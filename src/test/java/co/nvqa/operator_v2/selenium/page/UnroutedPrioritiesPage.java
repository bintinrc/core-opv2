package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.util.NvTestRuntimeException;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeParseException;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class UnroutedPrioritiesPage extends OperatorV2SimplePage {

  private static final String MD_VIRTUAL_REPEAT = "unroutedPriority in getTableData()";
  public static final String COLUMN_ClASS_DATA_TRACKING_ID = "tracking_id";
  public static final String COLUMN_ClASS_DATA_SHIPPER_NAME = "shipper_name";
  public static final String COLUMN_ClASS_DATA_TRANSACTION_END_TIME = "transaction_end_time";
  public static final String COLUMN_ClASS_DATA_GRANULAR_STATUS = "order_granular_status";

  public UnroutedPrioritiesPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void filterAndClickLoadSelection(ZonedDateTime routeDate) {
    setMdDatepicker("ctrl.date", routeDate);
    clickNvApiTextButtonByNameAndWaitUntilDone("commons.load-selection");
  }

  public void verifyOrderIsListedAndContainsCorrectInfo(Order order) {
    Long orderId = order.getId();
    String trackingId = order.getTrackingId();

    searchTableByTrackingId(trackingId);
    Assertions.assertThat(isTableEmpty())
        .as(f("Order (ID = %d - Tracking ID = %s) not found on table.", orderId, trackingId))
        .isFalse();

    String actualTrackingId = getTextOnTable(1, COLUMN_ClASS_DATA_TRACKING_ID);
    String actualShipperName = getTextOnTable(1, COLUMN_ClASS_DATA_SHIPPER_NAME);
    String actualGranularStatus = getTextOnTable(1, COLUMN_ClASS_DATA_GRANULAR_STATUS);
    String actualTransactionEndTime = getTextOnTable(1, COLUMN_ClASS_DATA_TRANSACTION_END_TIME);

    Assertions.assertThat(actualTrackingId).as("Tracking ID").isEqualTo(order.getTrackingId());
    Assertions.assertThat(actualShipperName).as("Shipper Name")
        .isEqualTo(order.getShipper().getName());
    Assertions.assertThat(actualGranularStatus).as("Check Granular Status")
        .isEqualToIgnoringCase(order.getGranularStatus().replace("_", " "));
    try {
      String orderEndTime = order.getTransactions().get(order.getTransactions().size() - 1)
          .getEndTime();
      ZonedDateTime zonedDateTime = StandardTestUtils.convertToZonedDateTime(orderEndTime,
          ZoneId.of("UTC"), DTF_ISO_8601_LITE);
      String expectedTransactionEndDate = DTF_NORMAL_DATETIME.format(zonedDateTime);
      Assertions.assertThat(actualTransactionEndTime).as("Transaction End Time")
          .isEqualTo(expectedTransactionEndDate);
    } catch (DateTimeParseException ex) {
      throw new NvTestRuntimeException("Failed to parse transaction end date.");
    }
  }

  public void verifyOrderIsNotListed(Order order) {
    Long orderId = order.getId();
    String trackingId = order.getTrackingId();

    searchTableByTrackingId(trackingId);
    assertTrue(String
        .format("Order (ID = %d - Tracking ID = %s) should not be listed on table.", orderId,
            trackingId), isTableEmpty());
  }

  public void searchTableByTrackingId(String trackingId) {
    searchTableCustom1("tracking_id", trackingId);
  }

  public String getTextOnTable(int rowNumber, String columnDataClass) {
    return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
  }
}
