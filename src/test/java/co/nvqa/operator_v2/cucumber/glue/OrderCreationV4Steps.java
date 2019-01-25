package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.StandardApiShipperSteps;
import co.nvqa.commons.model.order_create.v4.OrderRequestV4;
import co.nvqa.operator_v2.selenium.page.OrderCreationV4Page;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import javax.inject.Inject;
import java.util.Map;

/**
 *
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class OrderCreationV4Steps extends AbstractSteps
{
    @Inject private StandardApiShipperSteps standardApiShipperSteps;
    private OrderCreationV4Page orderCreationV4Page;

    public OrderCreationV4Steps()
    {
    }

    @Override
    public void init()
    {
        orderCreationV4Page = new OrderCreationV4Page(getWebDriver());
    }

    @When("^Operator create order V4 by uploading XLSX on Order Creation V4 page using data below:$")
    public void operatorCreateOrderVByUploadingXLSXOnOrderCreationVPageUsingDataBelow(Map<String,String> dataTableAsMap)
    {
        int shipperId = Integer.parseInt(dataTableAsMap.get("shipperId"));
        OrderRequestV4 orderRequestV4 = standardApiShipperSteps.buildOrderRequestV4(dataTableAsMap);
        orderCreationV4Page.uploadXlsx(orderRequestV4, shipperId);
        put(KEY_CREATED_ORDER, orderRequestV4);
    }

    @Then("^Operator verify order V4 is created successfully on Order Creation V4 page$")
    public void operatorVerifyOrderVIsCreatedSuccessfullyOnOrderCreationVPage()
    {
        OrderRequestV4 order = get(KEY_CREATED_ORDER);
        orderCreationV4Page.verifyOrderIsCreatedSuccessfully(order);
    }
}
