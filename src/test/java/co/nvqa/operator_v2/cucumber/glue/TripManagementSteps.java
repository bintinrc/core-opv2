package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.hub.trip_management.MovementTripType;
import co.nvqa.commons.model.core.hub.trip_management.TripManagementDetailsData;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.selenium.page.TripManagementPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;

/**
 *
 * @author Tristania Siagian
 */

public class TripManagementSteps extends AbstractSteps {
    private TripManagementPage tripManagementPage;

    private static final String TRIP_MANAGEMENT_URL = "https://operatorv2-qa.ninjavan.co/#/sg/trip-management";

    public TripManagementSteps() {
    }

    @Override
    public void init() {
        tripManagementPage = new TripManagementPage(getWebDriver());
    }

    @Given("Operator goes to Trip Management Page")
    public void operatorGoesToTripManagementPage() {
        navigateTo(TRIP_MANAGEMENT_URL);
        pause1s();
    }

    @And("Operator verifies that the Trip Management Page is opened")
    public void operatorVerifiesThatTheTripManagementPageIsOpened() {
        tripManagementPage.verifiesTripManagementIsLoaded();
    }

    @When("Operator clicks on Load Trip Button")
    public void operatorClicksOnLoadTripButton() {
        tripManagementPage.clickLoadButton();
    }

    @Then("Operator verifies that there will be an error shown for unselected Origin Hub")
    public void operatorVerifiesThatThereWillBeAnErrorShownForUnselectedOriginHub() {
        tripManagementPage.verifiesFieldReqiredErrorMessageShown();
    }

    @When("Operator selects the {string} with value {string}")
    public void operatorSelectsTheWithValue(String filterName, String filterValue) {
        switch (filterName.toLowerCase()) {
            case "origin hub" :
                filterName = "originHub";
                break;

            case "destination hub" :
                filterName = "destinationHub";
                break;

            case "movement type" :
                filterName = "movementType";
                put(KEY_MOVEMENT_TYPE_INCLUDED, true);
                break;

            default :
                NvLogger.warn("Filter Type is not found!");
        }

        tripManagementPage.selectValueFromFilterDropDown(filterName, filterValue);
    }

    @Then("Operator verifies that the trip management shown in {string} tab is correct")
    public void operatorVerifiesThetTheTripManagementShownIsCorrect(String tabName) {
        TripManagementDetailsData tripManagementDetailsData = get(KEY_DETAILS_OF_TRIP_MANAGEMENT);
        Long tripManagementCount = tripManagementDetailsData.getCount();
        MovementTripType tabNameAsEnum = MovementTripType.fromString(tabName);
        if (tripManagementCount != null && tripManagementCount != 0) {
            tripManagementPage.verifiesSumOfTripManagement(tabNameAsEnum, tripManagementCount);
        } else {
            tripManagementPage.verifiesNoResult();
        }
    }

    @Then("Operator verifies that the archived trip management is shown correctly")
    public void operatorVerifiesThatTheArchivedTripManagementIsShownCorrectly() {
        TripManagementDetailsData tripManagementDetailsData = get(KEY_DETAILS_OF_TRIP_MANAGEMENT);
        if (tripManagementDetailsData.getCount() != null && tripManagementDetailsData.getCount() != 0) {
            int index = tripManagementDetailsData.getData().size() - 1;
            Long tripManagementId = tripManagementDetailsData.getData().get(index).getId();
            tripManagementPage.searchAndVerifiesTripManagementIsExisted(tripManagementId);
        } else {
            tripManagementPage.verifiesNoResult();
        }
    }

    @When("Operator selects the date to tomorrow in {string} Tab")
    public void operatorSelectsTheDateToTomorrow(String tabName) {
        ZonedDateTime zdt = DateUtil.getDate().plusDays(1);
        String tomorrowDateFormatted = zdt.format(DateTimeFormatter.ofPattern("MMMM d, yyyy"));
        MovementTripType tabNameAsEnum = MovementTripType.fromString(tabName);
        tripManagementPage.selectsDate(tabNameAsEnum, tomorrowDateFormatted);
    }

    @When("Operator selects the date to {int} days early in {string} filter")
    public void operatorSelectsTheDateToTomorrow(int days, String filterName) {
        ZonedDateTime zdt = DateUtil.getDate().minusDays(days);
        String tomorrowDateFormatted = zdt.format(DateTimeFormatter.ofPattern("MMMM d, yyyy"));
        MovementTripType tabNameAsEnum = MovementTripType.fromString(filterName);
        tripManagementPage.selectsDateArchiveTab(tabNameAsEnum, tomorrowDateFormatted);
    }

    @When("Operator clicks on {string} tab")
    public void operatorClicksOnTab(String tabName) {
        tripManagementPage.clickTabBasedOnName(tabName);
    }
}
