package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.model.TaggedOrderParams;
import co.nvqa.operator_v2.selenium.page.EditOrderPage;
import co.nvqa.operator_v2.selenium.page.OrderTagManagementPage;
import co.nvqa.operator_v2.util.TestConstants;
import cucumber.api.java.en.And;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;

/**
 * @author Niko Susanto
 */
@ScenarioScoped
public class OrderTagManagementSteps extends AbstractSteps {

  private OrderTagManagementPage orderTagManagementPage;
  private EditOrderPage editOrderPage;

  public OrderTagManagementSteps() {
  }

  @Override
  public void init() {
    orderTagManagementPage = new OrderTagManagementPage(getWebDriver());
    editOrderPage = new EditOrderPage(getWebDriver());
  }

  @When("^Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:$")
  public void operatorSelectsFilterAndclicksLoadSelectionOnAddTagsToOrderPageUsingDataBelow(
      Map<String, String> data) {
    data = resolveKeyValues(data);

    if (data.containsKey("orderTags")) {
      List<String> tags = splitAndNormalize(data.get("orderTags"));
      orderTagManagementPage.orderTagsFilter.clearAll();
      orderTagManagementPage.orderTagsFilter.selectFilter(tags);
    }

    if (data.containsKey("shipperName")) {
      if (!orderTagManagementPage.shipperFilter.isDisplayedFast()) {
        orderTagManagementPage.addFilter("Shipper");
      }
      orderTagManagementPage.shipperFilter.clearAll();
      orderTagManagementPage.shipperFilter.selectFilter(data.get("shipperName"));
    }

    if (data.containsKey("status")) {
      if (!orderTagManagementPage.statusFilter.isDisplayedFast()) {
        orderTagManagementPage.addFilter("Status");
      }
      orderTagManagementPage.statusFilter.clearAll();
      orderTagManagementPage.statusFilter.selectFilter(data.get("status"));
    }

    if (data.containsKey("granularStatus")) {
      if (!orderTagManagementPage.granularStatusFilter.isDisplayedFast()) {
        orderTagManagementPage.addFilter("Granular Status");
      }
      orderTagManagementPage.granularStatusFilter.clearAll();
      orderTagManagementPage.granularStatusFilter.selectFilter(data.get("granularStatus"));
    }

    if (data.containsKey("orderType")) {
      if (!orderTagManagementPage.orderTypeFilter.isDisplayedFast()) {
        orderTagManagementPage.addFilter("Order Type");
      }
      orderTagManagementPage.orderTypeFilter.clearAll();
      orderTagManagementPage.orderTypeFilter.selectFilter(data.get("orderType"));
    }

    if (data.containsKey("rts")) {
      if (!orderTagManagementPage.rtsFilter.isDisplayedFast()) {
        orderTagManagementPage.addFilter("RTS");
      }
      orderTagManagementPage.rtsFilter.setFilter(data.get("rts"));
    }

    orderTagManagementPage.loadSelection.click();
  }

  @And("^Operator searches and selects orders created on Add Tags to Order page$")
  public void operatorSearchesAndSelectsOrdersCreatedOnAddTagsToOrderPage() {
    List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
    trackingIds.forEach(trackingId ->
    {
      orderTagManagementPage.ordersTable.filterByColumn("trackingId", trackingId);
      orderTagManagementPage.ordersTable.selectRow(1);
    });
  }

  @And("Operator searches and selects orders created first row on Add Tags to Order page")
  public void operatorSearchesAndSelectsOrdersCreatedFirstRowOnAddTagsToOrderPage() {
    List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
    trackingIds.forEach(trackingId ->
    {
      orderTagManagementPage.ordersTable.filterByColumn("trackingId", trackingId);
      orderTagManagementPage.ordersTable.selectFirstRowCheckBox();
    });
  }

  @And("^Operator tags order with:$")
  public void operatorTagsOrderWith(List<String> orderTag) {
    orderTagManagementPage.addTag(resolveValues(orderTag));
  }

  @And("^Operator remove order tags:$")
  public void operatorRemoveOrderTags(List<String> orderTag) {
    orderTagManagementPage.removeTag(resolveValues(orderTag));
  }

  @And("^Operator verify the tags shown on Edit Order page$")
  public void operatorVerifyTheTagsShownOnEditOrderPage(List<String> expectedOrderTags) {
    expectedOrderTags = resolveValues(expectedOrderTags);
    Order order = get(KEY_CREATED_ORDER);

    navigateTo(
        f("%s/%s/order/%d", TestConstants.OPERATOR_PORTAL_BASE_URL, TestConstants.COUNTRY_CODE,
            order.getId()));
    List<String> actualOrderTags = editOrderPage.getTags();

    final List<String> normalizedExpectedList = expectedOrderTags.stream().map(String::toLowerCase)
        .sorted().collect(Collectors.toList());
    final List<String> normalizedActualList = actualOrderTags.stream().map(String::toLowerCase)
        .sorted().collect(Collectors.toList());

    assertEquals(
        f("Order tags is not equal to tags set on Order Tag Management page for order Id - %s",
            order.getId()), normalizedExpectedList, normalizedActualList);
  }

  @And("Operator verifies selected value of RTS filter is {string} on Order Tag Management page")
  public void operatorVerifyRtsFilter(String expected) {
    expected = resolveValue(expected);
    assertTrue("RTS filter is displayed", orderTagManagementPage.rtsFilter.isDisplayed());
    assertEquals("RTS filter value", expected, orderTagManagementPage.rtsFilter.getValue());
  }

  @And("Operator clicks 'Clear All Selection' button on Order Tag Management page")
  public void operatorClicksClearAllSelection() {
    orderTagManagementPage.clearAllSelection.click();
  }

  @And("Operator verifies orders are not displayed on Order Tag Management page:")
  public void operatorVerifyOrdersAreNotDisplayed(List<String> trackingIds) {
    trackingIds = resolveValues(trackingIds);
    trackingIds.forEach(trackingId ->
    {
      orderTagManagementPage.ordersTable.filterByColumn("trackingId", trackingId);
      assertTrue(f("Order %s must not be displayed", trackingId),
          orderTagManagementPage.ordersTable.isEmpty());
    });
  }

  @And("Operator opens 'View Tagged Orders' tab on Order Tag Management page:")
  public void operatorOpenViewTaggedOrdersTab() {
    orderTagManagementPage.viewTaggedOrders.click();
  }

  @And("^Operator verifies that 'Load Selection' button is (enabled|disabled) on Order Tag Management page")
  public void operatorVerifyLoadSelection(String state) {
    assertEquals("Load selection button enable state",
        StringUtils.equalsIgnoreCase(state, "enabled"),
        orderTagManagementPage.loadSelection.isEnabled());
  }

  @And("^Operator verifies order params on Order Tag Management page:")
  public void operatorVerifyOrderParams(Map<String, String> data) {
    data = resolveKeyValues(data);
    Order expected = new Order();
    expected.fromMap(data);
    orderTagManagementPage.ordersTable.filterByColumn("trackingId", expected.getTrackingId());
    Order actual = orderTagManagementPage.ordersTable.readEntity(1);
    expected.compareWithActual(actual);
  }

  @And("^Operator verifies tagged order params on Order Tag Management page:")
  public void operatorVerifytaggedOrderParams(Map<String, String> data) {
    data = resolveKeyValues(data);
    TaggedOrderParams expected = new TaggedOrderParams(data);
    orderTagManagementPage.taggedOrdersTable.filterByColumn("trackingId", expected.getTrackingId());
    TaggedOrderParams actual = orderTagManagementPage.taggedOrdersTable.readEntity(1);
    expected.compareWithActual(actual);
  }

}
