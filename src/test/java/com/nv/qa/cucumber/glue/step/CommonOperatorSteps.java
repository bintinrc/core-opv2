package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.api.client.operator_portal.OperatorPortalInboundClient;
import com.nv.qa.api.client.operator_portal.OperatorPortalRoutingClient;
import com.nv.qa.integration.client.operator.OrderClient;
import com.nv.qa.integration.model.core.Transaction;
import com.nv.qa.model.operator_portal.authentication.AuthResponse;
import com.nv.qa.model.operator_portal.global_inbound.GlobalInboundRequest;
import com.nv.qa.model.operator_portal.routing.AddParcelToRouteRequest;
import com.nv.qa.model.operator_portal.van_inbound.VanInboundRequest;
import com.nv.qa.model.order_creation.v2.Order;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.JsonHelper;
import com.nv.qa.support.ScenarioStorage;
import cucumber.api.DataTable;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import org.hamcrest.Matchers;
import org.junit.Assert;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class CommonOperatorSteps extends AbstractSteps
{
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");

    @Inject private ScenarioStorage scenarioStorage;
    private OperatorPortalInboundClient operatorPortalInboundClient;
    private OperatorPortalRoutingClient operatorPortalRoutingClient;
    private OrderClient orderClient;

    @Inject
    public CommonOperatorSteps(ScenarioManager scenarioManager, ScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        try
        {
            AuthResponse operatorAuthResponse = getOperatorAuthToken();
            operatorPortalInboundClient = new OperatorPortalInboundClient(getOperatorApiBaseUrl(), getOperatorAuthenticationUrl(), operatorAuthResponse.getAccessToken());
            operatorPortalRoutingClient = new OperatorPortalRoutingClient(getOperatorApiBaseUrl(), getOperatorAuthenticationUrl(), operatorAuthResponse.getAccessToken());
            orderClient = new OrderClient(getOperatorApiBaseUrl(), getOperatorAuthenticationUrl(), operatorAuthResponse.getAccessToken());
        }
        catch(Exception ex)
        {
            throw new RuntimeException(ex);
        }
    }

    @Given("^Operator Global Inbound parcel using data below:")
    public void operatorGlobalInboundParcel(DataTable dataTable) throws IOException
    {
        Order order = scenarioStorage.get("order");

        Map<String,String> mapOfDynamicVariable = new HashMap<>();
        mapOfDynamicVariable.put("order_tracking_id", order.getTracking_id());

        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String globalInboundRequestJson = CommonUtil.replaceParam(mapOfData.get("globalInboundRequest"), mapOfDynamicVariable);
        GlobalInboundRequest globalInboundRequest = JsonHelper.fromJson(globalInboundRequestJson, GlobalInboundRequest.class);
        operatorPortalInboundClient.globalInbound(globalInboundRequest);
    }

    @Given("^Operator add parcel to the route using data below:$")
    public void operatorAddParcelToRoute(DataTable dataTable)  throws IOException
    {
        Order order = scenarioStorage.get("order");
        int routeId = scenarioStorage.get("routeId");

        Map<String,String> mapOfDynamicVariable = new HashMap<>();
        mapOfDynamicVariable.put("order_tracking_id", order.getTracking_id());

        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String addParcelToRouteRequestJson = CommonUtil.replaceParam(mapOfData.get("addParcelToRouteRequest"), mapOfDynamicVariable);

        AddParcelToRouteRequest addParcelToRouteRequest = JsonHelper.fromJson(addParcelToRouteRequestJson, AddParcelToRouteRequest.class);
        operatorPortalRoutingClient.addParcelToRoute(routeId, addParcelToRouteRequest);
        categorizedOrderByTransactionType(addParcelToRouteRequest, order);
    }

    @When("^Operator Van Inbound  parcel$")
    public void operatorVanInboundParcel()
    {
        String trackingId = scenarioStorage.get("trackingId");
        int deliveryWaypointId = scenarioStorage.get(CommonDriverSteps.KEY_DELIVERY_WAYPOINT_ID);

        VanInboundRequest vanInboundRequest = new VanInboundRequest();
        vanInboundRequest.setTrackingId(trackingId);
        vanInboundRequest.setWaypointId(deliveryWaypointId);
        vanInboundRequest.setType("VAN_FROM_NINJAVAN");
        operatorPortalInboundClient.vanInbound(vanInboundRequest);
    }

    @When("^Operator start the route$")
    public void operatorStartTheRoute()
    {
        int routeId = scenarioStorage.get("routeId");
        operatorPortalRoutingClient.startRoute(routeId);
    }

    private void categorizedOrderByTransactionType(AddParcelToRouteRequest addParcelToRouteRequest, Order order)
    {
        String transactionType = addParcelToRouteRequest.getType();

        if("PP".equalsIgnoreCase(transactionType))
        {
            scenarioStorage.putInList("ppOrders", order);
        }
        else if("DD".equalsIgnoreCase(transactionType))
        {
            scenarioStorage.putInList("ddOrders", order);
        }
    }

    @Then("^Operator verify order info after failed pickup C2C/Return order rescheduled on next day$")
    public void operatorVerifyOrderInfoAfterFailedPickupC2cOrReturnOrderRescheduledOnNextDay()
    {
        operatorVerifyOrderInfoAfterFailedPickupC2cOrReturnOrderRescheduled(1);
    }

    @Then("^Operator verify order info after failed pickup C2C/Return order rescheduled on next 2 days$")
    public void operatorVerifyOrderInfoAfterFailedPickupC2cOrReturnOrderRescheduledOnNext2Days()
    {
        operatorVerifyOrderInfoAfterFailedPickupC2cOrReturnOrderRescheduled(2);
    }

    private void operatorVerifyOrderInfoAfterFailedPickupC2cOrReturnOrderRescheduled(int numberOfNextDays)
    {
        Order order = scenarioStorage.get("order");
        int orderId = order.getTransactions().get(0).getOrder_id();

        com.nv.qa.integration.model.core.order.operator.Order orderDetails = orderClient.getOrder(orderId);
        Assert.assertEquals("status", "PENDING", orderDetails.getStatus());
        Assert.assertEquals("granular status", "PENDING_PICKUP", orderDetails.getGranularStatus());

        List<Transaction> transactions = orderDetails.getTransactions();
        List<Transaction> listOfPickupTransactions = transactions
                .stream()
                .filter((transaction) -> "PICKUP".equals(transaction.getType()))
                .collect(Collectors.toList());

        int numberOfExpectedPickupTransactions = 2;
        int numberOfActualPickupTransactions = listOfPickupTransactions.size();
        Assert.assertEquals(String.format("Number of pickup transaction should be %d.", numberOfExpectedPickupTransactions), numberOfExpectedPickupTransactions, numberOfActualPickupTransactions);
        Transaction transactionOfFirstAttempt = listOfPickupTransactions.get(0);
        Transaction transactionOfSecondAttempt = listOfPickupTransactions.get(1);

        Assert.assertEquals("First attempt of Pickup Transaction status should be FAIL.", "FAIL", transactionOfFirstAttempt.getStatus());
        Assert.assertEquals("Second attempt of Pickup Transaction status should be PENDING.", "PENDING", transactionOfSecondAttempt.getStatus());

        Date nextDate = CommonUtil.getNextDate(numberOfNextDays);
        String newPickupStartTime = DATE_FORMAT.format(nextDate);
        String newPickupEndTime = DATE_FORMAT.format(nextDate);

        Assert.assertThat(String.format("Start Time should be next %d day(s).", numberOfNextDays), transactionOfSecondAttempt.getStartTime(), Matchers.startsWith(newPickupStartTime));
        Assert.assertThat(String.format("End Time should be next %d day(s).", numberOfNextDays), transactionOfSecondAttempt.getEndTime(), Matchers.startsWith(newPickupEndTime));
    }

    @Then("^Operator verify order info after failed delivery order rescheduled on next day$")
    public void operatorVerifyOrderInfoAfterFailedDeliveryOrderRescheduledOnNextDay()
    {
        operatorVerifyOrderInfoAfterFailedDeliveryOrderRescheduled(1);
    }

    @Then("^Operator verify order info after failed delivery order rescheduled on next 2 days$")
    public void operatorVerifyOrderInfoAfterFailedDeliveryOrderRescheduledOnNext2Days()
    {
        operatorVerifyOrderInfoAfterFailedDeliveryOrderRescheduled(2);
    }

    private void operatorVerifyOrderInfoAfterFailedDeliveryOrderRescheduled(int numberOfNextDays)
    {
        Order order = scenarioStorage.get("order");
        int orderId = order.getTransactions().get(0).getOrder_id();

        pause2s(); // Give a few time for a backend to update the order details info.
        com.nv.qa.integration.model.core.order.operator.Order orderDetails = orderClient.getOrder(orderId);
        Assert.assertEquals("status", "TRANSIT", orderDetails.getStatus());
        Assert.assertEquals("granular status", "ENROUTE_TO_SORTING_HUB", orderDetails.getGranularStatus());

        List<Transaction> transactions = orderDetails.getTransactions();
        List<Transaction> listOfDeliveryTransactions = transactions
                .stream()
                .filter((transaction) -> "DELIVERY".equals(transaction.getType()))
                .collect(Collectors.toList());

        int numberOfExpectedDeliveryTransactions = 2;
        int numberOfActualDeliveryTransactions = listOfDeliveryTransactions.size();
        Assert.assertEquals(String.format("Number of delivery transaction should be %d.", numberOfExpectedDeliveryTransactions), numberOfExpectedDeliveryTransactions, numberOfActualDeliveryTransactions);
        Transaction transactionOfFirstAttempt = listOfDeliveryTransactions.get(0);
        Transaction transactionOfSecondAttempt = listOfDeliveryTransactions.get(1);

        Assert.assertEquals("First attempt of Delivery Transaction status should be FAIL.", "FAIL", transactionOfFirstAttempt.getStatus());
        Assert.assertEquals("Second attempt of Delivery Transaction status should be PENDING.", "PENDING", transactionOfSecondAttempt.getStatus());

        Date nextDate = CommonUtil.getNextDate(numberOfNextDays);
        String newDeliveryStartTime = DATE_FORMAT.format(nextDate);
        String newDeliveryEndTime = DATE_FORMAT.format(nextDate);

        Assert.assertThat(String.format("Start Time should be next %d day(s).", numberOfNextDays), transactionOfSecondAttempt.getStartTime(), Matchers.startsWith(newDeliveryStartTime));
        Assert.assertThat(String.format("End Time should be next %d day(s).", numberOfNextDays), transactionOfSecondAttempt.getEndTime(), Matchers.startsWith(newDeliveryEndTime));
    }
}
