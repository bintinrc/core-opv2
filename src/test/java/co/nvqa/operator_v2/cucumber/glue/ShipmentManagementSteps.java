package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.hub.Shipments;
import co.nvqa.operator_v2.model.ShipmentInfo;
import co.nvqa.operator_v2.selenium.page.ShipmentManagementPage;
import co.nvqa.operator_v2.util.KeyConstants;
import co.nvqa.operator_v2.util.TestUtils;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.StringUtils;

import java.io.FileNotFoundException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * Modified by Daniel Joi Partogi Hutapea.
 * Modified by Sergey Mishanin.
 *
 * @author Lanang Jati
 */
@SuppressWarnings("WeakerAccess")
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
        Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
        shipmentManagementPage.clickActionButton(shipmentId, actionButton);

        if("Force".equals(actionButton))
        {
            shipmentManagementPage.waitUntilForceToastDisappear(shipmentId);
        }
    }

    @When("^Operator filter ([^\"]*) = ([^\"]*) on Shipment Management page$")
    public void fillSearchFilter(String filter, String value)
    {
        if ("orderDestHubName".equalsIgnoreCase(value))
        {
            Order order = get(KEY_CREATED_ORDER);
            value = order.getDestinationHub();
        }

        shipmentManagementPage.addFilter(filter, value, false);
        putInMap(KEY_SHIPMENT_MANAGEMENT_FILTERS, filter, value);
    }

    @When("^Operator filter shipment based on MAWB value on Shipment Management page$")
    public void fillSearchFilterMawb()
    {
        final String mawb = get(KeyConstants.KEY_MAWB);

        shipmentManagementPage.addFilter("MAWB", mawb, true);
        putInMap(KEY_SHIPMENT_MANAGEMENT_FILTERS, "MAWB", mawb);
    }

    @When("Operator filter shipment based on {string} Date on Shipment Management page")
    public void fillSearchFilterByDate(String dateFieldName)
    {
        LocalDateTime today = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH);
        String dateOfToday = formatter.format(today);
        String dateOfTomorrow = formatter.format(today.plusDays(1));

        shipmentManagementPage.selectValueFromNvAutocompleteByItemTypesAndDismiss("filters", dateFieldName);
        shipmentManagementPage.changeDate(dateOfToday, true);
        shipmentManagementPage.changeDate(dateOfTomorrow, false);
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
        Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
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
        List<Order> listOfOrders;
        boolean isNextOrder = false;

        if (get("isNextOrder") != null)
        {
            isNextOrder = get("isNextOrder");
        }

        if(containsKey(KEY_LIST_OF_CREATED_ORDER))
        {
            listOfOrders = get(KEY_LIST_OF_CREATED_ORDER);
        }
        else if(containsKey(KEY_CREATED_ORDER))
        {
            listOfOrders = Arrays.asList(get(KEY_CREATED_ORDER));
        }
        else
        {
            listOfOrders = new ArrayList<>();
        }

        ShipmentInfo shipmentInfo = new ShipmentInfo();
        shipmentInfo.fromMap(mapOfData);
        shipmentInfo.setOrdersCount(listOfOrders.size());

        shipmentManagementPage.createShipment(shipmentInfo, isNextOrder);

        if(StringUtils.isBlank(shipmentInfo.getShipmentType()))
        {
            shipmentInfo.setShipmentType("AIR_HAUL");
        }

//        final String mawb = ("AUTO".equalsIgnoreCase(shipmentInfo.getMawb()) && !StringUtils.isBlank(shipmentInfo.getMawb())) ? "AUTO-" + randomLong(0000000, 9999999) : null;
//        put("tanias'mawb", mawb);
//        shipmentInfo.setMawb(mawb);

        put(KEY_SHIPMENT_INFO, shipmentInfo);
        put(KEY_CREATED_SHIPMENT, shipmentInfo);
        put(KEY_CREATED_SHIPMENT_ID, shipmentInfo.getId());

        if (isNextOrder)
        {
            Long secondShipmentId = shipmentManagementPage.createAnotherShipment();
            shipmentInfo.setId(secondShipmentId);
            Long shipmentIdBefore = get(KEY_CREATED_SHIPMENT_ID);
            List<Long> listOfShipmentId = new ArrayList<>();
            listOfShipmentId.add(shipmentIdBefore);
            listOfShipmentId.add(secondShipmentId);

            put(KEY_LIST_OF_CREATED_SHIPMENT_ID, listOfShipmentId);
        }
    }

    @When("^Operator edit Shipment on Shipment Management page using data below:$")
    public void operatorEditShipmentOnShipmentManagementPageUsingDataBelow(Map<String, String> mapOfData)
    {
        ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
        shipmentInfo.fromMap(mapOfData);
        shipmentManagementPage.editShipment(shipmentInfo);
    }

    @When("^Operator edit Shipment on Shipment Management page including MAWB using data below:$")
    public void operatorEditShipmentOnShipmentManagementPageIncludingMawbUsingDataBelow(Map<String, String> mapOfData)
    {
        ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
        shipmentInfo.fromMap(mapOfData);
        shipmentManagementPage.editShipment(shipmentInfo);
        put(KeyConstants.KEY_MAWB, shipmentInfo.getMawb());
    }

    @Then("^Operator verify parameters of the created shipment on Shipment Management page$")
    public void operatorVerifyParametersOfTheCreatedShipmentOnShipmentManagementPage()
    {
        ShipmentInfo shipmentInfo;

        if (get(KEY_SHIPMENT_INFO) == null) {
            Shipments shipments = get(KEY_CREATED_SHIPMENT);
            shipmentInfo = new ShipmentInfo(shipments);
        } else {
            shipmentInfo = get(KEY_SHIPMENT_INFO);
        }

        shipmentManagementPage.validateShipmentInfo(shipmentInfo.getId(), shipmentInfo);
    }

    @Then("^Operator verify parameters of the created shipment via API on Shipment Management page$")
    public void operatorVerifyParametersOfTheCreatedShipmentViaApiOnShipmentManagementPage()
    {
        Shipments shipment = get(KEY_CREATED_SHIPMENT);
        shipmentManagementPage.validateShipmentId(shipment.getShipment().getId());
    }

    @Then("Operator verify parameters of the created multiple shipment on Shipment Management page")
    public void operatorVerifyParametersOfTheCreatedMultipleShipmentOnShipmentManagementPage()
    {
        List<Long> shipmentId = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);
        for (Long shipmentIds : shipmentId)
        {
            shipmentManagementPage.validateShipmentId(shipmentIds);
        }
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

    @And("^Operator open the shipment detail for the created shipment on Shipment Management Page$")
    public void operatorOpenShipmentDetailsPageForCreatedShipmentOnShipmentManagementPage()
    {
        ShipmentInfo shipmentInfo;

        if (get(KEY_SHIPMENT_INFO) == null) {
            Shipments shipments = get(KEY_CREATED_SHIPMENT);
            shipmentInfo = new ShipmentInfo(shipments);
        } else {
            shipmentInfo = get(KEY_SHIPMENT_INFO);
        }

        shipmentManagementPage.openShipmentDetailsPage(shipmentInfo.getId());
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

    @When("Operator edits and verifies that the cancelled shipment cannot be edited")
    public void operatorEditsAndVerifiesThatTheCancelledShipmentCannotBeEdited()
    {
        shipmentManagementPage.editCancelledShipment();
    }

    @And("^Operator open the Master AWB of the created shipment on Shipment Management Page$")
    public void operatorOpenTheMasterAwbOfTheCreatedShipmentOnShipmentManagementPage()
    {
        ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
        shipmentManagementPage.openAwb(shipmentInfo.getId());
    }

    @And("^Operator verify the Shipment Details Page opened is for the created shipment$")
    public void operatorVerifyShipmentDetailsPageOpenedIsForTheCreatedShipment()
    {
        Order order = get(KEY_CREATED_ORDER);
        ShipmentInfo shipmentInfo;

        if (get(KEY_SHIPMENT_INFO) == null) {
            Shipments shipments = get(KEY_CREATED_SHIPMENT);
            shipmentInfo = new ShipmentInfo(shipments);
        } else {
            shipmentInfo = get(KEY_SHIPMENT_INFO);
        }

        shipmentManagementPage.verifyOpenedShipmentDetailsPageIsTrue(shipmentInfo.getId(), order.getTrackingId());
    }

    @And("^Operator verify the the master AWB is opened$")
    public void operatorVerifyTheOpenedMasterAwbIsConsistedOfTheRightData()
    {
        shipmentManagementPage.verifyMasterAwbIsOpened();
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

    @And("^Operator verify that the data consist is correct$")
    public void operatorDownloadAndVerifyThatTheDataConsistsIsCorrect()
    {
        byte[] shipmentAirwayBill = get(KEY_SHIPMENT_AWB);
        ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
        shipmentManagementPage.downloadPdfAndVerifyTheDataIsCorrect(shipmentInfo, shipmentAirwayBill);
    }

    @Given("Operator intends to create a new Shipment directly from the Shipment Toast")
    public void operatorIntendsToCreateANewShipmentDirectlyFromTheShipmentToast() {
        boolean isNextOrder = true;
        put("isNextOrder", isNextOrder);
    }

    @When("Operator click Force Success Button")
    public void operatorClickForceSuccessButton()
    {
        shipmentManagementPage.forceSuccessShipment();
    }

    @And("Operator create CSV \"([^\"]*)\" file which has multiple valid Tracking ID in it and upload the CSV")
    public void createAndUploadCsvMultipleTrackingId(String fileName) throws FileNotFoundException
    {
        List<Order> orders = get(KEY_LIST_OF_CREATED_ORDER);
        ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
        int numberOfOrder = orders.size();
        shipmentManagementPage.createAndUploadCsv(orders, fileName, numberOfOrder, shipmentInfo);
    }

    @And("Operator create CSV \"([^\"]*)\" file which has duplicated Tracking ID in it and upload the CSV")
    public void createAndUploadCsvDuplicatedTrackingId(String fileName) throws FileNotFoundException
    {
        List<Order> orders = get(KEY_LIST_OF_CREATED_ORDER);
        ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
        int numberOfOrder = orders.size();
        shipmentManagementPage.createAndUploadCsv(orders, fileName, true, true, numberOfOrder, shipmentInfo);
    }

    @And("Operator create CSV \"([^\"]*)\" file which has invalid Tracking ID in it and upload the CSV")
    public void createAndUploadCsvInvalidTrackingId(String fileName) throws FileNotFoundException
    {
        ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
        shipmentManagementPage.createAndUploadCsv(fileName, shipmentInfo);
    }
}
