package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.AbstractDatabaseSteps;
import co.nvqa.commons.model.addressing.JaroScore;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.commons.model.driver.FailureReason;
import co.nvqa.commons.model.entity.DriverEntity;
import co.nvqa.commons.model.entity.InboundScanEntity;
import co.nvqa.commons.model.entity.OrderEventEntity;
import co.nvqa.commons.model.entity.RouteDriverTypeEntity;
import co.nvqa.commons.model.entity.TransactionFailureReasonEntity;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.CreateRouteParams;
import co.nvqa.operator_v2.model.DpPartner;
import co.nvqa.operator_v2.model.DriverInfo;
import co.nvqa.operator_v2.model.DriverTypeParams;
import com.google.inject.Inject;
import cucumber.api.java.After;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.StringUtils;
import org.junit.Assert;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static org.hamcrest.Matchers.*;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class StandardDatabaseExtSteps extends AbstractDatabaseSteps<ScenarioManager>
{
    private final String TRANSACTION_TYPE_DELIVERY = "DELIVERY";

    @Inject
    public StandardDatabaseExtSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
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
            Assert.assertThat(String.format("Route with ID = %d does not contain the expected Driver Type ID = %d", routeId, driverTypeId), listOfRouteDriverTypeId, hasItem(driverTypeId));
        }
    }

    @Then("^Operator verify Jaro Scores are created successfully$")
    public void operatorVerifyJaroScoresAreCreatedSuccessfully()
    {
        List<JaroScore> jaroScores = get(KEY_LIST_OF_CREATED_JARO_SCORES);
        jaroScores.forEach(jaroScore ->
        {
            List<JaroScore> actualJaroScores = getAddressingJdbc().getJaroScores(jaroScore.getWaypointId());
            Assert.assertEquals("Number of rows in DB", 2, actualJaroScores.size());
            JaroScore newJaroScore = actualJaroScores.get(actualJaroScores.size() - 1);
            Assert.assertEquals("Latitude", jaroScore.getLatitude(), newJaroScore.getLatitude(), 0);
            Assert.assertEquals("Longitude", jaroScore.getLongitude(), newJaroScore.getLongitude(), 0);
            Assert.assertEquals("Verified Address Id", jaroScore.getVerifiedAddressId(), newJaroScore.getVerifiedAddressId());
        });
    }

    @Then("^DB Operator verify the last order_events record for the created order:$")
    public void operatorVerifyTheLastOrderEventParams(Map<String, String> mapOfData)
    {
        Long orderId = get(KEY_CREATED_ORDER_ID);
        List<OrderEventEntity> orderEvents = getEventsJdbc().getOrderEvents(orderId);
        Assert.assertThat(String.format("Order %d events list", orderId), orderEvents, not(empty()));
        OrderEventEntity theLastOrderEvent = orderEvents.get(0);
        String value = mapOfData.get("type");
        if (StringUtils.isNotBlank(value))
        {
            Assert.assertEquals("Type", Short.parseShort(value), theLastOrderEvent.getType());
        }
    }

    @Then("^DB Operator verify transaction_failure_reason record for the created order$")
    public void dbOperatorVerifyTransactionFailureReasonForTheCreatedOrder()
    {
        FailureReason failureReason = get(KEY_FAILURE_REASON);
        Order orderAfterDelivery = get(KEY_CREATED_ORDER_AFTER_DELIVERY);
        List<Transaction> transactions = orderAfterDelivery.getTransactions();
        Transaction deliveryTransaction = transactions.stream()
                .filter(transaction -> TRANSACTION_TYPE_DELIVERY.equals(transaction.getType()))
                .findFirst()
                .orElseThrow(() -> new AssertionError("Delivery transaction not found"));
        TransactionFailureReasonEntity transactionFailureReason = getCoreJdbc().findTransactionFailureReasonByTransactionId(deliveryTransaction.getId());
        Assert.assertEquals("failure_reason_code_id", (long) failureReason.getFailureReasonCodeId(), (long) transactionFailureReason.getFailureReasonCodeId());
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
            Assert.assertEquals("Hub ID", Long.valueOf(value), theLastInboundScan.getHubId());
        }

        value = mapOfData.get("type");

        if(StringUtils.isNotBlank(value))
        {
            Assert.assertEquals("Type", Short.valueOf(value), theLastInboundScan.getType());
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

    @And("^DB Operator get data of created driver$")
    public void dbOperatorGetDataOfCreatedDriver()
    {
        DriverInfo driverInfo = get(KEY_CREATED_DRIVER);
        DriverEntity driverEntity = getDriverJdbc().getDriverData(driverInfo.getUsername());
        driverInfo.setId(driverEntity.getId());
        driverInfo.setUuid(driverEntity.getUuid());
        put(KEY_CREATED_DRIVER_UUID, driverInfo.getUuid());
    }
}
