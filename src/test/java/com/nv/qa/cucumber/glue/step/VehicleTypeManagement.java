package com.nv.qa.cucumber.glue.step;

import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.SeleniumHelper;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.Scenario;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;
import org.openqa.selenium.*;

/**
 * Created by sw on 10/13/16.
 */
@ScenarioScoped
public class VehicleTypeManagement {

    private WebDriver driver;

    @Before
    public void setup() {
        driver = SeleniumSharedDriver.getInstance().getDriver();
    }

    @After
    public void teardown(Scenario scenario) {
        if (scenario.isFailed()) {
            final byte[] screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES);
            scenario.embed(screenshot, "image/png");
        }
    }

    @When("^vehicle type management, add vehicle type button is clicked$")
    public void clickAddContactType() throws Throwable {
        CommonUtil.clickBtn(driver, "//button[@aria-label='Add Vehicle Type']");
    }

    @When("^vehicle type management, add new vehicle type of \"([^\"]*)\"$")
    public void addNewVehicle(String name) {
        SeleniumHelper.waitUntilElementVisible(driver, driver.findElement(By.xpath("//input[@type='text' and @aria-label='Name']")));
        CommonUtil.inputText(driver, "//input[@type='text' and @aria-label='Name']", name);
        CommonUtil.clickBtn(driver, "//button[@type='submit' and @aria-label='Save Button']");
    }

    @Then("^vehicle type management, verify new vehicle type \"([^\"]*)\" existed$")
    public void verifyNewContact(String name) throws Throwable {
        CommonUtil.inputListBox(driver, "Search Vehicle Types...", name);
        verifyVehicle(name);
    }

    @Then("^vehicle type management, verify vehicle type \"([^\"]*)\" existed$")
    public void verifyVehicle(String name) throws Throwable {
        CommonUtil.inputListBox(driver, "Search Vehicle Types...", name);
        WebElement result = CommonUtil.getResultInTable(driver, "//table[@ng-table='ctrl.vehicleTypesTableParams']/tbody/tr", name);
        Assert.assertTrue(result != null);
    }

    @When("^vehicle type management, search for \"([^\"]*)\" vehicle type$")
    public void searchVehicle(String name) throws Throwable {
        CommonUtil.inputListBox(driver, "Search Vehicle Types...", name);
    }

    @When("^vehicle type management, edit vehicle type of \"([^\"]*)\"$")
    public void editButtonIsClicked(String name) {
        WebElement el = CommonUtil.verifySearchingResults(driver, "Search Vehicle Types...", "ctrl.vehicleTypesTableParams");
        WebElement editBtn = el.findElement(By.xpath("//nv-icon-button[@name='Edit']"));
        CommonUtil.pause100ms();
        CommonUtil.moveAndClick(driver, editBtn);

        CommonUtil.inputText(driver, "//input[@type='text' and @aria-label='Name']", name + " [EDITED]");
        CommonUtil.clickBtn(driver, "//button[@type='submit' and @aria-label='Save Button']");
    }

    @When("^vehicle type management, delete vechile type$")
    public void deleteVehicle() {
        WebElement el = CommonUtil.verifySearchingResults(driver, "Search Vehicle Types...", "ctrl.vehicleTypesTableParams");
        WebElement delBtn = el.findElement(By.xpath("//nv-icon-button[@name='Delete']"));
        CommonUtil.pause100ms();
        CommonUtil.moveAndClick(driver, delBtn);
        CommonUtil.pause100ms();
        CommonUtil.clickBtn(driver, "//button[@aria-label='Delete' and .//span='Delete']");
    }

    @Then("^vehicle type management, verify vehicle type \"([^\"]*)\" not existed$")
    public void verifyVehicleNotExisted(String name) throws Throwable {
        CommonUtil.inputListBox(driver, "Search Vehicle Types...", name);
        WebElement result = CommonUtil.getResultInTable(driver, "//table[@ng-table='ctrl.vehicleTypesTableParams']/tbody/tr", name);
        Assert.assertTrue(result == null);
    }
}
