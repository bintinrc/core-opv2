package com.nv.qa.cucumber.glue.step;

import com.nv.qa.support.*;
import cucumber.api.java.Before;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;
import org.openqa.selenium.*;

import java.io.File;

/**
 *
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class HubStep
{
    private static final int MAX_RETRY = 10;
    private static final String HUBS_CSV_FILE_NAME = "hubs.csv";
    private static final String HUBS_CSV_FILE_NAME_LOCATION = APIEndpoint.SELENIUM_WRITE_PATH + HUBS_CSV_FILE_NAME;

    private WebDriver driver;

    @Before
    public void setup()
    {
        driver = SeleniumSharedDriver.getInstance().getDriver();
    }

    @When("^hubs administration download button is clicked$")
    public void download()
    {
        CommonUtil.deleteFile(HUBS_CSV_FILE_NAME_LOCATION);
        CommonUtil.clickBtn(driver, String.format("//div[@filename='%s']/nv-api-text-button/button", HUBS_CSV_FILE_NAME));
        CommonUtil.pause1s();
    }

    @Then("^hubs administration file should exist$")
    public void verifyFile()
    {
        File file = new File(HUBS_CSV_FILE_NAME_LOCATION);
        int counter = 0;
        boolean isFileExists;

        do
        {
            isFileExists = file.exists();

            if(!isFileExists)
            {
                CommonUtil.pause1s();
            }

            counter++;
        }
        while(!isFileExists && counter<MAX_RETRY);

        CommonUtil.deleteFile(file);
        Assert.assertTrue(HUBS_CSV_FILE_NAME_LOCATION + " not exist", isFileExists);
    }

    @When("^hubs administration add button is clicked$")
    public void addHub() {
        CommonUtil.clickBtn(driver, "//button[@aria-label='Add Hub']");
    }

    @When("^hubs administration enter default value$")
    public void defaultValue() {
        String tmpId = DateUtil.getCurrentTime_HH_MM_SS();
        ScenarioHelper.getInstance().setTmpId(tmpId);

        CommonUtil.inputText(driver, "//input[@type='text' and @id='hub-name-1']", String.format("Hub %s", tmpId));
        CommonUtil.inputText(driver, "//input[@type='number' and @id='latitude-1']", "1.2843043");
        CommonUtil.inputText(driver, "//input[@type='number' and @id='longitude-2']", "103.8095597");
        CommonUtil.clickBtn(driver, "//button[@type='submit' and @aria-label='Save Button']");
    }

    @Then("^hubs administration verify result ([^\"]*)$")
    public void verify(String type) {
        String expectedValue = String.format("Hub %s", ScenarioHelper.getInstance().getTmpId()) + " [EDITED]";
        if (type.equalsIgnoreCase("add")) {
            expectedValue = String.format("Hub %s", ScenarioHelper.getInstance().getTmpId());
        }

        CommonUtil.inputText(driver, "//input[@placeholder='Search Hubs...']", expectedValue);
        CommonUtil.pause1s();

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