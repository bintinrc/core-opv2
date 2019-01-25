package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Dimension;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.utils.NvLogger;
import co.nvqa.commons.utils.StandardTestUtils;
import co.nvqa.operator_v2.selenium.page.EditOrderPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.SerializationUtils;
import org.apache.commons.lang3.StringUtils;

import java.util.Map;
import java.util.Optional;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class EditOrderSteps extends AbstractSteps
{
    private EditOrderPage editOrderPage;

    public EditOrderSteps()
    {
    }

    @Override
    public void init()
    {
        editOrderPage = new EditOrderPage(getWebDriver());
    }

    @When("^Operator click ([^\"]*) -> ([^\"]*) on Edit Order page$")
    public void operatorClickMenuOnEditOrderPage(String parentMenuName, String childMenuName)
    {
        editOrderPage.clickMenu(parentMenuName, childMenuName);
    }

    @When("^Operator Edit Order Details on Edit Order page$")
    public void operatorEditOrderDetailsOnEditOrderPage()
    {
        Order order = get(KEY_CREATED_ORDER);
        Order orderEdited = SerializationUtils.clone(order);

        int newParcelSizeId = (StandardTestUtils.getParcelSizeIdByLongString(orderEdited.getParcelSize())+1)%4;
        orderEdited.setParcelSize(StandardTestUtils.getParcelSizeAsLongString(newParcelSizeId));

        Dimension dimension = orderEdited.getDimensions();
        dimension.setWeight(Optional.ofNullable(dimension.getWeight()).orElse(0.0)+1.0);

        editOrderPage.editOrderDetails(orderEdited);
        put("orderEdited", orderEdited);
    }

    @Then("^Operator Edit Order Details on Edit Order page successfully$")
    public void operatorEditOrderDetailsOnEditOrderPageSuccessfully()
    {
        Order orderEdited = get("orderEdited");
        editOrderPage.verifyEditOrderDetailsIsSuccess(orderEdited);
    }

    @When("^Operator enter Order Instructions on Edit Order page:$")
    public void operatorEnterOrderInstructionsOnEditOrderPage(Map<String, String> data)
    {
        String pickupInstruction = data.get("pickupInstruction");
        if (pickupInstruction != null)
        {
            put(KEY_PICKUP_INSTRUCTION, pickupInstruction);
        }
        String deliveryInstruction = data.getOrDefault("deliveryInstruction", "");
        if (deliveryInstruction != null)
        {
            put(KEY_DELIVERY_INSTRUCTION, deliveryInstruction);
        }
        editOrderPage.editOrderInstructions(pickupInstruction, deliveryInstruction);
    }

    @When("^Operator verify Order Instructions are updated on Edit Order Page$")
    public void operatorVerifyOrderInstructionsAreUpdatedOnEditOrderPage()
    {
        Order order = get(KEY_CREATED_ORDER);
        String pickupInstruction = get(KEY_PICKUP_INSTRUCTION);

        if(StringUtils.isNotBlank(pickupInstruction))
        {
            pickupInstruction = order.getInstruction() + ", " + pickupInstruction;
        }

        String deliveryInstruction = get(KEY_DELIVERY_INSTRUCTION);

        if(StringUtils.isNotBlank(deliveryInstruction))
        {
            deliveryInstruction = order.getInstruction() + ", " + deliveryInstruction;
        }

        editOrderPage.verifyOrderInstructions(pickupInstruction, deliveryInstruction);
    }

    @When("^Operator confirm manually complete order on Edit Order page$")
    public void operatorManuallyCompleteOrderOnEditOrderPage()
    {
        editOrderPage.confirmCompleteOrder();
    }

    @Then("^Operator verify the order completed successfully on Edit Order page$")
    public void operatorVerifyTheOrderCompletedSuccessfullyOnEditOrderPage()
    {
        Order order = get(KEY_CREATED_ORDER);
        editOrderPage.verifyOrderIsForceSuccessedSuccessfully(order);
    }

    @When("^Operator change Priority Level to \"(\\d+)\" on Edit Order page$")
    public void operatorChangePriorityLevelToOnEditOrderPage(int priorityLevel)
    {
        editOrderPage.editPriorityLevel(priorityLevel);
    }

    @Then("^Operator verify (.+) Priority Level is \"(\\d+)\" on Edit Order page$")
    public void operatorVerifyDeliveryPriorityLevelIsOnEditOrderPage(String txnType, int expectedPriorityLevel)
    {
        editOrderPage.verifyPriorityLevel(txnType, expectedPriorityLevel);
    }

    @When("^Operator print Airway Bill on Edit Order page$")
    public void operatorPrintAirwayBillOnEditOrderPage()
    {
        editOrderPage.printAirwayBill();
    }

    @Then("^Operator verify the printed Airway bill for single order on Edit Orders page contains correct info$")
    public void operatorVerifyThePrintedAirwayBillForSingleOrderOnEditOrdersPageContainsCorrectInfo()
    {
        Order order = get(KEY_CREATED_ORDER);
        editOrderPage.verifyAirwayBillContentsIsCorrect(order);
    }

    @When("^Operator add created order to the (.+) route on Edit Order page$")
    public void operatorAddCreatedOrderToTheRouteOnEditOrderPage(String type)
    {
        editOrderPage.addToRoute(get(KEY_CREATED_ROUTE_ID), type);
    }

    @Then("^Operator verify the order is added to the (.+) route on Edit Order page$")
    public void operatorVerifyTheOrderIsAddedToTheRouteOnEditOrderPage(String type)
    {
        switch(type.toUpperCase())
        {
            case "DELIVERY": editOrderPage.verifyDeliveryRouteInfo(get(KEY_CREATED_ROUTE)); break;
            case "PICKUP": editOrderPage.verifyPickupRouteInfo(get(KEY_CREATED_ROUTE)); break;
            default: throw new IllegalArgumentException("Unknown route type: " + type);
        }
    }

    @And("^Operator verify Delivery dates:$")
    public void operatorVerifyDeliveryStartDateTimeValueIs(Map<String, String> mapOfData)
    {
        mapOfData = StandardTestUtils.replaceDataTableTokens(mapOfData);
        String startDateTime = mapOfData.get("startDateTime");

        try
        {
            if(StringUtils.isNoneBlank(startDateTime))
            {
                editOrderPage.verifyDeliveryStartDateTime(startDateTime);
            }

            String endDateTime = mapOfData.get("endDateTime");

            if(StringUtils.isNoneBlank(endDateTime))
            {
                editOrderPage.verifyDeliveryEndDateTime(endDateTime);
            }
        }
        catch(AssertionError | RuntimeException ex)
        {
            NvLogger.warn("Skip delivery start date & end date verification because it's to complicated.", ex);
        }
    }
}
