package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.NvTestWaitTimeoutException;
import co.nvqa.operator_v2.exception.NvTestCoreElementCountMismatch;
import co.nvqa.operator_v2.selenium.elements.PageElement;
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

import static co.nvqa.common.utils.StandardTestUtils.waitUntil;
import static co.nvqa.operator_v2.selenium.page.OutboundMonitoringPage.RoutesTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.OutboundMonitoringPage.RoutesTable.ACTION_FLAG;
import static co.nvqa.operator_v2.selenium.page.OutboundMonitoringPage.RoutesTable.COLUMN_OUTBOUND_STATUS;
import static co.nvqa.operator_v2.selenium.page.OutboundMonitoringPage.RoutesTable.COLUMN_ROUTE_ID;

/**
 * @author Tristania Siagian
 */
@ScenarioScoped
public class OutboundMonitoringSteps extends AbstractSteps {

  private OutboundMonitoringPage page;

  public OutboundMonitoringSteps() {
  }

  @Override
  public void init() {
    page = new OutboundMonitoringPage(getWebDriver());
  }

  @When("Operator click on 'Load Selection' Button on Outbound Monitoring Page")
  public void clickLoadSelection() {
    page.inFrame(() -> {
      page.loadSelection.click();
      page.waitUntilLoaded();
    });
  }

  @When("Operator verifies Date is {string} on Outbound Monitoring Page")
  public void verifyDate(String expected) {
    page.inFrame(() ->
        Assertions.assertThat(page.dateFilter.getValue())
            .as("Date")
            .isEqualTo(expected)
    );
  }

  @And("Operator search on Route ID Header Table on Outbound Monitoring Page:")
  public void searchRouteId(Map<String, String> dataTableRaw) {
    long routeId = Long.parseLong(resolveKeyValues(dataTableRaw).get("routeId"));
    page.inFrame(() -> page.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId));
  }

  @Then("Operator verify the route ID is exist on Outbound Monitoring Page:")
  public void verifyRouteIdExists(Map<String, String> dataTableRaw) {
    long routeId = Long.parseLong(resolveKeyValues(dataTableRaw).get("routeId"));
    page.inFrame(() -> {
      page.searchTableByRouteId(routeId);
      page.verifyRouteIdExists(String.valueOf(routeId));
    });
  }

  @Then("Operator clicks Edit button for {value} route on Outbound Monitoring Page")
  public void clickButtonInRoutesTable(String routeId) {
    String mainWindowHandle = getWebDriver().getWindowHandle();
    put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
    page.inFrame(() -> {
      page.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      Assertions.assertThat(page.routesTable.isEmpty())
          .as("Routes table is empty")
          .isFalse();
      page.routesTable.clickActionButton(1, ACTION_EDIT);
      doWithRetry(
          () -> page.switchToOutboundBreakrouteWindow(Long.parseLong(routeId)),
          "switch to Outbound Breakroute window",
          1000,
          5);
    });
  }

  @Then("Operator clicks Pull Out button for routes on Outbound Monitoring Page:")
  public void clickPullOutForRoutes(List<String> routeIds) {
    page.inFrame(() -> {
      String mainWindowHandle = getWebDriver().getWindowHandle();
      put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
      resolveValues(routeIds).forEach(routeId -> {
        page.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
        Assertions.assertThat(page.routesTable.isEmpty())
            .as("Routes table is empty")
            .isFalse();
        page.routesTable.selectRow(1);
      });
      page.pullOut.click();
      page.switchToOtherWindowUrlContains("outbound-breakroute-v2");
      page.outboundBreakrouteV2Page.switchTo();
      page.outboundBreakrouteV2Page.waitUntilLoaded();
      if (page.outboundBreakrouteV2Page.processModal.waitUntilVisible(3)) {
        page.outboundBreakrouteV2Page.processModal.waitUntilInvisible();
      }
      pause1s();
    });
  }

  @Then("Operator verifies {int} total selected Route IDs shown on Outbound Breakroute V2 page")
  public void clickPullOutForRoutes(int count) {
    page.outboundBreakrouteV2Page.inFrame(page -> {
      Assertions.assertThat(page.routesCount.getText())
          .as("total selected Route ID(s) label")
          .isEqualTo(count + " selected Route ID(s)");
    });
  }

  @Then("Operator verifies {value} date shown on Outbound Breakroute V2 page")
  public void checkDateOnOutboundBreakrouteV2Page(String date) {
    page.outboundBreakrouteV2Page.inFrame(page -> {
      Assertions.assertThat(page.date.getText())
          .as("Date label")
          .isEqualTo("Date: " + resolveValue(date));
    });
  }

  @Then("Operator verifies orders info on Outbound Breakroute V2 page:")
  public void checkDateOnOutboundBreakrouteV2Page(List<Map<String, String>> data) {
    page.outboundBreakrouteV2Page.inFrame(page -> {
      data.forEach(item -> {
        OutboundBreakrouteV2Page.OrderInfo expected = new OutboundBreakrouteV2Page.OrderInfo(
            resolveKeyValues(item));
        this.page.outboundBreakrouteV2Page.ordersInRouteTable
            .filterByColumn("trackingId", expected.getTrackingId());
        Assertions.assertThat(
                this.page.outboundBreakrouteV2Page.ordersInRouteTable.isEmpty())
            .as("Orders table is empty")
            .isFalse();
        OutboundBreakrouteV2Page.OrderInfo actual = this.page.outboundBreakrouteV2Page
            .ordersInRouteTable.readEntity(1);
        expected.compareWithActual(actual);
      });
    });
  }

  @Then("Operator verifies orders table is empty on Outbound Breakroute V2 page")
  public void checkOrdersTableIsEmpty() {
    page.outboundBreakrouteV2Page.inFrame(page -> {
      Assertions.assertThat(
              this.page.outboundBreakrouteV2Page.ordersInRouteTable.isEmpty())
          .as("Orders table is empty")
          .isTrue();
    });
  }

  @Then("Operator verifies filter results on Outbound Breakroute V2 page:")
  public void checkFilterResults(List<Map<String, String>> data) {
    page.outboundBreakrouteV2Page.inFrame(page -> {
      Assertions.assertThat(
              this.page.outboundBreakrouteV2Page.ordersInRouteTable.getRowsCount())
          .as("Orders table rows count")
          .isEqualTo(data.size());
      List<OutboundBreakrouteV2Page.OrderInfo> actual =
          this.page.outboundBreakrouteV2Page.ordersInRouteTable.readAllEntities();

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
    page.outboundBreakrouteV2Page.inFrame(page -> {
      finalData.forEach((key, value) -> {
        this.page.outboundBreakrouteV2Page.ordersInRouteTable
            .filterByColumn(key, value);
      });
    });
  }

  @Then("Operator clear filters of orders table on Outbound Breakroute V2 page")
  public void clearTableFilters() {
    page.outboundBreakrouteV2Page.inFrame(page -> {
      this.page.outboundBreakrouteV2Page.ordersInRouteTable.clearColumnFilters();
    });
  }

  @Then("Operator verify the In Progress Outbound Status on Outbound Monitoring Page")
  public void verifyStatusInProgress() {
    page.inFrame(() -> page.verifyStatusInProgress());
  }

  @Then("Operator verify the Complete Outbound Status on Outbound Monitoring Page")
  public void verifyStatusComplete() {
    page.inFrame(() -> page.verifyStatusComplete());
  }

  @And("Operator click on flag icon on chosen route ID on Outbound Monitoring Page")
  public void clickFlagButton() {
    page.inFrame(() -> {
      page.routesTable.clickActionButton(1, ACTION_FLAG);
      pause10s();
    });
  }

  @And("Operator verifies route record on Outbound Monitoring page:")
  public void clickFlagButton(Map<String, String> map) {
    page.inFrame(() -> {
      RouteInfo expected = new RouteInfo(resolveKeyValues(map));
      List<RouteInfo> actual = page.routesTable.readAllEntities();
      actual.stream()
          .filter(expected::matchedTo)
          .findFirst()
          .orElseThrow(() -> new AssertionError("Route record was not found: " + expected));
    });
  }

  @And("Operator verifies route record has {value} background color")
  public void verifyColor(String color) {
    page.inFrame(() -> {
      PageElement cell = page.routesTable.getCell(COLUMN_OUTBOUND_STATUS, 1);
      String expected = "col-" + color.toLowerCase(Locale.ROOT);
      Assertions.assertThat(cell.getAttribute("class"))
          .as("cell class")
          .contains(expected);
    });
  }

  @Then("Operator verifies the Outbound status on the chosen route ID is changed")
  public void verifyStatusMarked() {
    page.inFrame(() ->
        doWithRetry(() -> page.verifyStatusMarked(), "Verify Status is Marked")
    );
  }


  @And("Operator click on comment icon on chosen route ID on Outbound Monitoring Page")
  public void clickCommentButtonAndSubmit() {
    page.inFrame(() -> page.clickCommentButtonAndSubmit());
  }

  @Then("Operator verifies the comment table on the chosen route ID is changed")
  public void verifyCommentIsRight() {
    page.inFrame(() -> page.verifyCommentIsRight());
  }

  @When("Operator select filter and click Load Selection on Outbound Monitoring page using data below:")
  public void selectFiltersAndClickLoadSelection(Map<String, String> data) {
    var finalData = resolveKeyValues(data);
    page.inFrame(() -> {
      if (finalData.containsKey("hubName")) {
        page.hubsSelect.selectValues(splitAndNormalize(finalData.get("hubName")));
      }
      if (finalData.containsKey("zoneName")) {
        page.zonesSelect.selectValues(splitAndNormalize(finalData.get("zoneName")));
      }
    });
    clickLoadSelection();
  }

  @When("Operator verify that Orders in Route table contains records:")
  public void verifyOrdersInRouteTable(List<Map<String, String>> data) {
    page.outboundBreakrouteV2Page.inFrame(page -> {
      List<OutboundBreakrouteV2Page.OrderInfo> expected = data.stream()
          .map(map -> new OutboundBreakrouteV2Page.OrderInfo(resolveKeyValues(map)))
          .collect(Collectors.toList());
      List<OutboundBreakrouteV2Page.OrderInfo> actual = page.ordersInRouteTable.readAllEntities();
      Assertions.assertThat(actual)
          .as("List of Orders in Route")
          .hasSize(expected.size());
      for (OutboundBreakrouteV2Page.OrderInfo item : expected) {
        OutboundBreakrouteV2Page.OrderInfo actualItem = actual.stream()
            .filter(o -> StringUtils.equals(o.getTrackingId(), item.getTrackingId()))
            .findFirst()
            .orElseThrow(
                () -> new AssertionError("Order " + item.getTrackingId() + " was not found"));
        item.compareWithActual(actualItem);
      }
    });
  }

  @Then("Operator clicks Pull Out button for orders on Outbound Breakroute V2 page:")
  public void clickPullOutForOrders(List<String> trackingIds) {
    List<String> finalTrackingIds = resolveValues(trackingIds);
    page.outboundBreakrouteV2Page.inFrame(page -> {
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
    page.outboundBreakrouteV2Page.inFrame(page -> {
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
    page.outboundBreakrouteV2Page.inFrame(page -> {
      page.confirmPulloutDialog.waitUntilVisible();
      page.confirmPulloutDialog.pullOut.click();
    });
  }

  @Then("Operator verifies errors in Processing modal on Outbound Breakroute V2 page:")
  public void verifyProcessingErrors(List<String> expected) {
    page.outboundBreakrouteV2Page.inFrame(page -> {
      page.processModal.waitUntilVisible();
      try {
        waitUntil(() -> page.processModal.errors.size() == expected.size(), 10_000);
      } catch (NvTestWaitTimeoutException e) {
        throw new NvTestCoreElementCountMismatch("Number of errors is not " + expected.size());
      }
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
    page.outboundBreakrouteV2Page.inFrame(page -> {
      page.processModal.waitUntilVisible();
      page.processModal.cancel.click();
    });
  }
}
