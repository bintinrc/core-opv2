package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.model.route.RouteResponse;
import co.nvqa.common.core.utils.CoreScenarioStorageKeys;
import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.operator_v2.model.ExpectedScans;
import co.nvqa.operator_v2.model.MoneyCollection;
import co.nvqa.operator_v2.model.MoneyCollectionCollectedOrderEntry;
import co.nvqa.operator_v2.model.MoneyCollectionHistoryEntry;
import co.nvqa.operator_v2.model.WaypointOrderInfo;
import co.nvqa.operator_v2.model.WaypointPerformance;
import co.nvqa.operator_v2.model.WaypointReservationInfo;
import co.nvqa.operator_v2.model.WaypointScanInfo;
import co.nvqa.operator_v2.model.WaypointShipperInfo;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.RouteInboundPage;
import co.nvqa.operator_v2.selenium.page.RouteInboundPage.PhotoAuditDialog.WaypointsSection;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteInboundSteps extends AbstractSteps {

  private static final String FETCH_BY_ROUTE_ID = "FETCH_BY_ROUTE_ID";
  private static final String FETCH_BY_TRACKING_ID = "FETCH_BY_TRACKING_ID";
  private static final String FETCH_BY_DRIVER = "FETCH_BY_DRIVER";
  private static final String KEY_ROUTE_INBOUND_COMMENT = "KEY_ROUTE_INBOUND_COMMENT";

  private RouteInboundPage routeInboundPage;

  public RouteInboundSteps() {
  }

  @Override
  public void init() {
    routeInboundPage = new RouteInboundPage(getWebDriver());
  }

  @When("Operator get Route Summary Details on Route Inbound page using data below:")
  public void operatorGetRouteDetailsOnRouteInboundPageUsingDataBelow(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String hubName = mapOfData.get("hubName");
    String fetchBy = mapOfData.get("fetchBy");
    String fetchByValue = mapOfData.get("fetchByValue");
    String routeIdValue = mapOfData.get("routeId");
    Long routeId = getRouteId(routeIdValue);

    switch (fetchBy.toUpperCase()) {
      case FETCH_BY_ROUTE_ID:
        routeId = routeId != null ? routeId : Long.valueOf(fetchByValue);
        routeInboundPage.fetchRouteByRouteId(hubName, routeId);
        break;
      case FETCH_BY_TRACKING_ID:
        routeInboundPage.fetchRouteByTrackingId(hubName, fetchByValue, routeId);
        break;
      case FETCH_BY_DRIVER:
        routeInboundPage.fetchRouteByDriver(hubName, fetchByValue, routeId);
        break;

    }
  }

  @When("Operator get Route Summary Details of Invalid Data on Route Inbound page using data below:")
  public void operatorGetInvalidRouteDetailsOnRouteInboundPageUsingDataBelow(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    final String hubName = mapOfData.get("hubName");
    final String fetchBy = mapOfData.get("fetchBy");
    final String fetchByValue = mapOfData.get("fetchByValue");
    switch (fetchBy.toUpperCase()) {
      case FETCH_BY_ROUTE_ID:
        final long routeId = Long.valueOf(mapOfData.get("routeId"));
        routeInboundPage.fetchRouteByRouteId(hubName, routeId);
        break;
      case FETCH_BY_TRACKING_ID:
        routeInboundPage.fetchRouteByTrackingId(hubName, fetchByValue, null);
    }
  }

  private Long getRouteId(String value) {
    List<Long> routeIds = new ArrayList<>();
    List<RouteResponse> createdRoutes = get(CoreScenarioStorageKeys.KEY_LIST_OF_CREATED_ROUTES);
    if (createdRoutes != null) {
      createdRoutes.forEach(e -> routeIds.add(e.getId()));
    }
    if (StringUtils.isBlank(value)) {
      return routeIds.get(routeIds.size() - 1);
    }
    if (StringUtils.isNumeric(value)) {
      return Long.valueOf(value);
    }
    Pattern p = Pattern.compile("(GET_FROM_CREATED_ROUTE)(\\[\\s*)(\\d+)(\\s*])");
    Matcher m = p.matcher(value);
    if (m.matches()) {
      return routeIds.get(Integer.parseInt(m.group(3)) - 1);
    } else if (StringUtils.equals(value, "GET_FROM_CREATED_ROUTE")) {
      return routeIds.get(routeIds.size() - 1);
    } else {
      return null;
    }
  }

  @When("Operator verify error message displayed on Route Inbound:")
  public void checkErrorMessage(Map<String, String> data) {
    data = resolveKeyValues(data);
    String status = data.get("status");
    String url = data.get("url");
    String errorCode = data.get("errorCode");
    String errorMessage = data.get("errorMessage");

    routeInboundPage.verifyErrorMessage(status, url, errorCode, errorMessage);
  }

  @Then("Operator verify the Route Summary Details is correct using data below:")
  public void operatorVerifyTheRouteSummaryDetailsIsCorrectUsingDataBelow(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String routeIdAsString = mapOfData.get("routeId");
    String driverName = mapOfData.get("driverName");
    String hubName = mapOfData.get("hubName");
    String routeDateAsString = mapOfData.get("routeDate");

    Long routeId = getRouteId(routeIdAsString);

    ZonedDateTime routeDate;

    try {
      routeDate = StandardTestUtils.convertToZonedDateTime(routeDateAsString, ZoneId.of("UTC"),
          DTF_ISO_8601_LITE);
    } catch (DateTimeParseException ex) {
      throw new NvTestRuntimeException("Failed to parse route date.", ex);
    }

    WaypointPerformance waypointPerformance = new WaypointPerformance();
    waypointPerformance.setPending(Integer.parseInt(mapOfData.get("wpPending")));
    waypointPerformance.setPartial(Integer.parseInt(mapOfData.get("wpPartial")));
    waypointPerformance.setFailed(Integer.parseInt(mapOfData.get("wpFailed")));
    waypointPerformance.setCompleted(Integer.parseInt(mapOfData.get("wpCompleted")));
    waypointPerformance.setTotal(Integer.parseInt(mapOfData.get("wpTotal")));

    routeInboundPage.verifyRouteSummaryInfoIsCorrect(routeId, driverName, hubName, routeDate,
        waypointPerformance, null);
  }

  @Then("Operator verifies that Problematic Parcels table exactly contains records:")
  public void operatorVerifyProblematicParcelsRecordsExactly(List<Map<String, String>> data) {
    Assertions.assertThat(routeInboundPage.problematicParcelsTable.getRowsCount())
        .as("Number of problematic parcels").isEqualTo(data.size());

    List<WaypointOrderInfo> actualRecords = routeInboundPage.problematicParcelsTable
        .readAllEntities();

    data.forEach(entry -> {
      WaypointOrderInfo expected = new WaypointOrderInfo(resolveKeyValues(entry));
      WaypointOrderInfo actual = actualRecords.stream()
          .filter(
              val -> StringUtils.equalsIgnoreCase(expected.getTrackingId(), val.getTrackingId()))
          .findFirst()
          .orElseThrow(() -> new AssertionError(
              "Order " + expected.getTrackingId()
                  + " was not found in Problematic Orders table"));
      expected.compareWithActual(actual);
    });
  }

  @Then("Operator verifies that Problematic Waypoints table exactly contains records:")
  public void operatorVerifyProblematicWaypointsRecordsExactly
      (List<Map<String, String>> data) {
    Assertions.assertThat(routeInboundPage.problematicWaypointsTable.getRowsCount())
        .as("Number of problematic waypoints").isEqualTo(data.size());

    List<WaypointOrderInfo> actualRecords = routeInboundPage.problematicWaypointsTable
        .readAllEntities();

    data.forEach(entry -> {
      WaypointOrderInfo expected = new WaypointOrderInfo(resolveKeyValues(entry));
      WaypointOrderInfo actual = actualRecords.stream()
          .filter(
              val -> StringUtils.equalsIgnoreCase(expected.getLocation(), val.getLocation()))
          .findFirst()
          .orElseThrow(() -> new AssertionError(
              "Waypoint " + expected.getLocation()
                  + " was not found in Problematic Waypoints table"));
      expected.compareWithActual(actual);
    });
  }

  @Then("Operator verify the Route Inbound Details is correct using data below:")
  public void operatorVerifyTheRouteInboundDetailsIsCorrectUsingDataBelow(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String routeIdAsString = mapOfData.get("routeId");
    String driverName = mapOfData.get("driverName");
    String hubName = mapOfData.get("hubName");
    String routeDateAsString = mapOfData.get("routeDate");

    Long routeId = getRouteId(routeIdAsString);

    ZonedDateTime routeDate = null;
    if (StringUtils.isNotBlank(routeDateAsString)) {
      try {
        routeDate = StandardTestUtils
            .convertToZonedDateTime(routeDateAsString, ZoneId.of("UTC"),
                DTF_ISO_8601_LITE);
      } catch (DateTimeParseException ex) {
        throw new NvTestRuntimeException("Failed to parse route date.", ex);
      }
    }

    ExpectedScans expectedScans = new ExpectedScans();
    String value = mapOfData.get("pendingDeliveriesTotal");
    if (StringUtils.isNotBlank(value)) {
      expectedScans.setPendingDeliveriesTotal(Integer.parseInt(value));
    }
    value = mapOfData.get("pendingDeliveriesScans");
    if (StringUtils.isNotBlank(value)) {
      expectedScans.setPendingDeliveriesScans(Integer.parseInt(value));
    }
    value = mapOfData.get("parcelProcessedTotal");
    if (StringUtils.isNotBlank(value)) {
      expectedScans.setParcelProcessedTotal(Integer.parseInt(value));
    }
    value = mapOfData.get("parcelProcessedScans");
    if (StringUtils.isNotBlank(value)) {
      expectedScans.setParcelProcessedScans(Integer.parseInt(value));
    }
    value = mapOfData.get("failedDeliveriesValidTotal");
    if (StringUtils.isNotBlank(value)) {
      expectedScans.setFailedDeliveriesValidTotal(Integer.parseInt(value));
    }
    value = mapOfData.get("failedDeliveriesValidScans");
    if (StringUtils.isNotBlank(value)) {
      expectedScans.setFailedDeliveriesValidScans(Integer.parseInt(value));
    }
    value = mapOfData.get("failedDeliveriesInvalidTotal");
    if (StringUtils.isNotBlank(value)) {
      expectedScans.setFailedDeliveriesInvalidTotal(Integer.parseInt(value));
    }
    value = mapOfData.get("failedDeliveriesInvalidScans");
    if (StringUtils.isNotBlank(value)) {
      expectedScans.setFailedDeliveriesInvalidScans(Integer.parseInt(value));
    }
    value = mapOfData.get("pendingC2cReturnPickupsTotal");
    if (StringUtils.isNotBlank(value)) {
      expectedScans.setPendingC2cReturnPickupsTotal(Integer.parseInt(value));
    }
    value = mapOfData.get("pendingC2cReturnPickupsScans");
    if (StringUtils.isNotBlank(value)) {
      expectedScans.setPendingC2cReturnPickupsScans(Integer.parseInt(value));
    }
    value = mapOfData.get("c2cReturnPickupsTotal");
    if (StringUtils.isNotBlank(value)) {
      expectedScans.setC2cReturnPickupsTotal(Integer.parseInt(value));
    }
    value = mapOfData.get("c2cReturnPickupsScans");
    if (StringUtils.isNotBlank(value)) {
      expectedScans.setC2cReturnPickupsScans(Integer.parseInt(value));
    }
    value = mapOfData.get("reservationPickupsTotal");
    if (StringUtils.isNotBlank(value)) {
      expectedScans.setReservationPickupsTotal(Integer.parseInt(value));
    }
    value = mapOfData.get("reservationPickupsScans");
    if (StringUtils.isNotBlank(value)) {
      expectedScans.setReservationPickupsScans(Integer.parseInt(value));
    }
    value = mapOfData.get("reservationPickupsExtraOrders");
    if (StringUtils.isNotBlank(value)) {
      expectedScans.setReservationPickupsExtraOrders(Integer.parseInt(value));
    }
    routeInboundPage
        .verifyRouteInboundInfoIsCorrect(routeId, driverName, hubName, routeDate, expectedScans);
  }

  @When("Operator open Pending Waypoints Info dialog on Route Inbound page")
  public void operatorOpenPendingWaypointsInfoDialogOnRouteInboundPage() {
    routeInboundPage.openPendingWaypointsDialog();
  }

  @Then("Operator verify Shippers Info in {} dialog using data below:")
  public void operatorVerifyShippersInfoInPendingWaypointsDialogUsingDataBelow(String status,
      List<Map<String, String>> listOfData) {
    List<WaypointShipperInfo> expectedShippersInfo = listOfData.stream()
        .map(data -> new WaypointShipperInfo(resolveKeyValues(data)))
        .collect(Collectors.toList());
    routeInboundPage.validateShippersTable(expectedShippersInfo);
  }

  @When("Operator click 'View orders or reservations' button for shipper #{int} in {} dialog")
  public void operatorClickViewOrdersOrReservationsButtonForShipperInPendingWaypointsDialog(
      int index, String status) {
    routeInboundPage.openViewOrdersOrReservationsDialog(index);
  }

  @SuppressWarnings("unchecked")
  @Then("Operator verify Reservations table in {} dialog using data below:")
  public void operatorVerifyReservationsTableInPendingWaypointsDialogUsingDataBelow(String
      status,
      List<Map<String, String>> listOfData) {
    List<WaypointReservationInfo> expectedReservationsInfo = listOfData.stream().map(data ->
    {
      data = resolveKeyValues(data);
      WaypointReservationInfo reservationInfo = new WaypointReservationInfo();
      String value = data.get("reservationId");
      if (StringUtils.isNotBlank(value)) {
        reservationInfo.setReservationId(value);
      }

      value = data.get("location");

      if (StringUtils.isNotBlank(value)) {
        reservationInfo.setLocation(value);
      }

      value = data.get("readyToLatestTime");
      if (StringUtils.isNotBlank(value)) {
        reservationInfo.setReadyToLatestTime(value);
      }

      value = data.get("approxVolume");
      if (StringUtils.isNotBlank(value)) {
        reservationInfo.setApproxVolume(value);
      }

      value = data.get("status");
      if (StringUtils.isNotBlank(value)) {
        reservationInfo.setStatus(value);
      }

      value = data.get("receivedParcels");
      if (StringUtils.isNotBlank(value)) {
        reservationInfo.setReceivedParcels(value);
      }

      return reservationInfo;
    }).collect(Collectors.toList());

    routeInboundPage.validateReservationsTable(expectedReservationsInfo);
  }

  @SuppressWarnings("unchecked")
  @Then("Operator verify Orders table in {} dialog using data below:")
  public void operatorVerifyOrdersTableInPendingWaypointsDialogUsingDataBelow(String status,
      List<Map<String, String>> listOfData) {
    List<WaypointOrderInfo> expectedOrdersInfo = listOfData.stream().map(data ->
    {
      data = resolveKeyValues(data);
      WaypointOrderInfo orderInfo = new WaypointOrderInfo();
      String value = data.get("trackingId");
      if (StringUtils.isNotBlank(value)) {
        orderInfo.setTrackingId(value);
      }

      value = data.get("location");

      if (StringUtils.isNotBlank(value)) {
        orderInfo.setLocation(value);
      }

      value = data.get("type");

      if (StringUtils.isNotBlank(value)) {
        orderInfo.setType(value);
      }

      value = data.get("status");

      if (StringUtils.isNotBlank(value)) {
        orderInfo.setStatus(value);
      }

      value = data.get("cmiCount");

      if (StringUtils.isNotBlank(value)) {
        orderInfo.setCmiCount(value);
      }

      value = data.get("routeInboundStatus");

      if (StringUtils.isNotBlank(value)) {
        orderInfo.setRouteInboundStatus(value);
      }

      return orderInfo;
    }).collect(Collectors.toList());

    routeInboundPage.validateOrdersTable(expectedOrdersInfo);
  }

  @When("Operator click 'Continue To Inbound' button on Route Inbound page")
  public void operatorClickContinueToInboundButtonOnRouteInboundPage() {
    routeInboundPage.continueToInbound.waitUntilVisible();
    routeInboundPage.continueToInbound.click();
  }

  @When("Operator click 'Photo Audit' button on Route Inbound page")
  public void operatorClickPhotoAuditButtonOnRouteInboundPage() {
    routeInboundPage.photoAudit.click();
  }

  @When("Operator click 'I have completed photo audit' button on Route Inbound page")
  public void operatorClickCompletePhotoAuditButtonOnRouteInboundPage() {
    routeInboundPage.photoAuditDialog.waitUntilVisible();
    pause5s();
    routeInboundPage.photoAuditDialog.completePhotoAudit.click();
    routeInboundPage.photoAuditDialog.waitUntilInvisible();
    routeInboundPage.waitWhilePageIsLoading();
  }

  @When("Operator search {string} Tracking ID in Photo Audit dialog")
  public void operatorSearchTrackingIdInPhotoAuditDialog(String trackingId) {
    routeInboundPage.photoAuditDialog.searchTrackingId.setValue(resolveValue(trackingId));
  }

  @When("Operator close Photo Audit dialog")
  public void operatorClosePhotoAuditDialogOnRouteInboundPage() {
    routeInboundPage.photoAuditDialog.close();
  }

  @When("Operator verifies unsuccessful waypoints title is {string} in Photo Audit dialog")
  public void operatorVerifyUnsuccessfulWaypointTitle(String expected) {
    operatorVerifyWaypointTitle(routeInboundPage.photoAuditDialog.unsuccessfulWaypoints, expected,
        "Unsuccessful");
  }

  @When("Operator verifies successful waypoints title is {string} in Photo Audit dialog")
  public void operatorVerifySuccessfulWaypointTitle(String expected) {
    operatorVerifyWaypointTitle(routeInboundPage.photoAuditDialog.successfulWaypoints, expected,
        "Successful");
  }

  @When("Operator verifies partial waypoints title is {string} in Photo Audit dialog")
  public void operatorVerifyPartialWaypointTitle(String expected) {
    operatorVerifyWaypointTitle(routeInboundPage.photoAuditDialog.partialWaypoints, expected,
        "Partial");
  }

  public void operatorVerifyWaypointTitle(WaypointsSection section, String expected, String type) {
    pause5s();
    String actual = section.title.getNormalizedText();
    Assertions.assertThat(actual).as(type + " waypoints title").isEqualTo(resolveValue(expected));
  }

  @When("Operator clicks on {int} unsuccessful waypoint address in Photo Audit dialog")
  public void clickUnsuccessfulWaypointAddress(int index) {
    routeInboundPage.photoAuditDialog.unsuccessfulWaypoints.photos.get(index - 1).address.click();
  }

  @When("Operator clicks on {int} successful waypoint address in Photo Audit dialog")
  public void clickSuccessfulWaypointAddress(int index) {
    routeInboundPage.photoAuditDialog.successfulWaypoints.photos.get(index - 1).address.click();
  }

  @When("Operator clicks on {int} partial waypoint address in Photo Audit dialog")
  public void clickPartialWaypointAddress(int index) {
    routeInboundPage.photoAuditDialog.partialWaypoints.photos.get(index - 1).address.click();
  }

  @When("Operator clicks on {int} unsuccessful waypoint photo in Photo Audit dialog")
  public void clickUnsuccessfulWaypointPhoto(int index) {
    routeInboundPage.photoAuditDialog.unsuccessfulWaypoints.photos.get(index - 1).image.click();
  }

  @When("Operator clicks on {int} successful waypoint photo in Photo Audit dialog")
  public void clickSuccessfulWaypointPhoto(int index) {
    routeInboundPage.photoAuditDialog.successfulWaypoints.photos.get(index - 1).image.click();
  }

  @When("Operator clicks on {int} partial waypoint photo in Photo Audit dialog")
  public void clickPartialWaypointPhoto(int index) {
    routeInboundPage.photoAuditDialog.partialWaypoints.photos.get(index - 1).image.click();
  }

  @Then("Operator close Photo Details dialog")
  @When("Operator close Waypoint Details dialog")
  public void closeWaypointDetailsDialog() {
    routeInboundPage.photoAuditDialog.forceClose();
  }

  @When("Operator verifies waypoint parameters in Waypoint Details dialog:")
  public void checkWaypointParams(Map<String, String> data) {
    data = resolveKeyValues(data);
    routeInboundPage.waypointsDetailsDialog.waitUntilVisible();
    String value = data.get("address");
    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(routeInboundPage.waypointsDetailsDialog.address.getNormalizedText())
          .as("Waypoint address").isEqualTo(value);
    }
    value = data.get("contact");
    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(routeInboundPage.waypointsDetailsDialog.contact.getNormalizedText())
          .as("Waypoint contact").isEqualTo(value);
    }
    value = data.get("trackingId");
    if (StringUtils.isNotBlank(value)) {
      List<String> trackingIds = routeInboundPage.waypointsDetailsDialog.trackingId.stream()
          .map(PageElement::getNormalizedText)
          .collect(Collectors.toList());
      Assertions.assertThat(splitAndNormalize(value)).as("Waypoint Tracking IDs")
          .contains(trackingIds.toArray(new String[0]));
    }
  }

  @When("Operator verifies waypoint photo parameters in Photo Details dialog:")
  public void checkWaypointPhotoParams(Map<String, String> data) {
    data = resolveKeyValues(data);
    routeInboundPage.photoDetailsDialog.waitUntilVisible();
    String value = data.get("address");
    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(routeInboundPage.photoDetailsDialog.address.getNormalizedText())
          .as("Waypoint address").isEqualTo(value);
    }
    value = data.get("contact");
    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(routeInboundPage.photoDetailsDialog.contact.getNormalizedText())
          .as("Waypoint contact").isEqualTo(value);
    }
    String submissionDate = routeInboundPage.photoDetailsDialog.submissionDate
        .getNormalizedText();
    Assertions.assertThat(submissionDate).as("Submission date").isNotEmpty();
    Assertions.assertThat(routeInboundPage.photoDetailsDialog.submissionDate2.getNormalizedText())
        .as("Submission date below the photo").isEqualTo(submissionDate);
    Assertions.assertThat(routeInboundPage.photoDetailsDialog.image.isDisplayedFast())
        .as("Photo is displayed").isTrue();
  }

  @When("Operator clicks on {string} Tracking Id in Waypoint Details dialog")
  public void clickTrackingId(String value) {
    String trackingId = resolveValue(value);
    routeInboundPage.waypointsDetailsDialog.trackingId.stream()
        .filter(element -> StringUtils.equals(trackingId, element.getNormalizedText()))
        .findFirst()
        .orElseThrow(() -> new AssertionError("Tracking ID " + trackingId + " was not found"))
        .click();
  }

  @When("Operator verifies unsuccessful waypoints parameters in Photo Audit dialog:")
  public void operatorVerifyUnsuccessfulWaypointParams(List<Map<String, String>> data) {
    operatorVerifyWaypointParams(routeInboundPage.photoAuditDialog.unsuccessfulWaypoints, data);
  }

  @When("Operator verifies successful waypoints parameters in Photo Audit dialog:")
  public void operatorVerifySuccessfulWaypointParams(List<Map<String, String>> data) {
    operatorVerifyWaypointParams(routeInboundPage.photoAuditDialog.successfulWaypoints, data);
  }

  @When("Operator verifies no successful waypoints photos displayed in Photo Audit dialog")
  public void operatorVerifyNoSuccessfulWaypointPhotosDisplayed() {
    Assertions.assertThat(routeInboundPage.photoAuditDialog.successfulWaypoints.photos.size())
        .as("Number of displayed successful waypoint photos").isEqualTo(0);
  }

  @When("Operator verifies partial waypoints parameters in Photo Audit dialog:")
  public void operatorVerifyPartialWaypointParams(List<Map<String, String>> data) {
    operatorVerifyWaypointParams(routeInboundPage.photoAuditDialog.partialWaypoints, data);
  }

  public void operatorVerifyWaypointParams(WaypointsSection section,
      List<Map<String, String>> data) {
    List<Map<String, String>> actualParams = section.photos
        .stream()
        .map(photoContainer -> {
          Map<String, String> wpParams = new HashMap<>();
          wpParams.put("address", photoContainer.address.getNormalizedText());
          wpParams.put("photo",
              photoContainer.image.isDisplayedFast() ? photoContainer.image.getAttribute("src")
                  : null);
          wpParams.put("count",
              photoContainer.count.isDisplayedFast() ? photoContainer.count.getNormalizedText()
                  : null);
          return wpParams;
        }).collect(Collectors.toList());

    data.forEach(waypointParams -> {
          waypointParams = resolveKeyValues(waypointParams);
          String value = waypointParams.get("address");
          if (StringUtils.isBlank(value)) {
            throw new IllegalArgumentException("Waypoint address was not defined");
          }
          String finalValue = value;
          Map<String, String> actualWpParams = actualParams.stream()
              .filter(params -> StringUtils.equalsIgnoreCase(params.get("address"), finalValue))
              .findFirst().orElseThrow(
                  () -> new AssertionError(
                      "Waypoint with address [" + finalValue + "] was not found"));
          value = waypointParams.get("photo");
          if (StringUtils.isNotBlank(value)) {
            Assertions.assertThat(actualWpParams.get("photo")).as("Photo src").isEqualTo(value);
          }
          value = waypointParams.get("photoCount");
          if (StringUtils.isNotBlank(value)) {
            int count = Integer.parseInt(value);
            if (count > 0) {
              Assertions.assertThat(actualWpParams.get("photo")).as("Waypoint photo is displayed")
                  .isNotNull();
              Assertions.assertThat(Integer.parseInt(actualWpParams.get("count")))
                  .as("Waypoint photos count").isEqualTo(count);
            }
          }
        }
    );
  }

  @When("Operator add route inbound comment {string}  on Route Inbound page")
  public void operatorAddRouteInboundCommentOnRouteInboundPage(String comment) {
    routeInboundPage.addRoutInboundComment(comment);
    put(KEY_ROUTE_INBOUND_COMMENT, comment);
  }

  @When("Operator verify route inbound comment on Route Inbound page")
  public void operatorVerifyRouteInboundCommentOnRouteInboundPage() {
    String expectedComment = get(KEY_ROUTE_INBOUND_COMMENT);
    routeInboundPage.verifyRouteInboundComment(expectedComment);
  }

  @And("Operator scan a tracking ID of created order on Route Inbound page")
  public void operatorScanATrackingIDOfCreatedOrderOnRouteInboundPage() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    routeInboundPage.scanTrackingId(trackingId);
  }

  @And("Operator scan a tracking ID {value} on Route Inbound page")
  public void operatorScanATrackingIDOnRouteInboundPage(String trackingId) {
    routeInboundPage.scanTrackingId(trackingId);
  }

  @When("Operator click 'Go Back' button on Route Inbound page")
  public void operatorClickGoBackButtonOnRouteInboundPage() {
    routeInboundPage.goBack.click();
    pause1s();
  }

  @When("Operator open Completed Waypoints Info dialog on Route Inbound page")
  public void operatorOpenCompletedWaypointsInfoDialogOnRouteInboundPage() {
    routeInboundPage.openCompletedWaypointsDialog();
  }

  @When("Operator open Failed Waypoints Info dialog on Route Inbound page")
  public void operatorOpenFailedWaypointsInfoDialogOnRouteInboundPage() {
    routeInboundPage.openFailedWaypointsDialog();
  }

  @When("Operator open Failed Parcels dialog on Route Inbound page")
  public void operatorOpenFailedParcelsDialogOnRouteInboundPage() {
    routeInboundPage.openFailedParcelsDialog();
  }

  @When("Operator open C2C + Return dialog on Route Inbound page")
  public void operatorOpenC2CReturnDialogOnRouteInboundPage() {
    routeInboundPage.openC2CReturnDialog();
  }

  @When("Operator open Reservations dialog on Route Inbound page")
  public void operatorOpenReservationsDialogOnRouteInboundPage() {
    routeInboundPage.openReservationsDialog();
  }

  @When("Operator open Total Waypoints Info dialog on Route Inbound page")
  public void operatorOpenTotalWaypointsInfoDialogOnRouteInboundPage() {
    routeInboundPage.openTotalWaypointsDialog();
  }

  @When("Operator open Partial Waypoints Info dialog on Route Inbound page")
  public void operatorOpenPartialWaypointsInfoDialogOnRouteInboundPage() {
    routeInboundPage.openPartialWaypointsDialog();
  }

  @When("Operator open Pending Deliveries dialog on Route Inbound page")
  public void operatorOpenPendingDeliveriesInfoDialogOnRouteInboundPage() {
    routeInboundPage.openPendingDeliveriesDialog();
  }

  @When("Operator open Failed Deliveries Valid dialog on Route Inbound page")
  public void operatorOpenFailedDeliveriesValidDialogOnRouteInboundPage() {
    routeInboundPage.openFailedDeliveriesValidDialog();
  }

  @When("Operator open Failed Deliveries Invalid dialog on Route Inbound page")
  public void operatorOpenFailedDeliveriesInvalidDialogOnRouteInboundPage() {
    routeInboundPage.openFailedDeliveriesInvalidDialog();
  }

  @When("Operator open C2C Return Pickups dialog on Route Inbound page")
  public void operatorOpenC2CReturnPickupsDialogOnRouteInboundPage() {
    routeInboundPage.openC2CReturnPickupsDialog();
  }

  @When("Operator open Parcel Processed dialog on Route Inbound page")
  public void operatorOpenParcelProcessedDialogOnRouteInboundPage() {
    routeInboundPage.openParcelProcessedDialog();
  }

  @When("Operator open Pending C2C Return Pickups dialog on Route Inbound page")
  public void operatorOpenPendingC2CReturnPickupsDialogOnRouteInboundPage() {
    routeInboundPage.openPendingC2CReturnPickupsDialog();
  }

  @When("Operator open Reservation Pickups dialog on Route Inbound page")
  public void operatorOpenReservationPickupsDialogOnRouteInboundPage() {
    routeInboundPage.openReservationPickupsDialog();
  }

  @When("Operator close {} dialog on Route Inbound page")
  public void operatorCloseDialogOnRouteInboundPage(String status) {
    routeInboundPage.closeDialog();
  }

  @When("Operator open Money Collection dialog on Route Inbound page")
  public void operatorOpenMoneyCollectionDialogOnRouteInboundPage() {
    routeInboundPage.openMoneyCollectionDialog();
  }

  @Then("Operator verify 'Money to collect' value is {string} on Route Inbound page")
  public void operatorVerifyMoneyToCollectValueOnRouteInboundPage(String expectedValue) {
    String actualValue = routeInboundPage.getMoneyToCollectValue();
    if (StringUtils.isNumeric(expectedValue)) {
      expectedValue = f("%,d", Integer.parseInt(expectedValue));
    }
    Assertions.assertThat(actualValue).as("Money to collect value").isEqualTo(expectedValue);
  }

  @Then("Operator verify 'Expected Total' value is {string} on Money Collection dialog")
  public void operatorVerifyExpectedTotalValueOnMoneyCollectionDialog(String expectedValue) {
    String actualValue = routeInboundPage.moneyCollectionDialog().getExpectedTotal();
    Assertions.assertThat(actualValue).as("Expected Total value").isEqualTo(expectedValue);
  }

  @Then("Operator verify 'Outstanding amount' value is {string} on Money Collection dialog")
  public void operatorVerifyOutstandingAmountValueOnMoneyCollectionDialog(String expectedValue) {
    String actualValue = routeInboundPage.moneyCollectionDialog().getOutstandingAmount();
    Assertions.assertThat(actualValue).as("Outstanding Amount value").isEqualTo(expectedValue);
  }

  @Then("Operator submit following values on Money Collection dialog:")
  public void operatorSubmitValuesOnMoneyCollectionDialog(Map<String, String> mapOfData) {
    MoneyCollection moneyCollection = new MoneyCollection(mapOfData);
    routeInboundPage.moneyCollectionDialog().fillForm(moneyCollection).save();
  }

  @When("Operator open Money Collection history dialog on Route Inbound page")
  public void operatorOpenMoneyCollectionHistoryDialog() {
    routeInboundPage.cashButton.click();
    routeInboundPage.moneyCollectionHistoryDialog.waitUntilVisible();
  }

  @Then("Operator verify Money Collection history record using data below:")
  public void operatorVerifyMoneyCollectionHistoryRecord(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    MoneyCollectionHistoryEntry expectedRecord = new MoneyCollectionHistoryEntry(mapOfData);
    String preProcessing = expectedRecord.getProcessedAmount().replaceAll("S\\$", "");
    expectedRecord.setProcessedAmount(preProcessing);
    routeInboundPage.moneyCollectionHistoryDialog.historyTab.click();
    pause1s();
    MoneyCollectionHistoryEntry actualRecord = routeInboundPage.moneyCollectionHistoryDialog.historyTable
        .readEntity(1);
    expectedRecord.compareWithActual(actualRecord);
  }

  @Then("Operator verify Non-Inbounded Orders record using data below:")
  public void operatorVerifyNonInboundedOrdersRecord(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    WaypointOrderInfo expectedRecord = new WaypointOrderInfo(mapOfData);
    routeInboundPage.reservationPickupsDialog.nonInboundedOrdersTab.click();
    pause1s();
    WaypointOrderInfo actualRecord = routeInboundPage.reservationPickupsDialog.nonInboundedOrdersTable
        .readEntity(1);
    expectedRecord.compareWithActual(actualRecord);
  }

  @Then("Operator verify Inbounded Orders record using data below:")
  public void operatorVerifyInboundedOrdersRecord(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    WaypointOrderInfo expectedRecord = new WaypointOrderInfo(mapOfData);
    routeInboundPage.reservationPickupsDialog.inpoundedOrdersTab.click();
    pause1s();
    WaypointOrderInfo actualRecord = routeInboundPage.reservationPickupsDialog.inboundedOrdersTable
        .readEntity(1);
    expectedRecord.compareWithActual(actualRecord);
  }

  @Then("Operator verify Extra Orders record using data below:")
  public void operatorVerifyExtraOrdersRecord(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    WaypointOrderInfo expectedRecord = new WaypointOrderInfo(mapOfData);
    routeInboundPage.reservationPickupsDialog.extraOrdersTab.click();
    pause1s();
    WaypointOrderInfo actualRecord = routeInboundPage.reservationPickupsDialog.extraOrdersTable
        .readEntity(1);
    expectedRecord.compareWithActual(actualRecord);
  }

  @Then("Operator verify Money Collection Collected Order record using data below:")
  public void operatorVerifyMoneyCollectionCollectedOrderRecord(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    MoneyCollectionCollectedOrderEntry expectedRecord = new MoneyCollectionCollectedOrderEntry(
        mapOfData);
    routeInboundPage.moneyCollectionHistoryDialog.detailsTab.click();
    pause1s();
    MoneyCollectionCollectedOrderEntry actualRecord = routeInboundPage.moneyCollectionHistoryDialog.collectedOrdersTable
        .readEntity(1);
    expectedRecord.compareWithActual(actualRecord);
  }

  @Then("Operator verify Waypoint Scans record using data below:")
  public void operatorVerifyWaypointScansRecord(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    WaypointScanInfo expectedRecord = new WaypointScanInfo(mapOfData);
    WaypointScanInfo actualRecord = routeInboundPage.waypointScansTable.readEntity(1);
    expectedRecord.compareWithActual(actualRecord);
  }

  @Then("Operator removes route from driver app on Route Inbound page")
  public void operatorRemovesRouteFromDriverAppOnRouteInboundPage() {
    routeInboundPage.removeRouteFromDriverApp.check();
    routeInboundPage.waitUntilInvisibilityOfToast("Updated Successfully", true);
  }

  @Then("Operator ends Route Inbound session for route {string} on Route Inbound page")
  public void operatorEndsRouteInboundSessionOnRouteInboundPage(String routeId) {
    routeId = resolveValue(routeId);
    routeInboundPage.endSession.clickAndWaitUntilDone();
    routeInboundPage.waitUntilVisibilityOfToast("Inbound completed for route " + routeId);
  }

  @Then("Operator ends session incompletely for route {string} with reason as {string}")
  public void operator_ends_session_incompletely_for_route_with_reason_as(String routeId,
      String reason) {
    routeId = resolveValue(routeId);
    routeInboundPage.endSession.clickAndWaitUntilDone();
    routeInboundPage.reason.selectValue(reason);
    routeInboundPage.submit.click();
    routeInboundPage.waitUntilVisibilityOfToast("Inbound updated for route " + routeId);
  }
}
