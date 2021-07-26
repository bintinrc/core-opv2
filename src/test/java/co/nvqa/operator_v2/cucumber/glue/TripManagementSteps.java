package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.hub.trip_management.MovementTripType;
import co.nvqa.commons.model.core.hub.trip_management.TripManagementDetailsData;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.MovementTripActionName;
import co.nvqa.operator_v2.model.TripManagementFilteringType;
import co.nvqa.operator_v2.selenium.page.TripManagementPage;
import co.nvqa.operator_v2.util.TestConstants;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.openqa.selenium.WebElement;

/**
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

  @And("Operator verifies movement Trip page is loaded")
  public void operatorMovementTripPageIsLoaded() {
    tripManagementPage.switchTo();
    tripManagementPage.loadButton.waitUntilClickable(30);
  }

  @When("Operator clicks on Load Trip Button")
  public void operatorClicksOnLoadTripButton() {
    tripManagementPage.loadButton.click();
  }

  @When("Operator verify Load Trip Button is gone")
  public void operatorVerifyLoadTripButtonIsGone() {
    tripManagementPage.loadButton.waitUntilInvisible();
  }

  @Then("Operator verifies toast with message {string} is shown on movement page")
  public void operatorVerifiesToastWithMessageIsShownOnTripManagementPage(String toastMessage) {
    toastMessage = toastMessage.replace("#n","\n");
    String resolvedToastMessage = resolveValue(toastMessage);
    tripManagementPage.verifyToastContainingMessageIsShown(resolvedToastMessage);
  }

  @Then("Operator verifies toast with message {string} is shown on movement page without closing")
  public void operatorVerifiesToastWithMessageIsShownOnTripManagementPageWithoutClosing(
      String toastMessage) {
    String resolvedToastMessage = resolveValue(toastMessage);
    tripManagementPage.verifyToastContainingMessageIsShownWithoutClosing(resolvedToastMessage);
  }

  @Then("Operator verifies toast with following messages is shown on movement page without closing:")
  public void operatorVerifiesToastWithFollowingMessagesIsShownOnMovementPageWithoutClosing(
      List<String> toastMessages) {
    List<String> resolvedToastMessages = resolveValues(toastMessages);
    tripManagementPage.waitUntilVisibilityOfElementLocated(
        "//div[contains(@class,'notification-notice-message')]");
    WebElement toast = tripManagementPage.findElementByXpath(
        "//div[contains(@class,'notification-notice-message')]");
    String actualToastMessage = toast.getText().split(" with expected arrival time ")[0];
    assertThat("Trip Management toast message is the same", actualToastMessage,
        isOneOf(resolvedToastMessages.get(0), resolvedToastMessages.get(1)));
  }

  @Then("Operator click force trip completion")
  public void operatorClickForceTripCompletion() {
    tripManagementPage.forceTripCompletion();
  }

  @When("Operator depart trip")
  public void operatorClickDepartTripButton() {
    tripManagementPage.departTrip();
  }

  @When("Operator arrive trip")
  public void operatorClickArriveTripButton() {
    tripManagementPage.arriveTrip();
  }

  @When("Operator complete trip")
  public void operatorClickCompleteTripButton() {
    tripManagementPage.completeTrip();
  }

  @Then("Operator verifies trip has departed")
  public void operatorVerifiesTripHasDeparted() {
    tripManagementPage.verifyTripHasDeparted();
  }

  @Then("Operator verifies that there will be an error shown for unselected Origin Hub")
  public void operatorVerifiesThatThereWillBeAnErrorShownForUnselectedOriginHub() {
    tripManagementPage.verifiesFieldReqiredErrorMessageShown();
  }

  @When("Operator searches and selects the {string} with value {string}")
  public void operatorSearchesAndSelectsWithValue(final String filterName,
      final String filterValue) {
    final Map<String, String> filterMap = new HashMap<>();
    retryIfRuntimeExceptionOccurred(() ->
    {
      try {
        filterMap.put("filterValue", resolveValue(filterValue));
        switch (filterName.toLowerCase()) {
          case "origin hub":
            filterMap.put("filterName", "originHub");
            break;

          case "destination hub":
            filterMap.put("filterName", "destinationHub");
            break;

          case "movement type":
            filterMap.put("filterName", "movementType");
            put(KEY_MOVEMENT_TYPE_INCLUDED, true);
            break;
          default:
            NvLogger.warn("Filter Type is not found!");
        }
        tripManagementPage.selectValueFromFilterDropDownDirectly(filterMap.get("filterName"),
            filterMap.get("filterValue"));
      } catch (Throwable ex) {
        NvLogger.error(ex.getMessage());
        NvLogger.info("Searched element is not found, retrying after 2 seconds...");
        tripManagementPage.refreshPage();
        tripManagementPage.switchTo();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 10);
  }

  @And("Operator verifies a trip to destination hub {string} exist")
  public void operatorVerifiesATripToDestinationHubExist(String destinationHubName) {
    destinationHubName = resolveValue(destinationHubName);
    tripManagementPage
        .searchAndVerifiesTripManagementIsExistedByDestinationHubName(destinationHubName);
  }

  @Then("Operator verifies that the trip management shown in {string} tab is correct")
  public void operatorVerifiesThatTheTripManagementShownIsCorrect(String tabName) {
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
    TripManagementFilteringType tripManagementFilteringType = TripManagementFilteringType
        .fromString(filteringName);
    if ("driver".equalsIgnoreCase(tripManagementFilteringType.getVal())) {
      String driverUsername = get(KEY_TRIP_MANAGEMENT_DRIVER_NAME);
      tripManagementPage
          .tableFiltering(tripManagementFilteringType, tripManagementDetailsData, driverUsername);
      return;
    }

    tripManagementPage.tableFiltering(tripManagementFilteringType, tripManagementDetailsData);
  }

  @And("Operator searches for the Trip Management based on its {string} on arrival tab")
  public void operatorSearchesForTheTripManagementBasedOnItsOnArrivalTab(String filteringName) {
    TripManagementDetailsData tripManagementDetailsData = get(KEY_DETAILS_OF_TRIP_MANAGEMENT);
    TripManagementFilteringType tripManagementFilteringType = TripManagementFilteringType
        .fromString(filteringName);
    int latestIndex = tripManagementDetailsData.getData().size() - 1;
    if (tripManagementDetailsData.getData().size() > 0) {
      ZonedDateTime expectedArrivalTime = tripManagementDetailsData.getData().get(latestIndex)
          .getExpectedArrivalTime().plusDays(1);
      tripManagementDetailsData.getData().get(latestIndex)
          .setExpectedArrivalTime(expectedArrivalTime);
      tripManagementPage.tableFiltering(tripManagementFilteringType, tripManagementDetailsData);
    }
  }

  @Then("Operator verifies that the trip management shown with {string} as its filter is right")
  public void operatorVerifiesThatTheTripManagementShownWithAsItsFilterIsRight(
      String filteringName) {
    TripManagementDetailsData tripManagementDetailsData = get(KEY_DETAILS_OF_TRIP_MANAGEMENT);
    TripManagementFilteringType tripManagementFilteringType = TripManagementFilteringType
        .fromString(filteringName);
    if ("driver".equalsIgnoreCase(tripManagementFilteringType.getVal())) {
      String driverUsername = get(KEY_TRIP_MANAGEMENT_DRIVER_NAME);
      tripManagementPage
          .verifyResult(tripManagementFilteringType, tripManagementDetailsData, driverUsername);
      return;
    }

    tripManagementPage.verifyResult(tripManagementFilteringType, tripManagementDetailsData);
  }

  @Then("Operator verifies that the trip management shown with {string} as its filter is right on arrival tab")
  public void operatorVerifiesThatTheTripManagementShownWithAsItsFilterIsRightOnArrivalTab(
      String filteringName) {
    TripManagementDetailsData tripManagementDetailsData = get(KEY_DETAILS_OF_TRIP_MANAGEMENT);
    TripManagementFilteringType tripManagementFilteringType = TripManagementFilteringType
        .fromString(filteringName);
    if (("expected_arrival_time").equals(tripManagementFilteringType.getVal())) {
      ZonedDateTime expectedArrivalTime = tripManagementDetailsData.getData().get(0)
          .getExpectedArrivalTime().plusDays(1);
      tripManagementDetailsData.getData().get(0).setExpectedArrivalTime(expectedArrivalTime);
      tripManagementPage.verifyResult(tripManagementFilteringType, tripManagementDetailsData);
      return;
    }

    tripManagementPage.verifyResult(tripManagementFilteringType, tripManagementDetailsData);
  }

  @When("Operator clicks on {string} icon on the action column")
  public void operatorClicksOnIconOnTheActionColumn(String actionName) {
    String windowHandle = getWebDriver().getWindowHandle();
    MovementTripActionName movementTripActionName = MovementTripActionName.fromString(actionName);
    String tripId = tripManagementPage.getTripIdAndClickOnActionIcon(movementTripActionName);
    put(KEY_TRIP_ID, tripId);
    put(KEY_MAIN_WINDOW_HANDLE, windowHandle);
  }

  @And("Operator assign driver {string} to created movement trip")
  public void operatorAssignDriverToCreatedMovementScheduleWithData(String driverUsername) {
    String resolvedDriverUsername = resolveValue(driverUsername);
    tripManagementPage.assignDriver(resolvedDriverUsername);
  }

  @And("Operator clear all assigned driver in created movement")
  public void operatorClearAllAssignedDriverInCreatedMovementTrip() {
    tripManagementPage.clearAssignedDriver();
  }

  @And("Operator assign following drivers to created movement trip:")
  public void operatorSAssignFollowingDriversToCreatedMovementTrip(Map<String, String> mapOfData) {
    Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
    String primaryDriver = resolvedMapOfData.get("primaryDriver");
    String additionalDriver = resolvedMapOfData.get("additionalDriver");
    tripManagementPage.assignDriverWithAdditional(primaryDriver, additionalDriver);
  }

  @Then("Operator verifies that the new tab with trip details is opened")
  public void operatorVerifiesThatTheNewTabWithTripDetailsIsOpened() {
    String tripId = get(KEY_TRIP_ID);
    String windowHandle = get(KEY_MAIN_WINDOW_HANDLE);
    tripManagementPage.verifiesTripDetailIsOpened(tripId, windowHandle);
  }

  @And("Operator clicks {string} button on cancel trip dialog")
  public void operatorClicksButtonOnCancelTripDialog(String buttonValue) {
    tripManagementPage.clickButtonOnCancelDialog(buttonValue);
  }

  @And("Operator verifies that there will be a movement trip {string} cancelled toast shown")
  public void operatorVerifiesMovementTripCancelledToastShown(String tripIdAsString) {
    Long resolvedTripId = Long.valueOf(resolveValue(tripIdAsString));
    tripManagementPage.verifiesSuccessCancelTripToastShown(resolvedTripId);
  }

  @And("Operator searches for Movement Trip based on status {string}")
  public void operatorSearchesForMovementTripBasedOnStatus(String statusValue) {
    tripManagementPage.tableFilterByStatus(statusValue);
  }

  @Then("Operator verifies movement trip shown has status value {string}")
  public void operatorVerifiesMovementTripShownHasStatusValue(String statusValue) {
    String tripId = get(KEY_CURRENT_MOVEMENT_TRIP_ID);
    tripManagementPage.verifyStatusValue(tripId, statusValue.toLowerCase());
  }

  @Then("Operator verifies movement trip shown has status value {string} for trip id {string}")
  public void operatorVerifiesMovementTripShownHasStatusValue(String statusValue,
      String tripIdAsString) {
    String tripId = resolveValue(tripIdAsString);
    tripManagementPage.verifyStatusValue(tripId, statusValue.toLowerCase());
  }

  @Then("Operator verifies {string} button disabled")
  public void operatorVerifiesButtonDisabled(String buttonValue) {
    assertFalse(tripManagementPage.isElementEnabled(buttonValue));
  }

  @Then("Operator verifies event {string} with status {string} is present for trip on Trip events page")
  public void operatorVerifiesEventIsPresentForTripOnTripEventsPage(String tripEvent,
      String tripStatus) {
    String stringTripId = get(KEY_CURRENT_MOVEMENT_TRIP_ID);
    Long longTripId = Long.valueOf(stringTripId);
    navigateTo(f("%s/%s/movement-trips/%d/details", TestConstants.OPERATOR_PORTAL_BASE_URL,
        TestConstants.COUNTRY_CODE, longTripId));
    tripManagementPage.switchTo();
    // TODO: Uncomment after ticket is fixed by the dev team
//    tripManagementPage.verifyEventExist(tripEvent, tripStatus);
  }

  @Then("Operator verifies event {string} with status {string} is present for trip on Trip events page for trip with id {string}")
  public void operatorVerifiesEventIsPresentForTripOnTripEventsPage(String tripEvent,
      String tripStatus, String tripIdAsString) {
    String stringTripId = resolveValue(tripIdAsString);
    Long longTripId = Long.valueOf(stringTripId);
    navigateTo(f("%s/%s/movement-trips/%d/detail", TestConstants.OPERATOR_PORTAL_BASE_URL,
        TestConstants.COUNTRY_CODE, longTripId));
    tripManagementPage.switchTo();
    tripManagementPage.verifyEventExist(tripEvent, tripStatus);
  }

}
