package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.Reservation;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.model.ReservationInfo;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.md.MdCheckbox;
import co.nvqa.operator_v2.selenium.page.ShipperPickupsPage;
import co.nvqa.operator_v2.selenium.page.ShipperPickupsPage.BulkRouteAssignmentSidePanel.ReservationCard;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableList;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.text.ParseException;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.openqa.selenium.Keys;

import static co.nvqa.common.utils.StandardTestUtils.convertToZonedDateTime;
import static co.nvqa.operator_v2.selenium.page.ShipperPickupsPage.ReservationsTable.ACTION_BUTTON_DETAILS;
import static co.nvqa.operator_v2.selenium.page.ShipperPickupsPage.ReservationsTable.ACTION_BUTTON_ROUTE_EDIT;
import static co.nvqa.operator_v2.selenium.page.ShipperPickupsPage.ReservationsTable.COLUMN_PICKUP_ADDRESS;
import static co.nvqa.operator_v2.selenium.page.ShipperPickupsPage.ReservationsTable.COLUMN_RESERVATION_ID;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ShipperPickupsSteps extends AbstractSteps {

  private ShipperPickupsPage shipperPickupsPage;

  public ShipperPickupsSteps() {
  }

  @Override
  public void init() {
    shipperPickupsPage = new ShipperPickupsPage(getWebDriver());
  }

  @When("^Operator set filter Reservation Date to current date and click Load Selection on Shipper Pickups page$")
  public void operatorSetFilterReservationDateToCurrentDateAndClickLoadSelectionOnShipperPickupsPage() {
    ZonedDateTime currentDate = ZonedDateTime.now();
    ZonedDateTime nextDayDate = ZonedDateTime.from(TestUtils.getNextDate(1));
    shipperPickupsPage.filtersForm.filterReservationDate(currentDate, nextDayDate);
    shipperPickupsPage.filtersForm.loadSelection.clickAndWaitUntilDone();
  }

  @When("^Operator enter reservation ids on Shipper Pickups page:$")
  public void enterReservationIds(List<String> ids) {
    ids = resolveValues(ids);
    ids.forEach(id ->
        shipperPickupsPage.reservationIds.sendKeys(id + Keys.ENTER)
    );
  }

  @When("^Operator search reservations on Shipper Pickups page:$")
  public void searchReservationIds(List<String> ids) {
    enterReservationIds(ids);
    shipperPickupsPage.searchByReservationIds.clickAndWaitUntilDone(60);
  }

  @When("Operator enters {int} reservation ids on Shipper Pickups page")
  public void enterReservationIds(int idsCount) {
    List<String> ids = new ArrayList<>();
    for (int i = 0; i < idsCount; i++) {
      ids.add(RandomStringUtils.randomNumeric(7));
    }
    enterReservationIds(ids);
  }

  @When("Operator verifies that there is {value} shown under the search field on Shipper Pickups page")
  public void verifiesTotalReservationsId(String text) {
    Assertions.assertThat(shipperPickupsPage.reservationIdsCount.getNormalizedText())
        .as("Reservation IDs field counter text")
        .isEqualTo(text);
  }

  @When("^Operator clicks Search by Reservation IDs on Shipper Pickups page$")
  public void clickSearchByReservationIds() {
    shipperPickupsPage.searchByReservationIds.click();
  }

  @When("^Operator set filter parameters and click Load Selection on Shipper Pickups page:$")
  public void operatorSetFilterParametersAndClickLoadSelectionOnShipperPickupsPage(
      Map<String, String> mapOfData) throws ParseException {
    mapOfData = resolveKeyValues(mapOfData);

    shipperPickupsPage.waitUntilPageLoaded();
    String value = mapOfData.get("fromDate");

    ZonedDateTime fromDate =
        StringUtils.isNotBlank(value) ? convertToZonedDateTime(value, DTF_NORMAL_DATE)
            : ZonedDateTime.now();
    value = mapOfData.get("toDate");
    ZonedDateTime toDate =
        StringUtils.isNotBlank(value) ? convertToZonedDateTime(value, DTF_NORMAL_DATE)
            : ZonedDateTime.from(TestUtils.getNextDate(1));
    shipperPickupsPage.filtersForm.filterReservationDate(fromDate, toDate);

    value = mapOfData.get("hub");
    shipperPickupsPage.filtersForm.hubsFilter.clearAll();
    if (StringUtils.isNotBlank(value)) {
      shipperPickupsPage.filtersForm.hubsFilter.selectFilter(value);
    }

    value = mapOfData.get("zone");
    shipperPickupsPage.filtersForm.zonesFilter.clearAll();
    if (StringUtils.isNotBlank(value)) {
      shipperPickupsPage.filtersForm.zonesFilter.selectFilter(value);
    }

    value = mapOfData.get("type");
    shipperPickupsPage.filtersForm.reservationTypesFilter.clearAll();
    if (StringUtils.isNotBlank(value)) {
      shipperPickupsPage.filtersForm.reservationTypesFilter.selectFilter(value);
    }

    value = mapOfData.get("status");
    shipperPickupsPage.filtersForm.statusFilter.clearAll();
    if (StringUtils.isNotBlank(value)) {
      shipperPickupsPage.filtersForm.statusFilter.selectFilter(value);
    }

    value = mapOfData.get("shipperName");
    shipperPickupsPage.filtersForm.shipperFilter.clearAll();
    if (StringUtils.isNotBlank(value)) {
      shipperPickupsPage.filtersForm.shipperFilter.selectFilter(value);
    }

    value = mapOfData.get("masterShipperName");
    shipperPickupsPage.filtersForm.masterShipperFilter.clearAll();
    if (StringUtils.isNotBlank(value)) {
      shipperPickupsPage.filtersForm.masterShipperFilter.selectFilter(value);
    }

    shipperPickupsPage.filtersForm.loadSelection.clickAndWaitUntilDone(120);
  }

  @When("^Operator refresh routes on Shipper Pickups page$")
  public void operatorRefreshRoutesOnShipperPickupPage() {
    shipperPickupsPage.refresh.click();
    shipperPickupsPage.waitUntilPageLoaded();
  }

  @When("^Operator assign Reservation to Route on Shipper Pickups page$")
  public void operatorAssignReservationToRouteOnShipperPickupsPage() {
    Address addressResult = get(KEY_CREATED_ADDRESS);
    Long routeId = get(KEY_CREATED_ROUTE_ID);
    shipperPickupsPage.assignReservationToRoute(addressResult, routeId);
  }

  @When("^Operator removes reservation from route from Edit Route Details dialog$")
  public void operatorRemovesReservationFromEditRouteDetailsDialog() {
    Address addressResult = get(KEY_CREATED_ADDRESS);
    shipperPickupsPage.reservationsTable.searchByPickupAddress(addressResult);
    shipperPickupsPage.reservationsTable.clickActionButton(1, ACTION_BUTTON_ROUTE_EDIT);
    shipperPickupsPage.editRouteDialog.newRoute.clear();
    shipperPickupsPage.editRouteDialog.submitForm();
  }

  @When("^Operator assign Reservation to Route with priority level = \"([^\"]*)\" on Shipper Pickups page$")
  public void operatorAssignReservationToRouteWithPriorityOnShipperPickupsPage(
      String priorityLevelAsString) {
    Address addressResult = get(KEY_CREATED_ADDRESS);
    Long routeId = get(KEY_CREATED_ROUTE_ID);
    Integer priorityLevel = Integer.parseInt(priorityLevelAsString);
    shipperPickupsPage.assignReservationToRoute(addressResult, routeId, priorityLevel);
  }

  @Then("^Operator verify the new reservation is listed on table in Shipper Pickups page using data below:$")
  public void operatorVerifyTheNewReservationIsListedOnTableInShipperPickupsPageUsingDataBelow(
      Map<String, String> mapOfData) {
    String addressKey = mapOfData.getOrDefault("address", "KEY_CREATED_ADDRESS");
    Address addressResult = resolveValue(addressKey);
    retryIfAssertionErrorOccurred(() ->
            verifyReservationData(addressResult, resolveKeyValues(mapOfData)),
        " Verify reservation parameters", 500, 3);
  }

  @Then("^Operator verify reservations details on Shipper Pickups page:$")
  public void verifyReservationDetails(List<Map<String, String>> data) {
    verifyReservationDetails(data, false);
  }

  @Then("^Operator verify reservation details on Shipper Pickups page:$")
  public void verifyReservationDetails(Map<String, String> data) {
    verifyReservationDetails(ImmutableList.of(data), false);
  }

  @Then("^Operator verify exactly reservations details on Shipper Pickups page:$")
  public void verifyExactlyReservationDetails(List<Map<String, String>> data) {
    verifyReservationDetails(data, true);
  }

  public void verifyReservationDetails(List<Map<String, String>> data, boolean checkCount) {
    data = resolveListOfMaps(data);
    shipperPickupsPage.reservationsTable.clearColumnFilter(COLUMN_RESERVATION_ID);
    shipperPickupsPage.reservationsTable.clearColumnFilter(COLUMN_PICKUP_ADDRESS);
    int count = shipperPickupsPage.reservationsTable.getRowsCount();
    if (checkCount) {
      Assertions.assertThat(count)
          .as("Number of reservation")
          .isEqualTo(data.size());
    }
    data.forEach(row -> {
      ReservationInfo expected = new ReservationInfo(row);
      if (StringUtils.isNotBlank(expected.getId())) {
        shipperPickupsPage.reservationsTable.filterByColumn(COLUMN_RESERVATION_ID,
            expected.getId());
        if (shipperPickupsPage.reservationsTable.isEmpty()) {
          Assertions.fail("Reservation ID " + expected.getId() + " was not found");
        }
      } else if (StringUtils.isNotBlank(expected.getPickupAddress())) {
        shipperPickupsPage.reservationsTable.filterByColumn(COLUMN_PICKUP_ADDRESS,
            expected.getPickupAddress());
        if (shipperPickupsPage.reservationsTable.isEmpty()) {
          Assertions.fail(
              "Reservation with Pickup Address " + expected.getPickupAddress() + " was not found");
        }
      }
      ReservationInfo actual = shipperPickupsPage.reservationsTable.readEntity(1);
      expected.compareWithActual(actual);
    });
  }

  @Then("^Operator verify the new reservations are listed on table in Shipper Pickups page using data below:$")
  public void operatorVerifyTheNewReservationsAreListedOnTableInShipperPickupsPageUsingDataBelow(
      Map<String, String> mapOfData) {
    List<Address> addresses = get(KEY_LIST_OF_CREATED_ADDRESSES);
    addresses.forEach(address -> verifyReservationData(address, resolveKeyValues(mapOfData)));
  }

  private void verifyReservationData(Address address, Map<String, String> mapOfData) {
    String shipperName = mapOfData.get("shipperName");
    String routeId = mapOfData.get("routeId");
    String driverName = mapOfData.get("driverName");
    String priorityLevel = mapOfData.get("priorityLevel");
    String approxVolume = mapOfData.get("approxVolume");
    String comments = mapOfData.get("comments");
    String readyBy = mapOfData.get("readyBy");
    String latestBy = mapOfData.get("latestBy");

    if ("GET_FROM_CREATED_SHIPPER".equalsIgnoreCase(shipperName)) {
      shipperName = this.<Shipper>get(KEY_CREATED_SHIPPER).getName();
    }

    routeId = resolveExpectedRouteId(routeId);
    driverName = resolveExpectedDriverName(driverName);

    if ("GET_FROM_CREATED_RESERVATION".equals(comments)) {
      Reservation reservationResult = get(KEY_CREATED_RESERVATION);
      comments = reservationResult.getComments();
    }

    shipperPickupsPage
        .verifyReservationInfo(address, shipperName, routeId, driverName, priorityLevel,
            approxVolume, comments, readyBy, latestBy);
  }

  private String resolveExpectedRouteId(String routeIdParam) {
    if (StringUtils.isBlank(routeIdParam)) {
      return null;
    }

    switch (routeIdParam.toUpperCase()) {
      case "GET_FROM_CREATED_ROUTE":
        return String.valueOf((Long) get(KEY_CREATED_ROUTE_ID));
      case "GET_FROM_SUGGESTED_ROUTE":
        return String.valueOf(((Route) get(KEY_SUGGESTED_ROUTE)).getId());
      default:
        return routeIdParam;
    }
  }

  private String resolveExpectedDriverName(String driverNameParam) {
    if (StringUtils.isBlank(driverNameParam)) {
      return null;
    }

    Route route;

    switch (driverNameParam.toUpperCase()) {
      case "GET_FROM_CREATED_ROUTE":
        route = get(KEY_CREATED_ROUTE);
        return route.getDriver().getFirstName() + " " + route.getDriver().getLastName();
      case "GET_FROM_SUGGESTED_ROUTE":
        route = get(KEY_SUGGESTED_ROUTE);
        return route.getDriverName();
      default:
        return driverNameParam;
    }
  }

  @Then("^Operator verify the reservations details is correct on Shipper Pickups page using data below:$")
  public void operatorVerifyTheReservationsDetailsIsCorrectOnShipperPickupsPageUsingDataBelow(
      Map<String, String> mapOfData) {
    Address addressResult = get(KEY_CREATED_ADDRESS);

    String shipperName = mapOfData.get("shipperName");
    String shipperId = mapOfData.get("shipperId");
    String reservationId = mapOfData.get("reservationId");

    if ("GET_FROM_CREATED_RESERVATION".equals(reservationId)) {
      Reservation reservationResult = get(KEY_CREATED_RESERVATION);
      reservationId = String.valueOf(reservationResult.getId());
    }

    shipperPickupsPage
        .verifyReservationDetails(addressResult, shipperName, shipperId, reservationId);
  }

  @When("^Operator duplicates created reservation$")
  public void operatorDuplicatesCreatedReservation() {
    Address address = get(KEY_CREATED_ADDRESS);
    Reservation reservation = get(KEY_CREATED_RESERVATION);
    ReservationInfo duplicatedReservationInfo = duplicateReservations(
        Collections.singletonList(address), reservation).get(0);
    put(KEY_DUPLICATED_RESERVATION_INFO, duplicatedReservationInfo);
  }

  @When("^Operator duplicates created reservations$")
  public void operatorDuplicatesCreatedReservations() {
    List<Address> addresses = get(KEY_LIST_OF_CREATED_ADDRESSES);
    List<Reservation> reservations = get(KEY_LIST_OF_CREATED_RESERVATIONS);
    List<ReservationInfo> duplicatedReservationsInfo = duplicateReservations(addresses,
        reservations.get(0));
    put(KEY_LIST_OF_DUPLICATED_RESERVATIONS_INFO, duplicatedReservationsInfo);
  }

  private List<ReservationInfo> duplicateReservations(List<Address> addresses,
      Reservation reservation) {
    int daysShift = 1;
    DateTimeFormatter reservationDateTimeFormatter = DTF_NORMAL_DATETIME.withZone(ZoneId.of("UTC"));
    ZonedDateTime readyDatetime = DateUtil
        .getDate(reservation.getReadyDatetime(), reservationDateTimeFormatter);
    ZonedDateTime latestDatetime = DateUtil
        .getDate(reservation.getLatestDatetime(), reservationDateTimeFormatter);

    ZonedDateTime newReadyDatetime = readyDatetime.plusDays(daysShift);
    ZonedDateTime newLatestDatetime = latestDatetime.plusDays(daysShift);

    String newReadyDatetimeAsString = DateUtil
        .displayDateTime(newReadyDatetime.withZoneSameInstant(ZoneId.systemDefault()));
    String newLatestDatetimeAsString = DateUtil
        .displayDateTime(newLatestDatetime.withZoneSameInstant(ZoneId.systemDefault()));

    List<ReservationInfo> duplicatedReservationsInfo = shipperPickupsPage
        .duplicateReservations(addresses, newReadyDatetime);

    duplicatedReservationsInfo.forEach(reservationInfo ->
    {
      reservationInfo.setReadyBy(newReadyDatetimeAsString);
      reservationInfo.setLatestBy(newLatestDatetimeAsString);
    });

    return duplicatedReservationsInfo;
  }

  @Then("^Operator verify the duplicated reservation is created successfully$")
  public void operatorVerifyTheDuplicatedReservationIsCreatedSuccessfully() {
    ReservationInfo expected = get(KEY_DUPLICATED_RESERVATION_INFO);
    expected = new ReservationInfo(expected);
    expected.setId(null);
    shipperPickupsPage.verifyReservationInfo(expected, get(KEY_CREATED_ADDRESS));
  }

  @Then("^Operator verify the duplicated reservations are created successfully$")
  public void operatorVerifyTheDuplicatedReservationsAreCreatedSuccessfully() {
    List<ReservationInfo> expected = get(KEY_LIST_OF_DUPLICATED_RESERVATIONS_INFO);
    expected = expected.stream().map(val ->
    {
      val = new ReservationInfo(val);
      val.setId(null);
      return val;
    }).collect(Collectors.toList());
    shipperPickupsPage.verifyReservationsInfo(expected, get(KEY_LIST_OF_CREATED_ADDRESSES));
  }

  @And("^Operator use the Route Suggestion to add created reservation to the route using data below:$")
  public void operatorUseTheRouteSuggestionToAddCreatedReservationToTheRoute(
      Map<String, String> dataTableAsMap) {
    dataTableAsMap = resolveKeyValues(dataTableAsMap);
    Address address = get(KEY_CREATED_ADDRESS);
    String routeTagName = dataTableAsMap.get("routeTagName");
    addRouteViaRouteSuggestion(Collections.singletonList(address),
        Collections.singletonList(routeTagName));
  }

  @And("^Operator select Route Tags for Route Suggestion of created reservation using data below:$")
  public void operatorSelectRouteTagsForRouteSuggestionsOfTheRouteUsingDataBelow(
      Map<String, String> dataTableAsMap) {
    dataTableAsMap = resolveKeyValues(dataTableAsMap);
    Address address = get(KEY_CREATED_ADDRESS);
    String routeTagName = dataTableAsMap.get("routeTagName");
    shipperPickupsPage
        .suggestRoute(Collections.singletonList(address), Collections.singletonList(routeTagName));
  }

  @And("^Operator select Route Tags for Route Suggestion of created reservations using data below:$")
  public void operatorSelectRouteTagsForRouteSuggestionsOfCreatedReservationsUsingDataBelow(
      Map<String, String> dataTableAsMap) {
    dataTableAsMap = resolveKeyValues(dataTableAsMap);
    List<Address> addresses = get(KEY_LIST_OF_CREATED_ADDRESSES);
    String routeTagName = dataTableAsMap.get("routeTagName");
    shipperPickupsPage.suggestRoute(addresses, Collections.singletonList(routeTagName));
  }

  @And("^Operator select \"(.+)\" action for created reservations on Shipper Pickup page$")
  public void operatorSelectActionForCreatedReservations(String action) {
    action = resolveValue(action);
    operatorSelectCreatedReservations();
    shipperPickupsPage.actionsMenu.selectOption(action);
  }

  @And("^Operator select created reservations on Shipper Pickup page$")
  public void operatorSelectCreatedReservations() {
    List<Address> addresses = get(KEY_LIST_OF_CREATED_ADDRESSES);
    addresses.forEach(address ->
    {
      pause500ms();
      shipperPickupsPage.reservationsTable.searchByPickupAddress(address);
      shipperPickupsPage.reservationsTable.selectRow(1);
    });
  }

  @And("^Operator verifies no route suggested for selected reservations$")
  public void operatorVerifiesNoRouteSuggestedForSelectedReservations() {
    shipperPickupsPage.bulkRouteAssignmentDialog.suggestedRoutes.forEach(routeSelector ->
        Assertions.assertThat(routeSelector.getValue()).as("Suggested route value").isEmpty()
    );
  }

  @And("^Operator use the Route Suggestion to add created reservations to the route using data below:$")
  public void operatorUseTheRouteSuggestionToAddCreatedReservationsToTheRoute(
      Map<String, String> dataTableAsMap) {
    dataTableAsMap = resolveKeyValues(dataTableAsMap);
    List<Address> addresses = get(KEY_LIST_OF_CREATED_ADDRESSES);
    String routeTagName = dataTableAsMap.get("routeTagName");
    addRouteViaRouteSuggestion(addresses, Collections.singletonList(routeTagName));
  }

  private void addRouteViaRouteSuggestion(List<Address> addresses, List<String> routeTags) {
    List<Route> zzzRoutes = get(KEY_LIST_OF_CREATED_ROUTES);
    Route suggestedRoute = shipperPickupsPage
        .suggestRoute(addresses, routeTags)
        .validateSuggestedRoutes(zzzRoutes);
    put(KEY_SUGGESTED_ROUTE, suggestedRoute);
    shipperPickupsPage.bulkRouteAssignmentDialog().submitForm();
  }

  @And("^Operator removes the route from the created reservation$")
  public void operatorRemovesTheRouteFromTheCreatedReservation() {
    Address address = get(KEY_CREATED_ADDRESS);
    shipperPickupsPage.removeRoute(address);
  }

  @And("^Operator removes the route from the created reservations$")
  public void operatorRemovesTheRouteFromTheCreatedReservations() {
    List<Address> addresses = get(KEY_LIST_OF_CREATED_ADDRESSES);
    shipperPickupsPage.removeRoutes(addresses);
  }

  @Then("^Operator verify the route was removed from the created reservation$")
  public void operatorVerifyTheRouteWasRemovedFromTheCreatedReservation() {
    Address address = get(KEY_CREATED_ADDRESS);
    shipperPickupsPage.reservationsTable.searchByPickupAddress(address);
    ReservationInfo actual = shipperPickupsPage.reservationsTable.readEntity(1);
    Assertions.assertThat(actual.getRouteId()).as("Route Id").isNull();
    Assertions.assertThat(actual.getDriverName()).as("Driver Name").isNull();
  }

  @Then("^Operator verify the route was removed from the created reservations$")
  public void operatorVerifyTheRouteWasRemovedFromTheCreatedReservations() {
    List<Address> addresses = get(KEY_LIST_OF_CREATED_ADDRESSES);
    addresses.forEach(address ->
    {
      shipperPickupsPage.reservationsTable.searchByPickupAddress(address);
      ReservationInfo actual = shipperPickupsPage.reservationsTable.readEntity(1);
      Assertions.assertThat(actual.getRouteId()).as("Route Id").isNull();
      Assertions.assertThat(actual.getDriverName()).as("Driver Name").isNull();
    });
  }

  @Then("^Operator verify the reservation data is correct on Shipper Pickups page$")
  public void operatorVerifyTheReservationDataIsCorrectOnShipperPickupsPage() {
    ReservationInfo reservationInfo = get(KEY_CREATED_RESERVATION_INFO);
    Address address = get(KEY_CREATED_ADDRESS);
    shipperPickupsPage.verifyReservationInfo(reservationInfo, address);
  }

  @And("^Operator download CSV file for created reservation$")
  public void operatorDownloadCSVFileForCreatedReservation() {
    Address address = get(KEY_CREATED_ADDRESS);
    ReservationInfo reservationInfo = shipperPickupsPage.downloadCsvFile(address);
    put(KEY_CREATED_RESERVATION_INFO, reservationInfo);
  }

  @Then("^Operator verify the reservation info is correct in downloaded CSV file$")
  public void operatorVerifyTheReservationInfoIsCorrectInDownloadedCSVFile() {
    ReservationInfo reservationInfo = get(KEY_CREATED_RESERVATION_INFO);
    shipperPickupsPage.verifyCsvFileDownloadedSuccessfully(reservationInfo);
  }

  @And("^Operator set the Priority Level of the created reservation to \"(\\d+)\" from Apply Action$")
  public void operatorSetThePriorityLevelOfTheCreatedReservationFromApplyActionTo(
      int priorityLevel) {
    Address address = get(KEY_CREATED_ADDRESS);
    shipperPickupsPage.editPriorityLevel(address, priorityLevel);
  }

  @And("^Operator set the Priority Level of the created reservations to \"(\\d+)\" from Apply Action$")
  public void operatorSetThePriorityLevelOfTheCreatedReservationsToFromApplyAction(
      int priorityLevel) {
    List<Address> addresses = get(KEY_LIST_OF_CREATED_ADDRESSES);
    shipperPickupsPage.editPriorityLevel(addresses, priorityLevel, false);
  }

  @And("^Operator set the Priority Level of the created reservations to \"(\\d+)\" from Apply Action using \"Set To All\" option$")
  public void operatorSetThePriorityLevelOfTheCreatedReservationsToFromApplyActionUsingSetToAllOption(
      int priorityLevel) {
    List<Address> addresses = get(KEY_LIST_OF_CREATED_ADDRESSES);
    shipperPickupsPage.editPriorityLevel(addresses, priorityLevel, true);
  }

  @And("^Operator finish reservation with failure$")
  public void operatorFinishReservationWithFailure() {
    shipperPickupsPage.finishReservationWithFailure();
  }

  @And("Operator fails reservation with failure Reason for the ReservationID {string}")
  public void operatorFailsReservationWithFailureReason(String reservationID,
      Map<String, String> dataTableAsMap) {
    reservationID = resolveValue(reservationID);
    shipperPickupsPage.finishReservationWithFailureReason(dataTableAsMap, reservationID);
    takesScreenshot();
  }

  @And("^Operator finish reservation with success")
  public void operatorFinishReservationWithSuccess() {
    shipperPickupsPage.finishReservationWithSuccess();
  }

  @Then("^Operator verifies reservation is finished using data below:$")
  public void operatorVerifiesReservationIsFailed(Map<String, String> dataTableAsMap) {
    String color = dataTableAsMap.get("backgroundColor");
    String status = dataTableAsMap.get("status");
    shipperPickupsPage.verifyFinishedReservationHighlighted(color);
    shipperPickupsPage.verifyFinishedReservationHasStatus(status);
  }

  @Then("^Operator opens details of reservation \"(.+)\" on Shipper Pickups page$")
  public void operatorOpensDetailsOfReservation(String reservationId) {
    reservationId = resolveValue(reservationId);
    shipperPickupsPage.reservationsTable.filterByColumn(COLUMN_RESERVATION_ID, reservationId);
    shipperPickupsPage.reservationsTable.clickActionButton(1, ACTION_BUTTON_DETAILS);
  }

  @Then("^Operator verifies POD not found in Reservation Details dialog on Shipper Pickups page$")
  public void operatorVerifiesPodNotFound() {
    shipperPickupsPage.reservationDetailsDialog.waitUntilVisible();
    Assertions.assertThat(shipperPickupsPage.reservationDetailsDialog.podNotFound.isDisplayed())
        .as("POD not found").isTrue();
  }

  @Then("^Operator verifies POD details in Reservation Details dialog on Shipper Pickups page using data below:$")
  public void operatorVerifiesPodDetails(Map<String, String> data) {
    data = resolveKeyValues(data);
    shipperPickupsPage.reservationDetailsDialog.waitUntilVisible();
    String expectedValue = data.get("timestamp");
    if (StringUtils.isNotBlank(expectedValue)) {
      Assertions.assertThat(
              shipperPickupsPage.reservationDetailsDialog.timestamp.getNormalizedText()).as("Timestamp")
          .startsWith(expectedValue);
    }
    expectedValue = data.get("inputOnPod");
    if (StringUtils.isNotBlank(expectedValue)) {
      Assertions.assertThat(
              shipperPickupsPage.reservationDetailsDialog.inputOnPod.getNormalizedText())
          .as("Input on POD (Driver)").isEqualTo(expectedValue);
    }
    expectedValue = data.get("scannedAtShipperCount");
    if (StringUtils.isNotBlank(expectedValue)) {
      Assertions.assertThat(
              shipperPickupsPage.reservationDetailsDialog.scannedAtShipperCount.getNormalizedText())
          .as("Scanned at Shipper count").isEqualTo(expectedValue);
    }
    expectedValue = data.get("scannedAtShipperPOD");
    if (StringUtils.isNotBlank(expectedValue)) {
      List<String> expected = splitAndNormalize(expectedValue);
      List<String> actual = shipperPickupsPage.reservationDetailsDialog.scannedAtShipperPOD.stream()
          .map(PageElement::getNormalizedText).collect(Collectors.toList());
      Assertions.assertThat(actual).as("Scanned at Shipper (POD)")
          .contains(expected.toArray(new String[0]));
    }
  }

  @Then("^Operator verifies filter parameters on Shipper Pickups page using data below:$")
  public void operatorVerifiesFilterParametersDetails(Map<String, String> data) {
    data = resolveKeyValues(data);
    String expectedValue = data.get("shippers");
    if (StringUtils.isNotBlank(expectedValue)) {
      String[] array = Arrays.stream(expectedValue.split(",")).map(StringUtils::trim)
          .toArray(String[]::new);
      Assertions.assertThat(shipperPickupsPage.shipperFilter.getSelectedValues())
          .as("Shipper filter")
          .contains(array);
    }
  }

  @When("^Operator switch (on|off) Bulk Assign Route toggle on Shipper Pickups page$")
  public void operatorSwitchBulkAssignRoute(String mode) {
    shipperPickupsPage.bulkAssignRoute.setValue(StringUtils.equalsIgnoreCase(mode, "on"));
    pause1s();
  }

  @Then("^Operator verify that Bulk Route Assignment Side Panel is shown on Shipper Pickups page$")
  public void operatorVerifyBulkRouteAssignmentSidePanelIsShown() {
    Assertions.assertThat(shipperPickupsPage.bulkAssignRoute.waitUntilVisible(5))
        .as("Bulk Route Assignment Side Panel is shown").isTrue();
  }

  @Then("Operator verify that title of Bulk Route Assignment Side Panel is {value}")
  public void operatorVerifyBulkRouteAssignmentSidePanelTitle(String expected) {
    pause500ms();
    Assertions.assertThat(shipperPickupsPage.bulkRouteAssignmentSidePanel.description.getText())
        .as("Bulk Route Assignment Side Panel title")
        .isEqualTo(expected);
  }

  @Then("^Operator verify reservations data in Bulk Route Assignment Side Panel using data below:$")
  public void operatorVerifyReservationDataInBulkRouteAssignmentSidePanelTitle(
      List<Map<String, String>> data) {
    Assertions.assertThat(shipperPickupsPage.bulkRouteAssignmentSidePanel.reservationCards.size())
        .as("Count of Reservation Cards in Bulk Route Assignment Side Panel")
        .isEqualTo(data.size());
    for (int i = 0; i < data.size(); i++) {
      ReservationCard reservationCard = shipperPickupsPage.bulkRouteAssignmentSidePanel.reservationCards
          .get(i);
      Map<String, String> expected = resolveKeyValues(data.get(i));
      if (expected.containsKey("title")) {
        Assertions.assertThat(reservationCard.title.getText())
            .as("Reservation card title %d", i + 1).startsWith(expected.get("title"));
      }
      if (expected.containsKey("description")) {
        Assertions.assertThat(reservationCard.description.getText())
            .as("Reservation card description %d", i + 1).isEqualTo(expected.get("description"));
      }
      if (expected.containsKey("subtitle")) {
        Assertions.assertThat(reservationCard.subtitle.getText())
            .as("Reservation card subtitle %d", i + 1).isEqualTo(expected.get("subtitle"));
      }
    }
  }

  @When("Operator select {value} route in Bulk Route Assignment Side Panel")
  public void operatorSelectRouteInBulkRouteAssignmentSidePanel(String route) {
    shipperPickupsPage.bulkRouteAssignmentSidePanel.route.selectValue(route);
  }

  @When("^Operator click Bulk Assign button in Bulk Route Assignment Side Panel$")
  public void operatorClickBulkAssignButtonInBulkRouteAssignmentSidePanel() {
    shipperPickupsPage.bulkRouteAssignmentSidePanel.bulkAssign.clickAndWaitUntilDone();
  }

  @Then("^Operator delete (\\d+) reservation in Bulk Route Assignment Side Panel$")
  public void operatorDeleteReservationBulkRouteAssignmentSidePanelTitle(int index) {
    shipperPickupsPage.bulkRouteAssignmentSidePanel.reservationCards.get(index - 1).closeIcon
        .click();
  }

  @Then("^Operator verify that reservation checkbox is not selected on Shipper Pickups page$")
  public void operatorReservationCheckboxIsNotSelected() {
    MdCheckbox checkBox = shipperPickupsPage.reservationsTable.getCheckbox(1);
    Assertions.assertThat(checkBox.isEnabled()).as("Checkbox is enabled").isFalse();
    Assertions.assertThat(checkBox.isChecked()).as("Checkbox is checked").isFalse();
  }

  @Then("^Operator verify that \"(.+)\" icon is disabled for created reservation on Shipper Pickups page$")
  public void operatorVerifyThatFinishIconIsDisabled(String buttonName) {
    Address address = get(KEY_CREATED_ADDRESS);
    shipperPickupsPage.reservationsTable.searchByPickupAddress(address);
    Assertions.assertThat(
            shipperPickupsPage.reservationsTable.getActionButton(buttonName, 1).isEnabled())
        .as(f("%s button is disabled", buttonName)).isFalse();
  }

  @Then("^Operator verifies POD details in POD Details dialog on Shipper Pickups page using data below:$")
  public void operatorVerifiesPodDetailsDialog(Map<String, String> data) {
    data = resolveKeyValues(data);
    if (!shipperPickupsPage.podDetailsDialog.isDisplayedFast()) {
      Assertions.assertThat(shipperPickupsPage.reservationDetailsDialog.waitUntilVisible(5))
          .as("Reservation dialog is opened").isTrue();
      shipperPickupsPage.reservationDetailsDialog.viewPod.click();
      shipperPickupsPage.podDetailsDialog.waitUntilVisible();
    }
    String expectedValue = data.get("reservationId");
    if (StringUtils.isNotBlank(expectedValue)) {
      Assertions.assertThat(shipperPickupsPage.podDetailsDialog.reservationId.getNormalizedText())
          .as("Reservation ID").isEqualTo(expectedValue);
    }
    expectedValue = data.get("recipientName");
    if (StringUtils.isNotBlank(expectedValue)) {
      Assertions.assertThat(shipperPickupsPage.podDetailsDialog.recipientName.getNormalizedText())
          .as("Recipient Name").isEqualTo(expectedValue);
    }
    expectedValue = data.get("shipperId");
    if (StringUtils.isNotBlank(expectedValue)) {
      Assertions.assertThat(shipperPickupsPage.podDetailsDialog.shipperId.getNormalizedText())
          .as("Shipper ID").isEqualTo(expectedValue);
    }
    expectedValue = data.get("shipperName");
    if (StringUtils.isNotBlank(expectedValue)) {
      Assertions.assertThat(shipperPickupsPage.podDetailsDialog.shipperName.getNormalizedText())
          .as("Shipper Name").isEqualTo(expectedValue);
    }
    expectedValue = data.get("shipperContact");
    if (StringUtils.isNotBlank(expectedValue)) {
      Assertions.assertThat(shipperPickupsPage.podDetailsDialog.shipperContact.getNormalizedText())
          .as("Shipper Contact").isEqualTo(expectedValue);
    }
    expectedValue = data.get("status");
    if (StringUtils.isNotBlank(expectedValue)) {
      Assertions.assertThat(shipperPickupsPage.podDetailsDialog.status.getNormalizedText())
          .as("Status").isEqualTo(expectedValue);
    }
    shipperPickupsPage.podDetailsDialog.forceClose();
  }

  @Then("^Operator verifies downloaded POD CSV file on Shipper Pickups page using data below:$")
  public void operatorVerifiesPodCsvFile(List<String> trackingIds) {
    trackingIds = resolveValues(trackingIds);
    Assertions.assertThat(shipperPickupsPage.reservationDetailsDialog.waitUntilVisible(5))
        .as("Reservation dialog is opened").isTrue();
    String podId = shipperPickupsPage.reservationDetailsDialog.podName.getAttribute("name")
        .replace("POD-", "");
    shipperPickupsPage.reservationDetailsDialog.downloadCsvFile.click();
    for (String trackingId : trackingIds) {
      shipperPickupsPage
          .verifyFileDownloadedSuccessfully("pod-file-id-" + podId + ".csv", trackingId);
    }
  }

  @Then("^Operator verifies downloaded POD CSV file on Shipper Pickups page contains no details$")
  public void operatorVerifiesEmptyPodCsvFile() {
    Assertions.assertThat(shipperPickupsPage.reservationDetailsDialog.waitUntilVisible(5))
        .as("Reservation dialog is opened").isTrue();
    String podId = shipperPickupsPage.reservationDetailsDialog.podName.getAttribute("name")
        .replace("POD-", "");
    shipperPickupsPage.reservationDetailsDialog.downloadCsvFile.click();
    shipperPickupsPage
        .verifyFileDownloadedSuccessfully("pod-file-id-" + podId + ".csv",
            "Scanned at Shipper (POD),Removed TID by Driver\n" + ",", true, true, false);
  }

  @When("^Operator edit reservation address details on Edit Route Details dialog using data below:$")
  public void operatorEditReservationAddressFromEditRouteDetailsDialog(Map<String, String> data) {
    Address oldAddress = resolveValue(data.get("oldAddress"));
    Address newAddress = resolveValue(data.get("newAddress"));
    shipperPickupsPage.reservationsTable.searchByPickupAddress(oldAddress);
    shipperPickupsPage.reservationsTable.clickActionButton(1, ACTION_BUTTON_ROUTE_EDIT);
    var value = data.get("readyByHours");
    if (StringUtils.isNotBlank(value)) {
      shipperPickupsPage.editRouteDialog.readyByHours.setValue(value);
    }
    value = data.get("readyByMinutes");
    if (StringUtils.isNotBlank(value)) {
      shipperPickupsPage.editRouteDialog.readyByMinutes.setValue(value);
    }
    value = data.get("readyByAmPm");
    if (StringUtils.isNotBlank(value)) {
      if (!StringUtils.equalsIgnoreCase(
          shipperPickupsPage.editRouteDialog.readyByAmPm.getAttribute("aria-label"), value)) {
        shipperPickupsPage.editRouteDialog.readyByAmPm.click();
      }
    }
    value = data.get("lastByHours");
    if (StringUtils.isNotBlank(value)) {
      shipperPickupsPage.editRouteDialog.lastByHours.setValue(value);
    }
    value = data.get("lastByMinutes");
    if (StringUtils.isNotBlank(value)) {
      shipperPickupsPage.editRouteDialog.lastByMinutes.setValue(value);
    }
    value = data.get("lastByAmPm");
    if (StringUtils.isNotBlank(value)) {
      if (!StringUtils.equalsIgnoreCase(
          shipperPickupsPage.editRouteDialog.lastByAmPm.getAttribute("aria-label"), value)) {
        shipperPickupsPage.editRouteDialog.lastByAmPm.click();
      }
    }
    shipperPickupsPage.editRouteDialog.editAddress.click();
    if (StringUtils.isNotBlank(newAddress.getAddress1())) {
      shipperPickupsPage.editRouteDialog.address1.setValue(newAddress.getAddress1());
    }
    if (StringUtils.isNotBlank(newAddress.getAddress2())) {
      shipperPickupsPage.editRouteDialog.address2.setValue(newAddress.getAddress2());
    }
    if (StringUtils.isNotBlank(newAddress.getPostcode())) {
      shipperPickupsPage.editRouteDialog.postcode.setValue(newAddress.getPostcode());
    }
    if (newAddress.getLatitude() != null) {
      shipperPickupsPage.editRouteDialog.latitude.setValue(newAddress.getLatitude());
    }
    if (newAddress.getLongitude() != null) {
      shipperPickupsPage.editRouteDialog.longitude.setValue(newAddress.getLongitude());
    }
    shipperPickupsPage.editRouteDialog.updateAddress.clickAndWaitUntilDone();
  }

  @When("^Operator selects filters on Shipper Pickups page:$")
  public void operatorSelectsFilters(Map<String, String> data) {
    data = resolveKeyValues(data);

    shipperPickupsPage.waitUntilPageLoaded();

    if (data.containsKey("reservationDateFrom")) {
      if (!shipperPickupsPage.reservationDateFilter.isDisplayedFast()) {
        shipperPickupsPage.addFilter("Reservation Date");
      }
      shipperPickupsPage.reservationDateFilter.selectFromDate(data.get("reservationDateFrom"));
    } else {
      if (shipperPickupsPage.reservationDateFilter.isDisplayedFast()) {
        shipperPickupsPage.reservationDateFilter.selectFromDate(DateUtil.getTodayDate_YYYY_MM_DD());
      }
    }

    if (data.containsKey("reservationDateTo")) {
      if (!shipperPickupsPage.reservationDateFilter.isDisplayedFast()) {
        shipperPickupsPage.addFilter("Reservation Date");
      }
      shipperPickupsPage.reservationDateFilter.selectToDate(data.get("reservationDateTo"));
    } else {
      if (shipperPickupsPage.reservationDateFilter.isDisplayedFast()) {
        shipperPickupsPage.reservationDateFilter.selectToDate(DateUtil.getTodayDate_YYYY_MM_DD());
      }
    }

    if (shipperPickupsPage.reservationTypesFilter.isDisplayedFast()) {
      shipperPickupsPage.reservationTypesFilter.clearAll();
    }
    if (data.containsKey("reservationTypes")) {
      if (!shipperPickupsPage.reservationTypesFilter.isDisplayedFast()) {
        shipperPickupsPage.addFilter("Reservation Types");
      }
      shipperPickupsPage.reservationTypesFilter
          .selectFilter(splitAndNormalize(data.get("reservationTypes")));
    }

    if (shipperPickupsPage.waypointStatusFilter.isDisplayedFast()) {
      shipperPickupsPage.waypointStatusFilter.clearAll();
    }
    if (data.containsKey("waypointStatus")) {
      if (!shipperPickupsPage.waypointStatusFilter.isDisplayedFast()) {
        shipperPickupsPage.addFilter("Reservation Types");
      }
      shipperPickupsPage.waypointStatusFilter
          .selectFilter(splitAndNormalize(data.get("waypointStatus")));
    }

    if (shipperPickupsPage.hubsFilter.isDisplayedFast()) {
      shipperPickupsPage.hubsFilter.clearAll();
    }
    if (data.containsKey("hubs")) {
      if (!shipperPickupsPage.hubsFilter.isDisplayedFast()) {
        shipperPickupsPage.addFilter("Hubs");
      }
      shipperPickupsPage.hubsFilter.waitUntilLoaded();
      shipperPickupsPage.hubsFilter.selectFilter(data.get("hubsFilter"));
    }

    if (shipperPickupsPage.shipperFilter.isDisplayedFast()) {
      shipperPickupsPage.shipperFilter.clearAll();
    }
    if (data.containsKey("shipper")) {
      if (!shipperPickupsPage.shipperFilter.isDisplayedFast()) {
        shipperPickupsPage.addFilter("Shipper");
      }
      shipperPickupsPage.shipperFilter.selectFilter(data.get("shipper"));
    }

    if (shipperPickupsPage.masterShipperFilter.isDisplayedFast()) {
      shipperPickupsPage.masterShipperFilter.clearAll();
    }
    if (data.containsKey("masterShipper")) {
      if (!shipperPickupsPage.masterShipperFilter.isDisplayedFast()) {
        shipperPickupsPage.addFilter("Master Shipper");
      }
      shipperPickupsPage.masterShipperFilter.waitUntilLoaded();
      shipperPickupsPage.masterShipperFilter.selectFilter(data.get("masterShipper"));
    }

    if (shipperPickupsPage.zonesFilter.isDisplayedFast()) {
      shipperPickupsPage.zonesFilter.clearAll();
    }
    if (data.containsKey("zones")) {
      if (!shipperPickupsPage.zonesFilter.isDisplayedFast()) {
        shipperPickupsPage.addFilter("Zones");
      }
      shipperPickupsPage.zonesFilter.selectFilter(data.get("zones"));
    }
  }

  @When("^Operator updates filters on Shipper Pickups page:$")
  public void operatorUpdatesFilters(Map<String, String> data) {
    data = resolveKeyValues(data);

    shipperPickupsPage.waitUntilPageLoaded();

    if (data.containsKey("reservationDateFrom")) {
      if (!shipperPickupsPage.reservationDateFilter.isDisplayedFast()) {
        shipperPickupsPage.addFilter("Reservation Date");
      }
      shipperPickupsPage.reservationDateFilter.selectFromDate(data.get("reservationDateFrom"));
    }

    if (data.containsKey("reservationDateTo")) {
      if (!shipperPickupsPage.reservationDateFilter.isDisplayedFast()) {
        shipperPickupsPage.addFilter("Reservation Date");
      }
      shipperPickupsPage.reservationDateFilter.selectToDate(data.get("reservationDateTo"));
    }

    if (data.containsKey("reservationTypes")) {
      if (!shipperPickupsPage.reservationTypesFilter.isDisplayedFast()) {
        shipperPickupsPage.addFilter("Reservation Types");
      }
      shipperPickupsPage.reservationTypesFilter.clearAll();
      shipperPickupsPage.reservationTypesFilter
          .selectFilter(splitAndNormalize(data.get("reservationTypes")));
    }

    if (data.containsKey("waypointStatus")) {
      if (!shipperPickupsPage.waypointStatusFilter.isDisplayedFast()) {
        shipperPickupsPage.addFilter("Reservation Types");
      }
      shipperPickupsPage.waypointStatusFilter.clearAll();
      shipperPickupsPage.waypointStatusFilter
          .selectFilter(splitAndNormalize(data.get("waypointStatus")));
    }

    if (data.containsKey("hubs")) {
      if (!shipperPickupsPage.hubsFilter.isDisplayedFast()) {
        shipperPickupsPage.addFilter("Hubs");
      }
      shipperPickupsPage.hubsFilter.clearAll();
      shipperPickupsPage.hubsFilter.selectFilter(data.get("hubs"));
    }

    if (data.containsKey("shipper")) {
      if (!shipperPickupsPage.shipperFilter.isDisplayedFast()) {
        shipperPickupsPage.addFilter("Shipper");
      }
      shipperPickupsPage.shipperFilter.clearAll();
      shipperPickupsPage.shipperFilter.selectFilter(data.get("shipper"));
    }

    if (data.containsKey("masterShipper")) {
      if (!shipperPickupsPage.masterShipperFilter.isDisplayedFast()) {
        shipperPickupsPage.addFilter("Master Shipper");
      }
      shipperPickupsPage.masterShipperFilter.clearAll();
      shipperPickupsPage.masterShipperFilter.selectFilter(data.get("masterShipper"));
    }

    if (data.containsKey("zones")) {
      if (!shipperPickupsPage.zonesFilter.isDisplayedFast()) {
        shipperPickupsPage.addFilter("Zones");
      }
      shipperPickupsPage.zonesFilter.clearAll();
      shipperPickupsPage.zonesFilter.selectFilter(data.get("zones"));
    }
  }

  @When("Operator selects {string} preset action on Shipper Pickups page")
  public void selectPresetAction(String action) {
    shipperPickupsPage.presetActions.selectOption(resolveValue(action));
  }

  @When("Operator verifies Save Preset dialog on Shipper Pickups page contains filters:")
  public void verifySelectedFiltersForPreset(List<String> expected) {
    shipperPickupsPage.savePresetDialog.waitUntilVisible();
    List<String> actual = shipperPickupsPage.savePresetDialog.selectedFilters.stream()
        .map(PageElement::getNormalizedText)
        .collect(Collectors.toList());
    Assertions.assertThat(actual)
        .as("List of selected filters")
        .containsExactlyInAnyOrderElementsOf(expected);
  }

  @When("Operator verifies Preset Name field in Save Preset dialog on Shipper Pickups page is required")
  public void verifyPresetNameIsRequired() {
    shipperPickupsPage.savePresetDialog.waitUntilVisible();
    Assertions
        .assertThat(shipperPickupsPage.savePresetDialog.presetName.getAttribute("ng-required"))
        .as("Preset Name field ng-required attribute")
        .isEqualTo("required");
  }

  @When("Operator verifies help text {string} is displayed in Save Preset dialog on Shipper Pickups page")
  public void verifyHelpTextInSavePreset(String expected) {
    shipperPickupsPage.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(shipperPickupsPage.savePresetDialog.helpText.getNormalizedText())
        .as("Help Text")
        .isEqualTo(resolveValue(expected));
  }

  @When("Operator verifies Cancel button in Save Preset dialog on Shipper Pickups page is enabled")
  public void verifyCancelIsEnabled() {
    shipperPickupsPage.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(shipperPickupsPage.savePresetDialog.cancel.isEnabled())
        .as("Cancel button is enabled")
        .isTrue();
  }

  @When("Operator verifies Save button in Save Preset dialog on Shipper Pickups page is enabled")
  public void verifySaveIsEnabled() {
    shipperPickupsPage.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(shipperPickupsPage.savePresetDialog.save.isEnabled())
        .as("Save button is enabled")
        .isTrue();
  }

  @When("Operator clicks Save button in Save Preset dialog on Shipper Pickups page")
  public void clickSaveInSavePresetDialog() {
    shipperPickupsPage.savePresetDialog.save.click();
  }

  @When("Operator clicks Update button in Save Preset dialog on Shipper Pickups page")
  public void clickUpdateInSavePresetDialog() {
    shipperPickupsPage.savePresetDialog.update.click();
  }

  @When("Operator verifies Save button in Save Preset dialog on Shipper Pickups page is disabled")
  public void verifySaveIsDisabled() {
    shipperPickupsPage.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(shipperPickupsPage.savePresetDialog.save.isEnabled())
        .as("Save button is enabled")
        .isFalse();
  }

  @When("Operator verifies selected Filter Preset name is {string} on Shipper Pickups page")
  public void verifySelectedPresetName(String expected) {
    expected = resolveValue(expected);
    String actual = StringUtils.trim(shipperPickupsPage.filterPreset.getValue());
    Pattern p = Pattern.compile("(\\d+)\\s-\\s(.+)");
    Matcher m = p.matcher(actual);
    Assertions.assertThat(m.matches())
        .as("Selected Filter Preset value matches to pattern")
        .isTrue();
    Long presetId = Long.valueOf(m.group(1));
    String presetName = m.group(2);
    Assertions.assertThat(presetName)
        .as("Preset Name")
        .isEqualTo(expected);
    put(KEY_SHIPPER_PICKUPS_FILTERS_PRESET_ID, presetId);
  }

  @When("Operator selects {string} Filter Preset on Shipper Pickups page")
  public void selectPresetName(String value) {
    shipperPickupsPage.filterPreset.searchAndSelectValue(resolveValue(value));
    if (shipperPickupsPage.halfCircleSpinner.waitUntilVisible(3)) {
      shipperPickupsPage.halfCircleSpinner.waitUntilInvisible();
    }
    pause1s();
  }

  @When("Operator enters {string} Preset Name in Save Preset dialog on Shipper Pickups page")
  public void enterPresetNameIsRequired(String presetName) {
    shipperPickupsPage.savePresetDialog.waitUntilVisible();
    presetName = resolveValue(presetName);
    shipperPickupsPage.savePresetDialog.presetName.setValue(presetName);
    put(KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME, presetName);
  }

  @When("Operator verifies Preset Name field in Save Preset dialog on Shipper Pickups page has green checkmark on it")
  public void verifyPresetNameIsValidated() {
    Assertions.assertThat(shipperPickupsPage.savePresetDialog.confirmedIcon.isDisplayed())
        .as("Preset Name checkmark")
        .isTrue();
  }

  @When("^Operator verifies selected filters on Shipper Pickups page:$")
  public void operatorVerifiesSelectedFilters(Map<String, String> data) {
    data = resolveKeyValues(data);
    shipperPickupsPage.waitUntilPageLoaded();

    SoftAssertions assertions = new SoftAssertions();

    if (data.containsKey("reservationDateFrom")) {
      boolean isDisplayed = shipperPickupsPage.reservationDateFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Reservation Date is not displayed");
      } else {
        assertions.assertThat(shipperPickupsPage.reservationDateFilter.fromDate.getValue())
            .as("Reservation Date from")
            .isEqualTo(data.get("reservationDateFrom"));
      }
    }

    if (data.containsKey("reservationDateTo")) {
      boolean isDisplayed = shipperPickupsPage.reservationDateFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Reservation Date is not displayed");
      } else {
        assertions.assertThat(shipperPickupsPage.reservationDateFilter.toDate.getValue())
            .as("Reservation Date to")
            .isEqualTo(data.get("reservationDateTo"));
      }
    }

    if (data.containsKey("reservationTypes")) {
      boolean isDisplayed = shipperPickupsPage.reservationTypesFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Reservation Types filter is not displayed");
      } else {
        assertions.assertThat(shipperPickupsPage.reservationTypesFilter.getSelectedValues())
            .as("Reservation types items")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("reservationTypes")));
      }
    }

    if (data.containsKey("waypointStatus")) {
      boolean isDisplayed = shipperPickupsPage.waypointStatusFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Waypoint Status filter is not displayed");
      } else {
        assertions.assertThat(shipperPickupsPage.waypointStatusFilter.getSelectedValues())
            .as("Waypoint Status items")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("waypointStatus")));
      }
    }

    if (data.containsKey("hubs")) {
      boolean isDisplayed = shipperPickupsPage.hubsFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Hubs filter is not displayed");
      } else {
        shipperPickupsPage.hubsFilter.waitUntilLoaded();
        assertions.assertThat(shipperPickupsPage.hubsFilter.getSelectedValues())
            .as("Hubs items")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("hubs")));
      }
    }

    if (data.containsKey("shipper")) {
      boolean isDisplayed = shipperPickupsPage.shipperFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Shipper filter is not displayed");
      } else {
        assertions.assertThat(shipperPickupsPage.shipperFilter.getSelectedValues())
            .as("Shipper items")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("shipper")));
      }
    }

    if (data.containsKey("masterShipper")) {
      shipperPickupsPage.waitUntilPageLoaded();
      boolean isDisplayed = shipperPickupsPage.masterShipperFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Master Shipper filter is not displayed");
      } else {
        shipperPickupsPage.masterShipperFilter.waitUntilLoaded();
        assertions.assertThat(shipperPickupsPage.masterShipperFilter.getSelectedValues())
            .as("Master Shipper items")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("masterShipper")));
      }
    }

    if (data.containsKey("zones")) {
      boolean isDisplayed = shipperPickupsPage.zonesFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Zones filter is not displayed");
      } else {
        assertions.assertThat(shipperPickupsPage.zonesFilter.getSelectedValues())
            .as("Zones items")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("zones")));
      }
    }

    assertions.assertAll();
  }

  @When("Operator verifies Cancel button in Delete Preset dialog on Shipper Pickups page is enabled")
  public void verifyCancelIsEnabledInDeletePreset() {
    shipperPickupsPage.deletePresetDialog.waitUntilVisible();
    Assertions.assertThat(shipperPickupsPage.deletePresetDialog.cancel.isEnabled())
        .as("Cancel button is enabled")
        .isTrue();
  }

  @When("Operator verifies Delete button in Delete Preset dialog on Shipper Pickups page is enabled")
  public void verifyDeleteIsEnabled() {
    shipperPickupsPage.deletePresetDialog.waitUntilVisible();
    Assertions.assertThat(shipperPickupsPage.deletePresetDialog.delete.isEnabled())
        .as("Delete button is enabled")
        .isTrue();
  }

  @When("Operator selects {string} preset in Delete Preset dialog on Shipper Pickups page")
  public void selectPresetInDeletePresets(String value) {
    shipperPickupsPage.deletePresetDialog.waitUntilVisible();
    shipperPickupsPage.deletePresetDialog.preset.searchAndSelectValue(resolveValue(value));
  }

  @When("Operator clicks Delete button in Delete Preset dialog on Shipper Pickups page")
  public void clickDeleteInDeletePresetDialog() {
    shipperPickupsPage.deletePresetDialog.delete.click();
  }

  @When("Operator verifies Delete button in Delete Preset dialog on Shipper Pickups page is disabled")
  public void verifyDeleteIsDisabled() {
    shipperPickupsPage.deletePresetDialog.waitUntilVisible();
    Assertions.assertThat(shipperPickupsPage.deletePresetDialog.delete.isEnabled())
        .as("Delete button is enabled")
        .isFalse();
  }

  @When("Operator verifies {string} message is displayed in Delete Preset dialog on Shipper Pickups page")
  public void verifyMessageInDeletePreset(String expected) {
    shipperPickupsPage.deletePresetDialog.waitUntilVisible();
    Assertions.assertThat(shipperPickupsPage.deletePresetDialog.message.getNormalizedText())
        .as("Delete Preset message")
        .isEqualTo(resolveValue(expected));
  }
}
