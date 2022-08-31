package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.sort.hub.Airport;
import co.nvqa.operator_v2.selenium.page.AirportTripManagementPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;

public class AirportTripManagementSteps extends AbstractSteps{
    private static final Logger LOGGER = LoggerFactory.getLogger(AirportTripManagementSteps.class);

    private AirportTripManagementPage airportTripManagementPage;

    public AirportTripManagementSteps() {
    }

    @Override
    public void init() {
        airportTripManagementPage = new AirportTripManagementPage(getWebDriver());
    }

    @And("Operator verifies that the Airport Management Page is opened")
    public void operatorVerifiesThatTheAirportTripManagementPageIsOpened() {
        airportTripManagementPage.switchTo();
        airportTripManagementPage.verifyAirportTripMovementPageItems();
        pause2s();
    }

    @When("Operator fill the departure date for Airport Management")
    public void operatorFilltheDetailsInAirportManagement(Map<String, String> mapOfData) {
        Map<String, String> resolvedData = resolveKeyValues(mapOfData);
        airportTripManagementPage.fillDepartureDateDetails(resolvedData);
    }

    @When("Operator fill the Origin Or Destination for Airport Management")
    public void operatorFilltheOriginDetailsInAirportManagement(Map<String, String> mapOfData) {
        Map<String, String> resolvedData = resolveKeyValues(mapOfData);
        airportTripManagementPage.fillOrigDestDetails(resolvedData);
    }

    @And("Verify operator cannot fill more than 4 Origin Or Destination for Airport Management")
    public void verifyMaxOriginDetailsInAirportManagement() {
        airportTripManagementPage.verifyMaxOrigDestDetails();
    }

    @And("Operator click on 'Load Trips' on Airport Management")
    public void operatorclickOnLoadTripsOnAirportManagement() {
        airportTripManagementPage.clickOnLoadTripsAirportManagementDetails();
        takesScreenshot();
    }

    @Then("Verify the parameters of loaded trips in Airport Management")
    public void verifyParametersinAirportManagement(Map<String, String> mapOfData) {
        Map<String, String> resolvedData = resolveKeyValues(mapOfData);
        airportTripManagementPage.verifyLoadedTripsPageInAirportManagementDetails(resolvedData);
    }

    @And("Create a new flight trip with below data:")
    public void operatorCreateNewFlightTripInAirportManagement(Map<String, String> mapOfData) {
        airportTripManagementPage.createNewFlightTrip(mapOfData);
    }

    @And("Operator search the {string} column")
    public void operatorSearchesInAirportManagement(String filter) {
        put("KEY_AIRPORT_MANAGEMENT_FILTER", airportTripManagementPage.filterTheAirportTripsTable(filter, ""));
    }

    @And("Operator search the {string} column with invalid data {string}")
    public void operatorSearchesInAirportManagement(String filter, String invalidData) {
        put("KEY_AIRPORT_MANAGEMENT_FILTER", airportTripManagementPage.filterTheAirportTripsTable(filter, invalidData));
    }

    @And("Verify only filtered results are displayed")
    public void verifyTheFilteredResults() {
        HashMap<String, String> map = get("KEY_AIRPORT_MANAGEMENT_FILTER");
        airportTripManagementPage.verifyFilteredResultsInAirportTripsTable(map);
    }

    @When("Operator click on Manage Airport Facility and verify all components")
    public void operatorOpenManageAirportFacility() {
        airportTripManagementPage.operatorOpenManageAirportFacility();
    }

    @Then("Operator Add new Airport")
    public void operatorAddsNewAirport(Map<String, String> mapOfData) {
        airportTripManagementPage.createNewAirport(mapOfData);
        put(KEY_NEW_AIRPORT_DETAILS, mapOfData);
        putInList(KEY_NEW_AIRPORT_LIST, mapOfData.get("airportCode"));
    }

    @And("Verify the new airport {string} created success message")
    public void verifySuccessMessageAirportCreation(String airportName) {
        airportTripManagementPage.verifyAirportCreationSuccessMessage(airportName);
    }

    @And("Verify the newly created airport values in table")
    public void verifyNewlyCreatedAirport() {
        airportTripManagementPage.verifyNewlyCreatedAirport(get(KEY_NEW_AIRPORT_DETAILS));
    }

    @And("Capture the error in Airport Trip Management Page")
    public void captureTheErrorInAirportCreation() {
        airportTripManagementPage.captureErrorNotification();
    }

    @And("Verify the error {string} is displayed while creating new airport")
    public void verifyTheErrorInAirportCreation(String expError) {
        airportTripManagementPage.verifyTheErrorInAirportCreation(expError);
    }

    @Given("Operator search airport by {string}")
    public void operatorSeachAirport(String searchValue){
        String invalidValue = "AAAAA";
        Airport airport = get(KEY_NEW_AIRPORT_DETAILS);
        switch (searchValue.toLowerCase()){
            case "id":
                if(!(airport ==null)){
                    airportTripManagementPage.searchAirport(airportTripManagementPage.airportIdFilter, airport.getId().toString());
                } else {
                    airportTripManagementPage.searchAirport(airportTripManagementPage.airportIdFilter, invalidValue);
                }
                break;
            case "airport code":
                if(!(airport ==null)){
                    airportTripManagementPage.searchAirport(airportTripManagementPage.airportCodeFilter, airport.getAirport_code());
                } else {
                    airportTripManagementPage.searchAirport(airportTripManagementPage.airportCodeFilter, invalidValue);
                }
                break;
            case "airport name":
                if(!(airport ==null)){
                    airportTripManagementPage.searchAirport(airportTripManagementPage.airportNameFilter, airport.getAirport_name());
                } else {
                    airportTripManagementPage.searchAirport(airportTripManagementPage.airportNameFilter, invalidValue);
                }
                break;
            case "city":
                if(!(airport ==null)){
                    airportTripManagementPage.searchAirport(airportTripManagementPage.airportCityFilter, airport.getCity());
                } else {
                    airportTripManagementPage.searchAirport(airportTripManagementPage.airportCityFilter, invalidValue);
                }
                break;
            case "region":
                if(!(airport ==null)){
                    airportTripManagementPage.searchAirport(airportTripManagementPage.airportRegionFilter, airport.getRegion());
                } else {
                    airportTripManagementPage.searchAirport(airportTripManagementPage.airportRegionFilter, invalidValue);
                }
                break;
            case "latitude, longitude":
                if(!(airport ==null)){
                    String longLat = airport.getLatitude().toString()+", "+airport.getLongitude().toString();
                    airportTripManagementPage.searchAirport(airportTripManagementPage.airportLatitudeLongitudeFilter, longLat);
                } else {
                    airportTripManagementPage.searchAirport(airportTripManagementPage.airportLatitudeLongitudeFilter, invalidValue);
                }
                break;
        }
    }

    @Then("Operator verifies the search airport on Airport Facility page")
    public void operatorVerifiesSearchAirport() {
        Airport airport = get(KEY_NEW_AIRPORT_DETAILS);
        airportTripManagementPage.verifySearchedAirport(airport);
    }

    @And("Verify the validation error {string} is displayed")
    public void verifyTheValidationErrorInAirportCreation(String expError) {
        airportTripManagementPage.verifyTheValidationErrorInAirportCreation(expError);

    }

    @Then("Operator verifies that no data appear on Airport Facility page")
    public void operatorVerifiesNoDataDisplay(){
        airportTripManagementPage.verifyNodataDisplay();
    }

    @Then("Edit the {string} for created Airport")
    public void operatorAddsNewAirport(String editField, Map<String, String> mapOfData) {
        Map<String, String> map = get(KEY_NEW_AIRPORT_DETAILS);
        Map<String, String> updatedMap = new HashMap<>();
        updatedMap.putAll(map);
        updatedMap.put(editField, mapOfData.get(editField));
        airportTripManagementPage.editExistingAirport(editField, updatedMap, map);
        put(KEY_UPDATED_AIRPORT_DETAILS, updatedMap);
        putInList(KEY_NEW_AIRPORT_LIST, mapOfData.get("airportCode"));
    }

    @And("Verify the newly updated airport values in table")
    public void verifyNewlyUpdatedAirport() {
        airportTripManagementPage.verifyNewlyCreatedAirport(get(KEY_UPDATED_AIRPORT_DETAILS));
    }

    @Then("Operator click on Disable button for the created Airport in table")
    public void operatorDisableNewAirport() {
        airportTripManagementPage.disableExistingAirport(get(KEY_NEW_AIRPORT_DETAILS));
    }

    @Then("Click on {string} button on panel")
    public void operatorClickOnCancelOrDisable(String buttonName) {
        airportTripManagementPage.clickOnCancelOrDisable(buttonName);
    }

    @Then("Operator click on Activate button for the created Airport in table")
    public void operatorActivteNewAirport() {
        airportTripManagementPage.activateExistingAirport(get(KEY_NEW_AIRPORT_DETAILS));
    }

    @Then("Verify the airport is displayed with {string} button")
    public void verifyTheButtonIsDisplayed(String buttonName) {
        airportTripManagementPage.verifyButton(get(KEY_NEW_AIRPORT_DETAILS), buttonName);
    }

    @Then("Operator verifies that no data appear on Airport Trips page")
    public void operatorVerifiesNoDataDisplayOnAirportTrips(){
        airportTripManagementPage.verifyNoResultsFound();
    }

    @Then("Operator click on 'Create Tofrom Airport Trip' button in Airport Management page")
    public void operatorclickOnCreateToFromAirportTrip() {
        airportTripManagementPage.clickOnCreateToFromAirportTrip();
    }

    @Then("Operator create new airport trip using below data:")
    public void operatorCreateNewAirportTrip(Map<String, String> mapOfData) {
        Map<String, String> resolvedData = resolveKeyValues(mapOfData);
        airportTripManagementPage.createNewAirportTrip(resolvedData);
        String tripId =airportTripManagementPage.getAirportTripId();
        put(KEY_CURRENT_MOVEMENT_TRIP_ID,tripId);
        putInList(KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS,tripId);
    }

    @And("Verify the new airport trip {string} created success message")
    public void verifySuccessMessageAirportTripCreation(String airportName) {
        String expectedMessage = resolveValue(airportName);
        airportTripManagementPage.verifyAirportTripCreationSuccessMessage(expectedMessage);
    }

    @Then("Operator verify {string} license driver {string} is not displayed on Create Airport Trip page")
    public void operatorverifyDriverNotDisplayed(String driverType, String driver) {
        airportTripManagementPage.verifyDriverNotDisplayed(driver);
    }

    @Then("Operator verifies {string} with value {string} is not shown on Create Airport Trip page")
    public void operatorVerifiesInvalidDriver(String name, String value) {
        airportTripManagementPage.verifyInvalidItem(name, value);
    }

    @Then("Operator verifies same hub error messages on Create Airport Trip page")
    public void OperatorVerifiesErrorMessage(){
        airportTripManagementPage.getAndVerifySameHubErrorMessage();
    }

    @When("Operator fill new airport trip using data below:")
    public void OperatorCreateOTTUsingSamHub(Map<String, String> mapOfData){
        Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
        airportTripManagementPage.createAirportTripUsingData(resolvedMapOfData);
    }

    @Then("Operator verifies Submit button is disable on Create Airport Trip  page")
    public void operatorVerifySubmitButton(){
        airportTripManagementPage.verifySubmitButtonDisable();
    }

    @Then("Operator verifies duration time error messages on Create Airport Trip page")
    public void operatorVerifiesDurationErrorMessage(){
        airportTripManagementPage.getAndVerifyZeroDurationTimeErrorMessage();
    }

    @Then("Operator verifies past date picker {string} is disable on Create Airport Trip page")
    public void operatorVerifiesPastDateDisable(String date){
        airportTripManagementPage.verifyPastDayDisable(date);
    }

    @When("Operator removes text of {string} field on Create Airport Trip page")
    public void operatorRemovesText(String fieldName){
        airportTripManagementPage.clearTextonField(fieldName);
    }

    @Then("Operator verifies Mandatory require error message on {string} field")
    public void operatorVerifiesMandatoryErrorMessage(String fieldName){
        airportTripManagementPage.verifyMandatoryFieldErrorMessage(fieldName);
    }


}
