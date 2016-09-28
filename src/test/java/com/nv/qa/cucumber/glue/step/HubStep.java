package com.nv.qa.cucumber.glue.step;

import com.nv.qa.support.*;
import cucumber.api.Scenario;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;
import org.openqa.selenium.*;

import java.io.File;

/**
 * Created by sw on 8/19/16.
 */
@ScenarioScoped
public class HubStep {

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

    @When("^hubs administration download button is clicked$")
    public void download() {
        CommonUtil.clickBtn(driver, "//div[@filename='hubs.csv']/nv-api-text-button/button");
    }

    @Then("^hubs administration file should exist$")
    public void verifyFile() {
        File f = new File(APIEndpoint.SELENIUM_WRITE_PATH + "hubs.csv");
        boolean isFileExisted = f.exists();
        if (isFileExisted) {
            f.delete();
        }
        Assert.assertTrue(isFileExisted);
    }

    @When("^hubs administration add button is clicked$")
    public void addHub() {
        CommonUtil.clickBtn(driver, "//button[@aria-label='Add Hub']");
    }

    @When("^hubs administration enter default value$")
    public void defaultValue() {
        String tmpId = DateUtil.getCurrentTime_HH_MM_SS();
        ScenarioHelper.getInstance().setTmpId(tmpId);

        CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Hub Name']", String.format("Hub %s", tmpId));
        CommonUtil.inputText(driver, "//input[@type='number'][@aria-label='Latitude']", "1.2843043");
        CommonUtil.inputText(driver, "//input[@type='number'][@aria-label='Longitude']", "103.8095597");
        CommonUtil.clickBtn(driver, "//button[@type='submit'][@aria-label='Save Button']");
    }

    @Then("^hubs administration verify result ([^\"]*)$")
    public void verify(String type) {
        String expectedValue = String.format("Hub %s", ScenarioHelper.getInstance().getTmpId()) + " [EDITED]";
        if (type.equalsIgnoreCase("add")) {
            expectedValue = String.format("Hub %s", ScenarioHelper.getInstance().getTmpId());
        }
        WebElement result = CommonUtil.getResultInTable(driver, "//table[@ng-table='ctrl.hubsTableParams']/tbody/tr", expectedValue);
        Assert.assertTrue(result != null);
    }

    @When("^hubs administration searching for hub$")
    public void searchHub() {
        CommonUtil.inputText(driver,
                "//input[@placeholder='Search Hubs...'][@ng-model='searchText']",
                String.format("Hub %s", ScenarioHelper.getInstance().getTmpId()));

        String txt = String.format("Hub %s", ScenarioHelper.getInstance().getTmpId());
        WebElement result = CommonUtil.getResultInTable(driver, "//table[@ng-table='ctrl.hubsTableParams']/tbody/tr", txt);
        Assert.assertTrue(result != null);
    }

    @When("^hubs administration edit button is clicked$")
    public void clickEditHub() {
        WebElement el = CommonUtil.verifySearchingResults(driver, "Search Hubs...", "ctrl.hubsTableParams");
        WebElement editBtn = el.findElement(By.xpath("//nv-icon-button[@name='Edit']"));
        CommonUtil.pause100ms();
        CommonUtil.moveAndClick(driver, editBtn);

        String editValue = String.format("Hub %s", ScenarioHelper.getInstance().getTmpId()) + " [EDITED]";
        CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Hub Name']", editValue);
        CommonUtil.clickBtn(driver, "//button[@type='submit'][@aria-label='Save Button']");
    }

}