package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.util.TestUtils;
import com.google.inject.Inject;
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
public class ContactTypeManagementSteps extends AbstractSteps
{
    @Inject
    public ContactTypeManagementSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
    }

    @When("^contact type management, add contact type button is clicked$")
    public void clickAddContactType() throws Throwable
    {
        TestUtils.clickBtn(getWebDriver(), "//button[@aria-label='Add Contact Type']");
    }

    @When("^contact type management, add new contact type of \"([^\"]*)\"$")
    public void addNewContact(String name)
    {
        TestUtils.waitUntilElementVisible(getWebDriver(), By.xpath("//input[@type='text' and @aria-label='Name']"));
        TestUtils.inputText(getWebDriver(), "//input[@type='text' and @aria-label='Name']", name);
        TestUtils.clickBtn(getWebDriver(), "//button[@type='submit' and @aria-label='Save Button']");
    }

    @Then("^contact type management, verify new contact type \"([^\"]*)\" existed$")
    public void verifyNewContact(String name) throws Throwable
    {
        TestUtils.inputListBox(getWebDriver(), "Search Contact Types...", name);
        verifyContact(name);
    }

    @When("^contact type management, search for \"([^\"]*)\" contact type$")
    public void searchContact(String name) throws Throwable
    {
        TestUtils.inputListBox(getWebDriver(), "Search Contact Types...", name);
    }

    @Then("^contact type management, verify contact type \"([^\"]*)\" existed$")
    public void verifyContact(String name) throws Throwable
    {
        TestUtils.inputListBox(getWebDriver(), "Search Contact Types...", name);
        WebElement result = TestUtils.getResultInTable(getWebDriver(), "//table[@ng-table='ctrl.contactTypesTableParams']/tbody/tr", name);
        Assert.assertTrue(result != null);
    }

    @When("^contact type management, edit contact type of \"([^\"]*)\"$")
    public void editButtonIsClicked(String name)
    {
        WebElement el = TestUtils.verifySearchingResults(getWebDriver(), "Search Contact Types...", "ctrl.contactTypesTableParams");
        WebElement editBtn = el.findElement(By.xpath("//nv-icon-button[@name='Edit']"));
        TestUtils.pause100ms();
        TestUtils.moveAndClick(getWebDriver(), editBtn);

        TestUtils.inputText(getWebDriver(), "//input[@type='text' and @aria-label='Name']", name + " [EDITED]");
        TestUtils.clickBtn(getWebDriver(), "//button[@type='submit' and @aria-label='Save Button']");
    }

    @When("^contact type management, delete contact type$")
    public void deleteContact()
    {
        WebElement el = TestUtils.verifySearchingResults(getWebDriver(), "Search Contact Types...", "ctrl.contactTypesTableParams");
        WebElement delBtn = el.findElement(By.xpath("//nv-icon-button[@name='Delete']"));
        TestUtils.pause100ms();
        TestUtils.moveAndClick(getWebDriver(), delBtn);
        TestUtils.pause100ms();
        TestUtils.clickBtn(getWebDriver(), "//button[@aria-label='Delete' and .//span='Delete']");
    }

    @Then("^contact type management, verify contact type \"([^\"]*)\" not existed$")
    public void verifyContactNotExisted(String name) throws Throwable
    {
        TestUtils.inputListBox(getWebDriver(), "Search Contact Types...", name);
        WebElement result = TestUtils.getResultInTable(getWebDriver(), "//table[@ng-table='ctrl.contactTypesTableParams']/tbody/tr", name);
        Assert.assertTrue(result == null);
    }
}
