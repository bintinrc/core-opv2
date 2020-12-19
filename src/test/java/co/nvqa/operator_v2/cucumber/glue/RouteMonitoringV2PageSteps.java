package co.nvqa.operator_v2.cucumber.glue;

import static co.nvqa.operator_v2.selenium.page.RouteMonitoringV2Page.PendingPriorityModal.PendingPriorityTable.COLUMN_TRACKING_ID;
import static co.nvqa.operator_v2.selenium.page.RouteMonitoringV2Page.RouteMonitoringTable.COLUMN_INVALID_FAILED_WP;
import static co.nvqa.operator_v2.selenium.page.RouteMonitoringV2Page.RouteMonitoringTable.COLUMN_PENDING_PRIORITY_PARCELS;
import static co.nvqa.operator_v2.selenium.page.RouteMonitoringV2Page.RouteMonitoringTable.COLUMN_ROUTE_ID;

import co.nvqa.operator_v2.model.PendingPriorityOrder;
import co.nvqa.operator_v2.model.RouteMonitoringFilters;
import co.nvqa.operator_v2.model.RouteMonitoringParams;
import co.nvqa.operator_v2.selenium.page.RouteMonitoringV2Page;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.Date;
import java.util.Map;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.junit.Assert;
import org.junit.jupiter.api.Assertions;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class RouteMonitoringV2PageSteps extends AbstractSteps {

  private RouteMonitoringV2Page routeMonitoringV2Page;

  public RouteMonitoringV2PageSteps() {
  }

  @Override
  public void init() {
    routeMonitoringV2Page = new RouteMonitoringV2Page(getWebDriver());
  }

  @When("Route Monitoring V2 page is loaded")
  public void movementManagementPageIsLoaded() {
    routeMonitoringV2Page.switchTo();
    routeMonitoringV2Page.spinner.waitUntilInvisible();
  }

  @When("^Operator filter Route Monitoring V2 using data below and then load selection:$")
  public void operatorFilterRouteMonitoringV2UsingDataBelowAndThenLoadSelection(
      Map<String, String> data) {
    if (routeMonitoringV2Page.openFilters.isDisplayedFast()) {
      routeMonitoringV2Page.openFilters.click();
    }

    data = resolveKeyValues(data);
    RouteMonitoringFilters filters = new RouteMonitoringFilters(data);
    if (ArrayUtils.isNotEmpty(filters.getHubs())) {
      routeMonitoringV2Page.hubsFilter.clearAll();
      for (String hub : filters.getHubs()) {
        routeMonitoringV2Page.hubsFilter.selectFilter(hub);
      }
    }
    if (ArrayUtils.isNotEmpty(filters.getZones())) {
      routeMonitoringV2Page.zonesFilter.clearAll();
      for (String zone : filters.getZones()) {
        routeMonitoringV2Page.zonesFilter.selectFilter(zone);
      }
    }
    routeMonitoringV2Page.loadSelection.click();
    pause1s();
    routeMonitoringV2Page.smallSpinner.waitUntilInvisible();
  }

  @When("^Operator search order on Route Monitoring V2 using data below:$")
  public void operatorSearchOrderOnRouteMonitoringV2Page(Map<String, String> data) {
    data = resolveKeyValues(data);
    operatorFilterRouteMonitoringV2UsingDataBelowAndThenLoadSelection(data);

    int timeout = Integer.parseInt(data.getOrDefault("timeout", "180")) * 1000;

    RouteMonitoringParams expected = new RouteMonitoringParams(data);
    Long routeId = expected.getRouteId();
    Assertions.assertNotNull(routeId, "Route ID was not defined");
    routeMonitoringV2Page.routeMonitoringTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
    routeMonitoringV2Page.smallSpinner.waitUntilInvisible();

    long start = new Date().getTime();
    while (routeMonitoringV2Page.routeMonitoringTable.isEmpty() && (new Date().getTime() - start
        <= timeout)) {
      routeMonitoringV2Page.openFilters.click();
      routeMonitoringV2Page.loadSelection.click();
      pause1s();
      routeMonitoringV2Page.smallSpinner.waitUntilInvisible();
      routeMonitoringV2Page.routeMonitoringTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      pause1s();
      routeMonitoringV2Page.smallSpinner.waitUntilInvisible();
    }

    if (routeMonitoringV2Page.routeMonitoringTable.isEmpty()) {
      Assert.fail(f("Order [%d] was not found on Route Monitoring V2 page in [%d] seconds", routeId,
          timeout / 1000));
    }
  }

  @When("^Operator verify parameters of a route on Route Monitoring V2 page using data below:$")
  public void operatorVerifyRouteParameters(Map<String, String> data) {
    data = resolveKeyValues(data);
    RouteMonitoringParams expected = new RouteMonitoringParams(data);
    Long routeId = expected.getRouteId();
    Assert.assertNotNull("Route ID was not defined", routeId);
    routeMonitoringV2Page.routeMonitoringTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
    pause1s();
    Assert.assertFalse(f("Route [%d] was not found", routeId),
        routeMonitoringV2Page.routeMonitoringTable.isEmpty());
    RouteMonitoringParams actual = routeMonitoringV2Page.routeMonitoringTable.readEntity(1);
    expected.compareWithActual(actual);
  }

  @When("^Operator open Pending Priority modal of a route \"(.+)\" on Route Monitoring V2 page$")
  public void openPendingPriorityModal(String routeId) {
    routeMonitoringV2Page.routeMonitoringTable
        .filterByColumn(COLUMN_ROUTE_ID, resolveValue(routeId));
    pause1s();
    routeMonitoringV2Page.routeMonitoringTable.clickColumn(1, COLUMN_PENDING_PRIORITY_PARCELS);
    routeMonitoringV2Page.pendingPriorityModal.waitUntilVisible();
    routeMonitoringV2Page.spinner.waitUntilInvisible();
  }

  @When("^Operator open Invalid Failed WP modal of a route \"(.+)\" on Route Monitoring V2 page$")
  public void openInvalidFailedWpModal(String routeId) {
    routeMonitoringV2Page.routeMonitoringTable
        .filterByColumn(COLUMN_ROUTE_ID, resolveValue(routeId));
    pause1s();
    routeMonitoringV2Page.routeMonitoringTable.clickColumn(1, COLUMN_INVALID_FAILED_WP);
    routeMonitoringV2Page.invalidFailedWpModal.waitUntilVisible();
    routeMonitoringV2Page.spinner.waitUntilInvisible();
  }

  @When("^Operator check there are (\\d+) Pending Priority Pickups in Pending Priority modal on Route Monitoring V2 page$")
  public void checkPendingPriorityPickupsNumber(Integer expectedCount) {
    Assertions.assertEquals(f("Pending Priority Pickups (%d)", expectedCount),
        routeMonitoringV2Page.pendingPriorityModal.pendingPriorityPickupsTitle.getText().trim(),
        "Pending Priority Pickups Title");
    Assertions.assertEquals(expectedCount,
        routeMonitoringV2Page.pendingPriorityModal.pendingPriorityPickupsTable.getRowsCount(),
        "Pending Priority Pickups Table rows count");
  }

  @When("^Operator check there are (\\d+) Invalid Failed Pickups in Invalid Failed WP modal on Route Monitoring V2 page$")
  public void checkInvalidFailedPickupsNumber(Integer expectedCount) {
    Assertions.assertEquals(f("Invalid Failed Pickups (%d)", expectedCount),
        routeMonitoringV2Page.invalidFailedWpModal.invalidFailedPickupsTitle.getText().trim(),
        "Invalid Failed Pickups Title");
    Assertions.assertEquals(expectedCount,
        routeMonitoringV2Page.invalidFailedWpModal.invalidFailedPickupsTable.getRowsCount(),
        "Invalid Failed Pickups Table rows count");
  }

  @When("^Operator check there are (\\d+) Invalid Failed Reservations in Invalid Failed WP modal on Route Monitoring V2 page$")
  public void checkInvalidFailedReservationsNumber(Integer expectedCount) {
    Assertions.assertEquals(f("Invalid Failed Reservations (%d)", expectedCount),
        routeMonitoringV2Page.invalidFailedWpModal.invalidFailedReservationsTitle.getText().trim(),
        "Invalid Failed Reservations Title");
    Assertions.assertEquals(expectedCount,
        routeMonitoringV2Page.invalidFailedWpModal.invalidFailedReservationsTable.getRowsCount(),
        "Invalid Failed Reservations Table rows count");
  }

  @When("^Operator check there are (\\d+) Pending Priority Deliveries in Pending Priority modal on Route Monitoring V2 page$")
  public void checkPendingPriorityDeliveriesNumber(Integer expectedCount) {
    Assertions.assertEquals(f("Pending Priority Deliveries (%d)", expectedCount),
        routeMonitoringV2Page.pendingPriorityModal.pendingPriorityDeliveriesTitle.getText().trim(),
        "Pending Priority Deliveries Title");
    Assertions.assertEquals(expectedCount,
        routeMonitoringV2Page.pendingPriorityModal.pendingPriorityDeliveriesTable.getRowsCount(),
        "Pending Priority Deliveries Table rows count");
  }

  @When("^Operator check there are (\\d+) Invalid Failed Deliveries in Invalid Failed WP modal on Route Monitoring V2 page$")
  public void checkInvalidFailedDeliveriesNumber(Integer expectedCount) {
    Assertions.assertEquals(f("Invalid Failed Deliveries (%d)", expectedCount),
        routeMonitoringV2Page.invalidFailedWpModal.invalidFailedDeliveriesTitle.getText().trim(),
        "Invalid Failed Deliveries Title");
    Assertions.assertEquals(expectedCount,
        routeMonitoringV2Page.invalidFailedWpModal.invalidFailedDeliveriesTable.getRowsCount(),
        "Invalid Failed Deliveries Table rows count");
  }

  @When("^Operator verify Pending Priority Pickup record in Pending Priority modal on Route Monitoring V2 page using data below:$")
  public void verifyPendingPriorityPickupRecord(Map<String, String> data) {
    PendingPriorityOrder expected = new PendingPriorityOrder(resolveKeyValues(data));
    routeMonitoringV2Page.pendingPriorityModal.pendingPriorityPickupsTable
        .filterByColumn(COLUMN_TRACKING_ID, expected.getTrackingId());
    Assertions.assertEquals(1,
        routeMonitoringV2Page.pendingPriorityModal.pendingPriorityPickupsTable.getRowsCount(),
        "Pending Priority Pickups Table rows count");
    PendingPriorityOrder actual = routeMonitoringV2Page.pendingPriorityModal.pendingPriorityPickupsTable
        .readEntity(1);
    expected.compareWithActual(actual);
  }

  @When("^Operator verify Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:$")
  public void verifyInvalidFailedPickupRecord(Map<String, String> data) {
    PendingPriorityOrder expected = new PendingPriorityOrder(resolveKeyValues(data));
    routeMonitoringV2Page.invalidFailedWpModal.invalidFailedPickupsTable
        .filterByColumn(COLUMN_TRACKING_ID, expected.getTrackingId());
    Assertions.assertEquals(1,
        routeMonitoringV2Page.invalidFailedWpModal.invalidFailedPickupsTable.getRowsCount(),
        "Invalid Failed Pickups Table rows count");
    PendingPriorityOrder actual = routeMonitoringV2Page.invalidFailedWpModal.invalidFailedPickupsTable
        .readEntity(1);
    if (StringUtils.equals(data.get("tags"), "-")) {
      expected.clearTags();
      assertNull("List of tags", actual.getTags());
    }
    expected.compareWithActual(actual);
  }

  @When("^Operator verify Pending Priority Delivery record in Pending Priority modal on Route Monitoring V2 page using data below:$")
  public void verifyPendingPriorityDeliveryRecord(Map<String, String> data) {
    PendingPriorityOrder expected = new PendingPriorityOrder(resolveKeyValues(data));
    routeMonitoringV2Page.pendingPriorityModal.pendingPriorityDeliveriesTable
        .filterByColumn(COLUMN_TRACKING_ID, expected.getTrackingId());
    Assertions.assertEquals(1,
        routeMonitoringV2Page.pendingPriorityModal.pendingPriorityDeliveriesTable.getRowsCount(),
        "Pending Priority Deliveries Table rows count");
    PendingPriorityOrder actual = routeMonitoringV2Page.pendingPriorityModal.pendingPriorityDeliveriesTable
        .readEntity(1);
    expected.compareWithActual(actual);
  }

  @When("^Operator verify Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:$")
  public void verifyInvalidFailedDeliveryRecord(Map<String, String> data) {
    PendingPriorityOrder expected = new PendingPriorityOrder(resolveKeyValues(data));
    routeMonitoringV2Page.invalidFailedWpModal.invalidFailedDeliveriesTable
        .filterByColumn(COLUMN_TRACKING_ID, expected.getTrackingId());
    Assertions.assertEquals(1,
        routeMonitoringV2Page.invalidFailedWpModal.invalidFailedDeliveriesTable.getRowsCount(),
        "Invalid Failed Deliveries Table rows count");
    PendingPriorityOrder actual = routeMonitoringV2Page.invalidFailedWpModal.invalidFailedDeliveriesTable
        .readEntity(1);
    if (StringUtils.equals(data.get("tags"), "-")) {
      expected.clearTags();
      assertNull("List of tags", actual.getTags());
    }
    expected.compareWithActual(actual);
  }

  @When("^Operator click on tracking id of a Pending Priority Pickup record in Pending Priority modal on Route Monitoring V2 page using data below:$")
  public void clickPendingPriorityPickupTrackingId(Map<String, String> dataMap) {
    Map<String, String> data = resolveKeyValues(dataMap);
    String mainWindowHandle = routeMonitoringV2Page.getWebDriver().getWindowHandle();
    put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
    routeMonitoringV2Page.pendingPriorityModal.pendingPriorityPickupsTable
        .filterByColumn(COLUMN_TRACKING_ID, data.get("trackingId"));
    routeMonitoringV2Page.pendingPriorityModal.pendingPriorityPickupsTable
        .clickColumn(1, COLUMN_TRACKING_ID);
    pause3s();
    routeMonitoringV2Page.switchToOtherWindow(data.get("orderId"));
  }

  @When("^Operator click on tracking id of a Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:$")
  public void clickInvalidFailedPickupTrackingId(Map<String, String> dataMap) {
    Map<String, String> data = resolveKeyValues(dataMap);
    String mainWindowHandle = routeMonitoringV2Page.getWebDriver().getWindowHandle();
    put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
    routeMonitoringV2Page.invalidFailedWpModal.invalidFailedPickupsTable
        .filterByColumn(COLUMN_TRACKING_ID, data.get("trackingId"));
    routeMonitoringV2Page.invalidFailedWpModal.invalidFailedPickupsTable
        .clickColumn(1, COLUMN_TRACKING_ID);
    pause3s();
    routeMonitoringV2Page.switchToOtherWindow(data.get("orderId"));
  }

  @When("^Operator click on tracking id of a Pending Priority Delivery record in Pending Priority modal on Route Monitoring V2 page using data below:$")
  public void clickPendingPriorityDeliveryTrackingId(Map<String, String> dataMap) {
    Map<String, String> data = resolveKeyValues(dataMap);
    String mainWindowHandle = routeMonitoringV2Page.getWebDriver().getWindowHandle();
    put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
    routeMonitoringV2Page.pendingPriorityModal.pendingPriorityDeliveriesTable
        .filterByColumn(COLUMN_TRACKING_ID, data.get("trackingId"));
    routeMonitoringV2Page.pendingPriorityModal.pendingPriorityDeliveriesTable
        .clickColumn(1, COLUMN_TRACKING_ID);
    pause3s();
    routeMonitoringV2Page.switchToOtherWindow(data.get("orderId"));
  }

  @When("^Operator click on tracking id of a Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:$")
  public void clickInvalidFailedDeliveryTrackingId(Map<String, String> dataMap) {
    Map<String, String> data = resolveKeyValues(dataMap);
    String mainWindowHandle = routeMonitoringV2Page.getWebDriver().getWindowHandle();
    put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
    routeMonitoringV2Page.invalidFailedWpModal.invalidFailedDeliveriesTable
        .filterByColumn(COLUMN_TRACKING_ID, data.get("trackingId"));
    routeMonitoringV2Page.invalidFailedWpModal.invalidFailedDeliveriesTable
        .clickColumn(1, COLUMN_TRACKING_ID);
    pause3s();
    routeMonitoringV2Page.switchToOtherWindow(data.get("orderId"));
  }

  @When("^Operator close current window and switch to Route Monitoring V2 page$")
  public void operatorCloseCurrentWindow() {
    if (routeMonitoringV2Page.getWebDriver().getWindowHandles().size() > 1) {
      routeMonitoringV2Page.getWebDriver().close();
      String mainWindowHandle = get(KEY_MAIN_WINDOW_HANDLE);
      routeMonitoringV2Page.getWebDriver().switchTo().window(mainWindowHandle);
      routeMonitoringV2Page.switchTo();
    }
  }
}
