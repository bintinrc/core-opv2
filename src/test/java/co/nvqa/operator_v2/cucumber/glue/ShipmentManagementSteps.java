package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.hub.Shipments;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.StandardTestUtils;
import co.nvqa.operator_v2.model.MovementEvent;
import co.nvqa.operator_v2.model.ShipmentEvent;
import co.nvqa.operator_v2.model.ShipmentInfo;
import co.nvqa.operator_v2.selenium.page.ShipmentManagementPage;
import co.nvqa.operator_v2.util.KeyConstants;
import co.nvqa.operator_v2.util.TestConstants;
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
import java.util.stream.Collectors;

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

        if ("Force".equals(actionButton))
        {
            shipmentManagementPage.waitUntilForceToastDisappear(shipmentId);
        }
    }

    @When("^Operator filter ([^\"]*) = ([^\"]*) on Shipment Management page$")
    public void fillSearchFilter(String filter, String value)
    {
        String resolvedValue = resolveValue(value);
        shipmentManagementPage.addFilter(filter, resolvedValue, false);
        putInMap(KEY_SHIPMENT_MANAGEMENT_FILTERS, filter, resolvedValue);
    }

    @When("Operator filter with following data on Shipment Management Page")
    public void operatorFilerWithData(Map<String, String> mapOfData)
    {
        retryIfRuntimeExceptionOccurred(() ->
        {
            Map<String, String> resolvedKeyValue = resolveKeyValues(mapOfData);
            String shipmentStatus = resolvedKeyValue.get("shipmentStatus");
            String lastInboundHub = resolvedKeyValue.get("lastInboundHub");
            try
            {
                shipmentManagementPage.addFilter("Shipment Status", shipmentStatus, false);
                shipmentManagementPage.addFilter("Last Inbound Hub", lastInboundHub, false);
                putInMap(KEY_SHIPMENT_MANAGEMENT_FILTERS, "Shipment Status", shipmentStatus);
                putInMap(KEY_SHIPMENT_MANAGEMENT_FILTERS, "Last Inbound Hub", lastInboundHub);

            } catch (Throwable ex)
            {
                NvLogger.error(ex.getMessage());
                shipmentManagementPage.refreshPage();
                throw ex;
            }
        }, getCurrentMethodName(), 3000, 10);
    }

    @When("^Operator search shipments by given Ids on Shipment Management page:$")
    public void fillSearchShipmentsByIds(List<String> ids)
    {
        retryIfRuntimeExceptionOccurred(() ->
        {
            try
            {
                List<Long> shipmentIds = ids.stream()
                        .map(id -> Long.valueOf(resolveValue(id)))
                        .collect(Collectors.toList());
                shipmentManagementPage.searchByShipmentIds(shipmentIds);
            } catch (Throwable ex)
            {
                NvLogger.error(ex.getMessage());
                NvLogger.info("Searched element is not found, retrying after 2 seconds...");
                navigateRefresh();
                pause2s();
                throw ex;
            }
        }, 10);
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
        LocalDateTime tomorrow = today.plusDays(1);
        String dateOfTomorrow = formatter.format(tomorrow);

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
        } finally
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
        retryIfRuntimeExceptionOccurred(() ->
        {
            try
            {
                final Map<String, String> finalData = resolveKeyValues(mapOfData);
                List<Order> listOfOrders;
                boolean isNextOrder = false;

                if (get("isNextOrder") != null)
                {
                    isNextOrder = get("isNextOrder");
                }

                if (containsKey(KEY_LIST_OF_CREATED_ORDER))
                {
                    listOfOrders = get(KEY_LIST_OF_CREATED_ORDER);
                } else if (containsKey(KEY_CREATED_ORDER))
                {
                    listOfOrders = Arrays.asList(get(KEY_CREATED_ORDER));
                } else
                {
                    listOfOrders = new ArrayList<>();
                }

                ShipmentInfo shipmentInfo = new ShipmentInfo();
                shipmentInfo.fromMap(finalData);
                shipmentInfo.setOrdersCount((long) listOfOrders.size());

                shipmentManagementPage.createShipment(shipmentInfo, isNextOrder);

                if (StringUtils.isBlank(shipmentInfo.getShipmentType()))
                {
                    shipmentInfo.setShipmentType("AIR_HAUL");
                }

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
            } catch (Throwable ex)
            {
                NvLogger.error(ex.getMessage());
                NvLogger.info("Searched element is not found, retrying after 2 seconds...");
                navigateRefresh();
                pause2s();
                throw ex;
            }
        }, 10);
    }

    @When("^Operator edit Shipment on Shipment Management page using data below:$")
    public void operatorEditShipmentOnShipmentManagementPageUsingDataBelow(Map<String, String> mapOfData)
    {
        ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
        shipmentInfo.fromMap(mapOfData);
        shipmentManagementPage.editShipment(shipmentInfo);
    }

    @When("Operator edit Shipment on Shipment Management page based on {string} using data below:")
    public void operatorEditShipmentOnShipmentManagementPageBasedOnTypeUsingDataBelow(String editType, Map<String, String> mapOfData)
    {
        ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
        Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
        switch (editType)
        {
            case "Start Hub":
                shipmentInfo.setOrigHubName(resolvedMapOfData.get("origHubName"));
                break;
            case "End Hub":
                shipmentInfo.setDestHubName(resolvedMapOfData.get("destHubName"));
                break;
            case "Comments":
                shipmentInfo.setComments(resolvedMapOfData.get("comments"));
                break;
            case "EDA & ETA":
                // TODO: Fill
                break;
        }
        shipmentManagementPage.editShipmentBy(editType, shipmentInfo);
        put(KEY_SHIPMENT_INFO, shipmentInfo);
    }

    @When("^Operator edit Shipment on Shipment Management page including MAWB using data below:$")
    public void operatorEditShipmentOnShipmentManagementPageIncludingMawbUsingDataBelow(Map<String, String> mapOfData)
    {
        mapOfData = resolveKeyValues(mapOfData);
        ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
        shipmentInfo.fromMap(mapOfData);
        shipmentManagementPage.editShipment(shipmentInfo);
        put(KeyConstants.KEY_MAWB, shipmentInfo.getMawb());
    }

    @Then("^Operator verify parameters of the created shipment on Shipment Management page$")
    public void operatorVerifyParametersOfTheCreatedShipmentOnShipmentManagementPage()
    {
        pause5s();
        ShipmentInfo shipmentInfo;

        if (get(KEY_SHIPMENT_INFO) == null)
        {
            Shipments shipments = get(KEY_CREATED_SHIPMENT);
            shipmentInfo = new ShipmentInfo(shipments);
        } else
        {
            shipmentInfo = get(KEY_SHIPMENT_INFO);
        }

        shipmentManagementPage.validateShipmentInfo(shipmentInfo.getId(), shipmentInfo);
    }

    @Then("^Operator verify parameters of shipment on Shipment Management page using data below:$")
    public void operatorVerifyParametersShipmentOnShipmentManagementPage(Map<String, String> data)
    {
        data = resolveKeyValues(data);
        data = StandardTestUtils.replaceDataTableTokens(data);
        ShipmentInfo shipmentInfo = new ShipmentInfo();
        shipmentInfo.fromMap(data);

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
        ShipmentInfo shipmentInfo;

        if (get(KEY_SHIPMENT_INFO) == null)
        {
            Shipments shipments = get(KEY_CREATED_SHIPMENT);
            shipmentInfo = new ShipmentInfo(shipments);
        } else
        {
            shipmentInfo = get(KEY_SHIPMENT_INFO);
        }
        ShipmentInfo expectedShipmentInfo = new ShipmentInfo();
        Map<String, String> resolvedKeyValues = resolveKeyValues(mapOfData);
        expectedShipmentInfo.fromMap(resolvedKeyValues);
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

        if (get(KEY_SHIPMENT_INFO) == null)
        {
            Shipments shipments = get(KEY_CREATED_SHIPMENT);
            shipmentInfo = new ShipmentInfo(shipments);
        } else
        {
            shipmentInfo = get(KEY_SHIPMENT_INFO);
        }
        put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
        shipmentManagementPage.openShipmentDetailsPage(shipmentInfo.getId());
    }

    @And("Operator open the shipment detail for the shipment {string} on Shipment Management Page")
    public void operatorOpenShipmentDetailOnShipmentManagementPage(String shipmentIdAsString)
    {
        Long shipmentId = Long.valueOf(resolveValue(shipmentIdAsString));
        shipmentManagementPage.openShipmentDetailsPage(shipmentId);
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

        if (get(KEY_SHIPMENT_INFO) == null)
        {
            Shipments shipments = get(KEY_CREATED_SHIPMENT);
            shipmentInfo = new ShipmentInfo(shipments);
        } else
        {
            shipmentInfo = get(KEY_SHIPMENT_INFO);
        }
        shipmentManagementPage.verifyOpenedShipmentDetailsPageIsTrue(shipmentInfo.getId(), order.getTrackingId());
        getWebDriver().switchTo().window(get(KEY_MAIN_WINDOW_HANDLE));
    }

    @Then("^Operator verify shipment event on Shipment Details page using data below:$")
    public void operatorVerifyShipmentEventOnEditOrderPage(Map<String, String> mapOfData)
    {
        retryIfAssertionErrorOccurred(() ->
        {
            try
            {
                final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
                ShipmentEvent expectedEvent = new ShipmentEvent(finalMapOfData);
                List<ShipmentEvent> events = shipmentManagementPage.shipmentEventsTable.readFirstEntities(1);
                ShipmentEvent actualEvent = events.stream()
                        .filter(event -> StringUtils.equalsIgnoreCase(event.getSource(), expectedEvent.getSource()))
                        .findFirst()
                        .orElseThrow(() -> new AssertionError(f("There is no [%s] shipment event on Shipment Details page", expectedEvent.getSource())));
                expectedEvent.compareWithActual(actualEvent);
            } catch (Throwable ex)
            {
                NvLogger.error(ex.getMessage());
                throw ex;
            }
        }, "retry shipment details", 5000, 10);
    }

    @Then("Operator verifies event is present for shipment on Shipment Detail page")
    public void operatorVerifiesEventIsPresentForShipmentOnShipmentDetailPage(Map<String, String> mapOfData)
    {
        final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
        List<Shipments> lists = get(KEY_LIST_OF_CREATED_SHIPMENT);

        lists.forEach(shipment ->
        {
            retryIfAssertionErrorOccurred(() ->
            {
                try
                {
                    ShipmentEvent expectedEvent = new ShipmentEvent(finalMapOfData);
                    navigateTo(f("%s/%s/shipment-details/%d", TestConstants.OPERATOR_PORTAL_BASE_URL, TestConstants.COUNTRY_CODE, shipment.getShipment().getId()));
                    shipmentManagementPage.waitUntilPageLoaded();
                    List<ShipmentEvent> events = shipmentManagementPage.shipmentEventsTable.readFirstEntities(1);
                    ShipmentEvent actualEvent = events.stream()
                            .filter(event -> StringUtils.equalsIgnoreCase(event.getSource(), expectedEvent.getSource()))
                            .findFirst()
                            .orElseThrow(() -> new AssertionError(f("There is no [%s] shipment event on Shipment Details page", expectedEvent.getSource())));
                    expectedEvent.compareWithActual(actualEvent);
                } catch (Throwable ex)
                {
                    NvLogger.error(ex.getMessage());
                    throw ex;
                }
            }, "retry shipment details event", 5000, 10);
        });
    }

    @Then("Operator verifies event is present for shipment id {string} on Shipment Detail page")
    public void operatorVerifiesEventIsPresentForShipmentIdOnShipmentDetailPage(String shipmentIdAsString, Map<String, String> mapOfData)
    {
        final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
        Long shipmentId = Long.valueOf(resolveValue(shipmentIdAsString));
        retryIfAssertionErrorOccurred(() ->
        {
            try
            {
                ShipmentEvent expectedEvent = new ShipmentEvent(finalMapOfData);
                navigateTo(f("%s/%s/shipment-details/%d", TestConstants.OPERATOR_PORTAL_BASE_URL, TestConstants.COUNTRY_CODE, shipmentId));
                shipmentManagementPage.waitUntilPageLoaded();
                List<ShipmentEvent> events = shipmentManagementPage.shipmentEventsTable.readFirstEntities(1);
                ShipmentEvent actualEvent = events.stream()
                        .filter(event -> StringUtils.equalsIgnoreCase(event.getSource(), expectedEvent.getSource()))
                        .findFirst()
                        .orElseThrow(() -> new AssertionError(f("There is no [%s] shipment event on Shipment Details page", expectedEvent.getSource())));
                expectedEvent.compareWithActual(actualEvent);
            } catch (Throwable ex)
            {
                NvLogger.error(ex.getMessage());
                throw ex;
            }
        }, "retry shipment details event", 5000, 10);
    }

    @Then("^Operator verify movement event on Shipment Details page using data below:$")
    public void operatorVerifyMovementEventOnEditOrderPage(Map<String, String> mapOfData)
    {
        mapOfData = resolveKeyValues(mapOfData);
        MovementEvent expectedEvent = new MovementEvent(mapOfData);
        List<MovementEvent> events = shipmentManagementPage.movementEventsTable.readAllEntities();
        MovementEvent actualEvent = events.stream()
                .filter(event -> StringUtils.equalsIgnoreCase(event.getSource(), expectedEvent.getSource()))
                .findFirst()
                .orElseThrow(() -> new AssertionError(f("There is no [%s] movement event on Shipment Details page", expectedEvent.getSource())));
        expectedEvent.compareWithActual(actualEvent);
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
        operatorSelectGivenFiltersPresetOnShipmentManagementPage(presetName);
    }

    @And("^Operator select \"(.+)\" filters preset on Shipment Management page$")
    public void operatorSelectGivenFiltersPresetOnShipmentManagementPage(String filterPresetName)
    {
        filterPresetName = resolveValue(filterPresetName);
        shipmentManagementPage.filterPresetSelector.searchAndSelectValue(filterPresetName);
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
    public void operatorIntendsToCreateANewShipmentDirectlyFromTheShipmentToast()
    {
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

    @When("Operator filter the shipment based on its status of Transit")
    public void operatorFilterTheShipmentBasedOnItsStatusOfTransit()
    {
        shipmentManagementPage.transitStatus();
    }

    @When("Operator clicks on reopen shipment button under the Apply Action")
    public void operatorClicksOnReopenShipmentButtonUnderTheApplyAction()
    {
        shipmentManagementPage.clickReopenShipmentButton();
    }

    @When("Operator clicks on reopen shipment button under the Apply Action for invalid status shipment")
    public void operatorClicksOnReopenShipmentButtonUnderTheApplyActionForInvaludStatusShipment()
    {
        shipmentManagementPage.clickReopenShipmentButton(false);
    }

    @Then("Operator verifies that the shipment is reopened")
    public void operatorVerifiesThatTheShipmentIsReopened()
    {
        shipmentManagementPage.verifiesShipmentIsReopened();
    }

    @Then("Operator verifies that the Reopen Shipment Button is disabled")
    public void operatorVerifiesThatTheReopenShipmentButtonIsDisabled()
    {
        shipmentManagementPage.verifiesReopenShipmentIsDisabled();
    }

    @When("Operator searches multiple shipment ids in the Shipment Management Page")
    public void operatorSearchesMultipleShipmentIdsInTheShipmentManagementPage()
    {
        List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);
        shipmentManagementPage.bulkSearchShipmentIds(shipmentIds);
    }

    @When("Operator searches multiple shipment ids in the Shipment Management Page with {string}")
    public void operatorSearchesMultipleShipmentIdsInTheShipmentManagementPageWith(String condition)
    {
        List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);
        if ("duplicated".equalsIgnoreCase(condition))
        {
            shipmentManagementPage.bulkSearchShipmentIds(shipmentIds, true);
        } else
        {
            shipmentManagementPage.bulkSearchShipmentIdsWithCondition(shipmentIds, condition);
        }
    }

    @Then("Operator verifies that more than 30 warning toast shown")
    public void operatorVerifiesThatMoreThanWarningToastShown()
    {
        shipmentManagementPage.moreThan30WarningToastShown();
    }

    @Then("Operator verifies that there is a search error modal shown with {string}")
    public void operatorVerifiesThatThereIsASearchErrorModalShownWith(String mode)
    {
        if ("valid shipment".equalsIgnoreCase(mode))
        {
            shipmentManagementPage.verifiesSearchErrorModalIsShown(true);
        } else if ("none".equalsIgnoreCase(mode))
        {
            shipmentManagementPage.verifiesSearchErrorModalIsShown(false);
        } else
        {
            NvLogger.warn("Mode is not existed!");
        }
    }

    @Then("Operator verifies the searched shipment ids result is right")
    public void operatorVerifiesTheSearchedShipmentIdsResultIsRight()
    {
        List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);
        for (int i = 0; i < shipmentIds.size(); i++)
        {
            shipmentManagementPage.searchedShipmentVerification(shipmentIds.get(i));
        }
    }

    @Then("Operator verify {string} action button is disabled on shipment Management page")
    public void operatorVerifyActionButtonIsDisabled(String actionButton)
    {

        if ("Cancel Shipment".equals(actionButton))
        {
            shipmentManagementPage.cancelShipmentButton.waitUntilVisible();
            assertThat("Cancel Shipment Button is disabled",
                    shipmentManagementPage.cancelShipmentButton.isEnabled(), equalTo(false));
        }
    }

    @Then("Operator verify empty line parsing error toast exist")
    public void operatorVerifyEmptyLineParsingErrorToastExist()
    {
        shipmentManagementPage.verifyEmptyLineParsingErrorToastExist();
    }

    @Then("Operator verify cannot parse parameter id as long error toast exist")
    public void operatorVerifyCannotParseParameterIdAsLongErrorToastExist()
    {
        shipmentManagementPage.verifyCannotParseParameterIdAsLongToastExist();
    }
}
