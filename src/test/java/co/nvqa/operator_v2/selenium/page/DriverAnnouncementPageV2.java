package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.DriverAnnouncement;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import com.google.common.collect.ImmutableMap;

import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import lombok.Getter;
import lombok.Setter;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

@Getter
@Setter
public class DriverAnnouncementPageV2 extends SimpleReactPage {

    public DriverAnnouncementTable driverAnnouncementTable;

    private final String announcementSubjectXpath = "//div[@class='ant-drawer-body']/span[contains(@class,'ant-typography')]";
    private final String announcementMessageXpath = "//div[@class='ant-drawer-body']/p";
    private final String announcementDrawerCloseXpath = "//div[contains(@class,'ant-drawer-header')]/button[@class='ant-drawer-close']";
    private final String searchInputXpath = "//span[contains(@class,'ant-input')]/input[@placeholder='Search' and @data-testid='search-bar']";
    private final String uploadedCsvFileBtnXpath = "//div[contains(@class,'ant-space')][*[2][a] or *[1][svg]]";
    private final String btnNewAnnouncementXpath = "//button[contains(@class,'ant-btn')][span[text() = 'New announcement']]";
    private final String newAnnouncementPopupXpath = "//div[@class='ant-modal-content']";
    private final String selectRecepientTypeXpath = "//div[@class='ant-select-selector'][span[@class='ant-select-selection-placeholder' and text() = 'Recipient type']]";
    private final String subjectFieldXpath = "//input[@name='subject' and contains(@class,'ant-input')]";
    private final String btnMarkAsImportantXpath = "//button[contains(@class,'ant-btn')][span[text() = 'Mark as important']]";
    private final String btnSendNewAnnouncement = "//button[contains(@class,'ant-btn')][span[text()='Send']]";
    private final String announcementEditorXpath = "//div[contains(@class,'ql-editor')]";
    private final String btnNewPayrollReportXpath = "//button[span[text()='New payroll report']]";
    private final String btnSubmitPayrollReportXpath = "//button[span[text()='Submit']]";
    private final String uploadErrorXpath = "//h3[text()='Upload Error']";


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
        pause5s();
        boolean isMessageMatch = getText(announcementMessageXpath)
                .equalsIgnoreCase(rowData.get("message"));
        Assertions.assertThat(isMessageMatch)
                .as(f("[Actual: %s\nExpected: %s]", getText(announcementMessageXpath),
                        rowData.get("message")))
                .isTrue();
    }

    public void closeAnnouncementDrawer() {
        WebElement closeButton = findElementBy(By.xpath(announcementDrawerCloseXpath));
        waitUntilVisibilityOfElementLocated(By.xpath(announcementDrawerCloseXpath));
        closeButton.click();
    }

    public void searchDriverAnnouncement(String keyword) {
        driverAnnouncementTable.waitUntilTableLoaded();
        waitUntilVisibilityOfElementLocated(By.xpath(searchInputXpath));
        WebElement searchInput = findElementBy(By.xpath(searchInputXpath));
        searchInput.sendKeys(keyword);
        pause5s();
    }

    public void verifyAnnouncementContains(String category, String keyword) {
        boolean isContains;
        waitUntilVisibilityOfElementLocated(By.xpath(announcementDrawerCloseXpath));
        switch (category.toLowerCase()) {
            case "title":
                isContains = getText(announcementSubjectXpath).toLowerCase()
                        .contains(keyword.toLowerCase());
                break;
            case "body":
                isContains = getText(announcementMessageXpath).toLowerCase()
                        .contains(keyword.toLowerCase());
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

    public void createMultipleNormalAnnouncement(Map<String, Object> data, int amount) {
        Runnable openAnnouncementPopup = () -> {
            driverAnnouncementTable.waitUntilTableLoaded();
            waitUntilVisibilityOfElementLocated(btnNewAnnouncementXpath);
            click(btnNewAnnouncementXpath);
            waitUntilVisibilityOfElementLocated(newAnnouncementPopupXpath);
            Assertions.assertThat(isElementVisible(newAnnouncementPopupXpath))
                    .as("New Announcement Popup isn't appear")
                    .isTrue();
        };

        for (int i = 0; i < amount; i++) {
            doWithRetry(openAnnouncementPopup, "Open announcement popup", 1000, 3);
            if (data.get("recipientType") != null) {
                click(selectRecepientTypeXpath);
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
                findElementBy(By.xpath(subjectFieldXpath)).sendKeys(data.get("subject").toString());
            }
            if ((data.get("isImportant") != null) && Boolean.parseBoolean(
                    data.get("isImportant").toString())) {
                findElementBy(By.xpath(btnMarkAsImportantXpath)).click();
            }
            if (data.get("body") != null) {
                sendKeysInEditor(data.get("body").toString());
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
                String htmlTextAreaXpath = "//div[@class='ant-modal-body']/textarea";
                String btnHtmlSave = "//button[contains(@class,'ant-btn')][span[text()='Save']]";
                String btnHtmlXpath = "//button[contains(@class,'ql-html')]";
                click(btnHtmlXpath);
                List<WebElement> popupEls = findElementsBy(By.xpath(newAnnouncementPopupXpath));
                waitUntilVisibilityOfElementLocated(popupEls.get(popupEls.size() - 1));
                findElementBy(By.xpath(htmlTextAreaXpath)).sendKeys(data.get("html").toString());
                waitUntilElementIsClickable(btnHtmlSave);
                click(btnHtmlSave);
            }
            if (isElementVisible(btnSendNewAnnouncement)) {
                click(btnSendNewAnnouncement);
            }
        }
    }

    public void verifyAnnouncementSent() {
        String notificationXpath = "//div[contains(@class,'ant-notification-notice-message') and text()='Announcement sent']";
        waitUntilVisibilityOfElementLocated(notificationXpath);
        Assertions.assertThat(isElementVisible(notificationXpath))
                .as("Notification isn't displayed")
                .isTrue();
    }

    public void operatorSendPayrollReport(File csvFile, Map<String, String> data) {
        driverAnnouncementTable.waitUntilTableLoaded();
        click(btnNewPayrollReportXpath);
        pause5s();
        findElementBy(By.id("bulk-update-driver-csv")).sendKeys(csvFile.getAbsolutePath());
        if (!isElementExist(uploadErrorXpath)) {
            waitUntilVisibilityOfElementLocated(btnSubmitPayrollReportXpath);
            click(btnSubmitPayrollReportXpath);
        }
        pause5s();
        if (data.get("subject") != null) {
            findElementBy(By.xpath(subjectFieldXpath)).sendKeys(data.get("subject").toString());
        }
        if ((data.get("isImportant") != null) && Boolean.parseBoolean(
                data.get("isImportant").toString())) {
            findElementBy(By.xpath(btnMarkAsImportantXpath)).click();
        }
        if (data.get("body") != null) {
            sendKeysInEditor(data.get("body").toString());
        }
        if (data.get("html") != null) {
            String htmlTextAreaXpath = "//div[@class='ant-modal-body']/textarea";
            String btnHtmlSave = "//button[contains(@class,'ant-btn')][span[text()='Save']]";
            String btnHtmlXpath = "//button[contains(@class,'ql-html')]";
            click(btnHtmlXpath);
            List<WebElement> popupEls = findElementsBy(By.xpath(newAnnouncementPopupXpath));
            waitUntilVisibilityOfElementLocated(popupEls.get(popupEls.size() - 1));
            findElementBy(By.xpath(htmlTextAreaXpath)).sendKeys(data.get("html").toString());
            waitUntilElementIsClickable(btnHtmlSave);
            click(btnHtmlSave);
        }
        if (isElementVisible(btnSendNewAnnouncement)) {
            click(btnSendNewAnnouncement);
        }
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

        public final String tableRowXpath = "//tr[@data-row-key and contains(@class,'ant-table-row')]";

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
        }
    }
}
