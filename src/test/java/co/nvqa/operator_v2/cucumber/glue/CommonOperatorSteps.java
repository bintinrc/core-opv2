package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.api.client.operator_portal.OperatorPortalInboundClient;
import co.nvqa.operator_v2.api.client.operator_portal.OperatorPortalRoutingClient;
import co.nvqa.operator_v2.database.CoreJdbc;
import co.nvqa.operator_v2.model.entity.TransactionEntity;
import co.nvqa.operator_v2.model.operator_portal.global_inbound.GlobalInboundRequest;
import co.nvqa.operator_v2.model.operator_portal.routing.AddParcelToRouteRequest;
import co.nvqa.operator_v2.model.operator_portal.van_inbound.VanInboundRequest;
import co.nvqa.operator_v2.support.CommonUtil;
import co.nvqa.operator_v2.support.JsonHelper;
import co.nvqa.operator_v2.support.ScenarioStorage;
import com.google.inject.Inject;
import co.nvqa.operator_v2.integration.client.operator.OrderClient;
import co.nvqa.operator_v2.integration.model.core.Transaction;
import co.nvqa.operator_v2.model.operator_portal.authentication.AuthResponse;
import co.nvqa.operator_v2.support.TestConstants;
import co.nvqa.operator_v2.utils.AnonymousResult;
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
    private CoreJdbc coreJdbc;

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
            coreJdbc = new CoreJdbc(TestConstants.DB_DRIVER, TestConstants.DB_URL_CORE, TestConstants.DB_USER, TestConstants.DB_PASS);
        }
        catch(Exception ex)
        {
            throw new RuntimeException(ex);
        }
    }

    @Given("^Operator Global Inbound parcel using data below:")
    @SuppressWarnings("unchecked")
    public void operatorGlobalInboundParcel(DataTable dataTable) throws IOException
    {
        String trackingId = scenarioStorage.get("trackingId");

        Map<String,String> mapOfDynamicVariable = new HashMap<>();
        mapOfDynamicVariable.put("order_tracking_id", trackingId);

        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String globalInboundRequestJson = CommonUtil.replaceParam(mapOfData.get("globalInboundRequest"), mapOfDynamicVariable);
        GlobalInboundRequest globalInboundRequest = JsonHelper.fromJson(globalInboundRequestJson, GlobalInboundRequest.class);
        CommonUtil.retryIfExpectedExceptionOccurred(()->operatorPortalInboundClient.globalInbound(globalInboundRequest), String.format("operatorGlobalInboundParcel - [Tracking ID = %s]", trackingId), getScenarioManager()::writeToScenarioLog, AssertionError.class);
    }

    @Given("^Operator add parcel to the route using data below:$")
    @SuppressWarnings("unchecked")
    public void operatorAddParcelToRoute(DataTable dataTable)  throws IOException
    {
        co.nvqa.operator_v2.model.order_creation.v2.Order order = scenarioStorage.get("order");
        String trackingId = scenarioStorage.get("trackingId");
        int routeId = scenarioStorage.get("routeId");

        Map<String,String> mapOfDynamicVariable = new HashMap<>();
        mapOfDynamicVariable.put("order_tracking_id", trackingId);

        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String addParcelToRouteRequestJson = CommonUtil.replaceParam(mapOfData.get("addParcelToRouteRequest"), mapOfDynamicVariable);

        AddParcelToRouteRequest addParcelToRouteRequest = JsonHelper.fromJson(addParcelToRouteRequestJson, AddParcelToRouteRequest.class);
        String methodInfo = String.format("operatorAddParcelToRoute - [Tracking ID = %s] - [Route ID = %d] - [Type = %s]", trackingId, routeId, addParcelToRouteRequest.getType());
        CommonUtil.retryIfExpectedExceptionOccurred(()->operatorPortalRoutingClient.addParcelToRoute(routeId, addParcelToRouteRequest), methodInfo, getScenarioManager()::writeToScenarioLog, AssertionError.class);
        categorizedOrderByTransactionType(addParcelToRouteRequest, order);
    }

    @When("^Operator Van Inbound  parcel$")
    @SuppressWarnings("unchecked")
    public void operatorVanInboundParcel()
    {
        String trackingId = scenarioStorage.get("trackingId");
        int deliveryWaypointId = scenarioStorage.get(CommonDriverSteps.KEY_DELIVERY_WAYPOINT_ID);

        CommonUtil.retryIfExpectedExceptionOccurred(()->
        {
            VanInboundRequest vanInboundRequest = new VanInboundRequest();
            vanInboundRequest.setTrackingId(trackingId);
            vanInboundRequest.setWaypointId(deliveryWaypointId);
            vanInboundRequest.setType("VAN_FROM_NINJAVAN");
            operatorPortalInboundClient.vanInbound(vanInboundRequest);
        }, String.format("operatorVanInboundParcel - [Tracking ID = %s]", trackingId), getScenarioManager()::writeToScenarioLog, AssertionError.class, RuntimeException.class);
    }

    @When("^Operator start the route$")
    @SuppressWarnings("unchecked")
    public void operatorStartTheRoute()
    {
        int routeId = scenarioStorage.get("routeId");

        CommonUtil.retryIfExpectedExceptionOccurred(()->
        {
            operatorPortalRoutingClient.startRoute(routeId);
        }, String.format("operatorStartTheRoute - [Route ID = %d]", routeId), getScenarioManager()::writeToScenarioLog, AssertionError.class, RuntimeException.class);
    }

    private void categorizedOrderByTransactionType(AddParcelToRouteRequest addParcelToRouteRequest, co.nvqa.operator_v2.model.order_creation.v2.Order order)
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

    private co.nvqa.operator_v2.integration.model.core.order.operator.Order getOrderDetails(int orderId, String expectedStatus, String expectedGranularStatus)
    {
        AnonymousResult<co.nvqa.operator_v2.integration.model.core.order.operator.Order> result = new AnonymousResult<>();
        pause2s(); // Give a few time for a backend to update the order details info.

        CommonUtil.retryIfRuntimeExceptionOccurred(()->
        {
            co.nvqa.operator_v2.integration.model.core.order.operator.Order order = orderClient.getOrder(orderId);
            String actualStatus = order.getStatus();
            String actualGranularStatus = order.getGranularStatus();

            if(actualStatus.equals(expectedStatus) && actualGranularStatus.equals(expectedGranularStatus))
            {
                result.setValue(order);
            }
            else
            {
                String errorMessage = String.format("Status and Granular Status of order with ID = '%d' is not matched the expected value.\n[STATUS]\nExpected: %s\nActual  : %s\n\n[GRANULAR STATUS]\nExpected: %s\nActual  : %s", orderId, expectedStatus, actualStatus, expectedGranularStatus, actualGranularStatus);
                throw new RuntimeException(errorMessage);
            }
        }, String.format("getOrderDetails - [Order ID = %d]", orderId), getScenarioManager()::writeToScenarioLog);

        return result.getValue();
    }

    @Then("^Operator verify order info after Global Inbound$")
    @SuppressWarnings("unchecked")
    public void operatorVerifyOrderInfoAfterGlobalInbound()
    {
        co.nvqa.operator_v2.model.order_creation.v2.Order order = scenarioStorage.get("order");
        int orderId = order.getTransactions().get(0).getOrder_id();
        String trackingId = order.getTracking_id();

        CommonUtil.retryIfExpectedExceptionOccurred(()->
        {
            co.nvqa.operator_v2.integration.model.core.order.operator.Order orderDetails = orderClient.getOrder(orderId);
            Assert.assertEquals(String.format("Status - [Tracking ID = %s]", trackingId), "TRANSIT", orderDetails.getStatus());
            Assert.assertThat(String.format("Granular Status - [Tracking ID = %s]", trackingId), orderDetails.getGranularStatus(), Matchers.anyOf(Matchers.equalTo("ARRIVED_AT_SORTING_HUB"), Matchers.equalTo("ARRIVED_AT_ORIGIN_HUB")));

            List<Transaction> transactions = orderDetails.getTransactions();
            Transaction pickupTransaction = null;

            for(Transaction transaction : transactions)
            {
                if("PICKUP".equals(transaction.getType()))
                {
                    pickupTransaction = transaction;
                    break;
                }
            }

            if(pickupTransaction==null)
            {
                Assert.fail(String.format("Pickup transaction not found for order with tracking ID '%s'.", trackingId));
            }
            else
            {
                Assert.assertEquals(String.format("Pickup transaction status - [Tracking ID = %s]", trackingId), "SUCCESS", pickupTransaction.getStatus());
            }
        }, String.format("operatorVerifyOrderInfoAfterGlobalInbound - [Tracking ID = %s]", trackingId), getScenarioManager()::writeToScenarioLog, AssertionError.class, RuntimeException.class);
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
        co.nvqa.operator_v2.model.order_creation.v2.Order order = scenarioStorage.get("order");
        int orderId = order.getTransactions().get(0).getOrder_id();
        String trackingId = order.getTracking_id();

        String expectedStatus = "PENDING";
        String expectedGranularStatus = "PENDING_PICKUP";
        co.nvqa.operator_v2.integration.model.core.order.operator.Order orderDetails = getOrderDetails(orderId, expectedStatus, expectedGranularStatus);

        Assert.assertEquals(String.format("Status - [Tracking ID = %s]", trackingId), expectedStatus, orderDetails.getStatus());
        Assert.assertEquals(String.format("Granular Status - [Tracking ID = %s]", trackingId), expectedGranularStatus, orderDetails.getGranularStatus());

        List<Transaction> transactions = orderDetails.getTransactions();
        List<Transaction> listOfPickupTransactions = transactions
                .stream()
                .filter((transaction) -> "PICKUP".equals(transaction.getType()))
                .collect(Collectors.toList());

        int numberOfExpectedPickupTransactions = 2;
        int numberOfActualPickupTransactions = listOfPickupTransactions.size();
        Assert.assertEquals(String.format("Number of pickup transaction should be %d. [Tracking ID = %s]", numberOfExpectedPickupTransactions, trackingId), numberOfExpectedPickupTransactions, numberOfActualPickupTransactions);
        Transaction transactionOfFirstAttempt = listOfPickupTransactions.get(0);
        Transaction transactionOfSecondAttempt = listOfPickupTransactions.get(1);

        Assert.assertEquals(String.format("First attempt of Pickup Transaction status should be FAIL. [Tracking ID = %s]", trackingId), "FAIL", transactionOfFirstAttempt.getStatus());
        Assert.assertEquals(String.format("Second attempt of Pickup Transaction status should be PENDING. [Tracking ID = %s]", trackingId), "PENDING", transactionOfSecondAttempt.getStatus());

        Date nextDate = CommonUtil.getNextDate(numberOfNextDays);
        String newPickupStartTime = DATE_FORMAT.format(nextDate);
        String newPickupEndTime = DATE_FORMAT.format(nextDate);

        Assert.assertThat(String.format("Start Time should be next %d day(s). [Tracking ID = %s]", numberOfNextDays, trackingId), transactionOfSecondAttempt.getStartTime(), Matchers.startsWith(newPickupStartTime));
        Assert.assertThat(String.format("End Time should be next %d day(s). [Tracking ID = %s]", numberOfNextDays, trackingId), transactionOfSecondAttempt.getEndTime(), Matchers.startsWith(newPickupEndTime));
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
        co.nvqa.operator_v2.model.order_creation.v2.Order order = scenarioStorage.get("order");
        int orderId = order.getTransactions().get(0).getOrder_id();
        String trackingId = order.getTracking_id();

        String expectedStatus = "TRANSIT";
        String expectedGranularStatus = "ENROUTE_TO_SORTING_HUB";
        co.nvqa.operator_v2.integration.model.core.order.operator.Order orderDetails = getOrderDetails(orderId, expectedStatus, expectedGranularStatus);

        Assert.assertEquals(String.format("Status - [Tracking ID = %s]", trackingId), expectedStatus, orderDetails.getStatus());
        Assert.assertEquals(String.format("Granular Status - [Tracking ID = %s]", trackingId), expectedGranularStatus, orderDetails.getGranularStatus());

        List<Transaction> transactions = orderDetails.getTransactions();
        List<Transaction> listOfDeliveryTransactions = transactions
                .stream()
                .filter((transaction) -> "DELIVERY".equals(transaction.getType()))
                .collect(Collectors.toList());

        int numberOfExpectedDeliveryTransactions = 2;
        int numberOfActualDeliveryTransactions = listOfDeliveryTransactions.size();
        Assert.assertEquals(String.format("Number of delivery transaction should be %d. [Tracking ID = %s]", numberOfExpectedDeliveryTransactions, trackingId), numberOfExpectedDeliveryTransactions, numberOfActualDeliveryTransactions);
        Transaction transactionOfFirstAttempt = listOfDeliveryTransactions.get(0);
        Transaction transactionOfSecondAttempt = listOfDeliveryTransactions.get(1);

        Assert.assertEquals(String.format("First attempt of Delivery Transaction status should be FAIL. [Tracking ID = %s]", trackingId), "FAIL", transactionOfFirstAttempt.getStatus());
        Assert.assertEquals(String.format("Second attempt of Delivery Transaction status should be PENDING. [Tracking ID = %s]", trackingId), "PENDING", transactionOfSecondAttempt.getStatus());

        Date nextDate = CommonUtil.getNextDate(numberOfNextDays);
        String newDeliveryStartTime = DATE_FORMAT.format(nextDate);
        String newDeliveryEndTime = DATE_FORMAT.format(nextDate);

        Assert.assertThat(String.format("Start Time should be next %d day(s). [Tracking ID = %s]", numberOfNextDays, trackingId), transactionOfSecondAttempt.getStartTime(), Matchers.startsWith(newDeliveryStartTime));
        Assert.assertThat(String.format("End Time should be next %d day(s). [Tracking ID = %s]", numberOfNextDays, trackingId), transactionOfSecondAttempt.getEndTime(), Matchers.startsWith(newDeliveryEndTime));
    }

    @Then("^Operator verify order info after failed delivery order RTS-ed on next day$")
    public void operatorVerifyOrderInfoAfterFailedDeliveryOrderRtsedOnNextDay()
    {
        co.nvqa.operator_v2.model.order_creation.v2.Order order = scenarioStorage.get("order");
        int orderId = order.getTransactions().get(0).getOrder_id();
        String trackingId = order.getTracking_id();

        String expectedStatus = "TRANSIT";
        String expectedGranularStatus = "ENROUTE_TO_SORTING_HUB";
        co.nvqa.operator_v2.integration.model.core.order.operator.Order orderDetails = getOrderDetails(orderId, expectedStatus, expectedGranularStatus);

        Assert.assertEquals(String.format("Status - [Tracking ID = %s]", trackingId), expectedStatus, orderDetails.getStatus());
        Assert.assertEquals(String.format("Granular Status - [Tracking ID = %s]", trackingId), expectedGranularStatus, orderDetails.getGranularStatus());
        Assert.assertTrue(String.format("RTS should be true - [Tracking ID = %s]", trackingId), orderDetails.getRts());

        List<Transaction> transactions = orderDetails.getTransactions();
        List<Transaction> listOfDeliveryTransactions = transactions
                .stream()
                .filter((transaction) -> "DELIVERY".equals(transaction.getType()))
                .collect(Collectors.toList());

        int numberOfExpectedDeliveryTransactions = 2;
        int numberOfActualDeliveryTransactions = listOfDeliveryTransactions.size();
        Assert.assertEquals(String.format("Number of delivery transaction should be %d. [Tracking ID = %s]", numberOfExpectedDeliveryTransactions, trackingId), numberOfExpectedDeliveryTransactions, numberOfActualDeliveryTransactions);
        Transaction transactionOfFirstAttempt = listOfDeliveryTransactions.get(0);
        Transaction transactionOfSecondAttempt = listOfDeliveryTransactions.get(1);

        Assert.assertEquals(String.format("First attempt of Delivery Transaction status should be FAIL. [Tracking ID = %s]", trackingId), "FAIL", transactionOfFirstAttempt.getStatus());
        Assert.assertEquals(String.format("Second attempt of Delivery Transaction status should be PENDING. [Tracking ID = %s]", trackingId), "PENDING", transactionOfSecondAttempt.getStatus());

        Date nextDate = CommonUtil.getNextDate(1);
        String newDeliveryStartTime = DATE_FORMAT.format(nextDate)+"T07:00:00Z";
        String newDeliveryEndTime = DATE_FORMAT.format(nextDate)+"T10:00:00Z";

        Assert.assertThat(String.format("Start Time should be next %d day(s). [Tracking ID = %s]", 1, trackingId), transactionOfSecondAttempt.getStartTime(), Matchers.equalTo(newDeliveryStartTime));
        Assert.assertThat(String.format("End Time should be next %d day(s). [Tracking ID = %s]", 1, trackingId), transactionOfSecondAttempt.getEndTime(), Matchers.equalTo(newDeliveryEndTime));

        TransactionEntity transactionEntity = coreJdbc.findTransactionById(transactionOfSecondAttempt.getId());
        Assert.assertEquals(String.format("RTS - Name - [Tracking ID = %s]", trackingId), order.getFrom_name()+" (RTS)", transactionEntity.getName());
        Assert.assertEquals(String.format("RTS - Email - [Tracking ID = %s]", trackingId), order.getTo_email(), transactionEntity.getEmail());
        Assert.assertEquals(String.format("RTS - Contact - [Tracking ID = %s]", trackingId), order.getFrom_contact(), transactionEntity.getContact());
        Assert.assertEquals(String.format("RTS - Address 1 - [Tracking ID = %s]", trackingId), order.getFrom_address1(), transactionEntity.getAddress1());
        Assert.assertEquals(String.format("RTS - Address 2 - [Tracking ID = %s]", trackingId), order.getFrom_address2(), transactionEntity.getAddress2());
        Assert.assertEquals(String.format("RTS - City - [Tracking ID = %s]", trackingId), order.getFrom_city(), transactionEntity.getCity());
        Assert.assertEquals(String.format("RTS - Country - [Tracking ID = %s]", trackingId), order.getFrom_country(), transactionEntity.getCountry());
    }

    @Then("^Operator verify order info after failed delivery aged parcel global inbounded and rescheduled on next day$")
    public void operatorVerifyOrderInfoAfterFailedDeliveryAgedParcelGlobalInboundedAndRescheduledOnNextDay()
    {
        operatorVerifyOrderInfoAfterFailedDeliveryAgedParcelGlobalInboundedAndRescheduled(1);
    }

    @Then("^Operator verify order info after failed delivery aged parcel global inbounded and rescheduled on next 2 days$")
    public void operatorVerifyOrderInfoAfterFailedDeliveryAgedParcelGlobalInboundedAndRescheduledOnNext2Days()
    {
        operatorVerifyOrderInfoAfterFailedDeliveryAgedParcelGlobalInboundedAndRescheduled(2);
    }

    private void operatorVerifyOrderInfoAfterFailedDeliveryAgedParcelGlobalInboundedAndRescheduled(int numberOfNextDays)
    {
        co.nvqa.operator_v2.model.order_creation.v2.Order order = scenarioStorage.get("order");
        int orderId = order.getTransactions().get(0).getOrder_id();
        String trackingId = order.getTracking_id();

        String expectedStatus = "TRANSIT";
        String expectedGranularStatus = "ARRIVED_AT_SORTING_HUB";
        co.nvqa.operator_v2.integration.model.core.order.operator.Order orderDetails = getOrderDetails(orderId, expectedStatus, expectedGranularStatus);

        Assert.assertEquals(String.format("Status - [Tracking ID = %s]", trackingId), expectedStatus, orderDetails.getStatus());
        Assert.assertEquals(String.format("Granular Status - [Tracking ID = %s]", trackingId), expectedGranularStatus, orderDetails.getGranularStatus());

        List<Transaction> transactions = orderDetails.getTransactions();
        List<Transaction> listOfDeliveryTransactions = transactions
                .stream()
                .filter((transaction) -> "DELIVERY".equals(transaction.getType()))
                .collect(Collectors.toList());

        int numberOfExpectedDeliveryTransactions = 2;
        int numberOfActualDeliveryTransactions = listOfDeliveryTransactions.size();
        Assert.assertEquals(String.format("Number of delivery transaction should be %d. [Tracking ID = %s]", numberOfExpectedDeliveryTransactions, trackingId), numberOfExpectedDeliveryTransactions, numberOfActualDeliveryTransactions);
        Transaction transactionOfFirstAttempt = listOfDeliveryTransactions.get(0);
        Transaction transactionOfSecondAttempt = listOfDeliveryTransactions.get(1);

        Assert.assertEquals(String.format("First attempt of Delivery Transaction status should be FAIL. [Tracking ID = %s]", trackingId), "FAIL", transactionOfFirstAttempt.getStatus());
        Assert.assertEquals(String.format("Second attempt of Delivery Transaction status should be PENDING. [Tracking ID = %s]", trackingId), "PENDING", transactionOfSecondAttempt.getStatus());

        Date nextDate = CommonUtil.getNextDate(numberOfNextDays);
        String newDeliveryStartTime = DATE_FORMAT.format(nextDate);
        String newDeliveryEndTime = DATE_FORMAT.format(nextDate);

        Assert.assertThat(String.format("Start Time should be next %d day(s). [Tracking ID = %s]", numberOfNextDays, trackingId), transactionOfSecondAttempt.getStartTime(), Matchers.startsWith(newDeliveryStartTime));
        Assert.assertThat(String.format("End Time should be next %d day(s). [Tracking ID = %s]", numberOfNextDays, trackingId), transactionOfSecondAttempt.getEndTime(), Matchers.startsWith(newDeliveryEndTime));
    }

    @Then("^Operator verify order info after failed delivery aged parcel global inbounded and RTS-ed on next day$")
    public void operatorVerifyOrderInfoAfterFailedDeliveryAgedParcelGlobalInboundedAndRtsedOnNextDay()
    {
        co.nvqa.operator_v2.model.order_creation.v2.Order order = scenarioStorage.get("order");
        int orderId = order.getTransactions().get(0).getOrder_id();
        String trackingId = order.getTracking_id();

        String expectedStatus = "TRANSIT";
        String expectedGranularStatus = "ARRIVED_AT_SORTING_HUB";
        co.nvqa.operator_v2.integration.model.core.order.operator.Order orderDetails = getOrderDetails(orderId, expectedStatus, expectedGranularStatus);

        Assert.assertEquals(String.format("Status - [Tracking ID = %s]", trackingId), expectedStatus, orderDetails.getStatus());
        Assert.assertEquals(String.format("Granular Status - [Tracking ID = %s]", trackingId), expectedGranularStatus, orderDetails.getGranularStatus());
        Assert.assertTrue(String.format("RTS should be true - [Tracking ID = %s]", trackingId), orderDetails.getRts());

        List<Transaction> transactions = orderDetails.getTransactions();
        List<Transaction> listOfDeliveryTransactions = transactions
                .stream()
                .filter((transaction) -> "DELIVERY".equals(transaction.getType()))
                .collect(Collectors.toList());

        int numberOfExpectedDeliveryTransactions = 2;
        int numberOfActualDeliveryTransactions = listOfDeliveryTransactions.size();
        Assert.assertEquals(String.format("Number of delivery transaction should be %d. [Tracking ID = %s]", numberOfExpectedDeliveryTransactions, trackingId), numberOfExpectedDeliveryTransactions, numberOfActualDeliveryTransactions);
        Transaction transactionOfFirstAttempt = listOfDeliveryTransactions.get(0);
        Transaction transactionOfSecondAttempt = listOfDeliveryTransactions.get(1);

        Assert.assertEquals(String.format("First attempt of Delivery Transaction status should be FAIL. [Tracking ID = %s]", trackingId), "FAIL", transactionOfFirstAttempt.getStatus());
        Assert.assertEquals(String.format("Second attempt of Delivery Transaction status should be PENDING. [Tracking ID = %s]", trackingId), "PENDING", transactionOfSecondAttempt.getStatus());

        Date nextDate = CommonUtil.getNextDate(1);
        String newDeliveryStartTime = DATE_FORMAT.format(nextDate)+"T07:00:00Z";
        String newDeliveryEndTime = DATE_FORMAT.format(nextDate)+"T10:00:00Z";

        Assert.assertThat(String.format("Start Time should be next %d day(s). [Tracking ID = %s]", 1, trackingId), transactionOfSecondAttempt.getStartTime(), Matchers.equalTo(newDeliveryStartTime));
        Assert.assertThat(String.format("End Time should be next %d day(s). [Tracking ID = %s]", 1, trackingId), transactionOfSecondAttempt.getEndTime(), Matchers.equalTo(newDeliveryEndTime));

        TransactionEntity transactionEntity = coreJdbc.findTransactionById(transactionOfSecondAttempt.getId());
        Assert.assertEquals(String.format("RTS - Name - [Tracking ID = %s]", trackingId), order.getFrom_name()+" (RTS)", transactionEntity.getName());
        Assert.assertEquals(String.format("RTS - Email - [Tracking ID = %s]", trackingId), order.getTo_email(), transactionEntity.getEmail());
        Assert.assertEquals(String.format("RTS - Contact - [Tracking ID = %s]", trackingId), order.getFrom_contact(), transactionEntity.getContact());
        Assert.assertEquals(String.format("RTS - Address 1 - [Tracking ID = %s]", trackingId), order.getFrom_address1(), transactionEntity.getAddress1());
        Assert.assertEquals(String.format("RTS - Address 2 - [Tracking ID = %s]", trackingId), order.getFrom_address2(), transactionEntity.getAddress2());
        Assert.assertEquals(String.format("RTS - City - [Tracking ID = %s]", trackingId), order.getFrom_city(), transactionEntity.getCity());
        Assert.assertEquals(String.format("RTS - Country - [Tracking ID = %s]", trackingId), order.getFrom_country(), transactionEntity.getCountry());
    }
}
