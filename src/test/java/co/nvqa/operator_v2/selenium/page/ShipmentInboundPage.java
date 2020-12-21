package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.md.MdAutocomplete;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Tristania Siagian
 */
public class ShipmentInboundPage extends OperatorV2SimplePage {

  private static final String LOCATOR_SPINNER = "//md-progress-circular";

  @FindBy(xpath = "//md-select[starts-with(@id,'commons.hub')]")
  public MdSelect hub;

  @FindBy(xpath = "//md-autocomplete[@placeholder='Shipment ID']")
  public MdAutocomplete shipmentIdSelector;

  @FindBy(xpath = "//div[contains(@class,'validation-message error')]/p")
  public PageElement shipmentIdValidationMessage;

  public ShipmentInboundPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void selectHubAndShipmentId(String hubName, String shipmentId) {
    pause3s();
    hub.searchAndSelectValue(hubName);
    shipmentIdSelector.selectValue(shipmentId);
    pause1s();
  }

  public void selectHubShipmentIdAndCheckErrorMessage(String hubName, String errorMessage) {
    pause3s();
    hub.searchAndSelectValue(hubName);
    shipmentIdSelector.waitUntilClickable();
    shipmentIdSelector.selectItem("No Shipment ID");
    pause1s();
    shipmentIdValidationMessage.waitUntilClickable();
    Assert.assertEquals("Shipment ID validation message", errorMessage,
        shipmentIdValidationMessage.getText());
  }

  public void clickContinueButton() {
    clickNvIconTextButtonByNameAndWaitUntilDone("Continue");
    waitUntilInvisibilityOfElementLocated(LOCATOR_SPINNER);
  }

  public void enterTrackingId(String trackingId) {
    sendKeysAndEnterByAriaLabel("Tracking ID", trackingId);
  }

  public void addPrefix(String prefix) {
    clickNvIconTextButtonByName("container.parcel-sweeper.add-prefix");
    waitUntilVisibilityOfMdDialogByTitle("Set Prefix");
    sendKeysById("container.global-inbound.prefix", prefix);
    clickNvIconTextButtonByName("Save");
    waitUntilInvisibilityOfMdDialogByTitle("Set Prefix");
  }
}
