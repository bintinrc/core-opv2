package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.selenium.page.OrderLevelTagManagementPage;
import cucumber.api.java.en.And;

import java.util.List;

/**
 * @author Kateryna Skakunova
 */
public class OrderLevelTagManagementSteps extends AbstractSteps {

    private OrderLevelTagManagementPage orderLevelTagManagementPage;

    public OrderLevelTagManagementSteps() {
    }

    @Override
    public void init() {
        orderLevelTagManagementPage = new OrderLevelTagManagementPage(getWebDriver());
    }

    @And("^Operator filters by Shipper = \"([^\"]*)\"$")
    public void operatorFiltersByShipper(String text) {
        orderLevelTagManagementPage.selectShipperValue(text);
    }

    @And("^Operator filters by Status = \"([^\"]*)\"$")
    public void operatorFiltersByStatus(String text) {
        orderLevelTagManagementPage.selectUniqueStatusValue(text);
    }

    @And("^Operator filters by Granular Status = \"([^\"]*)\"$")
    public void operatorFiltersByGranularStatus(String text) {
        orderLevelTagManagementPage.selectUniqueGranularStatusValue(text);
    }

    @And("^Operator clicks \"Load Selection\" button$")
    public void operatorClicksButton() {
        orderLevelTagManagementPage.clickLoadSelectionButton();
    }

    @And("^Operator selects orders created$")
    public void operatorSelectsOrdersCreated() {
        List<Order> lists = get(KEY_LIST_OF_CREATED_ORDER);
        lists.forEach(order ->
                orderLevelTagManagementPage.selectOrderInTable(String.valueOf(order.getId())));
    }

    @And("^Operator tags order with \"([^\"]*)\"$")
    public void operatorTagsOrderWith(String tagLabel) {
        put(KEY_ORDER_TAG, tagLabel);
        orderLevelTagManagementPage.clickTagSelectedOrdersButton();
        orderLevelTagManagementPage.tagSelectedOrdersAndSave(tagLabel);
    }
}
