package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.hibernate.EventsDao;
import co.nvqa.common.core.model.persisted_class.events.OrderEvents;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.cucumber.glue.AbstractDatabaseSteps;
import co.nvqa.commons.model.addressing.JaroScore;
import co.nvqa.commons.model.core.CodInbound;
import co.nvqa.commons.model.core.Dimension;
import co.nvqa.commons.model.core.Driver;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Reservation;
import co.nvqa.commons.model.core.ShipperRefMetadata;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.commons.model.core.Waypoint;
import co.nvqa.commons.model.core.hub.Hub;
import co.nvqa.commons.model.core.hub.MovementPath;
import co.nvqa.commons.model.core.hub.MovementTrip;
import co.nvqa.commons.model.core.hub.PathSchedule;
import co.nvqa.commons.model.core.hub.UnscannedShipment;
import co.nvqa.commons.model.core.hub.trip_management.TripManagementDetailsData;
import co.nvqa.commons.model.driver.FailureReason;
import co.nvqa.commons.model.entity.DriverEntity;
import co.nvqa.commons.model.entity.InboundScanEntity;
import co.nvqa.commons.model.entity.MovementEventEntity;
import co.nvqa.commons.model.entity.MovementTripEventEntity;
import co.nvqa.commons.model.entity.ReserveTrackingIdEntity;
import co.nvqa.commons.model.entity.RouteMonitoringDataEntity;
import co.nvqa.commons.model.entity.ShipmentPathEntity;
import co.nvqa.commons.model.entity.TransactionEntity;
import co.nvqa.commons.model.entity.TransactionFailureReasonEntity;
import co.nvqa.commons.model.sort.hub.movement_trips.HubRelation;
import co.nvqa.commons.model.sort.hub.movement_trips.HubRelationSchedule;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.model.DpPartner;
import co.nvqa.operator_v2.model.DriverInfo;
import co.nvqa.operator_v2.model.RouteCashInboundCod;
import co.nvqa.operator_v2.model.ShipmentInfo;
import com.google.common.collect.ImmutableList;
import io.cucumber.datatable.DataTable;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.After;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.sql.SQLException;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;
import javax.inject.Inject;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.hamcrest.Matchers;
import org.json.JSONException;
import org.json.JSONObject;
import org.opentest4j.AssertionFailedError;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.commons.cucumber.glue.api.StandardApiOperatorPortalSteps.TRANSACTION_TYPE_PICKUP;
import static co.nvqa.commons.support.DateUtil.TIME_FORMATTER_1;
import static co.nvqa.operator_v2.cucumber.ScenarioStorageKeys.KEY_TRIP_ID;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class StandardDatabaseExtSteps extends AbstractDatabaseSteps<ScenarioManager> {

  private static final Logger LOGGER = LoggerFactory.getLogger(StandardDatabaseExtSteps.class);

  private final String TRANSACTION_TYPE_DELIVERY = "DELIVERY";
  private static final String HUB_CD_CD = "CD->CD";
  private static final String HUB_CD_ITS_ST = "CD->its ST";
  private static final String HUB_CD_ST_DIFF_CD = "CD->ST under another CD";
  private static final String HUB_ST_ST_SAME_CD = "ST->ST under same CD";
  private static final String HUB_ST_ST_DIFF_CD = "ST->ST under diff CD";
  private static final String HUB_ST_ITS_CD = "ST->its CD";
  private static final String HUB_ST_CD_DIFF_CD = "ST->another CD";

  public StandardDatabaseExtSteps() {
  }

  @Inject
  private EventsDao eventsDao;

  @Override
  public void init() {
  }

  @Then("Operator verify Jaro Scores are created successfully")
  public void operatorVerifyJaroScoresAreCreatedSuccessfully() {
    List<JaroScore> jaroScores = get(KEY_LIST_OF_CREATED_JARO_SCORES);

    jaroScores.forEach(jaroScore ->
    {
      List<JaroScore> actualJaroScores = getCoreJdbc().getJaroScores(jaroScore.getWaypointId());
      Assertions.assertThat(
              actualJaroScores.stream().filter(js -> js.getSourceId() == 4).findFirst())
          .as("Waypoint source id is CORRECT: 4")
          .isNotNull();
      Assertions.assertThat(actualJaroScores.stream().filter(js -> js.getScore() == 1).findFirst())
          .as("Waypoint Jaro score is CORRECT: 1")
          .isNotNull();
      Assertions.assertThat(
              actualJaroScores.stream().filter(js -> js.getArchived() == 1).findFirst())
          .as("Waypoint is ARCHIVED")
          .isNotNull();

      Waypoint actualWaypoint = getCoreJdbc().getWaypoint(jaroScore.getWaypointId());
      Assertions.assertThat(actualWaypoint)
          .as("Actual waypoint from DB should not be null.")
          .isNotNull();
      Assertions.assertThat(actualWaypoint.getLatitude())
          .as("Latitude is CORRECT: %f", jaroScore.getLatitude())
          .isEqualTo(jaroScore.getLatitude());
      Assertions.assertThat(actualWaypoint.getLongitude())
          .as("Longitude is CORRECT: %f", jaroScore.getLongitude())
          .isEqualTo(jaroScore.getLongitude());
    });
  }

  @Then("DB Operator verify Jaro Scores:")
  public void dbOperatorVerifyJaroScores(List<Map<String, String>> data) {
    data = resolveListOfMaps(data);

    data.forEach(map ->
    {
      JaroScore jaroScore = new JaroScore(map);
      List<JaroScore> actualJaroScores = getCoreJdbc().getJaroScores(jaroScore.getWaypointId());
      Assertions.assertThat(actualJaroScores)
          .as("List of Jaro Scores for waypoint id" + jaroScore.getWaypointId())
          .isNotEmpty();
      JaroScore actual = actualJaroScores.get(0);
      jaroScore.compareWithActual(actual);
    });
  }

  @Then("DB Operator verify Jaro Scores of Delivery Transaction waypoint of created order are archived")
  public void dbOperatorVerifyJaroScoresArchived() {
    retryIfAssertionErrorOccurred(() -> {
      Order order = get(KEY_ORDER_DETAILS);
      String trackingId = order.getTrackingId();

      List<Transaction> transactions = order.getTransactions();

      ImmutableList.of(TRANSACTION_TYPE_DELIVERY).forEach(transactionType ->
      {
        Optional<Transaction> transactionOptional = transactions.stream()
            .filter(t -> transactionType.equals(t.getType())).findFirst();

        if (transactionOptional.isPresent()) {
          Transaction transaction = transactionOptional.get();
          Long waypointId = transaction.getWaypointId();

          if (waypointId != null) {
            List<JaroScore> jaroScores = getCoreJdbc().getJaroScores(waypointId);
            Assertions.assertThat(jaroScores.size()).as("Number of jaro scores").isEqualTo(1);
            Assertions.assertThat(jaroScores.get(0).getArchived() == 1)
                .as("jaro scores are archived")
                .isTrue();
          }
        } else {
          fail(f("%s transaction not found for tracking ID = '%s'.", transactionType, trackingId));
        }
      });
    }, "Check Db Jaro Score");
  }

  @Then("DB Operator verify Jaro Scores of Pickup Transaction waypoint of created order are archived")
  public void dbOperatorVerifyJaroScoresOfPickupTransactionArchived() {
    Order order = get(KEY_ORDER_DETAILS);
    String trackingId = order.getTrackingId();

    List<Transaction> transactions = order.getTransactions();

    ImmutableList.of(TRANSACTION_TYPE_PICKUP).forEach(transactionType ->
    {
      Optional<Transaction> transactionOptional = transactions.stream()
          .filter(t -> transactionType.equals(t.getType())).findFirst();

      if (transactionOptional.isPresent()) {
        Transaction transaction = transactionOptional.get();
        Long waypointId = transaction.getWaypointId();
        if (waypointId != null) {
          List<JaroScore> jaroScores = getCoreJdbc().getJaroScores(waypointId);
          Assertions.assertThat(jaroScores.size()).as("Number of jaro scores").isEqualTo(1);
          Assertions.assertThat(jaroScores.get(0).getArchived() == 1).as("jaro scores are archived")
              .isTrue();
        }
      } else {
        fail(f("%s transaction not found for tracking ID = '%s'.", transactionType, trackingId));
      }
    });
  }

  @Then("DB Operator verify Jaro Scores of Delivery Transaction waypoint of created order:")
  public void dbOperatorVerifyJaroScoresOdFeliveryTransaction(List<Map<String, String>> data) {
    Order order = get(KEY_ORDER_DETAILS);
    String trackingId = order.getTrackingId();

    List<Transaction> transactions = order.getTransactions();

    List<Map<String, String>> finalData = resolveListOfMaps(data);
    ImmutableList.of(TRANSACTION_TYPE_DELIVERY).forEach(transactionType ->
    {
      Optional<Transaction> transactionOptional = transactions.stream()
          .filter(t -> transactionType.equals(t.getType())).findFirst();

      if (transactionOptional.isPresent()) {
        Transaction transaction = transactionOptional.get();
        Long waypointId = transaction.getWaypointId();
        if (waypointId != null) {
          List<JaroScore> jaroScores = getCoreJdbc().getJaroScores(waypointId);
          if (jaroScores.size() != finalData.size()) {
            pause10s();
            jaroScores = getCoreJdbc().getJaroScores(waypointId);
          }
          Assertions.assertThat(jaroScores.size()).as("Number of jaro scores")
              .isEqualTo(finalData.size());
          for (int i = 0; i < finalData.size(); i++) {
            if (StringUtils.equalsAnyIgnoreCase(finalData.get(i).get("score"), "null",
                "not null")) {
              finalData.get(i).remove("score");
            }
            JaroScore expected = new JaroScore(finalData.get(i));
            JaroScore actual = jaroScores.get(i);
            expected.compareWithActual(actual, finalData.get(i));
          }
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

    Transaction transaction = StringUtils.equalsIgnoreCase(transactionType, "delivery") ?
        order.getLastDeliveryTransaction() :
        order.getLastPickupTransaction();

    if (transaction != null) {
      Long waypointId = transaction.getWaypointId();
      Assertions.assertThat(waypointId)
          .as("%s waypoint Id", transactionType)
          .isNotNull();
      put(KEY_WAYPOINT_ID, waypointId);
      putInList(KEY_LIST_OF_WAYPOINT_IDS, waypointId);
      put(KEY_TRANSACTION_ID, transaction.getId());
      putInMap(KEY_MAP_OF_WAYPOINT_IDS_ORDER, waypointId, trackingId);

      Waypoint actualWaypoint = getCoreJdbc().getWaypoint(waypointId);

      if (data.containsKey("status")) {
        Assertions.assertThat(actualWaypoint.getStatus())
            .as("%s waypoint [%d] status", transactionType, waypointId)
            .isEqualToIgnoringCase(data.get("status"));
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
        .orElseThrow(() -> new AssertionFailedError(
            f("%s transaction not found for order ID = '%s'.", transactionType, order.getId())));

    validatePickupInWaypointRecord(order, transactionType, transaction.getWaypointId());
  }

  @Then("^DB Operator verify Pickup waypoint record for (.+) transaction$")
  public void dbOperatorVerifyNewPickupWaypointRecordCreated(String transactionStatus) {
    Order order = get(KEY_CREATED_ORDER);
    String transactionType = "PP";
    List<TransactionEntity> transactions = getCoreJdbc()
        .findTransactionByOrderIdAndType(order.getId(), transactionType);

    TransactionEntity transaction = transactions.stream()
        .filter(t -> StringUtils.equalsIgnoreCase(t.getType(), transactionType) &&
            StringUtils.equalsIgnoreCase(t.getStatus(), transactionStatus)).findFirst()
        .orElseThrow(() -> new AssertionFailedError(
            f("%s transaction in %s status not found for order ID = '%s'.",
                transactionType, transactionStatus, order.getId())));

    validatePickupInWaypointRecord(order, transactionType, transaction.getWaypointId());
  }

  @Then("^DB Operator verify Delivery waypoint record is updated$")
  public void dbOperatorVerifyDeliveryWaypointRecordUpdated() {
    String transactionType = "Delivery";
    Order order = get(KEY_CREATED_ORDER);
    Transaction transaction = order.getLastDeliveryTransaction();
    validateDeliveryInWaypointRecord(order, transactionType, transaction.getWaypointId());
  }

  @Then("^DB Operator verify Delivery waypoint record for (.+) transaction$")
  public void dbOperatorVerifyNewDeliveryWaypointRecordCreated(String transactionStatus) {
    Order order = get(KEY_CREATED_ORDER);
    String transactionType = "DD";
    List<TransactionEntity> transactions = getCoreJdbc()
        .findTransactionByOrderIdAndType(order.getId(), transactionType);

    TransactionEntity transaction = transactions.stream()
        .filter(t -> StringUtils.equalsIgnoreCase(t.getType(), transactionType) &&
            StringUtils.equalsIgnoreCase(t.getStatus(), transactionStatus)).findFirst()
        .orElseThrow(() -> new AssertionFailedError(
            f("%s transaction in %s status not found for order ID = '%s'.",
                transactionType, transactionStatus, order.getId())));

    validateDeliveryInWaypointRecord(order, transactionType, transaction.getWaypointId());
  }

  @Then("^DB Operator verify order_events record for the created order for RTS:$")
  public void operatorVerifyTheLastOrderEventParamsForRTS(Map<String, String> mapOfData) {
    Long orderId = get(KEY_CREATED_ORDER_ID);
    List<OrderEvents> orderEvents = eventsDao.getOrderEvents(orderId);
    List<String> orderEventsTypes = orderEvents.stream()
        .map(orderEvent -> String.valueOf(orderEvent.getType())).collect(
            Collectors.toList());
    assertThat(f("Order %d events list", orderId), orderEvents, not(empty()));
    String value = mapOfData.get("type");

    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(orderEventsTypes).as("Type contained in orderEvents").contains(value);
    }
  }

  @Then("^DB Operator verify the order_events record exists for the created order with type:$")
  public void operatorVerifyOrderEventExists(DataTable mapOfData) {
    Long orderId = get(KEY_CREATED_ORDER_ID);
    List<OrderEvents> orderEvents = eventsDao.getOrderEvents(orderId);
    assertThat(f("Order %d events list", orderId), orderEvents, not(empty()));
    List<Integer> types = mapOfData.asList(Integer.class);
    types.forEach(type ->
        orderEvents.stream()
            .filter(orderEventEntity -> Objects.equals(orderEventEntity.getType(), type))
            .findFirst()
            .orElseThrow(() -> new IllegalArgumentException(
                f("No order event with type %s is found in order events DB table", type))));
  }

  @Then("^DB Operator verify the order_events record:$")
  public void operatorVerifyOrderEventExists(Map<String, String> data) {
    OrderEvents expected = new OrderEvents(resolveKeyValues(data));
    List<OrderEvents> orderEvents = eventsDao.getOrderEvents(expected.getOrderId());
    OrderEvents.assertListContains(orderEvents, expected, "Order event");
  }

  @Then("^DB Operator verify Pickup '17' order_events record for the created order$")
  public void operatorVerifySpecificPickupOrderEvent() {
    int eventType = 17;
    Long orderId = get(KEY_CREATED_ORDER_ID);
    Order order = get(KEY_CREATED_ORDER);
    List<OrderEvents> orderEvents = eventsDao.getOrderEvents(orderId);
    assertThat(f("Order %d events list", orderId), orderEvents, not(empty()));

    OrderEvents event = orderEvents.stream()
        .filter(orderEventEntity -> Objects.equals(orderEventEntity.getType(), eventType))
        .findFirst()
        .orElseThrow(() -> new IllegalArgumentException(
            f("No order event with type %s is found in order events DB table", eventType)));
    try {
      JSONObject jo = new JSONObject(event.getData());
      LocalDateTime startDateTimeActual = LocalDateTime.ofInstant(Instant.ofEpochMilli(
          jo.getJSONObject("pickup_start_time").getLong("new_value")), ZoneId.systemDefault());
      LocalTime startTimeExpected = order.getPickupTimeslot().getStartTime();
      String dateExpected = order.getPickupDate();
      Assertions.assertThat(startDateTimeActual.toString())
          .as("Pickup start date is not as expected in order_events DB record")
          .isEqualTo(f("%sT%s", dateExpected, startTimeExpected.toString()));

      LocalDateTime endDateTimeActual = LocalDateTime.ofInstant(Instant.ofEpochMilli(
          jo.getJSONObject("pickup_end_time").getLong("new_value")), ZoneId.systemDefault());
      LocalTime endTimeExpected = order.getPickupTimeslot().getEndTime();
      Assertions.assertThat(endDateTimeActual.toString())
          .as("Pickup end date is not as expected in order_events DB record")
          .isEqualTo(f("%sT%s", dateExpected, endTimeExpected.toString()));
    } catch (JSONException e) {
      e.printStackTrace();
    }
  }

  @Then("^DB Operator verify Delivery '17' order_events record for the created order$")
  public void operatorVerifySpecificDeliveryOrderEvent() {
    int eventType = 17;
    Long orderId = get(KEY_CREATED_ORDER_ID);
    Order order = get(KEY_CREATED_ORDER);
    List<OrderEvents> orderEvents = eventsDao.getOrderEvents(orderId);
    assertThat(f("Order %d events list", orderId), orderEvents, not(empty()));

    OrderEvents event = orderEvents.stream()
        .filter(orderEventEntity -> Objects.equals(orderEventEntity.getType(), eventType))
        .findFirst()
        .orElseThrow(() -> new IllegalArgumentException(
            f("No order event with type %s is found in order events DB table", eventType)));
    try {
      JSONObject jo = new JSONObject(event.getData());
      LocalDateTime startDateTimeActual = LocalDateTime.ofInstant(Instant.ofEpochMilli(
          jo.getJSONObject("delivery_start_time").getLong("new_value")), ZoneId.systemDefault());
      LocalTime startTimeExpected = order.getDeliveryTimeslot().getStartTime();
      String dateExpected = order.getDeliveryDate();
      Assertions.assertThat(startDateTimeActual.toString())
          .as("Delivery start date is not as expected in order_events DB record")
          .isEqualTo(f("%sT%s", dateExpected, startTimeExpected.toString()));

      LocalDateTime endDateTimeActual = LocalDateTime.ofInstant(Instant.ofEpochMilli(
          jo.getJSONObject("delivery_end_time").getLong("new_value")), ZoneId.systemDefault());
      LocalTime endTimeExpected = order.getDeliveryTimeslot().getEndTime();
      Assertions.assertThat(endDateTimeActual.toString())
          .as("Delivery end date is not as expected in order_events DB record")
          .isEqualTo(f("%sT%s", dateExpected, endTimeExpected.toString()));
    } catch (JSONException e) {
      e.printStackTrace();
    }
  }

  @Then("^DB Operator verify (-?\\d+) order_events record for the created order:$")
  public void operatorVerifyOrderEventParams(int index, Map<String, String> mapOfData) {
    Long orderId = get(KEY_CREATED_ORDER_ID);
    List<OrderEvents> orderEvents = eventsDao.getOrderEvents(orderId);
    assertThat(f("Order %d events list", orderId), orderEvents, not(empty()));
    if (index <= 0) {
      index = orderEvents.size() + index;
    }
    OrderEvents theLastOrderEvent = orderEvents.get(index - 1);
    String value = mapOfData.get("type");

    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(theLastOrderEvent.getType()).as("Type")
          .isEqualTo(Integer.parseInt(value));
    }
  }

  @Then("^DB Operator verify order_events record for the created order:$")
  public void operatorVerifyOrderEventRecordParams(Map<String, String> mapOfData) {
    // order event is an async process, the order event may not created yet when accessing this step
    retryIfAssertionErrorOccurred(() -> {
      Long orderId = get(KEY_CREATED_ORDER_ID);
      List<OrderEvents> orderEvents = eventsDao.getOrderEvents(orderId);
      assertThat(f("Order %d events list", orderId), orderEvents, not(empty()));
      String value = mapOfData.get("type");
      orderEvents.stream()
          .filter(record -> {
            if (StringUtils.isNotBlank(value)) {
              return Integer.parseInt(value) == record.getType();
            }
            return false;
          })
          .findFirst()
          .orElseThrow(() -> new AssertionError(
              f("Event record %s for order %d was not found", mapOfData.toString(), orderId)));
    }, "Check DB for order event");
  }

  @Then("^DB Operator verify transaction_failure_reason record for the created order$")
  public void dbOperatorVerifyTransactionFailureReasonForTheCreatedOrder() {
    FailureReason failureReason = get(KEY_SELECTED_FAILURE_REASON);
    Order orderAfterDelivery = get(KEY_CREATED_ORDER_AFTER_DELIVERY);
    List<Transaction> transactions = orderAfterDelivery.getTransactions();
    Transaction deliveryTransaction = transactions.stream()
        .filter(transaction -> TRANSACTION_TYPE_DELIVERY.equals(transaction.getType()))
        .findFirst()
        .orElseThrow(() -> new AssertionError("Delivery transaction not found"));
    TransactionFailureReasonEntity transactionFailureReason = getCoreJdbc()
        .findTransactionFailureReasonByTransactionId(deliveryTransaction.getId());
    Assertions.assertThat((long) transactionFailureReason.getFailureReasonCodeId())
        .as("failure_reason_code_id").isEqualTo((long) failureReason.getFailureReasonCodeId());
  }

  @Then("^DB Operator verify Pickup transaction record is updated for the created order$")
  public void dbOperatorVerifyPickupTransactionRecordUpdatedForTheCreatedOrder() {
    Order order = get(KEY_CREATED_ORDER);
    String type = "PP";
    List<TransactionEntity> transactions = getCoreJdbc()
        .findTransactionByOrderIdAndType(order.getId(), type);

    assertThat(f("There is more than 1 %s transaction for orderId %d", type, order.getId()),
        transactions, hasSize(1));
    TransactionEntity entity = transactions.get(0);
    Assertions.assertThat(StringUtils.normalizeSpace(entity.getAddress1())).as("From Address 1")
        .isEqualTo(order.getFromAddress1());
    Assertions.assertThat(StringUtils.normalizeSpace(entity.getAddress2())).as("From Address 2")
        .isEqualTo(order.getFromAddress2());
    Assertions.assertThat(StringUtils.normalizeSpace(entity.getPostcode())).as("From Postcode")
        .isEqualTo(order.getFromPostcode());
    Assertions.assertThat(StringUtils.normalizeSpace(entity.getCity())).as("From City")
        .isEqualTo(order.getFromCity());
    Assertions.assertThat(StringUtils.normalizeSpace(entity.getCountry())).as("From Country")
        .isEqualTo(order.getFromCountry());
    Assertions.assertThat(StringUtils.normalizeSpace(entity.getName())).as("From Name")
        .isEqualTo(order.getFromName());
    Assertions.assertThat(StringUtils.normalizeSpace(entity.getEmail())).as("From Email")
        .isEqualTo(order.getFromEmail());
    Assertions.assertThat(StringUtils.normalizeSpace(entity.getContact())).as("From Contact")
        .isEqualTo(order.getFromContact());
    ZonedDateTime entityStartDateTime = ZonedDateTime
        .parse(entity.getStartTime(), DateUtil.DATE_TIME_FORMATTER.withZone(ZoneId.of("UTC")))
        .withZoneSameInstant(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE));
    ZonedDateTime entityEndDateTime = ZonedDateTime
        .parse(entity.getEndTime(), DateUtil.DATE_TIME_FORMATTER.withZone(ZoneId.of("UTC")))
        .withZoneSameInstant(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE));
    assertEquals("Pickup start date/time",
        order.getPickupDate() + " " + TIME_FORMATTER_1
            .format(order.getPickupTimeslot().getStartTime()),
        DateUtil.displayDateTime(entityStartDateTime));
    assertEquals("Pickup end date/time",
        order.getPickupDate() + " " + TIME_FORMATTER_1
            .format(order.getPickupTimeslot().getEndTime()),
        DateUtil.displayDateTime(entityEndDateTime));
  }

  @Then("^DB Operator verify the last (Pickup|Delivery) transaction record of the created order:$")
  public void dbOperatorVerifyPickupTransactionRecordUpdatedForTheCreatedOrder(String tranType,
      Map<String, String> data) {
    TransactionEntity expected = new TransactionEntity(resolveKeyValues(data));
    Order order = get(KEY_CREATED_ORDER);
    String type = tranType.equalsIgnoreCase("Pickup") ? "PP" : "DD";
    List<TransactionEntity> transactions = getCoreJdbc()
        .findTransactionByOrderIdAndType(order.getId(), type);

    Assertions.assertThat(transactions)
        .as("List of %s transactions of the %s order", tranType, order.getId())
        .isNotEmpty();

    TransactionEntity actual = transactions.get(transactions.size() - 1);
    expected.compareWithActual(actual);
    put(KEY_WAYPOINT_ID, actual.getWaypointId());
  }

  @Then("^DB Operator verify Delivery transaction record is updated for the created order$")
  public void dbOperatorVerifyDeliveryTransactionRecordUpdatedForTheCreatedOrder() {
    Order order = get(KEY_CREATED_ORDER);
    String type = "DD";
    List<TransactionEntity> transactions = getCoreJdbc()
        .findTransactionByOrderIdAndType(order.getId(), type);

    assertThat(f("There is more than 1 %s transaction for orderId %d", type, order.getId()),
        transactions, hasSize(1));
    TransactionEntity entity = transactions.get(0);
    Assertions.assertThat(StringUtils.normalizeSpace(entity.getAddress1())).as("To Address 1")
        .isEqualTo(order.getToAddress1());
    Assertions.assertThat(StringUtils.normalizeSpace(entity.getAddress2())).as("To Address 2")
        .isEqualTo(order.getToAddress2());
    Assertions.assertThat(StringUtils.normalizeSpace(entity.getPostcode())).as("To Postcode")
        .isEqualTo(order.getToPostcode());
    Assertions.assertThat(StringUtils.normalizeSpace(entity.getCity())).as("To City")
        .isEqualTo(order.getToCity());
    Assertions.assertThat(StringUtils.normalizeSpace(entity.getCountry())).as("To Country")
        .isEqualTo(order.getToCountry());
    Assertions.assertThat(StringUtils.normalizeSpace(entity.getName())).as("To Name")
        .isEqualTo(order.getToName());
    Assertions.assertThat(StringUtils.normalizeSpace(entity.getEmail())).as("To Email")
        .isEqualTo(order.getToEmail());
    Assertions.assertThat(StringUtils.normalizeSpace(entity.getContact())).as("To Contact")
        .isEqualTo(order.getToContact());
    ZonedDateTime entityStartDateTime = ZonedDateTime
        .parse(entity.getStartTime(), DateUtil.DATE_TIME_FORMATTER.withZone(ZoneId.of("UTC")))
        .withZoneSameInstant(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE));
    ZonedDateTime entityEndDateTime = ZonedDateTime
        .parse(entity.getEndTime(), DateUtil.DATE_TIME_FORMATTER.withZone(ZoneId.of("UTC")))
        .withZoneSameInstant(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE));
    assertEquals("Delivery start date/time",
        order.getDeliveryDate() + " " + TIME_FORMATTER_1
            .format(order.getDeliveryTimeslot().getStartTime()),
        DateUtil.displayDateTime(entityStartDateTime));
    assertEquals("Delivery end date/time",
        order.getDeliveryEndDate() + " " + TIME_FORMATTER_1
            .format(order.getDeliveryTimeslot().getEndTime()),
        DateUtil.displayDateTime(entityEndDateTime));
  }

  @Then("DB Operator verify {word} transaction record of order {value}:")
  public void dbOperatorVerifyTransactionRecord(String typeStr, String orderIdStr,
      Map<String, String> data) {
    String type = StringUtils.equalsIgnoreCase(typeStr, "Delivery") ? "DD" : "PP";
    long orderId = Long.parseLong(orderIdStr);
    TransactionEntity expected = new TransactionEntity(resolveKeyValues(data));

    List<TransactionEntity> transactions = getCoreJdbc().findTransactionByOrderIdAndType(orderId,
        type);
    assertThat(f("There is more than 1 %s transaction for orderId %d", type, orderId),
        transactions, hasSize(1));
    TransactionEntity actual = transactions.get(0);

    expected.compareWithActual(actual, "startTime", "endTime");

    SoftAssertions assertions = new SoftAssertions();
    if (expected.getStartTime() != null) {
      assertions.assertThat(actual.getDisplayedStartTime())
          .as("Start Time")
          .isEqualTo(expected.getStartTime());
    }
    if (expected.getEndTime() != null) {
      assertions.assertThat(actual.getDisplayedEndTime())
          .as("End Time")
          .isEqualTo(expected.getEndTime());
    }
    assertions.assertAll();
  }

  @Then("DB Operator verifies transactions record:")
  public void verifyTransaction(Map<String, String> data) {
    data = resolveKeyValues(data);
    TransactionEntity expected = new TransactionEntity(data);

    List<TransactionEntity> transactions = getCoreJdbc()
        .findTransactionByOrderIdAndType(expected.getOrderId(), expected.getType());
    if (expected.getWaypointId() != null) {
      TransactionEntity actual = transactions.stream()
          .filter(t -> Objects.equals(t.getWaypointId(), expected.getWaypointId()))
          .findFirst()
          .orElseThrow(() ->
              new AssertionError(
                  "Transaction with waypointId = " + expected.getWaypointId() + " was not found")
          );
      assertTransaction(expected, actual, data);
    } else {
      Map<String, String> finalData = data;
      transactions.stream()
          .filter(t -> {
            try {
              assertTransaction(expected, t, finalData);
              return true;
            } catch (AssertionError e) {
              return false;
            }
          })
          .findFirst()
          .orElseThrow(() ->
              new AssertionError(
                  "Transaction " + finalData + " was not found")
          );
    }
  }

  @Then("DB Operator verifies waypoints record:")
  public void verifyWaypoint(Map<String, String> data) {
    Waypoint expected = new Waypoint(resolveKeyValues(data));

    Waypoint actual = getCoreJdbc().findWaypointById(expected.getId());
    Assertions.assertThat(actual)
        .as("Waypoint with id=%s", expected.getId())
        .isNotNull();
    expected.compareWithActual(actual);
  }

  @Then("DB Operator verifies route_monitoring_data record:")
  public void verifyRouteMonitoringData(Map<String, String> data) {
    data = resolveKeyValues(data);
    long waypointId = Long.parseLong(data.get("waypointId"));
    long routeId = Long.parseLong(data.get("routeId"));

    RouteMonitoringDataEntity result = this.getCoreJdbc()
        .getRouteMonitoringDataEntity(waypointId, routeId);
    Assertions.assertThat(result)
        .as("route_monitoring_data record for waypointId %s and routeId %s", waypointId, routeId)
        .isNotNull();
  }

  private void assertTransaction(TransactionEntity expected, TransactionEntity actual,
      Map<String, String> data) {
    expected.compareWithActual(actual, data, "startTime", "endTime");

    SoftAssertions assertions = new SoftAssertions();
    if (StringUtils.isNotBlank(expected.getStartTime())) {
      assertions.assertThat(actual.getDisplayedStartTime())
          .as("Start Time")
          .isEqualTo(expected.getStartTime());
    }
    if (StringUtils.isNotBlank(expected.getEndTime())) {
      assertions.assertThat(actual.getDisplayedEndTime())
          .as("End Time")
          .isEqualTo(expected.getEndTime());
    }
    assertions.assertAll();
  }

  @Then("^DB Operator verify next Delivery transaction values are updated for the created order:$")
  public void dbOperatorVerifyTransactionRecordUpdatedForTheCreatedOrderForParameters(
      Map<String, String> mapOfData) {
    Order order = get(KEY_CREATED_ORDER);
    String type = "DD";
    List<TransactionEntity> transactions = getCoreJdbc()
        .findTransactionByOrderIdAndType(order.getId(), type);

    assertThat(f("There is more than 1 %s transaction for orderId %d", type, order.getId()),
        transactions, hasSize(1));
    TransactionEntity entity = transactions.get(0);
    put(KEY_WAYPOINT_ID, entity.getWaypointId());
    put(KEY_TRANSACTION_ID, entity.getId());
    String distributionPointId = mapOfData.get("distribution_point_id");
    String address1 =
        Objects.equals(mapOfData.get("address1"), "GET_FROM_CREATED_ORDER") ? order.getToAddress1()
            :
                mapOfData.get("address1");
    String address2 =
        Objects.equals(mapOfData.get("address2"), "GET_FROM_CREATED_ORDER") ? order.getToAddress2()
            :
                mapOfData.get("address2");
    String city =
        Objects.equals(mapOfData.get("city"), "GET_FROM_CREATED_ORDER") ? order.getToCity() :
            mapOfData.get("city");
    String country =
        Objects.equals(mapOfData.get("country"), "GET_FROM_CREATED_ORDER") ? order.getToCountry() :
            mapOfData.get("country");
    String postcode =
        Objects.equals(mapOfData.get("postcode"), "GET_FROM_CREATED_ORDER") ? order.getToPostcode()
            :
                mapOfData.get("postcode");
    String routeId = mapOfData.get("routeId");
    String priorityLevel = mapOfData.get("priorityLevel");
    if (Objects.nonNull(distributionPointId)) {
      Integer distributionPointIdInt = Objects.equals(distributionPointId, "null") ? null
          : NumberUtils.createInteger(distributionPointId);
      Assertions.assertThat(entity.getDistributionPointId())
          .as("DistributionPointId in Transaction entity is not as expected in db")
          .isEqualTo(distributionPointIdInt);
    }
    if (Objects.nonNull(address1)) {
      Assertions.assertThat(StringUtils.normalizeSpace(entity.getAddress1()))
          .as("Address1 in Transaction entity is not as expected in db").isEqualTo(address1);
    }
    if (Objects.nonNull(address2)) {
      Assertions.assertThat(StringUtils.normalizeSpace(entity.getAddress2()))
          .as("Address2 in Transaction entity is not as expected in db").isEqualTo(address2);
    }
    if (Objects.nonNull(city)) {
      Assertions.assertThat(StringUtils.normalizeSpace(entity.getCity()))
          .as("City in Transaction entity is not as expected in db").isEqualTo(city);
    }
    if (Objects.nonNull(country)) {
      Assertions.assertThat(StringUtils.normalizeSpace(entity.getCountry()))
          .as("Country in Transaction entity is not as expected in db").isEqualTo(country);
    }
    if (Objects.nonNull(postcode)) {
      Assertions.assertThat(StringUtils.normalizeSpace(entity.getPostcode()))
          .as("Postcode in Transaction entity is not as expected in db").isEqualTo(postcode);
    }
    if (Objects.nonNull(routeId)) {
      Integer routeIdInt =
          Objects.equals(routeId, "null") ? null : NumberUtils.createInteger(routeId);
      Assertions.assertThat(entity.getRouteId())
          .as("RouteId in Transaction entity is not as expected in db").isEqualTo(routeIdInt);
    }
    if (Objects.nonNull(priorityLevel)) {
      Integer priorityLevelInt =
          Objects.equals(priorityLevel, "null") ? null : NumberUtils.createInteger(priorityLevel);
      Assertions.assertThat(entity.getPriorityLevel())
          .as("PriorityLevel in Transaction entity is not as expected in db")
          .isEqualTo(priorityLevelInt);
    }
  }

  @Then("^DB Operator verify next Pickup transaction values are updated for the created order:$")
  public void dbOperatorVerifyPickupTransactionRecordUpdatedForTheCreatedOrderForParameters(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    mapOfData = StandardTestUtils.replaceDataTableTokens(mapOfData);

    Order order;
    if (mapOfData.containsKey("orderId")) {
      Long orderId = Long.parseLong(mapOfData.get("orderId"));
      List<Order> orders = get(KEY_LIST_OF_CREATED_ORDER);
      order = orders.stream()
          .filter(o -> Objects.equals(o.getId(), orderId))
          .findFirst()
          .orElseThrow(
              () -> new IllegalArgumentException("Order with id " + orderId + " was not created"));
    } else {
      order = get(KEY_CREATED_ORDER);
    }
    String type = "PP";
    List<TransactionEntity> transactions = getCoreJdbc()
        .findTransactionByOrderIdAndType(order.getId(), type);

    assertThat(f("There is more than 1 %s transaction for orderId %d", type, order.getId()),
        transactions, hasSize(1));
    TransactionEntity entity = transactions.get(0);
    put(KEY_WAYPOINT_ID, entity.getWaypointId());
    put(KEY_TRANSACTION_ID, entity.getId());

    String routeId = mapOfData.get("routeId");
    String priorityLevel = mapOfData.get("priorityLevel");
    String status = mapOfData.get("status");
    String serviceEndTime = mapOfData.get("serviceEndTime");
    if (StringUtils.isNotBlank(routeId)) {
      Integer routeIdInt = StringUtils.equalsIgnoreCase(routeId, "null") ? null :
          NumberUtils.createInteger(routeId);
      Assertions.assertThat(entity.getRouteId())
          .as("RouteId in DB Transaction entity is not as expected").isEqualTo(routeIdInt);
    }
    if (StringUtils.isNotBlank(priorityLevel)) {
      Integer priorityLevelInt = StringUtils.equalsIgnoreCase(priorityLevel, "null") ? null :
          NumberUtils.createInteger(priorityLevel);
      Assertions.assertThat(entity.getPriorityLevel())
          .as("PriorityLevel in DB Transaction entity is not as expected")
          .isEqualTo(priorityLevelInt);
    }
    if (StringUtils.isNotBlank(status)) {
      Assertions.assertThat(entity.getStatus())
          .as("Status in DB Transaction entity is not as expected").isEqualTo(status);
    }
    if (StringUtils.isNotBlank(serviceEndTime)) {
      Assertions.assertThat(DateUtil.SDF_YYYY_MM_DD.format(entity.getServiceEndTime()))
          .as("Service End Time in DB Transaction entity is not as expected")
          .isEqualTo(serviceEndTime);
    }
  }

  @Then("^DB Operator verify the last inbound_scans record for the created order:$")
  public void dbOperatorVerifyTheLastInboundScansRecord(Map<String, String> data) {
    data = resolveKeyValues(data);
    Long orderId = get(KEY_CREATED_ORDER_ID);
    Order order = get(KEY_CREATED_ORDER);
    List<InboundScanEntity> inboundScans = getCoreJdbc().findInboundScansByOrderId(orderId);
    Assertions.assertThat(inboundScans).as("List of inbound scans for order ").isNotEmpty();
    InboundScanEntity theLastInboundScan = inboundScans.get(inboundScans.size() - 1);

    String value = data.get("hubId");

    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(theLastInboundScan.getHubId()).as("Hub ID")
          .isEqualTo(Long.valueOf(value));
    }

    value = data.get("type");

    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(theLastInboundScan.getType()).as("Type")
          .isEqualTo(Short.valueOf(value));
    }

    String trackingId =
        "GET_FROM_CREATED_ORDER".equalsIgnoreCase(data.get("trackingId")) ? order.getTrackingId() :
            data.get("trackingId");

    if (StringUtils.isNotBlank(trackingId)) {
      Assertions.assertThat(theLastInboundScan.getScan()).as("TrackingId").isEqualTo(trackingId);
    }

    if (data.containsKey("scan")) {
      Assertions.assertThat(theLastInboundScan.getScan()).as("Scan").isEqualTo(data.get("scan"));
    }

    if (data.containsKey("orderId")) {
      Assertions.assertThat(theLastInboundScan.getOrderId()).as("Order ID")
          .isEqualTo(Long.valueOf(data.get("orderId")));
    }
  }

  @After(value = "@DeleteDpPartner")
  public void deleteDpPartner() {
    DpPartner dpPartner = get(KEY_DP_PARTNER);

    if (dpPartner != null) {
      getDpJdbc().deleteDpPartner(dpPartner.getName());
    }
  }

  @After(value = "@DeleteDpAndPartner")
  public void deleteDp() {
    DpPartner dpPartner = get(KEY_DP_PARTNER);

    if (dpPartner != null) {
      getDpJdbc().deleteDp(dpPartner.getName());
      getDpJdbc().deleteDpPartner(dpPartner.getName());
    }
  }

  @After(value = "@DeleteDpUserDpAndPartner")
  public void deleteDpUser() {
    DpPartner dpPartner = get(KEY_DP_PARTNER);

    if (dpPartner != null) {
      getDpJdbc().deleteDpUser(dpPartner.getName());
      getDpJdbc().deleteDp(dpPartner.getName());
      getDpJdbc().deleteDpPartner(dpPartner.getName());
    }
  }

  @Given("DB Operator get data of created driver")
  public void dbOperatorGetDataOfCreatedDriver() {
    DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
    DriverEntity driverEntity = getDriverJdbc().getDriverData(driverInfo.getUsername());
    driverInfo.setId(driverEntity.getId());
    driverInfo.setUuid(driverEntity.getUuid());
    put(KEY_CREATED_DRIVER_UUID, driverInfo.getUuid());
  }

  @Given("DB Operator find drivers by {string} first name")
  public void findDriversByFirstName(String firstName) {
    List<Driver> drivers = getDriverJdbc().findDriversByFirstName(resolveValue(firstName));
    put(KEY_DB_FOUND_DRIVERS, drivers);
  }

  @Given("DB Operator find drivers with ended employment")
  public void findDriversWithEndedEmployment() {
    List<Driver> drivers = getDriverJdbc().findDriversWithEndedEmployment();
    put(KEY_DB_FOUND_DRIVERS, drivers);
  }

  @Given("DB Operator find drivers by {string} driver type name")
  public void findDriversByDriverTypeName(String driverTypeName) {
    List<Driver> drivers = getDriverJdbc()
        .findDriversByDriverTypeName(resolveValue(driverTypeName));
    put(KEY_DB_FOUND_DRIVERS, drivers);
  }

  @After(value = "@DeleteShipment")
  public void deleteShipment() {
    Set<Long> ids = new HashSet<>();
    List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);
    if (CollectionUtils.isNotEmpty(shipmentIds)) {
      ids.addAll(shipmentIds);
    }
    shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_IDS);
    if (CollectionUtils.isNotEmpty(shipmentIds)) {
      ids.addAll(shipmentIds);
    }
    ids.forEach(id -> {
      try {
        getHubJdbc().deleteShipment(id);
      } catch (Throwable ex) {
        LOGGER.warn("Could not delete shipment", ex);
      }
    });
  }

  @After(value = "@DeleteShipments")
  public void deleteShipments() {
    ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
    if (shipmentInfo != null) {
      getHubJdbc().deleteShipment(shipmentInfo.getId());
      return;
    }

    List<Long> createdShipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_IDS);
    if (createdShipmentIds != null && createdShipmentIds.size() != 0) {
      for (Long createdShipmentId : createdShipmentIds) {
        getHubJdbc().deleteShipment(createdShipmentId);
      }
    }
  }

  @After(value = "@DeleteSortAppUser")
  public void deleteSortAppUser() {
    if (get(KEY_CREATED_SORT_APP_USERNAME) != null) {
      getHubJdbc().deleteSortAppUser(get(KEY_CREATED_SORT_APP_USERNAME));
      getAuthJdbc().softDeleteOauthClientByClientId(get(KEY_CREATED_SORT_APP_USERNAME));
    }
  }

  @Given("DB Operator gets the newest existed username for Sort App")
  public void dbOperatorGetsTheNewestExistedUsernameForSortApp() {
    String username = getHubJdbc().getExistedUsername();
    put(KEY_EXISTED_SORT_APP_USERNAME, username);
  }

  @Given("DB Operator gets the {int} shipment IDs")
  public void dbOperatorGetsTheShipmentIds(int shipmentNeeded) {
    List<Long> shipmentIds = getHubJdbc().getExistedShipmentId(shipmentNeeded);
    put(KEY_LIST_OF_CREATED_SHIPMENT_ID, shipmentIds);
  }

  @SuppressWarnings("unchecked")
  @Given("^DB Operator verifies warehouse_sweeps record$")
  public void dbOperatorVerifiesWareHouseSweepsRecord(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String trackingId = mapOfData.get("trackingId");
    String hubId = mapOfData.get("hubId");

    if (StringUtils.equalsIgnoreCase(trackingId, "CREATED")) {
      trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    }

    Order order = get(KEY_CREATED_ORDER);

    final String finalTrackingId = trackingId;

    List<Map<String, Object>> warehouseSweepRecordsFiltered = retryIfExpectedExceptionOccurred(() ->
    {
      List<Map<String, Object>> warehouseSweepRecords = getCoreJdbc()
          .findWarehouseSweepRecord(finalTrackingId);
      List<Map<String, Object>> warehouseSweepRecordsFilteredTemp = warehouseSweepRecords.stream()
          .filter(record -> record.get("scan").equals(finalTrackingId))
          .collect(Collectors.toList());

      Assertions.assertThat(warehouseSweepRecordsFilteredTemp.size())
          .as(f("Expected 1 record in Warehouse_sweeps table with tracking ID %s", finalTrackingId))
          .isEqualTo(1);
      return warehouseSweepRecordsFilteredTemp;
    }, getCurrentMethodName(), LOGGER::warn, 500, 30, AssertionError.class);

    Map<String, Object> warehouseSweepRecord = warehouseSweepRecordsFiltered.get(0);
    Assertions.assertThat(String.valueOf(warehouseSweepRecord.get("hub_id")))
        .as(f("Expected hub_id in Warehouse_sweeps table")).isEqualTo(hubId);
    Assertions.assertThat(String.valueOf(warehouseSweepRecord.get("order_id")))
        .as(f("Expected order_id in Warehouse_sweeps table"))
        .isEqualTo(String.valueOf(order.getId()));
    put(KEY_WAREHOUSE_SWEEPS_ID, warehouseSweepRecord.get("id"));
  }

  @SuppressWarnings("unchecked")
  @Given("DB Operator verifies pickup info is updated in order record")
  public void dbOperatorVerifiesPickupInfoInOrderRecord() {
    Order order = get(KEY_CREATED_ORDER);
    final String finalTrackingId = order.getTrackingId();
    List<Order> pickupInfoRecordsFiltered = retryIfExpectedExceptionOccurred(() ->
    {
      List<Order> pickupInfoRecords = getCoreJdbc().getOrderByTrackingId(finalTrackingId);
      List<Order> pickupInfoRecordsTemp = pickupInfoRecords.stream()
          .filter(record -> record.getTrackingId().equals(finalTrackingId))
          .collect(Collectors.toList());

      Assertions.assertThat(pickupInfoRecordsTemp.size())
          .as(f("Expected 1 record in Orders table with tracking ID %s", finalTrackingId))
          .isEqualTo(1);
      return pickupInfoRecordsTemp;
    }, getCurrentMethodName(), LOGGER::warn, 500, 30, AssertionError.class);

    Order pickupInfoRecord = pickupInfoRecordsFiltered.get(0);

    Assertions.assertThat(pickupInfoRecord.getFromAddress1())
        .as(f("Expected %s in %s table", "from_address1", "orders"))
        .isEqualTo(order.getFromAddress1());
    Assertions.assertThat(pickupInfoRecord.getFromAddress2())
        .as(f("Expected %s in %s table", "from_address2", "orders"))
        .isEqualTo(order.getFromAddress2());
    Assertions.assertThat(pickupInfoRecord.getFromPostcode())
        .as(f("Expected %s in %s table", "from_postcode", "orders"))
        .isEqualTo(order.getFromPostcode());
    Assertions.assertThat(pickupInfoRecord.getFromCity())
        .as(f("Expected %s in %s table", "from_city", "orders")).isEqualTo(order.getFromCity());
    Assertions.assertThat(pickupInfoRecord.getFromCountry())
        .as(f("Expected %s in %s table", "from_country", "orders"))
        .isEqualTo(order.getFromCountry());
    Assertions.assertThat(pickupInfoRecord.getFromName())
        .as(f("Expected %s in %s table", "from_name", "orders")).isEqualTo(order.getFromName());
    Assertions.assertThat(pickupInfoRecord.getFromEmail())
        .as(f("Expected %s in %s table", "from_email", "orders")).isEqualTo(order.getFromEmail());
    Assertions.assertThat(pickupInfoRecord.getFromContact())
        .as(f("Expected %s in %s table", "from_contact", "orders"))
        .isEqualTo(order.getFromContact());
  }

  @SuppressWarnings("unchecked")
  @Given("^DB Operator verifies delivery info is updated in order record$")
  public void dbOperatorVerifiesDeliveryInfoInOrderRecord() {
    Order order = get(KEY_CREATED_ORDER);
    final String finalTrackingId = order.getTrackingId();
    List<Order> deliveryInfoRecordsFiltered = retryIfExpectedExceptionOccurred(() ->
    {
      List<Order> deliveryInfoRecords = getCoreJdbc().getOrderByTrackingId(finalTrackingId);
      List<Order> deliveryInfoRecordsTemp = deliveryInfoRecords.stream()
          .filter(record -> record.getTrackingId().equals(finalTrackingId))
          .collect(Collectors.toList());

      Assertions.assertThat(deliveryInfoRecordsTemp.size())
          .as(f("Expected 1 record in Orders table with tracking ID %s", finalTrackingId))
          .isEqualTo(1);
      return deliveryInfoRecordsTemp;
    }, getCurrentMethodName(), LOGGER::warn, 500, 30, AssertionError.class);

    Order deliveryInfoRecord = deliveryInfoRecordsFiltered.get(0);

    Assertions.assertThat(deliveryInfoRecord.getToAddress1())
        .as(f("Expected %s in %s table", "to_address1", "orders")).isEqualTo(order.getToAddress1());
    Assertions.assertThat(deliveryInfoRecord.getToAddress2())
        .as(f("Expected %s in %s table", "to_address2", "orders"))
        .isEqualTo(Objects.nonNull(order.getToAddress2()) ? order.getToAddress2() : "");
    Assertions.assertThat(deliveryInfoRecord.getToPostcode())
        .as(f("Expected %s in %s table", "to_postcode", "orders")).isEqualTo(order.getToPostcode());
    Assertions.assertThat(deliveryInfoRecord.getToCity())
        .as(f("Expected %s in %s table", "to_city", "orders"))
        .isEqualTo(Objects.isNull(order.getToCity()) ? "" : order.getToCity());
    Assertions.assertThat(deliveryInfoRecord.getToCountry())
        .as(f("Expected %s in %s table", "to_country", "orders")).isEqualTo(order.getToCountry());
    Assertions.assertThat(deliveryInfoRecord.getToName())
        .as(f("Expected %s in %s table", "to_name", "orders")).isEqualTo(order.getToName());
    Assertions.assertThat(deliveryInfoRecord.getToEmail())
        .as(f("Expected %s in %s table", "to_email", "orders")).isEqualTo(order.getToEmail());
    Assertions.assertThat(deliveryInfoRecord.getToContact())
        .as(f("Expected %s in %s table", "to_contact", "orders")).isEqualTo(order.getToContact());
  }

  @Given("DB Operator verifies reservation record using data below:")
  public void dbOperatorVerifiesReservationRecord(Map<String, String> mapOfData) {
    Reservation reservation = get(KEY_CREATED_RESERVATION);
    reservation = getCoreJdbc().getReservationRecordByAddressId(reservation.getAddressId());

    if (Objects.nonNull(mapOfData.get("status"))) {
      int status = Integer.parseInt(mapOfData.get("status"));
      Assertions.assertThat(reservation.getStatusValue())
          .as(f("Expected %s in %s table", "status", "reservations")).isEqualTo(status);
    }
  }

  @Given("DB Operator verifies waypoint record using data below:")
  public void dbOperatorVerifiesWaypointRecord(Map<String, String> mapOfData) {
    Reservation reservation = get(KEY_CREATED_RESERVATION);
    Waypoint waypoint = getCoreJdbc().getWaypoint(reservation.getWaypointId());

    if (Objects.nonNull(mapOfData.get("status"))) {
      String status = mapOfData.get("status");
      Assertions.assertThat(waypoint.getStatus())
          .as(f("Expected %s in %s table", "status", "waypoints")).isEqualTo(status);
    }
  }

  @SuppressWarnings("unchecked")
  @Given("DB Operator verifies orders record using data below:")
  public void dbOperatorVerifiesOrdersRecord(Map<String, String> data) {
    data = resolveKeyValues(data);
    Order order = get(KEY_CREATED_ORDER);
    final String finalTrackingId = order.getTrackingId();
    List<Order> orderRecordsFiltered = retryIfExpectedExceptionOccurred(() ->
    {
      List<Order> orderRecords = getCoreJdbc().getOrderByTrackingId(finalTrackingId);
      List<Order> orderRecordsTemp = orderRecords.stream()
          .filter(record -> record.getTrackingId().equals(finalTrackingId))
          .collect(Collectors.toList());

      Assertions.assertThat(orderRecordsTemp.size())
          .as(f("Expected 1 record in Orders table with tracking ID %s", finalTrackingId))
          .isEqualTo(1);
      return orderRecordsTemp;
    }, getCurrentMethodName(), LOGGER::warn, 500, 30, AssertionError.class);

    Order orderRecord = orderRecordsFiltered.get(0);

    if (Objects.nonNull(data.get("status"))) {
      String status = data.get("status");
      Assertions.assertThat(orderRecord.getStatus())
          .as(f("Expected %s in %s table", "status", "orders")).isEqualTo(status);
    }
    if (Objects.nonNull(data.get("granularStatus"))) {
      String granularStatus = data.get("granularStatus");
      Assertions.assertThat(orderRecord.getGranularStatus())
          .as(f("Expected %s in %s table", "granularStatus", "orders")).isEqualTo(granularStatus);
    }
    if (Objects.nonNull(data.get("toAddress1"))) {
      String toAddress1 =
          Objects.equals(data.get("toAddress1"), "GET_FROM_CREATED_ORDER") ? order
              .getToAddress1() :
              data.get("toAddress1");
      Assertions.assertThat(orderRecord.getToAddress1())
          .as(f("Expected %s in %s table", "to_address1", "orders")).isEqualTo(toAddress1);
    }
    if (Objects.nonNull(data.get("toAddress2"))) {
      String toAddress2 =
          Objects.equals(data.get("toAddress2"), "GET_FROM_CREATED_ORDER") ? order
              .getToAddress2() :
              data.get("toAddress2");
      Assertions.assertThat(orderRecord.getToAddress2())
          .as(f("Expected %s in %s table", "to_address2", "orders")).isEqualTo(toAddress2);
    }
    if (Objects.nonNull(data.get("toPostcode"))) {
      String toPostcode =
          Objects.equals(data.get("toPostcode"), "GET_FROM_CREATED_ORDER") ? order
              .getToPostcode() :
              data.get("toPostcode");
      Assertions.assertThat(orderRecord.getToPostcode())
          .as(f("Expected %s in %s table", "to_postcode", "orders")).isEqualTo(toPostcode);
    }
    if (Objects.nonNull(data.get("toCity"))) {
      String toCity =
          Objects.equals(data.get("toCity"), "GET_FROM_CREATED_ORDER") ? order.getToCity() :
              data.get("toCity");
      Assertions.assertThat(orderRecord.getToCity())
          .as(f("Expected %s in %s table", "to_city", "orders")).isEqualTo(toCity);
    }
    if (Objects.nonNull(data.get("toCountry"))) {
      String toCountry =
          Objects.equals(data.get("toCountry"), "GET_FROM_CREATED_ORDER") ? order
              .getToCountry() :
              data.get("toCountry");
      Assertions.assertThat(orderRecord.getToCountry())
          .as(f("Expected %s in %s table", "to_country", "orders")).isEqualTo(toCountry);
    }
    if (Objects.nonNull(data.get("toState"))) {
      String toState =
          Objects.equals(data.get("toState"), "GET_FROM_CREATED_ORDER") ? order.getToState() :
              data.get("toState");
      Assertions.assertThat(orderRecord.getToState())
          .as(f("Expected %s in %s table", "to_state", "orders")).isEqualTo(toState);
    }
    if (Objects.nonNull(data.get("toDistrict"))) {
      String toDistrict =
          Objects.equals(data.get("toDistrict"), "GET_FROM_CREATED_ORDER") ? order
              .getToDistrict() :
              data.get("toDistrict");
      Assertions.assertThat(orderRecord.getToDistrict())
          .as(f("Expected %s in %s table", "to_district", "orders")).isEqualTo(toDistrict);
    }
    if (StringUtils.isNotBlank(data.get("rts"))) {
      boolean expected = StringUtils.equalsAnyIgnoreCase(data.get("rts"), "1", "true");
      Assertions.assertThat(orderRecord.getRts()).as("RTS").isEqualTo(expected);
    }
    if (StringUtils.isNotBlank(data.get("dimensions"))) {
      Dimension expected = new Dimension(data.get("dimensions"));
      Dimension actual = orderRecord.getDimensions();
      expected.compareWithActual(actual);
    }
    if (StringUtils.isNotBlank(data.get("parcelSizeId"))) {
      Assertions.assertThat(orderRecord.getParcelSizeId())
          .as("parcel_size_id")
          .isEqualTo(Long.valueOf(data.get("parcelSizeId")));
    }
  }

  @SuppressWarnings("unchecked")
  @Given("DB Operator verifies order is deleted")
  public void dbOperatorVerifiesOrderIsDeleted() {
    String trackingId;
    Order order = get(KEY_CREATED_ORDER);
    if (order != null) {
      trackingId = order.getTrackingId();
    } else {
      List<co.nvqa.common.core.model.order.Order> orders = get(KEY_LIST_OF_CREATED_ORDERS);
      if (CollectionUtils.isEmpty(orders)) {
        throw new IllegalArgumentException("KEY_LIST_OF_CREATED_ORDERS is empty");
      }
      trackingId = orders.get(orders.size() - 1).getTrackingId();
    }
    retryIfExpectedExceptionOccurred(() ->
    {
      List<Order> orderRecords = getCoreJdbc().getOrderByTrackingId(trackingId);

      Assertions.assertThat(orderRecords.size())
          .as(f("Expected 0 record in Orders table with tracking ID %s", trackingId))
          .isEqualTo(0);
      return orderRecords;
    }, getCurrentMethodName(), LOGGER::warn, 500, 30, AssertionError.class);
  }

  private void validatePickupInWaypointRecord(Order order, String transactionType,
      long waypointId) {
    Waypoint actualWaypoint = getCoreJdbc().getWaypoint(waypointId);
    Assertions.assertThat(StringUtils.normalizeSpace(actualWaypoint.getCity()))
        .as(f("%s waypoint [%d] city", transactionType, waypointId)).isEqualTo(order.getFromCity());
    Assertions.assertThat(StringUtils.normalizeSpace(actualWaypoint.getCountry()))
        .as(f("%s waypoint [%d] country", transactionType, waypointId))
        .isEqualTo(order.getFromCountry());
    Assertions.assertThat(StringUtils.normalizeSpace(actualWaypoint.getAddress1()))
        .as(f("%s waypoint [%d] address1", transactionType, waypointId))
        .isEqualTo(order.getFromAddress1());
    Assertions.assertThat(StringUtils.normalizeSpace(actualWaypoint.getAddress2()))
        .as(f("%s waypoint [%d] address2", transactionType, waypointId))
        .isEqualTo(order.getFromAddress2());
    Assertions.assertThat(StringUtils.normalizeSpace(actualWaypoint.getPostcode()))
        .as(f("%s waypoint [%d] postcode", transactionType, waypointId))
        .isEqualTo(order.getFromPostcode());
    //TODO need to clarify source of timewindow_id
//   Assertions.assertThat(Integer.parseInt(actualWaypoint.getTimeWindowId())).as(f("%s waypoint [%d] timewindowId", transactionType, waypointId)).isEqualTo(//        order.getPickupTimeslot().getId());
  }

  private void validateDeliveryInWaypointRecord(Order order, String transactionType,
      long waypointId) {
    Waypoint actualWaypoint = getCoreJdbc().getWaypoint(waypointId);
    assertEquals(f("%s waypoint [%d] city", transactionType, waypointId),
        Objects.isNull(order.getToCity()) ? "" :
            order.getToCity(), actualWaypoint.getCity());
    Assertions.assertThat(StringUtils.normalizeSpace(actualWaypoint.getCountry()))
        .as(f("%s waypoint [%d] country", transactionType, waypointId))
        .isEqualTo(order.getToCountry());
    Assertions.assertThat(StringUtils.normalizeSpace(actualWaypoint.getAddress1()))
        .as(f("%s waypoint [%d] address1", transactionType, waypointId))
        .isEqualTo(order.getToAddress1());
    Assertions.assertThat(StringUtils.normalizeSpace(actualWaypoint.getAddress2()))
        .as(f("%s waypoint [%d] address2", transactionType, waypointId))
        .isEqualTo(order.getToAddress2());
    Assertions.assertThat(StringUtils.normalizeSpace(actualWaypoint.getPostcode()))
        .as(f("%s waypoint [%d] postcode", transactionType, waypointId))
        .isEqualTo(order.getToPostcode());
    if (Objects.nonNull(order.getDeliveryTimeslot())) {
      Assertions.assertThat(Integer.parseInt(actualWaypoint.getTimeWindowId()))
          .as(f("%s waypoint [%d] timewindowId", transactionType, waypointId))
          .isEqualTo(order.getDeliveryTimeslot().getId());
    }
  }

  @Then("^DB Operator verify ticket status$")
  public void dbOperatorVerifyTicketStatus(Map<String, Integer> mapOfData)
      throws SQLException, ClassNotFoundException {
    Long orderId = get(KEY_CREATED_ORDER_ID);
    Integer expectedStatus = mapOfData.get("status");
    Integer ticketStatus = getTicketsJdbc().getTicketStatus(orderId);

    Assertions.assertThat(ticketStatus)
        .as(f("Expected ticket status %s but actual ticket status %d", expectedStatus,
            ticketStatus)).isEqualTo(expectedStatus);
  }

  @Then("^DB Operator verify reservation priority level$")
  public void dbOperatorReservationPriorityLevel(Map<String, Integer> mapOfData)
      throws SQLException, ClassNotFoundException {
    Long reservationId = get(KEY_CREATED_RESERVATION_ID);
    Integer expectedPriorityLevel = mapOfData.get("priorityLevel");
    Integer priorityLevel = getCoreJdbc().getReservationPriorityLevel(reservationId);

    Assertions.assertThat(priorityLevel)
        .as("Expected Reservation Priority Level %s but actual Priority Level %d",
            expectedPriorityLevel, priorityLevel).isEqualTo(expectedPriorityLevel);
  }

  @Then("^DB Operator verify the orders are deleted in order_batch_items DB$")
  public void dbOperatorVerifyBatchIdIsDeleted() throws SQLException, ClassNotFoundException {
    Long batchId = get(KEY_CREATED_BATCH_ID);
    Long result = getCoreJdbc().getBatchId(batchId);

    Assertions.assertThat(result).as(f("%s Batch ID Is Not Deleted", batchId)).isNull();
  }

  @When("DB Operator gets the id of the created middle mile driver")
  public void dbOperatorGetsTheIdOfTheCreatedMiddleMileDriver() {
    String driverUsername = get(KEY_CREATED_DRIVER_USERNAME);
    Long driverId = getDriverJdbc().getDriverIdByUsername(driverUsername);
    put(KEY_CREATED_DRIVER_ID, driverId);
  }

  @When("DB Operator gets the driver name by driver id for Trip Management")
  public void dbOperatorGetsTheDriverNameByDriverId() {
    TripManagementDetailsData tripManagementDetailsData = get(KEY_DETAILS_OF_TRIP_MANAGEMENT);
    int index = tripManagementDetailsData.getData().size() - 1;
    String driverUsername = null;

    if (tripManagementDetailsData.getData().get(index).getDrivers().size() != 0) {
      driverUsername = getDriverJdbc().getDriverUsernameById(
          tripManagementDetailsData.getData().get(index).getDrivers().get(0).getDriverId());
    }

    put(KEY_TRIP_MANAGEMENT_DRIVER_NAME, driverUsername);
  }

  @Then("Operator DB gets that the driver availability value")
  public void operatorDBGetsThatTheDriverAvailabilityValue() {
    String driverUsername = get(KEY_CREATED_DRIVER_USERNAME);
    boolean driverAvailability = getDriverJdbc().getDriverAvailabilityValue(driverUsername);
    put(KEY_CREATED_MIDDLE_MILE_DRIVER_AVAILABILITY, driverAvailability);
  }


  @Then("DB Operator verifies movement trip has event with status cancelled")
  public void dbOperatorVerifiesMovementTripHasEventWithStatusCancelled() {
    String tripId = get(KEY_TRIP_ID);
    MovementTripEventEntity movementTripEventEntity = getHubJdbc()
        .getNewestMovementTripEvent(Long.valueOf(tripId));
    String movementTripEntityEvent = movementTripEventEntity.getEvent().toLowerCase();
    String movementTripEntityStatus = movementTripEventEntity.getStatus().toLowerCase();
    String movementTripEntityUserId = movementTripEventEntity.getUserId().toLowerCase();
    assertEquals("cancelled", movementTripEntityEvent);
    assertEquals("cancelled", movementTripEntityStatus);
    assertEquals("qa@ninjavan.co", movementTripEntityUserId);
  }

  @Then("DB Operator verifies movement trip has event with status as below")
  public void dbOperatorVerifiesMovementTripHasEventWithStatusDeparted(Map<String, String> data) {
    String tripId = get(KEY_TRIP_ID);
    MovementTripEventEntity movementTripEventEntity = getHubJdbc()
        .getNewestMovementTripEvent(Long.valueOf(tripId));
    String movementTripEntityEvent = movementTripEventEntity.getEvent().toLowerCase();
    String movementTripEntityStatus = movementTripEventEntity.getStatus().toLowerCase();
    String movementTripEntityUserId = movementTripEventEntity.getUserId().toLowerCase();
    assertEquals(data.get("event"), movementTripEntityEvent);
    assertEquals(data.get("status"), movementTripEntityStatus);
    assertEquals(data.get("userId"), movementTripEntityUserId);
  }

  @Then("DB Operator verify path for shipment {string} appear in shipment_paths table")
  public void dbOperatorVerifyPathForShipmentAppearInShipmentPathsTable(String shipmentIdAsString) {
    shipmentIdAsString = resolveValue(shipmentIdAsString);
    Long shipmentId = Long.valueOf(shipmentIdAsString);
    ShipmentPathEntity shipmentPathEntity = getHubJdbc().getShipmentPathByShipmentId(shipmentId);
    assertNotNull(shipmentPathEntity.getSeqNo());
    assertNotNull(shipmentPathEntity.getTripId());
  }

  @Then("DB Operator verify inbound type {string} for shipment {string} appear in trip_shipment_scans table")
  public void dbOperatorVerifyInboundTypeForShipmentAppearInTripShipmentScansTable(
      String inboundType, String shipmentIdAsString) {
    shipmentIdAsString = resolveValue(shipmentIdAsString);
    Long shipmentId = Long.valueOf(shipmentIdAsString);
    String actualInboundType = getHubJdbc().getInboundScanTypeByShipmentId(shipmentId);
    assertEquals(inboundType.toLowerCase(), actualInboundType.toLowerCase());
  }

  @Then("DB Operator verifies driver {string} with username {string} and value {string} is updated")
  public void dbOperatorVerifiesDriverIsUpdatedWithValue(String column, String username,
      String updatedValue) {
    String resolvedUserName = resolveValue(username);
    String resolvedUpdatedValue = resolveValue(updatedValue);
    Driver driverData = getDriverJdbc().getDetailedDriverData(resolvedUserName);
    switch (column) {
      case "name":
        String actualName = driverData.getFirstName();
        Assertions.assertThat(actualName).as("Updated name is the same")
            .isEqualTo(resolvedUpdatedValue);
        break;
      case "contactNumber":
        Long driverId = driverData.getId();
        String actualContactNumber = getDriverJdbc().getLatestDriverContactNumber(driverId);
        Assertions.assertThat(actualContactNumber)
            .as("Updated contact number is the same")
            .contains(resolvedUpdatedValue);
        break;
      case "hub":
        String actualHubId = String.valueOf(driverData.getHubId());
        Assertions.assertThat(actualHubId).as("Updated hub is the same")
            .isEqualTo(resolvedUpdatedValue);
        break;
      case "licenseNumber":
        String actualLicenseNumber = driverData.getLicenseNumber();
        assertThat("Updated license number is the same", actualLicenseNumber,
            equalTo(resolvedUpdatedValue));
        break;
      case "licenseExpiryDate":
        String actualLicenseExpiryDate = driverData.getLicenseExpiryDate().split(" ")[0];
        assertThat("Updated license expiry date is the same", actualLicenseExpiryDate,
            equalTo(resolvedUpdatedValue));
        break;
      case "licenseType":
        String actualLicenseType = driverData.getLicenseType();
        assertThat("Updated license type is the same", actualLicenseType,
            equalTo(resolvedUpdatedValue));
        break;
      case "employmentType":
        String actualEmploymnetType = driverData.getEmploymentType();
        assertThat("Updated employment type is the same", actualEmploymnetType,
            equalTo(resolvedUpdatedValue));
        break;
      case "employmentStartDate":
        String actualEmploymentStartDate = driverData.getEmploymentStartDate().split(" ")[0];
        assertThat("Updated employment start date is the same", actualEmploymentStartDate,
            equalTo(resolvedUpdatedValue));
        break;
      case "employmentEndDate":
        String actualEmploymentEndDate = driverData.getEmploymentEndDate().split(" ")[0];
        assertThat("Updated employment end date is the same", actualEmploymentEndDate,
            equalTo(resolvedUpdatedValue));
        break;
    }
  }

  @Then("DB Operator verifies {string} path with origin {string} and {string} is created in movement_path table")
  public void dbOperatorVerifiesManualPathIsCreatedInMovementPathTable(String pathType,
      String originHubIdAsString, String destinationHubIdAsString) {
    dbOperatorVerifiesManualPathIsCreatedInMovementPathTableWithShipmentType(pathType,
        originHubIdAsString, destinationHubIdAsString, "");
  }

  @Then("DB Operator verifies {string} path with origin {string} and {string} with type {string} is created in movement_path table")
  public void dbOperatorVerifiesManualPathIsCreatedInMovementPathTableWithShipmentType(
      String pathType,
      String originHubIdAsString, String destinationHubIdAsString, String shipmentType) {
    Long originHubId = Long.valueOf(resolveValue(originHubIdAsString));
    Long destinationHubId = Long.valueOf(resolveValue(destinationHubIdAsString));

    String expectedMovementPathMovementType = "LAND_HAUL";
    String expectedMovementPathType = "MANUAL";
    if ("default".equals(pathType)) {
      expectedMovementPathType = "AUTO_GENERATED";
    }
    MovementPath movementPath = getHubJdbc()
        .getMovementPath(originHubId, destinationHubId, shipmentType, expectedMovementPathType);

    putInList(KEY_LIST_OF_CREATED_PATH_ID, movementPath.getId());
    if (StringUtils.isNotEmpty(shipmentType)) {
      expectedMovementPathMovementType = shipmentType;
    }
    assertThat("Movement path type is equal", movementPath.getType(),
        equalTo(expectedMovementPathType));
    assertThat("Movement path type is equal", movementPath.getMovementType(),
        equalTo(expectedMovementPathMovementType));
    pause1s();
  }

  @Then("DB Operator verifies number of path with origin {string} and {string} is {int} in movement_path table")
  public void dbOperatorVerifiesNoNewPathWithOriginIsCreatedInMovementPathTable(
      String originHubIdAsString, String destinationHubIdAsString, Integer numberOfPaths) {
    Long originHubId = Long.valueOf(resolveValue(originHubIdAsString));
    Long destinationHubId = Long.valueOf(resolveValue(destinationHubIdAsString));
    retryIfAssertionErrorOccurred(() -> {
      List<MovementPath> movementPaths = getHubJdbc()
          .getAllMovementPath(originHubId, destinationHubId);
      Assertions.assertThat(movementPaths.size()).as("Movement path length is equal")
          .isEqualTo(numberOfPaths);
      movementPaths
          .forEach(movementPath -> putInList(KEY_LIST_OF_CREATED_PATH_ID, movementPath.getId()));
    }, getCurrentMethodName(), 1000, 5);
  }

  @Then("DB Operator verifies number of path for {string} movement existence")
  public void dbOperatorVerifiesNumberOfPathForMovement(String scheduleType) {
    List<Hub> createdHubs = get(KEY_LIST_OF_CREATED_HUBS);
    Long originHubId = createdHubs.get(0).getId();
    Long destinationHubId;
    List<MovementPath> movementPaths;
    switch (scheduleType) {
      case HUB_ST_ST_SAME_CD:
      case HUB_ST_ITS_CD:
      case HUB_CD_ITS_ST:
        destinationHubId = createdHubs.get(1).getId();
        movementPaths = getHubJdbc().getAllMovementPath(originHubId, destinationHubId);
        movementPaths
            .forEach(movementPath -> putInList(KEY_LIST_OF_CREATED_PATH_ID, movementPath.getId()));
        Assertions.assertThat(movementPaths.size()).as("Movement path length is equal")
            .isEqualTo(3);
        break;
      case HUB_CD_CD:
      case HUB_CD_ST_DIFF_CD:
      case HUB_ST_CD_DIFF_CD:
      case HUB_ST_ST_DIFF_CD:
        destinationHubId = createdHubs.get(1).getId();
        movementPaths = getHubJdbc().getAllMovementPath(originHubId, destinationHubId);
        movementPaths
            .forEach(movementPath -> putInList(KEY_LIST_OF_CREATED_PATH_ID, movementPath.getId()));
        Assertions.assertThat(movementPaths.size()).as("Movement path length is equal")
            .isEqualTo(2);
        break;
    }
  }

  @Then("DB Operator verifies number of path for {string} movement existence after van inbound")
  public void dbOperatorVerifiesNumberOfPathForMovementAfterScheduleCreation(String scheduleType) {
    List<Hub> createdHubs = get(KEY_LIST_OF_CREATED_HUBS);
    Long originHubId = createdHubs.get(0).getId();
    Long destinationHubId;
    List<MovementPath> movementPaths;
    switch (scheduleType) {
      case HUB_ST_ST_SAME_CD:
      case HUB_CD_ITS_ST:
      case HUB_ST_ITS_CD:
        dbOperatorVerifiesNumberOfPathForMovement(scheduleType);
        break;
      case HUB_CD_ST_DIFF_CD:
      case HUB_ST_CD_DIFF_CD:
      case HUB_ST_ST_DIFF_CD:
      case HUB_CD_CD:
        destinationHubId = createdHubs.get(1).getId();
        movementPaths = getHubJdbc().getAllMovementPath(originHubId, destinationHubId);
        movementPaths
            .forEach(movementPath -> putInList(KEY_LIST_OF_CREATED_PATH_ID, movementPath.getId()));
        Assertions.assertThat(movementPaths.size()).as("Movement path length is equal")
            .isEqualTo(3);
        break;
    }
  }

  @Then("DB Operator verify {string} is deleted in movement_path table")
  public void dbOperatorVerifyPathIsDeletedInMovementPathTable(String pathIdAsString) {
    Long pathId = Long.valueOf(resolveValue(pathIdAsString));
    MovementPath movementPath = getHubJdbc().getMovementPathById(pathId);
    Assertions.assertThat(movementPath.getDeletedAt()).as("Movement path deleted at is not null")
        .isNotNull();
  }

  @Then("DB Operator verify {string} is deleted in hub_relation_schedules")
  public void dbOperatorVerifyScheduleIsDeletedInHubRelationSchedules(
      String hubRelationIdAsString) {
    Long hubRelationId = Long.valueOf(resolveValue(hubRelationIdAsString));
    HubRelationSchedule hubRelationSchedule = getHubJdbc()
        .getHubRelationScheduleByHubRelationId(hubRelationId);
    Assertions.assertThat(hubRelationSchedule.getDeletedAt()).as("Hub Relation not found")
        .isNotNull();
  }

  @Then("DB Operator verify {string} is not deleted in hub_relation_schedules")
  public void dbOperatorVerifyScheduleIsNotDeletedInHubRelationSchedules(
      String hubRelationIdAsString) {
    Long hubRelationId = Long.valueOf(resolveValue(hubRelationIdAsString));
    HubRelationSchedule hubRelationSchedule = getHubJdbc()
        .getHubRelationScheduleByHubRelationId(hubRelationId);
    Assertions.assertThat(hubRelationSchedule.getDeletedAt()).as("Hub Relation found")
        .isEqualTo(null);
  }

  @Then("DB Operator verify created hub relation schedules is not deleted")
  public void dbOperatorVerifyHubRelationScheduleIsNotDeletedFor() {
    List<HubRelation> hubRelations = get(KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP);
    List<HubRelation> createdHubRelations = hubRelations.subList(2, hubRelations.size());
    createdHubRelations.forEach(hubRelation -> {
      HubRelationSchedule hubRelationSchedule = getHubJdbc()
          .getHubRelationScheduleByHubRelationId(hubRelation.getId());
      Assertions.assertThat(hubRelationSchedule.getDeletedAt()).as("Hub Relation found")
          .isEqualTo(null);
    });
  }

  @Then("DB Operator verify created hub relation schedules is deleted")
  public void dbOperatorVerifyCreatedHubRelationSchedulesIsDeleted() {
    List<HubRelation> hubRelations = get(KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP);
    List<HubRelation> createdHubRelations = hubRelations.subList(2, hubRelations.size());
    createdHubRelations.forEach(hubRelation -> {
      HubRelationSchedule hubRelationSchedule = getHubJdbc()
          .getHubRelationScheduleByHubRelationId(hubRelation.getId());
      assertThat("Hub Relation not found", hubRelationSchedule.getDeletedAt(), not(equalTo(null)));
    });
  }

  @When("DB Operator verify sla in movement_events table is {string} no path for the following shipments from {string} to {string}:")
  public void dbOperatorVerifySlaFailedAndPathNotFoundInExtDataMovementEventsTableWithDataBelow(
      String expectedStatus, String originHub, String destHub, List<String> shipmentIds) {
    String expectedEvent = "SLA_CALCULATION";
    Long expectedOriginHub = Long.valueOf(resolveValue(originHub));
    Long expectedDestHub = Long.valueOf(resolveValue(destHub));
    String expectedExtData = f(
        "{\"path_cache\":{\"full_path\":null,\"trip_path\":null},\"crossdock_detail\":null," +
            "\"error_message\":\"found no path from origin %d (sg) to destination %d (sg)\"}",
        expectedOriginHub, expectedDestHub);
    for (String shipmentIdAsString : shipmentIds) {
      Long shipmentId = Long.valueOf(resolveValue(shipmentIdAsString));
      if ("NOT FOUND".equals(expectedStatus)) {
        Boolean movementEventEntityExistence = getHubJdbc()
            .getMovementEvenExistenceByShipmentId(shipmentId);
        Assertions.assertThat(movementEventEntityExistence).as("Movement Event not found")
            .isEqualTo(false);
        continue;
      }
      retryIfAssertionErrorOccurred(() -> {
        MovementEventEntity movementEventEntity = getHubJdbc()
            .getMovementEventByShipmentId(shipmentId);
        Assertions.assertThat(movementEventEntity.getEvent()).as("Event is equal")
            .isEqualTo(expectedEvent);
        Assertions.assertThat(movementEventEntity.getStatus()).as("Status is equal")
            .isEqualTo(expectedStatus);
        Assertions.assertThat(movementEventEntity.getExtData()).as("ExtData is equal")
            .isEqualTo(expectedExtData);
      }, getCurrentMethodName(), 1000, 5);
      pause2s();
    }
  }

  @Then("DB Operator verify sla in movement_events table for {string} no path for the following shipments from {string} to {string}:")
  public void dbOperatorVerifySlaInMovementEventsTableForNoPathForTheFollowingShipmentsFromTo(
      String scheduleType, String originHub, String destHub, List<String> shipmentIds) {
    switch (scheduleType) {
      case HUB_CD_CD:
        dbOperatorVerifySlaFailedAndPathNotFoundInExtDataMovementEventsTableWithDataBelow(
            "FAILED", originHub, destHub, shipmentIds.subList(0, 0));
        dbOperatorVerifySlaFailedAndPathNotFoundInExtDataMovementEventsTableWithDataBelow(
            "NOT FOUND", originHub, destHub, shipmentIds.subList(1, 1));
        break;
      case HUB_ST_ST_DIFF_CD:
      case HUB_ST_CD_DIFF_CD:
      case HUB_CD_ST_DIFF_CD:
      case HUB_ST_ST_SAME_CD:
      case HUB_CD_ITS_ST:
      case HUB_ST_ITS_CD:
        dbOperatorVerifySlaFailedAndPathNotFoundInExtDataMovementEventsTableWithDataBelow(
            "FAILED", originHub, destHub, shipmentIds);
        break;
    }
  }

  @Then("DB Operator verify path in movement_path table is not found for shipments from {string} to {string}")
  public void dbOperatorVerifyPathNotFoundInMovementPathTableIsForShipmentsFromTo(
      String originHubId, String destinationHubId) {
    Long resolvedOriginHubId = Long.valueOf(resolveValue(originHubId));
    Long resolvedDestinationHubId = Long.valueOf(resolveValue(destinationHubId));
    List<MovementPath> movementPaths = getHubJdbc()
        .getAllMovementPath(resolvedOriginHubId, resolvedDestinationHubId);
    movementPaths.forEach(movementPath ->
        assertThat("Movement path deleted at is not null", movementPath.getDeletedAt(),
            notNullValue()));
  }

  public void verifySlaInMovementEvents(List<Long> shipmentIds, String extData) {
    String expectedEvent = "SLA_CALCULATION";
    String expectedStatus = "SUCCESS";
    for (Long shipmentId : shipmentIds) {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        MovementEventEntity movementEventEntity = getHubJdbc()
            .getMovementEventByShipmentId(shipmentId);
        Assertions.assertThat(movementEventEntity.getEvent()).as("Event is equal")
            .isEqualTo(expectedEvent);
        Assertions.assertThat(movementEventEntity.getStatus()).as("Status is equal")
            .isEqualTo(expectedStatus);
        if (extData != null) {
          Assertions.assertThat(movementEventEntity.getExtData()).as("ExtData is equal")
              .isEqualTo(extData);
        }
        pause1s();
      }, "Retrying until SLA is done calculated...", 10000, 30);
    }
  }

  @And("DB Operator verify sla in movement_events table for shipment ids {string} exist")
  public void dbOperatorVerifySlaInMovement_eventsTableForShipmentIdsExist(String shipmentIdsArg) {
    List<Long> shipmentIds = Arrays.asList(((String) resolveValue(shipmentIdsArg)).split(","))
        .stream().map(Long::valueOf).collect(
            Collectors.toList());

    verifySlaInMovementEvents(shipmentIds, null);
  }

  @When("DB Operator verify sla in movement_events table is succeed for the following data:")
  public void dbOperatorVerifySlaInMovementEventsTableIsSucceedForTheFollowingData(
      Map<String, String> mapOfData) {
    Map<String, String> resolvedMapData = resolveKeyValues(mapOfData);
    String expectedExtData = resolvedMapData.get("extData");
    String[] shipmentIds = resolvedMapData.get("shipmentIds").split(",");
    List<Long> listShipmentIds = Arrays.stream(shipmentIds).map(Long::valueOf)
        .collect(Collectors.toList());

    verifySlaInMovementEvents(listShipmentIds, expectedExtData);
  }

  @Then("DB Operator verify sla in movement_events table from {string} to {string} is succeed for the following data:")
  public void dbOperatorVerifySlaInMovementEventsTableFromToIsSucceedForTheFollowingData(
      String originHubName, String destinationHubName, Map<String, String> mapOfData) {
    Map<String, String> resolvedMapData = resolveKeyValues(mapOfData);
    String resolvedOriginHubName = resolveValue(originHubName);
    String resolvedDestinationHubName = resolveValue(destinationHubName);
    String[] shipmentIds = resolvedMapData.get("shipmentIds").split(",");
    List<Long> listShipmentIds = Arrays.stream(shipmentIds).map(Long::valueOf)
        .collect(Collectors.toList());
    String[] hubRelationIds = resolvedMapData.get("hubRelationIds").split(",");
    List<Long> listHubRelationIds = Arrays.stream(hubRelationIds).map(Long::valueOf)
        .collect(Collectors.toList());
    Long landHaulHubRelationId = listHubRelationIds.get(0);
    String landHaulExtData = f(
        "{\"path_cache\":{\"full_path\":[\"%s (sg)\",\"%s (sg)\"],\"trip_path\":[%d]},\"crossdock_detail\":null,\"error_message\":null}",
        resolvedOriginHubName, resolvedDestinationHubName, landHaulHubRelationId);
    Long airHaulHubRelationId = listHubRelationIds.get(1);
    String airHaulExtData = f(
        "{\"path_cache\":{\"full_path\":[\"%s (sg)\",\"%s (sg)\"],\"trip_path\":[%d]},\"crossdock_detail\":null,\"error_message\":null}",
        resolvedOriginHubName, resolvedDestinationHubName, airHaulHubRelationId);

    String expectedEvent = "SLA_CALCULATION";
    String expectedStatus = "SUCCESS";
    for (Long shipmentId : listShipmentIds) {
      MovementEventEntity movementEventEntity = getHubJdbc()
          .getMovementEventByShipmentId(shipmentId);
      Assertions.assertThat(movementEventEntity.getEvent()).as("Event is equal")
          .isEqualTo(expectedEvent);
      Assertions.assertThat(movementEventEntity.getStatus()).as("Status is equal")
          .isEqualTo(expectedStatus);
      assertThat("ExtData is equal", movementEventEntity.getExtData(),
          isOneOf(landHaulExtData, airHaulExtData));
      pause1s();
    }
  }

  @When("DB Operator verify sla in movement events table for {string} movement")
  public void apiOperatorVerifySlaInMovementEventsTableForMovement(String scheduleType) {
    List<Hub> hubs = get(KEY_LIST_OF_CREATED_HUBS);
    List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_IDS);
    List<String> tripScheduleIds = get(KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS);
    Long landHaulShipmentId = shipmentIds.get(0);
    Long airHaulShipmentId = shipmentIds.get(1);

    String expectedEvent = "SLA_CALCULATION";
    String expectedStatus = "SUCCESS";

    MovementEventEntity landHaulMovementEventEntity = getHubJdbc()
        .getMovementEventByShipmentId(landHaulShipmentId);
    Assertions.assertThat(landHaulMovementEventEntity.getEvent()).as("Event is equal")
        .isEqualTo(expectedEvent);
    Assertions.assertThat(landHaulMovementEventEntity.getStatus()).as("Status is equal")
        .isEqualTo(expectedStatus);

    MovementEventEntity airHaulMovementEventEntity = getHubJdbc()
        .getMovementEventByShipmentId(airHaulShipmentId);
    Assertions.assertThat(airHaulMovementEventEntity.getEvent()).as("Event is equal")
        .isEqualTo(expectedEvent);
    Assertions.assertThat(airHaulMovementEventEntity.getStatus()).as("Status is equal")
        .isEqualTo(expectedStatus);

    String expectedExtDataLandHaul;
    String expectedExtDataAirHaul;
    String pathBase;
    String pathOptionOne;
    String pathOptionTwo;
    String pathOptionThree;
    String pathOptionFour;

    switch (scheduleType) {
      case HUB_CD_CD:
      case HUB_ST_ITS_CD:
      case HUB_CD_ITS_ST:
        expectedExtDataLandHaul = f(
            "{\"path_cache\":{\"full_path\":[\"%s (sg)\",\"%s (sg)\"],\"trip_path\":[%s]},\"crossdock_detail\":null,\"error_message\":null}",
            hubs.get(0).getName(), hubs.get(1).getName(), tripScheduleIds.get(0));
        expectedExtDataAirHaul = f(
            "{\"path_cache\":{\"full_path\":[\"%s (sg)\",\"%s (sg)\"],\"trip_path\":[%s]},\"crossdock_detail\":null,\"error_message\":null}",
            hubs.get(0).getName(), hubs.get(1).getName(), tripScheduleIds.get(1));
        assertThat("ExtData is equal", landHaulMovementEventEntity.getExtData(),
            isOneOf(expectedExtDataLandHaul, expectedExtDataAirHaul));
        assertThat("ExtData is equal", airHaulMovementEventEntity.getExtData(),
            isOneOf(expectedExtDataLandHaul, expectedExtDataAirHaul));
        break;
      case HUB_ST_CD_DIFF_CD:
      case HUB_ST_ST_SAME_CD:
      case HUB_CD_ST_DIFF_CD:
        pathBase = f(
            "{\"path_cache\":{\"full_path\":[\"%s (sg)\",\"%s (sg)\",\"%s (sg)\"],\"trip_path\":",
            hubs.get(0).getName(), hubs.get(2).getName(), hubs.get(1).getName());
        pathOptionOne =
            pathBase + f("[%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(0), tripScheduleIds.get(1));
        pathOptionTwo =
            pathBase + f("[%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(0), tripScheduleIds.get(3));
        pathOptionThree =
            pathBase + f("[%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(2), tripScheduleIds.get(1));
        pathOptionFour =
            pathBase + f("[%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(2), tripScheduleIds.get(3));
        assertThat("ExtData is equal", landHaulMovementEventEntity.getExtData(),
            isOneOf(pathOptionOne, pathOptionTwo, pathOptionThree, pathOptionFour));
        assertThat("ExtData is equal", airHaulMovementEventEntity.getExtData(),
            isOneOf(pathOptionOne, pathOptionTwo, pathOptionThree, pathOptionFour));
        break;
      case HUB_ST_ST_DIFF_CD:
        pathBase = f(
            "{\"path_cache\":{\"full_path\":[\"%s (sg)\",\"%s (sg)\",\"%s (sg)\",\"%s (sg)\"],\"trip_path\":",
            hubs.get(0).getName(), hubs.get(2).getName(), hubs.get(3).getName(),
            hubs.get(1).getName());
        pathOptionOne =
            pathBase + f("[%s,%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(0), tripScheduleIds.get(1), tripScheduleIds.get(2));
        pathOptionTwo =
            pathBase + f("[%s,%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(0), tripScheduleIds.get(1), tripScheduleIds.get(5));
        pathOptionThree =
            pathBase + f("[%s,%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(0), tripScheduleIds.get(4), tripScheduleIds.get(2));
        pathOptionFour =
            pathBase + f("[%s,%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(0), tripScheduleIds.get(4), tripScheduleIds.get(5));
        String pathOptionFive =
            pathBase + f("[%s,%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(3), tripScheduleIds.get(1), tripScheduleIds.get(2));
        String pathOptionSix =
            pathBase + f("[%s,%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(3), tripScheduleIds.get(1), tripScheduleIds.get(5));
        String pathOptionSeven =
            pathBase + f("[%s,%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(3), tripScheduleIds.get(4), tripScheduleIds.get(2));
        String pathOptionEight =
            pathBase + f("[%s,%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(3), tripScheduleIds.get(4), tripScheduleIds.get(5));
        assertThat("ExtData is equal", landHaulMovementEventEntity.getExtData(),
            isOneOf(pathOptionOne, pathOptionTwo, pathOptionThree, pathOptionFour, pathOptionFive,
                pathOptionSix, pathOptionSeven, pathOptionEight));
        assertThat("ExtData is equal", airHaulMovementEventEntity.getExtData(),
            isOneOf(pathOptionOne, pathOptionTwo, pathOptionThree, pathOptionFour, pathOptionFive,
                pathOptionSix, pathOptionSeven, pathOptionEight));
        break;
      case "default":
        break;
    }
  }

  @When("DB Operator verify sla in movement events table for {string} movement with deleted movements")
  public void apiOperatorVerifySlaInMovementEventsTableForMovementWithDeletedMovements(
      String scheduleType) {
    List<Hub> hubs = get(KEY_LIST_OF_CREATED_HUBS);
    List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_IDS);
    List<String> tripScheduleIds = get(KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS);
    Long landHaulShipmentId = shipmentIds.get(0);
    Long airHaulShipmentId = shipmentIds.get(1);

    MovementEventEntity landHaulMovementEventEntity = getHubJdbc()
        .getMovementEventByShipmentId(landHaulShipmentId);

    MovementEventEntity airHaulMovementEventEntity = getHubJdbc()
        .getMovementEventByShipmentId(airHaulShipmentId);

    String pathBase;
    String pathOptionOne;
    String pathOptionTwo;
    String pathOptionThree;
    String pathOptionFour;
    String expectedExtDataLandHaul;
    String expectedExtDataAirHaul;

    switch (scheduleType) {
      case HUB_CD_CD:
      case HUB_ST_ITS_CD:
      case HUB_CD_ITS_ST:
        expectedExtDataLandHaul = f(
            "{\"path_cache\":{\"full_path\":[\"%s (sg)\",\"%s (sg)\"],\"trip_path\":[%s]},\"crossdock_detail\":null,\"error_message\":null}",
            hubs.get(0).getName(), hubs.get(1).getName(), tripScheduleIds.get(2));
        expectedExtDataAirHaul = f(
            "{\"path_cache\":{\"full_path\":[\"%s (sg)\",\"%s (sg)\"],\"trip_path\":[%s]},\"crossdock_detail\":null,\"error_message\":null}",
            hubs.get(0).getName(), hubs.get(1).getName(), tripScheduleIds.get(3));
        assertThat("ExtData is equal", landHaulMovementEventEntity.getExtData(),
            isOneOf(expectedExtDataLandHaul, expectedExtDataAirHaul));
        assertThat("ExtData is equal", airHaulMovementEventEntity.getExtData(),
            isOneOf(expectedExtDataLandHaul, expectedExtDataAirHaul));
        break;
      case HUB_ST_CD_DIFF_CD:
      case HUB_ST_ST_SAME_CD:
      case HUB_CD_ST_DIFF_CD:
        apiOperatorVerifySlaInMovementEventsTableForMovement("default");
        pathBase = f(
            "{\"path_cache\":{\"full_path\":[\"%s (sg)\",\"%s (sg)\",\"%s (sg)\"],\"trip_path\":",
            hubs.get(0).getName(), hubs.get(2).getName(), hubs.get(1).getName());
        pathOptionOne =
            pathBase + f("[%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(4), tripScheduleIds.get(5));
        pathOptionTwo =
            pathBase + f("[%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(4), tripScheduleIds.get(7));
        pathOptionThree =
            pathBase + f("[%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(6), tripScheduleIds.get(5));
        pathOptionFour =
            pathBase + f("[%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(6), tripScheduleIds.get(7));
        assertThat("ExtData is equal", landHaulMovementEventEntity.getExtData(),
            isOneOf(pathOptionOne, pathOptionTwo, pathOptionThree, pathOptionFour));
        assertThat("ExtData is equal", airHaulMovementEventEntity.getExtData(),
            isOneOf(pathOptionOne, pathOptionTwo, pathOptionThree, pathOptionFour));
        break;
      case HUB_ST_ST_DIFF_CD:
        apiOperatorVerifySlaInMovementEventsTableForMovement("default");
        pathBase = f(
            "{\"path_cache\":{\"full_path\":[\"%s (sg)\",\"%s (sg)\",\"%s (sg)\",\"%s (sg)\"],\"trip_path\":",
            hubs.get(0).getName(), hubs.get(2).getName(), hubs.get(3).getName(),
            hubs.get(1).getName());
        pathOptionOne =
            pathBase + f("[%s,%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(6), tripScheduleIds.get(7), tripScheduleIds.get(8));
        pathOptionTwo =
            pathBase + f("[%s,%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(6), tripScheduleIds.get(7), tripScheduleIds.get(11));
        pathOptionThree =
            pathBase + f("[%s,%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(6), tripScheduleIds.get(10), tripScheduleIds.get(8));
        pathOptionFour =
            pathBase + f("[%s,%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(6), tripScheduleIds.get(10), tripScheduleIds.get(11));
        String pathOptionFive =
            pathBase + f("[%s,%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(9), tripScheduleIds.get(7), tripScheduleIds.get(8));
        String pathOptionSix =
            pathBase + f("[%s,%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(9), tripScheduleIds.get(7), tripScheduleIds.get(11));
        String pathOptionSeven =
            pathBase + f("[%s,%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(9), tripScheduleIds.get(10), tripScheduleIds.get(11));
        String pathOptionEight =
            pathBase + f("[%s,%s,%s]},\"crossdock_detail\":null,\"error_message\":null}",
                tripScheduleIds.get(6), tripScheduleIds.get(7), tripScheduleIds.get(8));
        assertThat("ExtData is equal", landHaulMovementEventEntity.getExtData(),
            isOneOf(pathOptionOne, pathOptionTwo, pathOptionThree, pathOptionFour, pathOptionFive,
                pathOptionSix, pathOptionSeven, pathOptionEight));
        assertThat("ExtData is equal", airHaulMovementEventEntity.getExtData(),
            isOneOf(pathOptionOne, pathOptionTwo, pathOptionThree, pathOptionFour, pathOptionFive,
                pathOptionSix, pathOptionSeven, pathOptionEight));
        break;
    }
  }

  @Then("DB Operator verifies old path is deleted in path_schedule from {string} to {string}")
  public void dbOperatorVerifiesOldPathIsDeletedInPathSchedule(String originHubIdAsString,
      String destinationHubIdAsString) {
    Long originHubId = Long.valueOf(resolveValue(originHubIdAsString));
    Long destinationHubId = Long.valueOf(resolveValue(destinationHubIdAsString));
    MovementPath movementPath = getHubJdbc()
        .getMovementPath(originHubId, destinationHubId, "LAND_HAUL", "MANUAL");
    List<PathSchedule> pathSchedule = getHubJdbc()
        .getMovementPathSchedulesByPathId(movementPath.getId());
    List<PathSchedule> oldPathSchedule = pathSchedule.subList(0, 7);
    oldPathSchedule.forEach(pathScheduleElement -> {
      assertThat(f("path id is the same %d", movementPath.getId()), pathScheduleElement.getPathId(),
          equalTo(movementPath.getId()));
      assertThat("deleted at is not null", pathScheduleElement.getDeletedAt(),
          not(equalTo(null)));
    });
  }

  @Then("DB Operator verify trip with id {string} status is {string}")
  public void dbOperatorVerifyTripWithIdStatusIs(String tripIdAsString, String tripStatus) {
    Long resolvedTripId = Long.valueOf(resolveValue(tripIdAsString));
    MovementTrip movementTrip = getHubJdbc().getMovementTrip(resolvedTripId);

    assertThat("Trip status is the same", movementTrip.getStatus().toLowerCase(),
        equalTo(tripStatus.toLowerCase()));
  }

  @Then("DB Operator verify 'inbound_weight_tolerance' parameter is {string}")
  public void dbOperatorVerifyInboundWeightTolerance(String expected) {
    Assertions.assertThat(
            getSortJdbc().getInboundSetting(StandardTestConstants.NV_SYSTEM_ID).getWeightTolerance())
        .as("inbound_weight_tolerance value").isEqualTo(Double.valueOf(resolveValue(expected)));
  }

  @Then("DB Operator verify 'inbound_max_weight' parameter is {string}")
  public void dbOperatorVerifyInboundMaxWeight(String expected) {
    Assertions.assertThat(
            getSortJdbc().getInboundSetting(StandardTestConstants.NV_SYSTEM_ID).getMaxWeight())
        .as("inbound_max_weight value").isEqualTo(Double.valueOf(resolveValue(expected)));
  }

  @Then("DB Operator verify the new COD for created route is created successfully")
  public void dbOperatorVerifyTheNewCodIsCreatedSuccessfully() {
    RouteCashInboundCod routeCashInboundCod = get(KEY_ROUTE_CASH_INBOUND_COD);
    CodInbound expected = new CodInbound();
    expected.setAmountCollected(
        Double.valueOf(StringUtils.remove(routeCashInboundCod.getAmountCollected(), "S$")));
    expected.setType("Cash");
    CodInbound actual = getCoreJdbc().getCodInbound(get(KEY_CREATED_ROUTE_ID));
    expected.compareWithActual(actual);
  }

  @Then("DB Operator verify the COD for created route is soft deleted")
  public void dbOperatorVerifyTheNewCodSoftDeleted() {
    CodInbound actual = getCoreJdbc().getCodInbound(get(KEY_CREATED_ROUTE_ID));
    assertThat("COD Inbound deleted_at", actual.getDeletedAt(),
        Matchers.startsWith(DateUtil.getUTCTodayDate()));
  }

  @Then("DB Operator verify loyalty point for completed order is {string}")
  public void checkLoyaltyPoint(String pointAdded) {
    if (containsKey(KEY_LOYALTY_POINT) && get(KEY_LOYALTY_POINT) == null) {
      retryIfAssertionErrorOccurred(() -> {
            String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
            Double point = getLoyaltyJdbc().getLoyaltyPoint(trackingId);
            assertNotNull(point);
            put(KEY_LOYALTY_POINT, point);
          }, "DB loyalty check loyalty point"
      );
    }
    Double actualLoyaltyPoint = get(KEY_LOYALTY_POINT);
    Double expectedLoyaltyPoint = Double.valueOf(pointAdded);

    Assertions.assertThat(actualLoyaltyPoint).as("Check added loyalty point")
        .isEqualTo(expectedLoyaltyPoint);
  }

  @Then("DB Operator verify unscanned shipment with following data:")
  public void dbOperatorVerifyUnscannedShipmentWithFollowingData(Map<String, String> mapOfData) {
    Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
    Long shipmentId = Long.valueOf(resolvedMapOfData.get("shipmentId"));
    String unscannedShipmentType = mapOfData.get("type");
    String scanType = mapOfData.get("scanType");
    UnscannedShipment unscannedShipment = getHubJdbc().getUnscannedShipment(shipmentId);

    assertThat("Unscanned shipment type id is the same", unscannedShipment.getShipmentId(),
        equalTo(shipmentId));
    assertThat("Unscanned shipment type is the same", unscannedShipment.getType(),
        equalTo(unscannedShipmentType));
    assertThat("Unscanned shipment scan type is the same", unscannedShipment.getScanType(),
        equalTo(scanType));
  }

  @When("DB Operator sets flags of driver with id {string} to {int}")
  public void setDriverFlags(String driverId, int flags) {
    getDriverJdbc().setDriverFlags(Long.parseLong(resolveValue(driverId)), flags);
  }

  @When("DB Operator searched {string} Orders with {string} Status and {string} Granular Status")
  public void dbOperatorSearchedOrdersWithStatusAndGranularStatus(String orderNumberAsString,
      String orderStatus, String orderGranularStatus) {
    Integer orderNumber = Integer.parseInt(orderNumberAsString);
    List<String> trackingIds = getCoreJdbc()
        .getTrackingIdByStatusAndGranularStatus(orderNumber, orderStatus, orderGranularStatus);
    put(KEY_LIST_OF_CREATED_TRACKING_IDS, trackingIds);
  }

  @When("DB Operator verifies orders records are hard-deleted in orders table:")
  public void verifyOrdersAreHardDeleted(List<String> orderIds) {
    resolveValues(orderIds).forEach(this::verifyOrderIsHardDeleted);
  }

  @When("DB Operator verifies {value} order record is hard-deleted in orders table")
  public void verifyOrderIsHardDeleted(String orderId) {
    List<Long> orderIds = getCoreJdbc().findOrderRecordByOrderId(Long.valueOf(orderId));
    Assertions.assertThat(orderIds)
        .as("List of orders records for id=%s", orderId)
        .isEmpty();
  }

  @When("DB Operator verifies orders records are hard-deleted in transactions table:")
  public void verifyOrdersTransactionsAreHardDeleted(List<String> orderIds) {
    resolveValues(orderIds).forEach(this::verifyOrderTransactionsAreHardDeleted);
  }

  @When("DB Operator verifies {value} order records are hard-deleted in transactions table")
  public void verifyOrderTransactionsAreHardDeleted(String orderId) {
    List<Long> orderIds = getCoreJdbc().findTransactionsRecordByOrderId(Long.valueOf(orderId));
    Assertions.assertThat(orderIds)
        .as("List of transactions records for order_id=%s", orderId)
        .isEmpty();
  }

  @When("DB Operator verifies orders records are hard-deleted in waypoints table:")
  public void verifyOrdersWaypointsAreHardDeleted(List<String> orderIds) {
    resolveValues(orderIds).forEach(this::verifyOrderWaypointsAreHardDeleted);
  }

  @When("DB Operator verifies {value} order records are hard-deleted in waypoints table")
  public void verifyOrderWaypointsAreHardDeleted(String orderId) {
    List<Order> orders = get(KEY_LIST_OF_CREATED_ORDER);
    Order order = orders.stream()
        .filter(o -> Objects.equals(o.getId(), Long.valueOf(orderId)))
        .findFirst()
        .orElseThrow(
            () -> new IllegalArgumentException("Order with ID " + orderId + " was not found"));
    Set<Long> waypointIds = order.getTransactions().stream()
        .map(Transaction::getWaypointId)
        .filter(Objects::nonNull)
        .collect(Collectors.toSet());

    SoftAssertions assertions = new SoftAssertions();
    waypointIds.forEach(w -> {
      Waypoint waypoint = getCoreJdbc().findWaypointById(w);
      assertions.assertThat(waypoint)
          .as("waypoints record for id=%s", w)
          .isNull();
    });
    assertions.assertAll();
  }

  @When("DB Operator verifies orders records are hard-deleted in order_details table:")
  public void verifyOrderDetailsAreHardDeleted(List<String> orderIds) {
    resolveValues(orderIds).forEach(this::verifyOrderDetailsAreHardDeleted);
  }

  @When("DB Operator verifies {value} order record is hard-deleted in order_details table")
  public void verifyOrderDetailsAreHardDeleted(String orderId) {
    String serviceType = getCoreJdbc().getOrderServiceType(Long.parseLong(orderId));
    Assertions.assertThat(serviceType)
        .as("order_details record for order_id=%s", orderId)
        .isNull();
  }

  @When("DB Operator verifies orders records are hard-deleted in order_delivery_verifications table:")
  public void verifyOrderDeliveryVerificationsAreHardDeleted(List<String> orderIds) {
    resolveValues(orderIds).forEach(this::verifyOrderDeliveryVerificationsAreHardDeleted);
  }

  @When("DB Operator verifies {value} order record is hard-deleted in order_delivery_verifications table")
  public void verifyOrderDeliveryVerificationsAreHardDeleted(String orderId) {
    ShipperRefMetadata shipperRefMetadata = getCoreJdbc().getOrderDeliveryVerifications(
        Long.parseLong(orderId));
    Assertions.assertThat(shipperRefMetadata)
        .as("order_delivery_verifications record for order_id=%s", orderId)
        .isNull();
  }

  @When("DB Operator verifies orders records are hard-deleted in reserve_tracking_ids table:")
  public void verifyReserveTrackingIdIsHardDeleted(List<String> trackingIds) {
    resolveValues(trackingIds).forEach(this::verifyReserveTrackingIdIsHardDeleted);
  }

  @When("DB Operator verifies {value} order record is hard-deleted in reserve_tracking_ids table")
  public void verifyReserveTrackingIdIsHardDeleted(String trackingId) {
    ReserveTrackingIdEntity reservedTrackingId = getOrderCreateJdbc().rawFindReservedTrackingId(
        trackingId);
    Assertions.assertThat(reservedTrackingId)
        .as("reserve_tracking_ids record for tracking_id=%s", trackingId)
        .isNull();
  }

  @Given("DB Operator gets {int} existed DP IDs")
  public void dbOperatorGetsExistedDPIDs(int dpIdsNeeded) {
    List<Long> dpIds = getNonNull(() -> getDpJdbc().getExistedDpId(dpIdsNeeded),
        f("Get %d Existed DP IDs", dpIdsNeeded));
    put(KEY_LIST_OF_DP_IDS, dpIds);
  }

  @Given("DB Operator gets waypoint record")
  public void dbOperatorGetsWaypointRecord() {
    final Long waypointId = get(KEY_WAYPOINT_ID);
    dbOperatorGetsWaypointRecord(waypointId.toString());
  }

  @Given("DB Operator gets {value} waypoint record")
  public void dbOperatorGetsWaypointRecord(String value) {
    Waypoint waypoint = getCoreJdbc().getWaypoint(Long.valueOf(value));
    put(KEY_WAYPOINT_DETAILS, waypoint);
  }


  @Then("DB Operator verifies that {int} row(s) is/are added for the change type: {string} in account_audit_logs table in driver db")
  public void dbOperatorVerifiesTheRowIsAddedForTheChangeTypeInAccountAuditLogsTableInDriverDb(
      int records, String changeType) {
    DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
    int totalRecord = getDriverJdbc().getAccountAuditTotal(driverInfo.getId(), changeType);
    Assertions.assertThat(totalRecord)
        .as("Total number of records with change type = %s", changeType)
        .isEqualTo(records);
  }
}
