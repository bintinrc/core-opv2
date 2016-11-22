package com.nv.qa.cucumber.glue.step;

import com.nv.qa.selenium.page.page.ShipmentManagementPage;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;
import org.openqa.selenium.*;

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

    @When("^create shipment button is clicked$")
    public void ClickCreateShipmentButton() throws Throwable {
        CommonUtil.clickBtn(driver, XPATH_CREATE_SHIPMENT_BUTTON);
    }

    @When("^create Shipment with Start Hub ([^\"]*), End hub ([^\"]*) and comment ([^\"]*)$")
    public void createShipment(String startHub, String endHub, String comment) throws Throwable {

        shipmentManagementPage.selectFirstLineHaul();
        CommonUtil.pause1s();
        shipmentManagementPage.selectStartHub(startHub);
        CommonUtil.pause1s();
        shipmentManagementPage.selectEndHub(endHub);
        CommonUtil.pause1s();
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
        WebElement toast = driver.findElement(By.xpath("//div[@id='toast-container']//div[contains(text(),'Shipment') and contains(text(),'created')]"));
        Assert.assertNotNull("toast info not shown", toast);
        id = toast.getText().split(" ")[1];
    }

    @Given("^op click Load All Shipment$")
    public void listAllShipment() throws Throwable {
        shipmentManagementPage.setupSort("Id", "Latest first");
        CommonUtil.clickBtn(driver, XPATH_LOAD_ALL_SHIPMENT_BUTTON);
        CommonUtil.pause(3000);
    }

    @When("^shipment ([^\"]*) action button clicked$")
    public void clickActionButton(String actionButton) throws Throwable {

        List<ShipmentManagementPage.Shipment> shipments =shipmentManagementPage.getShipmentsFromTable();

        for (ShipmentManagementPage.Shipment shipment : shipments) {
            if (shipment.getId().equals(id)) {
                shipment.clickShipmentActionButton(actionButton);
                break;
            }
        }

        CommonUtil.pause(3000);

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
    }

    @Then("^shipment status is ([^\"]*)$")
    public void checkStatus(String status) throws Throwable {
        List<ShipmentManagementPage.Shipment> shipments =shipmentManagementPage.getShipmentsFromTable();
        String actualStat = "";
        for (ShipmentManagementPage.Shipment shipment : shipments) {
            String spId = shipment.getId();

            if (spId.equals(id)) {
                actualStat = shipment.getStatus();
                break;
            }
        }

        Assert.assertEquals("Shipment " + id + " status", status, actualStat);
    }

    @When("^cancel shipment button clicked$")
    public void clickCancelShipmentButton() throws Throwable {
        CommonUtil.clickBtn(driver, XPATH_CANCEL_SHIPMENT_BUTTON);
        CommonUtil.pause(5000);
    }

    @Then("^shipment deleted$")
    public void isShipmentDeleted() throws Throwable {

        WebElement toast = driver.findElement(By.xpath("//div[@id='toast-container']//div[contains(text(),'Success delete Shipping ID " + id + "')]"));
        Assert.assertNotNull("toast info not shown", toast);

        List<ShipmentManagementPage.Shipment> shipments = shipmentManagementPage.getShipmentsFromTable();
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
        CommonUtil.pause1s();
        CommonUtil.inputText(driver, shipmentManagementPage.grabXPathFilterTF(filter), value);
        CommonUtil.pause1s();
        CommonUtil.clickBtn(driver, shipmentManagementPage.grabXPathFilterDropdown(value));

        CommonUtil.pause1s();

    }

    @Given("^op click edit filter$")
    public void op_click_edit_filter() throws Throwable {
        shipmentManagementPage.clickEditSearchFilterButton();
        CommonUtil.pause1s();
    }

    @Then("^shipment scan with source ([^\"]*) in hub ([^\"]*)$")
    public void shipment_scan_with_source_VAN_INBOUND_in_hub_JKB(String source, String hub) throws Throwable {
        try {
            shipmentManagementPage.shipmentScanExist(source, hub);
        } finally {
            close_scan_modal();
        }
    }

    public void close_scan_modal() throws Throwable {
        CommonUtil.clickBtn(driver, ShipmentManagementPage.XPATH_CLOSE_SCAN_MODAL_BUTTON);
        CommonUtil.pause1s();
    }

    @When("^clear filter$")
    public void clear_filter() throws Throwable {
        try {
            CommonUtil.clickBtn(driver, ShipmentManagementPage.XPATH_CLEAR_FILTER_BUTTON);
        } catch (Exception ignored) {
        }
        CommonUtil.pause(2000);
    }
}
