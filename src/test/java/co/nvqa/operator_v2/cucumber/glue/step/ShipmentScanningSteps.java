package co.nvqa.operator_v2.cucumber.glue.step;

import com.google.inject.Inject;
import co.nvqa.operator_v2.selenium.page.ShipmentScanningPage;
import co.nvqa.operator_v2.support.CommonUtil;
import co.nvqa.operator_v2.support.ScenarioStorage;
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

    private ShipmentScanningPage scanningPage;

    @Inject
    public ShipmentScanningSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        scanningPage = new ShipmentScanningPage(getDriver());
    }

    @When("^scan order to shipment in hub ([^\"]*)$")
    public void scanOrderToShipment(String hub)
    {
        scanningPage.selectHub(hub);
        scanningPage.selectShipment(scenarioStorage.get(ScenarioStorage.KEY_SHIPMENT_ID));
        CommonUtil.inputText(getDriver(), ShipmentScanningPage.XPATH_BARCODE_SCAN, scenarioStorage.get(ScenarioStorage.KEY_TRACKING_ID) + "\n");
        scanningPage.checkOrderInShipment(scenarioStorage.get(ScenarioStorage.KEY_TRACKING_ID));
    }
}
