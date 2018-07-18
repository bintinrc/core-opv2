package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.order_create.v2.Parcel;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.EditOrderPage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.SerializationUtils;
import org.apache.commons.lang3.StringUtils;

import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class EditOrderSteps extends AbstractSteps
{
    private EditOrderPage editOrderPage;

    @Inject
    public EditOrderSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
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
        Order order = get(KEY_ORDER_CREATE_REQUEST);

        Order orderEdited = SerializationUtils.clone(order);
        Parcel parcelEdited = null; //orderRequestV2Edited.getParcels().get(0);

        int newParcelSizeId = (parcelEdited.getParcelSizeId()+1)%4;
        parcelEdited.setParcelSizeId(newParcelSizeId);

        Double newWeight = parcelEdited.getWeight();

        if(newWeight==null)
        {
            newWeight = 1.0;
        }
        else
        {
            newWeight += 1.0;
        }

        parcelEdited.setWeight(newWeight);

        editOrderPage.editOrderDetails(orderEdited);
        put("orderRequestV2Edited", orderEdited);
    }

    @Then("^Operator Edit Order Details on Edit Order page successfully$")
    public void operatorEditOrderDetailsOnEditOrderPageSuccessfully()
    {
        Order orderEdited = get("orderRequestV2Edited");
        Order order = get(KEY_ORDER_DETAILS);
        editOrderPage.verifyEditOrderDetailsIsSuccess(orderEdited, order);
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
        Order order = get(KEY_ORDER_CREATE_REQUEST);
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
        Order order = get(KEY_ORDER_CREATE_REQUEST);
        order.setTrackingId(get(KEY_CREATED_ORDER_TRACKING_ID));
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
}
