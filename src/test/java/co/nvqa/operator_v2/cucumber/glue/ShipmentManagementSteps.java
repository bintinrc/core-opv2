package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.ShipmentManagementPage;
import com.google.inject.Inject;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Lanang Jati
 *
 * Modified by Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ShipmentManagementSteps extends AbstractSteps
{
    private ShipmentManagementPage shipmentManagementPage;
    private String start = "";
    private String end = "";
    private String comment = "";

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

    @When("^Operator create Shipment with Start Hub ([^\"]*), End hub ([^\"]*) and comment ([^\"]*)$")
    public void createShipment(String startHub, String endHub, String comment)
    {
        String id = shipmentManagementPage.createShipment(startHub, endHub, comment);
        put(KEY_SHIPMENT_ID, id);
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

    @When("^Operator edit Shipment with Start Hub ([^\"]*), End hub ([^\"]*) and comment ([^\"]*)$")
    public void editShipment(String startHub, String endHub, String newComment)
    {
        String shipmentId = get(KEY_SHIPMENT_ID);
        shipmentManagementPage.selectStartHub(startHub);
        shipmentManagementPage.selectEndHub(endHub);
        shipmentManagementPage.fillFieldComments(newComment);
        shipmentManagementPage.clickButtonSaveChangesOnEditShipmentDialog(shipmentId);

        start = startHub;
        end = endHub;
        comment = newComment;
    }

    @Then("^Operator verify the shipment is edited successfully$")
    public void shipmentEdited()
    {
        String shipmentId = get(KEY_SHIPMENT_ID);
        shipmentManagementPage.verifyShipmentUpdatedSuccessfully(shipmentId, start, end, comment);
    }

    @Then("^Operator verify the shipment status is ([^\"]*)$")
    public void checkStatus(String expectedStatus)
    {
        String shipmentId = get(KEY_SHIPMENT_ID);
        shipmentManagementPage.checkStatus(shipmentId, expectedStatus);
    }

    @When("^Operator click \"Cancel Shipment\" button on Shipment Management page$")
    public void clickCancelShipmentButton()
    {
        String shipmentId = get(KEY_SHIPMENT_ID);
        shipmentManagementPage.clickCancelShipmentButton(shipmentId);
    }

    @Then("^Operator verify the Shipment is deleted successfully$")
    public void isShipmentDeleted()
    {
        String shipmentId = get(KEY_SHIPMENT_ID);
        shipmentManagementPage.verifyShipmentDeletedSuccessfully(shipmentId);
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
}
