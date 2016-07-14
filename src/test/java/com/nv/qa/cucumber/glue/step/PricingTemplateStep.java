package com.nv.qa.cucumber.glue.step;

import com.nv.qa.selenium.page.page.PricingTemplatePage;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.java.Before;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.util.Date;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class PricingTemplateStep
{
    private WebDriver driver;
    private PricingTemplatePage pricingTemplatePage;
    private String newPricingTemplateName;

    @Before
    public void setup()
    {
        driver = SeleniumSharedDriver.getInstance().getDriver();
        pricingTemplatePage = new PricingTemplatePage(driver);
    }

    @When("^op create new rules on Pricing Template$")
    public void createNewRules()
    {
        newPricingTemplateName = "Cucumber PT #"+new Date().getTime();
        CommonUtil.clickBtn(driver, "//button[@aria-label='Create Rules']");
        CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Name']", newPricingTemplateName);
        CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Description']", "Create by Cucumber with Selenium.");
        CommonUtil.clickBtn(driver, "//nv-api-text-button[@name='Save']");
    }

    @Then("^new rules on Pricing Template created successfully$")
    public void verifyNewPricingTemplateCreatedSuccessfully()
    {
        CommonUtil.inputText(driver, "//input[@placeholder='Search rule']", newPricingTemplateName);
        CommonUtil.pause1s();
        String pricingTemplateNameFromTable = pricingTemplatePage.getTextOnTable(1, "ctrl.table.name");
        Assert.assertEquals(newPricingTemplateName, pricingTemplateNameFromTable);
    }

    @When("^op update rules on Pricing Template$")
    public void updateRules()
    {
        newPricingTemplateName += " [EDITED]";
        pricingTemplatePage.clickActionButton(1, PricingTemplatePage.ACTION_BUTTON_EDIT);
        CommonUtil.pause1s();
        CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Name']", newPricingTemplateName);
        CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Description']", "Create by Cucumber with Selenium. [EDITED]");
        CommonUtil.clickBtn(driver, "//nv-api-text-button[@name='Update']");
    }

    @Then("^rules on Pricing Template updated successfully$")
    public void verifyPricingTemplateUpdatedSuccessfully()
    {
        System.out.println("TEMPLATE NAME: "+newPricingTemplateName);
        CommonUtil.inputText(driver, "//input[@placeholder='Search rule']", newPricingTemplateName);
        CommonUtil.pause1s();
        String pricingTemplateNameFromTable = pricingTemplatePage.getTextOnTable(1, "ctrl.table.name");
        Assert.assertEquals(newPricingTemplateName, pricingTemplateNameFromTable);
    }

    @When("^op delete rules on Pricing Template$")
    public void deleteRules()
    {
        CommonUtil.inputText(driver, "//input[@placeholder='Search rule']", newPricingTemplateName);
        CommonUtil.pause1s();
        pricingTemplatePage.clickActionButton(1, PricingTemplatePage.ACTION_BUTTON_DELETE);
        CommonUtil.pause1s();
        CommonUtil.clickBtn(driver, "//button[@type='button'][@aria-label='Delete']");
        CommonUtil.pause1s();

    }

    @Then("^rules on Pricing Template deleted successfully$")
    public void verifyPricingTemplateDeletedSuccessfully()
    {
        CommonUtil.inputText(driver, "//input[@placeholder='Search rule']", newPricingTemplateName);
        CommonUtil.pause1s();
        String expectedValue = null;
        String pricingTemplateNameFromTable = pricingTemplatePage.getTextOnTable(1, "ctrl.table.name");
        Assert.assertEquals(expectedValue, pricingTemplateNameFromTable);
    }
}
