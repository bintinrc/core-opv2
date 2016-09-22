package com.nv.qa.cucumber.glue.step;

import com.nv.qa.selenium.page.page.PricingScriptsPage;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.DataTable;
import cucumber.api.Scenario;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.Date;
import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class PricingScriptsStep
{
    private WebDriver driver;
    private PricingScriptsPage pricingScriptsPage;
    private String newPricingScriptsName;
    private String pricingScriptsLinkedToAShipper;
    private String shipperLinkedToPricingScripts;

    @Before
    public void setup()
    {
        driver = SeleniumSharedDriver.getInstance().getDriver();
        pricingScriptsPage = new PricingScriptsPage(driver);
    }

    @After
    public void teardown(Scenario scenario) {
        if (scenario.isFailed()) {
            final byte[] screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES);
            scenario.embed(screenshot, "image/png");
        }
    }

    @When("^op create new script on Pricing Scripts$")
    public void createNewScript()
    {
        newPricingScriptsName = "Cucumber Script #"+new Date().getTime();
        pricingScriptsPage.createScript(newPricingScriptsName, "Create by Cucumber with Selenium.");
    }

    @Then("^new script on Pricing Scripts created successfully$")
    public void verifyNewPricingScriptsCreatedSuccessfully()
    {
        String pricingScriptsNameFromTable = pricingScriptsPage.searchAndGetTextOnTable(newPricingScriptsName, 1, "name");
        Assert.assertEquals(newPricingScriptsName, pricingScriptsNameFromTable);
    }

    @When("^op update script on Pricing Scripts$")
    public void updateScript()
    {
        newPricingScriptsName += " [EDITED]";
        pricingScriptsPage.updateScript(1, newPricingScriptsName, "Create by Cucumber with Selenium. [EDITED]");
    }

    @Then("^script on Pricing Scripts updated successfully$")
    public void verifyPricingScriptsUpdatedSuccessfully()
    {
        String pricingScriptsNameFromTable = pricingScriptsPage.searchAndGetTextOnTable(newPricingScriptsName, 1, "name");
        Assert.assertEquals(newPricingScriptsName, pricingScriptsNameFromTable);
    }

    @When("^op delete script on Pricing Scripts$")
    public void deleteScript()
    {
        pricingScriptsPage.searchAndDeleteScript(1, newPricingScriptsName);
    }

    @Then("^script on Pricing Scripts deleted successfully$")
    public void verifyPricingScriptsDeletedSuccessfully()
    {
        String expectedValue = null;
        String pricingScriptsNameFromTable = pricingScriptsPage.searchAndGetTextOnTable(newPricingScriptsName, 1, "name");
        Assert.assertEquals(expectedValue, pricingScriptsNameFromTable);
    }

    @Given("^op have two default script \\\"([^\\\"]*)\\\" and \\\"([^\\\"]*)\\\"$")
    public void createDefaultTwoScriptIfNotExists(String defaultScriptName1, String defaultScriptName2)
    {
        String scriptDescription = "Please don't touch this script. This script created by Cucumber with Selenium for testing purpose.";
        String script1 = "function getDefaultPrice() {\\n    return 1.2;\\n}";
        String script1Id = pricingScriptsPage.createDefaultScriptIfNotExists(defaultScriptName1, scriptDescription, script1);

        String importScript = String.format("importScript(%s);", script1Id);
        String script2 = importScript+"\\n\\nfunction calculate(deliveryType, orderType, timeslotType, size, weight,\\n    fromZone, toZone) {\\n    var price = getDefaultPrice();\\n\\n    if (deliveryType == \"STANDARD\") {\\n        price += 2;\\n    } else if (deliveryType == \"EXPRESS\") {\\n        price += 3;\\n    } else if (deliveryType == \"NEXT_DAY\") {\\n        price += 5;\\n    } else if (deliveryType == \"SAME_DAY\") {\\n        price += 7;\\n    } else {\\n        throw \"Unknown delivery type.\";\\n    }\\n\\n    if (orderType == \"NORMAL\") {\\n        price += 11;\\n    } else if (orderType == \"RETURN\") {\\n        price += 13;\\n    } else if (orderType == \"C2C\") {\\n        price += 17;\\n    } else {\\n        throw \"Unknown order type.\";\\n    }\\n\\n    if (timeslotType == \"NONE\") {\\n        price += 19;\\n    } else if (timeslotType == \"DAY_NIGHT\") {\\n        price += 23;\\n    } else if (timeslotType == \"TIMESLOT\") {\\n        price += 29;\\n    } else {\\n        throw \"Unknown timeslot type.\";\\n    }\\n\\n    if (size == \"S\") {\\n        price += 31;\\n    } else if (size == \"M\") {\\n        price += 37;\\n    } else if (size == \"L\") {\\n        price += 41;\\n    } else if (size == \"XL\") {\\n        price += 43;\\n    } else if (size == \"XXL\") {\\n        price += 47;\\n    } else {\\n        throw \"Unknown size.\";\\n    }\\n\\n    price += weight + 53.4;\\n\\n    return price;\\n}";

        pricingScriptsPage.createDefaultScriptIfNotExists(defaultScriptName2, scriptDescription, script2);
    }

    @When("^op click Run Test on Operator V2 Portal using this Script Check below:$")
    public void simulateRunTest(DataTable dataTable)
    {
        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String deliveryType = mapOfData.get("deliveryType");
        String orderType = mapOfData.get("orderType");
        String timeslotType = mapOfData.get("timeslotType");
        String size = mapOfData.get("size");
        String weight = mapOfData.get("weight");
        pricingScriptsPage.simulateRunTest(deliveryType, orderType, timeslotType, size, weight);
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

    @When("^op linking Pricing Scripts \\\"([^\\\"]*)\\\" or \\\"([^\\\"]*)\\\" to shipper \\\"([^\\\"]*)\\\"$")
    public void linkPricingScriptsToShipper(String defaultScriptName1, String defaultScriptName2, String shipperName)
    {
        shipperLinkedToPricingScripts = shipperName;
        pricingScriptsLinkedToAShipper = pricingScriptsPage.linkPricingScriptsToShipper(defaultScriptName1, defaultScriptName2, shipperName);
    }

    @Then("^Pricing Scripts linked to the shipper successfully$")
    public void verifyPricingScriptsLinkedToShipperSuccessfully()
    {
        CommonUtil.inputText(driver, "//input[@placeholder='Search Script...']", pricingScriptsLinkedToAShipper);
        CommonUtil.pause1s();
        pricingScriptsPage.clickActionButton(1, PricingScriptsPage.ACTION_BUTTON_SHIPPERS);
        CommonUtil.pause1s();
        boolean isPricingScriptsContainShipper = pricingScriptsPage.isPricingScriptsContainShipper(shipperLinkedToPricingScripts);
        CommonUtil.clickBtn(driver, "//button[@id='button-cancel-dialog']");
        Assert.assertEquals(true, isPricingScriptsContainShipper);
    }
}
