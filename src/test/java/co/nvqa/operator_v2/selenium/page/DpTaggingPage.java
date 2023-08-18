package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.event.Events;
import co.nvqa.commons.model.dp.DpDetailsResponse;
import co.nvqa.commons.model.dp.dp_database_checking.DatabaseCheckingNinjaCollectConfirmed;
import co.nvqa.commons.model.dp.dp_database_checking.DatabaseCheckingNinjaCollectDriverDropOffConfirmedStatus;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.DpTagging;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.FileInput;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class DpTaggingPage extends SimpleReactPage<DpTaggingPage> {

  public DpTaggingTable dpTaggingTable;

  private static final String LOCATOR_TRACKING_ID = "//div[@class='BaseTable__body']//div[@data-datakey='trackingId']//*[text()='%s']";
  private static final String LOCATOR_DROP_OFF_DATE = "//div[@data-datakey='postcode']//input";

  private static final String DROP_OFF_DATE = "//div[@data-testid='dropdown_date']//span[@class='ant-select-selection-item']";

  private static final String LOCATOR_DATA_ROWS = "//div[@data-row-index='%s']";

  private static final String LOCATOR_ROW_CHECKBOX = "//div[@data-row-index='%s']//input[@data-testid='checkbox_assign_order']";

  private static final String LOCATOR_DROP_OFF_MENU = "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[contains(@value,'') or contains(./div/text(),'')]";

  @FindBy(css = "[data-testid='button_download_sample_csv']")
  public Button downloadSampleCsv;
  @FindBy(xpath = "//iframe[contains(@src,'dp-tagging')]")
  private PageElement pageFrame;

  @FindBy(css = ".ant-spin-dot")
  public PageElement spinner;
  @FindBy(xpath = "//button[@data-testid='assign_all']")
  public AntButton assignAll;

  @FindBy(xpath = "//button[@data-testid='button_untag_all']")
  public Button untagAll;

  @FindBy(xpath = "//div[contains(@class,'ant-upload-select')]//input")
  public FileInput selectFile;

  @FindBy(xpath = LOCATOR_DROP_OFF_DATE)
  public MdSelect selectDate;

  public DpTaggingPage(WebDriver webDriver) {
    super(webDriver);
    dpTaggingTable = new DpTaggingTable(webDriver);
  }

  public void uploadDpTaggingCsv(List<DpTagging> listOfDpTagging) {
    pause2s();
    File dpTaggingCsv = buildCsv(listOfDpTagging);
    selectFile.setValue(dpTaggingCsv);
    verifyTaggingToast("File successfully uploaded");
  }

  public void verifyTaggingToast(String message) {
    AntNotification notification = noticeNotifications.get(0);
    notification.waitUntilVisible();
    String actualNotificationMessage = notification.getText();
    Assertions.assertThat(actualNotificationMessage)
        .as("Notification message is the same")
        .isEqualTo(message);
  }

  public void switchToIframe() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void uploadInvalidDpTaggingCsv() {
    File dpTaggingCsv = buildInvalidCsv();
    selectFile.setValue(dpTaggingCsv);
  }

  public void waitUntilLoaded() {
    if (spinner.waitUntilVisible(10)) {
      spinner.waitUntilInvisible();
    }
  }

  public void verifyDpTaggingCsvIsUploadedSuccessfully(List<DpTagging> listOfDpTagging) {
    for (DpTagging dpTagging : listOfDpTagging) {
      String xpath = f(LOCATOR_TRACKING_ID, dpTagging.getTrackingId());
      Assertions.assertThat(isElementExist(xpath))
          .as("Tracking ID is not listed on table")
          .isTrue();
    }
  }

  public void verifyInvalidDpTaggingCsvIsNotUploadedSuccessfully() {
    String expectedErrorMessageOnToast = "No order data to process, please check the file";
    verifyTaggingToast(expectedErrorMessageOnToast);
  }

  private File buildCsv(List<DpTagging> listOfDpTagging) {
    StringBuilder contentAsSb = new StringBuilder();

    for (DpTagging dpTagging : listOfDpTagging) {
      contentAsSb.append(dpTagging.getTrackingId()).append(',').append(dpTagging.getDpId())
          .append(System.lineSeparator());
    }

    return buildCsv(contentAsSb.toString());
  }

  private File buildInvalidCsv() {
    return buildCsv("INVALID_TRACKING_ID,1001" + System.lineSeparator());
  }

  private File buildCsv(String content) {
    try {
      File file = TestUtils
          .createFileOnTempFolder(String.format("dp-tagging_%s.csv", generateDateUniqueString()));

      PrintWriter pw = new PrintWriter(new FileOutputStream(file));
      pw.write(content);
      pw.close();

      return file;
    } catch (IOException ex) {
      throw new NvTestRuntimeException(ex);
    }
  }

  public void checkAndAssignAll(boolean isMultipleOrders) {
    int row = 0;
    while (isElementExist(f(LOCATOR_DATA_ROWS, row))) {
      clickf(LOCATOR_ROW_CHECKBOX, row);
      row++;
    }
    assignAll.clickAndWaitUntilDone(60);
    pause1s();
    if (isMultipleOrders) {
      verifyTaggingToast("DP tagging performed successfully");
    } else {
      verifyTaggingToast(row + " order(s) tagged successfully");
    }
  }

  public void untagAll() {
    int row = 0;
    while (isElementExist(f(LOCATOR_DATA_ROWS, row))) {
      clickf(LOCATOR_ROW_CHECKBOX, row);
      row++;
    }
    untagAll.click();
  }

  /**
   * Accessor for DP Tagging Tickets table
   */
  public static class DpTaggingTable extends MdVirtualRepeatTable<DpTagging> {

    public static final String COLUMN_TRACKING_ID = "trackingId";

    public DpTaggingTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_TRACKING_ID, "tracking-id")
          .build()
      );
      setEntityClass(DpTagging.class);
      setMdVirtualRepeat("order in getTableData()");
    }
  }

  public void selectDateToNextDay() {
    String nextDay = dropOffDate();
    clickf(
        "//div[@class='ant-select-item-option-content']/span[@title='%s']",
        nextDay);
  }

  public void selectMultiDateToNextDay(int size) {
    String nextDay = dropOffDate();
    int tableRowId = 1;
    for (int i = 0; i <= size - 1; i++) {
      click("//div[@data-row-index='" + i + "']" + LOCATOR_DROP_OFF_DATE);
      clickf("//div[@id='rc_select_" + tableRowId + "_list']/div[@aria-label='%s']", nextDay);
      tableRowId = tableRowId + 2;
    }
  }

  private String dropOffDate() {
    clickAndWaitUntilDone("//div[@data-row-index='0']" + LOCATOR_DROP_OFF_DATE);
    String date = getWebDriver().findElement(By.xpath(DROP_OFF_DATE)).getText();
    LocalDate localDate = LocalDate.parse(date);
    return localDate.plusDays(1).toString();
  }

  public void verifiesDetailsRightConfirmedOptTag(DatabaseCheckingNinjaCollectConfirmed result,
      DpDetailsResponse dpDetails, Events orderEvent, String barcode) {
    LocalDateTime today = LocalDateTime.now();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH);

    Assertions.assertThat(barcode).as("Barcode is not the same : ").isEqualTo(result.getBarcode());
    Assertions.assertThat(dpDetails.getId()).as("DP ID is not the same : ")
        .isEqualTo(result.getDpId());
    Assertions.assertThat("CONFIRMED").as("Status is not the same : ")
        .isEqualTo(result.getStatus());
    Assertions.assertThat("OPERATOR").as("Source is not the same : ").isEqualTo(result.getSource());
    Assertions.assertThat(formatter.format(today)).as("Drop Off On is not the same : ")
        .isEqualTo(result.getDropOffOn().toString());
    Assertions.assertThat(formatter.format(today)).as("Start Date is not the same : ")
        .isEqualTo(result.getStartDate().toString());
    Assertions.assertThat(formatter.format(today.plusDays(1)))
        .as("Collect Start Date is not the same : ")
        .isEqualTo(result.getCollectStartDate().toString());
    Assertions.assertThat("OPERATOR_CONFIRMED").as("DP Reservation Event Name is not the same : ")
        .isEqualTo(result.getName());
    Assertions.assertThat(isOrderEventPublished(orderEvent, "ASSIGNED_TO_DP"))
        .as("Order Event - ASSIGNED_TO_DP - is published: ").isTrue();
    Assertions.assertThat("NA").as("DP Reservation SMS Notification is not the same : ")
        .isEqualTo(result.getSmsNotificationStatus());
    Assertions.assertThat("NA").as("DP Reservation Email Notification is not the same : ")
        .isEqualTo(result.getEmailNotificationStatus());
  }

  public boolean isOrderEventPublished(Events orderEvent, String expectedOrderEvent) {
    boolean isOrderEventPublished = false;
    for (int i = 0; i < orderEvent.getData().size(); i++) {
      if (orderEvent.getData().get(i).getType().equalsIgnoreCase(expectedOrderEvent)) {
        isOrderEventPublished = true;
        break;
      }
    }
    return isOrderEventPublished;
  }

  public void verifiesDetailsForDriverDropOffConfirmedStatus(
      DatabaseCheckingNinjaCollectDriverDropOffConfirmedStatus result, String barcode) {
    LocalDateTime today = LocalDateTime.now();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH);

    Assertions.assertThat(barcode).as("Barcode is not the same : ").isEqualTo(result.getBarcode());
    Assertions.assertThat("DRIVER").as("Received From is not the same : ")
        .isEqualTo(result.getReceivedFrom());
    Assertions.assertThat("CONFIRMED").as("DP Reservation Status is not the same : ")
        .isEqualTo(result.getDpReservationStatus());
    Assertions.assertThat(result.getReceivedAt().toString().contains(formatter.format(today)))
        .as("Received At is not the same : ").isTrue();
    Assertions.assertThat("SUCCESS").as("DP Job Order Status is not the same : ")
        .isEqualTo(result.getDpJobOrderStatus());
  }
}