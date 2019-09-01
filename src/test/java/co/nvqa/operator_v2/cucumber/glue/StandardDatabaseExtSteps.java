package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.AbstractDatabaseSteps;
import co.nvqa.commons.model.addressing.JaroScore;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.commons.model.core.Waypoint;
import co.nvqa.commons.model.driver.FailureReason;
import co.nvqa.commons.model.entity.DriverEntity;
import co.nvqa.commons.model.entity.InboundScanEntity;
import co.nvqa.commons.model.entity.OrderEventEntity;
import co.nvqa.commons.model.entity.RouteDriverTypeEntity;
import co.nvqa.commons.model.entity.TransactionFailureReasonEntity;
import co.nvqa.commons.util.NvLogger;
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
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;
import org.junit.Assert;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import static co.nvqa.commons.cucumber.glue.StandardApiOperatorPortalSteps.TRANSACTION_TYPE_PICKUP;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class StandardDatabaseExtSteps extends AbstractDatabaseSteps<ScenarioManager>
{
    private final String TRANSACTION_TYPE_DELIVERY = "DELIVERY";

    public StandardDatabaseExtSteps()
    {
    }

    @Override
    public void init()
    {
    }

    /**
     * Cucumber regex: ^DB Operator verify driver types of multiple routes is updated successfully$
     */
    @Given("^DB Operator verify driver types of multiple routes is updated successfully$")
    public void dbOperatorVerifyDriverTypesOfMultipleRoutesIsUpdatedSuccessfully()
    {
        List<CreateRouteParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);
        DriverTypeParams driverTypeParams = get(KEY_DRIVER_TYPE_PARAMS);

        Long driverTypeId = driverTypeParams.getDriverTypeId();

        for (CreateRouteParams createRouteParams : listOfCreateRouteParams)
        {
            long routeId = createRouteParams.getCreatedRoute().getId();
            List<RouteDriverTypeEntity> listOfRouteDriverTypeEntity = getRouteJdbc().findRouteDriverTypeByRouteIdAndNotDeleted(routeId);
            List<Long> listOfRouteDriverTypeId = listOfRouteDriverTypeEntity.stream().map(RouteDriverTypeEntity::getDriverTypeId).collect(Collectors.toList());
            assertThat(f("Route with ID = %d does not contain the expected Driver Type ID = %d", routeId, driverTypeId), listOfRouteDriverTypeId, hasItem(driverTypeId));
        }
    }

    @Then("^Operator verify Jaro Scores are created successfully$")
    public void operatorVerifyJaroScoresAreCreatedSuccessfully()
    {
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
    public void dbOperatorVerifyJaroScoresAfterCancel()
    {
        Order order = get(KEY_ORDER_DETAILS);
        String trackingId = order.getTrackingId();

        List<Transaction> transactions = order.getTransactions();

        ImmutableList.of(TRANSACTION_TYPE_PICKUP, TRANSACTION_TYPE_DELIVERY).forEach(transactionType ->
        {
            Optional<Transaction> transactionOptional = transactions.stream().filter(t -> transactionType.equals(t.getType())).findFirst();

            if (transactionOptional.isPresent())
            {
                Transaction transaction = transactionOptional.get();
                Long waypointId = transaction.getWaypointId();
                if (waypointId != null)
                {
                    List<JaroScore> jaroScores = getCoreJdbc().getJaroScores(waypointId);
                    assertEquals("Number of rows in DB", 1, jaroScores.size());
                    jaroScores.forEach(jaroScore ->
                            Assert.assertEquals(f("order jaro score is archived for the %s waypoint ", transactionType), new Integer(1), jaroScore.getArchived()));
                }
            } else
            {
                fail(f("%s transaction not found for tracking ID = '%s'.", transactionType, trackingId));
            }
        });
    }

    @Then("^DB Operator verify (.+) waypoint of the created order using data below:$")
    public void dbOperatorVerifyWaypoint(String transactionType, Map<String, String> data)
    {
        Order order = get(KEY_ORDER_DETAILS);
        String trackingId = order.getTrackingId();

        List<Transaction> transactions = order.getTransactions();

        Optional<Transaction> transactionOptional = transactions.stream().filter(t -> StringUtils.equalsIgnoreCase(t.getType(), transactionType)).findFirst();

        if (transactionOptional.isPresent())
        {
            Transaction transaction = transactionOptional.get();
            Long waypointId = transaction.getWaypointId();
            Assert.assertNotNull(f("%s waypoint Id", transactionType), waypointId);

            Waypoint actualWaypoint = getCoreJdbc().getWaypoint(waypointId);
            if (data.containsKey("status"))
            {
                assertThat(f("%s waypoint [%d] status", transactionType, waypointId), actualWaypoint.getStatus(), Matchers.equalToIgnoringCase(data.get("status")));
            }
        } else
        {
            fail(f("%s transaction not found for tracking ID = '%s'.", transactionType, trackingId));
        }
    }

    @Then("^DB Operator verify the last order_events record for the created order:$")
    public void operatorVerifyTheLastOrderEventParams(Map<String, String> mapOfData)
    {
        Long orderId = get(KEY_CREATED_ORDER_ID);
        List<OrderEventEntity> orderEvents = getEventsJdbc().getOrderEvents(orderId);
        assertThat(f("Order %d events list", orderId), orderEvents, not(empty()));
        OrderEventEntity theLastOrderEvent = orderEvents.get(0);
        String value = mapOfData.get("type");

        if (StringUtils.isNotBlank(value))
        {
            assertEquals("Type", Integer.parseInt(value), theLastOrderEvent.getType());
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
        assertEquals(f("Expected hub_id in Warehouse_sweeps table"), String.valueOf(warehouseSweepRecord.get("hub_id")), hubId);
        assertEquals(f("Expected order_id in Warehouse_sweeps table"), String.valueOf(warehouseSweepRecord.get("order_id")), String.valueOf(order.getId()));
    }
}