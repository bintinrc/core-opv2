package com.nv.qa.cucumber.glue.step;

import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.SeleniumHelper;
import com.nv.qa.support.SeleniumSharedDriver;
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
public class ContactTypeManagementStep {

    private WebDriver driver;

    @Before
    public void setup() {
        driver = SeleniumSharedDriver.getInstance().getDriver();
    }

    @When("^contact type management, add contact type button is clicked$")
    public void clickAddContactType() throws Throwable {
        CommonUtil.clickBtn(driver, "//button[@aria-label='Add Contact Type']");
    }

    @When("^contact type management, add new contact type of \"([^\"]*)\"$")
    public void addNewContact(String name) {
        SeleniumHelper.waitUntilElementVisible(driver, driver.findElement(By.xpath("//input[@type='text' and @aria-label='Name']")));
        CommonUtil.inputText(driver, "//input[@type='text' and @aria-label='Name']", name);
        CommonUtil.clickBtn(driver, "//button[@type='submit' and @aria-label='Save Button']");
    }

    @Then("^contact type management, verify new contact type \"([^\"]*)\" existed$")
    public void verifyNewContact(String name) throws Throwable {
        CommonUtil.inputListBox(driver, "Search Contact Types...", name);
        verifyContact(name);
    }

    @When("^contact type management, search for \"([^\"]*)\" contact type$")
    public void searchContact(String name) throws Throwable {
        CommonUtil.inputListBox(driver, "Search Contact Types...", name);
    }

    @Then("^contact type management, verify contact type \"([^\"]*)\" existed$")
    public void verifyContact(String name) throws Throwable {
        CommonUtil.inputListBox(driver, "Search Contact Types...", name);
        WebElement result = CommonUtil.getResultInTable(driver, "//table[@ng-table='ctrl.contactTypesTableParams']/tbody/tr", name);
        Assert.assertTrue(result != null);
    }

    @When("^contact type management, edit contact type of \"([^\"]*)\"$")
    public void editButtonIsClicked(String name) {
        WebElement el = CommonUtil.verifySearchingResults(driver, "Search Contact Types...", "ctrl.contactTypesTableParams");
        WebElement editBtn = el.findElement(By.xpath("//nv-icon-button[@name='Edit']"));
        CommonUtil.pause100ms();
        CommonUtil.moveAndClick(driver, editBtn);

        CommonUtil.inputText(driver, "//input[@type='text' and @aria-label='Name']", name + " [EDITED]");
        CommonUtil.clickBtn(driver, "//button[@type='submit' and @aria-label='Save Button']");
    }

    @When("^contact type management, delete contact type$")
    public void deleteContact() {
        WebElement el = CommonUtil.verifySearchingResults(driver, "Search Contact Types...", "ctrl.contactTypesTableParams");
        WebElement delBtn = el.findElement(By.xpath("//nv-icon-button[@name='Delete']"));
        CommonUtil.pause100ms();
        CommonUtil.moveAndClick(driver, delBtn);
        CommonUtil.pause100ms();
        CommonUtil.clickBtn(driver, "//button[@aria-label='Delete' and .//span='Delete']");
    }

    @Then("^contact type management, verify contact type \"([^\"]*)\" not existed$")
    public void verifyContactNotExisted(String name) throws Throwable {
        CommonUtil.inputListBox(driver, "Search Contact Types...", name);
        WebElement result = CommonUtil.getResultInTable(driver, "//table[@ng-table='ctrl.contactTypesTableParams']/tbody/tr", name);
        Assert.assertTrue(result == null);
    }
}
