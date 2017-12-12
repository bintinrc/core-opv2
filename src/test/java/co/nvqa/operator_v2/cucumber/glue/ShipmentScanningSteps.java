package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.ShipmentScanningPage;
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
    private ShipmentScanningPage shipmentScanningPage;

    @Inject
    public ShipmentScanningSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        shipmentScanningPage = new ShipmentScanningPage(getWebDriver());
    }

    @When("^scan order to shipment in hub ([^\"]*)$")
    public void scanOrderToShipment(String hub)
    {
        String trackingId = getScenarioStorage().get(KEY_CREATED_ORDER_TRACKING_ID);
        String shipmentId = getScenarioStorage().get(KEY_SHIPMENT_ID);
        shipmentScanningPage.selectHub(hub);
        shipmentScanningPage.selectShipment(shipmentId);
        TestUtils.inputText(getWebDriver(), ShipmentScanningPage.XPATH_BARCODE_SCAN, trackingId + "\n");
        shipmentScanningPage.checkOrderInShipment(trackingId);
    }
}
