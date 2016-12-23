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
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

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

        WebElement toast = CommonUtil.getToast(driver);
        Assert.assertTrue("toast message not contains Shipment xxx created", toast.getText().contains("Shipment") && toast.getText().contains("created"));
        id = toast.getText().split(" ")[1];
    }

    @Given("^op click Load All Shipment$")
    public void listAllShipment() throws Throwable {
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
        List<WebElement> toasts = CommonUtil.getToasts(driver);
        String text = "";
        for (WebElement toast : toasts) {
            text = toast.getText();
            if (text.contains("Success changed status to Cancelled for Shipment ID " + id)) {
                break;
            }
        }
        Assert.assertTrue("toast message not contains Cancelled", text.contains("Success changed status to Cancelled for Shipment ID " + id));
        CommonUtil.pause(5000);
    }

    @Then("^shipment deleted$")
    public void isShipmentDeleted() throws Throwable {

        String msg = "Success delete Shipping ID " + id;
        WebElement toast = CommonUtil.getToast(driver);
        Assert.assertTrue("toast message not contains " + msg, toast.getText().contains(msg));

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
        shipmentManagementPage.clickAddFilter(filter, value);
//        CommonUtil.clickBtn(driver, shipmentManagementPage.grabXPathFilter(filter));
//        CommonUtil.pause1s();
//        CommonUtil.inputText(driver, shipmentManagementPage.grabXPathFilterTF(filter), value);
//        CommonUtil.pause1s();
//        CommonUtil.clickBtn(driver, shipmentManagementPage.grabXPathFilterDropdown(value));

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
        if (driver.findElement(By.xpath(ShipmentManagementPage.XPATH_CLEAR_FILTER_BUTTON)).isDisplayed()){
            if (driver.findElement(By.xpath(ShipmentManagementPage.XPATH_CLEAR_FILTER_VALUE)).isDisplayed()){
                List<WebElement> clearValueBtnList = driver.findElements(By.xpath(ShipmentManagementPage.XPATH_CLEAR_FILTER_VALUE));
                for (WebElement clearBtn : clearValueBtnList) {
                    clearBtn.click();
                    CommonUtil.pause1s();
                }
            }

            CommonUtil.clickBtn(driver, ShipmentManagementPage.XPATH_CLEAR_FILTER_BUTTON);
        }
        CommonUtil.pause(2000);
    }
}
