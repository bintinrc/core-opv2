package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.mm.model.MiddleMileDriver;
import co.nvqa.common.mm.model.MovementTrip;
import co.nvqa.commons.model.core.Driver;
import co.nvqa.commons.model.core.hub.trip_management.MovementTripType;
import co.nvqa.commons.model.core.hub.trip_management.TripManagementDetailsData;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.MovementTripActionName;
import co.nvqa.operator_v2.model.TripManagementFilteringType;
import co.nvqa.operator_v2.selenium.page.MainPage;
import co.nvqa.operator_v2.selenium.page.TripManagementPage;
import co.nvqa.operator_v2.util.TestConstants;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.text.SimpleDateFormat;
import java.time.LocalTime;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebElement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.common.mm.cucumber.MiddleMileScenarioStorageKeys.KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS;
import static co.nvqa.common.mm.utils.MiddleMileUtils.isCommaSeparated;
import static co.nvqa.common.mm.utils.MiddleMileUtils.isSingleKeyObject;

/**
 * @author Tristania Siagian
 */

public class TripManagementSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(TripManagementSteps.class);

  private TripManagementPage tripManagementPage;
  private MainPage mainPage;
  private List<String> filterList = Arrays.asList("destinationHub", "originHub", "movementType",
      "OneTimeOriginHub", "OneTimeDestinationHub", "OneTimeMovementType");

  public TripManagementSteps() {
  }

  @Override
  public void init() {
    tripManagementPage = new TripManagementPage(getWebDriver());
    mainPage = new MainPage(getWebDriver());
  }

  private <T> List<T> resolveListOfKeys(String str, Class<T> clazz) {
    if (isCommaSeparated(str)) {
      return Arrays.stream(str.split(",")).map(key -> resolveValue(key, clazz)).collect(Collectors.toList());
    } else if (isSingleKeyObject(str)) {
      return Collections.singletonList(resolveValue(str));
    }
    return resolveValue(str);
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
    tripManagementPage.verifyTripMovementPageItems();
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
    String[] messages = toastMessage.split("&&");
    TripManagementPage.actualToastMessageContent = "";
    tripManagementPage.readTheToastMessage();
    for (String message : messages) {
      toastMessage = message.replace("#n", "\n");
      String resolvedToastMessage = resolveValue(toastMessage);
      tripManagementPage.verifyToastContainingMessageIsShown(resolvedToastMessage);
    }
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
    Assertions.assertThat(actualToastMessage).as("Trip Management toast message is the same")
        .isIn(resolvedToastMessages.get(0), resolvedToastMessages.get(1));
  }

  @Then("Operator click force trip completion")
  public void operatorClickForceTripCompletion() {
    tripManagementPage.forceTripCompletion();
  }

  @When("Operator depart trip")
  public void operatorClickDepartTripButton() {
    tripManagementPage.departTrip();
  }

  @When("Operator departs trip with driver")
  public void operatorClickDepartTripButtonWithDriver() {
    tripManagementPage.departTripWithDrivers();
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
    doWithRetry(() ->
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
          case "one time trip origin hub":
            filterMap.put("filterName", "OneTimeOriginHub");
            break;
          case "one time trip destination hub":
            filterMap.put("filterName", "OneTimeDestinationHub");
            break;
          case "one time trip movement type":
            filterMap.put("filterName", "OneTimeMovementType");
            break;
          default:
            LOGGER.warn("Filter Type: {} is not found!", filterName);
        }
        tripManagementPage.selectValueFromFilterDropDownDirectly(filterMap.get("filterName"),
            filterMap.get("filterValue"));
      } catch (Throwable ex) {
        LOGGER.info("Searched element is not found, retrying after 2 seconds...");
        tripManagementPage.refreshPage();
        tripManagementPage.switchTo();
        throw new NvTestRuntimeException(ex);
      }
    }, "Searching trip...", 1000, 10);
  }

  @And("Operator verifies a trip to destination hub {string} exist")
  public void operatorVerifiesATripToDestinationHubExist(String destinationHubName) {
    destinationHubName = resolveValue(destinationHubName);
    tripManagementPage
        .searchAndVerifiesTripManagementIsExistedByDestinationHubName(destinationHubName);
  }

  @Then("Operator verifies that the trip management shown in {string} tab is correct")
  public void operatorVerifiesThatTheTripManagementShownIsCorrect(String tabName) {
    final TripManagementDetailsData tripManagementDetailsData = get(KEY_DETAILS_OF_TRIP_MANAGEMENT);
    // Get the record counts for today
    final Long tripManagementCount = tripManagementDetailsData.getData().stream().filter(
            (job) -> job.getExpectedDepartureTime().toString()
                .contains(DateUtil.getDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))))
        .count();

    MovementTripType tabNameAsEnum = MovementTripType.fromString(tabName);
    if (tripManagementCount != null && tripManagementCount != 0) {
      tripManagementPage.verifiesSumOfTripManagement(tabNameAsEnum, tripManagementCount);
      return;
    }

    tripManagementPage.verifiesNoResult();
  }

  @Then("Operator verifies trips shown on {string} tab of Movement Trip page are the same as {string}")
  public void operatorVerifiesTripsShownOnMovementTripPageAreTheSameAs(String tab, String storageKey) {
    List<MovementTrip> trips = resolveValueAsList(storageKey, MovementTrip.class);

    if (!trips.isEmpty()) {
      tripManagementPage.verifiesSumOfTripManagement(tab, trips.size());
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
    String tomorrowDateFormatted = zdt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    MovementTripType tabNameAsEnum = MovementTripType.fromString(tabName);
    tripManagementPage.selectsDate(tabNameAsEnum, tomorrowDateFormatted);
  }

  @When("Operator selects the date to {int} days early in {string} filter")
  public void operatorSelectsTheDateToTomorrow(int days, String filterName) {
    ZonedDateTime zdt = DateUtil.getDate().minusDays(days);
    String tomorrowDateFormatted = zdt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
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

  @And("Operator searches for the Trip Management for driver {value}")
  public void operatorSearchesForTheTripManagementBasedOnItsDriver(String driverUsername) {
    TripManagementDetailsData tripManagementDetailsData = get(KEY_DETAILS_OF_TRIP_MANAGEMENT);
    TripManagementFilteringType tripManagementFilteringType = TripManagementFilteringType
        .fromString("driver");

    tripManagementPage
        .tableFiltering(tripManagementFilteringType, tripManagementDetailsData, driverUsername);
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

  @Then("Operator verifies that the trip management assigned to driver {value}")
  public void operatorVerifiesThatTheTripManagementAssignedToDriver(
      String driverUsername) {
    TripManagementDetailsData tripManagementDetailsData = get(KEY_DETAILS_OF_TRIP_MANAGEMENT);
    TripManagementFilteringType tripManagementFilteringType = TripManagementFilteringType
        .fromString("driver");

    tripManagementPage
        .verifyResult(tripManagementFilteringType, tripManagementDetailsData, driverUsername);
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
    Assertions.assertThat(tripManagementPage.isElementEnabled(buttonValue)).isFalse();
  }

  @Then("Operator verifies event {string} with status {string} is present for trip on Trip events page")
  public void operatorVerifiesEventIsPresentForTripOnTripEventsPage(String tripEvent,
      String tripStatus) {
    String stringTripId = get(KEY_CURRENT_MOVEMENT_TRIP_ID);
    Long longTripId = Long.valueOf(stringTripId);
    navigateTo(f("%s/%s/movement-trips/%d/details", TestConstants.OPERATOR_PORTAL_BASE_URL,
        TestConstants.NV_SYSTEM_ID, longTripId));
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
        TestConstants.NV_SYSTEM_ID, longTripId));
    tripManagementPage.switchTo();
    tripManagementPage.verifyEventExist(tripEvent, tripStatus);
  }

  @When("Operator force complete trip")
  public void operatorForceCompleteTrip() {
    tripManagementPage.forceCompleteTrip();
  }

  @When("Operator click on Assign Driver button on Department page")
  public void clickAssignDriverButton() {
    tripManagementPage.clickAssignDriverButtonOnDetailPage();
  }

  @When("Operator click on Unassign All driver button on Assign Driver page")
  public void clickUnassignDriverButton() {
    tripManagementPage.clickUnassignAllOnAssignDriverPage();
  }

  @Then("Pencil icon button on Assign driver is not visible")
  public void AssignDriverIconInvisible() {
    tripManagementPage.verifyAssignDriverInvisible();
  }

  @Then("Operator verify Items display on Assign Driver Page")
  public void OperatorVerifyItemsOnAssginDriverPage() {
    tripManagementPage.verifyItemsDisplayOnAssignDriverPage();
  }

  @When("Operator click on Shipment tab")
  public void OperatorClickOnShipmentTab() {
    tripManagementPage.clickShipmentTab();
  }

  @Then("Operator verifies the elements on Shipment tab are correct")
  public void OperatorVerifiesElementOnShipmentTab() {
    tripManagementPage.verifyShipmentTabElements();
  }

  @When("Operator goes to current page plus parameters {string}")
  public void GotoCurrentPagePlusParameters(String parameters) {
    String currentURL = mainPage.getCurrentUrl();
    mainPage.goToUrl(currentURL + parameters);
    mainPage.refreshPage();
    tripManagementPage.switchTo();
  }

  @When("Operator select Cancellation Reason on Cancel Trip Page")
  public void OperatorSelectCancellationReason() {
    tripManagementPage.selectCancellationReason();
  }

  @Then("Operator verifies the Cancellation Reason are correct")
  public void OperatorVerifiesCancellationReason() {
    tripManagementPage.verifyCancellationMessage();
  }

  @Then("Operator verifies the Cancel Trip button in Trip Management page is {string}")
  public void OperatorVerifiesCancelTripButtonStatus(String status) {
    tripManagementPage.CancelTripButtonStatus(status);
  }

  @When("Operator clicks Cancel Trip button on Department page")
  public void OperatorClicksCancelTripButton() {
    tripManagementPage.CancelTrip();
  }

  @When("Operator clicks Cancel Trip button on Cancel page")
  public void OperatorClicksCancelOnCancelPage() {
    tripManagementPage.clickCancelTripButton();
  }

  @When("Operator clicks on Create One Time Trip Button")
  public void operatorClicksCreateOneTimeTripButton() {
    tripManagementPage.clickCreateOneTimeTripButton();
  }

  @And("Operator verifies Create One Time Trip page is loaded")
  public void operatorVerifiesItemsOnCreateOneTimeTripPage() {
    tripManagementPage.verifyCreateOneTimeTripPage();
  }

  @When("Operator create One Time Trip on Movement Trips page using data below:")
  public void OperatorCreateOneTimeTrip(Map<String, String> mapOfData) {
    Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
    List<Driver> middleMileDriver = get(KEY_LIST_OF_CREATED_DRIVERS);
    if (resolvedMapOfData.get("departureTime").equalsIgnoreCase("GENERATED")) {
      LocalTime time = LocalTime.now().plusHours(1L);
      String departTime = time.format(DateTimeFormatter.ofPattern("HH:mm"));
      resolvedMapOfData.put("departureTime", departTime);
    }
    if (resolvedMapOfData.get("departureDate").equalsIgnoreCase("GENERATED")) {
      String departureDay = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
      resolvedMapOfData.put("departureDate", departureDay);
    }
    if (resolvedMapOfData.get("duration").equalsIgnoreCase("GENERATED")) {
      resolvedMapOfData.putIfAbsent("durationDays", "0");
      resolvedMapOfData.putIfAbsent("durationHours", "0");
      resolvedMapOfData.putIfAbsent("durationMinutes", "15");
    }
//    tripManagementPage.createOneTimeTrip(resolvedMapOfData, middleMileDriver);
  }

  @When("Operator create One Time Trip with drivers on Movement Trips page using data below:")
  public void OperatorCreateOneTimeTripWithDrivers(Map<String, String> mapOfData) {
    List<MiddleMileDriver> middleMileDriver = resolveListOfKeys(mapOfData.get("drivers"), MiddleMileDriver.class);
    Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
    if (resolvedMapOfData.get("departureTime").equalsIgnoreCase("GENERATED")) {
      LocalTime time = LocalTime.now().plusHours(1L);
      String departTime = time.format(DateTimeFormatter.ofPattern("HH:mm"));
      resolvedMapOfData.put("departureTime", departTime);
    }
    if (resolvedMapOfData.get("departureDate").equalsIgnoreCase("GENERATED")) {
      String departureDay = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
      resolvedMapOfData.put("departureDate", departureDay);
    }
    if (resolvedMapOfData.get("duration").equalsIgnoreCase("GENERATED")) {
      resolvedMapOfData.putIfAbsent("durationDays", "0");
      resolvedMapOfData.putIfAbsent("durationHours", "0");
      resolvedMapOfData.putIfAbsent("durationMinutes", "15");
    }
    tripManagementPage.createOneTimeTrip(resolvedMapOfData, middleMileDriver);
  }

  @When("Operator create One Time Trip without driver on Movement Trips page using data below:")
  public void OperatorCreateOneTimeTripWithoutDriver(Map<String, String> mapOfData) {
    Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
    if (resolvedMapOfData.get("departureTime").equalsIgnoreCase("GENERATED")) {
      LocalTime time = LocalTime.now().plusHours(1L);
      String departTime = time.format(DateTimeFormatter.ofPattern("HH:mm"));
      resolvedMapOfData.put("departureTime", departTime);
    }
    if (resolvedMapOfData.get("departureDate").equalsIgnoreCase("GENERATED")) {
      Date date = new Date();
      long hour = 1000 * 60 * 60 * 24;
      date.setTime(date.getTime() + hour);
      String departureDay = new SimpleDateFormat("yyyy-MM-dd").format(date);
      resolvedMapOfData.put("departureDate", departureDay);
    }
    if (resolvedMapOfData.get("duration").equalsIgnoreCase("GENERATED")) {
      resolvedMapOfData.putIfAbsent("durationDays", "0");
      resolvedMapOfData.putIfAbsent("durationHours", "0");
      resolvedMapOfData.putIfAbsent("durationMinutes", "15");
    }
    tripManagementPage.createOneTimeTripWithoutDriver(resolvedMapOfData);
  }

  @And("Operator clicks Submit button on Create One Trip page")
  public void operatorClicksSubmitButton() {
    tripManagementPage.clickSubmitButtonOnCreateOneTripPage();
  }

  @Then("Operator verifies toast message display on create one time trip page")
  public void operatorVerifiesToastMessageOnCreateOneTimeTrip() {
    tripManagementPage.readAndVerifyTheToastMessageOfOneTimeTrip();
    //Get the trip ID, using for cancelling trip after test
    String currentTripId = TripManagementPage.actualToastMessageContent.replaceAll("[^\\d]", "");
    MovementTrip trip = new MovementTrip();
    trip.setId(Long.parseLong(currentTripId));
    trip.setStatus("Pending");
    putInList(KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS, currentTripId);
    putInList(KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS, trip);
  }

  @When("Operator create One Time Trip on Movement Trips page using same hub:")
  public void OperatorCreateOTTUsingSamHub(Map<String, String> mapOfData) {
    Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
    tripManagementPage.createOneTimeTripUsingSameHub(resolvedMapOfData);
  }

  @Then("Operator verifies same hub error messages on Create One Time Trip page")
  public void OperatorVerifiesErrorMessage() {
    tripManagementPage.getAndVerifySameHubErrorMessage();
  }

  @Then("Operator verifies Submit button is disable on Create One Trip page")
  public void operatorVerifySubmitButton() {
    tripManagementPage.verifySubmitButtonIsDisable();
  }

  @Then("Operator verifies {string} with value {string} is not shown on Create One Trip page")
  public void operatorVerifiesInvalidDriver(String name, String value) {
    tripManagementPage.verifyInvalidItem(name, value);
  }

  @And("Operator sets movement trips filter with data below:")
  public void operatorSetsMovementTripsFilterWithDataBelow(Map<String, String> dataTableAsMap) {
    final Map<String, String> inputMap = resolveKeyValues(dataTableAsMap);

    doWithRetry(() -> {
      tripManagementPage.refreshPage_v1();
      tripManagementPage.switchTo();

      operatorClicksOnTab(inputMap.get("tab"));
      for (String key : inputMap.keySet().stream().filter(k -> filterList.contains(k)).collect(
          Collectors.toList())) {
        tripManagementPage.selectValueFromFilterDropDownDirectly(key, inputMap.get(key));
      }
    }, "Retrying until field value is shown...", 1000, 10);
  }

  @Then("Operator verifies one of toast with message is shown on movement page without closing")
  public void operatorVerifiesOneOfToastWithMessageIsShow(List<String> toastMessages) {
    List<String> resolvedToastMessages = resolveValues(toastMessages);
    tripManagementPage.waitUntilVisibilityOfElementLocated(
        "//div[contains(@class,'notification-notice-message')]");
    WebElement toast = tripManagementPage.findElementByXpath(
        "//div[contains(@class,'notification-notice-message')]");
    String actualToastMessage = toast.getText();
    Boolean result =
        (actualToastMessage.contains(resolvedToastMessages.get(0))) || (actualToastMessage.contains(
            resolvedToastMessages.get(1)));
    Assertions.assertThat(result).as("Trip Management toast message is the same").isTrue();
  }

  @When("Operator clicks Force Completion button on Movement Trips page")
  public void operatorClicksForceCompletionButtonOnMovementTripsPage() {
    tripManagementPage.forceTripCompletion.waitUntilVisible();
    tripManagementPage.forceTripCompletion.click();
    tripManagementPage.forceTripCompletion.waitUntilInvisible();
  }

  @When("Operator departs trip and force complete when showing warning for driver in another trip")
  public void operatorDepartsTripAndForceCompleteWhenShowingWarningForDriverInAnotherTrip() {
    doWithRetry(() -> {
      tripManagementPage.departTripWithDrivers();
      pause2s();
      if (tripManagementPage.forceTripCompletion.isDisplayed()) {
        tripManagementPage.forceTripCompletion.click();
        tripManagementPage.forceTripCompletion.waitUntilInvisible();
        tripManagementPage.verifyToastContainingMessageIsShown("has completed");
      }
    }, "Departing trip...", 5000, 5);
  }

  @And("Operator verifies trip message {string} display on Movement Trip details page")
  public void operatorVerifiesDepartTripMessageDisplayOnMovementTripDetailsPage(
      String tripMessage) {
    tripMessage = resolveValue(tripMessage);
    tripManagementPage.verifyTripMessageSuccessful(tripMessage);
  }
}
