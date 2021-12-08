package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.event.Events;
import co.nvqa.commons.model.dp.DpDetailsResponse;
import co.nvqa.commons.model.dp.dp_database_checking.DatabaseCheckingNinjaCollectConfirmed;
import co.nvqa.commons.model.dp.dp_database_checking.DatabaseCheckingNinjaCollectDriverDropOffConfirmedStatus;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.DpTagging;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonFilePicker;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class DpTaggingPage extends OperatorV2SimplePage {

  public DpTaggingTable dpTaggingTable;

  private static final String LOCATOR_DROP_OFF_DATE = "//td[contains(@class,'drop-off-date column-locked-right')]/md-input-container";
  private static final String LOCATOR_DROP_OFF_MENU = "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[contains(@value,'') or contains(./div/text(),'')]";

  @FindBy(name = "container.dp-tagging.assign-all")
  public NvApiTextButton assignAll;

  @FindBy(name = "container.dp-tagging.untag-all")
  public NvApiTextButton untagAll;

  @FindBy(css = "nv-button-file-picker[label='Select File']")
  public NvButtonFilePicker selectFile;

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
    waitUntilInvisibilityOfToast("File successfully uploaded");
  }

  public void uploadInvalidDpTaggingCsv() {
    File dpTaggingCsv = buildInvalidCsv();
    selectFile.setValue(dpTaggingCsv);
  }

  public void verifyDpTaggingCsvIsUploadedSuccessfully(List<DpTagging> listOfDpTagging) {
    List<String> actualTracingIds = dpTaggingTable.readAllEntities().stream()
        .map(DpTagging::getTrackingId)
        .collect(Collectors.toList());

    for (DpTagging dpTagging : listOfDpTagging) {
      assertThat("Tracking ID is not listed on table.", dpTagging.getTrackingId(),
          isIn(actualTracingIds));
    }
  }

  public void verifyInvalidDpTaggingCsvIsNotUploadedSuccessfully() {
    String expectedErrorMessageOnToast = "No order data to process, please check the file";
    String actualMessage = getText(
        "//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div");
    assertEquals("Error Message", expectedErrorMessageOnToast, actualMessage);
    waitUntilInvisibilityOfToast(expectedErrorMessageOnToast, false);
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
    dpTaggingTable.selectAllShown();
    assignAll.click();

    if (isMultipleOrders) {
      waitUntilInvisibilityOfToast("DP tagging performed successfully");
    } else {
      waitUntilInvisibilityOfToast("tagged successfully");
    }
  }

  public void untagAll() {
    dpTaggingTable.selectAllShown();
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
        "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[contains(@value,'%s') or contains(./div/text(),'%s')]",
        nextDay, nextDay);
  }

  public void selectMultiDateToNextDay(int size) {
    String nextDay = dropOffDate();
    click(LOCATOR_DROP_OFF_DATE);

    for (int i = 1; i <= size; i++) {
      click("//tr[" + i + "]" + LOCATOR_DROP_OFF_DATE);
      clickf(
          "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[contains(@value,'%s') or contains(./div/text(),'%s')]",
          nextDay, nextDay);
    }
  }

  private String dropOffDate() {
    clickAndWaitUntilDone("//tr[1]" + LOCATOR_DROP_OFF_DATE);
    waitUntilVisibilityOfElementLocated(LOCATOR_DROP_OFF_MENU);
    List<String> listOfDropOffDates = findElementsBy(By.xpath(LOCATOR_DROP_OFF_MENU)).stream()
        .map(WebElement::getText).collect(Collectors.toList());

    String nextDay = listOfDropOffDates.get(listOfDropOffDates.size() - 1);
    return nextDay;
  }

  public void verifiesDetailsRightConfirmedOptTag(DatabaseCheckingNinjaCollectConfirmed result,
      DpDetailsResponse dpDetails, Events orderEvent, String barcode) {
    LocalDateTime today = LocalDateTime.now();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH);

    assertEquals("Barcode is not the same : ", result.getBarcode(), barcode);
    assertEquals("DP ID is not the same : ", result.getDpId(), dpDetails.getId());
    assertEquals("Status is not the same : ", result.getStatus(), "CONFIRMED");
    assertEquals("Source is not the same : ", result.getSource(), "OPERATOR");
    assertEquals("Drop Off On is not the same : ", result.getDropOffOn().toString(),
        formatter.format(today));
    assertEquals("Start Date is not the same : ", result.getStartDate().toString(),
        formatter.format(today));
    assertEquals("Collect Start Date is not the same : ", result.getCollectStartDate().toString(),
        formatter.format(today.plusDays(1)));
    assertEquals("DP Reservation Event Name is not the same : ", result.getName(),
        "OPERATOR_CONFIRMED");
    assertTrue("Order Event - ASSIGNED_TO_DP - is published: ",
        isOrderEventPublished(orderEvent, "ASSIGNED_TO_DP"));
    assertEquals("DP Reservation SMS Notification is not the same : ",
        result.getSmsNotificationStatus(), "NA");
    assertEquals("DP Reservation Email Notification is not the same : ",
        result.getEmailNotificationStatus(), "NA");
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

    assertEquals("Barcode is not the same : ", result.getBarcode(), barcode);
    assertEquals("Received From is not the same : ", result.getReceivedFrom(), "DRIVER");
    assertEquals("DP Reservation Status is not the same : ", result.getDpReservationStatus(),
        "CONFIRMED");
    assertTrue("Received At is not the same : ",
        result.getReceivedAt().toString().contains(formatter.format(today)));
    assertEquals("DP Reservation Event Name is not the same : ",
        result.getDpReservationEventName(), "DRIVER_DROPPED_OFF");
    assertEquals("DP Job Order Status is not the same : ", result.getDpJobOrderStatus(), "SUCCESS");
  }
}