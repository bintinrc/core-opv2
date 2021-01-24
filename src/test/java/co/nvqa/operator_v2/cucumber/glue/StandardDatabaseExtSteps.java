package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.AbstractDatabaseSteps;
import co.nvqa.commons.model.addressing.JaroScore;
import co.nvqa.commons.model.core.Driver;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Reservation;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.commons.model.core.Waypoint;
import co.nvqa.commons.model.core.hub.Hub;
import co.nvqa.commons.model.core.hub.MovementPath;
import co.nvqa.commons.model.core.hub.PathSchedule;
import co.nvqa.commons.model.core.hub.trip_management.TripManagementDetailsData;
import co.nvqa.commons.model.driver.FailureReason;
import co.nvqa.commons.model.entity.DriverEntity;
import co.nvqa.commons.model.entity.InboundScanEntity;
import co.nvqa.commons.model.entity.MovementEventEntity;
import co.nvqa.commons.model.entity.MovementTripEventEntity;
import co.nvqa.commons.model.entity.OrderEventEntity;
import co.nvqa.commons.model.entity.ShipmentPathEntity;
import co.nvqa.commons.model.entity.TransactionEntity;
import co.nvqa.commons.model.entity.TransactionFailureReasonEntity;
import co.nvqa.commons.model.sort.hub.movement_trips.HubRelation;
import co.nvqa.commons.model.sort.hub.movement_trips.HubRelationSchedule;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.commons.util.StandardTestUtils;
import co.nvqa.operator_v2.model.DpPartner;
import co.nvqa.operator_v2.model.DriverInfo;
import co.nvqa.operator_v2.model.ShipmentInfo;
import com.google.common.collect.ImmutableList;
import cucumber.api.java.After;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import io.cucumber.datatable.DataTable;
import java.sql.SQLException;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.hamcrest.Matchers;
import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Assert;
import org.opentest4j.AssertionFailedError;

import static co.nvqa.commons.cucumber.glue.StandardApiOperatorPortalSteps.TRANSACTION_TYPE_PICKUP;
import static co.nvqa.commons.support.DateUtil.TIME_FORMATTER_1;
import static co.nvqa.operator_v2.cucumber.ScenarioStorageKeys.KEY_TRIP_ID;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class StandardDatabaseExtSteps extends AbstractDatabaseSteps<ScenarioManager> {

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

  @Override
  public void init() {
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
      Optional<Transaction> transactionOptional = transactions.stream()
          .filter(t -> transactionType.equals(t.getType())).findFirst();

      if (transactionOptional.isPresent()) {
        Transaction transaction = transactionOptional.get();
        Long waypointId = transaction.getWaypointId();
        if (waypointId != null) {
          List<JaroScore> jaroScores = getCoreJdbc().getJaroScores(waypointId);
          assertEquals("Number of rows in DB", 1, jaroScores.size());
          jaroScores.forEach(jaroScore ->
              Assert.assertEquals(
                  f("order jaro score is archived for the %s waypoint ", transactionType),
                  new Integer(1), jaroScore.getArchived()));
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

    Optional<Transaction> transactionOptional = transactions.stream()
        .filter(t -> StringUtils.equalsIgnoreCase(t.getType(), transactionType)).findFirst();

    if (transactionOptional.isPresent()) {
      Transaction transaction = transactionOptional.get();
      Long waypointId = transaction.getWaypointId();
      Assert.assertNotNull(f("%s waypoint Id", transactionType), waypointId);

      Waypoint actualWaypoint = getCoreJdbc().getWaypoint(waypointId);

      if (data.containsKey("status")) {
        assertThat(f("%s waypoint [%d] status", transactionType, waypointId),
            actualWaypoint.getStatus(), Matchers.equalToIgnoringCase(data.get("status")));
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
    List<Transaction> transactions = order.getTransactions();

    Transaction transaction = transactions.stream()
        .filter(t -> StringUtils.equalsIgnoreCase(t.getType(), transactionType)).findFirst()
        .orElseThrow(() -> new AssertionFailedError(
            f("%s transaction not found for order ID = '%s'.", transactionType, order.getId())));

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
    types.forEach(type ->
        orderEvents.stream()
            .filter(orderEventEntity -> Objects.equals(orderEventEntity.getType(), type))
            .findFirst()
            .orElseThrow(() -> new IllegalArgumentException(
                f("No order event with type %s is found in order events DB table", type))));
  }

  @Then("^DB Operator verify Pickup '17' order_events record for the created order$")
  public void operatorVerifySpecificPickupOrderEvent() {
    int eventType = 17;
    Long orderId = get(KEY_CREATED_ORDER_ID);
    Order order = get(KEY_CREATED_ORDER);
    List<OrderEventEntity> orderEvents = getEventsJdbc().getOrderEvents(orderId);
    assertThat(f("Order %d events list", orderId), orderEvents, not(empty()));

    OrderEventEntity event = orderEvents.stream()
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

    OrderEventEntity event = orderEvents.stream()
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
  public void operatorVerifyOrderEventParams(int index, Map<String, String> mapOfData) {
    Long orderId = get(KEY_CREATED_ORDER_ID);
    List<OrderEventEntity> orderEvents = getEventsJdbc().getOrderEvents(orderId);
    assertThat(f("Order %d events list", orderId), orderEvents, not(empty()));
    if (index <= 0) {
      index = orderEvents.size() + index;
    }
    OrderEventEntity theLastOrderEvent = orderEvents.get(index - 1);
    String value = mapOfData.get("type");

    if (StringUtils.isNotBlank(value)) {
      assertEquals("Type", Integer.parseInt(value), theLastOrderEvent.getType());
    }
  }

  @Then("^DB Operator verify order_events record for the created order:$")
  public void operatorVerifyOrderEventRecordParams(Map<String, String> mapOfData) {
    Long orderId = get(KEY_CREATED_ORDER_ID);
    List<OrderEventEntity> orderEvents = getEventsJdbc().getOrderEvents(orderId);
    assertThat(f("Order %d events list", orderId), orderEvents, not(empty()));
    String value = mapOfData.get("type");

    orderEvents.stream()
        .filter(record ->
        {
          if (StringUtils.isNotBlank(value)) {
            return Integer.parseInt(value) == record.getType();
          }
          return false;
        })
        .findFirst()
        .orElseThrow(() -> new AssertionError(
            f("Event record %s for order %d was not found", mapOfData.toString(), orderId)));
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
    assertEquals("failure_reason_code_id", (long) failureReason.getFailureReasonCodeId(),
        (long) transactionFailureReason.getFailureReasonCodeId());
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
    assertEquals("From Address 1", order.getFromAddress1(),
        StringUtils.normalizeSpace(entity.getAddress1()));
    assertEquals("From Address 2", order.getFromAddress2(),
        StringUtils.normalizeSpace(entity.getAddress2()));
    assertEquals("From Postcode", order.getFromPostcode(),
        StringUtils.normalizeSpace(entity.getPostcode()));
    assertEquals("From City", order.getFromCity(), StringUtils.normalizeSpace(entity.getCity()));
    assertEquals("From Country", order.getFromCountry(),
        StringUtils.normalizeSpace(entity.getCountry()));
    assertEquals("From Name", order.getFromName(), StringUtils.normalizeSpace(entity.getName()));
    assertEquals("From Email", order.getFromEmail(), StringUtils.normalizeSpace(entity.getEmail()));
    assertEquals("From Contact", order.getFromContact(),
        StringUtils.normalizeSpace(entity.getContact()));
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

  @Then("^DB Operator verify Delivery transaction record is updated for the created order$")
  public void dbOperatorVerifyDeliveryTransactionRecordUpdatedForTheCreatedOrder() {
    Order order = get(KEY_CREATED_ORDER);
    String type = "DD";
    List<TransactionEntity> transactions = getCoreJdbc()
        .findTransactionByOrderIdAndType(order.getId(), type);

    assertThat(f("There is more than 1 %s transaction for orderId %d", type, order.getId()),
        transactions, hasSize(1));
    TransactionEntity entity = transactions.get(0);
    assertEquals("To Address 1", order.getToAddress1(),
        StringUtils.normalizeSpace(entity.getAddress1()));
    assertEquals("To Address 2", order.getToAddress2(),
        StringUtils.normalizeSpace(entity.getAddress2()));
    assertEquals("To Postcode", order.getToPostcode(),
        StringUtils.normalizeSpace(entity.getPostcode()));
    assertEquals("To City", order.getToCity(), StringUtils.normalizeSpace(entity.getCity()));
    assertEquals("To Country", order.getToCountry(),
        StringUtils.normalizeSpace(entity.getCountry()));
    assertEquals("To Name", order.getToName(), StringUtils.normalizeSpace(entity.getName()));
    assertEquals("To Email", order.getToEmail(), StringUtils.normalizeSpace(entity.getEmail()));
    assertEquals("To Contact", order.getToContact(),
        StringUtils.normalizeSpace(entity.getContact()));
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
        order.getDeliveryDate() + " " + TIME_FORMATTER_1
            .format(order.getDeliveryTimeslot().getEndTime()),
        DateUtil.displayDateTime(entityEndDateTime));
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
      assertEquals("DistributionPointId in Transaction entity is not as expected in db",
          distributionPointIdInt, entity.getDistributionPointId());
    }
    if (Objects.nonNull(address1)) {
      assertEquals("Address1 in Transaction entity is not as expected in db", address1,
          StringUtils.normalizeSpace(entity.getAddress1()));
    }
    if (Objects.nonNull(address2)) {
      assertEquals("Address2 in Transaction entity is not as expected in db", address2,
          StringUtils.normalizeSpace(entity.getAddress2()));
    }
    if (Objects.nonNull(city)) {
      assertEquals("City in Transaction entity is not as expected in db", city,
          StringUtils.normalizeSpace(entity.getCity()));
    }
    if (Objects.nonNull(country)) {
      assertEquals("Country in Transaction entity is not as expected in db", country,
          StringUtils.normalizeSpace(entity.getCountry()));
    }
    if (Objects.nonNull(postcode)) {
      assertEquals("Postcode in Transaction entity is not as expected in db", postcode,
          StringUtils.normalizeSpace(entity.getPostcode()));
    }
    if (Objects.nonNull(routeId)) {
      Integer routeIdInt =
          Objects.equals(routeId, "null") ? null : NumberUtils.createInteger(routeId);
      assertEquals("RouteId in Transaction entity is not as expected in db", routeIdInt,
          entity.getRouteId());
    }
    if (Objects.nonNull(priorityLevel)) {
      Integer priorityLevelInt =
          Objects.equals(priorityLevel, "null") ? null : NumberUtils.createInteger(priorityLevel);
      assertEquals("PriorityLevel in Transaction entity is not as expected in db", priorityLevelInt,
          entity.getPriorityLevel());
    }
  }

  @Then("^DB Operator verify next Pickup transaction values are updated for the created order:$")
  public void dbOperatorVerifyPickupTransactionRecordUpdatedForTheCreatedOrderForParameters(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    mapOfData = StandardTestUtils.replaceDataTableTokens(mapOfData);

    Order order = get(KEY_CREATED_ORDER);
    String type = "PP";
    List<TransactionEntity> transactions = getCoreJdbc()
        .findTransactionByOrderIdAndType(order.getId(), type);

    assertThat(f("There is more than 1 %s transaction for orderId %d", type, order.getId()),
        transactions, hasSize(1));
    TransactionEntity entity = transactions.get(0);
    put(KEY_WAYPOINT_ID, entity.getWaypointId());

    String routeId = mapOfData.get("routeId");
    String priorityLevel = mapOfData.get("priorityLevel");
    String status = mapOfData.get("status");
    String serviceEndTime = mapOfData.get("serviceEndTime");
    if (StringUtils.isNotBlank(routeId)) {
      Integer routeIdInt = StringUtils.equalsIgnoreCase(routeId, "null") ? null :
          NumberUtils.createInteger(routeId);
      assertEquals("RouteId in DB Transaction entity is not as expected", routeIdInt,
          entity.getRouteId());
    }
    if (StringUtils.isNotBlank(priorityLevel)) {
      Integer priorityLevelInt = StringUtils.equalsIgnoreCase(priorityLevel, "null") ? null :
          NumberUtils.createInteger(priorityLevel);
      assertEquals("PriorityLevel in DB Transaction entity is not as expected", priorityLevelInt,
          entity.getPriorityLevel());
    }
    if (StringUtils.isNotBlank(status)) {
      assertEquals("Status in DB Transaction entity is not as expected", status,
          entity.getStatus());
    }
    if (StringUtils.isNotBlank(serviceEndTime)) {
      assertEquals("Service End Time in DB Transaction entity is not as expected", serviceEndTime,
          DateUtil.SDF_YYYY_MM_DD.format(entity.getServiceEndTime()));
    }
  }

  @Then("^DB Operator verify the last inbound_scans record for the created order:$")
  public void dbOperatorVerifyTheLastInboundScansRecord(Map<String, String> data) {
    data = resolveKeyValues(data);
    Long orderId = get(KEY_CREATED_ORDER_ID);
    Order order = get(KEY_CREATED_ORDER);
    List<InboundScanEntity> inboundScans = getCoreJdbc().findInboundScansByOrderId(orderId);
    Assert.assertThat("List of inbound scans for order " + orderId, inboundScans,
        Matchers.not(Matchers.empty()));
    InboundScanEntity theLastInboundScan = inboundScans.get(inboundScans.size() - 1);

    String value = data.get("hubId");

    if (StringUtils.isNotBlank(value)) {
      assertEquals("Hub ID", Long.valueOf(value), theLastInboundScan.getHubId());
    }

    value = data.get("type");

    if (StringUtils.isNotBlank(value)) {
      assertEquals("Type", Short.valueOf(value), theLastInboundScan.getType());
    }

    String trackingId =
        "GET_FROM_CREATED_ORDER".equalsIgnoreCase(data.get("trackingId")) ? order.getTrackingId() :
            data.get("trackingId");

    if (StringUtils.isNotBlank(trackingId)) {
      assertEquals("TrackingId", trackingId, theLastInboundScan.getScan());
    }

    if (data.containsKey("scan")) {
      assertEquals("Scan", data.get("scan"), theLastInboundScan.getScan());
    }

    if (data.containsKey("orderId")) {
      assertEquals("Order ID", Long.valueOf(data.get("orderId")), theLastInboundScan.getOrderId());
    }
  }

  @After(value = {"@DeleteDpPartner"})
  public void deleteDpPartner() {
    DpPartner dpPartner = get(KEY_DP_PARTNER);

    if (dpPartner != null) {
      getDpJdbc().deleteDpPartner(dpPartner.getName());
    }
  }

  @After(value = {"@DeleteDpAndPartner"})
  public void deleteDp() {
    DpPartner dpPartner = get(KEY_DP_PARTNER);

    if (dpPartner != null) {
      getDpJdbc().deleteDp(dpPartner.getName());
      getDpJdbc().deleteDpPartner(dpPartner.getName());
    }
  }

  @After(value = {"@DeleteDpUserDpAndPartner"})
  public void deleteDpUser() {
    DpPartner dpPartner = get(KEY_DP_PARTNER);

    if (dpPartner != null) {
      getDpJdbc().deleteDpUser(dpPartner.getName());
      getDpJdbc().deleteDp(dpPartner.getName());
      getDpJdbc().deleteDpPartner(dpPartner.getName());
    }
  }

  @Given("^DB Operator get data of created driver$")
  public void dbOperatorGetDataOfCreatedDriver() {
    DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
    DriverEntity driverEntity = getDriverJdbc().getDriverData(driverInfo.getUsername());
    driverInfo.setId(driverEntity.getId());
    driverInfo.setUuid(driverEntity.getUuid());
    put(KEY_CREATED_DRIVER_UUID, driverInfo.getUuid());
  }

  @After(value = "@DeleteShipment")
  public void deleteShipment() {
    ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
    if (shipmentInfo != null) {
      getHubJdbc().deleteShipment(shipmentInfo.getId());
      return;
    }

    Long createdShipmentId = get(KEY_CREATED_SHIPMENT_ID);
    if (createdShipmentId != null) {
      getHubJdbc().deleteShipment(createdShipmentId);
    }
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

      assertEquals(
          f("Expected 1 record in Warehouse_sweeps table with tracking ID %s", finalTrackingId), 1,
          warehouseSweepRecordsFilteredTemp.size());
      return warehouseSweepRecordsFilteredTemp;
    }, getCurrentMethodName(), NvLogger::warn, 500, 30, AssertionError.class);

    Map<String, Object> warehouseSweepRecord = warehouseSweepRecordsFiltered.get(0);
    assertEquals(f("Expected hub_id in Warehouse_sweeps table"), hubId,
        String.valueOf(warehouseSweepRecord.get("hub_id")));
    assertEquals(f("Expected order_id in Warehouse_sweeps table"), String.valueOf(order.getId()),
        String.valueOf(warehouseSweepRecord.get("order_id")));
  }

  @SuppressWarnings("unchecked")
  @Given("^DB Operator verifies pickup info is updated in order record$")
  public void dbOperatorVerifiesPickupInfoInOrderRecord() {
    Order order = get(KEY_CREATED_ORDER);
    final String finalTrackingId = order.getTrackingId();
    List<Order> pickupInfoRecordsFiltered = retryIfExpectedExceptionOccurred(() ->
    {
      List<Order> pickupInfoRecords = getCoreJdbc().getOrderByTrackingId(finalTrackingId);
      List<Order> pickupInfoRecordsTemp = pickupInfoRecords.stream()
          .filter(record -> record.getTrackingId().equals(finalTrackingId))
          .collect(Collectors.toList());

      assertEquals(f("Expected 1 record in Orders table with tracking ID %s", finalTrackingId), 1,
          pickupInfoRecordsTemp.size());
      return pickupInfoRecordsTemp;
    }, getCurrentMethodName(), NvLogger::warn, 500, 30, AssertionError.class);

    Order pickupInfoRecord = pickupInfoRecordsFiltered.get(0);

    assertEquals(f("Expected %s in %s table", "from_address1", "orders"), order.getFromAddress1(),
        pickupInfoRecord.getFromAddress1());
    assertEquals(f("Expected %s in %s table", "from_address2", "orders"), order.getFromAddress2(),
        pickupInfoRecord.getFromAddress2());
    assertEquals(f("Expected %s in %s table", "from_postcode", "orders"), order.getFromPostcode(),
        pickupInfoRecord.getFromPostcode());
    assertEquals(f("Expected %s in %s table", "from_city", "orders"), order.getFromCity(),
        pickupInfoRecord.getFromCity());
    assertEquals(f("Expected %s in %s table", "from_country", "orders"), order.getFromCountry(),
        pickupInfoRecord.getFromCountry());
    assertEquals(f("Expected %s in %s table", "from_name", "orders"), order.getFromName(),
        pickupInfoRecord.getFromName());
    assertEquals(f("Expected %s in %s table", "from_email", "orders"), order.getFromEmail(),
        pickupInfoRecord.getFromEmail());
    assertEquals(f("Expected %s in %s table", "from_contact", "orders"), order.getFromContact(),
        pickupInfoRecord.getFromContact());
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

      assertEquals(f("Expected 1 record in Orders table with tracking ID %s", finalTrackingId), 1,
          deliveryInfoRecordsTemp.size());
      return deliveryInfoRecordsTemp;
    }, getCurrentMethodName(), NvLogger::warn, 500, 30, AssertionError.class);

    Order deliveryInfoRecord = deliveryInfoRecordsFiltered.get(0);

    assertEquals(f("Expected %s in %s table", "to_address1", "orders"), order.getToAddress1(),
        deliveryInfoRecord.getToAddress1());
    assertEquals(f("Expected %s in %s table", "to_address2", "orders"),
        Objects.nonNull(order.getToAddress2()) ? order.getToAddress2() : "",
        deliveryInfoRecord.getToAddress2());
    assertEquals(f("Expected %s in %s table", "to_postcode", "orders"), order.getToPostcode(),
        deliveryInfoRecord.getToPostcode());
    assertEquals(f("Expected %s in %s table", "to_city", "orders"),
        Objects.isNull(order.getToCity()) ? "" : order.getToCity(), deliveryInfoRecord.getToCity());
    assertEquals(f("Expected %s in %s table", "to_country", "orders"), order.getToCountry(),
        deliveryInfoRecord.getToCountry());
    assertEquals(f("Expected %s in %s table", "to_name", "orders"), order.getToName(),
        deliveryInfoRecord.getToName());
    assertEquals(f("Expected %s in %s table", "to_email", "orders"), order.getToEmail(),
        deliveryInfoRecord.getToEmail());
    assertEquals(f("Expected %s in %s table", "to_contact", "orders"), order.getToContact(),
        deliveryInfoRecord.getToContact());
  }

  @Given("^DB Operator verifies reservation record using data below:$")
  public void dbOperatorVerifiesReservationRecord(Map<String, String> mapOfData) {
    Reservation reservation = get(KEY_CREATED_RESERVATION);
    reservation = getCoreJdbc().getReservationRecordByAddressId(reservation.getAddressId());

    if (Objects.nonNull(mapOfData.get("status"))) {
      int status = Integer.parseInt(mapOfData.get("status"));
      assertEquals(f("Expected %s in %s table", "status", "reservations"), status,
          reservation.getStatusValue());
    }
  }

  @Given("^DB Operator verifies waypoint record using data below:$")
  public void dbOperatorVerifiesWaypointRecord(Map<String, String> mapOfData) {
    Reservation reservation = get(KEY_CREATED_RESERVATION);
    Waypoint waypoint = getCoreJdbc().getWaypoint(reservation.getWaypointId());

    if (Objects.nonNull(mapOfData.get("status"))) {
      String status = mapOfData.get("status");
      assertEquals(f("Expected %s in %s table", "status", "waypoints"), status,
          waypoint.getStatus());
    }
  }

  @SuppressWarnings("unchecked")
  @Given("^DB Operator verifies orders record using data below:$")
  public void dbOperatorVerifiesOrdersRecord(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    Order order = get(KEY_CREATED_ORDER);
    final String finalTrackingId = order.getTrackingId();
    List<Order> orderRecordsFiltered = retryIfExpectedExceptionOccurred(() ->
    {
      List<Order> orderRecords = getCoreJdbc().getOrderByTrackingId(finalTrackingId);
      List<Order> orderRecordsTemp = orderRecords.stream()
          .filter(record -> record.getTrackingId().equals(finalTrackingId))
          .collect(Collectors.toList());

      assertEquals(f("Expected 1 record in Orders table with tracking ID %s", finalTrackingId), 1,
          orderRecordsTemp.size());
      return orderRecordsTemp;
    }, getCurrentMethodName(), NvLogger::warn, 500, 30, AssertionError.class);

    Order orderRecord = orderRecordsFiltered.get(0);

    if (Objects.nonNull(mapOfData.get("status"))) {
      String status = mapOfData.get("status");
      assertEquals(f("Expected %s in %s table", "status", "orders"), status,
          orderRecord.getStatus());
    }
    if (Objects.nonNull(mapOfData.get("granularStatus"))) {
      String granularStatus = mapOfData.get("granularStatus");
      assertEquals(f("Expected %s in %s table", "granularStatus", "orders"), granularStatus,
          orderRecord.getGranularStatus());
    }
    if (Objects.nonNull(mapOfData.get("toAddress1"))) {
      String toAddress1 =
          Objects.equals(mapOfData.get("toAddress1"), "GET_FROM_CREATED_ORDER") ? order
              .getToAddress1() :
              mapOfData.get("toAddress1");
      assertEquals(f("Expected %s in %s table", "to_address1", "orders"), toAddress1,
          orderRecord.getToAddress1());
    }
    if (Objects.nonNull(mapOfData.get("toAddress2"))) {
      String toAddress2 =
          Objects.equals(mapOfData.get("toAddress2"), "GET_FROM_CREATED_ORDER") ? order
              .getToAddress2() :
              mapOfData.get("toAddress2");
      assertEquals(f("Expected %s in %s table", "to_address2", "orders"), toAddress2,
          orderRecord.getToAddress2());
    }
    if (Objects.nonNull(mapOfData.get("toPostcode"))) {
      String toPostcode =
          Objects.equals(mapOfData.get("toPostcode"), "GET_FROM_CREATED_ORDER") ? order
              .getToPostcode() :
              mapOfData.get("toPostcode");
      assertEquals(f("Expected %s in %s table", "to_postcode", "orders"), toPostcode,
          orderRecord.getToPostcode());
    }
    if (Objects.nonNull(mapOfData.get("toCity"))) {
      String toCity =
          Objects.equals(mapOfData.get("toCity"), "GET_FROM_CREATED_ORDER") ? order.getToCity() :
              mapOfData.get("toCity");
      assertEquals(f("Expected %s in %s table", "to_city", "orders"), toCity,
          orderRecord.getToCity());
    }
    if (Objects.nonNull(mapOfData.get("toCountry"))) {
      String toCountry =
          Objects.equals(mapOfData.get("toCountry"), "GET_FROM_CREATED_ORDER") ? order
              .getToCountry() :
              mapOfData.get("toCountry");
      assertEquals(f("Expected %s in %s table", "to_country", "orders"), toCountry,
          orderRecord.getToCountry());
    }
    if (Objects.nonNull(mapOfData.get("toState"))) {
      String toState =
          Objects.equals(mapOfData.get("toState"), "GET_FROM_CREATED_ORDER") ? order.getToState() :
              mapOfData.get("toState");
      assertEquals(f("Expected %s in %s table", "to_state", "orders"), toState,
          orderRecord.getToState());
    }
    if (Objects.nonNull(mapOfData.get("toDistrict"))) {
      String toDistrict =
          Objects.equals(mapOfData.get("toDistrict"), "GET_FROM_CREATED_ORDER") ? order
              .getToDistrict() :
              mapOfData.get("toDistrict");
      assertEquals(f("Expected %s in %s table", "to_district", "orders"), toDistrict,
          orderRecord.getToDistrict());
    }
    if (StringUtils.isNotBlank(mapOfData.get("rts"))) {
      boolean expected = StringUtils.equalsAnyIgnoreCase(mapOfData.get("rts"), "1", "true");
      assertEquals("RTS", expected, orderRecord.getRts());
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

      assertEquals(f("Expected 0 record in Orders table with tracking ID %s", finalTrackingId), 0,
          orderRecords.size());
      return orderRecords;
    }, getCurrentMethodName(), NvLogger::warn, 500, 30, AssertionError.class);
  }

  @SuppressWarnings("unchecked")
  @Given("^DB Operator verifies waypoint for (Pickup|Delivery) transaction is deleted from route_waypoint table$")
  public void dbOperatorVerifiesWaypointIsDeleted(String txnType) {
    Order order = get(KEY_CREATED_ORDER);
    final String waypointId = String.valueOf(order.getTransactions().stream()
        .filter(transaction -> StringUtils.equalsIgnoreCase(transaction.getType(), txnType))
        .findFirst().orElseThrow(() -> new IllegalArgumentException(
            f("No %s transaction for %d order", txnType, order.getId())))
        .getWaypointId());
    retryIfExpectedExceptionOccurred(() ->
    {
      List<Map<String, Object>> waypointRecords = getCoreJdbc().getWaypointRecords(waypointId);

      assertEquals(f("Expected 0 record in route_waypoint table with waypoint ID %s", waypointId),
          0, waypointRecords.size());
      return waypointRecords;
    }, getCurrentMethodName(), NvLogger::warn, 500, 30, AssertionError.class);
  }

  private void validatePickupInWaypointRecord(Order order, String transactionType,
      long waypointId) {
    Waypoint actualWaypoint = getCoreJdbc().getWaypoint(waypointId);
    assertEquals(f("%s waypoint [%d] city", transactionType, waypointId), order.getFromCity(),
        StringUtils.normalizeSpace(actualWaypoint.getCity()));
    assertEquals(f("%s waypoint [%d] country", transactionType, waypointId), order.getFromCountry(),
        StringUtils.normalizeSpace(actualWaypoint.getCountry()));
    assertEquals(f("%s waypoint [%d] address1", transactionType, waypointId),
        order.getFromAddress1(), StringUtils.normalizeSpace(actualWaypoint.getAddress1()));
    assertEquals(f("%s waypoint [%d] address2", transactionType, waypointId),
        order.getFromAddress2(), StringUtils.normalizeSpace(actualWaypoint.getAddress2()));
    assertEquals(f("%s waypoint [%d] postcode", transactionType, waypointId),
        order.getFromPostcode(), StringUtils.normalizeSpace(actualWaypoint.getPostcode()));
    assertEquals(f("%s waypoint [%d] timewindowId", transactionType, waypointId),
        order.getPickupTimeslot().getId(), Integer.parseInt(actualWaypoint.getTimeWindowId()));
  }

  private void validateDeliveryInWaypointRecord(Order order, String transactionType,
      long waypointId) {
    Waypoint actualWaypoint = getCoreJdbc().getWaypoint(waypointId);
    assertEquals(f("%s waypoint [%d] city", transactionType, waypointId),
        Objects.isNull(order.getToCity()) ? "" :
            order.getToCity(), actualWaypoint.getCity());
    assertEquals(f("%s waypoint [%d] country", transactionType, waypointId), order.getToCountry(),
        StringUtils.normalizeSpace(actualWaypoint.getCountry()));
    assertEquals(f("%s waypoint [%d] address1", transactionType, waypointId), order.getToAddress1(),
        StringUtils.normalizeSpace(actualWaypoint.getAddress1()));
    assertEquals(f("%s waypoint [%d] address2", transactionType, waypointId), order.getToAddress2(),
        StringUtils.normalizeSpace(actualWaypoint.getAddress2()));
    assertEquals(f("%s waypoint [%d] postcode", transactionType, waypointId), order.getToPostcode(),
        StringUtils.normalizeSpace(actualWaypoint.getPostcode()));
    if (Objects.nonNull(order.getDeliveryTimeslot())) {
      assertEquals(f("%s waypoint [%d] timewindowId", transactionType, waypointId),
          order.getDeliveryTimeslot().getId(),
          Integer.parseInt(actualWaypoint.getTimeWindowId()));
    }
  }

  @Then("^DB Operator verify ticket status$")
  public void dbOperatorVerifyTicketStatus(Map<String, Integer> mapOfData)
      throws SQLException, ClassNotFoundException {
    Long orderId = get(KEY_CREATED_ORDER_ID);
    Integer expectedStatus = mapOfData.get("status");
    Integer ticketStatus = getTicketsJdbc().getTicketStatus(orderId);

    assertEquals(
        f("Expected ticket status %s but actual ticket status %d", expectedStatus, ticketStatus),
        expectedStatus, ticketStatus);
  }

  @Then("^DB Operator verify reservation priority level$")
  public void dbOperatorReservationPriorityLevel(Map<String, Integer> mapOfData)
      throws SQLException, ClassNotFoundException {
    Long reservationId = get(KEY_CREATED_RESERVATION_ID);
    Integer expectedPriorityLevel = mapOfData.get("priorityLevel");
    Integer priorityLevel = getCoreJdbc().getReservationPriorityLevel(reservationId);

    assertEquals(f("Expected Reservation Priority Level %s but actual Priority Level %d",
        expectedPriorityLevel, priorityLevel), expectedPriorityLevel, priorityLevel);
  }

  @Then("^DB Operator verify new record is created in route_waypoints table with the correct details$")
  public void dbOperatorVerifyRouteWaypointsTable() throws SQLException, ClassNotFoundException {
    Long reservationId = get(KEY_CREATED_RESERVATION_ID);
    Long routeId = get(KEY_CREATED_ROUTE_ID);
    Long reservationWaypoint = getCoreJdbc().getReservationWaypoint(reservationId);
    Long routeWaypoint = getCoreJdbc().getRouteWaypoint(routeId);

    assertEquals(f("Waypoint ID in reservations DB %s but Waypoint ID in route_waypoint %d",
        reservationWaypoint, routeWaypoint), reservationWaypoint, routeWaypoint);
  }

  @Then("^DB Operator verify the orders are deleted in core_qa_sg.order_batch_items DB$")
  public void dbOperatorVerifyBatchIdIsDeleted() throws SQLException, ClassNotFoundException {
    Long batchId = get(KEY_CREATED_BATCH_ID);
    Long result = getCoreJdbc().getBatchId(batchId);

    assertEquals(f("%s Batch ID Is Not Deleted", batchId), result, null);
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
    assertEquals("automation@ninjavan.co", movementTripEntityUserId);
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
        assertThat("Updated name is the same", actualName, equalTo(resolvedUpdatedValue));
        break;
      case "contactNumber":
        Long driverId = driverData.getId();
        String actualContactNumber = getDriverJdbc().getLatestDriverContactNumber(driverId);
        assertThat("Updated name is the same", actualContactNumber, equalTo(resolvedUpdatedValue));
        break;
      case "hub":
        String actualHubId = String.valueOf(driverData.getHubId());
        assertThat("Updated hub is the same", actualHubId, equalTo(resolvedUpdatedValue));
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

    List<MovementPath> movementPaths = getHubJdbc()
        .getAllMovementPath(originHubId, destinationHubId);
    movementPaths
        .forEach(movementPath -> putInList(KEY_LIST_OF_CREATED_PATH_ID, movementPath.getId()));
    assertThat("Movement path length is equal", movementPaths.size(), equalTo(numberOfPaths));
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
        assertThat("Movement path length is equal", movementPaths.size(), equalTo(3));
        break;
      case HUB_CD_CD:
      case HUB_CD_ST_DIFF_CD:
      case HUB_ST_CD_DIFF_CD:
      case HUB_ST_ST_DIFF_CD:
        destinationHubId = createdHubs.get(1).getId();
        movementPaths = getHubJdbc().getAllMovementPath(originHubId, destinationHubId);
        movementPaths
            .forEach(movementPath -> putInList(KEY_LIST_OF_CREATED_PATH_ID, movementPath.getId()));
        assertThat("Movement path length is equal", movementPaths.size(), equalTo(2));
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
        assertThat("Movement path length is equal", movementPaths.size(), equalTo(3));
        break;
    }
  }

  @Then("DB Operator verify {string} is deleted in movement_path table")
  public void dbOperatorVerifyPathIsDeletedInMovementPathTable(String pathIdAsString) {
    Long pathId = Long.valueOf(resolveValue(pathIdAsString));
    MovementPath movementPath = getHubJdbc().getMovementPathById(pathId);
    assertThat("Movement path deleted at is not null", movementPath.getDeletedAt(), notNullValue());
  }

  @Then("DB Operator verify {string} is deleted in hub_relation_schedules")
  public void dbOperatorVerifyScheduleIsDeletedInHubRelationSchedules(
      String hubRelationIdAsString) {
    Long hubRelationId = Long.valueOf(resolveValue(hubRelationIdAsString));
    HubRelationSchedule hubRelationSchedule = getHubJdbc()
        .getHubRelationScheduleByHubRelationId(hubRelationId);
    assertThat("Hub Relation not found", hubRelationSchedule.getDeletedAt(), notNullValue());
  }

  @Then("DB Operator verify {string} is not deleted in hub_relation_schedules")
  public void dbOperatorVerifyScheduleIsNotDeletedInHubRelationSchedules(
      String hubRelationIdAsString) {
    Long hubRelationId = Long.valueOf(resolveValue(hubRelationIdAsString));
    HubRelationSchedule hubRelationSchedule = getHubJdbc()
        .getHubRelationScheduleByHubRelationId(hubRelationId);
    assertThat("Hub Relation found", hubRelationSchedule.getDeletedAt(), equalTo(null));
  }

  @Then("DB Operator verify created hub relation schedules is not deleted")
  public void dbOperatorVerifyHubRelationScheduleIsNotDeletedFor() {
    List<HubRelation> hubRelations = get(KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP);
    List<HubRelation> createdHubRelations = hubRelations.subList(2, hubRelations.size());
    createdHubRelations.forEach(hubRelation -> {
      HubRelationSchedule hubRelationSchedule = getHubJdbc()
          .getHubRelationScheduleByHubRelationId(hubRelation.getId());
      assertThat("Hub Relation found", hubRelationSchedule.getDeletedAt(), equalTo(null));
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
        assertThat("Movement Event not found", movementEventEntityExistence, equalTo(false));
        continue;
      }
      MovementEventEntity movementEventEntity = getHubJdbc()
          .getMovementEventByShipmentId(shipmentId);
      assertThat("Event is equal", movementEventEntity.getEvent(), equalTo(expectedEvent));
      assertThat("Status is equal", movementEventEntity.getStatus(), equalTo(expectedStatus));
      assertThat("ExtData is equal", movementEventEntity.getExtData(), equalTo(expectedExtData));
      pause2s();
    }
  }

  @Then("DB Operator verify sla in movement_events table for {string} no path for the following shipments from {string} to {string}:")
  public void dbOperatorVerifySlaInMovementEventsTableForNoPathForTheFollowingShipmentsFromTo(
      String scheduleType, String originHub, String destHub, List<String> shipmentIds) {
    switch (scheduleType) {
      case HUB_CD_CD:
      case HUB_ST_ST_DIFF_CD:
      case HUB_ST_CD_DIFF_CD:
      case HUB_CD_ST_DIFF_CD:
      case HUB_ST_ST_SAME_CD:
        dbOperatorVerifySlaFailedAndPathNotFoundInExtDataMovementEventsTableWithDataBelow(
            "FAILED", originHub, destHub, shipmentIds);
        break;
      case HUB_CD_ITS_ST:
      case HUB_ST_ITS_CD:
        dbOperatorVerifySlaFailedAndPathNotFoundInExtDataMovementEventsTableWithDataBelow(
            "NOT FOUND", originHub, destHub, shipmentIds);
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

  @When("DB Operator verify sla in movement_events table is succeed for the following data:")
  public void dbOperatorVerifySlaInMovementEventsTableIsSucceedForTheFollowingData(
      Map<String, String> mapOfData) {
    Map<String, String> resolvedMapData = resolveKeyValues(mapOfData);
    String expectedExtData = resolvedMapData.get("extData");
    String[] shipmentIds = resolvedMapData.get("shipmentIds").split(",");
    List<Long> listShipmentIds = Arrays.stream(shipmentIds).map(Long::valueOf)
        .collect(Collectors.toList());

    String expectedEvent = "SLA_CALCULATION";
    String expectedStatus = "SUCCESS";
    for (Long shipmentId : listShipmentIds) {
      MovementEventEntity movementEventEntity = getHubJdbc()
          .getMovementEventByShipmentId(shipmentId);
      assertThat("Event is equal", movementEventEntity.getEvent(), equalTo(expectedEvent));
      assertThat("Status is equal", movementEventEntity.getStatus(), equalTo(expectedStatus));
      assertThat("ExtData is equal", movementEventEntity.getExtData(), equalTo(expectedExtData));
      pause1s();
    }
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
      assertThat("Event is equal", movementEventEntity.getEvent(), equalTo(expectedEvent));
      assertThat("Status is equal", movementEventEntity.getStatus(), equalTo(expectedStatus));
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
    assertThat("Event is equal", landHaulMovementEventEntity.getEvent(), equalTo(expectedEvent));
    assertThat("Status is equal", landHaulMovementEventEntity.getStatus(), equalTo(expectedStatus));

    MovementEventEntity airHaulMovementEventEntity = getHubJdbc()
        .getMovementEventByShipmentId(airHaulShipmentId);
    assertThat("Event is equal", airHaulMovementEventEntity.getEvent(), equalTo(expectedEvent));
    assertThat("Status is equal", airHaulMovementEventEntity.getStatus(), equalTo(expectedStatus));

    String expectedExtDataLandHaul;
    String expectedExtDataAirHaul;
    String pathBase;
    String pathOptionOne;
    String pathOptionTwo;
    String pathOptionThree;
    String pathOptionFour;

    switch (scheduleType) {
      case HUB_CD_CD:
      case "ST->its CD":
      case "CD->its ST":
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
      case "ST->another CD":
      case "ST->ST under same CD":
      case "CD->ST under another CD":
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
      case "ST->ST under diff CD":
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

    switch (scheduleType) {
      case HUB_CD_CD:
      case "ST->its CD":
      case "CD->its ST":
        apiOperatorVerifySlaInMovementEventsTableForMovement(scheduleType);
        break;
      case "ST->another CD":
      case "ST->ST under same CD":
      case "CD->ST under another CD":
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
      case "ST->ST under diff CD":
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
    List<PathSchedule> oldPathSchedule = pathSchedule.subList(0,7);
    oldPathSchedule.forEach(pathScheduleElement -> {
      assertThat(f("path id is the same %d", movementPath.getId()), pathScheduleElement.getPathId(),
          equalTo(movementPath.getId()));
      assertThat("deleted at is not null", pathScheduleElement.getDeletedAt(),
          not(equalTo(null)));
    });
  }
}
