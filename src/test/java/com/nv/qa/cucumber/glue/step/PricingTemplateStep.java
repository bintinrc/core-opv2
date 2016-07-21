package com.nv.qa.cucumber.glue.step;

import com.nv.qa.selenium.page.page.PricingTemplatePage;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
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
        pricingTemplatePage.createRules(newPricingTemplateName, "Create by Cucumber with Selenium.");
    }

    @Then("^new rules on Pricing Template created successfully$")
    public void verifyNewPricingTemplateCreatedSuccessfully()
    {
        String pricingTemplateNameFromTable = pricingTemplatePage.searchAndGetTextOnTable(newPricingTemplateName, 1, "ctrl.table.name");
        Assert.assertEquals(newPricingTemplateName, pricingTemplateNameFromTable);
    }

    @When("^op update rules on Pricing Template$")
    public void updateRules()
    {
        newPricingTemplateName += " [EDITED]";
        pricingTemplatePage.updateRules(1, newPricingTemplateName, "Create by Cucumber with Selenium. [EDITED]");
    }

    @Then("^rules on Pricing Template updated successfully$")
    public void verifyPricingTemplateUpdatedSuccessfully()
    {
        String pricingTemplateNameFromTable = pricingTemplatePage.searchAndGetTextOnTable(newPricingTemplateName, 1, "ctrl.table.name");
        Assert.assertEquals(newPricingTemplateName, pricingTemplateNameFromTable);
    }

    @When("^op delete rules on Pricing Template$")
    public void deleteRules()
    {
        pricingTemplatePage.searchAndDeleteRules(1, newPricingTemplateName);
    }

    @Then("^rules on Pricing Template deleted successfully$")
    public void verifyPricingTemplateDeletedSuccessfully()
    {
        String expectedValue = null;
        String pricingTemplateNameFromTable = pricingTemplatePage.searchAndGetTextOnTable(newPricingTemplateName, 1, "ctrl.table.name");
        Assert.assertEquals(expectedValue, pricingTemplateNameFromTable);
    }

    @Given("^op have two default rules \\\"([^\\\"]*)\\\" and \\\"([^\\\"]*)\\\"$")
    public void createDefaultTwoRulesIfNotExists(String defaultRulesName1, String defaultRulesName2)
    {
        String rulesDescription = "Please don't touch this rules. This rules created by Cucumber with Selenium for testing purpose.";
        String rules1 = "function getDefaultPrice() {\\n    return 987.6;\\n}";
        String rules1Id = pricingTemplatePage.createDefaultRulesIfNotExists(defaultRulesName1, rulesDescription, rules1);

        String importScript = String.format("importScript(%s);", rules1Id);
        String rules2 = importScript+"\\nfunction calculate(deliveryType, orderType, timeSlot, size, weight, insuredValue, \\ncodValue, fromDp, toDp, fromZone, toZone) {\\n    var price = getDefaultPrice();\\n\\n    // order type\\n    if (deliveryType == \"STANDARD\") {\\n        price = 8;\\n    } else if (deliveryType == \"EXPRESS\") {\\n        price = 9;\\n    } else if (deliveryType == \"NEXT_DAY\") {\\n        price = 11;\\n    } else if (deliveryType == \"SAMEDAY\") {\\n        price = 12;\\n    } else {\\n        throw \"Unknown order type.\";\\n    }\\n\\n    // size\\n    if (size == \"S\") {\\n        // initial price is for smallest size already (hence we do nothing here)\\n    } else if (size == \"M\") {\\n        price += 1.5;\\n    } else if (size == \"L\") {\\n        price += 4.5;\\n    } else if (size == \"XL\") {\\n        price += 12;\\n    } else if (size == \"XXL\") {\\n        price += 16; // nothing in the document for XXL\\n    } else {\\n        throw \"Unknown size.\";\\n    }\\n\\n    return price;}";

        pricingTemplatePage.createDefaultRulesIfNotExists(defaultRulesName2, rulesDescription, rules2);
    }

    @When("^do nothing$")
    public void whenDoNothing()
    {
    }

    @Then("^do something")
    public void thenDoSomething()
    {
    }
}
