package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.model.DataEntity;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntTableV2;
import com.google.common.collect.ImmutableMap;
import java.util.List;
import java.util.Map;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class OutboundBreakrouteV2Page extends SimpleReactPage<OutboundBreakrouteV2Page> {

  @FindBy(xpath = "//button[.='Pull Out']")
  public Button pullOut;

  @FindBy(css = "div.table-stats > div > div:nth-of-type(2)")
  public PageElement routesCount;

  @FindBy(css = "div.table-stats > div > div:nth-of-type(3)")
  public PageElement date;

  @FindBy(css = ".ant-modal")
  public ConfirmPulloutDialog confirmPulloutDialog;

  @FindBy(css = ".ant-modal")
  public ProcessModal processModal;

  public OrdersInRouteTable ordersInRouteTable;

  public OutboundBreakrouteV2Page(WebDriver webDriver) {
    super(webDriver);
    ordersInRouteTable = new OrdersInRouteTable(webDriver);
  }

  public static class OrderInfo extends DataEntity<OrderInfo> {

    private String trackingId;
    private String granularStatus;
    private String lastScannedHub;
    private String routeId;
    private String routeDate;
    private String driverId;
    private String driverName;
    private String driverType;
    private String address;
    private String lastScanType;
    private String orderDeliveryType;

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

    public String getGranularStatus() {
      return granularStatus;
    }

    public void setGranularStatus(String granularStatus) {
      this.granularStatus = granularStatus;
    }

    public String getLastScannedHub() {
      return lastScannedHub;
    }

    public void setLastScannedHub(String lastScannedHub) {
      this.lastScannedHub = lastScannedHub;
    }

    public String getRouteId() {
      return routeId;
    }

    public void setRouteId(String routeId) {
      this.routeId = routeId;
    }

    public String getRouteDate() {
      return routeDate;
    }

    public void setRouteDate(String routeDate) {
      this.routeDate = routeDate;
    }

    public String getDriverId() {
      return driverId;
    }

    public void setDriverId(String driverId) {
      this.driverId = driverId;
    }

    public String getDriverName() {
      return driverName;
    }

    public void setDriverName(String driverName) {
      this.driverName = driverName;
    }

    public String getDriverType() {
      return driverType;
    }

    public void setDriverType(String driverType) {
      this.driverType = driverType;
    }

    public String getAddress() {
      return address;
    }

    public void setAddress(String address) {
      this.address = address;
    }

    public String getLastScanType() {
      return lastScanType;
    }

    public void setLastScanType(String lastScanType) {
      this.lastScanType = lastScanType;
    }

    public String getOrderDeliveryType() {
      return orderDeliveryType;
    }

    public void setOrderDeliveryType(String orderDeliveryType) {
      this.orderDeliveryType = orderDeliveryType;
    }

    @Override
    public String toString() {
      return "OrderInfo{" +
          "trackingId='" + trackingId + '\'' +
          ", granularStatus='" + granularStatus + '\'' +
          ", lastScannedHub='" + lastScannedHub + '\'' +
          ", routeId='" + routeId + '\'' +
          ", routeDate='" + routeDate + '\'' +
          ", driverId='" + driverId + '\'' +
          ", driverName='" + driverName + '\'' +
          ", driverType='" + driverType + '\'' +
          ", address='" + address + '\'' +
          ", lastScanType='" + lastScanType + '\'' +
          ", orderDeliveryType='" + orderDeliveryType + '\'' +
          '}';
    }
  }

  public static class OrdersInRouteTable extends AntTableV2<OrderInfo> {

    public OrdersInRouteTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("trackingId", "tracking_id")
          .put("granularStatus", "granular_status")
          .put("lastScannedHub", "last_scanned_hub")
          .put("routeId", "route_id")
          .put("routeDate", "route_date")
          .put("driverId", "driver_id")
          .put("driverName", "driver_name")
          .put("driverType", "driver_type")
          .put("address", "address")
          .put("lastScanType", "last_scanned_type")
          .put("orderDeliveryType", "order_delivery_type")
          .build());
      setEntityClass(OrderInfo.class);
    }
  }

  public static class ConfirmPulloutDialog extends AntModal {

    public ConfirmPulloutDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "div[role='gridcell'][data-datakey='0']")
    public List<PageElement> routeIds;

    @FindBy(css = "div[role='gridcell'][data-datakey='1']")
    public List<PageElement> trackingIds;

    @FindBy(xpath = ".//button[.='Pull Out']")
    public Button pullOut;
  }

  public static class ProcessModal extends AntModal {

    @FindBy(css = "table[data-testid='simple-table'] tr > td:nth-of-type(2)")
    public List<PageElement> errors;

    @FindBy(xpath = ".//button[.='Cancel']")
    public Button cancel;

    public ProcessModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}