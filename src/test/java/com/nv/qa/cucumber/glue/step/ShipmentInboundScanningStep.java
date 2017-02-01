package com.nv.qa.cucumber.glue.step;

import com.nv.qa.selenium.page.ShipmentInboundScanningPage;
import com.nv.qa.selenium.page.ShipmentManagementPage;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.ScenarioStorage;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.java.Before;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import javax.inject.Inject;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

/**
 * Created by lanangjati
 * on 10/5/16.
 */
@ScenarioScoped
public class ShipmentInboundScanningStep {

    @Inject
    private ScenarioStorage scenarioStorage;

    private WebDriver driver;
    private ShipmentManagementPage shipmentManagementPage;
    private ShipmentInboundScanningPage scanningPage;

    @Before
    public void setup() {
        driver = SeleniumSharedDriver.getInstance().getDriver();
        shipmentManagementPage = new ShipmentManagementPage(driver);
        scanningPage = new ShipmentInboundScanningPage(driver);
    }

    @When("^choose inbound hub ([^\"]*)$")
    public void choose_inbound_hub_JKB(String hub) throws Throwable {
        scanningPage.selectHub(hub);
    }

    @When("^click button ([^\"]*) on Inbound Scanning$")
    public void clickButton(String label) throws Throwable {
        CommonUtil.clickBtn(driver, scanningPage.grabXpathButton(label));
    }

    @When("^scan shipment to inbound$")
    public void scan_shipment_to_inbound() throws Throwable {
        scanningPage.inputShipmentToInbound(scenarioStorage.get(ScenarioStorage.KEY_SHIPMENT_ID));
        scanningPage.checkSessionScan(scenarioStorage.get(ScenarioStorage.KEY_SHIPMENT_ID));
    }

    @Then("^inbounded shipment exist$")
    public void inbounded_shipment_exist() throws Throwable {
        List<ShipmentManagementPage.Shipment> shipmentList = shipmentManagementPage.getShipmentsFromTable();
        boolean isExist = false;
        for (ShipmentManagementPage.Shipment shipment : shipmentList) {
            if (shipment.getId().equalsIgnoreCase(scenarioStorage.get(ScenarioStorage.KEY_SHIPMENT_ID))) {
                isExist = true;
                break;
            }
        }

        Assert.assertTrue("shipment(" + scenarioStorage.get(ScenarioStorage.KEY_SHIPMENT_ID) + ") not exist", isExist);
    }

    @When("^change end date$")
    public void click_change_end_date_button() throws Throwable {
        Calendar now = Calendar.getInstance();
        now.add(Calendar.DATE, 2);
        List<String> mustCheckId = scanningPage.grabSessionIdNotChangedScan();
        scanningPage.clickEditEndDate();
        String today = new SimpleDateFormat("yyyy-MM-dd").format(now.getTime());
        scanningPage.inputEndDate(today);
        scanningPage.clickChangeDateButton();
        scanningPage.checkEndDateSessionScanChange(mustCheckId, today);
    }
}
