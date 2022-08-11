package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.AirportTripManagementPage;
import io.cucumber.java.en.And;
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
        airportTripManagementPage.fillDepartureDateDetails(mapOfData);
    }

    @When("Operator fill the Origin Or Destination for Airport Management")
    public void operatorFilltheOriginDetailsInAirportManagement(Map<String, String> mapOfData) {
        airportTripManagementPage.fillOrigDestDetails(mapOfData);
    }

    @And("Verify operator cannot fill more than 4 Origin Or Destination for Airport Management")
    public void verifyMaxOriginDetailsInAirportManagement() {
        airportTripManagementPage.verifyMaxOrigDestDetails();
    }

    @And("Operator click on 'Load Trips' on Airport Management")
    public void operatorclickOnLoadTripsOnAirportManagement() {
        airportTripManagementPage.clickOnLoadTripsAirportManagementDetails();
    }

    @Then("Verify the parameters of loaded trips in Airport Management")
    public void verifyParametersinAirportManagement(Map<String, String> mapOfData) {
        airportTripManagementPage.verifyLoadedTripsPageInAirportManagementDetails(mapOfData);
    }

    @And("Create a new flight trip with below data:")
    public void operatorCreateNewFlightTripInAirportManagement(Map<String, String> mapOfData) {
        airportTripManagementPage.createNewFlightTrip(mapOfData);
    }

    @And("Operator search the {string} column")
    public void operatorSearchesInAirportManagement(String filter) {
        put("KEY_AIRPORT_MANAGEMENT_FILTER", airportTripManagementPage.filterTheAirportTripsTable(filter));
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
        put("KEY_NEW_AIRPORT_DETAILS", mapOfData);
        putInList("KEY_NEW_AIRPORT_LIST", mapOfData.get("airportCode"));
    }

    @And("Verify the new airport {string} created success message")
    public void verifySuccessMessageAirportCreation(String airportName) {
        airportTripManagementPage.verifyAirportCreationSuccessMessage(airportName);
    }

    @And("Verify the newly created airport values in table")
    public void verifyNewlyCreatedAirport() {
        airportTripManagementPage.verifyNewlyCreatedAirport(get("KEY_NEW_AIRPORT_DETAILS"));
    }

    @And("Capture the error in Airport Trip Management Page")
    public void captureTheErrorInAirportCreation() {
        airportTripManagementPage.captureErrorNotification();
    }

    @And("Verify the error {string} is displayed while creating new airport")
    public void verifyTheErrorInAirportCreation(String expError) {
        airportTripManagementPage.verifyTheErrorInAirportCreation(expError);
    }

    @And("Verify the validation error {string} is displayed")
    public void verifyTheValidationErrorInAirportCreation(String expError) {
        airportTripManagementPage.verifyTheValidationErrorInAirportCreation(expError);
    }
}
