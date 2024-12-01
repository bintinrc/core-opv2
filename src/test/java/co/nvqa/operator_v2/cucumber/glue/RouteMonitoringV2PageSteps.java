package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.PendingPriorityOrder;
import co.nvqa.operator_v2.model.RouteMonitoringFilters;
import co.nvqa.operator_v2.model.RouteMonitoringParams;
import co.nvqa.operator_v2.selenium.page.RouteMonitoringV2Page;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.When;
import java.util.Arrays;
import java.util.Date;
import java.util.Map;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.junit.Assert;

import static co.nvqa.operator_v2.selenium.page.RouteMonitoringV2Page.PendingPriorityModal.PendingPriorityTable.COLUMN_TRACKING_ID;
import static co.nvqa.operator_v2.selenium.page.RouteMonitoringV2Page.RouteMonitoringTable.COLUMN_INVALID_FAILED_WP;
import static co.nvqa.operator_v2.selenium.page.RouteMonitoringV2Page.RouteMonitoringTable.COLUMN_PENDING_PRIORITY_PARCELS;
import static co.nvqa.operator_v2.selenium.page.RouteMonitoringV2Page.RouteMonitoringTable.COLUMN_ROUTE_ID;

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
    if (routeMonitoringV2Page.spinner.waitUntilVisible(5)) {
      routeMonitoringV2Page.spinner.waitUntilInvisible();
    }
  }

  @When("Operator filter Route Monitoring V2 using data below and then load selection:")
  public void operatorFilterRouteMonitoringV2UsingDataBelowAndThenLoadSelection(
      Map<String, String> data) {
    routeMonitoringV2Page.inFrame(() -> applyFilters(data));
  }

  private void applyFilters(Map<String, String> data) {
    routeMonitoringV2Page.expandFilters();

    if (!routeMonitoringV2Page.loadSelection.waitUntilVisible(2)) {
      routeMonitoringV2Page.refreshPage();
      routeMonitoringV2Page.waitUntilLoaded();
    }

    RouteMonitoringFilters filters = new RouteMonitoringFilters(resolveKeyValues(data));
    if (ArrayUtils.isNotEmpty(filters.getHubs())) {
      routeMonitoringV2Page.hubsFilter.clearAll();
      routeMonitoringV2Page.hubsFilter.selectFilter(Arrays.asList(filters.getHubs()));
    }
    if (ArrayUtils.isNotEmpty(filters.getZones())) {
      routeMonitoringV2Page.zonesFilter.clearAll();
      routeMonitoringV2Page.zonesFilter.selectFilter(Arrays.asList(filters.getZones()));
    }
    routeMonitoringV2Page.loadSelection.click();
    pause1s();
    routeMonitoringV2Page.smallSpinner.waitUntilInvisible();
  }

  @When("Operator search order on Route Monitoring V2 using data below:")
  public void operatorSearchOrderOnRouteMonitoringV2Page(Map<String, String> data) {
    routeMonitoringV2Page.inFrame(page -> {
      page.waitUntilLoaded();
      applyFilters(data);

      int timeout = Integer.parseInt(data.getOrDefault("timeout", "180")) * 1000;

      RouteMonitoringParams expected = new RouteMonitoringParams(resolveKeyValues(data));
      Long routeId = expected.getRouteId();
      Assertions.assertThat(routeId).as("Route ID was not defined").isNotNull();
      page.routeMonitoringTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      page.smallSpinner.waitUntilInvisible();

      long start = new Date().getTime();
      while (page.routeMonitoringTable.isEmpty() && (new Date().getTime() - start
          <= timeout)) {
        page.expandFilters();
        page.loadSelection.click();
        pause1s();
        page.smallSpinner.waitUntilInvisible();
        page.routeMonitoringTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
        pause1s();
        page.smallSpinner.waitUntilInvisible();
      }

      if (page.routeMonitoringTable.isEmpty()) {
        Assert.fail(
            f("Order [%d] was not found on Route Monitoring V2 page in [%d] seconds", routeId,
                timeout / 1000));
      }
    });
  }

  @When("Operator verify parameters of a route on Route Monitoring V2 page using data below:")
  public void operatorVerifyRouteParameters(Map<String, String> data) {
    routeMonitoringV2Page.inFrame(page -> {
      RouteMonitoringParams expected = new RouteMonitoringParams(resolveKeyValues(data));
      Long routeId = expected.getRouteId();
      Assert.assertNotNull("Route ID was not defined", routeId);
      page.routeMonitoringTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      pause1s();
      Assert.assertFalse(f("Route [%d] was not found", routeId),
          page.routeMonitoringTable.isEmpty());
      RouteMonitoringParams actual = page.routeMonitoringTable.readEntity(1);
      expected.compareWithActual(actual);
    });
  }

  @When("Operator open Pending Priority modal of a route {string} on Route Monitoring V2 page")
  public void openPendingPriorityModal(String routeId) {
    routeMonitoringV2Page.inFrame(page -> {
      page.routeMonitoringTable
          .filterByColumn(COLUMN_ROUTE_ID, resolveValue(routeId));
      pause1s();
      page.routeMonitoringTable.clickColumn(1, COLUMN_PENDING_PRIORITY_PARCELS);
      page.pendingPriorityModal.waitUntilVisible();
      page.spinner.waitUntilInvisible();
    });
  }

  @When("Operator open Invalid Failed WP modal of a route {string} on Route Monitoring V2 page")
  public void openInvalidFailedWpModal(String routeId) {
    routeMonitoringV2Page.inFrame(page -> {
      page.routeMonitoringTable
          .filterByColumn(COLUMN_ROUTE_ID, resolveValue(routeId));
      pause1s();
      page.routeMonitoringTable.clickColumn(1, COLUMN_INVALID_FAILED_WP);
      page.invalidFailedWpModal.waitUntilLoaded();
    });
  }

  @When("Operator check there are {int} Pending Priority Pickups in Pending Priority modal on Route Monitoring V2 page")
  public void checkPendingPriorityPickupsNumber(Integer expectedCount) {
    routeMonitoringV2Page.inFrame(page -> {
      Assertions.assertThat(page.pendingPriorityModal.pendingPriorityPickupsTitle.getText().trim())
          .as("Pending Priority Pickups Title")
          .isEqualTo("Pending Priority Pickups (%d)", expectedCount);
      Assertions.assertThat(page.pendingPriorityModal.pendingPriorityPickupsTable.getRowsCount())
          .as("Pending Priority Pickups Table rows count").isEqualTo(expectedCount);
    });
  }

  @When("Operator check there are {int} Invalid Failed Pickups in Invalid Failed WP modal on Route Monitoring V2 page")
  public void checkInvalidFailedPickupsNumber(Integer expectedCount) {
    routeMonitoringV2Page.inFrame(page -> {
      Assertions.assertThat(page.invalidFailedWpModal.invalidFailedPickupsTitle.getText().trim())
          .as("Invalid Failed Pickups Title")
          .isEqualTo(f("Invalid Failed Pickups (%d)", expectedCount));
      Assertions.assertThat(page.invalidFailedWpModal.invalidFailedPickupsTable.getRowsCount())
          .as("Invalid Failed Pickups Table rows count").isEqualTo(expectedCount);
    });
  }

  @When("Operator check there are {int} Invalid Failed Reservations in Invalid Failed WP modal on Route Monitoring V2 page")
  public void checkInvalidFailedReservationsNumber(Integer expectedCount) {
    routeMonitoringV2Page.inFrame(page -> {
      Assertions.assertThat(
              page.invalidFailedWpModal.invalidFailedReservationsTitle.getText().trim())
          .as("Invalid Failed Reservations Title")
          .isEqualTo(f("Invalid Failed Reservations (%d)", expectedCount));
      Assertions.assertThat(page.invalidFailedWpModal.invalidFailedReservationsTable.getRowsCount())
          .as("Invalid Failed Reservations Table rows count").isEqualTo(expectedCount);
    });
  }

  @When("Operator check there are {int} Pending Priority Deliveries in Pending Priority modal on Route Monitoring V2 page")
  public void checkPendingPriorityDeliveriesNumber(Integer expectedCount) {
    routeMonitoringV2Page.inFrame(page -> {
      Assertions.assertThat(
              page.pendingPriorityModal.pendingPriorityDeliveriesTitle.getText().trim())
          .as("Pending Priority Deliveries Title")
          .isEqualTo(f("Pending Priority Deliveries (%d)", expectedCount));
      Assertions.assertThat(page.pendingPriorityModal.pendingPriorityDeliveriesTable.getRowsCount())
          .as("Pending Priority Deliveries Table rows count").isEqualTo(expectedCount);
    });
  }

  @When("Operator check there are {int} Invalid Failed Deliveries in Invalid Failed WP modal on Route Monitoring V2 page")
  public void checkInvalidFailedDeliveriesNumber(Integer expectedCount) {
    routeMonitoringV2Page.inFrame(page -> {
      Assertions.assertThat(page.invalidFailedWpModal.invalidFailedDeliveriesTitle.getText().trim())
          .as("Invalid Failed Deliveries Title")
          .isEqualTo(f("Invalid Failed Deliveries (%d)", expectedCount));
      Assertions.assertThat(page.invalidFailedWpModal.invalidFailedDeliveriesTable.getRowsCount())
          .as("Invalid Failed Deliveries Table rows count").isEqualTo(expectedCount);
    });
  }

  @When("Operator verify Pending Priority Pickup record in Pending Priority modal on Route Monitoring V2 page using data below:")
  public void verifyPendingPriorityPickupRecord(Map<String, String> data) {
    routeMonitoringV2Page.inFrame(page -> {
      PendingPriorityOrder expected = new PendingPriorityOrder(resolveKeyValues(data));
      page.pendingPriorityModal.pendingPriorityPickupsTable
          .filterByColumn(COLUMN_TRACKING_ID, expected.getTrackingId());
      Assertions.assertThat(page.pendingPriorityModal.pendingPriorityPickupsTable.getRowsCount())
          .as("Pending Priority Pickups Table rows count").isEqualTo(1);
      PendingPriorityOrder actual = page.pendingPriorityModal.pendingPriorityPickupsTable.readEntity(
          1);
      expected.compareWithActual(actual);
    });
  }

  @When("Operator verify Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:")
  public void verifyInvalidFailedPickupRecord(Map<String, String> data) {
    routeMonitoringV2Page.inFrame(page -> {
      PendingPriorityOrder expected = new PendingPriorityOrder(resolveKeyValues(data));
      page.invalidFailedWpModal.invalidFailedPickupsTable
          .filterByColumn(COLUMN_TRACKING_ID, expected.getTrackingId());
      Assertions.assertThat(page.invalidFailedWpModal.invalidFailedPickupsTable.getRowsCount())
          .as("Invalid Failed Pickups Table rows count").isEqualTo(1);
      PendingPriorityOrder actual = page.invalidFailedWpModal.invalidFailedPickupsTable.readEntity(
          1);
      if (StringUtils.equals(data.get("tags"), "-")) {
        expected.clearTags();
        Assertions.assertThat(actual.getTags()).as("List of tags").isNull();
      }
      expected.compareWithActual(actual);
    });
  }

  @When("Operator verify Pending Priority Delivery record in Pending Priority modal on Route Monitoring V2 page using data below:")
  public void verifyPendingPriorityDeliveryRecord(Map<String, String> data) {
    routeMonitoringV2Page.inFrame(page -> {
      PendingPriorityOrder expected = new PendingPriorityOrder(resolveKeyValues(data));
      page.pendingPriorityModal.pendingPriorityDeliveriesTable
          .filterByColumn(COLUMN_TRACKING_ID, expected.getTrackingId());
      Assertions.assertThat(page.pendingPriorityModal.pendingPriorityDeliveriesTable.getRowsCount())
          .as("Pending Priority Deliveries Table rows count").isEqualTo(1);
      PendingPriorityOrder actual = page.pendingPriorityModal.pendingPriorityDeliveriesTable.readEntity(
          1);
      expected.compareWithActual(actual);
    });
  }

  @When("Operator verify Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:")
  public void verifyInvalidFailedDeliveryRecord(Map<String, String> data) {
    routeMonitoringV2Page.inFrame(page -> {
      PendingPriorityOrder expected = new PendingPriorityOrder(resolveKeyValues(data));
      page.invalidFailedWpModal.invalidFailedDeliveriesTable
          .filterByColumn(COLUMN_TRACKING_ID, expected.getTrackingId());
      Assertions.assertThat(page.invalidFailedWpModal.invalidFailedDeliveriesTable.getRowsCount())
          .as("Invalid Failed Deliveries Table rows count").isEqualTo(1);
      PendingPriorityOrder actual = page.invalidFailedWpModal.invalidFailedDeliveriesTable
          .readEntity(1);
      if (StringUtils.equals(data.get("tags"), "-")) {
        expected.clearTags();
        Assertions.assertThat(actual.getTags()).as("List of tags").isNull();
      }
      expected.compareWithActual(actual);
    });
  }

  @When("Operator click on tracking id of a Pending Priority Pickup record in Pending Priority modal on Route Monitoring V2 page using data below:")
  public void clickPendingPriorityPickupTrackingId(Map<String, String> dataMap) {
    routeMonitoringV2Page.inFrame(page -> {
      Map<String, String> data = resolveKeyValues(dataMap);
      String mainWindowHandle = page.getWebDriver().getWindowHandle();
      put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
      page.pendingPriorityModal.pendingPriorityPickupsTable.filterByColumn(COLUMN_TRACKING_ID,
          data.get("trackingId"));
      page.pendingPriorityModal.pendingPriorityPickupsTable.clickColumn(1, COLUMN_TRACKING_ID);
      pause3s();
      String orderId = data.get("orderId");
      retryIfRuntimeExceptionOccurred(
          () -> page.switchToOtherWindow(data.get("orderId")), "switch to order page " + orderId,
          2000, 5);
    });
  }

  @When("Operator click on tracking id of a Invalid Failed Pickup record in Invalid Failed WP modal on Route Monitoring V2 page using data below:")
  public void clickInvalidFailedPickupTrackingId(Map<String, String> dataMap) {
    routeMonitoringV2Page.inFrame(page -> {
      Map<String, String> data = resolveKeyValues(dataMap);
      String mainWindowHandle = page.getWebDriver().getWindowHandle();
      put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
      page.invalidFailedWpModal.invalidFailedPickupsTable.filterByColumn(COLUMN_TRACKING_ID,
          data.get("trackingId"));
      page.invalidFailedWpModal.invalidFailedPickupsTable.clickColumn(1, COLUMN_TRACKING_ID);
      pause3s();
      String orderId = data.get("orderId");
      retryIfRuntimeExceptionOccurred(
          () -> page.switchToOtherWindow(data.get("orderId")), "switch to order page " + orderId,
          2000, 5);
    });
  }

  @When("Operator click on tracking id of a Pending Priority Delivery record in Pending Priority modal on Route Monitoring V2 page using data below:")
  public void clickPendingPriorityDeliveryTrackingId(Map<String, String> dataMap) {
    routeMonitoringV2Page.inFrame(page -> {
      Map<String, String> data = resolveKeyValues(dataMap);
      String mainWindowHandle = page.getWebDriver().getWindowHandle();
      put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
      page.pendingPriorityModal.pendingPriorityDeliveriesTable.filterByColumn(COLUMN_TRACKING_ID,
          data.get("trackingId"));
      page.pendingPriorityModal.pendingPriorityDeliveriesTable.clickColumn(1, COLUMN_TRACKING_ID);
      pause3s();
      String orderId = data.get("orderId");
      retryIfRuntimeExceptionOccurred(
          () -> page.switchToOtherWindow(data.get("orderId")), "switch to order page " + orderId,
          2000, 5);
    });
  }

  @When("Operator click on tracking id of a Invalid Failed Delivery record in Invalid Failed WP modal on Route Monitoring V2 page using data below:")
  public void clickInvalidFailedDeliveryTrackingId(Map<String, String> dataMap) {
    routeMonitoringV2Page.inFrame(page -> {
      Map<String, String> data = resolveKeyValues(dataMap);
      String mainWindowHandle = page.getWebDriver().getWindowHandle();
      put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
      page.invalidFailedWpModal.invalidFailedDeliveriesTable.filterByColumn(COLUMN_TRACKING_ID,
          data.get("trackingId"));
      page.invalidFailedWpModal.invalidFailedDeliveriesTable.clickColumn(1, COLUMN_TRACKING_ID);
      pause3s();
      String orderId = data.get("orderId");
      retryIfRuntimeExceptionOccurred(
          () -> page.switchToOtherWindow(data.get("orderId")), "switch to order page " + orderId,
          2000, 5);
    });
  }

  @When("Operator close current window and switch to Route Monitoring V2 page")
  public void operatorCloseCurrentWindow() {
    if (routeMonitoringV2Page.getWebDriver().getWindowHandles().size() > 1) {
      routeMonitoringV2Page.getWebDriver().close();
      String mainWindowHandle = get(KEY_MAIN_WINDOW_HANDLE);
      routeMonitoringV2Page.getWebDriver().switchTo().window(mainWindowHandle);
    }
  }
}
