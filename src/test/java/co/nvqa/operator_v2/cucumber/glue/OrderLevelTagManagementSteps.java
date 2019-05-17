package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.selenium.page.OrderLevelTagManagementPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * @author Kateryna Skakunova
 */
@ScenarioScoped
public class OrderLevelTagManagementSteps extends AbstractSteps
{
    private OrderLevelTagManagementPage orderLevelTagManagementPage;

    public OrderLevelTagManagementSteps()
    {
    }

    @Override
    public void init()
    {
        orderLevelTagManagementPage = new OrderLevelTagManagementPage(getWebDriver());
    }

    @And("^Operator selects orders created$")
    public void operatorSelectsOrdersCreated()
    {
        List<Order> lists = get(KEY_LIST_OF_CREATED_ORDER);
        lists.forEach(order -> orderLevelTagManagementPage.selectOrderInTable(String.valueOf(order.getId())));
    }

    @And("^Operator tags order with \"([^\"]*)\"$")
    public void operatorTagsOrderWith(String tagLabel)
    {
        put(KEY_ORDER_TAG, tagLabel);
        orderLevelTagManagementPage.clickTagSelectedOrdersButton();
        orderLevelTagManagementPage.tagSelectedOrdersAndSave(tagLabel);
    }

    @When("^Operator selects filter and clicks Load Selection on Order Level Tag Management page using data below:$")
    public void operatorSelectsFilterAndClicksLoadSelectionOnOrderLevelTagManagementPageUsingDataBelow(Map<String, String> mapOfData)
    {
        if(Objects.nonNull(mapOfData.get("shipperName")))
        {
            orderLevelTagManagementPage.selectShipperValue(mapOfData.get("shipperName"));
        }

        if(Objects.nonNull(mapOfData.get("status")))
        {
            orderLevelTagManagementPage.selectUniqueStatusValue(mapOfData.get("status"));
        }

        if(Objects.nonNull(mapOfData.get("granularStatus")))
        {
            orderLevelTagManagementPage.selectUniqueGranularStatusValue(mapOfData.get("granularStatus"));
        }

        if(Objects.nonNull(mapOfData.get("masterShipper")))
        {
            orderLevelTagManagementPage.selectMasterShipperValue(mapOfData.get("masterShipper"));
        }

        orderLevelTagManagementPage.clickLoadSelectionButton();
    }
}
