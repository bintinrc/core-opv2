package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.util.TestUtils;
import com.google.inject.Inject;
import com.nv.qa.commons.utils.StandardScenarioStorage;
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
public class VehicleTypeManagementSteps extends AbstractSteps
{
    @Inject
    public VehicleTypeManagementSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
    }

    @When("^vehicle type management, add vehicle type button is clicked$")
    public void clickAddContactType()
    {
        TestUtils.clickBtn(getWebDriver(), "//button[@aria-label='Add Vehicle Type']");
    }

    @When("^vehicle type management, add new vehicle type of \"([^\"]*)\"$")
    public void addNewVehicle(String name)
    {
        TestUtils.waitUntilElementVisible(getWebDriver(), By.xpath("//input[@type='text' and @aria-label='Name']"));
        TestUtils.inputText(getWebDriver(), "//input[@type='text' and @aria-label='Name']", name);
        TestUtils.clickBtn(getWebDriver(), "//button[@type='submit' and @aria-label='Save Button']");
    }

    @Then("^vehicle type management, verify new vehicle type \"([^\"]*)\" existed$")
    public void verifyNewContact(String name)
    {
        TestUtils.inputListBox(getWebDriver(), "Search Vehicle Types...", name);
        verifyVehicle(name);
    }

    @Then("^vehicle type management, verify vehicle type \"([^\"]*)\" existed$")
    public void verifyVehicle(String name)
    {
        TestUtils.inputListBox(getWebDriver(), "Search Vehicle Types...", name);
        WebElement result = TestUtils.getResultInTable(getWebDriver(), "//table[@ng-table='ctrl.vehicleTypesTableParams']/tbody/tr", name);
        Assert.assertTrue(result != null);
    }

    @When("^vehicle type management, search for \"([^\"]*)\" vehicle type$")
    public void searchVehicle(String name)
    {
        TestUtils.inputListBox(getWebDriver(), "Search Vehicle Types...", name);
    }

    @When("^vehicle type management, edit vehicle type of \"([^\"]*)\"$")
    public void editButtonIsClicked(String name)
    {
        WebElement el = TestUtils.verifySearchingResults(getWebDriver(), "Search Vehicle Types...", "ctrl.vehicleTypesTableParams");
        WebElement editBtn = el.findElement(By.xpath("//nv-icon-button[@name='Edit']"));
        pause100ms();
        TestUtils.moveAndClick(getWebDriver(), editBtn);

        TestUtils.inputText(getWebDriver(), "//input[@type='text' and @aria-label='Name']", name + " [EDITED]");
        TestUtils.clickBtn(getWebDriver(), "//button[@type='submit' and @aria-label='Save Button']");
    }

    @When("^vehicle type management, delete vechile type$")
    public void deleteVehicle()
    {
        WebElement el = TestUtils.verifySearchingResults(getWebDriver(), "Search Vehicle Types...", "ctrl.vehicleTypesTableParams");
        WebElement delBtn = el.findElement(By.xpath("//nv-icon-button[@name='Delete']"));
        pause100ms();
        TestUtils.moveAndClick(getWebDriver(), delBtn);
        pause100ms();
        TestUtils.clickBtn(getWebDriver(), "//button[@aria-label='Delete' and .//span='Delete']");
    }

    @Then("^vehicle type management, verify vehicle type \"([^\"]*)\" not existed$")
    public void verifyVehicleNotExisted(String name)
    {
        TestUtils.inputListBox(getWebDriver(), "Search Vehicle Types...", name);
        WebElement result = TestUtils.getResultInTable(getWebDriver(), "//table[@ng-table='ctrl.vehicleTypesTableParams']/tbody/tr", name);
        Assert.assertTrue(result == null);
    }
}
