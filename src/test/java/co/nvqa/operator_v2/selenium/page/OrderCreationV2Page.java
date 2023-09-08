package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.model.OrderCreationV2Template;
import co.nvqa.operator_v2.util.TestUtils;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings({"WeakerAccess", "unused"})
public class OrderCreationV2Page extends OperatorV2SimplePage {

  private static final String NG_REPEAT = "row in $data";
  private static final String CSV_FILENAME_PATTERN = "sample_csv";

  public static final String COLUMN_CLASS_DATA_STATUS = "status";
  public static final String COLUMN_CLASS_DATA_MESSAGE = "message";
  public static final String COLUMN_CLASS_DATA_TRACKING_ID = "tracking_id";
  public static final String COLUMN_CLASS_DATA_ORDER_REF_NO = "order_ref_no";

  public OrderCreationV2Page(WebDriver webDriver) {
    super(webDriver);
  }

  public void downloadSampleCsvFile() {
    clickNvApiTextButtonByNameAndWaitUntilDone("Download sample CSV file");
  }

  public void verifyCsvFileDownloadedSuccessfully() {
    verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(CSV_FILENAME_PATTERN));
  }

  public void uploadInvalidCsv() {
    uploadCsv(buildInvalidCsvFile());
  }

  public void uploadCsv(OrderCreationV2Template orderCreationV2Template) {
    File createOrderCsv = buildCreateOrderCsv(orderCreationV2Template);
    uploadCsv(createOrderCsv);
  }

  public void uploadCsv(File createOrderCsv) {
    clickNvIconTextButtonByName("Create Order");
    waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class,'file-select')]");
    sendKeysByAriaLabel("Choose", createOrderCsv.getAbsolutePath());
    clickNvButtonSaveByNameAndWaitUntilDone("Submit");
  }

  public void verifyOrderV2IsCreatedSuccessfully(OrderCreationV2Template orderCreationV2Template) {
    verifyOrderIsCreatedSuccessfully("-", false, null, "-");
  }

  public void verifyOrderV3IsCreatedSuccessfully(OrderCreationV2Template orderCreationV2Template) {
    verifyOrderIsCreatedSuccessfully("Order Creation Successful.", true,
        orderCreationV2Template.getOrderNo(), orderCreationV2Template.getShipperOrderNo());
  }

  private void verifyOrderIsCreatedSuccessfully(String expectedMessage, boolean validateTrackingId,
      String expectedTrackingIdEndsWith, String expectedOrderRefNo) {
    String status = getTextOnTable(1, COLUMN_CLASS_DATA_STATUS);
    String message = getTextOnTable(1, COLUMN_CLASS_DATA_MESSAGE);
    String trackingId = getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID);
    String orderRefNo = getTextOnTable(1, COLUMN_CLASS_DATA_ORDER_REF_NO);

    Assertions.assertThat(status).as("Status").isEqualTo("SUCCESS");
    Assertions.assertThat(message).as("Message").isEqualTo(expectedMessage);

    if (validateTrackingId) {
      Assertions.assertThat(trackingId).as("Check tracking id")
          .endsWith(expectedTrackingIdEndsWith);
    }

    Assertions.assertThat(orderRefNo).as("Order Ref No").isEqualTo(expectedOrderRefNo);
  }

  public void verifyOrderIsNotCreated() {
    String status = getTextOnTable(1, COLUMN_CLASS_DATA_STATUS);
    String message = getTextOnTable(1, COLUMN_CLASS_DATA_MESSAGE);
    String trackingId = getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID);

    Assertions.assertThat(status).as("Status").isEqualTo("FAIL");
    Assertions.assertThat(message).as("Check message").startsWith("Invalid requested tracking ID");
    Assertions.assertThat(trackingId).as("Check tracking id").isEmpty();
  }

  private String normalize(Object value) {
    return value == null ? "" : String.valueOf(value);
  }

  private File buildInvalidCsvFile() {
    try {
      File file = TestUtils.createFileOnTempFolder(
          String.format("invalid-create-order-request_%s.csv", generateDateUniqueString()));

      PrintWriter pw = new PrintWriter(new FileOutputStream(file));
      pw.write(
          "\"SHIPPER ID\",\"ORDER NO\",\"SHIPPER ORDER NO\",\"ORDER TYPE\",\"TO FIRST NAME*\",\"TO LAST NAME\",\"TO CONTACT*\",\"TO EMAIL\",\"TO ADDRESS 1*\",\"TO ADDRESS 2\",\"TO POSTCODE\",\"TO DISTRICT\",\"TO CITY\",\"TO STATE/PROVINCE\",\"TO COUNTRY\",\"PARCEL SIZE\",\"WEIGHT\",\"LENGTH\",\"WIDTH\",\"HEIGHT\",\"DELIVERY DATE\",\"DELIVERY TIMEWINDOW ID\",\"MAX DELIVERY DAYS\",\"PICKUP DATE\",\"PICKUP TIMEWINDOW ID\",\"PICKUP WEEKEND\",\"DELIVERY WEEKEND\",\"PICKUP INSTRUCTION\",\"DELIVERY INSTRUCTION\",\"COD VALUE\",\"INSURED VALUE\",\"FROM FIRST NAME*\",\"FROM LAST NAME\",\"FROM CONTACT*\",\"FROM EMAIL\",\"FROM ADDRESS 1*\",\"FROM ADDRESS 2\",\"FROM POSTCODE\",\"FROM DISTRICT\",\"FROM CITY\",\"FROM STATE/PROVINCE\",\"FROM COUNTRY\",\"MULTI PARCEL REF NO\"\n");
      pw.write(
          "3275,514451250N,\"SORN-514451250N\",\"Normal\",\"C-N-514451250 Customer\",\"\",\"6598980003\",\"customer.normal.514451250@ninjavan.co\",\"15 JALAN KILANG\",\"\",\"159415\",\"\",\"SG\",\"\",\"SG\",1,2,3,5,7,\"2017-12-28\",1,3,\"2017-12-28\",1,\"TRUE\",\"TRUE\",\"This order's pickup instruction is created by automation test. Ignore this order. Created at Thu, 28 Dec 2017 16:54:05 +0800 by scenario 'Operator create order on Order Creation V2'.\",\"This order's delivery instruction is created by automation test. Ignore this order. Created at Thu, 28 Dec 2017 16:54:05 +0800 by scenario 'Operator create order on Order Creation V2'.\",0.0,0.0,\"S-N-514451250 Shipper\",\"\",\"6598980005\",\"shipper.normal.514451250@test.com\",\"501 ORCHARD ROAD\",\"WHEELOCK PLACE\",\"238880\",\"\",\"SG\",\"\",\"SG\",\"\"\n");
      pw.close();

      return file;
    } catch (IOException ex) {
      throw new NvTestRuntimeException(ex);
    }
  }

  private File buildCreateOrderCsv(OrderCreationV2Template order) {
    StringBuilder orderAsSb = new StringBuilder()
        .append(normalize(order.getShipperId())).append(',')
        .append(normalize(order.getOrderNo())).append(',')
        .append('"').append(normalize(order.getShipperOrderNo())).append('"').append(',')
        .append('"').append(normalize(order.getOrderType())).append('"').append(',')
        .append('"').append(normalize(order.getToFirstName())).append('"').append(',')
        .append('"').append(normalize(order.getToLastName())).append('"').append(',')
        .append('"').append(normalize(order.getToContact())).append('"').append(',')
        .append('"').append(normalize(order.getToEmail())).append('"').append(',')
        .append('"').append(normalize(order.getToAddress1())).append('"').append(',')
        .append('"').append(normalize(order.getToAddress2())).append('"').append(',')
        .append('"').append(normalize(order.getToPostcode())).append('"').append(',')
        .append('"').append(normalize(order.getToDistrict())).append('"').append(',')
        .append('"').append(normalize(order.getToCity())).append('"').append(',')
        .append('"').append(normalize(order.getToStateOrProvince())).append('"').append(',')
        .append('"').append(normalize(order.getToCountry())).append('"').append(',')
        .append(normalize(order.getParcelSize())).append(',')
        .append(normalize(order.getWeight())).append(',')
        .append(normalize(order.getLength())).append(',')
        .append(normalize(order.getWidth())).append(',')
        .append(normalize(order.getHeight())).append(',')
        .append('"').append(normalize(order.getDeliveryDate())).append('"').append(',')
        .append(normalize(order.getDeliveryTimewindowId())).append(',')
        .append(normalize(order.getMaxDeliveryDays())).append(',')
        .append('"').append(normalize(order.getPickupDate())).append('"').append(',')
        .append(normalize(order.getPickupTimewindowId())).append(',')
        .append('"').append(normalize(order.isPickupWeekend()).toUpperCase()).append('"')
        .append(',')
        .append('"').append(normalize(order.isDeliveryWeekend()).toUpperCase()).append('"')
        .append(',')
        .append('"').append(normalize(order.getPickupInstruction())).append('"').append(',')
        .append('"').append(normalize(order.getDeliveryInstruction())).append('"').append(',')
        .append(normalize(order.getCodValue())).append(',')
        .append(normalize(order.getInsuredValue())).append(',')
        .append('"').append(normalize(order.getFromFirstName())).append('"').append(',')
        .append('"').append(normalize(order.getFromLastName())).append('"').append(',')
        .append('"').append(normalize(order.getFromContact())).append('"').append(',')
        .append('"').append(normalize(order.getFromEmail())).append('"').append(',')
        .append('"').append(normalize(order.getFromAddress1())).append('"').append(',')
        .append('"').append(normalize(order.getFromAddress2())).append('"').append(',')
        .append('"').append(normalize(order.getFromPostcode())).append('"').append(',')
        .append('"').append(normalize(order.getFromDistrict())).append('"').append(',')
        .append('"').append(normalize(order.getFromCity())).append('"').append(',')
        .append('"').append(normalize(order.getFromStateOrProvince())).append('"').append(',')
        .append('"').append(normalize(order.getFromCountry())).append('"').append(',')
        .append('"').append(normalize(order.getMultiParcelRefNo())).append('"');

    try {
      File file = TestUtils.createFileOnTempFolder(
          String.format("create-order-request_%s.csv", generateDateUniqueString()));

      PrintWriter pw = new PrintWriter(new FileOutputStream(file));
      pw.write(
          "\"SHIPPER ID\",\"ORDER NO\",\"SHIPPER ORDER NO\",\"ORDER TYPE\",\"TO FIRST NAME*\",\"TO LAST NAME\",\"TO CONTACT*\",\"TO EMAIL\",\"TO ADDRESS 1*\",\"TO ADDRESS 2\",\"TO POSTCODE\",\"TO DISTRICT\",\"TO CITY\",\"TO STATE/PROVINCE\",\"TO COUNTRY\",\"PARCEL SIZE\",\"WEIGHT\",\"LENGTH\",\"WIDTH\",\"HEIGHT\",\"DELIVERY DATE\",\"DELIVERY TIMEWINDOW ID\",\"MAX DELIVERY DAYS\",\"PICKUP DATE\",\"PICKUP TIMEWINDOW ID\",\"PICKUP WEEKEND\",\"DELIVERY WEEKEND\",\"PICKUP INSTRUCTION\",\"DELIVERY INSTRUCTION\",\"COD VALUE\",\"INSURED VALUE\",\"FROM FIRST NAME*\",\"FROM LAST NAME\",\"FROM CONTACT*\",\"FROM EMAIL\",\"FROM ADDRESS 1*\",\"FROM ADDRESS 2\",\"FROM POSTCODE\",\"FROM DISTRICT\",\"FROM CITY\",\"FROM STATE/PROVINCE\",\"FROM COUNTRY\",\"MULTI PARCEL REF NO\"");
      pw.write(System.lineSeparator());
      pw.write(orderAsSb.toString());
      pw.write(System.lineSeparator());
      pw.close();

      return file;
    } catch (IOException ex) {
      throw new NvTestRuntimeException(ex);
    }
  }

  public String getTextOnTable(int rowNumber, String columnDataClass) {
    return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT);
  }
}
