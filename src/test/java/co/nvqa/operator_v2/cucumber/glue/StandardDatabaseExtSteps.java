package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.AbstractDatabaseSteps;
import co.nvqa.commons.model.addressing.JaroScore;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Reservation;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.commons.model.core.Waypoint;
import co.nvqa.commons.model.driver.FailureReason;
import co.nvqa.commons.model.entity.*;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.CreateRouteParams;
import co.nvqa.operator_v2.model.DpPartner;
import co.nvqa.operator_v2.model.DriverInfo;
import co.nvqa.operator_v2.model.DriverTypeParams;
import co.nvqa.operator_v2.model.ShipmentInfo;
import com.google.common.collect.ImmutableList;
import cucumber.api.java.After;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.runtime.java.guice.ScenarioScoped;
import io.cucumber.datatable.DataTable;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.hamcrest.Matchers;
import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Assert;
import org.opentest4j.AssertionFailedError;

import java.time.*;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

import static co.nvqa.commons.cucumber.glue.StandardApiOperatorPortalSteps.TRANSACTION_TYPE_PICKUP;
import static co.nvqa.commons.support.DateUtil.TIME_FORMATTER_1;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class StandardDatabaseExtSteps extends AbstractDatabaseSteps<ScenarioManager> {
    private final String TRANSACTION_TYPE_DELIVERY = "DELIVERY";

    public StandardDatabaseExtSteps() {
    }

    @Override
    public void init() {
    }

    /**
     * Cucumber regex: ^DB Operator verify driver types of multiple routes is updated successfully$
     */
    @Given("^DB Operator verify driver types of multiple routes is updated successfully$")
    public void dbOperatorVerifyDriverTypesOfMultipleRoutesIsUpdatedSuccessfully() {
        List<CreateRouteParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);
        DriverTypeParams driverTypeParams = get(KEY_DRIVER_TYPE_PARAMS);

        Long driverTypeId = driverTypeParams.getDriverTypeId();

        for (CreateRouteParams createRouteParams : listOfCreateRouteParams) {
            long routeId = createRouteParams.getCreatedRoute().getId();
            List<RouteDriverTypeEntity> listOfRouteDriverTypeEntity = getRouteJdbc().findRouteDriverTypeByRouteIdAndNotDeleted(routeId);
            List<Long> listOfRouteDriverTypeId = listOfRouteDriverTypeEntity.stream().map(RouteDriverTypeEntity::getDriverTypeId).collect(Collectors.toList());
            assertThat(f("Route with ID = %d does not contain the expected Driver Type ID = %d", routeId, driverTypeId), listOfRouteDriverTypeId, hasItem(driverTypeId));
        }
    }

    @Then("^Operator verify Jaro Scores are created successfully$")
    public void operatorVerifyJaroScoresAreCreatedSuccessfully() {
        List<JaroScore> jaroScores = get(KEY_LIST_OF_CREATED_JARO_SCORES);

        jaroScores.forEach(jaroScore ->
        {
            List<JaroScore> actualJaroScores = getCoreJdbc().getJaroScores(jaroScore.getWaypointId());
            assertEquals("Number of rows in DB", 2, actualJaroScores.size());

            Waypoint actualWaypoint = getCoreJdbc().getWaypoint(jaroScore.getWaypointId());
            assertNotNull("Actual waypoint from DB should not be null.", actualWaypoint);
            assertEquals("Latitude", jaroScore.getLatitude(), actualWaypoint.getLatitude(), 0);
            assertEquals("Longitude", jaroScore.getLongitude(), actualWaypoint.getLongitude(), 0);
        });
    }

    @Then("^DB Operator verify Jaro Scores of the created order after cancel$")
    public void dbOperatorVerifyJaroScoresAfterCancel() {
        Order order = get(KEY_ORDER_DETAILS);
        String trackingId = order.getTrackingId();

        List<Transaction> transactions = order.getTransactions();

        ImmutableList.of(TRANSACTION_TYPE_PICKUP, TRANSACTION_TYPE_DELIVERY).forEach(transactionType ->
        {
            Optional<Transaction> transactionOptional = transactions.stream().filter(t -> transactionType.equals(t.getType())).findFirst();

            if (transactionOptional.isPresent()) {
                Transaction transaction = transactionOptional.get();
                Long waypointId = transaction.getWaypointId();
                if (waypointId != null) {
                    List<JaroScore> jaroScores = getCoreJdbc().getJaroScores(waypointId);
                    assertEquals("Number of rows in DB", 1, jaroScores.size());
                    jaroScores.forEach(jaroScore ->
                            Assert.assertEquals(f("order jaro score is archived for the %s waypoint ", transactionType), new Integer(1), jaroScore.getArchived()));
                }
            } else {
                fail(f("%s transaction not found for tracking ID = '%s'.", transactionType, trackingId));
            }
        });
    }

    @Then("^DB Operator verify (.+) waypoint of the created order using data below:$")
    public void dbOperatorVerifyWaypoint(String transactionType, Map<String, String> data) {
        Order order = get(KEY_ORDER_DETAILS);
        String trackingId = order.getTrackingId();

        List<Transaction> transactions = order.getTransactions();

        Optional<Transaction> transactionOptional = transactions.stream().filter(t -> StringUtils.equalsIgnoreCase(t.getType(), transactionType)).findFirst();

        if (transactionOptional.isPresent()) {
            Transaction transaction = transactionOptional.get();
            Long waypointId = transaction.getWaypointId();
            Assert.assertNotNull(f("%s waypoint Id", transactionType), waypointId);

            Waypoint actualWaypoint = getCoreJdbc().getWaypoint(waypointId);

            if (data.containsKey("status"))
            {
                assertThat(f("%s waypoint [%d] status", transactionType, waypointId), actualWaypoint.getStatus(), Matchers.equalToIgnoringCase(data.get("status")));
            }
        } else {
            fail(f("%s transaction not found for tracking ID = '%s'.", transactionType, trackingId));
        }
    }

    @Then("^DB Operator verify Pickup waypoint record is updated$")
    public void dbOperatorVerifyPickupWaypointRecordUpdated() {
        String transactionType = "Pickup";
        Order order = get(KEY_CREATED_ORDER);

        List<Transaction> transactions = order.getTransactions();

        Transaction transaction = transactions.stream()
                .filter(t -> StringUtils.equalsIgnoreCase(t.getType(), transactionType)).findFirst()
                .orElseThrow(() -> new AssertionFailedError(f("%s transaction not found for order ID = '%s'.", transactionType, order.getId())));

        validatePickupInWaypointRecord(order, transactionType, transaction.getWaypointId());
    }

    @Then("^DB Operator verify Pickup waypoint record for (.+) transaction$")
    public void dbOperatorVerifyNewPickupWaypointRecordCreated(String transactionStatus) {
        Order order = get(KEY_CREATED_ORDER);
        String transactionType = "PP";
        List<TransactionEntity> transactions = getCoreJdbc().findTransactionByOrderIdAndType(order.getId(), transactionType);

        TransactionEntity transaction = transactions.stream()
                .filter(t -> StringUtils.equalsIgnoreCase(t.getType(), transactionType) &&
                        StringUtils.equalsIgnoreCase(t.getStatus(), transactionStatus)).findFirst()
                .orElseThrow(() -> new AssertionFailedError(f("%s transaction in %s status not found for order ID = '%s'.",
                        transactionType, transactionStatus, order.getId())));

        validatePickupInWaypointRecord(order, transactionType, transaction.getWaypointId());
    }

    @Then("^DB Operator verify Delivery waypoint record is updated$")
    public void dbOperatorVerifyDeliveryWaypointRecordUpdated() {
        String transactionType = "Delivery";
        Order order = get(KEY_CREATED_ORDER);
        List<Transaction> transactions = order.getTransactions();

        Transaction transaction = transactions.stream()
                .filter(t -> StringUtils.equalsIgnoreCase(t.getType(), transactionType)).findFirst()
                .orElseThrow(() -> new AssertionFailedError(f("%s transaction not found for order ID = '%s'.", transactionType, order.getId())));

            validateDeliveryInWaypointRecord(order, transactionType, transaction.getWaypointId());
    }

    @Then("^DB Operator verify Delivery waypoint record for (.+) transaction$")
    public void dbOperatorVerifyNewDeliveryWaypointRecordCreated(String transactionStatus) {
        Order order = get(KEY_CREATED_ORDER);
        String transactionType = "DD";
        List<TransactionEntity> transactions = getCoreJdbc().findTransactionByOrderIdAndType(order.getId(), transactionType);

        TransactionEntity transaction = transactions.stream()
                .filter(t -> StringUtils.equalsIgnoreCase(t.getType(), transactionType) &&
                        StringUtils.equalsIgnoreCase(t.getStatus(), transactionStatus)).findFirst()
                .orElseThrow(() -> new AssertionFailedError(f("%s transaction in %s status not found for order ID = '%s'.",
                        transactionType, transactionStatus, order.getId())));

        validateDeliveryInWaypointRecord(order, transactionType, transaction.getWaypointId());
    }

    @Then("^DB Operator verify the last order_events record for the created order:$")
    public void operatorVerifyTheLastOrderEventParams(Map<String, String> mapOfData) {
        Long orderId = get(KEY_CREATED_ORDER_ID);
        List<OrderEventEntity> orderEvents = getEventsJdbc().getOrderEvents(orderId);
        assertThat(f("Order %d events list", orderId), orderEvents, not(empty()));
        OrderEventEntity theLastOrderEvent = orderEvents.get(0);
        String value = mapOfData.get("type");

        if (StringUtils.isNotBlank(value)) {
            assertEquals("Type", Integer.parseInt(value), theLastOrderEvent.getType());
        }
    }

    @Then("^DB Operator verify the order_events record exists for the created order with type:$")
    public void operatorVerifyOrderEventExists(DataTable mapOfData) {
        Long orderId = get(KEY_CREATED_ORDER_ID);
        List<OrderEventEntity> orderEvents = getEventsJdbc().getOrderEvents(orderId);
        assertThat(f("Order %d events list", orderId), orderEvents, not(empty()));
        List<Integer> types = mapOfData.asList(Integer.class);
        types.forEach(type -> {
            OrderEventEntity event = orderEvents.stream().filter(orderEventEntity -> Objects.equals(orderEventEntity.getType(), type)).findFirst()
                    .orElseThrow(() -> new IllegalArgumentException(f("No order event with type %s is found in order events DB table", type)));
        });
    }

    @Then("^DB Operator verify Pickup '17' order_events record for the created order$")
    public void operatorVerifySpecificPickupOrderEvent() {
        int eventType = 17;
        Long orderId = get(KEY_CREATED_ORDER_ID);
        Order order = get(KEY_CREATED_ORDER);
        List<OrderEventEntity> orderEvents = getEventsJdbc().getOrderEvents(orderId);
        assertThat(f("Order %d events list", orderId), orderEvents, not(empty()));

        OrderEventEntity event = orderEvents.stream().filter(orderEventEntity -> Objects.equals(orderEventEntity.getType(), eventType)).findFirst()
                .orElseThrow(() -> new IllegalArgumentException(f("No order event with type %s is found in order events DB table", eventType)));
        try {
            JSONObject jo = new JSONObject(event.getData());
            LocalDateTime startDateTimeActual = LocalDateTime.ofInstant(Instant.ofEpochMilli(
                    jo.getJSONObject("pickup_start_time").getLong("new_value")), ZoneId.systemDefault());
            LocalTime startTimeExpected = order.getPickupTimeslot().getStartTime();
            String dateExpected = order.getPickupDate();
            assertEquals("Pickup start date is not as expected in order_events DB record",
                    f("%sT%s", dateExpected, startTimeExpected.toString()), startDateTimeActual.toString());

            LocalDateTime endDateTimeActual = LocalDateTime.ofInstant(Instant.ofEpochMilli(
                    jo.getJSONObject("pickup_end_time").getLong("new_value")), ZoneId.systemDefault());
            LocalTime endTimeExpected = order.getPickupTimeslot().getEndTime();
            assertEquals("Pickup end date is not as expected in order_events DB record",
                    f("%sT%s", dateExpected, endTimeExpected.toString()), endDateTimeActual.toString());
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    @Then("^DB Operator verify Delivery '17' order_events record for the created order$")
    public void operatorVerifySpecificDeliveryOrderEvent() {
        int eventType = 17;
        Long orderId = get(KEY_CREATED_ORDER_ID);
        Order order = get(KEY_CREATED_ORDER);
        List<OrderEventEntity> orderEvents = getEventsJdbc().getOrderEvents(orderId);
        assertThat(f("Order %d events list", orderId), orderEvents, not(empty()));

        OrderEventEntity event = orderEvents.stream().filter(orderEventEntity -> Objects.equals(orderEventEntity.getType(), eventType)).findFirst()
                .orElseThrow(() -> new IllegalArgumentException(f("No order event with type %s is found in order events DB table", eventType)));
        try {
            JSONObject jo = new JSONObject(event.getData());
            LocalDateTime startDateTimeActual = LocalDateTime.ofInstant(Instant.ofEpochMilli(
                    jo.getJSONObject("delivery_start_time").getLong("new_value")), ZoneId.systemDefault());
            LocalTime startTimeExpected = order.getDeliveryTimeslot().getStartTime();
            String dateExpected = order.getDeliveryDate();
            assertEquals("Delivery start date is not as expected in order_events DB record",
                    f("%sT%s", dateExpected, startTimeExpected.toString()), startDateTimeActual.toString());

            LocalDateTime endDateTimeActual = LocalDateTime.ofInstant(Instant.ofEpochMilli(
                    jo.getJSONObject("delivery_end_time").getLong("new_value")), ZoneId.systemDefault());
            LocalTime endTimeExpected = order.getDeliveryTimeslot().getEndTime();
            assertEquals("Delivery end date is not as expected in order_events DB record",
                    f("%sT%s", dateExpected, endTimeExpected.toString()), endDateTimeActual.toString());
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    @Then("^DB Operator verify (-?\\d+) order_events record for the created order:$")
    public void operatorVerifyOrderEventParams(int index, Map<String, String> mapOfData)
    {
        Long orderId = get(KEY_CREATED_ORDER_ID);
        List<OrderEventEntity> orderEvents = getEventsJdbc().getOrderEvents(orderId);
        assertThat(f("Order %d events list", orderId), orderEvents, not(empty()));
        if (index <= 0)
        {
            index = orderEvents.size() + index;
        }
        OrderEventEntity theLastOrderEvent = orderEvents.get(index - 1);
        String value = mapOfData.get("type");

        if (StringUtils.isNotBlank(value))
        {
            assertEquals("Type", Integer.parseInt(value), theLastOrderEvent.getType());
        }
    }

    @Then("^DB Operator verify order_events record for the created order:$")
    public void operatorVerifyOrderEventRecordParams(Map<String, String> mapOfData)
    {
        Long orderId = get(KEY_CREATED_ORDER_ID);
        List<OrderEventEntity> orderEvents = getEventsJdbc().getOrderEvents(orderId);
        assertThat(f("Order %d events list", orderId), orderEvents, not(empty()));
        String value = mapOfData.get("type");

        boolean recordFound = orderEvents.stream()
                .anyMatch(record ->
                {
                    if (StringUtils.isNotBlank(value))
                    {
                        return Integer.parseInt(value) == record.getType();
                    }
                    return false;
                });
        assertTrue(f("Event record %s for order %d was not found", mapOfData.toString(), orderId), recordFound);
    }

    @Then("^DB Operator verify transaction_failure_reason record for the created order$")
    public void dbOperatorVerifyTransactionFailureReasonForTheCreatedOrder()
    {
        FailureReason failureReason = get(KEY_SELECTED_FAILURE_REASON);
        Order orderAfterDelivery = get(KEY_CREATED_ORDER_AFTER_DELIVERY);
        List<Transaction> transactions = orderAfterDelivery.getTransactions();
        Transaction deliveryTransaction = transactions.stream()
                .filter(transaction -> TRANSACTION_TYPE_DELIVERY.equals(transaction.getType()))
                .findFirst()
                .orElseThrow(() -> new AssertionError("Delivery transaction not found"));
        TransactionFailureReasonEntity transactionFailureReason = getCoreJdbc().findTransactionFailureReasonByTransactionId(deliveryTransaction.getId());
        assertEquals("failure_reason_code_id", (long) failureReason.getFailureReasonCodeId(), (long) transactionFailureReason.getFailureReasonCodeId());
    }

    @Then("^DB Operator verify Pickup transaction record is updated for the created order$")
    public void dbOperatorVerifyPickupTransactionRecordUpdatedForTheCreatedOrder()
    {
        Order order = get(KEY_CREATED_ORDER);
        String type = "PP";
        List<TransactionEntity> transactions = getCoreJdbc().findTransactionByOrderIdAndType(order.getId(), type);

        assertThat(f("There is more than 1 %s transaction for orderId %d", type, order.getId()), transactions, hasSize(1));
        TransactionEntity entity = transactions.get(0);
        assertEquals("Transaction entity is not as expected in db", order.getFromAddress1(), entity.getAddress1());
        assertEquals("Transaction entity is not as expected in db", order.getFromAddress2(), entity.getAddress2());
        assertEquals("Transaction entity is not as expected in db", order.getFromPostcode(), entity.getPostcode());
        assertEquals("Transaction entity is not as expected in db", order.getFromCity(), entity.getCity());
        assertEquals("Transaction entity is not as expected in db", order.getFromCountry(), entity.getCountry());
        assertEquals("Transaction entity is not as expected in db", order.getFromName(), entity.getName());
        assertEquals("Transaction entity is not as expected in db", order.getFromEmail(), entity.getEmail());
        assertEquals("Transaction entity is not as expected in db", order.getFromContact(), entity.getContact());
        ZonedDateTime entityStartDateTime = ZonedDateTime.parse(entity.getStartTime(), DateUtil.DATE_TIME_FORMATTER.withZone(ZoneId.of("UTC")))
                .withZoneSameInstant(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE));
        ZonedDateTime entityEndDateTime = ZonedDateTime.parse(entity.getEndTime(), DateUtil.DATE_TIME_FORMATTER.withZone(ZoneId.of("UTC")))
                .withZoneSameInstant(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE));
        assertEquals("Transaction entity is not as expected in db",
                order.getPickupDate() + " " + TIME_FORMATTER_1.format(order.getPickupTimeslot().getStartTime()),
                DateUtil.displayDateTime(entityStartDateTime));
        assertEquals("Transaction entity is not as expected in db",
                order.getPickupDate() + " " + TIME_FORMATTER_1.format(order.getPickupTimeslot().getEndTime()),
                DateUtil.displayDateTime(entityEndDateTime));
    }

    @Then("^DB Operator verify Delivery transaction record is updated for the created order$")
    public void dbOperatorVerifyDeliveryTransactionRecordUpdatedForTheCreatedOrder()
    {
        Order order = get(KEY_CREATED_ORDER);
        String type = "DD";
        List<TransactionEntity> transactions = getCoreJdbc().findTransactionByOrderIdAndType(order.getId(), type);

        assertThat(f("There is more than 1 %s transaction for orderId %d", type, order.getId()), transactions, hasSize(1));
        TransactionEntity entity = transactions.get(0);
        assertEquals("Transaction entity is not as expected in db", order.getToAddress1(), entity.getAddress1());
        assertEquals("Transaction entity is not as expected in db", order.getToAddress2(), entity.getAddress2());
        assertEquals("Transaction entity is not as expected in db", order.getToPostcode(), entity.getPostcode());
        assertEquals("Transaction entity is not as expected in db", order.getToCity(), entity.getCity());
        assertEquals("Transaction entity is not as expected in db", order.getToCountry(), entity.getCountry());
        assertEquals("Transaction entity is not as expected in db", order.getToName(), entity.getName());
        assertEquals("Transaction entity is not as expected in db", order.getToEmail(), entity.getEmail());
        assertEquals("Transaction entity is not as expected in db", order.getToContact(), entity.getContact());
        ZonedDateTime entityStartDateTime = ZonedDateTime.parse(entity.getStartTime(), DateUtil.DATE_TIME_FORMATTER.withZone(ZoneId.of("UTC")))
                .withZoneSameInstant(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE));
        ZonedDateTime entityEndDateTime = ZonedDateTime.parse(entity.getEndTime(), DateUtil.DATE_TIME_FORMATTER.withZone(ZoneId.of("UTC")))
                .withZoneSameInstant(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE));
        assertEquals("Transaction entity is not as expected in db",
                order.getDeliveryDate() + " " + TIME_FORMATTER_1.format(order.getDeliveryTimeslot().getStartTime()),
                DateUtil.displayDateTime(entityStartDateTime));
        assertEquals("Transaction entity is not as expected in db",
                order.getDeliveryDate() + " " + TIME_FORMATTER_1.format(order.getDeliveryTimeslot().getEndTime()),
                DateUtil.displayDateTime(entityEndDateTime));
    }

    @Then("^DB Operator verify next Delivery transaction values are updated for the created order:$")
    public void dbOperatorVerifyTransactionRecordUpdatedForTheCreatedOrderForParameters(Map<String, String> mapOfData)
    {
        Order order = get(KEY_CREATED_ORDER);
        String type = "DD";
        List<TransactionEntity> transactions = getCoreJdbc().findTransactionByOrderIdAndType(order.getId(), type);

        assertThat(f("There is more than 1 %s transaction for orderId %d", type, order.getId()), transactions, hasSize(1));
        TransactionEntity entity = transactions.get(0);
        put(KEY_WAYPOINT_ID, entity.getWaypointId());
        String distributionPointId = mapOfData.get("distribution_point_id");
        String address1 = Objects.equals(mapOfData.get("address1"), "GET_FROM_CREATED_ORDER") ? order.getToAddress1() :
                mapOfData.get("address1");
        String address2 = Objects.equals(mapOfData.get("address2"), "GET_FROM_CREATED_ORDER") ? order.getToAddress2() :
                mapOfData.get("address2");
        String city = Objects.equals(mapOfData.get("city"), "GET_FROM_CREATED_ORDER") ? order.getToCity() :
                mapOfData.get("city");
        String country = Objects.equals(mapOfData.get("country"), "GET_FROM_CREATED_ORDER") ? order.getToCountry() :
                mapOfData.get("country");
        String postcode = Objects.equals(mapOfData.get("postcode"), "GET_FROM_CREATED_ORDER") ? order.getToPostcode() :
                mapOfData.get("postcode");
        String routeId = mapOfData.get("routeId");
        String priorityLevel = mapOfData.get("priorityLevel");
        if (Objects.nonNull(distributionPointId)){
            Integer distributionPointIdInt = Objects.equals(distributionPointId, "null") ? null : NumberUtils.createInteger(distributionPointId);
            assertEquals("DistributionPointId in Transaction entity is not as expected in db", distributionPointIdInt, entity.getDistributionPointId());
        }
        if (Objects.nonNull(address1)){
            assertEquals("Address1 in Transaction entity is not as expected in db", address1, entity.getAddress1());
        }
        if (Objects.nonNull(address2)){
            assertEquals("Address2 in Transaction entity is not as expected in db", address2, entity.getAddress2());
        }
        if (Objects.nonNull(city)){
            assertEquals("City in Transaction entity is not as expected in db", city, entity.getCity());
        }
        if (Objects.nonNull(country)){
            assertEquals("Country in Transaction entity is not as expected in db", country, entity.getCountry());
        }
        if (Objects.nonNull(postcode)){
            assertEquals("Postcode in Transaction entity is not as expected in db", postcode, entity.getPostcode());
        }
        if (Objects.nonNull(routeId)){
            Integer routeIdInt = Objects.equals(routeId, "null") ? null : NumberUtils.createInteger(routeId);
            assertEquals("RouteId in Transaction entity is not as expected in db", routeIdInt, entity.getRouteId());
        }
        if (Objects.nonNull(priorityLevel)){
            Integer priorityLevelInt = Objects.equals(priorityLevel, "null") ? null : NumberUtils.createInteger(priorityLevel);
            assertEquals("PriorityLevel in Transaction entity is not as expected in db", priorityLevelInt, entity.getPriorityLevel());
        }
    }

    @Then("^DB Operator verify next Pickup transaction values are updated for the created order:$")
    public void dbOperatorVerifyPickupTransactionRecordUpdatedForTheCreatedOrderForParameters(Map<String, String> mapOfData)
    {
        Map<String, String> mapOfTokens = createDefaultTokens();
        mapOfData = replaceDataTableTokens(mapOfData, mapOfTokens);
        Order order = get(KEY_CREATED_ORDER);
        String type = "PP";
        List<TransactionEntity> transactions = getCoreJdbc().findTransactionByOrderIdAndType(order.getId(), type);

        assertThat(f("There is more than 1 %s transaction for orderId %d", type, order.getId()), transactions, hasSize(1));
        TransactionEntity entity = transactions.get(0);
        put(KEY_WAYPOINT_ID, entity.getWaypointId());

        String routeId = mapOfData.get("routeId");
        String priorityLevel = mapOfData.get("priorityLevel");
        String status = mapOfData.get("status");
        String serviceEndTime = mapOfData.get("serviceEndTime");
        if (StringUtils.isNotBlank(routeId)){
            Integer routeIdInt = StringUtils.equalsIgnoreCase(routeId, "null") ? null :
                    NumberUtils.createInteger(routeId);
            assertEquals("RouteId in DB Transaction entity is not as expected", routeIdInt, entity.getRouteId());
        }
        if (StringUtils.isNotBlank(priorityLevel)){
            Integer priorityLevelInt = StringUtils.equalsIgnoreCase(priorityLevel, "null") ? null :
                    NumberUtils.createInteger(priorityLevel);
            assertEquals("PriorityLevel in DB Transaction entity is not as expected", priorityLevelInt, entity.getPriorityLevel());
        }
        if (StringUtils.isNotBlank(status)){
            assertEquals("Status in DB Transaction entity is not as expected", status, entity.getStatus());
        }
        if (StringUtils.isNotBlank(serviceEndTime)){
            assertEquals("Service End Time in DB Transaction entity is not as expected", serviceEndTime, DateUtil.SDF_YYYY_MM_DD.format(entity.getServiceEndTime()));
        }
    }

    @Then("^DB Operator verify the last inbound_scans record for the created order:$")
    public void dbOperatorVerifyTheLastInboundScansRecord(Map<String, String> mapOfData)
    {
        Long orderId = get(KEY_CREATED_ORDER_ID);
        Order order = get(KEY_CREATED_ORDER);
        List<InboundScanEntity> inboundScans = getCoreJdbc().findInboundScansByOrderId(orderId);
        InboundScanEntity theLastInboundScan = inboundScans.get(inboundScans.size() - 1);

        String value = mapOfData.get("hubId");

        if (StringUtils.isNotBlank(value))
        {
            assertEquals("Hub ID", Long.valueOf(value), theLastInboundScan.getHubId());
        }

        value = mapOfData.get("type");

        if (StringUtils.isNotBlank(value))
        {
            assertEquals("Type", Short.valueOf(value), theLastInboundScan.getType());
        }

        String trackingId = "GET_FROM_CREATED_ORDER".equalsIgnoreCase(mapOfData.get("trackingId")) ? order.getTrackingId() :
                mapOfData.get("trackingId");

        if (StringUtils.isNotBlank(trackingId))
        {
            assertEquals("TrackingId", trackingId, theLastInboundScan.getScan());
        }
    }

    @After(value = {"@DeleteDpPartner"})
    public void deleteDpPartner()
    {
        DpPartner dpPartner = get(KEY_DP_PARTNER);

        if (dpPartner != null)
        {
            getDpJdbc().deleteDpPartner(dpPartner.getName());
        }
    }

    @After(value = {"@DeleteDpAndPartner"})
    public void deleteDp()
    {
        DpPartner dpPartner = get(KEY_DP_PARTNER);

        if (dpPartner != null)
        {
            getDpJdbc().deleteDp(dpPartner.getName());
            getDpJdbc().deleteDpPartner(dpPartner.getName());
        }
    }

    @After(value = {"@DeleteDpUserDpAndPartner"})
    public void deleteDpUser()
    {
        DpPartner dpPartner = get(KEY_DP_PARTNER);

        if (dpPartner != null)
        {
            getDpJdbc().deleteDpUser(dpPartner.getName());
            getDpJdbc().deleteDp(dpPartner.getName());
            getDpJdbc().deleteDpPartner(dpPartner.getName());
        }
    }

    @Given("^DB Operator get data of created driver$")
    public void dbOperatorGetDataOfCreatedDriver()
    {
        DriverInfo driverInfo = get(KEY_CREATED_DRIVER);
        DriverEntity driverEntity = getDriverJdbc().getDriverData(driverInfo.getUsername());
        driverInfo.setId(driverEntity.getId());
        driverInfo.setUuid(driverEntity.getUuid());
        put(KEY_CREATED_DRIVER_UUID, driverInfo.getUuid());
    }

    @After(value = "@DeleteShipment")
    public void deleteShipment()
    {
        ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);

        if (shipmentInfo != null)
        {
            getHubJdbc().deleteShipment(shipmentInfo.getId());
        }
    }

    @After(value = "@DeleteHubAppUser")
    public void deleteHubAppUser()
    {
        if (get(KEY_CREATED_HUB_APP_USERNAME) != null)
        {
            getHubJdbc().deleteHubAppUser(get(KEY_CREATED_HUB_APP_USERNAME));
            getAuthJdbc().softDeleteOauthClientByClientId(get(KEY_CREATED_HUB_APP_USERNAME));
        }
    }

    @Given("DB Operator gets the newest existed username for Hub App")
    public void dbOperatorGetsTheNewestExistedUsernameForHubApp()
    {
        String username = getHubJdbc().getExistedUsername();
        put(KEY_EXISTED_HUB_APP_USERNAME, username);
    }

    @SuppressWarnings("unchecked")
    @Given("^DB Operator verifies warehouse_sweeps record$")
    public void dbOperatorVerifiesWareHouseSweepsRecord(Map<String, String> mapOfData)
    {
        String trackingId = mapOfData.get("trackingId");
        String hubId = mapOfData.get("hubId");

        if (StringUtils.equalsIgnoreCase(trackingId, "CREATED"))
        {
            trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        }

        Order order = get(KEY_CREATED_ORDER);

        final String finalTrackingId = trackingId;

        List<Map<String, Object>> warehouseSweepRecordsFiltered = retryIfExpectedExceptionOccurred(() ->
        {
            List<Map<String, Object>> warehouseSweepRecords = getCoreJdbc().findWarehouseSweepRecord(finalTrackingId);
            List<Map<String, Object>> warehouseSweepRecordsFilteredTemp = warehouseSweepRecords.stream()
                    .filter(record -> record.get("scan").equals(finalTrackingId))
                    .collect(Collectors.toList());

            assertEquals(f("Expected 1 record in Warehouse_sweeps table with tracking ID %s", finalTrackingId), 1, warehouseSweepRecordsFilteredTemp.size());
            return warehouseSweepRecordsFilteredTemp;
        }, getCurrentMethodName(), NvLogger::warn, 500, 30, AssertionError.class);

        Map<String, Object> warehouseSweepRecord = warehouseSweepRecordsFiltered.get(0);
        assertEquals(f("Expected hub_id in Warehouse_sweeps table"), hubId, String.valueOf(warehouseSweepRecord.get("hub_id")));
        assertEquals(f("Expected order_id in Warehouse_sweeps table"), String.valueOf(order.getId()), String.valueOf(warehouseSweepRecord.get("order_id")));
    }

    @SuppressWarnings("unchecked")
    @Given("^DB Operator verifies pickup info is updated in order record$")
    public void dbOperatorVerifiesPickupInfoInOrderRecord(){
        Order order = get(KEY_CREATED_ORDER);
        final String finalTrackingId = order.getTrackingId();
        List<Order> pickupInfoRecordsFiltered = retryIfExpectedExceptionOccurred(() ->
        {
            List<Order> pickupInfoRecords = getCoreJdbc().getOrderByTrackingId(finalTrackingId);
            List<Order> pickupInfoRecordsTemp = pickupInfoRecords.stream()
                    .filter(record -> record.getTrackingId().equals(finalTrackingId))
                    .collect(Collectors.toList());

            assertEquals(f("Expected 1 record in Orders table with tracking ID %s", finalTrackingId), 1, pickupInfoRecordsTemp.size());
            return pickupInfoRecordsTemp;
        }, getCurrentMethodName(), NvLogger::warn, 500, 30, AssertionError.class);

        Order pickupInfoRecord = pickupInfoRecordsFiltered.get(0);

        assertEquals(f("Expected %s in %s table", "from_address1", "orders"), order.getFromAddress1(), pickupInfoRecord.getFromAddress1());
        assertEquals(f("Expected %s in %s table", "from_address2", "orders"), order.getFromAddress2(), pickupInfoRecord.getFromAddress2());
        assertEquals(f("Expected %s in %s table", "from_postcode", "orders"), order.getFromPostcode(), pickupInfoRecord.getFromPostcode());
        assertEquals(f("Expected %s in %s table", "from_city", "orders"), order.getFromCity(), pickupInfoRecord.getFromCity());
        assertEquals(f("Expected %s in %s table", "from_country", "orders"), order.getFromCountry(), pickupInfoRecord.getFromCountry());
        assertEquals(f("Expected %s in %s table", "from_name", "orders"), order.getFromName(), pickupInfoRecord.getFromName());
        assertEquals(f("Expected %s in %s table", "from_email", "orders"), order.getFromEmail(), pickupInfoRecord.getFromEmail());
        assertEquals(f("Expected %s in %s table", "from_contact", "orders"), order.getFromContact(), pickupInfoRecord.getFromContact());
    }

    @SuppressWarnings("unchecked")
    @Given("^DB Operator verifies delivery info is updated in order record$")
    public void dbOperatorVerifiesDeliveryInfoInOrderRecord(){
        Order order = get(KEY_CREATED_ORDER);
        final String finalTrackingId = order.getTrackingId();
        List<Order> deliveryInfoRecordsFiltered = retryIfExpectedExceptionOccurred(() ->
        {
            List<Order> deliveryInfoRecords = getCoreJdbc().getOrderByTrackingId(finalTrackingId);
            List<Order> deliveryInfoRecordsTemp = deliveryInfoRecords.stream()
                    .filter(record -> record.getTrackingId().equals(finalTrackingId))
                    .collect(Collectors.toList());

            assertEquals(f("Expected 1 record in Orders table with tracking ID %s", finalTrackingId), 1, deliveryInfoRecordsTemp.size());
            return deliveryInfoRecordsTemp;
        }, getCurrentMethodName(), NvLogger::warn, 500, 30, AssertionError.class);

        Order deliveryInfoRecord = deliveryInfoRecordsFiltered.get(0);

        assertEquals(f("Expected %s in %s table", "to_address1", "orders"), order.getToAddress1(), deliveryInfoRecord.getToAddress1());
        assertEquals(f("Expected %s in %s table", "to_address2", "orders"), Objects.nonNull(order.getToAddress2()) ? order.getToAddress2() : "", deliveryInfoRecord.getToAddress2());
        assertEquals(f("Expected %s in %s table", "to_postcode", "orders"), order.getToPostcode(), deliveryInfoRecord.getToPostcode());
        assertEquals(f("Expected %s in %s table", "to_city", "orders"), Objects.isNull(order.getToCity()) ? "" : order.getToCity(), deliveryInfoRecord.getToCity());
        assertEquals(f("Expected %s in %s table", "to_country", "orders"), order.getToCountry(), deliveryInfoRecord.getToCountry());
        assertEquals(f("Expected %s in %s table", "to_name", "orders"), order.getToName(), deliveryInfoRecord.getToName());
        assertEquals(f("Expected %s in %s table", "to_email", "orders"), order.getToEmail(), deliveryInfoRecord.getToEmail());
        assertEquals(f("Expected %s in %s table", "to_contact", "orders"), order.getToContact(), deliveryInfoRecord.getToContact());
    }

    @Given("^DB Operator verifies reservation record using data below:$")
    public void dbOperatorVerifiesReservationRecord(Map<String, String> mapOfData)
    {
        Reservation reservation = get(KEY_CREATED_RESERVATION);
        reservation = getCoreJdbc().getReservationRecordByAddressId(reservation.getAddressId());

        if (Objects.nonNull(mapOfData.get("status"))){
            int status = Integer.parseInt(mapOfData.get("status"));
            assertEquals(f("Expected %s in %s table", "status", "reservations"), status, reservation.getStatusValue());
        }
    }

    @Given("^DB Operator verifies waypoint record using data below:$")
    public void dbOperatorVerifiesWaypointRecord(Map<String, String> mapOfData) {
        Reservation reservation = get(KEY_CREATED_RESERVATION);
        Waypoint waypoint = getCoreJdbc().getWaypoint(reservation.getWaypointId());

        if (Objects.nonNull(mapOfData.get("status"))) {
            String status = mapOfData.get("status");
            assertEquals(f("Expected %s in %s table", "status", "waypoints"), status, waypoint.getStatus());
        }
    }

    @SuppressWarnings("unchecked")
    @Given("^DB Operator verifies orders record using data below:$")
    public void dbOperatorVerifiesOrdersRecord(Map<String, String> mapOfData) {
        Order order = get(KEY_CREATED_ORDER);
        final String finalTrackingId = order.getTrackingId();
        List<Order> orderRecordsFiltered = retryIfExpectedExceptionOccurred(() ->
        {
            List<Order> orderRecords = getCoreJdbc().getOrderByTrackingId(finalTrackingId);
            List<Order> orderRecordsTemp = orderRecords.stream()
                    .filter(record -> record.getTrackingId().equals(finalTrackingId))
                    .collect(Collectors.toList());

            assertEquals(f("Expected 1 record in Orders table with tracking ID %s", finalTrackingId), 1, orderRecordsTemp.size());
            return orderRecordsTemp;
        }, getCurrentMethodName(), NvLogger::warn, 500, 30, AssertionError.class);

        Order orderRecord = orderRecordsFiltered.get(0);

        if (Objects.nonNull(mapOfData.get("status"))) {
            String status = mapOfData.get("status");
            assertEquals(f("Expected %s in %s table", "status", "orders"), status, orderRecord.getStatus());
        }
        if (Objects.nonNull(mapOfData.get("granularStatus"))) {
            String granularStatus = mapOfData.get("granularStatus");
            assertEquals(f("Expected %s in %s table", "granularStatus", "orders"), granularStatus, orderRecord.getGranularStatus());
        }
        if (Objects.nonNull(mapOfData.get("toAddress1"))) {
            String toAddress1 = Objects.equals(mapOfData.get("toAddress1"), "GET_FROM_CREATED_ORDER") ? order.getToAddress1() :
                    mapOfData.get("toAddress1");
            assertEquals(f("Expected %s in %s table", "to_address1", "orders"), toAddress1, orderRecord.getToAddress1());
        }
        if (Objects.nonNull(mapOfData.get("toAddress2"))) {
            String toAddress2 = Objects.equals(mapOfData.get("toAddress2"), "GET_FROM_CREATED_ORDER") ? order.getToAddress2() :
                    mapOfData.get("toAddress2");
            assertEquals(f("Expected %s in %s table", "to_address2", "orders"), toAddress2, orderRecord.getToAddress2());
        }
        if (Objects.nonNull(mapOfData.get("toPostcode"))) {
            String toPostcode = Objects.equals(mapOfData.get("toPostcode"), "GET_FROM_CREATED_ORDER") ? order.getToPostcode() :
                    mapOfData.get("toPostcode");
            assertEquals(f("Expected %s in %s table", "to_postcode", "orders"), toPostcode, orderRecord.getToPostcode());
        }
        if (Objects.nonNull(mapOfData.get("toCity"))) {
            String toCity = Objects.equals(mapOfData.get("toCity"), "GET_FROM_CREATED_ORDER") ? order.getToCity() :
                    mapOfData.get("toCity");
            assertEquals(f("Expected %s in %s table", "to_city", "orders"), toCity, orderRecord.getToCity());
        }
        if (Objects.nonNull(mapOfData.get("toCountry"))) {
            String toCountry = Objects.equals(mapOfData.get("toCountry"), "GET_FROM_CREATED_ORDER") ? order.getToCountry() :
                    mapOfData.get("toCountry");
            assertEquals(f("Expected %s in %s table", "to_country", "orders"), toCountry, orderRecord.getToCountry());
        }
        if (Objects.nonNull(mapOfData.get("toState"))) {
            String toState = Objects.equals(mapOfData.get("toState"), "GET_FROM_CREATED_ORDER") ? order.getToState() :
                    mapOfData.get("toState");
            assertEquals(f("Expected %s in %s table", "to_state", "orders"), toState, orderRecord.getToState());
        }
        if (Objects.nonNull(mapOfData.get("toDistrict"))) {
            String toDistrict = Objects.equals(mapOfData.get("toDistrict"), "GET_FROM_CREATED_ORDER") ? order.getToDistrict() :
                    mapOfData.get("toDistrict");
            assertEquals(f("Expected %s in %s table", "to_district", "orders"), toDistrict, orderRecord.getToDistrict());
        }
    }

    @SuppressWarnings("unchecked")
    @Given("^DB Operator verifies order is deleted$")
    public void dbOperatorVerifiesOrderIsDeleted() {
        Order order = get(KEY_CREATED_ORDER);
        final String finalTrackingId = order.getTrackingId();
        retryIfExpectedExceptionOccurred(() ->
        {
            List<Order> orderRecords = getCoreJdbc().getOrderByTrackingId(finalTrackingId);

            assertEquals(f("Expected 0 record in Orders table with tracking ID %s", finalTrackingId), 0, orderRecords.size());
            return orderRecords;
        }, getCurrentMethodName(), NvLogger::warn, 500, 30, AssertionError.class);
    }

    @SuppressWarnings("unchecked")
    @Given("^DB Operator verifies waypoint for (Pickup|Delivery) transaction is deleted from route_waypoint table$")
    public void dbOperatorVerifiesWaypointIsDeleted(String txnType) {
        Order order = get(KEY_CREATED_ORDER);
        final String waypointId = String.valueOf(order.getTransactions().stream()
                .filter(transaction -> StringUtils.equalsIgnoreCase(transaction.getType(), txnType))
                .findFirst().orElseThrow(() -> new IllegalArgumentException(f("No %s transaction for %d order", txnType, order.getId())))
                .getWaypointId());
        retryIfExpectedExceptionOccurred(() ->
        {
            List<Map<String, Object>> waypointRecords = getCoreJdbc().getWaypointRecords(waypointId);

            assertEquals(f("Expected 0 record in route_waypoint table with waypoint ID %s", waypointId), 0, waypointRecords.size());
            return waypointRecords;
        }, getCurrentMethodName(), NvLogger::warn, 500, 30, AssertionError.class);
    }

    private void validatePickupInWaypointRecord(Order order, String transactionType, long waypointId) {
        Assert.assertNotNull(f("%s waypoint Id", transactionType), waypointId);

        Waypoint actualWaypoint = getCoreJdbc().getWaypoint(waypointId);
        assertEquals(f("%s waypoint [%d] city", transactionType, waypointId), order.getFromCity(), actualWaypoint.getCity());
        assertEquals(f("%s waypoint [%d] country", transactionType, waypointId), order.getFromCountry(), actualWaypoint.getCountry());
        assertEquals(f("%s waypoint [%d] address1", transactionType, waypointId), order.getFromAddress1(), actualWaypoint.getAddress1());
        assertEquals(f("%s waypoint [%d] address2", transactionType, waypointId), order.getFromAddress2(), actualWaypoint.getAddress2());
        assertEquals(f("%s waypoint [%d] postcode", transactionType, waypointId), order.getFromPostcode(), actualWaypoint.getPostcode());
        assertEquals(f("%s waypoint [%d] timewindowId", transactionType, waypointId), order.getPickupTimeslot().getId(), Integer.parseInt(actualWaypoint.getTimeWindowId()));
    }

    private void validateDeliveryInWaypointRecord(Order order, String transactionType, long waypointId) {
        Assert.assertNotNull(f("%s waypoint Id", transactionType), waypointId);

        Waypoint actualWaypoint = getCoreJdbc().getWaypoint(waypointId);
        assertEquals(f("%s waypoint [%d] city", transactionType, waypointId), Objects.isNull(order.getToCity()) ? "" :
                order.getToCity(), actualWaypoint.getCity());
        assertEquals(f("%s waypoint [%d] country", transactionType, waypointId), order.getToCountry(), actualWaypoint.getCountry());
        assertEquals(f("%s waypoint [%d] address1", transactionType, waypointId), order.getToAddress1(), actualWaypoint.getAddress1());
        assertEquals(f("%s waypoint [%d] address2", transactionType, waypointId), order.getToAddress2(), actualWaypoint.getAddress2());
        assertEquals(f("%s waypoint [%d] postcode", transactionType, waypointId), order.getToPostcode(), actualWaypoint.getPostcode());
        if (Objects.nonNull(order.getDeliveryTimeslot())) {
            assertEquals(f("%s waypoint [%d] timewindowId", transactionType, waypointId), order.getDeliveryTimeslot().getId(),
                    Integer.parseInt(actualWaypoint.getTimeWindowId()));
        }
    }
}
