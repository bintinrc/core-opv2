package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.selenium.page.ShipmentInboundPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.When;

/**
 * @author Tristania Siagian
 */
public class ShipmentInboundSteps extends AbstractSteps
{
    private ShipmentInboundPage shipmentInboundPage;

    public ShipmentInboundSteps()
    {
    }

    @Override
    public void init()
    {
        shipmentInboundPage = new ShipmentInboundPage(getWebDriver());
    }

    @When("Operator selects the Hub = {string} and the Shipment ID")
    public void operatorSelectsTheHubAndTheShipmentId(String hubName)
    {
        String shipmentIdAsString = Long.toString(get(KEY_CREATED_SHIPMENT_ID));

        if ("orderDestHubName".equalsIgnoreCase(hubName)) {
            Order order = get(KEY_CREATED_ORDER);
            hubName = order.getDestinationHub();
            shipmentInboundPage.selectPreciseHubAndShipmentId(hubName, shipmentIdAsString);
        } else {
            shipmentInboundPage.selectHubAndShipmentId(hubName, shipmentIdAsString);
        }
    }

    @And("Operator clicks on Continue Button in Shipment Inbound Page")
    public void operatorClicksOnContinueButtonInShipmentInboundPage()
    {
        shipmentInboundPage.clickContinueButton();
    }

    @And("Operator inputs the {string} Tracking ID in the Shipment Inbound Page")
    public void operatorInputsTheTrackingID(String trackingIdOrigin)
    {
        String trackingId;

        if ("CREATED".equalsIgnoreCase(trackingIdOrigin))
        {
            trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        } else {
            trackingId = "RANDOMTID" + randomLong(0,99999);
        }

        shipmentInboundPage.enterTrackingId(trackingId);
    }

    @And("Operator inputs Tracking ID using prefix in the Shipment Inbound Page")
    public void operatorInputsTheTrackingIDUsingPrefix()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        String prefix = trackingId.substring(0, 5);
        trackingId = trackingId.substring(5);

        shipmentInboundPage.addPrefix(prefix);
        shipmentInboundPage.enterTrackingId(trackingId);
    }
}
