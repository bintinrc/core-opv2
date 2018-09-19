package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.ShipmentInfo;
import co.nvqa.operator_v2.selenium.page.ShipmentManagementPage;
import com.google.inject.Inject;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Map;

/**
 * @author Lanang Jati
 *
 * Modified by Daniel Joi Partogi Hutapea.
 */
@ScenarioScoped
public class ShipmentManagementSteps extends AbstractSteps
{
    private ShipmentManagementPage shipmentManagementPage;

    @Inject
    public ShipmentManagementSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        shipmentManagementPage = new ShipmentManagementPage(getWebDriver());
    }

    @When("^Operator click \"Load All Selection\" on Shipment Management page$")
    public void listAllShipment()
    {
        shipmentManagementPage.clickButtonLoadSelection();
    }

    @When("^Operator click ([^\"]*) button on Shipment Management page$")
    public void clickActionButton(String actionButton)
    {
        String shipmentId = get(KEY_SHIPMENT_ID);
        shipmentManagementPage.clickActionButton(shipmentId, actionButton);

        if("Force".equals(actionButton))
        {
            shipmentManagementPage.waitUntilForceToastDisappear(shipmentId);
        }
    }

    @When("^Operator filter ([^\"]*) = ([^\"]*) on Shipment Management page$")
    public void fillSearchFilter(String filter, String value)
    {
        shipmentManagementPage.clickAddFilter(filter, value);
    }

    @Given("^Operator click Edit filter on Shipment Management page$")
    public void operatorClickEditFilterOnShipmentManagementPage()
    {
        shipmentManagementPage.clickEditSearchFilterButton();
    }

    @Then("^Operator scan Shipment with source ([^\"]*) in hub ([^\"]*) on Shipment Management page$")
    public void operatorScanShipmentWithSourceInHubOnShipmentManagementPage(String source, String hub)
    {
        try
        {
            shipmentManagementPage.shipmentScanExist(source, hub);
        }
        finally
        {
            shipmentManagementPage.closeScanModal();
        }
    }

    @Then("^Operator verify inbounded Shipment exist on Shipment Management page$")
    public void operatorVerifyInboundedShipmentExistOnShipmentManagementPage()
    {
        String shipmentId = get(KEY_SHIPMENT_ID);
        shipmentManagementPage.verifyInboundedShipmentExist(shipmentId);
    }

    @When("^Operator clear all filters on Shipment Management page$")
    public void operatorClearAllFiltersOnShipmentManagementPage()
    {
        shipmentManagementPage.clearAllFilters();
    }

    @When("^Operator create Shipment on Shipment Management page using data below:$")
    public void operatorCreateShipmentOnShipmentManagementPageUsingDataBelow(Map<String, String> mapOfData)
    {
        ShipmentInfo shipmentInfo = new ShipmentInfo();
        shipmentInfo.fromMap(mapOfData);
        shipmentManagementPage.createShipment(shipmentInfo);
        put(KEY_SHIPMENT_INFO, shipmentInfo);
        put(KEY_SHIPMENT_ID, shipmentInfo.getId());
    }

    @When("^Operator edit Shipment on Shipment Management page using data below:$")
    public void operatorEditShipmentOnShipmentManagementPageUsingDataBelow(Map<String, String> mapOfData)
    {
        ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
        shipmentInfo.fromMap(mapOfData);
        shipmentManagementPage.editShipment(shipmentInfo);
    }

    @Then("^Operator verify parameters of the created shipment on Shipment Management page$")
    public void operatorVerifyParametersOfTheCreatedShipmentOnShipmentManagementPage()
    {
        ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
        shipmentManagementPage.validateShipmentInfo(shipmentInfo.getId(), shipmentInfo);
    }

    @Then("^Operator verify the following parameters of the created shipment on Shipment Management page:$")
    public void operatorVerifyTheFollowingParametersOfTheCreatedShipmentOnShipmentManagementPage(Map<String, String> mapOfData)
    {
        ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
        ShipmentInfo expectedShipmentInfo = new ShipmentInfo();
        expectedShipmentInfo.fromMap(mapOfData);
        shipmentManagementPage.validateShipmentInfo(shipmentInfo.getId(), expectedShipmentInfo);
    }

    @When("^Operator click \"([^\"]*)\" action button for the created shipment on Shipment Management page$")
    public void operatorClickActionButtonForTheCreatedShipmentOnShipmentManagementPage(String actionId)
    {
        ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
        shipmentManagementPage.clickActionButton(shipmentInfo.getId(), actionId);
    }

    @And("^Operator force success the created shipment on Shipment Management page$")
    public void operatorForceSuccessTheCreatedShipmentOnShipmentManagementPage()
    {
        ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
        shipmentManagementPage.forceSuccessShipment(shipmentInfo.getId());
    }

    @And("^Operator cancel the created shipment on Shipment Management page$")
    public void operatorCancelTheCreatedShipmentOnShipmentManagementPage()
    {
        ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
        shipmentManagementPage.cancelShipment(shipmentInfo.getId());
    }
}
