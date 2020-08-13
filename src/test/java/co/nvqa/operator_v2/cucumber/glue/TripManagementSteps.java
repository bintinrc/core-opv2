package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.hub.trip_management.MovementTripType;
import co.nvqa.commons.model.core.hub.trip_management.TripManagementDetailsData;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.TripManagementFilteringType;
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

    public TripManagementSteps() {
    }

    @Override
    public void init() {
        tripManagementPage = new TripManagementPage(getWebDriver());
    }

    @And("Operator verifies that the Trip Management Page is opened")
    public void operatorVerifiesThatTheTripManagementPageIsOpened() {
        pause2s();
        tripManagementPage.verifiesTripManagementIsLoaded();
        pause2s();
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
            return;
        }

        tripManagementPage.verifiesNoResult();
    }

    @Then("Operator verifies that the archived trip management is shown correctly")
    public void operatorVerifiesThatTheArchivedTripManagementIsShownCorrectly() {
        TripManagementDetailsData tripManagementDetailsData = get(KEY_DETAILS_OF_TRIP_MANAGEMENT);
        if (tripManagementDetailsData.getCount() != null && tripManagementDetailsData.getCount() != 0) {
            int index = tripManagementDetailsData.getData().size() - 1;
            Long tripManagementId = tripManagementDetailsData.getData().get(index).getId();
            tripManagementPage.searchAndVerifiesTripManagementIsExistedById(tripManagementId);
            return;
        }

        tripManagementPage.verifiesNoResult();
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

    @And("Operator searches for the Trip Management based on its {string}")
    public void operatorSearchesForTheTripManagementBasedOnIts(String filteringName) {
        TripManagementDetailsData tripManagementDetailsData = get(KEY_DETAILS_OF_TRIP_MANAGEMENT);
        TripManagementFilteringType tripManagementFilteringType = TripManagementFilteringType.fromString(filteringName);
        if ("driver".equalsIgnoreCase(tripManagementFilteringType.getVal())) {
            String driverUsername = get(KEY_TRIP_MANAGEMENT_DRIVER_NAME);
            tripManagementPage.tableFiltering(tripManagementFilteringType, tripManagementDetailsData, driverUsername);
            return;
        }

        tripManagementPage.tableFiltering(tripManagementFilteringType, tripManagementDetailsData);
    }

    @Then("Operator verifies that the trip management shown with {string} as its filter is right")
    public void operatorVerifiesThatTheTripManagementShownWithAsItsFilterIsRight(String filteringName) {
        TripManagementDetailsData tripManagementDetailsData = get(KEY_DETAILS_OF_TRIP_MANAGEMENT);
        TripManagementFilteringType tripManagementFilteringType = TripManagementFilteringType.fromString(filteringName);
        if ("driver".equalsIgnoreCase(tripManagementFilteringType.getVal())) {
            String driverUsername = get(KEY_TRIP_MANAGEMENT_DRIVER_NAME);
            tripManagementPage.verifyResult(tripManagementFilteringType, tripManagementDetailsData, driverUsername);
            return;
        }

        tripManagementPage.verifyResult(tripManagementFilteringType, tripManagementDetailsData);
    }
}