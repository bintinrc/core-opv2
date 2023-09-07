package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.NvWait;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.OutboundBreakroutePage.OrderInfo;
import co.nvqa.operator_v2.selenium.page.OutboundBreakrouteV2Page;
import co.nvqa.operator_v2.selenium.page.OutboundMonitoringPage;
import co.nvqa.operator_v2.selenium.page.OutboundMonitoringPage.RouteInfo;
import com.google.common.collect.ImmutableMap;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;

import static co.nvqa.operator_v2.selenium.page.OutboundMonitoringPage.RoutesTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.OutboundMonitoringPage.RoutesTable.ACTION_FLAG;
import static co.nvqa.operator_v2.selenium.page.OutboundMonitoringPage.RoutesTable.COLUMN_OUTBOUND_STATUS;
import static co.nvqa.operator_v2.selenium.page.OutboundMonitoringPage.RoutesTable.COLUMN_ROUTE_ID;

/**
 * @author Tristania Siagian
 */
@ScenarioScoped
public class OutboundMonitoringSteps extends AbstractSteps {

  private OutboundMonitoringPage outboundMonitoringPage;

  public OutboundMonitoringSteps() {
  }

  @Override
  public void init() {
    outboundMonitoringPage = new OutboundMonitoringPage(getWebDriver());
  }

  @When("Operator click on 'Load Selection' Button on Outbound Monitoring Page")
  public void clickLoadSelection() {
    outboundMonitoringPage.loadSelection.clickAndWaitUntilDone();
    if (outboundMonitoringPage.loadSelection.isDisplayedFast()) {
      outboundMonitoringPage.loadSelection.clickAndWaitUntilDone();
    }
  }

  @When("Operator verifies Date is {string} on Outbound Monitoring Page")
  public void verifyDate(String expected) {
    Assertions.assertThat(outboundMonitoringPage.dateFilter.fromDate.getValue())
        .as("Date")
        .isEqualTo(expected);
  }

  @And("Operator search on Route ID Header Table on Outbound Monitoring Page:")
  public void searchRouteId(Map<String, String> dataTableRaw) {
    final Map<String, String> dataTable = resolveKeyValues(dataTableRaw);
    long routeId = Long.parseLong(dataTable.get("routeId"));
    outboundMonitoringPage.searchTableByRouteId(routeId);
  }

  @Then("Operator verify the route ID is exist on Outbound Monitoring Page:")
  public void verifyRouteIdExists(Map<String, String> dataTableRaw) {
    final Map<String, String> dataTable = resolveKeyValues(dataTableRaw);
    long routeId = Long.parseLong(dataTable.get("routeId"));
    outboundMonitoringPage.searchTableByRouteId(routeId);
    outboundMonitoringPage.verifyRouteIdExists(String.valueOf(routeId));
  }

  @Then("Operator clicks Edit button for {value} route on Outbound Monitoring Page")
  public void clickButtonInRoutesTable(String routeId) {
    String mainWindowHandle = getWebDriver().getWindowHandle();
    put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
    outboundMonitoringPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
    Assertions.assertThat(outboundMonitoringPage.routesTable.isEmpty())
        .as("Routes table is empty")
        .isFalse();
    outboundMonitoringPage.routesTable.clickActionButton(1, ACTION_EDIT);
    retryIfRuntimeExceptionOccurred(
        () -> outboundMonitoringPage.switchToOutboundBreakrouteWindow(Long.parseLong(routeId)), 5);
  }

  @Then("Operator clicks Pull Out button for routes on Outbound Monitoring Page:")
  public void clickPullOutForRoutes(List<String> routeIds) {
    String mainWindowHandle = getWebDriver().getWindowHandle();
    put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
    routeIds = resolveValues(routeIds);
    routeIds.forEach(routeId -> {
      outboundMonitoringPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      Assertions.assertThat(outboundMonitoringPage.routesTable.isEmpty())
          .as("Routes table is empty")
          .isFalse();
      outboundMonitoringPage.routesTable.selectRow(1);
    });
    outboundMonitoringPage.pullOut.click();
    outboundMonitoringPage.switchToOtherWindowUrlContains("outbound-breakroute-v2");
    outboundMonitoringPage.outboundBreakrouteV2Page.switchTo();
    outboundMonitoringPage.outboundBreakrouteV2Page.waitUntilLoaded();
    if (outboundMonitoringPage.outboundBreakrouteV2Page.processModal.waitUntilVisible(3)) {
      outboundMonitoringPage.outboundBreakrouteV2Page.processModal.waitUntilInvisible();
    }
    pause1s();
  }

  @Then("Operator verifies {int} total selected Route IDs shown on Outbound Breakroute V2 page")
  public void clickPullOutForRoutes(int count) {
    outboundMonitoringPage.outboundBreakrouteV2Page.inFrame(page -> {
      Assertions.assertThat(page.routesCount.getText())
          .as("total selected Route ID(s) label")
          .isEqualTo(count + " selected Route ID(s)");
    });
  }

  @Then("Operator verifies {value} date shown on Outbound Breakroute V2 page")
  public void checkDateOnOutboundBreakrouteV2Page(String date) {
    outboundMonitoringPage.outboundBreakrouteV2Page.inFrame(page -> {
      Assertions.assertThat(page.date.getText())
          .as("Date label")
          .isEqualTo("Date: " + resolveValue(date));
    });
  }

  @Then("Operator verifies orders info on Outbound Breakroute V2 page:")
  public void checkDateOnOutboundBreakrouteV2Page(List<Map<String, String>> data) {
    outboundMonitoringPage.outboundBreakrouteV2Page.inFrame(page -> {
      data.forEach(item -> {
        OutboundBreakrouteV2Page.OrderInfo expected = new OutboundBreakrouteV2Page.OrderInfo(
            resolveKeyValues(item));
        outboundMonitoringPage.outboundBreakrouteV2Page.ordersInRouteTable
            .filterByColumn("trackingId", expected.getTrackingId());
        Assertions.assertThat(
                outboundMonitoringPage.outboundBreakrouteV2Page.ordersInRouteTable.isEmpty())
            .as("Orders table is empty")
            .isFalse();
        OutboundBreakrouteV2Page.OrderInfo actual = outboundMonitoringPage.outboundBreakrouteV2Page
            .ordersInRouteTable.readEntity(1);
        expected.compareWithActual(actual);
      });
    });
  }

  @Then("Operator verifies orders table is empty on Outbound Breakroute V2 page")
  public void checkOrdersTableIsEmpty() {
    outboundMonitoringPage.outboundBreakrouteV2Page.inFrame(page -> {
      Assertions.assertThat(
              outboundMonitoringPage.outboundBreakrouteV2Page.ordersInRouteTable.isEmpty())
          .as("Orders table is empty")
          .isTrue();
    });
  }

  @Then("Operator verifies filter results on Outbound Breakroute V2 page:")
  public void checkFilterResults(List<Map<String, String>> data) {
    outboundMonitoringPage.outboundBreakrouteV2Page.inFrame(page -> {
      Assertions.assertThat(
              outboundMonitoringPage.outboundBreakrouteV2Page.ordersInRouteTable.getRowsCount())
          .as("Orders table rows count")
          .isEqualTo(data.size());
      List<OutboundBreakrouteV2Page.OrderInfo> actual =
          outboundMonitoringPage.outboundBreakrouteV2Page.ordersInRouteTable.readAllEntities();

      data.forEach(item -> {
        OutboundBreakrouteV2Page.OrderInfo expected = new OutboundBreakrouteV2Page.OrderInfo(
            resolveKeyValues(item));
        actual.stream()
            .filter(o -> {
              try {
                expected.compareWithActual(o);
                return true;
              } catch (AssertionError e) {
                return false;
              }
            })
            .findFirst()
            .orElseThrow(() -> new AssertionError("Order " + expected + " was not found"));
      });
    });
  }

  @Then("Operator filter orders table on Outbound Breakroute V2 page:")
  public void checkFilterResults(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    outboundMonitoringPage.outboundBreakrouteV2Page.inFrame(page -> {
      finalData.forEach((key, value) -> {
        outboundMonitoringPage.outboundBreakrouteV2Page.ordersInRouteTable
            .filterByColumn(key, value);
      });
    });
  }

  @Then("Operator clear filters of orders table on Outbound Breakroute V2 page")
  public void clearTableFilters() {
    outboundMonitoringPage.outboundBreakrouteV2Page.inFrame(page -> {
      outboundMonitoringPage.outboundBreakrouteV2Page.ordersInRouteTable.clearColumnFilters();
    });
  }

  @Then("Operator verify the In Progress Outbound Status on Outbound Monitoring Page")
  public void verifyStatusInProgress() {
    outboundMonitoringPage.verifyStatusInProgress();
  }

  @Then("Operator verify the Complete Outbound Status on Outbound Monitoring Page")
  public void verifyStatusComplete() {
    outboundMonitoringPage.verifyStatusComplete();
  }

  @And("Operator click on flag icon on chosen route ID on Outbound Monitoring Page")
  public void clickFlagButton() {
    outboundMonitoringPage.routesTable.clickActionButton(1, ACTION_FLAG);
    pause10s();
  }

  @And("Operator verifies route record on Outbound Monitoring page:")
  public void clickFlagButton(Map<String, String> map) {
    RouteInfo expected = new RouteInfo(resolveKeyValues(map));
    List<RouteInfo> actual = outboundMonitoringPage.routesTable.readAllEntities();
    actual.stream()
        .filter(expected::matchedTo)
        .findFirst()
        .orElseThrow(() -> new AssertionError("Route record was not found: " + expected));
  }

  @And("Operator verifies route record has {value} background color")
  public void verifyColor(String color) {
    PageElement cell = outboundMonitoringPage.routesTable.getCell(COLUMN_OUTBOUND_STATUS, 1);
    String expected = "row-" + color.toLowerCase(Locale.ROOT);
    Assertions.assertThat(cell.getAttribute("class"))
        .as("cell class")
        .contains(expected);
  }

  @Then("Operator verifies the Outbound status on the chosen route ID is changed")
  public void verifyStatusMarked() {
    retryIfAssertionErrorOccurred(outboundMonitoringPage::verifyStatusMarked,
        "Verify Status is Marked");
  }


  @And("Operator click on comment icon on chosen route ID on Outbound Monitoring Page")
  public void clickCommentButtonAndSubmit() {
    outboundMonitoringPage.clickCommentButtonAndSubmit();
  }

  @Then("Operator verifies the comment table on the chosen route ID is changed")
  public void verifyCommentIsRight() {
    outboundMonitoringPage.verifyCommentIsRight();
  }

  @When("Operator select filter and click Load Selection on Outbound Monitoring page using data below:")
  public void selectFiltersAndClickLoadSelection(Map<String, String> data) {
    data = resolveKeyValues(data);
    if (data.containsKey("zoneName")) {
      outboundMonitoringPage.zonesSelect.selectFilter(splitAndNormalize(data.get("zoneName")));
    }
    if (data.containsKey("hubName")) {
      outboundMonitoringPage.hubsSelect.selectFilter(splitAndNormalize(data.get("hubName")));
    }
    clickLoadSelection();
  }

  @When("Operator pull out order {value} from route on Outbound Breakroute page")
  public void pullOutOrderFromRoute(String trackingId) {
    int rowsCount = outboundMonitoringPage.outboundBreakroutePage.parcelsNotInOutboundScansTable.getRowsCount();
    for (int i = 1; i <= rowsCount; i++) {
      String nextTrackingId = outboundMonitoringPage.outboundBreakroutePage.parcelsNotInOutboundScansTable.getColumnText(
          i, "trackingId");
      if (StringUtils.equals(trackingId, nextTrackingId)) {
        outboundMonitoringPage.outboundBreakroutePage.parcelsNotInOutboundScansTable.clickActionButton(
            i, "pull");
        outboundMonitoringPage.outboundBreakroutePage.confirmPulloutDialog.waitUntilVisible();
        outboundMonitoringPage.outboundBreakroutePage.confirmPulloutDialog.pullOut.click();
        outboundMonitoringPage.outboundBreakroutePage.confirmPulloutDialog.waitUntilInvisible();
        break;
      }
    }
  }

  @When("Operator verify that there is {value} route selected shown on 'Outbound Route Pullout' field")
  public void verifyRouteId(String routeId) {
    Assertions.assertThat(outboundMonitoringPage.outboundBreakroutePage.routeId.getValue())
        .as("Outbound Route Pullout")
        .isEqualTo(routeId);
  }

  @When("Operator verify that Orders in Route table contains records:")
  public void verifyOrdersInRouteTable(List<Map<String, String>> data) {
    List<OrderInfo> expected = data.stream()
        .map(map -> new OrderInfo(resolveKeyValues(map)))
        .collect(Collectors.toList());
    List<OrderInfo> actual = outboundMonitoringPage.outboundBreakroutePage.ordersInRouteTable.readAllEntities();
    Assertions.assertThat(actual)
        .as("List of Orders in Route")
        .hasSize(expected.size());
    for (OrderInfo item : expected) {
      OrderInfo actualItem = actual.stream()
          .filter(o -> StringUtils.equals(o.getTrackingId(), item.getTrackingId()))
          .findFirst()
          .orElseThrow(
              () -> new AssertionError("Order " + item.getTrackingId() + " was not found"));
      item.compareWithActual(actualItem);
    }
  }

  @When("Operator verify that Parcels not in Outbound Scans table contains records:")
  public void verifyParcelsNotInOutboundScansTable(List<Map<String, String>> data) {
    List<OrderInfo> expected = data.stream()
        .map(map -> new OrderInfo(resolveKeyValues(map)))
        .collect(Collectors.toList());
    List<OrderInfo> actual = outboundMonitoringPage.outboundBreakroutePage.parcelsNotInOutboundScansTable.readAllEntities();
    Assertions.assertThat(actual)
        .as("List of Parcels not in Outbound Scans")
        .hasSize(expected.size());
    for (OrderInfo item : expected) {
      OrderInfo actualItem = actual.stream()
          .filter(o -> StringUtils.equals(o.getTrackingId(), item.getTrackingId()))
          .findFirst()
          .orElseThrow(
              () -> new AssertionError("Order " + item.getTrackingId() + " was not found"));
      item.compareWithActual(actualItem);
    }
  }

  @When("Operator verify that Outbound Scans table contains records:")
  public void verifyOutboundScansTable(List<Map<String, String>> data) {
    List<OrderInfo> expected = data.stream()
        .map(map -> new OrderInfo(resolveKeyValues(map)))
        .collect(Collectors.toList());
    List<OrderInfo> actual = outboundMonitoringPage.outboundBreakroutePage.outboundScansTable.readAllEntities();
    Assertions.assertThat(actual)
        .as("List of Outbound Scans")
        .hasSize(expected.size());
    for (OrderInfo item : expected) {
      OrderInfo actualItem = actual.stream()
          .filter(o -> StringUtils.equals(o.getTrackingId(), item.getTrackingId()))
          .findFirst()
          .orElseThrow(
              () -> new AssertionError("Order " + item.getTrackingId() + " was not found"));
      item.compareWithActual(actualItem);
    }
  }

  @When("Operator verify that Outbound Scans table is empty")
  public void verifyOutboundScansTableIsEmpty() {
    Assertions.assertThat(
            outboundMonitoringPage.outboundBreakroutePage.outboundScansTable.isEmpty())
        .as("Outbound Scans table is Empty")
        .isTrue();
  }

  @When("Operator verify that Parcels not in Outbound Scans table is empty")
  public void verifyParcelsNotInOutboundScansTableIsEmpty() {
    Assertions.assertThat(
            outboundMonitoringPage.outboundBreakroutePage.parcelsNotInOutboundScansTable.isEmpty())
        .as("Parcels not in Outbound Scans table is Empty")
        .isTrue();
  }

  @When("Operator verify that Orders in Route table is empty")
  public void verifyOrdersInRouteTableIsEmpty() {
    Assertions.assertThat(
            outboundMonitoringPage.outboundBreakroutePage.ordersInRouteTable.isEmpty())
        .as("Orders in Route table is Empty")
        .isTrue();
  }

  @Then("Operator clicks Pull Out button for orders on Outbound Breakroute V2 page:")
  public void clickPullOutForOrders(List<String> trackingIds) {
    List<String> finalTrackingIds = resolveValues(trackingIds);
    outboundMonitoringPage.outboundBreakrouteV2Page.inFrame(page -> {
      finalTrackingIds.forEach(trackingId -> {
        page.ordersInRouteTable.filterByColumn("trackingId", trackingId);
        Assertions.assertThat(page.ordersInRouteTable.isEmpty())
            .as("Orders table is empty")
            .isFalse();
        page.ordersInRouteTable.selectRow(1);
      });
      page.pullOut.click();
    });
  }

  @Then("Operator verifies info in Confirm Pull Out modal on Outbound Breakroute V2 page:")
  public void verifyConfirmPullOutModalRecords(List<Map<String, String>> data) {
    List<Map<String, String>> finalData = resolveListOfMaps(data);
    outboundMonitoringPage.outboundBreakrouteV2Page.inFrame(page -> {
      page.confirmPulloutDialog.waitUntilVisible();
      int size = page.confirmPulloutDialog.routeIds.size();
      Assertions.assertThat(size)
          .as("Number of records in Confirm Pull Out modal")
          .isEqualTo(data.size());
      List<Map<String, String>> actual = new ArrayList<>();
      for (int i = 0; i < size; i++) {
        Map<String, String> item = ImmutableMap.of(
            "routeId", page.confirmPulloutDialog.routeIds.get(i).getText(),
            "trackingId", page.confirmPulloutDialog.trackingIds.get(i).getText()
        );
        actual.add(item);
      }
      Assertions.assertThat(actual)
          .as("List of records in Confirm Pull Out modal")
          .containsExactlyInAnyOrderElementsOf(finalData);
    });
  }

  @Then("Operator clicks Pull Out in Confirm Pull Out modal on Outbound Breakroute V2 page")
  public void clickPullOutInConfirmPullOutModal() {
    outboundMonitoringPage.outboundBreakrouteV2Page.inFrame(page -> {
      page.confirmPulloutDialog.waitUntilVisible();
      page.confirmPulloutDialog.pullOut.click();
    });
  }

  @Then("Operator verifies errors in Processing modal on Outbound Breakroute V2 page:")
  public void verifyProcessingErrors(List<String> expected) {
    outboundMonitoringPage.outboundBreakrouteV2Page.inFrame(page -> {
      page.processModal.waitUntilVisible();
      new NvWait(10_000).until(
          () -> page.processModal.errors.size() == expected.size(),
          "Number of errors is not " + expected.size());
      List<String> actual = page.processModal.errors.stream()
          .map(PageElement::getNormalizedText)
          .collect(Collectors.toList());
      Assertions.assertThat(actual)
          .as("List of pull out errors")
          .isNotEmpty()
          .containsExactlyInAnyOrderElementsOf(resolveValues(expected));
    });
  }

  @Then("Operator clicks Cancel in Processing modal on Outbound Breakroute V2 page")
  public void clickCancelInProcessingModal() {
    outboundMonitoringPage.outboundBreakrouteV2Page.inFrame(page -> {
      page.processModal.waitUntilVisible();
      page.processModal.cancel.click();
    });
  }
}
