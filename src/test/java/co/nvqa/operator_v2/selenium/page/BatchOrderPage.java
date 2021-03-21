package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import java.util.Date;
import org.openqa.selenium.WebDriver;


/**
 * @author Niko Susanto
 */
@SuppressWarnings("WeakerAccess")
public class BatchOrderPage extends OperatorV2SimplePage {

  private static final String MD_VIRTUAL_REPEAT_TABLE_ORDER = "order in getTableData()";

  public static final String COLUMN_CLASS_DATA_TRACKING_ID = "tracking_id";
  public static final String COLUMN_CLASS_DATA_TYPE = "type";
  public static final String COLUMN_CLASS_DATA_FROM = "c_from";
  public static final String COLUMN_CLASS_DATA_TO = "c_to";
  public static final String COLUMN_CLASS_DATA_STATUS = "status";
  public static final String COLUMN_CLASS_DATA_CREATED_AT = "c_created_at";
  private static final String ERROR_TOAST_INVALID_BATCH_ID_XPATH = "//div[contains(@class,'toast-error')]//strong[text()='Order batch with batch id %s not found!']";
  private static final String ERROR_TOAST_INVALID_ORDER_STATUS_XPATH = "//div[contains(@class,'toast-error')]//strong[contains(text(),'delete order %s in Cancelled state. Order can only be deleted if in the following states : [Staging, Pending Pickup, Van en-route to pickup, Pickup fail]')]";
  private static final String ROLLBACK_BUTTON_XPATH = "//md-dialog-actions//button[@aria-label='Rollback']";

  public BatchOrderPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void searchBatchId(String batchId) {
    sendKeysToMdInputContainerByModel("ctrl.formBatchId", batchId);
    clickNvApiTextButtonByNameAndWaitUntilDone("commons.search");
  }

  public String getTextOnTableOrder(String columnDataClass) {
    return getTextOnTableWithMdVirtualRepeat(1, columnDataClass, MD_VIRTUAL_REPEAT_TABLE_ORDER);
  }

  public void verifyOrderInfoOnTableOrderIsCorrect(Order order) {
    String trackingId = order.getTrackingId();
    String expectedType = order.getType();
    String expectedFrom =
        order.getFromName() + System.lineSeparator() + order.getFromAddress1() + " " + order
            .getFromAddress2() + " " + order.getFromCountry() + " " + order.getFromPostcode();
    expectedFrom = expectedFrom.replaceAll("( )+", " ");
    String expectedTo =
        order.getToName() + System.lineSeparator() + order.getToAddress1() + " " + order
            .getToAddress2() + " " + order.getToCountry() + " " + order.getToPostcode();
    expectedTo = expectedTo.replaceAll("( )+", " ");
    String expectedStatus = order.getStatus() + System.lineSeparator() + order.getGranularStatus();
    Date expectedCreatedAt = order.getCreatedAt();

    String actualTrackingId = getTextOnTableOrder(COLUMN_CLASS_DATA_TRACKING_ID);
    String actualType = getTextOnTableOrder(COLUMN_CLASS_DATA_TYPE);
    String actualFrom = getTextOnTableOrder(COLUMN_CLASS_DATA_FROM);
    String actualTo = getTextOnTableOrder(COLUMN_CLASS_DATA_TO);
    String actualStatus = getTextOnTableOrder(COLUMN_CLASS_DATA_STATUS);
    String actualCreatedAt = getTextOnTableOrder(COLUMN_CLASS_DATA_CREATED_AT);

    assertEquals("Tracking ID", trackingId, actualTrackingId);
    assertEquals("Type", expectedType, actualType);
    assertEquals("From", expectedFrom, actualFrom);
    assertEquals("To", expectedTo, actualTo);
    assertEquals("Status", expectedStatus, actualStatus);
    assertEquals("Created At", actualCreatedAt, expectedCreatedAt);
  }

  public void verifyTheInvalidBatchIdToast(String batchId) {
    waitUntilVisibilityOfElementLocated(ERROR_TOAST_INVALID_BATCH_ID_XPATH, batchId);
  }

  public void rollbackBatchOrder() {
    clickButtonByAriaLabel("Rollback");
    sendKeysByAriaLabel("Password", "1234567890");
    click(ROLLBACK_BUTTON_XPATH);
  }

  public void verifyTheInvalidStatusToast(String trackingId) {
    waitUntilVisibilityOfElementLocated(ERROR_TOAST_INVALID_ORDER_STATUS_XPATH, trackingId);
  }
}
