package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.commons.model.order_create.v4.OrderRequestV4;
import co.nvqa.commons.model.order_create.v4.Timeslot;
import co.nvqa.commons.support.JsonHelper;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;

import static co.nvqa.common.utils.StandardTestConstants.TEMP_DIR;
import static co.nvqa.common.utils.StandardTestUtils.convertToZonedDateTime;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings({"WeakerAccess", "unused"})
public class OrderCreationV4Page extends OperatorV2SimplePage {

  private static final Map<String, String> MAP_OF_ADDITIONAL_CONFIGURATIONS_XPATH = new HashMap<>();
  private static final String CSV_FILENAME_PATTERN = "sample-ocv4";
  private static final String XPATH_BATCH_ID = "//div/label[contains(text(),'Batch Id')]/following-sibling::p";

  static {
    MAP_OF_ADDITIONAL_CONFIGURATIONS_XPATH
        .put("Pickup Required", "//md-checkbox[@ng-model=\"ctrl.state.isPickupRequired\"]");
    MAP_OF_ADDITIONAL_CONFIGURATIONS_XPATH
        .put("Cash Enabled", "//md-checkbox[@ng-model=\"ctrl.state.isCashEnabled\"]");
    MAP_OF_ADDITIONAL_CONFIGURATIONS_XPATH
        .put("Stamp Shipper", "//md-checkbox[@ng-model=\"ctrl.state.isStampShipper\"]");
  }

  private OrdersTable ordersTable;
  private UploadSummaryTable uploadSummaryTable;

  public OrderCreationV4Page(WebDriver webDriver) {
    super(webDriver);
    ordersTable = new OrdersTable(webDriver);
    uploadSummaryTable = new UploadSummaryTable(webDriver);
  }

  public void uploadXlsx(OrderRequestV4 order, int shipperId) {
    File createOrderXlsx = buildCreateOrderXlsx(order, shipperId);
    uploadXlsx(createOrderXlsx);
  }

  public void uploadXlsx(File createOrderXlsx) {
    clickNvIconTextButtonByName("Create Order");
    waitUntilVisibilityOfMdDialogByTitle("Upload Order CSV");
    sendKeysByAriaLabel("Choose", createOrderXlsx.getAbsolutePath());
    clickNvButtonSaveByNameAndWaitUntilDone("Submit");
    waitUntilInvisibilityOfMdDialogByTitle("Upload Order CSV");
    waitUntilInvisibilityOfElementLocated("//div[@class='md-half-circle']");
  }

  public void verifyOrderIsCreatedSuccessfully(OrderRequestV4 order) {
    ordersTable.searchOrderByTrackingId(order.getRequestedTrackingNumber());
    String totalSuccess = uploadSummaryTable.getTotalSuccess();
    Assertions.assertThat(totalSuccess).as("Total Success").isEqualTo("1");
    String totalOrders = uploadSummaryTable.getTotalOrders();
    Assertions.assertThat(totalOrders).as("Total Orders").isEqualTo("1");

    int rowNumber = 1;
    Assertions.assertThat(ordersTable.getTrackingId(rowNumber)).as("Tracking ID")
        .endsWith(order.getRequestedTrackingNumber());
    Assertions.assertThat(ordersTable.getServiceLevel(rowNumber)).as("Service Level")
        .isEqualToIgnoringCase(order.getServiceLevel());
    Assertions.assertThat(ordersTable.getFromName(rowNumber)).as("From Name")
        .isEqualTo(order.getFrom().getName());
    Assertions.assertThat(ordersTable.getFromAddress(rowNumber)).as("From Address")
        .isEqualTo(buildAddress(order.getFrom().getAddress()));
    Assertions.assertThat(ordersTable.getToName(rowNumber)).as("To Name")
        .isEqualTo(order.getTo().getName());
    Assertions.assertThat(ordersTable.getToAddress(rowNumber)).as("To Address")
        .isEqualTo(buildAddress(order.getTo().getAddress()));
    //assertThat("Delivery Start Date", ordersTable.getDeliveryStartDate(rowNumber), equalTo(order.getParcelJob().getDeliveryStartDate())); // Need to add logic to calculate the expected delivery date.
    Assertions.assertThat(ordersTable.getDeliveryTimeslot(rowNumber)).as("Delivery Timeslot")
        .isEqualTo(buildTimeslot(order.getParcelJob().getDeliveryTimeslot()));
  }

  public void downloadSampleFile(Map<String, String> dataTableAsMap) throws ParseException {
    String shipperName = dataTableAsMap.get("shipperName");
    String orderType = dataTableAsMap.get("orderType");
    String additionalConfigurations = dataTableAsMap.get("additionalConfigurations");
    String serviceLevel = dataTableAsMap.get("serviceLevel");
    String deliveryDate = dataTableAsMap.get("deliveryDate");
    String deliveryTimeslot = dataTableAsMap.get("deliveryTimeslot");
    String cashAmount = dataTableAsMap.get("cashAmount");
    String cashCollectionTransaction = dataTableAsMap.get("cashCollectionTransaction");
    String cashCollectionType = dataTableAsMap.get("cashCollectionType");
    String pickupDate = dataTableAsMap.get("pickupDate");
    String pickupType = dataTableAsMap.get("pickupType");
    String pickupLevel = dataTableAsMap.get("pickupLevel");
    String pickupTimeslot = dataTableAsMap.get("pickupTimeslot");
    String reservationVolume = dataTableAsMap.get("reservationVolume");

    List<String> additionalConfigurationsAsList = new ArrayList<>();

    Optional.ofNullable(additionalConfigurations).ifPresent(it ->
    {
      String[] temp = additionalConfigurations.replaceAll(",\\s+", ",").split(",");
      additionalConfigurationsAsList.addAll(Arrays.asList(temp));
    });

    clickNvIconTextButtonByName("container.order.create.download-sample-file");

    // Step 1
    retryIfNvTestRuntimeExceptionOccurred(
        () -> selectValueFromNvAutocomplete("ctrl.shipperText", shipperName),
        "Select shipper from NvAutoComplete");

    clickf("//md-radio-button//span[contains(text(),'%s')]", orderType);
    additionalConfigurationsAsList.forEach(additionalConfiguration -> click(
        MAP_OF_ADDITIONAL_CONFIGURATIONS_XPATH.get(additionalConfiguration)));
    click("//div[@layout-align=\"end\"]//nv-icon-text-button[@name=\"commons.next\"]");

    // Step 2
    waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class,'ocv4-preset-sample')]");
    selectValueFromMdSelectByIdContains("container.order.create.dialog.service-level",
        serviceLevel);
    click("//div[@layout-align=\"space-between\"]//nv-icon-text-button[@name=\"commons.next\"]");

    // Step 3
    waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class,'ocv4-preset-sample')]");
    setMdDatepicker("ctrl.currentStep.date", convertToZonedDateTime(deliveryDate, DTF_NORMAL_DATE));
    selectValueFromMdSelectByIdContains("container.order.create.dialog.delivery-timeslot",
        deliveryTimeslot);
    click("//div[@class=\"layout-column\"]//nv-icon-text-button[@name=\"commons.next\"]");

    // step 4
    if (additionalConfigurationsAsList.contains("Pickup Required")) {
      waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class,'ocv4-preset-sample')]");
      setMdDatepicker("ctrl.currentStep.date",
          convertToZonedDateTime(deliveryDate, DTF_NORMAL_DATE));
      selectValueFromMdSelectByIdContains("container.order.create.dialog.pickup-type", pickupType);
      selectValueFromMdSelectByIdContains("Pickup Level", pickupLevel);
      selectValueFromMdSelectByIdContains("Pickup Timeslot", pickupTimeslot);
      selectValueFromMdSelectByIdContains("container.order.create.dialog.reservation-volume",
          reservationVolume);
    }

    // step 5
    waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class,'ocv4-preset-sample')]");

    if ("Marketplace".equals(orderType)) {
      click("//div[@class=\"layout-column\"]//nv-icon-text-button[@name=\"commons.next\"]");
      sendKeysById("Seller ID", "OPV2");
      sendKeysById("commons.company-name", "Ninja Van");
    }

    // step 6
    if (additionalConfigurationsAsList.contains("Cash Enabled")) {
      click("//div[@class=\"layout-column\"]//nv-icon-text-button[@name=\"commons.next\"]");
      waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class,'ocv4-preset-sample')]");
      sendKeys("//input[@name='commons.cash-amount']", cashAmount);
    }

    click("//div[@class='layout-column']//nv-icon-text-button[@name='commons.done']");
  }

  public void clickDownloadSampleFile() {
    clickNvApiTextButtonByNameAndWaitUntilDone("Download sample CSV file");
  }

  public void verifyFileDownloadedSuccessfully() {
    verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(CSV_FILENAME_PATTERN));
  }

  public void verifyDownloadedFile(Map<String, String> dataTableAsMap) throws IOException {
    Map<String, String> fileValues = new HashMap<>();
    fileValues.put("service_type", dataTableAsMap.get("orderType"));
    fileValues.put("service_level", dataTableAsMap.get("serviceLevel"));
    fileValues.put("parcel_job.delivery_start_date", dataTableAsMap.get("deliveryDate"));
    fileValues.put("cash_job.amount", dataTableAsMap.get("cashAmount"));
    fileValues.put("cash_job.transacted_at", dataTableAsMap.get("cashCollectionTransaction"));
    fileValues.put("cash_job.type", dataTableAsMap.get("cashCollectionType"));
    fileValues.put("parcel_job.pickup_date", dataTableAsMap.get("pickupDate"));
    fileValues.put("parcel_job.pickup_service_type", dataTableAsMap.get("pickupType"));
    fileValues.put("parcel_job.pickup_service_level", dataTableAsMap.get("pickupLevel"));
    fileValues.put("parcel_job.pickup_approximate_volume", dataTableAsMap.get("reservationVolume"));

    FileInputStream downloadedFile = new FileInputStream(
        TEMP_DIR + getLatestDownloadedFilename(CSV_FILENAME_PATTERN));
    XSSFWorkbook myWorkBook = new XSSFWorkbook(downloadedFile);
    XSSFSheet mySheet = myWorkBook.getSheetAt(0);

    String cellHeader;
    String cellValue;
    int rowNumber = 0;
    int cols = mySheet.getRow(rowNumber).getPhysicalNumberOfCells();

    for (int c = 0; c < cols; c++) {
      cellHeader = mySheet.getRow(0).getCell(c).getStringCellValue();
      if (fileValues.containsKey(cellHeader)) {
        cellValue = mySheet.getRow(1).getCell(c).getStringCellValue();
        assertEquals(fileValues.get(cellHeader).toLowerCase(), cellValue.toLowerCase());
      }
    }
  }

  private String buildAddress(Map<String, String> addressMap) {
    String fromAddress;

    switch (TestConstants.NV_SYSTEM_ID.toUpperCase()) {
      case "MBS":
      case "FEF":
      case "MMPG":
      case "TKL":
      case "HBL":
      case "MNT":
      case "DEMO":
      case "MSI": {
        fromAddress = addressMap.get("address1");
        fromAddress += " " + addressMap.getOrDefault("address2", "");
        fromAddress += " , " + addressMap.getOrDefault("city", "");
        fromAddress += " " + addressMap.getOrDefault("country", "");
        break;
      }
      default: {
        fromAddress = addressMap.get("address1");
        fromAddress += " " + addressMap.getOrDefault("address2", "");
        fromAddress += " " + addressMap.getOrDefault("country", "");
      }
    }

    return StringUtils.normalizeSpace(fromAddress.trim());
  }

  private String buildTimeslot(Timeslot timeslot) {
    return timeslot.getStartTime() + " - " + timeslot.getEndTime();
  }

  private static void addXlsxCell(XSSFRow row, int columnIndex, String value) {
    XSSFCell cell = row.createCell(columnIndex);
    cell.setCellValue(value);
  }

  private static void addXlsxPair(XSSFRow headerRow, XSSFRow valueRow, int columnIndex,
      String header, String value) {
    addXlsxCell(headerRow, columnIndex, header);
    addXlsxCell(valueRow, columnIndex, value);
  }

  private File buildCreateOrderXlsx(OrderRequestV4 order, int shipperId) {
    Map<String, Object> data = JsonHelper
        .fromJsonToFlatMap(JsonHelper.toJson(JsonHelper.getDefaultSnakeCaseMapper(), order));
    File excelFileName = TestUtils.createFileOnTempFolder(
        String.format("create-order-request_%s.xlsx", generateDateUniqueString()));
    data.put("shipper_id", shipperId);

    String sheetName = "Sheet 1";

    XSSFWorkbook wb = new XSSFWorkbook();
    XSSFSheet sheet = wb.createSheet(sheetName);
    XSSFRow headerRow = sheet.createRow(0);
    XSSFRow valueRow = sheet.createRow(1);

    int i = 0;

    for (Map.Entry<String, Object> entry : data.entrySet()) {
      String header = entry.getKey();
      Object value = entry.getValue();
      addXlsxPair(headerRow, valueRow, i, header, value.toString());
      i++;
    }

    try (FileOutputStream fileOut = new FileOutputStream(excelFileName)) {
      wb.write(fileOut);
      fileOut.flush();
    } catch (IOException ex) {
      throw new NvTestRuntimeException(ex);
    }

    return excelFileName;
  }

  public static class OrdersTable extends OperatorV2SimplePage {

    private static final String MD_VIRTUAL_REPEAT = "order in getTableData()";
    private static final String COLUMN_TRACKING_ID_CLASS = "tracking_number";
    private static final String COLUMN_SERVICE_LEVEL_CLASS = "service_level";
    private static final String COLUMN_FROM_NAME_CLASS = "from-name";
    private static final String COLUMN_FROM_ADDRESS_CLASS = "from_address";
    private static final String COLUMN_TO_NAME_CLASS = "to-name";
    private static final String COLUMN_TO_ADDRESS_CLASS = "to_address";
    private static final String COLUMN_DELIVERY_START_DATE_CLASS = "parcel_job-delivery_start_date";
    private static final String COLUMN_DELIVERY_TIMESLOT_CLASS = "delivery_timeslot_time";

    public OrdersTable(WebDriver webDriver) {
      super(webDriver);
    }

    public void searchOrderByTrackingId(String trackingId) {
      searchTableCustom1(COLUMN_TRACKING_ID_CLASS, trackingId);
    }

    public String getTrackingId(int rowNumber) {
      return getTextOnTable(rowNumber, COLUMN_TRACKING_ID_CLASS);
    }

    public String getServiceLevel(int rowNumber) {
      return getTextOnTable(rowNumber, COLUMN_SERVICE_LEVEL_CLASS);
    }

    public String getFromName(int rowNumber) {
      return getTextOnTable(rowNumber, COLUMN_FROM_NAME_CLASS);
    }

    public String getFromAddress(int rowNumber) {
      return getTextOnTable(rowNumber, COLUMN_FROM_ADDRESS_CLASS);
    }

    public String getToName(int rowNumber) {
      return getTextOnTable(rowNumber, COLUMN_TO_NAME_CLASS);
    }

    public String getToAddress(int rowNumber) {
      return getTextOnTable(rowNumber, COLUMN_TO_ADDRESS_CLASS);
    }

    public String getDeliveryStartDate(int rowNumber) {
      return getTextOnTable(rowNumber, COLUMN_DELIVERY_START_DATE_CLASS);
    }

    public String getDeliveryTimeslot(int rowNumber) {
      return getTextOnTable(rowNumber, COLUMN_DELIVERY_TIMESLOT_CLASS);
    }

    private String getTextOnTable(int rowNumber, String columnDataClass) {
      return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }
  }

  public static class UploadSummaryTable extends OperatorV2SimplePage {

    private static final String XPATH_TOTAL_ORDERS = "//div[label[.='Total Orders']]/p";
    private static final String XPATH_TOTAL_SUCCESS = "//div[label[.='Total Success']]/p";

    public UploadSummaryTable(WebDriver webDriver) {
      super(webDriver);
    }

    public String getTotalOrders() {
      return getText(XPATH_TOTAL_ORDERS);
    }

    public String getTotalSuccess() {
      return getText(XPATH_TOTAL_SUCCESS);
    }
  }

  public String getBatchId() {
    String batchId = getText(XPATH_BATCH_ID);
    return batchId;
  }
}
