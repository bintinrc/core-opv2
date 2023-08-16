package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.mm.model.AirHaulTrip;
import co.nvqa.common.mm.model.MiddleMileDriver;
import co.nvqa.common.mm.model.Port;
import co.nvqa.common.mm.model.PortTrip;
import co.nvqa.common.mm.utils.MiddleMileUtils;
import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.model.core.Driver;
import co.nvqa.operator_v2.selenium.page.PortTripManagementPage;
import co.nvqa.operator_v2.util.TestConstants;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import org.apache.commons.text.RandomStringGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.common.mm.cucumber.MiddleMileScenarioStorageKeys.KEY_LIST_OF_CREATED_PORT_CODES;
import static co.nvqa.common.mm.cucumber.MiddleMileScenarioStorageKeys.KEY_LIST_OF_CREATED_PORT_DETAILS;
import static co.nvqa.common.mm.cucumber.MiddleMileScenarioStorageKeys.KEY_LIST_OF_UPDATED_PORT_DETAILS;
import static co.nvqa.common.mm.cucumber.MiddleMileScenarioStorageKeys.KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS;
import static co.nvqa.common.mm.cucumber.MiddleMileScenarioStorageKeys.KEY_MM_LIST_OF_CREATED_PORTS;
import static co.nvqa.common.mm.cucumber.MiddleMileScenarioStorageKeys.KEY_MM_LIST_OF_UPDATED_PORTS;
import static co.nvqa.operator_v2.selenium.page.PortTripManagementPage.PortTable.ACTION_ASSIGN_MAWB;
import static co.nvqa.operator_v2.selenium.page.PortTripManagementPage.PortTable.ACTION_DETAILS;
import static co.nvqa.operator_v2.selenium.page.PortTripManagementPage.PortTable.ACTION_EDIT;

public class PortTripManagementSteps extends AbstractSteps {

    private static final Logger LOGGER = LoggerFactory.getLogger(PortTripManagementSteps.class);
    private final String GENERATED = "GENERATED";
    private final String NUMBER = "NUMBER";
    private final String ALPHANUM = "ALPHANUM";

    private PortTripManagementPage portTripManagementPage;

    public PortTripManagementSteps() {
    }

    @Override
    public void init() {
        portTripManagementPage = new PortTripManagementPage(getWebDriver());
    }

    @And("Operator verifies that the Port Management Page is opened")
    public void operatorVerifiesThatThePortTripManagementPageIsOpened() {
        portTripManagementPage.switchTo();
        portTripManagementPage.verifyPortTripMovementPageItems();
        pause2s();
    }

    @When("Operator fill the departure date for Port Management")
    public void operatorFillTheDetailsInPortManagement(Map<String, String> mapOfData) {
        Map<String, String> resolvedData = resolveKeyValues(mapOfData);
        portTripManagementPage.fillDepartureDateDetails(resolvedData);
    }

    @When("Operator fill the Origin Or Destination for Port Management")
    public void operatorFillTheOriginDetailsInPortManagement(Map<String, String> mapOfData) {
        Map<String, String> resolvedData = resolveKeyValues(mapOfData);
        portTripManagementPage.fillOrigDestDetails(resolvedData);
    }

    @And("Verify operator cannot fill more than 4 Origin Or Destination for Port Management")
    public void verifyMaxOriginDetailsInPortManagement() {
        portTripManagementPage.verifyMaxOrigDestDetails();
    }

    @And("Operator click on 'Load Trips' on Port Management")
    public void operatorClickOnLoadTripsOnPortManagement() {
        portTripManagementPage.clickOnLoadTripsPortManagementDetails();
    }

    @Then("Verify the parameters of loaded trips in Port Management")
    public void verifyParametersInPortManagement(Map<String, String> mapOfData) {
        Map<String, String> resolvedData = resolveKeyValues(mapOfData);
        portTripManagementPage.verifyLoadedTripsPageInPortManagementDetails(resolvedData);
    }

    @And("Create a new flight trip on Port Trip Management using below data:")
    public void operatorCreateNewFlightTripInPortManagement(Map<String, String> mapOfData) {
        Map<String, String> resolvedData = resolveKeyValues(mapOfData);
        Boolean isCreateTripSuccess = portTripManagementPage.createFlightTrip(resolvedData);
        if (isCreateTripSuccess) {
            String tripId = portTripManagementPage.getPortTripId();
            AirHaulTrip airHaulTrip = new AirHaulTrip();
            airHaulTrip.setTripId(Long.parseLong(tripId));
            put(KEY_CURRENT_MOVEMENT_TRIP_ID, tripId);
            putInList(KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS, tripId);
            putInList(KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS, airHaulTrip);
            LOGGER.info("Trip id: {}", getList(KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS, AirHaulTrip.class).get(0).getTripId());
        }
    }

    @And("Operator search the {string} column on Port Trip Management page")
    public void operatorSearchesInPortManagement(String filter) {
        put("KEY_AIRPORT_MANAGEMENT_FILTER",
            portTripManagementPage.filterThePortTripsTable(filter, ""));
    }

    @And("Operator search the {string} column with invalid data {string} on Port Trip Management page")
    public void operatorSearchesInPortManagement(String filter, String invalidData) {
        put("KEY_AIRPORT_MANAGEMENT_FILTER",
            portTripManagementPage.filterThePortTripsTable(filter, invalidData));
    }

    @And("Verify only filtered results are displayed on Port Trip Management page")
    public void verifyTheFilteredResults() {
        HashMap<String, String> map = get("KEY_AIRPORT_MANAGEMENT_FILTER");
        portTripManagementPage.verifyFilteredResultsInPortTripsTable(map);
    }

    @When("Operator click on Manage Port Facility and verify all components")
    public void operatorOpenManagePortFacility() {
        portTripManagementPage.operatorOpenManagePortFacility();
    }

    @Then("Operator Add new Port")
    public void operatorAddsNewPort(Map<String, String> mapOfData) {
        Map<String, String> resolvedMap = resolveKeyValues(mapOfData);
        if (resolvedMap.get("portName").equalsIgnoreCase(GENERATED)) {
            resolvedMap.put("portName",
                f("%s AUTO-GENERATED %s", StandardTestUtils.generateAlphaNumericString(8),
                    resolvedMap.get("portType")).toUpperCase());
        }

        int codeLength = mapOfData.get("portType").equalsIgnoreCase("airport") ? 3 : 5;
        if (resolvedMap.get("portCode").equalsIgnoreCase(GENERATED)) {
            String portCode = new RandomStringGenerator.Builder().withinRange('A', 'Z').build()
                .generate(codeLength);
            resolvedMap.put("portCode", portCode.toUpperCase());
        } else if (resolvedMap.get("portCode").equalsIgnoreCase(NUMBER)) {
            String portCode = new RandomStringGenerator.Builder().withinRange('0', '9').build()
                .generate(codeLength);
            resolvedMap.put("portCode", portCode);
        } else if (resolvedMap.get("portCode").equalsIgnoreCase(ALPHANUM)) {
            resolvedMap.put("portCode",
                StandardTestUtils.generateAlphaNumericString(codeLength).toUpperCase());
        }
        portTripManagementPage.createNewPort(resolvedMap);
        putInList(KEY_LIST_OF_CREATED_PORT_DETAILS, resolvedMap);
        putInList(KEY_LIST_OF_CREATED_PORT_CODES, resolvedMap.get("portCode"));
        putInList(KEY_MM_LIST_OF_CREATED_PORTS, new Port(resolvedMap));
    }

    @And("Verify the new port {string} created success message")
    public void verifySuccessMessagePortCreation(String portName) {
        portTripManagementPage.verifyPortCreationSuccessMessage(resolveValue(portName));
    }

    @And("Verify the newly created port values in table")
    public void verifyNewlyCreatedPort() {
        List<Map<String, String>> portDetails = ((List<Port>) get(
            KEY_MM_LIST_OF_CREATED_PORTS)).stream().map(Port::portToMap).collect(
            Collectors.toList());
        portTripManagementPage.verifyNewlyCreatedPort(portDetails.get(portDetails.size() - 1));
    }

    @And("Verify port {string} values in table")
    public void verifyPortValuesInTable(String storageKey) {
        Map<String, String> portDetails = convertValueToMapCamelCase(resolveValue(storageKey, Port.class), String.class, String.class);
        portDetails.put("portType", portDetails.get("type"));
        portTripManagementPage.verifyNewlyCreatedPort(portDetails);
    }

    @And("Capture the error in Port Trip Management Page")
    public void captureTheErrorInPortCreation() {
        portTripManagementPage.captureErrorNotification();
    }

    @And("Verify the error {string} is displayed while creating new port")
    public void verifyTheErrorInPortCreation(String expError) {
        portTripManagementPage.verifyTheErrorInPortCreation(resolveValue(expError));
    }

    @Given("Operator search port by {string}")
    public void operatorSearchPort(String searchValue){
        String invalidValue = "AAAAAA";
        List<Port> portDetails = get(KEY_MM_LIST_OF_CREATED_PORTS);
        Port port = new Port();
        if (Objects.nonNull(portDetails)) {
            port = portDetails.get(portDetails.size() - 1);
        }
        switch (searchValue.toLowerCase()){
            case "id":
                if(!(port.getId() == null)){
                    portTripManagementPage.searchPort(portTripManagementPage.portIdFilter, port.getId().toString());
                } else {
                    portTripManagementPage.searchPort(portTripManagementPage.portIdFilter, invalidValue);
                }
                break;
            case "port code":
                if(!(port.getPortCode() ==null)){
                    portTripManagementPage.searchPort(portTripManagementPage.portCodeFilter, port.getPortCode());
                } else {
                    portTripManagementPage.searchPort(portTripManagementPage.portCodeFilter, invalidValue);
                }
                break;
            case "port type":
                if(!(port.getType() ==null)){
                    portTripManagementPage.searchPort(portTripManagementPage.portTypeFilter,
                        port.getType());
                    portTripManagementPage.searchPort(portTripManagementPage.portCodeFilter,
                        port.getPortCode());
                } else {
                    portTripManagementPage.searchPort(portTripManagementPage.portTypeFilter, invalidValue);
                }
                break;
            case "port name":
                if(!(port.getPortName() ==null)){
                    portTripManagementPage.searchPort(portTripManagementPage.portNameFilter, port.getPortName());
                } else {
                    portTripManagementPage.searchPort(portTripManagementPage.portNameFilter, invalidValue);
                }
                break;
            case "city":
                if(!(port.getCity() ==null)){
                    portTripManagementPage.searchPort(portTripManagementPage.portCityFilter, port.getCity());
                    portTripManagementPage.searchPort(portTripManagementPage.portCodeFilter, port.getPortCode());
                } else {
                    portTripManagementPage.searchPort(portTripManagementPage.portCityFilter, invalidValue);
                }
                break;
            case "region":
                if(!(port.getRegion() ==null)){
                    portTripManagementPage.searchPort(portTripManagementPage.portRegionFilter, port.getRegion());
                    portTripManagementPage.searchPort(portTripManagementPage.portCodeFilter, port.getPortCode());
                } else {
                    portTripManagementPage.searchPort(portTripManagementPage.portRegionFilter, invalidValue);
                }
                break;
            case "latitude, longitude":
                if(!(port.getLatitude() ==null)){
                    String longLat = port.getLatitude().toString()+", "+port.getLongitude().toString();
                    portTripManagementPage.searchPort(portTripManagementPage.portLatitudeLongitudeFilter, longLat);
                    portTripManagementPage.searchPort(portTripManagementPage.portCodeFilter, port.getPortCode());
                } else {
                    portTripManagementPage.searchPort(portTripManagementPage.portLatitudeLongitudeFilter, invalidValue);
                }
                break;
        }
    }

    @Then("Operator verifies the search port on Port Facility page")
    public void operatorVerifiesSearchPort() {
        List<Port> portDetails = get(KEY_MM_LIST_OF_CREATED_PORTS);
        portTripManagementPage.verifySearchedPort(portDetails.get(portDetails.size() - 1));
    }

    @And("Verify the validation error {string} is displayed in Add New Port form")
    public void verifyTheValidationErrorInPortCreation(String expError) {
        portTripManagementPage.verifyTheValidationErrorInPortCreation(resolveValue(expError));
    }

    @Then("Operator verifies that no data appear on Port Facility page")
    public void operatorVerifiesNoDataDisplay(){
        portTripManagementPage.verifyNodataDisplay();
    }

    @Then("Edit the {string} for created Port")
    public void operatorAddsNewPort(String editField, Map<String, String> mapOfData) {
        List<Map<String, String>> portDetails = get(KEY_LIST_OF_CREATED_PORT_DETAILS);
        Map<String, String> map = portDetails.get(portDetails.size() - 1);
        Map<String, String> updatedMap = new HashMap<>();
        Map<String, String> resolvedMapData = resolveKeyValues(mapOfData);

        int codeLength = map.get("portType").equalsIgnoreCase("airport") ? 3 : 5;
        if (resolvedMapData.get(editField).equalsIgnoreCase(GENERATED)) {
            if (editField.equalsIgnoreCase("portName")) {
                resolvedMapData.put(editField,
                    f("%s NATIONAL %s", StandardTestUtils.generateAlphaNumericString(8),
                        map.get("portType")).toUpperCase());
            } else {
                String portCode = new RandomStringGenerator.Builder().withinRange('A', 'Z').build()
                    .generate(codeLength);
                resolvedMapData.put(editField, portCode.toUpperCase());
            }
        } else if (resolvedMapData.get(editField).equalsIgnoreCase(NUMBER)) {
            String portCode = new RandomStringGenerator.Builder().withinRange('0', '9').build()
                .generate(codeLength);
            resolvedMapData.put(editField, portCode);
        } else if (resolvedMapData.get(editField).equalsIgnoreCase(ALPHANUM)) {
            resolvedMapData.put(editField,
                StandardTestUtils.generateAlphaNumericString(codeLength).toUpperCase());
        }

        updatedMap.putAll(map);
        updatedMap.put(editField, resolvedMapData.get(editField));
        portTripManagementPage.editExistingPort(editField, updatedMap, map);
        putInList(KEY_LIST_OF_UPDATED_PORT_DETAILS, updatedMap);
        putInList(KEY_LIST_OF_CREATED_PORT_CODES, mapOfData.get("portCode"));
        putInList(KEY_MM_LIST_OF_UPDATED_PORTS, new Port(updatedMap));
    }

    @And("Verify the newly updated port values in table")
    public void verifyNewlyUpdatedPort() {
        List<Map<String, String>> portDetails = ((List<Port>) get(
            KEY_MM_LIST_OF_UPDATED_PORTS)).stream().map(Port::portToMap).collect(
            Collectors.toList());
        portTripManagementPage.verifyNewlyCreatedPort(portDetails.get(0));
    }

    @Then("Operator click on Disable button for the created Port in table")
    public void operatorDisableNewPort() {
        List<Map<String, String>> portDetails = get(KEY_LIST_OF_CREATED_PORT_DETAILS);
        Map<String, String> portDetail = portDetails.get(portDetails.size() - 1);
        portTripManagementPage.disableExistingPort(portDetail);
    }

    @Then("Click on {string} button on panel on Port Trip Management page")
    public void operatorClickOnCancelOrDisable(String buttonName) {
        portTripManagementPage.clickOnCancelOrDisable(buttonName);
    }

    @Then("Operator click on Activate button for the created Port in table")
    public void operatorActivateNewPort() {
        List<Map<String, String>> portDetails = get(KEY_LIST_OF_CREATED_PORT_DETAILS);
        Map<String, String> portDetail = portDetails.get(portDetails.size() - 1);
        portTripManagementPage.activateExistingPort(portDetail);
    }

    @Then("Verify the port is displayed with {string} button")
    public void verifyTheButtonIsDisplayed(String buttonName) {
        List<Map<String, String>> portDetails = get(KEY_LIST_OF_CREATED_PORT_DETAILS);
        Map<String, String> portDetail = portDetails.get(portDetails.size() - 1);
        portTripManagementPage.verifyButton(portDetail, buttonName);
    }

    @Then("Operator verifies that no data appear on Port Trips page")
    public void operatorVerifiesNoDataDisplayOnPortTrips() {
        portTripManagementPage.verifyNoResultsFound();
    }

    @Then("Operator click on {string} button in Port Management page")
    public void operatorClickOnCreateToFromPortTrip(String button) {
        switch (button) {
            case "Create Tofrom Airport Trip":
                portTripManagementPage.clickOnCreateToFromPortTrip();
                break;
            case "Create Flight Trip":
                portTripManagementPage.clickOnCreateFlightTrip();
                break;
        }
    }

    @Then("Operator create new airport trip on Port Trip Management page using below data:")
    public void operatorCreateNewPortTrip(Map<String, String> mapOfData) {
        Map<String, String> resolvedData = resolveKeyValues(mapOfData);
        portTripManagementPage.createNewAirportTrip(resolvedData);
        String tripId = portTripManagementPage.getPortTripId();
        AirHaulTrip airHaulTrip = new AirHaulTrip();
        airHaulTrip.setTripId(Long.parseLong(tripId));
        put(KEY_CURRENT_MOVEMENT_TRIP_ID, tripId);
        putInList(KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS, tripId);
        putInList(KEY_MM_LIST_OF_CREATED_AIR_HAUL_TRIPS, airHaulTrip);
    }

    @And("Verify the new airport trip {string} created success message on Port Trip Management page")
    public void verifySuccessMessagePortTripCreation(String portName) {
        String expectedMessage = resolveValue(portName);
        portTripManagementPage.verifyAirportTripCreationSuccessMessage(expectedMessage);
    }

    @Then("Operator verify {string} license driver {string} is not displayed on Create Airport Trip on Port Trip Management page")
    public void operatorVerifyDriverNotDisplayed(String driverType, String driver) {
        portTripManagementPage.verifyDriverNotDisplayed(driver);
    }

    @Then("Operator verifies {string} with value {string} is not shown on Create Airport Trip Port Trip Management page")
    public void operatorVerifiesInvalidDriver(String name, String value) {
        portTripManagementPage.verifyInvalidItem(name, value);
    }

    @Then("Operator verifies same hub error messages on {string} Port Trip Management page")
    public void OperatorVerifiesErrorMessage(String pageName) {
        portTripManagementPage.getAndVerifySameHubErrorMessage(pageName);
    }

    @When("Operator fill new airport trip on Create Airport Trip Port Trip Management page using data below:")
    public void OperatorCreateOTTUsingSamHub(Map<String, String> mapOfData) {
        Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
        portTripManagementPage.createPortTripUsingData(resolvedMapOfData);
    }

    @Then("Operator verifies Submit button on Create Airport Trip Port Trip Management page is disabled")
    public void operatorVerifySubmitButton() {
        portTripManagementPage.verifySubmitButtonDisable();
    }

    @Then("Operator verifies duration time error messages on {string} Port Trip Management page")
    public void operatorVerifiesDurationErrorMessage(String pageName) {
        portTripManagementPage.getAndVerifyZeroDurationTimeErrorMessage(pageName);
    }

    @Then("Operator verifies past date picker {string} is disable on {string} Port Trip Management page")
    public void operatorVerifiesPastDateDisable(String date, String pageName) {
        portTripManagementPage.verifyPastDayDisable(date, pageName);
    }

    @When("Operator removes text of {string} field on {string} Port Trip Management page")
    public void operatorRemovesText(String fieldName, String pageName) {
        switch (pageName) {
            case "Create Port Trip":
                portTripManagementPage.clearTextonField(fieldName);
                break;
            case "Create Flight Trip":
                portTripManagementPage.clearTextonFieldOnFlightTrip(fieldName);
                break;
        }
    }

    @Then("Operator verifies Mandatory require error message of {string} field on {string} Port Trip Management page")
    public void operatorVerifiesMandatoryErrorMessage(String fieldName, String pageName) {
        switch (pageName) {
            case "Create Port Trip":
                portTripManagementPage.verifyMandatoryFieldErrorMessagePortPage(fieldName);
                break;
            case "Create Flight Trip":
                portTripManagementPage.verifyMandatoryFieldErrorMessageFlightTripPage(fieldName);
                break;
        }
    }

    @Then("Operator verifies MAWB error messages on Create Flight Trip Port Trip Management page")
    public void operatorVerifiesMAWBErrorMessage() {
        portTripManagementPage.verifyMAWBerrorMessage();
    }

    @Then("Operator verifies toast messages below on Create Flight Trip Port Trip Management page:")
    public void operatorVerifiesErrorMessages(List<String> expectedError) {
        expectedError = resolveValues(expectedError);
        portTripManagementPage.verifyToastErrorMessage(expectedError);
    }

    @Then("Operator verify parameters of air trip on Port Trip Management page:")
    public void operatorVerifyParametersShipmentOnShipmentManagementPage(Map<String, String> data) {
    }

    @Then("Operator verify parameters of air trip {string} on Port Trip Management page:")
    public void operatorVerifyParametersShipmentOnShipmentManagementPage(String storageKey, Map<String, String> dataTableAsMap) {
        Map<String, String> data = resolveKeyValues(dataTableAsMap);
        Map<String, String> keyIdx = MiddleMileUtils.getKeyIndex(storageKey);
        AirHaulTrip airHaulTrip = getList(keyIdx.get("key"), AirHaulTrip.class).get(Integer.parseInt(keyIdx.get("idx")));
        Long tripID = airHaulTrip.getTripId();
        PortTrip aitrip = new PortTrip();
        aitrip.fromMap(data);
        aitrip.setTripId(airHaulTrip.getTripId());
        portTripManagementPage.validatePortTripInfo(aitrip.getTripId(), aitrip);
        if (data.get("drivers") != null) {
            String driversAsStr = dataTableAsMap.get("drivers");
            List<MiddleMileDriver> expectedDrivers = new ArrayList<>(); //= driversAsStr.contains(".username") ? Arrays.asList(driversAsStr.split(",")) : resolveValue(driversAsStr);
            if (driversAsStr.contains(";")) {
                String[] driverInput = driversAsStr.split(";");
                driversAsStr = driverInput[0];
                int maxIdx = Integer.parseInt(driverInput[1]);
                List<MiddleMileDriver> drivers = getList(driversAsStr, MiddleMileDriver.class);
                for (int i = 0; i < maxIdx - 1; i++) {
                    expectedDrivers.add(drivers.get(i));
                }
            } else {
                expectedDrivers = resolveValue(driversAsStr);
            }
            portTripManagementPage.verifyListDriver(expectedDrivers);
        }
    }

    @When("Operator open edit airport trip on Port Trip Management page with data below:")
    public void operatorEditAirTripOnPortTripPage(Map<String, String> data) {
        Map<String, String> resolvedData = resolveKeyValues(data);
        String tripID = resolvedData.get("tripID");
        portTripManagementPage.filterPortById(Long.parseLong(resolveValue(tripID)));
        portTripManagementPage.portTable.clickActionButton(1, ACTION_EDIT);
        portTripManagementPage.switchToOtherWindow(tripID);

        doWithRetry(() -> {
            try {
                portTripManagementPage.waitUntilPageLoaded();
                portTripManagementPage.switchTo();
                portTripManagementPage.verifyDisableItemsOnEditPage(resolvedData.get("tripType"));
            } catch (NvTestRuntimeException e) {
                portTripManagementPage.refreshPage_v1();
                throw new NvTestRuntimeException(e.getCause());
            }
        }, "Reloading until page is properly loaded...", 1000, 3);
    }

    @When("Operator edit data on Edit Trip Port Trip Management page:")
    public void operatorEditDataOnEditTripPage(Map<String, String> data) {
        Map<String, String> resolvedData = resolveKeyValues(data);
        portTripManagementPage.editAirportTripItems(resolvedData);
    }

    @When("Operator departs trip {string} on Port Trip Management page")
    public void operatorDepartsTripOnPortTripPage(String tripID) {
        tripID = resolveValue(tripID);
        portTripManagementPage.filterPortById(Long.parseLong(resolveValue(tripID)));
        portTripManagementPage.departTrip();
    }

    @Then("Operator verifies depart trip message {string} display on Port Trip Management page")
    public void operatorVerifiesDepartTripMessageSuccess(String tripID) {
        tripID = resolveValue(tripID);
        String expectedMessage = f("Trip %s departed", tripID);
        portTripManagementPage.verifyDepartedTripSuccessful(expectedMessage);
    }

    @Then("Operator verifies action buttons below are disable on Port Trip Management page:")
    public void operatorVerifiesActionButtonsAreDisable(List<String> actionButtons) {
        portTripManagementPage.verifyActionButtonsAreDisabled(actionButtons);
    }

    @Then("Operator verifies driver error messages below on Port Trip Management page:")
    public void operatorVerifiesDriverErrorMessages(List<String> expectedErrorMessages) {
        expectedErrorMessages = resolveValues(expectedErrorMessages);
        portTripManagementPage.verifyDriverErrorMessages(expectedErrorMessages);
    }

    @When("Operator arrives trip {string} on Port Trip Management page")
    public void operatorArrivesTripOnPortTripPage(String tripID) {
        portTripManagementPage.filterPortById(Long.parseLong(resolveValue(tripID)));
        portTripManagementPage.ArriveTripAndVerifyItems();
    }

    @Then("Operator verifies {string} button on Port Trip Management page is shown")
    public void operatorVerifiesButtonIsShownOnAirTripPage(String button) {
        portTripManagementPage.verifyButtonIsShown(button);
    }

    @Then("Operator verifies trip message {string} display on Port Trip Management page")
    public void operatorVerifiesTripMessageSuccess(String tripMessage) {
        portTripManagementPage.verifyTripMessageSuccessful(resolveValue(tripMessage));
    }

    @When("Operator completes trip {string} on Port Trip Management page")
    public void operatorCompletesTripOnPortTripPage(String tripID) {
        portTripManagementPage.filterPortById(Long.parseLong(resolveValue(tripID)));
        portTripManagementPage.CompleteTripAndVerifyItems();
    }

    @When("Operator cancel trip {value} on Port Trip Management page")
    public void operatorCacelsTripOnPortTripPage(String tripID) {
        portTripManagementPage.filterPortById(Long.parseLong(resolveValue(tripID)));
//        portTripManagementPage.portTable.filterByColumn(COLUMN_AIRTRIP_ID, tripID);
        portTripManagementPage.CancelTripAndVerifyItems();
    }

    @When("Operator click assign driver button to trip {value} on Port Trip Management page")
    public void operatorAssignDriverToTripOnPortTripManagementPage(String tripID) {
        portTripManagementPage.filterPortById(Long.parseLong(resolveValue(tripID)));
        portTripManagementPage.AssignDriversAndVerifyItems();
    }

    @And("Operator clicks Save button on Assign Driver popup on Port Trip Management page")
    public void operatorClicksSaveButtonOnAssignDriverPopup() {
        portTripManagementPage.SaveAssignDriver();
    }

    @And("Operator selects multiple drivers on Port Trip Management using data below:")
    public void operatorAssignMultipleDriversOnPortTripManagementUsingDataBelow(
        Map<String, String> mapOfData) {
        Map<String, String> resolvedKeyOfData = resolveKeyValues(mapOfData);
        List<Driver> middleMileDriver = get(KEY_LIST_OF_CREATED_DRIVERS);
        portTripManagementPage.selectMultipleDrivers(resolvedKeyOfData, middleMileDriver);
    }

    @And("Operator selects drivers {string} on Port Trip Management using data below:")
    public void operatorAssignMultipleDriversOnPortTripManagementUsingDataBelow(String driverStorageKeys,
        Map<String, String> mapOfData) {
        Map<String, String> resolvedKeyOfData = resolveKeyValues(mapOfData);
        List<String> usernames = getList(driverStorageKeys, MiddleMileDriver.class).stream().map(MiddleMileDriver::getUsername).collect(
            Collectors.toList());
        portTripManagementPage.selectMultipleDriversByUsernames(resolvedKeyOfData, usernames);
    }

    @Then("Operator successful message {string} display on Assigned Driver popup on Port Trip Management")
    public void operatorSuccessfulMessageDisplayOnAssignedDriverPopup(String message) {
        List<Driver> middleMileDriver = get(KEY_LIST_OF_CREATED_DRIVERS);
        portTripManagementPage.verifyTripMessageSuccessful(f(message, middleMileDriver.size()));
    }

    @Then("Operator successful message {string} display on Assigned Drivers {string} popup on Port Trip Management")
    public void operatorSuccessfulMessageDisplayOnAssignedDriverPopup(String message, String driverStorageKey) {
        List<MiddleMileDriver> middleMileDriver = getList(driverStorageKey, MiddleMileDriver.class);
        portTripManagementPage.verifyTripMessageSuccessful(f(message, middleMileDriver.size()));
    }

    @Then("Operator verifies driver with value {string} is not shown on Port Trip Management page")
    public void operatorVerifiesWithValueIsNotShownOnPortManagementPage(String driverUsername) {
        portTripManagementPage.assignDriversToTripModal.addDriver.click();
        portTripManagementPage.verifyInvalidDriver(driverUsername);
    }

    @And("Operator clicks Unassign All button on Assign Driver popup on Port Trip Management")
    public void operatorClicksUnassignAllButtonOnAssignDriverPopup() {
        pause3s();
        portTripManagementPage.assignDriversToTripModal.unassignAllDrivers.click();
        pause2s();
    }

    @Then("Operator successful message {string} for unassign driver display on Assigned Driver popup on Port Trip Management")
    public void operatorSuccessfulMessageForUnassignDriverDisplayOnAssignedDriverPopup(
        String message) {
        portTripManagementPage.verifySuccessUnassignAllDrivers(message);
    }

    @And("Operator search created flight trip {value} on Port Trip table")
    public void operatorSearchCreatedFlightTripOnPortTripTable(String tripID) {
        portTripManagementPage.filterPortById(Long.parseLong(tripID));
    }

    @When("Operator opens view Airport Trip on Port Trip Management page with data below:")
    public void operatorOpensViewPortTripPageWithDataBelow(Map<String, String> data) {
        Map<String, String> resolvedData = resolveKeyValues(data);
        String tripID = resolvedData.get("tripID");
        String tripType = resolvedData.get("tripType");
        portTripManagementPage.filterPortById(Long.parseLong(resolveValue(tripID)));
        portTripManagementPage.portTable.clickActionButton(1, ACTION_DETAILS);
        portTripManagementPage.switchToOtherWindow(tripID + "/details");
        portTripManagementPage.waitUntilPageLoaded();
        portTripManagementPage.switchTo();
        portTripManagementPage.verifyAirportTripDetailPageItem(tripType, tripID);
    }

    @And("Operator clicks Assign Driver button on Port Trip details page")
    public void operatorClicksAssignDriverButtonOnPortTripDetailsPage() {
        portTripManagementPage.assignDriverOnAirportTripDetails.click();
        portTripManagementPage.verifyAssignDriverItemsOnTripDetail();
    }

    @And("Operator verify Assign Driver field not appear in Port Flight Trip Details page")
    public void operatorVerifyAssignDriverFieldNotAppearInPortFlightTripDetailsPage() {
        portTripManagementPage.verifyAssignDriverFieldNotAppearInAirportFlightTripDetail();
    }

    @When("Operator clicks View Details action link on successful toast created to from airport trip on Port Trip Management page")
    public void operatorClicksViewDetailsActionLinkOnSuccessfulToastCreatedToFromPortTrip() {
        String tripIdAsString = get(KEY_CURRENT_MOVEMENT_TRIP_ID);
        portTripManagementPage.viewDetailsActionLink.click();
        portTripManagementPage.switchToOtherWindow(tripIdAsString + "/details");
        portTripManagementPage.waitUntilPageLoaded();
        portTripManagementPage.switchTo();
    }

    @Then("Operator verifies it direct to trip details on Port Trip Management page with data below:")
    public void operatorVerifyItDirectToTripDetailsPageWithDataBelow(Map<String, String> data) {
        Map<String, String> resolvedData = resolveKeyValues(data);
        String tripID = resolvedData.get("tripID");
        String tripType = resolvedData.get("tripType");
        portTripManagementPage.verifyAirportTripDetailPageItem(tripType, tripID);
    }

    @And("Operator verifies the element of {string} tab on Port Trip details page are correct")
    public void operatorVerifiesTheElementOfTabOnPortTripDetailsPageAreCorrect(String tabName) {
        portTripManagementPage.verifyTabElementOnPortTripDetailsPage(tabName);
    }

    @Then("Operator verifies trip status is {string} on Port Trip details page")
    public void operatorVerifiesTripStatusIsOnPortTripDetailsPage(String tripStatus) {
        portTripManagementPage.verifyTripStatusOnAirportTripDetailsPage(tripStatus);
    }

    @Then("Operator verify {string} button is disabled on Port Trip page")
    public void operatorVerifyButtonIsDisabledOnPortTripPage(String actionButton) {
        portTripManagementPage.verifyActionsButtonIsDisabledOnAirportTripPage(actionButton);
    }

    @When("Operator assigns MAWB to flight trip on Port Trip Management page with data below:")
    public void operatorAssignsMAWBToFlightTrip(Map<String, String> data) {
        Map<String, String> resolvedData = resolveKeyValues(data);
        String tripID = resolvedData.get("tripID");
        portTripManagementPage.filterPortById(Long.parseLong(resolveValue(tripID)));
        portTripManagementPage.portTable.clickActionButton(1, ACTION_ASSIGN_MAWB);
        portTripManagementPage.verifyAssignedMawbPage();
        portTripManagementPage.assignMawb(resolvedData.get("vendor"), resolvedData.get("mawb"));
    }

    @Then("Operator verifies assigned MAWB success message on Port Trip Management page")
    public void operatorVerifiesAssignedMawbSuccessMessaage() {
        portTripManagementPage.verifyAssignMawbSuccessMessage();
    }

    @When("Operator clicks {string} button on Port Trip Management page")
    public void operatorClicksButtonOnPortTripManagementPage(String buttonName) {
        portTripManagementPage.clickButtonOnPortTripManagement(buttonName);
    }

    @Then("Operator verifies can view assigned MAWB on Flight Trip in Port Trip Management page")
    public void operatorVerifiesCanViewAssignedMAWBOnFlightTripInPortTripManagementPage() {
        portTripManagementPage.verifyCanViewAssignedMAWBOnFlightTrip();
    }

    @Then("Operator opens trip detail page for trip id {string} on Port Trip Management")
    public void operatorOpensTripDetailPageForTripIdOnPortTripManagement(String tripIdAsStr) {
        String url = f("%s/%s/port-trip-management/%d/details", TestConstants.OPERATOR_PORTAL_BASE_URL, StandardTestConstants.NV_SYSTEM_ID, Long.parseLong(resolveValue(tripIdAsStr)));
        LOGGER.info("Go to url: {}", url);
        portTripManagementPage.goToUrl(url);
        portTripManagementPage.switchTo();
    }
}
