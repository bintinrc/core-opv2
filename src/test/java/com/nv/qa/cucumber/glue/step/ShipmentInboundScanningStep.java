package com.nv.qa.cucumber.glue.step;

import com.nv.qa.selenium.page.page.ShipmentInboundScanningPage;
import com.nv.qa.selenium.page.page.ShipmentManagementPage;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.java.Before;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.util.List;

/**
 * Created by lanangjati
 * on 10/5/16.
 */
@ScenarioScoped
public class ShipmentInboundScanningStep {

    private WebDriver driver;
    private ShipmentManagementPage shipmentManagementPage;
    private ShipmentInboundScanningPage scanningPage;
    private String shipmentId = "";

    @Before
    public void setup() {
        driver = SeleniumSharedDriver.getInstance().getDriver();
        shipmentManagementPage = new ShipmentManagementPage(driver);
        scanningPage = new ShipmentInboundScanningPage(driver);
    }

    @Then("^get first shipment for shipment inbound scanning$")
    public void get_first_shipment() throws Throwable {
        ShipmentManagementPage.Shipment shipment = shipmentManagementPage.getShipmentFromTable(0);
        shipmentId = shipment.getId();
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
        CommonUtil.inputText(driver, ShipmentInboundScanningPage.XPATH_SCAN_INPUT, shipmentId + "\n");
    }

    @Then("^inbounded shipment exist$")
    public void inbounded_shipment_exist() throws Throwable {
        List<ShipmentManagementPage.Shipment> shipmentList = shipmentManagementPage.getShipmentsFromTable();
        boolean isExist = false;
        for (ShipmentManagementPage.Shipment shipment : shipmentList) {
            if (shipment.getId().equalsIgnoreCase(shipmentId)) {
                isExist = true;
                break;
            }
        }

        Assert.assertTrue("shipment(" + shipmentId + ") not exist", isExist);
    }
}
