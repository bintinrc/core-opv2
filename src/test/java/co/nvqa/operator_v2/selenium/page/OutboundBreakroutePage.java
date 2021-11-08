package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.DataEntity;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import com.google.common.collect.ImmutableMap;
import java.util.Map;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class OutboundBreakroutePage extends OperatorV2SimplePage {

  @FindBy(id = "route-id")
  public TextBox routeId;

  @FindBy(css = "md-dialog")
  public ConfirmPulloutDialog confirmPulloutDialog;

  public OrdersInRouteTable ordersInRouteTable;
  public OutboundScansTable outboundScansTable;
  public ParcelsNotInOutboundScansTable parcelsNotInOutboundScansTable;

  public OutboundBreakroutePage(WebDriver webDriver) {
    super(webDriver);
    ordersInRouteTable = new OrdersInRouteTable(webDriver);
    outboundScansTable = new OutboundScansTable(webDriver);
    parcelsNotInOutboundScansTable = new ParcelsNotInOutboundScansTable(webDriver);
  }

  public void waitUntilElementDisplayed() {
    routeId.waitUntilVisible();
  }

  public static class OrderInfo extends DataEntity<OrderInfo> {

    private String trackingId;
    private String info;

    public OrderInfo() {
    }

    public OrderInfo(Map<String, ?> data) {
      super(data);
    }

    public String getTrackingId() {
      return trackingId;
    }

    public void setTrackingId(String trackingId) {
      this.trackingId = trackingId;
    }

    public String getInfo() {
      return info;
    }

    public void setInfo(String info) {
      this.info = info;
    }
  }

  public static class OrdersInRouteTable extends NgRepeatTable<OrderInfo> {

    public OrdersInRouteTable(WebDriver webDriver) {
      super(webDriver);
      setNgRepeat("order in ctrl.orders");
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("trackingId", "tracking-id")
          .put("info", "info-column")
          .build());
      setEntityClass(OrderInfo.class);
    }
  }

  public static class OutboundScansTable extends NgRepeatTable<OrderInfo> {

    public OutboundScansTable(WebDriver webDriver) {
      super(webDriver);
      setNgRepeat("order in ctrl.scans");
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("trackingId", "tracking-id")
          .put("info", "info-column")
          .build());
      setEntityClass(OrderInfo.class);
    }
  }

  public static class ParcelsNotInOutboundScansTable extends NgRepeatTable<OrderInfo> {

    public ParcelsNotInOutboundScansTable(WebDriver webDriver) {
      super(webDriver);
      setNgRepeat("order in ctrl.orders");
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("trackingId", "tracking-id")
          .put("info", "info-column")
          .build());
      setEntityClass(OrderInfo.class);
      setActionButtonsLocators(ImmutableMap.of(
          "pull", "//tr[@ng-repeat='order in ctrl.missingOutbounds'][%d]//nv-icon-text-button"
      ));
    }
  }

  public static class ConfirmPulloutDialog extends MdDialog {

    public ConfirmPulloutDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "button[aria-label='Pull Out']")
    public Button pullOut;
  }
}