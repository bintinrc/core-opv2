package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.PricingScriptsPage;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.datatable.DataTable;
import java.util.Date;
import java.util.Map;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class PricingScriptsSteps extends AbstractSteps {

  private PricingScriptsPage pricingScriptsPage;
  private String newPricingScriptsName;
  private String pricingScriptsLinkedToAShipper;
  private String shipperLinkedToPricingScripts;

  public PricingScriptsSteps() {
  }

  @Override
  public void init() {
    pricingScriptsPage = new PricingScriptsPage(getWebDriver());
  }

  @When("^Operator create new script on Pricing Scripts page$")
  public void operatorCreateNewScriptOnPricingScriptsPage() {
    newPricingScriptsName = "Dummy Script #" + generateDateUniqueString();
    pricingScriptsPage.createScript(newPricingScriptsName,
        f("This 'Pricing Script' is created by Operator V2 automation test. Created at %s.",
            new Date()));
  }

  @Then("^Operator verify the new script on Pricing Scripts is created successfully$")
  public void operatorVerifyTheNewScriptOnPricingScriptsIsCreatedSuccessfully() {
    String pricingScriptsNameFromTable = pricingScriptsPage
        .searchAndGetTextOnTable(newPricingScriptsName, 1,
            PricingScriptsPage.COLUMN_CLASS_DATA_NAME);
    assertEquals(newPricingScriptsName, pricingScriptsNameFromTable);
  }

  @When("^Operator update script on Pricing Scripts page$")
  public void operatorUpdateScriptOnPricingScriptsPage() {
    newPricingScriptsName += " [EDITED]";
    pricingScriptsPage.updateScript(1, newPricingScriptsName,
        f("This 'Pricing Script' is modified by Operator V2 automation test. Modified at %s.",
            new Date()));
  }

  @Then("^Operator verify the script on Pricing Scripts page is updated successfully$")
  public void operatorVerifyTheScriptOnPricingScriptsPageIsUpdatedSuccessfully() {
    String pricingScriptsNameFromTable = pricingScriptsPage
        .searchAndGetTextOnTable(newPricingScriptsName, 1,
            PricingScriptsPage.COLUMN_CLASS_DATA_NAME);
    assertEquals(newPricingScriptsName, pricingScriptsNameFromTable);
  }

  @When("^Operator delete script on Pricing Scripts page$")
  public void operatorDeleteScriptOnPricingScriptsPage() {
    pricingScriptsPage.searchAndDeleteScript(newPricingScriptsName);
  }

  @Then("^Operator verify the script on Pricing Scripts page is deleted successfully$")
  public void operatorVerifyTheScriptOnPricingScriptsPageIsDeletedSuccessfully() {
    String expectedValue = "";
    String pricingScriptsNameFromTable = pricingScriptsPage
        .searchAndGetTextOnTable(newPricingScriptsName, 1,
            PricingScriptsPage.COLUMN_CLASS_DATA_NAME);
    assertEquals(expectedValue, pricingScriptsNameFromTable);
  }

  @Given("^Operator have two default script \"([^\"]*)\" and \"([^\"]*)\"$")
  public void createDefaultTwoScriptIfNotExists(String defaultScriptName1,
      String defaultScriptName2) {
    String scriptDescription = "Please don't touch this script. This script is created by Operator V2 automation test.";
    String script1 = "function getDefaultPrice() {\\n    return 0.2;\\n}";
    String script1Id = pricingScriptsPage
        .createDefaultScriptIfNotExists(defaultScriptName1, scriptDescription, script1);

    String importScript = f("importScript(%s);", script1Id);
    String script2 = importScript
        + "\\n\\nfunction calculate(deliveryType, orderType, timeslotType, size, weight,\\n    fromZone, toZone, codValue, insuredValue) {\\n\\n    var price = getDefaultPrice();\\n\\n    if (deliveryType == \"STANDARD\") {\\n        price += 0.3;\\n    } else if (deliveryType == \"EXPRESS\") {\\n        price += 0.5;\\n    } else if (deliveryType == \"NEXT_DAY\") {\\n        price += 0.7;\\n    } else if (deliveryType == \"SAME_DAY\") {\\n        price += 1.1;\\n    } else {\\n        throw \"Unknown delivery type.\";\\n    }\\n\\n    if (orderType == \"NORMAL\") {\\n        price += 1.3;\\n    } else if (orderType == \"RETURN\") {\\n        price += 1.7;\\n    } else if (orderType == \"C2C\") {\\n        price += 1.9;\\n    } else {\\n        throw \"Unknown order type.\";\\n    }\\n\\n    if (timeslotType == \"NONE\") {\\n        price += 2.3;\\n    } else if (timeslotType == \"DAY_NIGHT\") {\\n        price += 2.9;\\n    } else if (timeslotType == \"TIMESLOT\") {\\n        price += 3.1;\\n    } else {\\n        throw \"Unknown timeslot type.\";\\n    }\\n\\n    if (size == \"S\") {\\n        price += 3.7;\\n    } else if (size == \"M\") {\\n        price += 4.1;\\n    } else if (size == \"L\") {\\n        price += 4.3;\\n    } else if (size == \"XL\") {\\n        price += 4.7;\\n    } else if (size == \"XXL\") {\\n        price += 5.3;\\n    } else {\\n        throw \"Unknown size.\";\\n    }\\n\\n    price += weight;\\n\\n    var result = {};\\n    result.delivery_fee = price;\\n    result.cod_fee = codValue;\\n    result.insurance_fee = insuredValue;\\n\tresult.gst = 7;\\n    result.handling_fee = 11;\\n\\n    return result;\\n}";

    pricingScriptsPage
        .createDefaultScriptIfNotExists(defaultScriptName2, scriptDescription, script2);
  }

  @When("^Operator click Run Test on Operator V2 Portal using this Script Check below:$")
  public void simulateRunTest(DataTable dataTable) {
    Map<String, String> mapOfData = dataTable.asMap(String.class, String.class);
    String deliveryType = mapOfData.get("deliveryType");
    String orderType = mapOfData.get("orderType");
    String timeslotType = mapOfData.get("timeslotType");
    String size = mapOfData.get("size");
    String weight = mapOfData.get("weight");
    String insuredValue = mapOfData.get("insuredValue");
    String codValue = mapOfData.get("codValue");
    pricingScriptsPage
        .simulateRunTest(deliveryType, orderType, timeslotType, size, weight, insuredValue,
            codValue);
    pause1s();
  }

  @Then("^Operator will find the price result:$")
  public void verifyCostAndComments(DataTable dataTable) {
    Map<String, String> mapOfData = dataTable.asMap(String.class, String.class);
    pricingScriptsPage.verifyCostAndComments(mapOfData);
    pause500ms();
    pricingScriptsPage.clickButtonCancel();
  }

  @When("^Operator linking Pricing Scripts \"([^\"]*)\" or \"([^\"]*)\" to shipper \"([^\"]*)\"$")
  public void linkPricingScriptsToShipper(String defaultScriptName1, String defaultScriptName2,
      String shipperName) {
    shipperLinkedToPricingScripts = shipperName;
    pricingScriptsLinkedToAShipper = pricingScriptsPage
        .linkPricingScriptsToShipper(defaultScriptName1, defaultScriptName2, shipperName);
  }

  @Then("^Operator verify the script is linked to the shipper successfully$")
  public void operatorVerifyTheScriptIsLinkedToTheShipperSuccessfully() {
    pricingScriptsPage.searchScript(pricingScriptsLinkedToAShipper);
    pricingScriptsPage.clickActionButton(1, PricingScriptsPage.ACTION_BUTTON_SHIPPERS);
    boolean isPricingScriptsContainShipper = pricingScriptsPage
        .isPricingScriptsContainShipper(shipperLinkedToPricingScripts);
    pricingScriptsPage.clickButtonClose();
    assertTrue("Pricing Scripts not contain the expected shipper.", isPricingScriptsContainShipper);
  }
}
