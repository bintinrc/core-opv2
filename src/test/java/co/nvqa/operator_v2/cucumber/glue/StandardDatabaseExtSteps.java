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
import cucumber.api.java.After;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.StringUtils;
import org.opentest4j.AssertionFailedError;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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

        for(CreateRouteParams createRouteParams : listOfCreateRouteParams)
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

    @Then("^DB Operator verify the last order_events record for the created order:$")
    public void operatorVerifyTheLastOrderEventParams(Map<String, String> mapOfData)
    {
        Long orderId = get(KEY_CREATED_ORDER_ID);
        List<OrderEventEntity> orderEvents = getEventsJdbc().getOrderEvents(orderId);
        assertThat(f("Order %d events list", orderId), orderEvents, not(empty()));
        OrderEventEntity theLastOrderEvent = orderEvents.get(0);
        String value = mapOfData.get("type");

        if(StringUtils.isNotBlank(value))
        {
            assertEquals("Type", Integer.parseInt(value), theLastOrderEvent.getType());
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

    @Then("^DB Operator verify the last inbound_scans record for the created order:$")
    public void dbOperatorVerifyTheLastInboundScansRecord(Map<String, String> mapOfData)
    {
        Long orderId = get(KEY_CREATED_ORDER_ID);
        List<InboundScanEntity> inboundScans = getCoreJdbc().findInboundScansByOrderId(orderId);
        InboundScanEntity theLastInboundScan = inboundScans.get(inboundScans.size() - 1);

        String value = mapOfData.get("hubId");

        if(StringUtils.isNotBlank(value))
        {
            assertEquals("Hub ID", Long.valueOf(value), theLastInboundScan.getHubId());
        }

        value = mapOfData.get("type");

        if(StringUtils.isNotBlank(value))
        {
            assertEquals("Type", Short.valueOf(value), theLastInboundScan.getType());
        }
    }

    @After(value = {"@DeleteDpPartner"})
    public void deleteDpPartner()
    {
        DpPartner dpPartner = get(KEY_DP_PARTNER);

        if(dpPartner!=null)
        {
            getDpJdbc().deleteDpPartner(dpPartner.getName());
        }
    }

    @After(value = {"@DeleteDpAndPartner"})
    public void deleteDp()
    {
        DpPartner dpPartner = get(KEY_DP_PARTNER);

        if(dpPartner!=null)
        {
            getDpJdbc().deleteDp(dpPartner.getName());
            getDpJdbc().deleteDpPartner(dpPartner.getName());
        }
    }

    @After(value = {"@DeleteDpUserDpAndPartner"})
    public void deleteDpUser()
    {
        DpPartner dpPartner = get(KEY_DP_PARTNER);

        if(dpPartner!=null)
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

        if(shipmentInfo!=null)
        {
            getHubJdbc().deleteShipment(shipmentInfo.getId());
        }
    }

    @Given("DB Operator verifies warehouse_sweeps record")
    public void dbOperatorVerifiesWareHouseSweepsRecord(Map<String, String> mapOfData) {
        String trackingId = mapOfData.get("trackingId");
        String hubId = mapOfData.get("hubId");
        if (StringUtils.equalsIgnoreCase(trackingId, "CREATED")) {
            trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        }
        Order order = get(KEY_CREATED_ORDER);
        List<Map<String, Object>> warehouseSweepRecordsFiltered = new ArrayList<>();
        int counter = 0;
        while (warehouseSweepRecordsFiltered.size() != 1){
            if (counter > 3) {
                throw new AssertionFailedError(f("No record found in Warehouse_sweeps table with tracking id %s", trackingId));
            }
            warehouseSweepRecordsFiltered = dbWarehouseSweepsRequest(trackingId);
            counter++;
        }

        Map<String, Object> warehouseSweepRecord = warehouseSweepRecordsFiltered.get(0);
        assertEquals(f("Expected hub_id in Warehouse_sweeps table"),
                String.valueOf(warehouseSweepRecord.get("hub_id")), hubId);
        assertEquals(f("Expected order_id in Warehouse_sweeps table"),
                String.valueOf(warehouseSweepRecord.get("order_id")), String.valueOf(order.getId()));
    }

    private List<Map<String, Object>> dbWarehouseSweepsRequest(String finalTrackingId){
        List<Map<String, Object>> warehouseSweepRecordsFiltered = new ArrayList<>();
        try {
            List<Map<String, Object>> warehouseSweepRecords = getCoreJdbc().findWarehouseSweepRecord();
            warehouseSweepRecordsFiltered = warehouseSweepRecords.stream()
                    .filter(record -> record.get("scan").equals(finalTrackingId)).collect(Collectors.toList());

            assertEquals(f("Expected 1 record in Warehouse_sweeps table with tracking id %s", finalTrackingId),
                    1, warehouseSweepRecordsFiltered.size());
        }
        catch (AssertionFailedError assertError){
            NvLogger.infof(assertError.getMessage());
        }
        return warehouseSweepRecordsFiltered;
    }
}
