package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.ShipmentInboundPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.When;
import java.util.Map;

/**
 * @author Tristania Siagian
 */
public class ShipmentInboundSteps extends AbstractSteps {

  private ShipmentInboundPage shipmentInboundPage;

  public ShipmentInboundSteps() {
  }

  @Override
  public void init() {
    shipmentInboundPage = new ShipmentInboundPage(getWebDriver());
  }

  @When("Operator selects the Hub = {string} and the Shipment ID")
  public void operatorSelectsTheHubAndTheShipmentId(String hubName) {
    String shipmentIdAsString = Long.toString(get(KEY_CREATED_SHIPMENT_ID));
    hubName = resolveValue(hubName);
    shipmentInboundPage.selectHubAndShipmentId(hubName, shipmentIdAsString);
  }

  @When("Operator selects Hub and Shipment ID and check error message:")
  public void operatorSelectsHubAndShipmentIdAndCheckErrorMessage(Map<String, String> data) {
    data = resolveKeyValues(data);
    String hubName = data.get("hub");
    String errorMessage = data.get("errorMessage");
    shipmentInboundPage.selectHubShipmentIdAndCheckErrorMessage(hubName, errorMessage);
  }

  @And("Operator clicks on Continue Button in Shipment Inbound Page")
  public void operatorClicksOnContinueButtonInShipmentInboundPage() {
    shipmentInboundPage.clickContinueButton();
  }

  @And("Operator inputs the {string} Tracking ID in the Shipment Inbound Page")
  public void operatorInputsTheTrackingID(String trackingId) {
    trackingId = resolveValue(trackingId);

    if ("RANDOM".equalsIgnoreCase(trackingId)) {
      trackingId = "RANDOMTID" + randomLong(0, 99999);
    }

    shipmentInboundPage.enterTrackingId(trackingId);
  }

  @And("Operator inputs Tracking ID using prefix in the Shipment Inbound Page")
  public void operatorInputsTheTrackingIDUsingPrefix() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    String prefix = trackingId.substring(0, 5);
    trackingId = trackingId.substring(5);

    shipmentInboundPage.addPrefix(prefix);
    shipmentInboundPage.enterTrackingId(trackingId);
  }
}
