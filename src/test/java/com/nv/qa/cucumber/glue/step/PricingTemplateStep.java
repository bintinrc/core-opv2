package com.nv.qa.cucumber.glue.step;

import com.nv.qa.selenium.page.page.PricingTemplatePage;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.DataTable;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.Date;
import java.util.Map;

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
    private String pricingTemplateLinkedToAShipper;
    private String shipperLinkedToPricingTemplate;

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
        String rules1 = "function getDefaultPrice() {\\n    return 1.2;\\n}";
        String rules1Id = pricingTemplatePage.createDefaultRulesIfNotExists(defaultRulesName1, rulesDescription, rules1);

        String importScript = String.format("importScript(%s);", rules1Id);
        String rules2 = importScript+"\\n\\nfunction calculate(deliveryType, orderType, timeslotType, size, weight, insuredValue, \\ncodValue, fromDp, toDp, fromZone, toZone) {\\n    var price = getDefaultPrice();\\n\\n    if (deliveryType == \"STANDARD\") {\\n        price += 2;\\n    } else if (deliveryType == \"EXPRESS\") {\\n        price += 3;\\n    } else if (deliveryType == \"NEXT_DAY\") {\\n        price += 5;\\n    } else if (deliveryType == \"SAMEDAY\") {\\n        price += 7;\\n    } else {\\n        throw \"Unknown delivery type.\";\\n    }\\n\\n    if (orderType == \"NORMAL\") {\\n        price += 11;\\n    } else if (orderType == \"RETURN\") {\\n        price += 13;\\n    } else if (orderType == \"C2C\") {\\n        price += 17;\\n    } else {\\n        throw \"Unknown order type.\";\\n    }\\n\\n    if (timeslotType == \"NONE\") {\\n        price += 19;\\n    } else if (timeslotType == \"DAY_NIGHT\") {\\n        price += 23;\\n    } else if (timeslotType == \"TIMESLOT\") {\\n        price += 29;\\n    } else {\\n        throw \"Unknown timeslot type.\";\\n    }\\n\\n    if (size == \"S\") {\\n        price += 31;\\n    } else if (size == \"M\") {\\n        price += 37;\\n    } else if (size == \"L\") {\\n        price += 41;\\n    } else if (size == \"XL\") {\\n        price += 43;\\n    } else if (size == \"XXL\") {\\n        price += 47;\\n    } else {\\n        throw \"Unknown size.\";\\n    }\\n\\n    price += weight + 53.4;\\n\\n    return price;\\n}";

        pricingTemplatePage.createDefaultRulesIfNotExists(defaultRulesName2, rulesDescription, rules2);
    }

    @When("^op click Run Test on Operator V2 Portal using this Rules Check below:$")
    public void simulateRunTest(DataTable dataTable)
    {
        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String deliveryType = mapOfData.get("deliveryType");
        String orderType = mapOfData.get("orderType");
        String timeslotType = mapOfData.get("timeslotType");
        String size = mapOfData.get("size");
        String weight = mapOfData.get("weight");
        pricingTemplatePage.simulateRunTest(deliveryType, orderType, timeslotType, size, weight);
    }

    @Then("^op will find the cost equal to \\\"([^\\\"]*)\\\" and the comments equal to \\\"([^\\\"]*)\\\"$")
    public void verifyCostAndComments(String expectedCost, String expectedComments)
    {
        WebElement costEl = CommonUtil.getElementByXpath(driver, "//div[text()='Unit Cost']/following-sibling::div[1]");
        String actualCost = costEl.getText();
        Assert.assertEquals(expectedCost, actualCost);

        WebElement commentsEl = CommonUtil.getElementByXpath(driver, "//div[text()='Comments']/following-sibling::div[1]");
        String actualComments = commentsEl.getText();
        Assert.assertEquals(expectedComments, actualComments);

        CommonUtil.pause1s();
        CommonUtil.clickBtn(driver, "//button[@id='button-cancel-dialog']");
    }

    @When("^op linking Pricing Template \\\"([^\\\"]*)\\\" or \\\"([^\\\"]*)\\\" to shipper \\\"([^\\\"]*)\\\"$")
    public void linkPricingTemplateToShipper(String defaultRulesName1, String defaultRulesName2, String shipperName)
    {
        shipperLinkedToPricingTemplate = shipperName;
        pricingTemplateLinkedToAShipper = pricingTemplatePage.linkPricingTemplateToShipper(defaultRulesName1, defaultRulesName2, shipperName);
    }

    @Then("^Pricing Template linked to the shipper successfully$")
    public void verifyPricingTemplateLinkedToShipperSuccessfully()
    {
        CommonUtil.inputText(driver, "//input[@placeholder='Search rule']", pricingTemplateLinkedToAShipper);
        CommonUtil.pause1s();
        pricingTemplatePage.clickActionButton(1, PricingTemplatePage.ACTION_BUTTON_SHIPPERS);
        CommonUtil.pause1s();
        boolean isPricingTemplateContainShipper = pricingTemplatePage.isPricingTemplateContainShipper(shipperLinkedToPricingTemplate);
        CommonUtil.clickBtn(driver, "//button[@id='button-cancel-dialog']");
        Assert.assertEquals(true, isPricingTemplateContainShipper);
    }
}
