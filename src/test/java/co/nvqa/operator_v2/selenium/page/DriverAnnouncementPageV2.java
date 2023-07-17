package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.support.RandomUtil;
import co.nvqa.operator_v2.model.DriverAnnouncement;
import com.google.common.collect.ImmutableMap;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import lombok.Getter;
import lombok.Setter;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

@Getter
@Setter
public class DriverAnnouncementPageV2 extends SimpleReactPage {

  public DriverAnnouncementTable driverAnnouncementTable;

  private final String announcementSubjectXpath = "//div[@class='ant-drawer-body']/span[contains(@class,'ant-typography')]";
  private final String announcementDrawerCloseXpath = "//div[contains(@class,'ant-drawer-header')]/button[@class='ant-drawer-close']";
  private final String searchInputXpath = "//input[@data-testid='search-bar']";
  private final String uploadedCsvFileBtnXpath = "//div[contains(@class,'ant-space')][*[2][a] or *[1][svg]]";
  private final String btnNewAnnouncementXpath = "//button[contains(@class,'ant-btn')][span[text() = 'New announcement']]";
  private final String newAnnouncementPopupXpath = "//div[@class='ant-modal-content']";
  private final String selectRecipientTypeXpath = "//div[@class='ant-select-selector'][span[@class='ant-select-selection-placeholder' and text() = 'Recipient type']]";
  private final String subjectFieldXpath = "//input[@name='subject' and contains(@class,'ant-input')]";
  private final String btnMarkAsImportantXpath = "//button[contains(@class,'ant-btn')][span[text() = 'Mark as important']]";
  private final String btnSendNewAnnouncement = "//button[contains(@class,'ant-btn')][span[text()='Send']]";
  private final String announcementEditorXpath = "//div[contains(@class,'ql-editor')]";
  private final String btnNewPayrollReportXpath = "//button[span[text()='New payroll report']]";
  private final String btnSubmitPayrollReportXpath = "//button[span[text()='Submit']]";
  private final String uploadErrorXpath = "//h3[text()='Upload Error']";
  private final String inputPayrollReport = "//input[@id='bulk-update-driver-csv']";
  private final String notificationXpath = "//div[contains(@class,'ant-notification-notice-message') and text()='Announcement sent']";

  public DriverAnnouncementPageV2(WebDriver webDriver) {
    super(webDriver);
    driverAnnouncementTable = new DriverAnnouncementTable(webDriver);
  }

  public void sendKeysInEditor(String style, String message) {
    String styleXpath = f("//button[@class='ql-%s']", style.toLowerCase());
    WebElement editor = findElementBy(By.xpath(announcementEditorXpath));
    WebElement btnStyle = findElementBy(By.xpath(styleXpath));
    btnStyle.click();
    editor.sendKeys(message);
    btnStyle.click();
  }

  public void sendKeysInEditor(String message) {
    WebElement editor = findElementBy(By.xpath(announcementEditorXpath));
    editor.sendKeys(message);
  }

  public WebElement getTableRowElement(int rowNumber) {
    final String tableRowXpath = f("//tr[@data-row-key and contains(@class,'ant-table-row')][%s]",
        rowNumber);
    return findElementBy(By.xpath(tableRowXpath));
  }

  public WebElement getRecipientTypeOptionElement(String recipientType) {
    pause5s();
    recipientType =
        recipientType.substring(0, 1).toUpperCase() + recipientType.substring(1).toLowerCase();
    return findElementBy(By.xpath(
        f("//div[@class='ant-select-item-option-content' and contains(text(), '%s')]",
            recipientType)));
  }

  public WebElement getRecipientOptionElement(String recipient) {
    pause5s();
    return findElementBy(
        By.xpath(f("//div[contains(@class,'ant-select-item-option') and @label='%s']", recipient)));
  }

  public void verifyRowOnDriverAnnouncementPage(int rowNumber) {
    driverAnnouncementTable.waitUntilTableLoaded();
    getTableRowElement(rowNumber).click();

    Map<String, String> rowData = this.driverAnnouncementTable.readRow(rowNumber);

    waitUntilVisibilityOfElementLocated(By.xpath(announcementSubjectXpath));
    boolean isSubjectMatch = getText(announcementSubjectXpath)
        .equalsIgnoreCase(rowData.get("subject"));
    Assertions.assertThat(isSubjectMatch)
        .as(f("[Actual: %s\nExpected: %s]", getText(announcementSubjectXpath),
            rowData.get("subject")))
        .isTrue();
  }

  public void closeAnnouncementDrawer() {
    WebElement closeButton = findElementBy(By.xpath(announcementDrawerCloseXpath));
    waitUntilVisibilityOfElementLocated(By.xpath(announcementDrawerCloseXpath));
    closeButton.click();
  }

  public void searchDriverAnnouncement(String keyword) {
    doWithRetry(() -> {
          driverAnnouncementTable.waitUntilTableLoaded();
          waitUntilVisibilityOfElementLocated(searchInputXpath);
          click(searchInputXpath);
          sendKeys(searchInputXpath, keyword);
          Assertions.assertThat(getValue(searchInputXpath))
              .isEqualToIgnoringCase(keyword)
              .as("Search input isn't match with keyword");
        }, "Search driver announcement", DEFAULT_DELAY_ON_RETRY_IN_MILLISECONDS,
        DEFAULT_MAX_RETRY_ON_EXCEPTION);
  }

  public void verifyAnnouncementContains(String category, String keyword) {
    boolean isContains;
    waitUntilVisibilityOfElementLocated(By.xpath(announcementDrawerCloseXpath));
    pause5s();
    switch (category.toLowerCase()) {
      case "title":
        isContains = getText(announcementSubjectXpath).toLowerCase()
            .contains(keyword.toLowerCase());
        break;
      case "body":
        isContains = isElementExist(f("//td/*[contains(text(),'%s')]", keyword.toLowerCase()));
        break;
      default:
        isContains = false;
    }
    Assertions.assertThat(isContains).as(f("%s isn't contains %s", category, keyword))
        .isTrue();
  }

  public void verifyUploadedCsvFileAppear() {
    waitUntilVisibilityOfElementLocated(uploadedCsvFileBtnXpath);
    Assertions.assertThat(isElementVisible(uploadedCsvFileBtnXpath))
        .as("Uploaded report CSV button not appear in Announcement Drawer")
        .isTrue();
  }

  public void openAnnouncementModal() {
    doWithRetry(() -> {
      driverAnnouncementTable.waitUntilTableLoaded();
      waitUntilVisibilityOfElementLocated(btnNewAnnouncementXpath);
      click(btnNewAnnouncementXpath);
      waitUntilVisibilityOfElementLocated(newAnnouncementPopupXpath);
      Assertions.assertThat(isElementVisible(newAnnouncementPopupXpath))
          .as("New Announcement Popup isn't appear")
          .isTrue();
    }, "Open announcement popup");
  }

  public List<String> createMultipleNormalAnnouncement(Map<String, Object> data, int amount) {
    List<String> createdAnnouncementSubjects = new ArrayList<String>();

    openAnnouncementModal();
    for (int i = 0; i < amount; i++) {
      if (data.get("recipientType") != null) {
        click(selectRecipientTypeXpath);
        getRecipientTypeOptionElement(data.get("recipientType").toString()).click();
      }
      if (data.get("recipient") != null) {
        final String inputXpath = "//span[@class='ant-select-selection-search']/input[@class='ant-select-selection-search-input']";
        List<WebElement> inputEl = findElementsBy(By.xpath(inputXpath));
        inputEl.get(inputEl.size() - 1).sendKeys(
            data.get("recipient").toString());
        getRecipientOptionElement(data.get("recipient").toString()).click();
      }
      if (data.get("subject") != null) {
        final String subject = ((String) data.get("subject"))
            .replaceAll("RANDOM_SUBJECT", f("Announcement %s", RandomUtil.randomString(
                10)));
        createdAnnouncementSubjects.add(subject);
        findElementBy(By.xpath(subjectFieldXpath)).sendKeys(subject);
      }
      if ((data.get("isImportant") != null) && Boolean.parseBoolean(
          data.get("isImportant").toString())) {
        findElementBy(By.xpath(btnMarkAsImportantXpath)).click();
      }
      if (data.get("body") != null) {
        final String body = ((String) data.get("body"))
            .replaceAll("RANDOM_BODY",
                f("Auto generate announcement body: %s", RandomUtil.randomString(
                    12)));
        sendKeysInEditor(body);
      }
      if (data.get("bold") != null) {
        sendKeysInEditor("bold", data.get("bold").toString());
      }
      if (data.get("italic") != null) {
        sendKeysInEditor("italic", data.get("italic").toString());
      }
      if (data.get("underline") != null) {
        sendKeysInEditor("underline", data.get("underline").toString());
      }
      if (data.get("link") != null) {
        sendKeysInEditor(data.get("link").toString());
        for (char c : data.get("link").toString().toCharArray()) {
          findElementBy(By.xpath(announcementEditorXpath)).sendKeys(Keys.SHIFT, Keys.ARROW_LEFT);
        }
        String btnLinkXpath = "//button[@class='ql-link']";
        String btnSaveLinkXpath = "//a[@class='ql-action']";
        findElementBy(By.xpath(btnLinkXpath)).click();
        waitUntilVisibilityOfElementLocated(btnSaveLinkXpath);
        findElementBy(By.xpath(btnSaveLinkXpath)).click();
        findElementBy(By.xpath(announcementEditorXpath)).click();
      }
      if (data.get("html") != null) {
        final String html = ((String) data.get("html")).replaceAll("RANDOM_HTML",
            f("<h1>Auto generate HTML: %s</h1>", RandomUtil.randomString(12)));
        String htmlTextAreaXpath = "//div[@class='ant-modal-body']/textarea";
        String btnHtmlSave = "//button[contains(@class,'ant-btn')][span[text()='Save']]";
        String btnHtmlXpath = "//button[contains(@class,'ql-html')]";
        click(btnHtmlXpath);
        List<WebElement> popupEls = findElementsBy(By.xpath(newAnnouncementPopupXpath));
        waitUntilVisibilityOfElementLocated(popupEls.get(popupEls.size() - 1));
        findElementBy(By.xpath(htmlTextAreaXpath)).sendKeys(html);
        waitUntilElementIsClickable(btnHtmlSave);
        click(btnHtmlSave);
      }
      if (isElementVisible(btnSendNewAnnouncement)) {
        click(btnSendNewAnnouncement);
      }
    }

    return createdAnnouncementSubjects;
  }

  public void verifyAnnouncementSent() {
    waitUntilVisibilityOfElementLocated(notificationXpath);
    Assertions.assertThat(isElementVisible(notificationXpath))
        .as("Notification isn't displayed")
        .isTrue();
  }

  public String operatorSendPayrollReport(File csvFile, Map<String, String> data) {
    String payrollSubject = null;

    driverAnnouncementTable.waitUntilTableLoaded();
    while (!isElementExist(inputPayrollReport)) {
      findElementBy(By.xpath(btnNewPayrollReportXpath)).click();
    }
    pause5s();
    findElementBy(By.xpath(inputPayrollReport)).sendKeys(csvFile.getAbsolutePath());
    if (!isElementExist(uploadErrorXpath)) {
      waitUntilVisibilityOfElementLocated(btnSubmitPayrollReportXpath);
      click(btnSubmitPayrollReportXpath);
    }
    pause5s();
    if (data.get("subject") != null) {
      payrollSubject = data.get("subject").replaceAll("RANDOM_SUBJECT",
          f("Payroll %s", RandomUtil.randomString(10)));
      findElementBy(By.xpath(subjectFieldXpath)).sendKeys(payrollSubject);
    }
    if ((data.get("isImportant") != null) && Boolean.parseBoolean(
        data.get("isImportant"))) {
      findElementBy(By.xpath(btnMarkAsImportantXpath)).click();
    }
    if (data.get("body") != null) {
      final String body = data.get("body")
          .replaceAll("RANDOM_BODY", f("Auto generate payroll body: %s",
              RandomUtil.randomString(12)));
      sendKeysInEditor(body);
    }
    if (data.get("html") != null) {
      final String html = data.get("html").replaceAll("RANDOM_HTML",
          f("<h1>Auto generate HTML: %s</h1>", RandomUtil.randomString(12)));
      String htmlTextAreaXpath = "//div[@class='ant-modal-body']/textarea";
      String btnHtmlSave = "//button[contains(@class,'ant-btn')][span[text()='Save']]";
      String btnHtmlXpath = "//button[contains(@class,'ql-html')]";
      click(btnHtmlXpath);
      List<WebElement> popupEls = findElementsBy(By.xpath(newAnnouncementPopupXpath));
      waitUntilVisibilityOfElementLocated(popupEls.get(popupEls.size() - 1));
      findElementBy(By.xpath(htmlTextAreaXpath)).sendKeys(html);
      waitUntilElementIsClickable(btnHtmlSave);
      click(btnHtmlSave);
    }
    if (isElementVisible(btnSendNewAnnouncement)) {
      click(btnSendNewAnnouncement);
    }

    return payrollSubject;
  }

  public void verifyFailedUploadPayrollReport() {
    waitUntilVisibilityOfElementLocated(uploadErrorXpath);
    Assertions.assertThat(isElementVisible(uploadErrorXpath))
        .as("Upload error message not found")
        .isTrue();
  }

  public static class DriverAnnouncementTable extends AntTableV3<DriverAnnouncement> {

    public static final String COLUMN_SUBJECT = "subject";
    public static final String COLUMN_MESSAGE = "message";
    public static final String COLUMN_RECIPIENTS = "sentCount";
    public static final String COLUMN_READ_BY = "readCount";
    public static final String COLUMN_SENT_DATE_TIME = "sentTime";

    public final String tableRowXpath = "//tbody[@class='ant-table-tbody']";

    public DriverAnnouncementTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_SUBJECT, "1")
          .put(COLUMN_MESSAGE, "2")
          .put(COLUMN_RECIPIENTS, "3")
          .put(COLUMN_READ_BY, "4")
          .put(COLUMN_SENT_DATE_TIME, "5")
          .build());
      setEntityClass(DriverAnnouncement.class);
    }

    public void waitUntilTableLoaded() {
      while (!isElementVisible(tableRowXpath)) {
        pause500ms();
      }
      pause5s();
    }
  }
}
