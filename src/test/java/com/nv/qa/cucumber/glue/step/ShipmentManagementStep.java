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

    @When("^create Shipment with Start Hub ([^\"]*) and End hub ([^\"]*)$")
    public void createShipment(String startHub, String endHub) throws Throwable {

        shipmentManagementPage.selectStartHub(startHub);
        CommonUtil.pause10ms();
        shipmentManagementPage.selectEndHub(endHub);
        CommonUtil.pause10ms();
        CommonUtil.inputText(driver, XPATH_COMMENT_TEXT_AREA, "AUTOMATION TEST");

        CommonUtil.clickBtn(driver, XPATH_CREATE_SHIPMENT_CONFIRMATION_BUTTON);
        CommonUtil.pause1s();

    }

    @When("^edit Shipment with Start Hub ([^\"]*) and End hub ([^\"]*)$")
    public void editShipment(String startHub, String endHub) throws Throwable {

        shipmentManagementPage.selectStartHub(startHub);
        CommonUtil.pause10ms();
        shipmentManagementPage.selectEndHub(endHub);
        CommonUtil.pause10ms();
        CommonUtil.inputText(driver, XPATH_COMMENT_TEXT_AREA, "AUTOMATION TEST");

        start = startHub;
        end = endHub;

        CommonUtil.clickBtn(driver, XPATH_SAVE_CHANGES_BUTTON);
        CommonUtil.pause1s();

    }

    @Then("^shipment created$")
    public void shipmentCreated() throws Throwable {
        Assert.assertNotNull(driver.findElement(By.xpath("//div[@ng-if=\"nvLoad.status === 'loaded'\"][@aria-hidden=\"false\"]")));
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

        WebElement shipment =shipmentManagementPage.grabShipments().get(0);
        id = shipment.findElements(By.tagName("td")).get(2).findElement(By.tagName("span")).getText();
        start = shipment.findElements(By.tagName("td")).get(5).findElement(By.tagName("span")).getText();
        end = shipment.findElements(By.tagName("td")).get(8).findElement(By.tagName("span")).getText();

        shipmentManagementPage.clickShipmentActionButton(shipment, actionButton);
        CommonUtil.pause1s();

        if (actionButton.equals(shipmentManagementPage.DELETE_ACTION)) {
            CommonUtil.clickBtn(driver, XPATH_DELETE_CONFIRMATION_BUTTON);
        }
    }

    @Then("^shipment edited$")
    public void shipmentEdited() throws Throwable {
        List<WebElement> shipments =shipmentManagementPage.grabShipments();
        String startHub = "";
        String endHub = "";
        for (WebElement shipment : shipments) {
            String spId = shipment.findElements(By.tagName("td")).get(2).findElement(By.tagName("span")).getText();

            if (spId.equals(id)) {
                startHub = shipment.findElements(By.tagName("td")).get(5).findElement(By.tagName("span")).getText();
                endHub = shipment.findElements(By.tagName("td")).get(8).findElement(By.tagName("span")).getText();

            }
        }

        Assert.assertEquals(start, startHub);
        Assert.assertEquals(end, endHub);

        CommonUtil.clickBtn(driver, XPATH_EDIT_SEARCH_FILTER_BUTTON);
    }

    @Then("^shipment status is ([^\"]*)$")
    public void checkStatus(String status) throws Throwable {
        List<WebElement> shipments =shipmentManagementPage.grabShipments();
        String actualStat = "";
        for (WebElement shipment : shipments) {
            String spId = shipment.findElements(By.tagName("td")).get(2).findElement(By.tagName("span")).getText();

            if (spId.equals(id)) {
                actualStat = shipment.findElements(By.tagName("td")).get(4).findElement(By.tagName("span")).getText();
            }
        }

        Assert.assertEquals(status, actualStat);
        CommonUtil.clickBtn(driver, XPATH_EDIT_SEARCH_FILTER_BUTTON);
    }

    @When("^cancel shipment button clicked$")
    public void clickCancelShipmentButton() throws Throwable {
        CommonUtil.clickBtn(driver, XPATH_CANCEL_SHIPMENT_BUTTON);
    }

    @Then("^shipment deleted$")
    public void isShipmentDeleted() throws Throwable {
        List<WebElement> shipments =shipmentManagementPage.grabShipments();
        boolean isRemoved = true;
        for (WebElement shipment : shipments) {
            String spId = shipment.findElements(By.tagName("td")).get(2).findElement(By.tagName("span")).getText();

            if (spId.equals(id)) {
                isRemoved = false;
            }
        }

        Assert.assertTrue(isRemoved);
    }
}
