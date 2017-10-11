package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.SeleniumHelper;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;
import org.openqa.selenium.*;

/**
 *
 * @author Soewandi Wirjawan
 *
 * Modified by Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class VehicleTypeManagement extends AbstractSteps
{
    @Inject
    public VehicleTypeManagement(CommonScenario commonScenario)
    {
        super(commonScenario);
    }

    @Override
    public void init()
    {
    }

    @When("^vehicle type management, add vehicle type button is clicked$")
    public void clickAddContactType() throws Throwable
    {
        CommonUtil.clickBtn(getDriver(), "//button[@aria-label='Add Vehicle Type']");
    }

    @When("^vehicle type management, add new vehicle type of \"([^\"]*)\"$")
    public void addNewVehicle(String name)
    {
        SeleniumHelper.waitUntilElementVisible(getDriver(), By.xpath("//input[@type='text' and @aria-label='Name']"));
        CommonUtil.inputText(getDriver(), "//input[@type='text' and @aria-label='Name']", name);
        CommonUtil.clickBtn(getDriver(), "//button[@type='submit' and @aria-label='Save Button']");
    }

    @Then("^vehicle type management, verify new vehicle type \"([^\"]*)\" existed$")
    public void verifyNewContact(String name) throws Throwable
    {
        CommonUtil.inputListBox(getDriver(), "Search Vehicle Types...", name);
        verifyVehicle(name);
    }

    @Then("^vehicle type management, verify vehicle type \"([^\"]*)\" existed$")
    public void verifyVehicle(String name) throws Throwable
    {
        CommonUtil.inputListBox(getDriver(), "Search Vehicle Types...", name);
        WebElement result = CommonUtil.getResultInTable(getDriver(), "//table[@ng-table='ctrl.vehicleTypesTableParams']/tbody/tr", name);
        Assert.assertTrue(result != null);
    }

    @When("^vehicle type management, search for \"([^\"]*)\" vehicle type$")
    public void searchVehicle(String name) throws Throwable {
        CommonUtil.inputListBox(getDriver(), "Search Vehicle Types...", name);
    }

    @When("^vehicle type management, edit vehicle type of \"([^\"]*)\"$")
    public void editButtonIsClicked(String name)
    {
        WebElement el = CommonUtil.verifySearchingResults(getDriver(), "Search Vehicle Types...", "ctrl.vehicleTypesTableParams");
        WebElement editBtn = el.findElement(By.xpath("//nv-icon-button[@name='Edit']"));
        CommonUtil.pause100ms();
        CommonUtil.moveAndClick(getDriver(), editBtn);

        CommonUtil.inputText(getDriver(), "//input[@type='text' and @aria-label='Name']", name + " [EDITED]");
        CommonUtil.clickBtn(getDriver(), "//button[@type='submit' and @aria-label='Save Button']");
    }

    @When("^vehicle type management, delete vechile type$")
    public void deleteVehicle()
    {
        WebElement el = CommonUtil.verifySearchingResults(getDriver(), "Search Vehicle Types...", "ctrl.vehicleTypesTableParams");
        WebElement delBtn = el.findElement(By.xpath("//nv-icon-button[@name='Delete']"));
        CommonUtil.pause100ms();
        CommonUtil.moveAndClick(getDriver(), delBtn);
        CommonUtil.pause100ms();
        CommonUtil.clickBtn(getDriver(), "//button[@aria-label='Delete' and .//span='Delete']");
    }

    @Then("^vehicle type management, verify vehicle type \"([^\"]*)\" not existed$")
    public void verifyVehicleNotExisted(String name) throws Throwable
    {
        CommonUtil.inputListBox(getDriver(), "Search Vehicle Types...", name);
        WebElement result = CommonUtil.getResultInTable(getDriver(), "//table[@ng-table='ctrl.vehicleTypesTableParams']/tbody/tr", name);
        Assert.assertTrue(result == null);
    }
}
