package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.selenium.page.PricingScriptsPage;
import com.nv.qa.support.CommonUtil;
import cucumber.api.DataTable;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;
import org.openqa.selenium.WebElement;

import java.util.Date;
import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class PricingScriptsSteps extends AbstractSteps
{
    private PricingScriptsPage pricingScriptsPage;
    private String newPricingScriptsName;
    private String pricingScriptsLinkedToAShipper;
    private String shipperLinkedToPricingScripts;

    @Inject
    public PricingScriptsSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        pricingScriptsPage = new PricingScriptsPage(getDriver());
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
        String pricingScriptsNameFromTable = pricingScriptsPage.searchAndGetTextOnTable(newPricingScriptsName, 1, PricingScriptsPage.COLUMN_CLASS_NAME);
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
        String pricingScriptsNameFromTable = pricingScriptsPage.searchAndGetTextOnTable(newPricingScriptsName, 1, PricingScriptsPage.COLUMN_CLASS_NAME);
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
        String expectedValue = "";
        String pricingScriptsNameFromTable = pricingScriptsPage.searchAndGetTextOnTable(newPricingScriptsName, 1, PricingScriptsPage.COLUMN_CLASS_NAME);
        Assert.assertEquals(expectedValue, pricingScriptsNameFromTable);
    }

    @Given("^op have two default script \"([^\"]*)\" and \"([^\"]*)\"$")
    public void createDefaultTwoScriptIfNotExists(String defaultScriptName1, String defaultScriptName2)
    {
        String scriptDescription = "Please don't touch this script. This script created by Cucumber with Selenium for testing purpose.";
        String script1 = "function getDefaultPrice() {\\n    return 0.2;\\n}";
        String script1Id = pricingScriptsPage.createDefaultScriptIfNotExists(defaultScriptName1, scriptDescription, script1);

        String importScript = String.format("importScript(%s);", script1Id);
        String script2 = importScript+"\\n\\nfunction calculate(deliveryType, orderType, timeslotType, size, weight,\\n    fromZone, toZone, codValue, insuredValue) {\\n\\n    var price = getDefaultPrice();\\n\\n    if (deliveryType == \"STANDARD\") {\\n        price += 0.3;\\n    } else if (deliveryType == \"EXPRESS\") {\\n        price += 0.5;\\n    } else if (deliveryType == \"NEXT_DAY\") {\\n        price += 0.7;\\n    } else if (deliveryType == \"SAME_DAY\") {\\n        price += 1.1;\\n    } else {\\n        throw \"Unknown delivery type.\";\\n    }\\n\\n    if (orderType == \"NORMAL\") {\\n        price += 1.3;\\n    } else if (orderType == \"RETURN\") {\\n        price += 1.7;\\n    } else if (orderType == \"C2C\") {\\n        price += 1.9;\\n    } else {\\n        throw \"Unknown order type.\";\\n    }\\n\\n    if (timeslotType == \"NONE\") {\\n        price += 2.3;\\n    } else if (timeslotType == \"DAY_NIGHT\") {\\n        price += 2.9;\\n    } else if (timeslotType == \"TIMESLOT\") {\\n        price += 3.1;\\n    } else {\\n        throw \"Unknown timeslot type.\";\\n    }\\n\\n    if (size == \"S\") {\\n        price += 3.7;\\n    } else if (size == \"M\") {\\n        price += 4.1;\\n    } else if (size == \"L\") {\\n        price += 4.3;\\n    } else if (size == \"XL\") {\\n        price += 4.7;\\n    } else if (size == \"XXL\") {\\n        price += 5.3;\\n    } else {\\n        throw \"Unknown size.\";\\n    }\\n\\n    price += weight;\\n\\n    var result = {};\\n    result.delivery_fee = price;\\n    result.cod_fee = codValue;\\n    result.insurance_fee = insuredValue;\\n\tresult.gst = 7;\\n    result.handling_fee = 11;\\n\\n    return result;\\n}";

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
        String insuredValue = mapOfData.get("insuredValue");
        String codValue = mapOfData.get("codValue");
        pricingScriptsPage.simulateRunTest(deliveryType, orderType, timeslotType, size, weight, insuredValue, codValue);
        pause1s();
    }

    @Then("^op will find the price result:$")
    public void verifyCostAndComments(DataTable dataTable)
    {
        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String expectedTotal = mapOfData.get("total");
        String expectedGst = mapOfData.get("gst");
        String expectedCodFee = mapOfData.get("codFee");
        String expectedInsuranceFee = mapOfData.get("insuranceFee");
        String expectedDeliveryFee = mapOfData.get("deliveryFee");
        String expectedHandlingFee = mapOfData.get("handlingFee");
        String expectedComments = mapOfData.get("comments");

        WebElement totalEl = CommonUtil.getElementByXpath(getDriver(), "//md-input-container/label[text()='Grand Total']/following-sibling::div[1]");
        String actualTotal = totalEl.getText();
        Assert.assertEquals("Total", expectedTotal, actualTotal);

        /*WebElement gstEl = CommonUtil.getElementByXpath(getDriver(), "//md-input-container[label[text()='GST']]/div[@class='readonly ng-binding']");
        String actualGst = gstEl.getText();
        Assert.assertEquals("GST", expectedGst, actualGst);*/

        WebElement codFeeEl = CommonUtil.getElementByXpath(getDriver(), "//md-input-container/label[text()='COD Fee']/following-sibling::div[1]");
        String actualCodFee = codFeeEl.getText();
        Assert.assertEquals("COD Fee", expectedCodFee, actualCodFee);

        WebElement insuranceFeeEl = CommonUtil.getElementByXpath(getDriver(), "//md-input-container/label[text()='Insurance Fee']/following-sibling::div[1]");
        String actualInsuranceFee = insuranceFeeEl.getText();
        Assert.assertEquals("Insurance Fee", expectedInsuranceFee, actualInsuranceFee);

        WebElement deliveryFeeEl = CommonUtil.getElementByXpath(getDriver(), "//md-input-container/label[text()='Delivery Fee']/following-sibling::div[1]");
        String actualDeliveryFee = deliveryFeeEl.getText();
        Assert.assertEquals("Delivery Fee", expectedDeliveryFee, actualDeliveryFee);

        WebElement handlingFeeEl = CommonUtil.getElementByXpath(getDriver(), "//md-input-container/label[text()='Handling Fee']/following-sibling::div[1]");
        String actualHandlingFee = handlingFeeEl.getText();
        Assert.assertEquals("Handling Fee", expectedHandlingFee, actualHandlingFee);

        WebElement commentsEl = CommonUtil.getElementByXpath(getDriver(), "//md-input-container/label[text()='Comments']/following-sibling::div[1]");
        String actualComments = commentsEl.getText();
        Assert.assertEquals("Comments", expectedComments, actualComments);

        CommonUtil.pause1s();
        CommonUtil.clickBtn(getDriver(), "//button[@aria-label='Cancel']");
    }

    @When("^op linking Pricing Scripts \"([^\"]*)\" or \"([^\"]*)\" to shipper \"([^\"]*)\"$")
    public void linkPricingScriptsToShipper(String defaultScriptName1, String defaultScriptName2, String shipperName)
    {
        shipperLinkedToPricingScripts = shipperName;
        pricingScriptsLinkedToAShipper = pricingScriptsPage.linkPricingScriptsToShipper(defaultScriptName1, defaultScriptName2, shipperName);
    }

    @Then("^Pricing Scripts linked to the shipper successfully$")
    public void verifyPricingScriptsLinkedToShipperSuccessfully()
    {
        pricingScriptsPage.searchScript(pricingScriptsLinkedToAShipper);
        pricingScriptsPage.clickActionButton(1, PricingScriptsPage.ACTION_BUTTON_SHIPPERS);
        boolean isPricingScriptsContainShipper = pricingScriptsPage.isPricingScriptsContainShipper(shipperLinkedToPricingScripts);
        CommonUtil.clickBtn(getDriver(), pricingScriptsPage.CLOSE_BUTTON);
        Assert.assertEquals(true, isPricingScriptsContainShipper);
    }
}
