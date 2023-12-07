package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.BulkOrderInfo;
import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.NgRepeatTable;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class BulkOrdersPage extends OperatorV2SimplePage {

  @FindBy(css = "[aria-label='Bulk ID']")
  public TextBox bulkIdInput;

  @FindBy(name = "Search")
  public NvApiTextButton searchButton;

  @FindBy(css = "md-dialog")
  public BulkDetailsDialog bulkDetailsDialog;

  @FindBy(css = "md-dialog")
  public PrintConfirmationDialog printConfirmationDialog;

  public BulkOrdersTable bulkOrdersTable;

  public BulkOrdersPage(WebDriver webDriver) {
    super(webDriver);
    bulkOrdersTable = new BulkOrdersTable(webDriver);
  }

  public static class BulkOrdersTable extends MdVirtualRepeatTable<BulkOrderInfo> {

    public static final String COLUMN_ID = "id";
    public static final String COLUMN_SHIPPER_ID = "shipperId";
    public static final String COLUMN_QTY = "qty";
    public static final String COLUMN_AUTO_RESCHEDULE_DAYS = "autoRescheduleDays";
    public static final String COLUMN_PICKUP_DATE = "pickupDate";
    public static final String COLUMN_PICKUP_TIMEWINDOW_ID = "pickupTimewindowId";
    public static final String COLUMN_DELIVERY_TIMEWINDOW_ID = "deliveryTimewindowId";
    public static final String COLUMN_HAS_DAYNIGHT = "hasDaynight";
    public static final String COLUMN_PROCESS_STATUS = "processStatus";
    public static final String COLUMN_ROLLBACK_TIME = "rollbackTime";
    public static final String COLUMN_CREATED_AT = "createdAt";
    public static final String ACTION_DETAILS = "details";
    public static final String ACTION_PRINT = "print";

    public BulkOrdersTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_ID, "id")
          .put(COLUMN_SHIPPER_ID, "shipper-id")
          .put(COLUMN_QTY, "qty")
          .put(COLUMN_AUTO_RESCHEDULE_DAYS, "auto-reschedule-days")
          .put(COLUMN_PICKUP_DATE, "pickup-date")
          .put(COLUMN_PICKUP_TIMEWINDOW_ID, "pickup-timewindow-id")
          .put(COLUMN_DELIVERY_TIMEWINDOW_ID, "delivery-timewindow-id")
          .put(COLUMN_HAS_DAYNIGHT, "has-daynight")
          .put(COLUMN_PROCESS_STATUS, "process-status")
          .put(COLUMN_ROLLBACK_TIME, "rollback-time")
          .put(COLUMN_CREATED_AT, "created-at")
          .build()
      );
      setEntityClass(BulkOrderInfo.class);
      setActionButtonsLocators(ImmutableMap.of(
          ACTION_DETAILS, "commons.details",
          ACTION_PRINT, "container.bulk-order.print-label"));
    }
  }

  public static class BulkDetailsDialog extends MdDialog {

    public OrdersTable ordersTable;

    public BulkDetailsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      ordersTable = new OrdersTable(webDriver);
    }

    public static class OrdersTable extends NgRepeatTable<Order> {

      public static final String COLUMN_TRACKING_ID = "trackingId";
      public static final String COLUMN_TYPE = "type";
      public static final String COLUMN_FROM_NAME = "fromName";
      public static final String COLUMN_TO_NAME = "toName";
      public static final String COLUMN_STATUS = "status";
      public static final String COLUMN_GRANULAR_STATUS = "granularStatus";

      public OrdersTable(WebDriver webDriver) {
        super(webDriver);
        setNgRepeat("order in ctrl.orders");
        setColumnLocators(ImmutableMap.<String, String>builder()
            .put(COLUMN_TRACKING_ID, "//td[2]")
            .put(COLUMN_TYPE, "//td[3]")
            .put(COLUMN_FROM_NAME, "//td[4]/span")
            .put(COLUMN_TO_NAME, "//td[5]/span")
            .put(COLUMN_STATUS, "//td[6]")
            .put(COLUMN_GRANULAR_STATUS, "//td[6]")
            .build()
        );
        setColumnValueProcessors(ImmutableMap.of(
            COLUMN_STATUS, value -> StringUtils.normalizeSpace(value).split(" ")[0],
            COLUMN_GRANULAR_STATUS, value -> StringUtils.normalizeSpace(value).split(" ")[1]
        ));
        setEntityClass(Order.class);
      }
    }
  }

  public static class PrintConfirmationDialog extends MdDialog {

    @FindBy(css = ".md-dialog-content-body")
    public PageElement message;

    @FindBy(css = "[aria-label='Print']")
    public Button printButton;

    public PrintConfirmationDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

}
