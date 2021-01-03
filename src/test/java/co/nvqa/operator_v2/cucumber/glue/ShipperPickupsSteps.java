package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.Reservation;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.model.ReservationInfo;
import co.nvqa.operator_v2.selenium.elements.md.MdCheckbox;
import co.nvqa.operator_v2.selenium.page.ShipperPickupsPage;
import co.nvqa.operator_v2.selenium.page.ShipperPickupsPage.BulkRouteAssignmentSidePanel.ReservationCard;
import co.nvqa.operator_v2.util.TestUtils;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.text.ParseException;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;

import static co.nvqa.operator_v2.selenium.page.ShipperPickupsPage.ReservationsTable.ACTION_BUTTON_DETAILS;
import static co.nvqa.operator_v2.selenium.page.ShipperPickupsPage.ReservationsTable.ACTION_BUTTON_ROUTE_EDIT;
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
    Date currentDate = new Date();
    Date nextDayDate = TestUtils.getNextDate(1);
    shipperPickupsPage.filtersForm.filterReservationDate(currentDate, nextDayDate);
    shipperPickupsPage.filtersForm.loadSelection.clickAndWaitUntilDone();
  }

  @When("^Operator set filter parameters and click Load Selection on Shipper Pickups page:$")
  public void operatorSetFilterParametersAndClickLoadSelectionOnShipperPickupsPage(
      Map<String, String> mapOfData) throws ParseException {
    mapOfData = resolveKeyValues(mapOfData);

    String value = mapOfData.get("fromDate");
    Date fromDate = StringUtils.isNotBlank(value) ? YYYY_MM_DD_SDF.parse(value) : new Date();
    value = mapOfData.get("toDate");
    Date toDate =
        StringUtils.isNotBlank(value) ? YYYY_MM_DD_SDF.parse(value) : TestUtils.getNextDate(1);
    shipperPickupsPage.filtersForm.filterReservationDate(fromDate, toDate);

    value = mapOfData.get("hub");
    if (StringUtils.isNotBlank(value)) {
      shipperPickupsPage.filtersForm.filterByHub(value);
    }
    value = mapOfData.get("zone");
    if (StringUtils.isNotBlank(value)) {
      shipperPickupsPage.filtersForm.filterByZone(value);
    }
    value = mapOfData.get("type");
    if (StringUtils.isNotBlank(value)) {
      shipperPickupsPage.filtersForm.filterByType(value);
    }
    value = mapOfData.get("status");
    if (StringUtils.isNotBlank(value)) {
      shipperPickupsPage.filtersForm.filterByStatus(value);
    }
    value = mapOfData.get("shipperName");
    if (StringUtils.isNotBlank(value)) {
      shipperPickupsPage.filtersForm.filterByShipper(value);
    }
    value = mapOfData.get("masterShipperName");
    if (StringUtils.isNotBlank(value)) {
      shipperPickupsPage.filtersForm.filterByMasterShipper(value);
    }
    shipperPickupsPage.filtersForm.loadSelection.clickAndWaitUntilDone();
  }

  private Date resolveFilterDate(String value) {
    switch (value.toUpperCase()) {
      case "TODAY":
        return new Date();
      case "TOMORROW":
        return TestUtils.getNextDate(1);
      default:
        return Date.from(DateUtil.getDate(value).toInstant());
    }
  }

  @When("^Operator refresh routes on Shipper Pickups page$")
  public void operatorRefreshRoutesOnShipperPickupPage() {
    shipperPickupsPage.clickButtonRefresh();
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
    mapOfData = resolveKeyValues(mapOfData);
    verifyReservationData(addressResult, mapOfData);
  }

  @Then("^Operator verify the new reservations are listed on table in Shipper Pickups page using data below:$")
  public void operatorVerifyTheNewReservationsAreListedOnTableInShipperPickupsPageUsingDataBelow(
      Map<String, String> mapOfData) {
    List<Address> addresses = get(KEY_LIST_OF_CREATED_ADDRESSES);
    addresses.forEach(address -> verifyReservationData(address, mapOfData));
  }

  private void verifyReservationData(Address address, Map<String, String> mapOfData) {
    String shipperName = mapOfData.get("shipperName");
    String routeId = mapOfData.get("routeId");
    String driverName = mapOfData.get("driverName");
    String priorityLevel = mapOfData.get("priorityLevel");
    String approxVolume = mapOfData.get("approxVolume");
    String comments = mapOfData.get("comments");

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
            approxVolume, comments);
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
        return route.getDriver().getFirstName() + " " + route.getDriver().getLastName();
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
    DateTimeFormatter reservationDateTimeFormatter = DateTimeFormatter
        .ofPattern("yyyy-MM-dd HH:mm:ss").withZone(ZoneId.of("UTC"));
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

    Date newDate = Date.from(newReadyDatetime.toInstant());
    List<ReservationInfo> duplicatedReservationsInfo = shipperPickupsPage
        .duplicateReservations(addresses, newDate);

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
    Address address = get(KEY_CREATED_ADDRESS);
    String routeTagName = dataTableAsMap.get("routeTagName");
    addRouteViaRouteSuggestion(Collections.singletonList(address),
        Collections.singletonList(routeTagName));
  }

  @And("^Operator select Route Tags for Route Suggestion of created reservation using data below:$")
  public void operatorSelectRouteTagsForRouteSuggestionsOfTheRouteUsingDataBelow(
      Map<String, String> dataTableAsMap) {
    Address address = get(KEY_CREATED_ADDRESS);
    String routeTagName = dataTableAsMap.get("routeTagName");
    shipperPickupsPage
        .suggestRoute(Collections.singletonList(address), Collections.singletonList(routeTagName));
  }

  @And("^Operator select Route Tags for Route Suggestion of created reservations using data below:$")
  public void operatorSelectRouteTagsForRouteSuggestionsOfCreatedReservationsUsingDataBelow(
      Map<String, String> dataTableAsMap) {
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
      shipperPickupsPage.reservationsTable.searchByPickupAddress(address);
      shipperPickupsPage.reservationsTable.selectRow(1);
    });
  }

  @And("^Operator verifies no route suggested for selected reservations$")
  public void operatorVerifiesNoRouteSuggestedForSelectedReservations() {
    shipperPickupsPage.bulkRouteAssignmentDialog.suggestedRoutes.forEach(routeSelector ->
    {
      assertEquals("Suggested route value", "", routeSelector.getValue());
    });
  }

  @And("^Operator use the Route Suggestion to add created reservations to the route using data below:$")
  public void operatorUseTheRouteSuggestionToAddCreatedReservationsToTheRoute(
      Map<String, String> dataTableAsMap) {
    List<Address> addresses = get(KEY_LIST_OF_CREATED_ADDRESSES);
    String routeTagName = dataTableAsMap.get("routeTagName");
    addRouteViaRouteSuggestion(addresses, Collections.singletonList(routeTagName));
  }

  private void addRouteViaRouteSuggestion(List<Address> addresses, List<String> routeTags) {
    List<Route> zzzRoutes = get(KEY_LIST_OF_FOUND_ROUTES);
    Route suggestedRoute = shipperPickupsPage
        .suggestRoute(addresses, routeTags)
        .validateSuggestedRoutes(zzzRoutes);
    put(KEY_SUGGESTED_ROUTE, suggestedRoute);
    shipperPickupsPage.bulkRouteAssignmentDialog().submitForm();
    shipperPickupsPage.clickButtonRefresh();
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
    assertNull("Route Id", actual.getRouteId());
    assertNull("Driver Name", actual.getDriverName());
  }

  @Then("^Operator verify the route was removed from the created reservations$")
  public void operatorVerifyTheRouteWasRemovedFromTheCreatedReservations() {
    List<Address> addresses = get(KEY_LIST_OF_CREATED_ADDRESSES);
    addresses.forEach(address ->
    {
      shipperPickupsPage.reservationsTable.searchByPickupAddress(address);
      ReservationInfo actual = shipperPickupsPage.reservationsTable.readEntity(1);
      assertNull("Route Id", actual.getRouteId());
      assertNull("Driver Name", actual.getDriverName());
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
    assertTrue("POD not found",
        shipperPickupsPage.reservationDetailsDialog.podNotFound.isDisplayed());
  }

  @Then("^Operator verifies POD details in Reservation Details dialog on Shipper Pickups page using data below:$")
  public void operatorVerifiesPodDetails(Map<String, String> data) {
    data = resolveKeyValues(data);
    shipperPickupsPage.reservationDetailsDialog.waitUntilVisible();
    String expectedValue = data.get("timestamp");
    if (StringUtils.isNotBlank(expectedValue)) {
      assertThat("Timestamp",
          shipperPickupsPage.reservationDetailsDialog.timestamp.getNormalizedText(),
          Matchers.startsWith(expectedValue));
    }
    expectedValue = data.get("inputOnPod");
    if (StringUtils.isNotBlank(expectedValue)) {
      assertEquals("Input on POD (Driver)", expectedValue,
          shipperPickupsPage.reservationDetailsDialog.inputOnPod.getNormalizedText());
    }
    expectedValue = data.get("scannedAtShipperCount");
    if (StringUtils.isNotBlank(expectedValue)) {
      assertEquals("Scanned at Shipper count", expectedValue,
          shipperPickupsPage.reservationDetailsDialog.scannedAtShipperCount.getNormalizedText());
    }
    expectedValue = data.get("scannedAtShipperPOD");
    if (StringUtils.isNotBlank(expectedValue)) {
      assertEquals("Scanned at Shipper (POD)", expectedValue,
          shipperPickupsPage.reservationDetailsDialog.scannedAtShipperPOD.getNormalizedText());
    }
  }

  @Then("^Operator verifies filter parameters on Shipper Pickups page using data below:$")
  public void operatorVerifiesFilterParametersDetails(Map<String, String> data) {
    data = resolveKeyValues(data);
    String expectedValue = data.get("shippers");
    if (StringUtils.isNotBlank(expectedValue)) {
      assertThat("Shipper filter", shipperPickupsPage.shipperFilter.getSelectedValues(), Matchers
          .containsInAnyOrder(
              Arrays.stream(expectedValue.split(",")).map(StringUtils::trim).toArray()));
    }
  }

  @When("^Operator switch (on|off) Bulk Assign Route toggle on Shipper Pickups page$")
  public void operatorSwitchBulkAssignRoute(String mode) {
    shipperPickupsPage.bulkAssignRoute.setValue(StringUtils.equalsIgnoreCase(mode, "on"));
  }

  @Then("^Operator verify that Bulk Route Assignment Side Panel is shown on Shipper Pickups page$")
  public void operatorVerifyBulkRouteAssignmentSidePanelIsShown() {
    assertTrue("Bulk Route Assignment Side Panel is shown",
        shipperPickupsPage.bulkAssignRoute.waitUntilVisible(5));
  }

  @Then("^Operator verify that title of Bulk Route Assignment Side Panel is \"(.+)\"$")
  public void operatorVerifyBulkRouteAssignmentSidePanelTitle(String expected) {
    assertEquals("Bulk Route Assignment Side Panel title", expected,
        shipperPickupsPage.bulkRouteAssignmentSidePanel.description.getText());
  }

  @Then("^Operator verify reservations data in Bulk Route Assignment Side Panel using data below:$")
  public void operatorVerifyReservationDataInBulkRouteAssignmentSidePanelTitle(
      List<Map<String, String>> data) {
    assertEquals("Count of Reservation Cards in Bulk Route Assignment Side Panel", data.size(),
        shipperPickupsPage.bulkRouteAssignmentSidePanel.reservationCards.size());
    for (int i = 0; i < data.size(); i++) {
      ReservationCard reservationCard = shipperPickupsPage.bulkRouteAssignmentSidePanel.reservationCards
          .get(i);
      Map<String, String> expected = resolveKeyValues(data.get(i));
      if (expected.containsKey("title")) {
        assertThat(f("Reservation card title %d", i + 1), reservationCard.title.getText(),
            Matchers.startsWith(expected.get("title")));
      }
      if (expected.containsKey("description")) {
        assertThat(f("Reservation card description %d", i + 1),
            reservationCard.description.getText(), Matchers.equalTo(expected.get("description")));
      }
      if (expected.containsKey("subtitle")) {
        assertThat(f("Reservation card subtitle %d", i + 1), reservationCard.subtitle.getText(),
            Matchers.equalTo(expected.get("subtitle")));
      }
    }
  }

  @When("^Operator select \"(.+)\" route in Bulk Route Assignment Side Panel$")
  public void operatorSelectRouteInBulkRouteAssignmentSidePanel(String route) {
    shipperPickupsPage.bulkRouteAssignmentSidePanel.route.selectValue(resolveValue(route));
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
    assertFalse("Checkbox is enabled", checkBox.isEnabled());
    assertFalse("Checkbox is checked", checkBox.isChecked());
  }

  @Then("^Operator verify that \"(.+)\" icon is disabled for created reservation on Shipper Pickups page$")
  public void operatorVerifyThatFinishIconIsDisabled(String buttonName) {
    Address address = get(KEY_CREATED_ADDRESS);
    shipperPickupsPage.reservationsTable.searchByPickupAddress(address);
    assertFalse(f("%s button is disabled", buttonName),
        shipperPickupsPage.reservationsTable.getActionButton(buttonName, 1).isEnabled());
  }

  @Then("^Operator verifies POD details in POD Details dialog on Shipper Pickups page using data below:$")
  public void operatorVerifiesPodDetailsDialog(Map<String, String> data) {
    data = resolveKeyValues(data);
    if (!shipperPickupsPage.podDetailsDialog.isDisplayedFast()) {
      assertTrue("Reservation dialog is opened",
          shipperPickupsPage.reservationDetailsDialog.waitUntilVisible(5));
      shipperPickupsPage.reservationDetailsDialog.viewPod.click();
      shipperPickupsPage.podDetailsDialog.waitUntilVisible();
    }
    String expectedValue = data.get("reservationId");
    if (StringUtils.isNotBlank(expectedValue)) {
      assertEquals("Reservation ID",
          expectedValue,
          shipperPickupsPage.podDetailsDialog.reservationId.getNormalizedText());
    }
    expectedValue = data.get("recipientName");
    if (StringUtils.isNotBlank(expectedValue)) {
      assertEquals("Recipient Name", expectedValue,
          shipperPickupsPage.podDetailsDialog.recipientName.getNormalizedText());
    }
    expectedValue = data.get("shipperId");
    if (StringUtils.isNotBlank(expectedValue)) {
      assertEquals("Shipper ID", expectedValue,
          shipperPickupsPage.podDetailsDialog.shipperId.getNormalizedText());
    }
    expectedValue = data.get("shipperName");
    if (StringUtils.isNotBlank(expectedValue)) {
      assertEquals("Shipper Name", expectedValue,
          shipperPickupsPage.podDetailsDialog.shipperName.getNormalizedText());
    }
    expectedValue = data.get("shipperContact");
    if (StringUtils.isNotBlank(expectedValue)) {
      assertEquals("Shipper Contact", expectedValue,
          shipperPickupsPage.podDetailsDialog.shipperContact.getNormalizedText());
    }
    expectedValue = data.get("status");
    if (StringUtils.isNotBlank(expectedValue)) {
      assertEquals("Status", expectedValue,
          shipperPickupsPage.podDetailsDialog.status.getNormalizedText());
    }
    shipperPickupsPage.podDetailsDialog.forceClose();
  }

  @Then("^Operator verifies downloaded POD CSV file on Shipper Pickups page using data below:$")
  public void operatorVerifiesPodCsvFile(List<String> trackingIds) {
    trackingIds = resolveValues(trackingIds);
    assertTrue("Reservation dialog is opened",
        shipperPickupsPage.reservationDetailsDialog.waitUntilVisible(5));
    String podId = shipperPickupsPage.reservationDetailsDialog.podName.getAttribute("name")
        .replace("POD-", "");
    shipperPickupsPage.reservationDetailsDialog.downloadCsvFile.click();
    for (String trackingId : trackingIds) {
      shipperPickupsPage
          .verifyFileDownloadedSuccessfully("pod-file-id-" + podId + ".csv", trackingId);
    }
  }

  @When("^Operator edit reservation address details on Edit Route Details dialog using data below:$")
  public void operatorEditReservationAddressFromEditRouteDetailsDialog(Map<String, String> data) {
    Address oldAddress = resolveValue(data.get("oldAddress"));
    Address newAddress = resolveValue(data.get("newAddress"));
    shipperPickupsPage.reservationsTable.searchByPickupAddress(oldAddress);
    shipperPickupsPage.reservationsTable.clickActionButton(1, ACTION_BUTTON_ROUTE_EDIT);
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
    shipperPickupsPage.editRouteDialog.submitForm();
  }
}
