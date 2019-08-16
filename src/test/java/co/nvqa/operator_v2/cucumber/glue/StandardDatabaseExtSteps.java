package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.AbstractDatabaseSteps;
import co.nvqa.commons.model.addressing.JaroScore;
import co.nvqa.commons.model.core.Order;
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
import org.hamcrest.Matchers;
import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Assert;

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
            if (data.containsKey("status")) {
                assertThat(f("%s waypoint [%d] status", transactionType, waypointId), actualWaypoint.getStatus(), Matchers.equalToIgnoringCase(data.get("status")));
            }
        } else {
            fail(f("%s transaction not found for tracking ID = '%s'.", transactionType, trackingId));
        }
    }

    @Then("^DB Operator verify (.+) waypoint record is updated$")
    public void dbOperatorVerifyWaypointRecordUpdated(String transactionType) {
        Order order = get(KEY_CREATED_ORDER);
        String trackingId = order.getTrackingId();

        List<Transaction> transactions = order.getTransactions();

        Optional<Transaction> transactionOptional = transactions.stream().filter(t -> StringUtils.equalsIgnoreCase(t.getType(), transactionType)).findFirst();

        if (transactionOptional.isPresent()) {
            Transaction transaction = transactionOptional.get();
            Long waypointId = transaction.getWaypointId();
            Assert.assertNotNull(f("%s waypoint Id", transactionType), waypointId);

            Waypoint actualWaypoint = getCoreJdbc().getWaypoint(waypointId);
            assertEquals(f("%s waypoint [%d] city", transactionType, waypointId), order.getFromCity(), actualWaypoint.getCity());
            assertEquals(f("%s waypoint [%d] country", transactionType, waypointId), order.getFromCountry(), actualWaypoint.getCountry());
            assertEquals(f("%s waypoint [%d] address1", transactionType, waypointId), order.getFromAddress1(), actualWaypoint.getAddress1());
            assertEquals(f("%s waypoint [%d] address2", transactionType, waypointId), order.getFromAddress2(), actualWaypoint.getAddress2());
            assertEquals(f("%s waypoint [%d] postcode", transactionType, waypointId), order.getFromPostcode(), actualWaypoint.getPostcode());
            assertEquals(f("%s waypoint [%d] timewindowId", transactionType, waypointId), order.getPickupTimeslot().getId(), Integer.parseInt(actualWaypoint.getTimeWindowId()));
        } else {
            fail(f("%s transaction not found for tracking ID = '%s'.", transactionType, trackingId));
        }
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

    @Then("^DB Operator verify '17' order_events record for the created order$")
    public void operatorVerifySpecificOrderEvent() {
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
    public void dbOperatorVerifyTransactionRecordUpdatedForTheCreatedOrder()
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

    @Then("^DB Operator verify the last inbound_scans record for the created order:$")
    public void dbOperatorVerifyTheLastInboundScansRecord(Map<String, String> mapOfData)
    {
        Long orderId = get(KEY_CREATED_ORDER_ID);
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
            List<Map<String, Object>> warehouseSweepRecords = getCoreJdbc().findWarehouseSweepRecord();
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
        List<Map<String, Object>> pickupInfoRecordsFiltered = retryIfExpectedExceptionOccurred(() ->
        {
            List<Map<String, Object>> pickupInfoRecords = getCoreJdbc().getOrderByTrackingId(finalTrackingId);
            List<Map<String, Object>> pickupInfoRecordsTemp = pickupInfoRecords.stream()
                    .filter(record -> record.get("tracking_id").equals(finalTrackingId))
                    .collect(Collectors.toList());

            assertEquals(f("Expected 1 record in Orders table with tracking ID %s", finalTrackingId), 1, pickupInfoRecordsTemp.size());
            return pickupInfoRecordsTemp;
        }, getCurrentMethodName(), NvLogger::warn, 500, 30, AssertionError.class);

        Map<String, Object> pickupInfoRecord = pickupInfoRecordsFiltered.get(0);

        assertEquals(f("Expected %s in %s table", "from_address1", "orders"), order.getFromAddress1(), String.valueOf(pickupInfoRecord.get("from_address1")));
        assertEquals(f("Expected %s in %s table", "from_address2", "orders"), order.getFromAddress2(), String.valueOf(pickupInfoRecord.get("from_address2")));
        assertEquals(f("Expected %s in %s table", "from_postcode", "orders"), order.getFromPostcode(), String.valueOf(pickupInfoRecord.get("from_postcode")));
        assertEquals(f("Expected %s in %s table", "from_city", "orders"), order.getFromCity(), String.valueOf(pickupInfoRecord.get("from_city")));
        assertEquals(f("Expected %s in %s table", "from_country", "orders"), order.getFromCountry(), String.valueOf(pickupInfoRecord.get("from_country")));
        assertEquals(f("Expected %s in %s table", "from_name", "orders"), order.getFromName(), String.valueOf(pickupInfoRecord.get("from_name")));
        assertEquals(f("Expected %s in %s table", "from_email", "orders"), order.getFromEmail(), String.valueOf(pickupInfoRecord.get("from_email")));
        assertEquals(f("Expected %s in %s table", "from_contact", "orders"), order.getFromContact(), String.valueOf(pickupInfoRecord.get("from_contact")));
    }
}