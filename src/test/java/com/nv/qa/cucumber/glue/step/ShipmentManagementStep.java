package com.nv.qa.cucumber.glue.step;

import com.nv.qa.selenium.page.page.ShipmentManagementPage;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

import java.util.List;

import static com.nv.qa.selenium.page.page.ShipmentManagementPage.*;

/**
 * Created by lanangjati
 * on 9/6/16.
 */
@ScenarioScoped
public class ShipmentManagementStep {

    private WebDriver driver;
    private ShipmentManagementPage shipmentManagementPage;
    private String id = "";
    private String start = "";
    private String end = "";
    private String comment = "";

    @Before
    public void setup() {
        driver = SeleniumSharedDriver.getInstance().getDriver();
        shipmentManagementPage = new ShipmentManagementPage(driver);
    }

    @After
    public void teardown() {

    }

    @When("^create shipment button is clicked$")
    public void ClickCreateShipmentButton() throws Throwable {
        CommonUtil.clickBtn(driver, XPATH_CREATE_SHIPMENT_BUTTON);
    }

    @When("^create Shipment with Start Hub ([^\"]*), End hub ([^\"]*) and comment ([^\"]*)$")
    public void createShipment(String startHub, String endHub, String comment) throws Throwable {

        shipmentManagementPage.selectStartHub(startHub);
        CommonUtil.pause10ms();
        shipmentManagementPage.selectEndHub(endHub);
        CommonUtil.pause10ms();
        CommonUtil.inputText(driver, XPATH_COMMENT_TEXT_AREA, comment);

        CommonUtil.clickBtn(driver, XPATH_CREATE_SHIPMENT_CONFIRMATION_BUTTON);
        CommonUtil.pause1s();

    }

    @When("^edit Shipment with Start Hub ([^\"]*), End hub ([^\"]*) and comment ([^\"]*)$")
    public void editShipment(String startHub, String endHub, String comment) throws Throwable {

        shipmentManagementPage.selectStartHub(startHub);
        CommonUtil.pause10ms();
        shipmentManagementPage.selectEndHub(endHub);
        CommonUtil.pause10ms();
        CommonUtil.inputText(driver, XPATH_COMMENT_TEXT_AREA, comment);

        start = startHub;
        end = endHub;
        this.comment = comment;

        CommonUtil.clickBtn(driver, XPATH_SAVE_CHANGES_BUTTON);
        CommonUtil.pause1s();

    }

    @Then("^shipment created$")
    public void shipmentCreated() throws Throwable {
        Assert.assertNotNull("shipment table loaded", driver.findElement(By.xpath("//div[@ng-if=\"nvLoad.status === 'loaded'\"][@aria-hidden=\"false\"]")));
        CommonUtil.clickBtn(driver, XPATH_EDIT_SEARCH_FILTER_BUTTON);
    }

    @Given("^op click Load All Shipment$")
    public void listAllShipment() throws Throwable {
        shipmentManagementPage.setupSort("Id", "Latest first");
        CommonUtil.clickBtn(driver, XPATH_LOAD_ALL_SHIPMENT_BUTTON);
        CommonUtil.pause(3000);
    }

    @When("^shipment ([^\"]*) action button clicked$")
    public void clickActionButton(String actionButton) throws Throwable {

        ShipmentManagementPage.Shipment shipment = shipmentManagementPage.getShipmentFromTable(0);
        id = shipment.getId();
        start = shipment.getStartHub();
        end = shipment.getEndHub();

        shipment.clickShipmentActionButton(actionButton);

    }

    @Then("^shipment edited$")
    public void shipmentEdited() throws Throwable {
        List<ShipmentManagementPage.Shipment> shipments =shipmentManagementPage.getShipmentsFromTable();
        String startHub = "";
        String endHub = "";
        String komen = "";
        for (ShipmentManagementPage.Shipment shipment : shipments) {
            String spId = shipment.getId();

            if (spId.equals(id)) {
                startHub = shipment.getStartHub();
                endHub = shipment.getEndHub();
                komen = shipment.getComment();

            }
        }

        Assert.assertEquals("start hub value", start, startHub);
        Assert.assertEquals("end hub value", end, endHub);
        Assert.assertEquals("comment value", comment, komen);

        CommonUtil.clickBtn(driver, XPATH_EDIT_SEARCH_FILTER_BUTTON);
    }

    @Then("^shipment status is ([^\"]*)$")
    public void checkStatus(String status) throws Throwable {
        List<ShipmentManagementPage.Shipment> shipments =shipmentManagementPage.getShipmentsFromTable();
        String actualStat = "";
        for (ShipmentManagementPage.Shipment shipment : shipments) {
            String spId = shipment.getId();

            if (spId.equals(id)) {
                actualStat = shipment.getStatus();
            }
        }

        Assert.assertEquals("Shipment status", status, actualStat);
        CommonUtil.clickBtn(driver, XPATH_EDIT_SEARCH_FILTER_BUTTON);
    }

    @When("^cancel shipment button clicked$")
    public void clickCancelShipmentButton() throws Throwable {
        CommonUtil.clickBtn(driver, XPATH_CANCEL_SHIPMENT_BUTTON);
    }

    @Then("^shipment deleted$")
    public void isShipmentDeleted() throws Throwable {
        List<ShipmentManagementPage.Shipment> shipments =shipmentManagementPage.getShipmentsFromTable();
        boolean isRemoved = true;
        for (ShipmentManagementPage.Shipment shipment : shipments) {
            String spId = shipment.getId();

            if (spId.equals(id)) {
                isRemoved = false;
            }
        }

        Assert.assertTrue("is Shipment removed", isRemoved);
    }

    @When("^filter ([^\"]*) is ([^\"]*)$")
    public void fillSearchFilter(String filter, String value) throws Throwable {
        CommonUtil.clickBtn(driver, shipmentManagementPage.grabXPathFilter(filter));
        CommonUtil.pause100ms();
        CommonUtil.clickBtn(driver, shipmentManagementPage.grabXPathFilterValue(value));
        CommonUtil.pause100ms();
        CommonUtil.clickBtn(driver, shipmentManagementPage.grabXPathFilter(filter));

        CommonUtil.pause1s();

    }
}
