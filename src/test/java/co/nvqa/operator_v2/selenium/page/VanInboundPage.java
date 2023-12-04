package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.model.DataEntity;
import co.nvqa.operator_v2.selenium.elements.NgRepeatTable;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import java.util.List;
import java.util.Map;
import org.assertj.core.api.Assertions;
import org.junit.Assert;
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

  @FindBy(xpath = "  //div[./h3[.='Parcels yet to Scan']]/h5")
  public PageElement parcelsYetToScan;

  @FindBy(css = "md-dialog-content")
  public ScannedParcelsDialog scannedParcelsDialog;

  @FindBy(css = "button[aria-label='Route Start']")
  public PageElement routeStart;

  @FindBy(xpath = "//md-dialog-content[//*[.='Route  is started']]")
  public List<PageElement> routeStartedModal;

  @FindBy(css = "[aria-label*='Back to Route Input Screen']")
  public PageElement backToRouteInputScreen;

  @FindBy(css = "md-content[class^='nv-van-inbound']")
  public List<PageElement> vanInboundHomePage;

  @FindBy(xpath = "//h4[contains(text(),' Unable to van inbound')]")
  public PageElement unableToVanInboundModalTitle;

  @FindBy(xpath = "//p[contains(text(),'We are unable to van inbound this parcel')]")
  public PageElement unableToVanInboundModalMessage;

  @FindBy(xpath = "//md-icon[@role='button']")
  public PageElement closeIcon;

  @FindBy(xpath = "//button[@aria-label='Close']")
  public PageElement closeButton;

  @FindBy(xpath = "//button[@aria-label='View']")
  public PageElement viewButton;

  @FindBy(xpath = "//button[@aria-label='Hub Inbound Shipment']")
  public PageElement hubInboundShipment;

  @FindBy(xpath = "//button[@aria-label='Parcel Sweep Parcel']")
  public PageElement parcelSweepButton;

  @FindBy(xpath = "//label[text()='Tracking ID']/following-sibling::h3")
  private PageElement editOrderTrackingId;

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
    Assertions.assertThat(actualMessage).as("Tracking ID is invalid").isEqualTo("SUCCESS");
  }

  public void startRoute(String trackingId) {
    waitUntilVisibilityOfElementLocated("//*[starts-with(@id, 'tracking-id-scan')]");
    pause3s();
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
    Assertions.assertThat(expectedTrackingId).as("Tracking ID is valid").isEqualTo(trackingId);
  }

  public void verifyTrackingIdEmpty() {
    String actualMessage = getText("//div[contains(@class,\"status-box\")]/h1");
    Assertions.assertThat(actualMessage).as("Tracking ID is invalid").isEqualTo("EMPTY");
  }

  public void clickCloseIcon() {
    closeIcon.click();
  }

  public void clickCloseButton() {
    closeButton.click();
  }

  public void clickViewButton() {
    viewButton.click();
  }

  public void verifyNavigationToEditOrderScreen(String expectedTrackingId) {
    clickViewButton();
    String windowHandle = getWebDriver().getWindowHandle();
    switchToNewWindow();
    waitWhilePageIsLoading();
    pause3s();
    String actualTrackingId = editOrderTrackingId.getText().trim();
    closeAllWindows(windowHandle);
    pause3s();
    Assert.assertTrue("Assert that the search has results as expected after applying filters",
        actualTrackingId.equalsIgnoreCase(expectedTrackingId));
  }

  public void validateUnableToVanInboundModalIsDisplayed() {
    Assert.assertTrue(
        "Unable to Van Inbound Modal is not displayed",
        unableToVanInboundModalTitle.isDisplayed());
    Assert.assertTrue(
        "Unable to Van Inbound Modal message is not displayed",
        unableToVanInboundModalMessage.isDisplayed());
  }

  public void clickHubInboundShipmentButton() {
    hubInboundShipment.click();
  }

  public void clickParcelSweepButton() {
    parcelSweepButton.click();
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


  @FindBy(css = "md-dialog-content")
  public ShipmentInboundDialog shipmentInboundDialog;

  public static class ShipmentInboundDialog extends MdDialog {

    public ShipmentInboundDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "h4")
    public PageElement dialogHeader;

    @FindBy(css = "b")
    public PageElement parcelNo;

    @FindBy(css = "td.tracking-id")
    public PageElement trackingId;

    @FindBy(css = "p b")
    public PageElement trackingIdInModal;

    @FindBy(css = "[aria-label='Proceed without Hub Inbounding']")
    public PageElement proceedWithoutInbounding;

    @FindBy(css = "[aria-label='Hub Inbound Shipment']")
    public PageElement hubInboundShipment;

  }

  @FindBy(css = "md-dialog-content")
  public UnScannedParcelsDialog unScannedParcelsDialog;

  public static class UnScannedParcelsDialog extends MdDialog {

    public UnScannedParcelsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "h4")
    public PageElement dialogHeader;

    @FindBy(css = "td.tracking-id")
    public PageElement trackingId;

    @FindBy(css = "td.comments>div.warning-text")
    public PageElement commentsText;

  }


}
