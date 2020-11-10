package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.selenium.page.EditOrderPage;
import co.nvqa.operator_v2.selenium.page.OrderTagManagementPage;
import co.nvqa.operator_v2.util.TestConstants;
import cucumber.api.java.en.And;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @author Niko Susanto
 */
@ScenarioScoped
public class OrderTagManagementSteps extends AbstractSteps
{
    private OrderTagManagementPage orderTagManagementPage;
    private EditOrderPage editOrderPage;

    public OrderTagManagementSteps()
    {
    }

    @Override
    public void init()
    {
        orderTagManagementPage = new OrderTagManagementPage(getWebDriver());
        editOrderPage = new EditOrderPage(getWebDriver());
    }

    @When("^Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:$")
    public void operatorSelectsFilterAndclicksLoadSelectionOnAddTagsToOrderPageUsingDataBelow(Map<String, String> data)
    {
        data = resolveKeyValues(data);
        if (data.containsKey("shipperName"))
        {
            orderTagManagementPage.shipperFilter.clearAll();
            orderTagManagementPage.shipperFilter.selectFilter(data.get("shipperName"));
        }

        if (data.containsKey("status"))
        {
            orderTagManagementPage.statusFilter.clearAll();
            orderTagManagementPage.statusFilter.selectFilter(data.get("status"));
        }

        if (data.containsKey("granularStatus"))
        {
            orderTagManagementPage.granularStatusFilter.clearAll();
            orderTagManagementPage.granularStatusFilter.selectFilter(data.get("granularStatus"));
        }

        orderTagManagementPage.loadSelection.click();
    }

    @And("^Operator searches and selects orders created on Add Tags to Order page$")
    public void operatorSearchesAndSelectsOrdersCreatedOnAddTagsToOrderPage()
    {
        List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
        trackingIds.forEach(trackingId ->
        {
            orderTagManagementPage.ordersTable.filterByColumn("trackingId", trackingId);
            orderTagManagementPage.ordersTable.selectRow(1);
        });
    }

    @And("Operator searches and selects orders created first row on Add Tags to Order page")
    public void operatorSearchesAndSelectsOrdersCreatedFirstRowOnAddTagsToOrderPage()
    {
        List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
        trackingIds.forEach(trackingId ->
        {
            orderTagManagementPage.ordersTable.filterByColumn("trackingId", trackingId);
            orderTagManagementPage.ordersTable.selectFirstRowCheckBox();
        });
    }

    @And("^Operator tags order with:$")
    public void operatorTagsOrderWith(List<String> orderTag)
    {
        orderTagManagementPage.addTag(orderTag);
    }

    @And("^Operator remove order tags:$")
    public void operatorRemoveOrderTags(List<String> orderTag)
    {
        orderTagManagementPage.removeTag(orderTag);
    }

    @And("^Operator verify the tags shown on Edit Order page$")
    public void operatorVerifyTheTagsShownOnEditOrderPage(List<String> expectedOrderTags)
    {
        Order order = get(KEY_CREATED_ORDER);

        navigateTo(f("%s/%s/order/%d", TestConstants.OPERATOR_PORTAL_BASE_URL, TestConstants.COUNTRY_CODE, order.getId()));
        List<String> actualOrderTags = editOrderPage.getTags();

        final List<String> normalizedExpectedList = expectedOrderTags.stream().map(String::toLowerCase).sorted().collect(Collectors.toList());
        final List<String> normalizedActualList = actualOrderTags.stream().map(String::toLowerCase).sorted().collect(Collectors.toList());

        assertEquals(f("Order tags is not equal to tags set on Order Tag Management page for order Id - %s", order.getId()), normalizedExpectedList, normalizedActualList);
    }

}
