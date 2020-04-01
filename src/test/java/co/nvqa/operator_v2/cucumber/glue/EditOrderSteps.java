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
import java.util.Objects;
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

    @Then("^Operator verify Current DNR Group is \"(.+)\" on Edit Order page$")
    public void operatorVerifyCurrentDnrGroupOnEditOrderPage(String expected)
    {
        expected = resolveValue(expected);
        String actual = editOrderPage.currentDnrGroup.getText();
        Assert.assertThat("Current DNR Group", actual, Matchers.equalToIgnoringCase(expected));
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
            stampId = "NVSGSTAMP" + TestUtils.generateAlphaNumericString(7);
        }
        NvLogger.warn(stampId);
        editOrderPage.editOrderStamp(stampId);
        Order order = get(KEY_CREATED_ORDER);
        order.setStampId(stampId);
        put(KEY_STAMP_ID, stampId);
    }

    @When("^Operator unable to change Stamp ID of the created order to \"(.+)\" on Edit order page$")
    public void operatorUnableToEditStampIdToExistingOnEditOrderPage(String stampId)
    {
        /*
          Replace searchTerm value to value on ScenarioStorage.
         */
        String trackingIdOfExistingOrder = get(KEY_TRACKING_ID_BY_ACCESSING_STAMP_ID);
        if (containsKey(stampId))
        {
            if (StringUtils.equalsIgnoreCase(stampId, "KEY_ANOTHER_ORDER_TRACKING_ID"))
            {
                trackingIdOfExistingOrder = get(stampId);
            }
            stampId = get(stampId);
        }
        editOrderPage.editOrderStampToExisting(stampId, trackingIdOfExistingOrder);
    }

    @When("^Operator remove Stamp ID of the created order on Edit order page$")
    public void operatorRemoveStampIdOnEditOrderPage()
    {
        editOrderPage.removeOrderStamp();
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

    @And("Operator does the Manually Complete Order from Edit Order Page")
    public void operatorDoesTheManuallyCompleteOrderFromEditOrderPage()
    {
        editOrderPage.manuallyCompleteOrder();
    }

    @And("Operator selects the Route Tags of \"([^\"]*)\" from the Route Finder")
    public void operatorSelectTheRouteTagsOfFromTheRouteFinder(String routeTag)
    {
        editOrderPage.addToRouteFromRouteTag(routeTag);
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

    @Then("^Operator verify (Pickup|Delivery) \"(.+)\" order event description on Edit order page$")
    public void operatorVerifyOrderEventOnEditOrderPage(String type, String expectedEventName)
    {
        Order order = get(KEY_CREATED_ORDER);
        List<OrderEvent> events = editOrderPage.eventsTable().readAllEntities();
        OrderEvent actualEvent = events.stream()
                .filter(event -> StringUtils.equalsIgnoreCase(event.getName(), expectedEventName))
                .findFirst()
                .orElseThrow(() -> new AssertionError(f("There is no [%s] event on Edit Order page", expectedEventName)));
        String eventDescription = actualEvent.getDescription();
        if (StringUtils.equalsIgnoreCase(type, "Pickup"))
        {
            if (StringUtils.equalsIgnoreCase(expectedEventName, "UPDATE ADDRESS"))
            {
                editOrderPage.eventsTable().verifyUpdatePickupAddressEventDescription(order, eventDescription);
            }
            if (StringUtils.equalsIgnoreCase(expectedEventName, "UPDATE CONTACT INFORMATION"))
            {
                editOrderPage.eventsTable().verifyUpdatePickupContactInformationEventDescription(order, eventDescription);
            }
            if (StringUtils.equalsIgnoreCase(expectedEventName, "UPDATE SLA"))
            {
                editOrderPage.eventsTable().verifyUpdatePickupSlaEventDescription(order, eventDescription);
            }
            if (StringUtils.equalsIgnoreCase(expectedEventName, "VERIFY ADDRESS"))
            {
                editOrderPage.eventsTable().verifyPickupAddressEventDescription(order, eventDescription);
            }
        } else
        {
            if (StringUtils.equalsIgnoreCase(expectedEventName, "UPDATE ADDRESS"))
            {
                editOrderPage.eventsTable().verifyUpdateDeliveryAddressEventDescription(order, eventDescription);
            }
            if (StringUtils.equalsIgnoreCase(expectedEventName, "UPDATE CONTACT INFORMATION"))
            {
                editOrderPage.eventsTable().verifyUpdateDeliveryContactInformationEventDescription(order, eventDescription);
            }
            if (StringUtils.equalsIgnoreCase(expectedEventName, "UPDATE SLA"))
            {
                editOrderPage.eventsTable().verifyUpdateDeliverySlaEventDescription(order, eventDescription);
            }
            if (StringUtils.equalsIgnoreCase(expectedEventName, "VERIFY ADDRESS"))
            {
                editOrderPage.eventsTable().verifyDeliveryAddressEventDescription(order, eventDescription);
            }
        }
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
        if (mapOfData.containsKey("routeId"))
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

        if (mapOfData.containsKey("comments"))
        {
            expectedOrder.setComments(mapOfData.get("comments"));
        }

        editOrderPage.verifyOrderSummary(expectedOrder);
    }

    @Then("Operator verifies the status of the order will be Completed")
    public void operatorVerifiesTheStatusOfTheOrderWillBeCompleted()
    {
        editOrderPage.verifyOrderStatus("Completed");
    }

    @Then("Operator verifies the route is tagged to the order")
    public void operatorVerifiesTheRouteIsTaggedToTheOrder()
    {
        editOrderPage.verifiesOrderIsTaggedToTheRecommendedRouteId();
    }

    @Then("^Operator verify menu item \"(.+)\" > \"(.+)\" is disabled on Edit order page$")
    public void operatorVerifyMenuItemIsDisabledOnEditOrderPage(String parentMenuItem, String childMenuItem)
    {
        Assert.assertFalse(f("%s > %s menu item is enabled", parentMenuItem, childMenuItem), editOrderPage.isMenuItemEnabled(parentMenuItem, childMenuItem));
    }

    @Then("^Operator update Pickup Details on Edit Order Page$")
    public void operatorUpdatePickupDetailsOnEditOrderPage(Map<String, String> mapOfData)
    {
        Map<String, String> mapOfTokens = createDefaultTokens();
        mapOfData = replaceDataTableTokens(mapOfData, mapOfTokens);
        editOrderPage.updatePickupDetails(mapOfData);
        Order order = get(KEY_CREATED_ORDER);
        String senderName = mapOfData.get("senderName");
        String senderContact = mapOfData.get("senderContact");
        String senderEmail = mapOfData.get("senderEmail");
        String internalNotes = mapOfData.get("internalNotes");
        String pickupDate = mapOfData.get("pickupDate");
        String pickupTimeslot = mapOfData.get("pickupTimeslot");
        String country = mapOfData.get("country");
        String city = mapOfData.get("city");
        String address1 = mapOfData.get("address1");
        String address2 = mapOfData.get("address2");
        String postalCode = mapOfData.get("postalCode");

        if (Objects.nonNull(senderName))
        {
            order.setFromName(senderName);
        }
        if (Objects.nonNull(senderContact))
        {
            order.setFromContact(senderContact);
        }
        if (Objects.nonNull(senderEmail))
        {
            order.setFromEmail(senderEmail);
        }
//        if (Objects.nonNull(internalNotes)) {order.setComments(internalNotes);}
        if (Objects.nonNull(pickupDate))
        {
            order.setPickupDate(pickupDate);
        }
        if (Objects.nonNull(pickupTimeslot))
        {
            order.setPickupTimeslot(pickupTimeslot);
        }
        if (Objects.nonNull(address1))
        {
            order.setFromAddress1(address1);
        }
        if (Objects.nonNull(address2))
        {
            order.setFromAddress2(address2);
        }
        if (Objects.nonNull(postalCode))
        {
            order.setFromPostcode(postalCode);
        }
        if (Objects.nonNull(city))
        {
            order.setFromCity(city);
        }
        if (Objects.nonNull(country))
        {
            order.setFromCountry(country);
        }
        put(KEY_CREATED_ORDER, order);
    }

    @Then("^Operator update Delivery Details on Edit Order Page$")
    public void operatorUpdateDeliveryDetailsOnEditOrderPage(Map<String, String> mapOfData)
    {
        Map<String, String> mapOfTokens = createDefaultTokens();
        mapOfData = replaceDataTableTokens(mapOfData, mapOfTokens);
        editOrderPage.updateDeliveryDetails(mapOfData);
        Order order = get(KEY_CREATED_ORDER);
        String recipientName = mapOfData.get("recipientName");
        String recipientContact = mapOfData.get("recipientContact");
        String recipientEmail = mapOfData.get("recipientEmail");
        String internalNotes = mapOfData.get("internalNotes");
        String changeSchedule = mapOfData.get("changeSchedule");
        String deliveryDate = mapOfData.get("deliveryDate");
        String deliveryTimeslot = mapOfData.get("deliveryTimeslot");
        String country = mapOfData.get("country");
        String city = mapOfData.get("city");
        String address1 = mapOfData.get("address1");
        String address2 = mapOfData.get("address2");
        String postalCode = mapOfData.get("postalCode");

        if (Objects.nonNull(recipientName))
        {
            order.setToName(recipientName);
        }
        if (Objects.nonNull(recipientContact))
        {
            order.setToContact(recipientContact);
        }
        if (Objects.nonNull(recipientEmail))
        {
            order.setToEmail(recipientEmail);
        }
//        if (Objects.nonNull(internalNotes)) {order.setComments(internalNotes);}
        if (Objects.nonNull(deliveryDate))
        {
            order.setDeliveryDate(deliveryDate);
        }
        if (Objects.nonNull(deliveryTimeslot))
        {
            order.setDeliveryTimeslot(deliveryTimeslot);
        }
        if (Objects.nonNull(address1))
        {
            order.setToAddress1(address1);
        }
        if (Objects.nonNull(address2))
        {
            order.setToAddress2(address2);
        }
        if (Objects.nonNull(postalCode))
        {
            order.setToPostcode(postalCode);
        }
        if (Objects.nonNull(city))
        {
            order.setToCity(city);
        }
        if (Objects.nonNull(country))
        {
            order.setToCountry(country);
        }
        put(KEY_CREATED_ORDER, order);
    }

    @Then("^Operator verifies Pickup Details are updated on Edit Order Page$")
    public void operatorVerifiesPickupDetailsUpdated()
    {
        Order order = get(KEY_CREATED_ORDER);
        editOrderPage.verifyPickupInfo(order);
    }

    @Then("^Operator verifies Delivery Details are updated on Edit Order Page$")
    public void operatorVerifiesDeliveryDetailsUpdated()
    {
        Order order = get(KEY_CREATED_ORDER);
        editOrderPage.verifyDeliveryInfo(order);
    }

    @Then("^Operator verifies (Pickup|Delivery) Transaction is updated on Edit Order Page$")
    public void operatorVerifiesTransactionUpdated(String txnType)
    {
        Order order = get(KEY_CREATED_ORDER);
        if (StringUtils.equalsIgnoreCase(txnType, "Pickup"))
        {
            editOrderPage.verifyPickupDetailsInTransaction(order, txnType);
        } else
        {
            editOrderPage.verifyDeliveryDetailsInTransaction(order, txnType);
        }
    }

    @Then("^Operator tags order to \"(.+)\" DP on Edit Order Page$")
    public void operatorTagOrderToDP(String dpId)
    {
        editOrderPage.tagOrderToDP(dpId);
    }

    @Then("^Operator untags order from DP on Edit Order Page$")
    public void operatorUnTagOrderFromDP()
    {
        editOrderPage.untagOrderFromDP();
    }

    @Then("^Operator verifies delivery (is|is not) indicated by 'Ninja Collect' icon on Edit Order Page$")
    public void deliveryIsIndicatedByIcon(String indicationValue)
    {
        if (Objects.equals(indicationValue, "is"))
        {
            assertTrue("Expected that Delivery is indicated by 'Ninja Collect' icon on Edit Order Page",
                    editOrderPage.deliveryIsIndicatedWithIcon());
        } else if (Objects.equals(indicationValue, "is not"))
        {
            assertFalse("Expected that Delivery is not indicated by 'Ninja Collect' icon on Edit Order Page",
                    editOrderPage.deliveryIsIndicatedWithIcon());
        }
    }

    @Then("^Operator delete order on Edit Order Page$")
    public void operatorDeleteOrder()
    {
        editOrderPage.deleteOrder();
    }

    @Then("^Operator reschedule Pickup on Edit Order Page$")
    public void operatorReschedulePickupOnEditOrderPage(Map<String, String> mapOfData)
    {
        Map<String, String> mapOfTokens = createDefaultTokens();
        mapOfData = replaceDataTableTokens(mapOfData, mapOfTokens);
        editOrderPage.reschedulePickup(mapOfData);
        Order order = get(KEY_CREATED_ORDER);
        String senderName = mapOfData.get("senderName");
        String senderContact = mapOfData.get("senderContact");
        String senderEmail = mapOfData.get("senderEmail");
        String pickupDate = mapOfData.get("pickupDate");
        String pickupTimeslot = mapOfData.get("pickupTimeslot");
        String country = mapOfData.get("country");
        String city = mapOfData.get("city");
        String address1 = mapOfData.get("address1");
        String address2 = mapOfData.get("address2");
        String postalCode = mapOfData.get("postalCode");

        if (Objects.nonNull(senderName))
        {
            order.setFromName(senderName);
        }
        if (Objects.nonNull(senderContact))
        {
            order.setFromContact(senderContact);
        }
        if (Objects.nonNull(senderEmail))
        {
            order.setFromEmail(senderEmail);
        }
        if (Objects.nonNull(pickupDate))
        {
            order.setPickupDate(pickupDate);
        }
        if (Objects.nonNull(pickupTimeslot))
        {
            order.setPickupTimeslot(pickupTimeslot);
        }
        if (Objects.nonNull(address1))
        {
            order.setFromAddress1(address1);
        }
        if (Objects.nonNull(address2))
        {
            order.setFromAddress2(address2);
        }
        if (Objects.nonNull(postalCode))
        {
            order.setFromPostcode(postalCode);
        }
        if (Objects.nonNull(city))
        {
            order.setFromCity(city);
        }
        if (Objects.nonNull(country))
        {
            order.setFromCountry(country);
        }
        put(KEY_CREATED_ORDER, order);
    }

    @Then("^Operator reschedule Delivery on Edit Order Page$")
    public void operatorRescheduleDeliveryOnEditOrderPage(Map<String, String> mapOfData)
    {
        Map<String, String> mapOfTokens = createDefaultTokens();
        mapOfData = replaceDataTableTokens(mapOfData, mapOfTokens);
        editOrderPage.rescheduleDelivery(mapOfData);
        Order order = get(KEY_CREATED_ORDER);
        String recipientName = mapOfData.get("recipientName");
        String recipientContact = mapOfData.get("recipientContact");
        String recipientEmail = mapOfData.get("recipientEmail");
        String deliveryDate = mapOfData.get("deliveryDate");
        String deliveryTimeslot = mapOfData.get("deliveryTimeslot");
        String country = mapOfData.get("country");
        String city = mapOfData.get("city");
        String address1 = mapOfData.get("address1");
        String address2 = mapOfData.get("address2");
        String postalCode = mapOfData.get("postalCode");

        if (Objects.nonNull(recipientName))
        {
            order.setToName(recipientName);
        }
        if (Objects.nonNull(recipientContact))
        {
            order.setToContact(recipientContact);
        }
        if (Objects.nonNull(recipientEmail))
        {
            order.setToEmail(recipientEmail);
        }
        if (Objects.nonNull(deliveryDate))
        {
            order.setDeliveryDate(deliveryDate);
        }
        if (Objects.nonNull(deliveryTimeslot))
        {
            order.setDeliveryTimeslot(deliveryTimeslot);
        }
        if (Objects.nonNull(address1))
        {
            order.setToAddress1(address1);
        }
        if (Objects.nonNull(address2))
        {
            order.setToAddress2(address2);
        }
        if (Objects.nonNull(postalCode))
        {
            order.setToPostcode(postalCode);
        }
        if (Objects.nonNull(city))
        {
            order.setToCity(city);
        }
        if (Objects.nonNull(country))
        {
            order.setToCountry(country);
        }
        put(KEY_CREATED_ORDER, order);
    }

    @Then("^Operator pull out parcel from the route for (Pickup|Delivery) on Edit Order page$")
    public void operatorPullsOrderFromRouteOnEditOrderPage(String txnType)
    {
        Order createdOrder = get(KEY_CREATED_ORDER);
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        editOrderPage.pullOutParcelFromTheRoute(createdOrder, txnType, routeId);
    }

    @When("^Operator verify next order info on Edit order page:$")
    public void operatorVerifyOrderInfoOnEditOrderPage(Map<String, String> mapOfData)
    {
        mapOfData = resolveKeyValues(mapOfData);
        String fieldToValidate = mapOfData.get("stampId");
        if (StringUtils.isNotBlank(fieldToValidate))
        {
            assertEquals("StampId value is not as expected", fieldToValidate, editOrderPage.getStampId());
        }
    }

    @When("Operator change the COP value to {string}")
    public void OperatorChangeTheCopValue(String copValue)
    {
        Integer copValueToString = Integer.parseInt(copValue);
        editOrderPage.changeCopValue(copValueToString);
    }

    @When("Operator change the COD value to {string}")
    public void OperatorChangeTheCodValue(String codValue)
    {
        Integer codValueToString = Integer.parseInt(codValue);
        editOrderPage.changeCodValue(codValueToString);
    }

    @Then("Operator verify COP value is updated to {string}")
    public void VerifyCopUpdated(String copValue)
    {
        Integer copValueToString = Integer.parseInt(copValue);
        editOrderPage.verifyCopUpdated(copValueToString);
    }

    @Then("Operator verify COD value is updated to {string}")
    public void VerifyCodUpdated(String codValue)
    {
        Integer codValueToString = Integer.parseInt(codValue);
        editOrderPage.verifyCodUpdated(codValueToString);
    }

    @Then("^Operator verify \"(.+)\" order event description on Edit order page$")
    public void OperatorVerifyOrderEvent(String expectedEventName)
    {
        Order order = get(KEY_CREATED_ORDER);
        List<OrderEvent> events = editOrderPage.eventsTable().readAllEntities();
        OrderEvent actualEvent = events.stream()
                .filter(event -> StringUtils.equalsIgnoreCase(event.getName(), expectedEventName))
                .findFirst()
                .orElseThrow(() -> new AssertionError(f("There is no [%s] event on Edit Order page", expectedEventName)));
        String eventDescription = actualEvent.getDescription();
        if (StringUtils.equalsIgnoreCase(expectedEventName, "UPDATE CASH"))
        {
            editOrderPage.eventsTable().verifyVerifyUpdateCashDescription(order, eventDescription);
        }
    }

    @When("Operator change Cash on Pickup toggle to yes")
    public void ChangeCopToggleToYes()
    {
        editOrderPage.changeCopToggleToYes();
    }

    @When("Operator change Cash on Delivery toggle to yes")
    public void ChangeCodToggleToYes()
    {
        editOrderPage.changeCodToggleToYes();
    }

    @When("Operator change Cash on Delivery toggle to no")
    public void ChangeCodToggleToNo()
    {
        editOrderPage.changeCodToggleToNo();
    }

    @When("Operator change Cash on Pickup toggle to no")
    public void ChangeCopToggleToNo()
    {
        editOrderPage.changeCopToggleToNo();
    }
}
