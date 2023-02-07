package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.model.core.Driver;
import co.nvqa.commons.model.sort.hub.AirTrip;
import co.nvqa.commons.model.sort.hub.Airport;
import co.nvqa.common.mm.model.Port;
import co.nvqa.operator_v2.selenium.page.PortTripManagementPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.common.mm.cucumber.MiddleMileScenarioStorageKeys.KEY_LIST_OF_CREATED_PORT_CODES;
import static co.nvqa.common.mm.cucumber.MiddleMileScenarioStorageKeys.KEY_LIST_OF_CREATED_PORT_DETAILS;
import static co.nvqa.common.mm.cucumber.MiddleMileScenarioStorageKeys.KEY_LIST_OF_UPDATED_PORT_DETAILS;

public class PortTripManagementSteps extends AbstractSteps{
    private static final Logger LOGGER = LoggerFactory.getLogger(PortTripManagementSteps.class);

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

//    @When("Operator fill the departure date for Port Management")
//    public void operatorFillTheDetailsInPortManagement(Map<String, String> mapOfData) {
//        Map<String, String> resolvedData = resolveKeyValues(mapOfData);
//        portTripManagementPage.fillDepartureDateDetails(resolvedData);
//    }
//
//    @When("Operator fill the Origin Or Destination for Port Management")
//    public void operatorFillTheOriginDetailsInPortManagement(Map<String, String> mapOfData) {
//        Map<String, String> resolvedData = resolveKeyValues(mapOfData);
//        portTripManagementPage.fillOrigDestDetails(resolvedData);
//    }
//
//    @And("Verify operator cannot fill more than 4 Origin Or Destination for Port Management")
//    public void verifyMaxOriginDetailsInPortManagement() {
//        portTripManagementPage.verifyMaxOrigDestDetails();
//    }
//
//    @And("Operator click on 'Load Trips' on Port Management")
//    public void operatorClickOnLoadTripsOnPortManagement() {
//        portTripManagementPage.clickOnLoadTripsPortManagementDetails();
//    }
//
//    @Then("Verify the parameters of loaded trips in Port Management")
//    public void verifyParametersInPortManagement(Map<String, String> mapOfData) {
//        Map<String, String> resolvedData = resolveKeyValues(mapOfData);
//        portTripManagementPage.verifyLoadedTripsPageInPortManagementDetails(resolvedData);
//    }
//
//    @And("Create a new flight trip using below data:")
//    public void operatorCreateNewFlightTripInPortManagement(Map<String, String> mapOfData) {
//        Map<String, String> resolvedData = resolveKeyValues(mapOfData);
//        Boolean isCreateTripSuccess = portTripManagementPage.createFlightTrip(resolvedData);
//        if (isCreateTripSuccess){
//            String tripId = portTripManagementPage.getPortTripId();
//            put(KEY_CURRENT_MOVEMENT_TRIP_ID,tripId);
//            putInList(KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS,tripId);
//        }
//    }
//
//    @And("Operator search the {string} column")
//    public void operatorSearchesInPortManagement(String filter) {
//        put("KEY_AIRPORT_MANAGEMENT_FILTER", portTripManagementPage.filterThePortTripsTable(filter, ""));
//    }
//
//    @And("Operator search the {string} column with invalid data {string}")
//    public void operatorSearchesInPortManagement(String filter, String invalidData) {
//        put("KEY_AIRPORT_MANAGEMENT_FILTER", portTripManagementPage.filterThePortTripsTable(filter, invalidData));
//    }
//
//    @And("Verify only filtered results are displayed")
//    public void verifyTheFilteredResults() {
//        HashMap<String, String> map = get("KEY_AIRPORT_MANAGEMENT_FILTER");
//        portTripManagementPage.verifyFilteredResultsInPortTripsTable(map);
//    }

    @When("Operator click on Manage Port Facility and verify all components")
    public void operatorOpenManagePortFacility() {
        portTripManagementPage.operatorOpenManagePortFacility();
    }

    @Then("Operator Add new Port")
    public void operatorAddsNewPort(Map<String, String> mapOfData) {
        portTripManagementPage.createNewPort(mapOfData);
        putInList(KEY_LIST_OF_CREATED_PORT_DETAILS, mapOfData);
        putInList(KEY_LIST_OF_CREATED_PORT_CODES, mapOfData.get("portCode"));
    }

    @And("Verify the new port {string} created success message")
    public void verifySuccessMessagePortCreation(String portName) {
        portTripManagementPage.verifyPortCreationSuccessMessage(portName);
    }

    @And("Verify the newly created port values in table")
    public void verifyNewlyCreatedPort() {
        List<Map<String, String>> portDetails = get(KEY_LIST_OF_CREATED_PORT_DETAILS);
        portTripManagementPage.verifyNewlyCreatedPort(portDetails.get(portDetails.size() - 1));
    }

    @And("Capture the error in Port Trip Management Page")
    public void captureTheErrorInPortCreation() {
        portTripManagementPage.captureErrorNotification();
    }

    @And("Verify the error {string} is displayed while creating new port")
    public void verifyTheErrorInPortCreation(String expError) {
        portTripManagementPage.verifyTheErrorInPortCreation(expError);
    }

    @Given("Operator search port by {string}")
    public void operatorSearchPort(String searchValue){
        String invalidValue = "AAAAAA";
        List<Port> portDetails = get(KEY_LIST_OF_CREATED_PORT_DETAILS);
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
                    portTripManagementPage.searchPort(portTripManagementPage.portTypeFilter, port.getType());
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
        List<Port> portDetails = get(KEY_LIST_OF_CREATED_PORT_DETAILS);
        portTripManagementPage.verifySearchedPort(portDetails.get(portDetails.size() - 1));
    }

    @And("Verify the validation error {string} is displayed in Add New Port form")
    public void verifyTheValidationErrorInPortCreation(String expError) {
        portTripManagementPage.verifyTheValidationErrorInPortCreation(expError);
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
        updatedMap.putAll(map);
        updatedMap.put(editField, mapOfData.get(editField));
        portTripManagementPage.editExistingPort(editField, updatedMap, map);
        putInList(KEY_LIST_OF_UPDATED_PORT_DETAILS, updatedMap);
        putInList(KEY_LIST_OF_CREATED_PORT_CODES, mapOfData.get("portCode"));
    }

    @And("Verify the newly updated port values in table")
    public void verifyNewlyUpdatedPort() {
        List<Map<String, String>> portDetails = get(KEY_LIST_OF_UPDATED_PORT_DETAILS);
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

//    @Then("Operator verifies that no data appear on Port Trips page")
//    public void operatorVerifiesNoDataDisplayOnPortTrips(){
//        portTripManagementPage.verifyNoResultsFound();
//    }
//
//    @Then("Operator click on {string} button in Port Management page")
//    public void operatorClickOnCreateToFromPortTrip(String button) {
//        switch (button){
//            case "Create Tofrom Port Trip":
//                portTripManagementPage.clickOnCreateToFromPortTrip();
//                break;
//            case "Create Flight Trip":
//                portTripManagementPage.clickOnCreateFlightTrip();
//                break;
//        }
//    }
//
//    @Then("Operator create new port trip using below data:")
//    public void operatorCreateNewPortTrip(Map<String, String> mapOfData) {
//        Map<String, String> resolvedData = resolveKeyValues(mapOfData);
//        portTripManagementPage.createNewPortTrip(resolvedData);
//        String tripId =portTripManagementPage.getPortTripId();
//        put(KEY_CURRENT_MOVEMENT_TRIP_ID,tripId);
//        putInList(KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS,tripId);
//    }
//
//    @And("Verify the new port trip {string} created success message")
//    public void verifySuccessMessagePortTripCreation(String portName) {
//        String expectedMessage = resolveValue(portName);
//        portTripManagementPage.verifyPortTripCreationSuccessMessage(expectedMessage);
//    }
//
//    @Then("Operator verify {string} license driver {string} is not displayed on Create Port Trip page")
//    public void operatorVerifyDriverNotDisplayed(String driverType, String driver) {
//        portTripManagementPage.verifyDriverNotDisplayed(driver);
//    }
//
//    @Then("Operator verifies {string} with value {string} is not shown on Create Port Trip page")
//    public void operatorVerifiesInvalidDriver(String name, String value) {
//        portTripManagementPage.verifyInvalidItem(name, value);
//    }
//
//    @Then("Operator verifies same hub error messages on {string} page")
//    public void OperatorVerifiesErrorMessage(String pageName){
//        portTripManagementPage.getAndVerifySameHubErrorMessage(pageName);
//    }
//
//    @When("Operator fill new port trip using data below:")
//    public void OperatorCreateOTTUsingSamHub(Map<String, String> mapOfData){
//        Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
//        portTripManagementPage.createPortTripUsingData(resolvedMapOfData);
//    }
//
//    @Then("Operator verifies Submit button is disable on Create Port Trip  page")
//    public void operatorVerifySubmitButton(){
//        portTripManagementPage.verifySubmitButtonDisable();
//    }
//
//    @Then("Operator verifies duration time error messages on {string} page")
//    public void operatorVerifiesDurationErrorMessage(String pageName){
//        portTripManagementPage.getAndVerifyZeroDurationTimeErrorMessage(pageName);
//    }
//
//    @Then("Operator verifies past date picker {string} is disable on {string} page")
//    public void operatorVerifiesPastDateDisable(String date, String pageName){
//        portTripManagementPage.verifyPastDayDisable(date,pageName);
//    }
//
//    @When("Operator removes text of {string} field on {string} page")
//    public void operatorRemovesText(String fieldName, String pageName){
//        switch (pageName){
//            case "Create Port Trip":
//                portTripManagementPage.clearTextonField(fieldName);
//                break;
//            case "Create Flight Trip":
//                portTripManagementPage.clearTextonFieldOnFlightTrip(fieldName);
//                break;
//        }
//    }
//
//    @Then("Operator verifies Mandatory require error message of {string} field on {string} page")
//    public void operatorVerifiesMandatoryErrorMessage(String fieldName, String pageName){
//        switch (pageName){
//            case "Create Port Trip":
//                portTripManagementPage.verifyMandatoryFieldErrorMessagePortPage(fieldName);
//                break;
//            case "Create Flight Trip":
//                portTripManagementPage.verifyMandatoryFieldErrorMessageFlightTripPage(fieldName);
//                break;
//        }
//    }
//
//    @Then("Operator verifies MAWB error messages on Create Flight Trip page")
//    public void operatorVerifiesMAWBErrorMessage(){
//        portTripManagementPage.verifyMAWBerrorMessage();
//    }
//
//    @Then("Operator verifies toast messages below on Create Flight Trip page:")
//    public void operatorVerifiesErrorMessages(List<String> expectedError){
//        expectedError = resolveValues(expectedError);
//        portTripManagementPage.verifyToastErrorMessage(expectedError);
//    }
//
//    @Then("Operator verify parameters of air trip on Port Trip Management page:")
//    public void operatorVerifyParametersShipmentOnShipmentManagementPage(Map<String, String> data) {
//        data = resolveKeyValues(data);
//        data = StandardTestUtils.replaceDataTableTokens(data);
//        Long tripID = get(KEY_CURRENT_MOVEMENT_TRIP_ID);
//        AirTrip aitrip = new AirTrip();
//        aitrip.fromMap(data);
//        aitrip.setTrip_id(tripID);
//        portTripManagementPage.validateAirTripInfo(aitrip.getTrip_id(), aitrip);
//        if (data.get("drivers")!=null){
//            List<Driver> expectedDrivers = get(KEY_LIST_OF_CREATED_DRIVERS);
//            portTripManagementPage.verifyListDriver(expectedDrivers);
//        }
//    }
//
//    @When("Operator open edit port trip page with data below:")
//    public void operatorEditAirTripOnPortTripPage(Map<String, String> data){
//        Map<String, String> resolvedData = resolveKeyValues(data);
//        String tripID = resolvedData.get("tripID");
//        portTripManagementPage.portTable.filterByColumn(COLUMN_AIRTRIP_ID,tripID);
//        portTripManagementPage.portTable.clickActionButton(1,ACTION_EDIT);
//        portTripManagementPage.switchToOtherWindow();
//        portTripManagementPage.waitUntilPageLoaded();
//        portTripManagementPage.switchTo();
//        portTripManagementPage.verifyDisableItemsOnEditPage(resolvedData.get("tripType"));
//    }
//
//    @When("Operator edit data on Edit Trip page:")
//    public void operatorEditDataOnEditTripPage(Map<String,String> data){
//        Map<String, String> resolvedData = resolveKeyValues(data);
//        portTripManagementPage.editPortTripItems(resolvedData);
//    }
//
//    @When("Operator departs trip {string} on Port Trip Management page")
//    public void operatorDepartsTripOnPortTripPage(String tripID){
//        tripID = resolveValue(tripID);
//        portTripManagementPage.portTable.filterByColumn(COLUMN_AIRTRIP_ID,tripID);
//        portTripManagementPage.departTrip();
//    }
//
//    @Then("Operator verifies depart trip message {string} display on Port Trip Management page")
//    public void operatorVerifiesDepartTripMessageSuccess(String tripID){
//        tripID = resolveValue(tripID);
//        String expectedMessage = f("Trip %s departed",tripID);
//        portTripManagementPage.verifyDepartedTripSuccessful(expectedMessage);
//    }
//
//    @Then("Operator verifies action buttons below are disable:")
//    public void operatorVerifiesActionButtonsAreDisable(List<String> actionButtons){
//        portTripManagementPage.verifyActionButtonsAreDisabled(actionButtons);
//    }
//
//    @Then("Operator verifies driver error messages below on Port Trip Management page:")
//    public void operatorVerifiesDriverErrorMessages(List<String> expectedErrorMessages){
//        expectedErrorMessages = resolveValues(expectedErrorMessages);
//        portTripManagementPage.verifyDriverErrorMessages(expectedErrorMessages);
//    }
//
//    @When("Operator arrives trip {string} on Port Trip Management page")
//    public void operatorArrivesTripOnPortTripPage(String tripID){
//        tripID = resolveValue(tripID);
//        portTripManagementPage.portTable.filterByColumn(COLUMN_AIRTRIP_ID,tripID);
//        portTripManagementPage.ArriveTripAndVerifyItems();
//    }
//
//    @Then("Operator verifies {string} button is shown on Port Trip Management page")
//    public void operatorVerifiesButtonIsShownOnAirTripPage(String button){
//        portTripManagementPage.verifyButtonIsShown(button);
//
//    }
//
//    @Then("Operator verifies trip message {string} display on Port Trip Management page")
//    public void operatorVerifiesTripMessageSuccess(String tripMessage){
//        tripMessage = resolveValue(tripMessage);
//        portTripManagementPage.verifyTripMessageSuccessful(tripMessage);
//    }
//
//    @When("Operator completes trip {string} on Port Trip Management page")
//    public void operatorCompletesTripOnPortTripPage(String tripID){
//        tripID = resolveValue(tripID);
//        portTripManagementPage.portTable.filterByColumn(COLUMN_AIRTRIP_ID,tripID);
//        portTripManagementPage.CompleteTripAndVerifyItems();
//    }
//
//    @When("Operator cancel trip {value} on Port Trip Management page")
//    public void operatorCacelsTripOnPortTripPage(String tripID){
//        portTripManagementPage.portTable.filterByColumn(COLUMN_AIRTRIP_ID,tripID);
//        portTripManagementPage.CancelTripAndVerifyItems();
//    }
//
//    @When("Operator click assign driver button to trip {value} on Port Trip Management page")
//    public void operatorAssignDriverToTripOnPortTripManagementPage(String tripID) {
//        portTripManagementPage.portTable.filterByColumn(COLUMN_AIRTRIP_ID,tripID);
//        portTripManagementPage.AssignDriversAndVerifyItems();
//    }
//
//    @And("Operator clicks Save button on Assign Driver popup")
//    public void operatorClicksSaveButtonOnAssignDriverPopup() {
//        portTripManagementPage.SaveAssignDriver();
//    }
//
//    @And("Operator selects multiple drivers on Port Trip Management using data below:")
//    public void operatorAssignMultipleDriversOnPortTripManagementUsingDataBelow(Map<String,String> mapOfData) {
//        Map<String,String> resolvedKeyOfData = resolveKeyValues(mapOfData);
//        List<Driver> middleMileDriver = get(KEY_LIST_OF_CREATED_DRIVERS);
//        portTripManagementPage.selectMultipleDrivers(resolvedKeyOfData, middleMileDriver);
//    }
//
//    @Then("Operator successful message {string} display on Assigned Driver popup")
//    public void operatorSuccessfulMessageDisplayOnAssignedDriverPopup(String message) {
//        List<Driver> middleMileDriver = get(KEY_LIST_OF_CREATED_DRIVERS);
//        portTripManagementPage.verifyTripMessageSuccessful(f(message, middleMileDriver.size()));
//    }
//
//    @Then("Operator verifies driver with value {string} is not shown on Port Trip Management page")
//    public void operatorVerifiesWithValueIsNotShownOnPortManagementPage(String driverUsername) {
//        portTripManagementPage.assignDriversToTripModal.addDriver.click();
//        portTripManagementPage.verifyInvalidDriver(driverUsername);
//    }
//
//    @And("Operator clicks Unassign All button on Assign Driver popup")
//    public void operatorClicksUnassignAllButtonOnAssignDriverPopup() {
//        pause3s();
//        portTripManagementPage.assignDriversToTripModal.unassignAllDrivers.click();
//        pause2s();
//    }
//
//    @Then("Operator successful message {string} for unassign driver display on Assigned Driver popup")
//    public void operatorSuccessfulMessageForUnassignDriverDisplayOnAssignedDriverPopup(String message) {
//        portTripManagementPage.verifySuccessUnassignAllDrivers(message);
//    }
//
//    @And("Operator search created flight trip {value} on Port Trip table")
//    public void operatorSearchCreatedFlightTripOnPortTripTable(String tripID) {
//        portTripManagementPage.portTable.filterByColumn(COLUMN_AIRTRIP_ID,tripID);
//    }
//
//    @When("Operator opens view Port Trip page with data below:")
//    public void operatorOpensViewPortTripPageWithDataBelow(Map<String,String> data) {
//        Map<String,String> resolvedData = resolveKeyValues(data);
//        String tripID = resolvedData.get("tripID");
//        String tripType = resolvedData.get("tripType");
//        portTripManagementPage.portTable.filterByColumn(COLUMN_AIRTRIP_ID,tripID);
//        portTripManagementPage.portTable.clickActionButton(1, ACTION_DETAILS);
//        portTripManagementPage.switchToOtherWindow();
//        portTripManagementPage.waitUntilPageLoaded();
//        portTripManagementPage.switchTo();
//        portTripManagementPage.verifyPortTripDetailPageItem(tripType, tripID);
//    }
//
//    @And("Operator clicks Assign Driver button on Port Trip details page")
//    public void operatorClicksAssignDriverButtonOnPortTripDetailsPage() {
//        portTripManagementPage.assignDriverOnPortTripDetails.click();
//        portTripManagementPage.verifyAssignDriverItemsOnTripDetail();
//    }
//
//    @And("Operator verify Assign Driver field not appear in Port Flight Trip Details page")
//    public void operatorVerifyAssignDriverFieldNotAppearInPortFlightTripDetailsPage() {
//        portTripManagementPage.verifyAssignDriverFieldNotAppearInPortFlightTripDetail();
//    }
//
//    @When("Operator clicks View Details action link on successful toast created to from port trip")
//    public void operatorClicksViewDetailsActionLinkOnSuccessfulToastCreatedToFromPortTrip() {
//        portTripManagementPage.viewDetailsActionLink.click();
//        portTripManagementPage.switchToOtherWindow();
//        portTripManagementPage.waitUntilPageLoaded();
//        portTripManagementPage.switchTo();
//    }
//
//    @Then("Operator verifies it direct to trip details page with data below:")
//    public void operatorVerifyItDirectToTripDetailsPageWithDataBelow(Map<String,String> data) {
//        Map<String,String> resolvedData = resolveKeyValues(data);
//        String tripID = resolvedData.get("tripID");
//        String tripType = resolvedData.get("tripType");
//        portTripManagementPage.verifyPortTripDetailPageItem(tripType, tripID);
//    }
//
//    @And("Operator verifies the element of {string} tab on Port Trip details page are correct")
//    public void operatorVerifiesTheElementOfTabOnPortTripDetailsPageAreCorrect(String tabName) {
//        portTripManagementPage.verifyTabElementOnPortTripDetailsPage(tabName);
//    }
//
//    @Then("Operator verifies trip status is {string} on Port Trip details page")
//    public void operatorVerifiesTripStatusIsOnPortTripDetailsPage(String tripStatus) {
//        portTripManagementPage.verifyTripStatusOnPortTripDetailsPage(tripStatus);
//    }
//
//    @Then("Operator verify {string} button is disabled on Port Trip page")
//    public void operatorVerifyButtonIsDisabledOnPortTripPage(String actionButton) {
//        portTripManagementPage.verifyActionsButtonIsDisabledOnPortTripPage(actionButton);
//    }
//
//    @When("Operator assigns MAWB to flight trip with data below:")
//    public void operatorAssignsMAWBToFlightTrip(Map<String, String> data) {
//        Map<String, String> resolvedData = resolveKeyValues(data);
//        String tripID = resolvedData.get("tripID");
//        portTripManagementPage.portTable.filterByColumn(COLUMN_AIRTRIP_ID, tripID);
//        portTripManagementPage.portTable.clickActionButton(1, ACTION_ASSIGN_MAWB);
//        portTripManagementPage.verifyAssignedMawbPage();
//        portTripManagementPage.assignMawb(resolvedData.get("vendor"),resolvedData.get("mawb"));
//    }
//
//    @Then("Operator verifies assigned MAWB success message")
//    public void operatorVerifiesAssignedMawbSuccessMessaage(){
//        portTripManagementPage.verifyAssignMawbSuccessMessage();
//    }
}
