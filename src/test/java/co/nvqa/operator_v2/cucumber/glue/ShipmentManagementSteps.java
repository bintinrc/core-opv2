package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.ShipmentInfo;
import co.nvqa.operator_v2.selenium.page.ShipmentManagementPage;
import co.nvqa.operator_v2.util.TestUtils;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.StringUtils;

import java.util.Map;

/**
 * @author Lanang Jati
 * <p>
 * Modified by Daniel Joi Partogi Hutapea.
 * Modified by Sergey Mishanin.
 */
@ScenarioScoped
public class ShipmentManagementSteps extends AbstractSteps
{
    private ShipmentManagementPage shipmentManagementPage;
    public static final String KEY_SHIPMENT_MANAGEMENT_FILTERS = "KEY_SHIPMENT_MANAGEMENT_FILTERS";
    public static final String KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID = "KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID";
    public static final String KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_NAME = "KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_NAME";

    public ShipmentManagementSteps()
    {
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
        String shipmentId = get(KEY_CREATED_SHIPMENT_ID);
        shipmentManagementPage.clickActionButton(shipmentId, actionButton);

        if ("Force".equals(actionButton))
        {
            shipmentManagementPage.waitUntilForceToastDisappear(shipmentId);
        }
    }

    @When("^Operator filter ([^\"]*) = ([^\"]*) on Shipment Management page$")
    public void fillSearchFilter(String filter, String value)
    {
        shipmentManagementPage.addFilter(filter, value);
        putInMap(KEY_SHIPMENT_MANAGEMENT_FILTERS, filter, value);
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
        } finally
        {
            shipmentManagementPage.closeScanModal();
        }
    }

    @Then("^Operator verify inbounded Shipment exist on Shipment Management page$")
    public void operatorVerifyInboundedShipmentExistOnShipmentManagementPage()
    {
        String shipmentId = get(KEY_CREATED_SHIPMENT_ID);
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
        if (StringUtils.isBlank(shipmentInfo.getShipmentType())){
            shipmentInfo.setShipmentType("Air Haul");
        }
        put(KEY_SHIPMENT_INFO, shipmentInfo);
        put(KEY_CREATED_SHIPMENT_ID, shipmentInfo.getId());
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

    @And("^Operator save current filters as preset on Shipment Management page$")
    public void operatorSaveCurrentFiltersAsPresetWithNameOnShipmentManagementPage()
    {
        String presetName = "Test" + TestUtils.generateDateUniqueString();
        long presetId = shipmentManagementPage.saveFiltersAsPreset(presetName);
        put(KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID, presetId);
        put(KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_NAME, presetName);
    }

    @And("^Operator select created filters preset on Shipment Management page$")
    public void operatorSelectCreatedFiltersPresetOnShipmentManagementPage()
    {
        String presetName = get(KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID) + "-" + get(KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_NAME);
        shipmentManagementPage.selectFiltersPreset(presetName);
    }

    @And("^Operator verify parameters of selected filters preset on Shipment Management page$")
    public void operatorVerifyParametersOfSelectedFiltersPresetOnShipmentManagementPage()
    {
        Map<String, String> filters = get(KEY_SHIPMENT_MANAGEMENT_FILTERS);
        shipmentManagementPage.verifySelectedFilters(filters);
    }

    @And("^Operator delete created filters preset on Shipment Management page$")
    public void operatorDeleteCreatedFiltersPresetOnShipmentManagementPage()
    {
        String presetName = get(KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID) + "-" + get(KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_NAME);
        shipmentManagementPage.deleteFiltersPreset(presetName);
    }

    @Then("^Operator verify filters preset was deleted$")
    public void operatorVerifyFiltersPresetWasDeleted()
    {
        String presetName = get(KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID) + "-" + get(KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_NAME);
        shipmentManagementPage.verifyFiltersPresetWasDeleted(presetName);
        remove(KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID);
    }
}
