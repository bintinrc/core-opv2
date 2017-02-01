package com.nv.qa.cucumber.glue.step;

import com.nv.qa.selenium.page.ShipmentScanningPage;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.ScenarioStorage;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.java.Before;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.openqa.selenium.WebDriver;

import javax.inject.Inject;

/**
 * Created by lanangjati
 * on 9/26/16.
 */
@ScenarioScoped
public class ShipmentScanningStep {

    @Inject
    private ScenarioStorage scenarioStorage;

    private WebDriver driver;
    private ShipmentScanningPage scanningPage;

    @Before
    public void setup() {
        driver = SeleniumSharedDriver.getInstance().getDriver();
        scanningPage = new ShipmentScanningPage(driver);
    }

    @When("^scan order to shipment in hub ([^\"]*)$")
    public void scanOrderToShipment(String hub) throws Throwable {
        scanningPage.selectHub(hub);
        scanningPage.selectShipment(scenarioStorage.get(ScenarioStorage.KEY_SHIPMENT_ID));
        CommonUtil.inputText(driver, ShipmentScanningPage.XPATH_BARCODE_SCAN, scenarioStorage.get(ScenarioStorage.KEY_TRACKING_ID) + "\n");
        scanningPage.checkOrderInShipment(scenarioStorage.get(ScenarioStorage.KEY_TRACKING_ID));
    }
}
