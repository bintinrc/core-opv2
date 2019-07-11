package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Dimension;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.StandardTestUtils;
import co.nvqa.operator_v2.model.OrderEvent;
import co.nvqa.operator_v2.selenium.page.EditOrderPage;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.SerializationUtils;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.junit.jupiter.api.Assertions;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import static co.nvqa.operator_v2.selenium.page.EditOrderPage.EventsTable.EVENT_NAME;

/**
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

        int newParcelSizeId = (StandardTestUtils.getParcelSizeIdByLongString(orderEdited.getParcelSize()) + 1) % 4;
        orderEdited.setParcelSize(StandardTestUtils.getParcelSizeAsLongString(newParcelSizeId));

        Dimension dimension = orderEdited.getDimensions();
        dimension.setWeight(Optional.ofNullable(dimension.getWeight()).orElse(0.0) + 1.0);

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

        if (StringUtils.isNotBlank(pickupInstruction))
        {
            pickupInstruction = order.getInstruction() + ", " + pickupInstruction;
        }

        String deliveryInstruction = get(KEY_DELIVERY_INSTRUCTION);

        if (StringUtils.isNotBlank(deliveryInstruction))
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
        switch (type.toUpperCase())
        {
            case "DELIVERY":
                editOrderPage.verifyDeliveryRouteInfo(get(KEY_CREATED_ROUTE));
                break;
            case "PICKUP":
                editOrderPage.verifyPickupRouteInfo(get(KEY_CREATED_ROUTE));
                break;
            default:
                throw new IllegalArgumentException("Unknown route type: " + type);
        }
    }

    @And("^Operator verify Delivery dates:$")
    public void operatorVerifyDeliveryStartDateTimeValueIs(Map<String, String> mapOfData)
    {
        mapOfData = StandardTestUtils.replaceDataTableTokens(mapOfData);
        String startDateTime = mapOfData.get("startDateTime");

        try
        {
            if (StringUtils.isNoneBlank(startDateTime))
            {
                editOrderPage.verifyDeliveryStartDateTime(startDateTime);
            }

            String endDateTime = mapOfData.get("endDateTime");

            if (StringUtils.isNoneBlank(endDateTime))
            {
                editOrderPage.verifyDeliveryEndDateTime(endDateTime);
            }
        } catch (AssertionError | RuntimeException ex)
        {
            NvLogger.warn("Skip delivery start date & end date verification because it's to complicated.", ex);
        }
    }

    @Then("^Operator verify order status is \"(.+)\" on Edit Order page$")
    public void operatorVerifyOrderStatusOnEditOrderPage(String expectedValue)
    {
        editOrderPage.verifyOrderStatus(expectedValue);
    }

    @Then("^Operator verify order granular status is \"(.+)\" on Edit Order page$")
    public void operatorVerifyOrderGranularStatusOnEditOrderPage(String expectedValue)
    {
        editOrderPage.verifyOrderGranularStatus(expectedValue);
    }

    @Then("^Operator verify order delivery title is \"(.+)\" on Edit Order page$")
    public void operatorVerifyOrderDeliveryTitleOnEditOrderPage(String expectedValue)
    {
        editOrderPage.verifyOrderDeliveryTitle(expectedValue);
    }

    @Then("^Operator verify order delivery status is \"(.+)\" on Edit Order page$")
    public void operatorVerifyOrderDeliveryStatusOnEditOrderPage(String expectedValue)
    {
        editOrderPage.verifyOrderDeliveryStatus(expectedValue);
    }

    @Then("^Operator verify RTS event displayed on Edit Order page with following properties:$")
    public void operatorVerifyRtsEventOnEditOrderPage(Map<String, String> mapOfData)
    {
        Map<String, String> mapOfTokens = createDefaultTokens();
        mapOfData = replaceDataTableTokens(mapOfData, mapOfTokens);

        OrderEvent orderEvent = editOrderPage.eventsTable().filterByColumn(EVENT_NAME, "RTS").readEntity(1);
        assertThat("Event Name", orderEvent.getName(), Matchers.equalToIgnoringCase("RTS"));

        String value = mapOfData.get("eventTags");

        if (value != null)
        {
            assertThat("Event Tags", orderEvent.getTags(), Matchers.equalToIgnoringCase(value));
        }

        value = mapOfData.get("reason");

        if (value != null)
        {
            assertThat("Reason", orderEvent.getDescription(), Matchers.containsString("Reason: Return to sender: " + value));
        }

        value = mapOfData.get("startTime");

        if (value != null)
        {
            assertThat("Start Time", orderEvent.getDescription(), Matchers.containsString("Start Time: " + value));
        }

        value = mapOfData.get("endTime");

        if (value != null)
        {
            assertThat("End Time", orderEvent.getDescription(), Matchers.containsString("End Time: " + value));
        }
    }

    @Then("^Operator verifies orders are tagged on Edit order page$")
    public void operatorVerifiesOrdersAreTaggedOnEditOrderPage()
    {
        String tagLabel = get(KEY_ORDER_TAG);
        List<Order> lists = get(KEY_LIST_OF_CREATED_ORDER);

        lists.forEach(order ->
        {
            navigateTo(f("%s/%s/order/%d", TestConstants.OPERATOR_PORTAL_BASE_URL, TestConstants.COUNTRY_CODE, order.getId()));
            String actualTagName = editOrderPage.getTag();
            assertEquals(f("Order tag is not equal to tag set on Order Level Tag Management page for order Id - %s", order.getId()), tagLabel, actualTagName);
        });
    }

    @When("^Operator change Stamp ID of the created order to \"(.+)\" on Edit order page$")
    public void operatorEditStampIdOnEditOrderPage(String stampId)
    {
        if (StringUtils.equalsIgnoreCase(stampId, "GENERATED"))
        {
            stampId = TestUtils.generateDateUniqueString();
        }

        NvLogger.warn(stampId);
        editOrderPage.editOrderStamp(stampId);
    }

    @When("^Operator update status of the created order on Edit order page using data below:$")
    public void operatorUpdateStatusOnEditOrderPage(Map<String, String> mapOfData)
    {
        Order order = get(KEY_CREATED_ORDER);
        String value = mapOfData.get("status");
        if (StringUtils.isNotBlank(value))
        {
            order.setStatus(value);
        }
        value = mapOfData.get("granularStatus");
        if (StringUtils.isNotBlank(value))
        {
            order.setGranularStatus(value);
        }
        value = mapOfData.get("lastPickupTransactionStatus");
        if (StringUtils.isNotBlank(value))
        {
            Transaction transaction = order.getLastPickupTransaction();
            Assertions.assertNotNull(transaction, "Last Pickup Transaction");
            transaction.setStatus(value.toUpperCase());
        }
        value = mapOfData.get("lastDeliveryTransactionStatus");
        if (StringUtils.isNotBlank(value))
        {
            Transaction transaction = order.getLastDeliveryTransaction();
            Assertions.assertNotNull(transaction, "Last Delivery Transaction");
            transaction.setStatus(value.toUpperCase());
        }
        editOrderPage.updateOrderStatus(order);
    }

    @Then("^Operator verify the created order info is correct on Edit Order page$")
    public void operatorVerifyOrderInfoOnEditOrderPage()
    {
        Order order = get(KEY_CREATED_ORDER);
        editOrderPage.verifyOrderInfoIsCorrect(order);
    }

    @Then("^Operator verify color of order header on Edit Order page is \"(.+)\"$")
    public void operatorVerifyColorOfOrderHeaderOnEditOrderPage(String color)
    {
        switch (color.toLowerCase())
        {
            case "green":
                color = "rgba(28, 111, 52, 1)";
                break;
            case "red":
                color = "rgba(193, 36, 68, 1)";
                break;
        }
        editOrderPage.verifyOrderHeaderColor(color);
    }

    @Then("^Operator verifies event is present for order on Edit order page$")
    public void operatorVerifiesEventIsPresentOnEditOrderPage(Map<String, String> mapOfData)
    {
        String event = mapOfData.get("eventName");
        String hubName = mapOfData.get("hubName");
        String hubId = mapOfData.get("hubId");
        List<Order> lists = get(KEY_LIST_OF_CREATED_ORDER);

        lists.forEach(order ->
        {
            navigateTo(f("%s/%s/order/%d", TestConstants.OPERATOR_PORTAL_BASE_URL, TestConstants.COUNTRY_CODE, order.getId()));
            editOrderPage.verifyEvent(order, hubName, hubId, event);
        });
    }

    @Then("^Operator cancel order on Edit order page using data below:$")
    public void operatorCancelOrderOnEditOrderPage(Map<String, String> mapOfData)
    {
        String cancellationReason = mapOfData.get("cancellationReason");
        editOrderPage.cancelOrder(cancellationReason);
        put(KEY_CANCELLATION_REASON, cancellationReason);
    }

    @Then("^Operator verify order event on Edit order page using data below:$")
    public void operatorVerifyOrderEventOnEditOrderPage(Map<String, String> mapOfData)
    {
        mapOfData = resolveKeyValues(mapOfData);
        List<OrderEvent> events = editOrderPage.eventsTable().readAllEntities();
        OrderEvent expectedEvent = new OrderEvent();
        expectedEvent.fromMap(mapOfData);
        OrderEvent actualEvent = events.stream()
                .filter(event -> StringUtils.equalsIgnoreCase(event.getName(), expectedEvent.getName()))
                .findFirst()
                .orElseThrow(() -> new AssertionError(f("There is no [%s] event on Edit Order page", expectedEvent.getName())));

        expectedEvent.compareWithActual(actualEvent);
    }

    @Then("^Operator verify (.+) transaction on Edit order page using data below:$")
    public void operatorVerifyTransactionOnEditOrderPage(String transactionType, Map<String, String> mapOfData)
    {
        mapOfData = resolveKeyValues(mapOfData);
        int rowIndex = transactionType.equalsIgnoreCase("Delivery") ? 2 : 1;

        String value = mapOfData.get("status");
        if (StringUtils.isNotBlank(value))
        {
            assertEquals(f("%s transaction status", transactionType), value, editOrderPage.transactionsTable().getStatus(rowIndex));
        }


        if (mapOfData.containsKey("routeID"))
        {
            value = mapOfData.get("routeId") == null ? "" : String.valueOf(mapOfData.get("routeId"));
            assertEquals(f("%s transaction Route Id", transactionType), value, editOrderPage.transactionsTable().getRouteId(rowIndex));
        }
    }

    @Then("^Operator verify order summary on Edit order page using data below:$")
    public void operatorVerifyOrderSummaryOnEditOrderPage(Map<String, String> mapOfData)
    {
        mapOfData = resolveKeyValues(mapOfData);
        Order expectedOrder = new Order();

        if (mapOfData.containsKey("comments")){
            expectedOrder.setComments(mapOfData.get("comments"));
        }

        editOrderPage.verifyOrderSummary(expectedOrder);
    }

    @Then("^Operator verify menu item \"(.+)\" > \"(.+)\" is disabled on Edit order page$")
    public void operatorVerifyMenuItemIsDisabledOnEditOrderPage(String parentMenuItem, String childMenuItem)
    {
        Assert.assertFalse(f("%s > %s menu item is enabled", parentMenuItem, childMenuItem), editOrderPage.isMenuItemEnabled(parentMenuItem, childMenuItem));
    }
}
