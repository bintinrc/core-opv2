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
import java.util.Objects;
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
    public void operatorSelectsFilterAndclicksLoadSelectionOnAddTagsToOrderPageUsingDataBelow(Map<String, String> mapOfData)
    {
        if(Objects.nonNull(mapOfData.get("shipperName")))
        {
            orderTagManagementPage.selectShipperValue(mapOfData.get("shipperName"));
        }

        if(Objects.nonNull(mapOfData.get("status")))
        {
            orderTagManagementPage.selectUniqueStatusValue(mapOfData.get("status"));
        }

        if(Objects.nonNull(mapOfData.get("granularStatus")))
        {
            orderTagManagementPage.selectUniqueGranularStatusValue(mapOfData.get("granularStatus"));
        }

        orderTagManagementPage.clickLoadSelectionButton();
    }

    @And("^Operator searches and selects orders created on Add Tags to Order page$")
    public void operatorSearchesAndSelectsordersCreatedOnAddTagsToOrderPage()
    {
        orderTagManagementPage.selectOrdersInTable();
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
