package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.DataEntity;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import java.util.Map;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Tristania Siagian
 */
public class VanInboundPage extends OperatorV2SimplePage {

  @FindBy(id = "route-id")
  public TextBox routeId;

  @FindBy(id = "tracking-id")
  public TextBox trackingId;

  @FindBy(id = "tracking-id-scan")
  public TextBox trackingIdScan;

  @FindBy(xpath = "//div[./h3[.='Scanned Parcels']]/h5")
  public PageElement scannedParcelsCount;

  @FindBy(css = "md-dialog")
  public ScannedParcelsDialog scannedParcelsDialog;

  public VanInboundPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void fillRouteIdOnVanInboundPage(String routeId) {
    sendKeysById("route-id", routeId);
    clickNvApiTextButtonByNameAndWaitUntilDone("container.van-inbound.fetch");
  }

  public void fillTrackingIdOnVanInboundPage(String trackingId) {
    sendKeysById("tracking-id-scan", trackingId + Keys.RETURN);
    pause1s();
  }

  public void verifyVanInboundSucceed() {
    String actualMessage = getText("//div[contains(@class,\"status-box\")]/h1");
    assertEquals("Tracking ID is invalid", "SUCCESS", actualMessage);
  }

  public void startRoute(String trackingId) {
    sendKeysById("tracking-id-scan", trackingId);
    pause1s();
    clickButtonByAriaLabelAndWaitUntilDone("Route Start");
    waitUntilVisibilityOfElementLocated(
        "//md-dialog-content[contains( @class, 'md-dialog-content')]");
    clickButtonOnMdDialogByAriaLabel("Close");
  }

  public void verifyInvalidTrackingId(String trackingId) {
    String expectedTrackingId = findElementByXpath(
        "//tr[@ng-repeat='trackingId in ctrl.invalidTrackingIds track by $index'][1]/td").getText()
        .trim();
    assertEquals("Tracking ID is valid", trackingId, expectedTrackingId);
  }

  public void verifyTrackingIdEmpty() {
    String actualMessage = getText("//div[contains(@class,\"status-box\")]/h1");
    assertEquals("Tracking ID is invalid", "EMPTY", actualMessage);
  }

  public static class ScannedParcelsDialog extends MdDialog {

    @FindBy(name = "commons.close")
    public NvIconTextButton close;

    public OrdersTable ordersTable;

    public ScannedParcelsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      ordersTable = new OrdersTable(webDriver);
    }

    public static class OrderInfo extends DataEntity<OrderInfo> {

      private String trackingId;
      private String name;
      private String contact;
      private String address;
      private String granularStatus;
      private String status;

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

      public String getName() {
        return name;
      }

      public void setName(String name) {
        this.name = name;
      }

      public String getContact() {
        return contact;
      }

      public void setContact(String contact) {
        this.contact = contact;
      }

      public String getAddress() {
        return address;
      }

      public void setAddress(String address) {
        this.address = address;
      }

      public String getGranularStatus() {
        return granularStatus;
      }

      public void setGranularStatus(String granularStatus) {
        this.granularStatus = granularStatus;
      }

      public String getStatus() {
        return status;
      }

      public void setStatus(String status) {
        this.status = status;
      }
    }

    public static class OrdersTable extends NgRepeatTable<OrderInfo> {

      public OrdersTable(WebDriver webDriver) {
        super(webDriver);
        setColumnLocators(ImmutableMap.<String, String>builder()
            .put("trackingId", "tracking-id")
            .put("name", "name")
            .put("contact", "contact")
            .put("address", "address")
            .put("granularStatus", "granular-status")
            .put("status", "status")
            .build());
        setNgRepeat("order in ctrl.data");
        setEntityClass(OrderInfo.class);
      }
    }
  }
}
