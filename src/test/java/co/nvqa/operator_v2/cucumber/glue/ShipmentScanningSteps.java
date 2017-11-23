package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.ShipmentScanningPage;
import co.nvqa.operator_v2.util.ScenarioStorage;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.inject.Inject;
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
    @Inject private ScenarioStorage scenarioStorage;
    private ShipmentScanningPage shipmentScanningPage;

    @Inject
    public ShipmentScanningSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        shipmentScanningPage = new ShipmentScanningPage(getWebDriver());
    }

    @When("^scan order to shipment in hub ([^\"]*)$")
    public void scanOrderToShipment(String hub)
    {
        String trackingId = scenarioStorage.get(KEY_CREATED_ORDER_TRACKING_ID);
        String shipmentId = scenarioStorage.get(KEY_SHIPMENT_ID);
        shipmentScanningPage.selectHub(hub);
        shipmentScanningPage.selectShipment(shipmentId);
        TestUtils.inputText(getWebDriver(), ShipmentScanningPage.XPATH_BARCODE_SCAN, trackingId + "\n");
        shipmentScanningPage.checkOrderInShipment(trackingId);
    }
}
