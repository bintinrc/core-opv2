package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.hub.Shipments;
import co.nvqa.operator_v2.model.ShipmentInfo;
import co.nvqa.operator_v2.selenium.page.ShipmentScanningPage;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Lanang Jati
 *
 * Modified by Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ShipmentScanningSteps extends AbstractSteps
{
    private ShipmentScanningPage shipmentScanningPage;

    public ShipmentScanningSteps()
    {
    }

    @Override
    public void init()
    {
        shipmentScanningPage = new ShipmentScanningPage(getWebDriver());
    }

    @When("^Operator scan the created order to shipment in hub ([^\"]*)$")
    public void operatorScanTheCreatedOrderToShipmentInHub(String hub)
    {
        String trackingId =get(KEY_CREATED_ORDER_TRACKING_ID);
        String shipmentId = get(KEY_CREATED_SHIPMENT_ID);
        String shipmentType = containsKey(KEY_SHIPMENT_INFO) ?
                ((ShipmentInfo) get(KEY_SHIPMENT_INFO)).getShipmentType() :
                ((Shipments)get(KEY_CREATED_SHIPMENT)).getShipment().getShipmentType();

        shipmentScanningPage.selectHub(hub);
        shipmentScanningPage.selectShipmentType(shipmentType);
        shipmentScanningPage.selectShipmentId(shipmentId);
        shipmentScanningPage.clickSelectShipment();
        shipmentScanningPage.scanBarcode(trackingId);
        shipmentScanningPage.checkOrderInShipment(trackingId);
    }
}
