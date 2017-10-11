package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.selenium.page.ShipmentScanningPage;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.ScenarioStorage;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Lanang Jati
 *
 * Modified by Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ShipmentScanningStep extends AbstractSteps
{
    @Inject private ScenarioStorage scenarioStorage;

    private ShipmentScanningPage scanningPage;

    @Inject
    public ShipmentScanningStep(CommonScenario commonScenario)
    {
        super(commonScenario);
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
