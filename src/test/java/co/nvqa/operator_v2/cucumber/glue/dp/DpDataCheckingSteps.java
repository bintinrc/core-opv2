package co.nvqa.operator_v2.cucumber.glue.dp;

import co.nvqa.common.dp.model.hibernate.DpOrderDetail;
import co.nvqa.common.dp.model.hibernate.dp_analytics.DpOrderAnalyticDetail;
import co.nvqa.common.utils.JsonUtils;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.dp.persisted_classes.DpJob;
import co.nvqa.commons.model.dp.persisted_classes.DpJobOrder;
import co.nvqa.commons.model.dp.persisted_classes.DpReservation;
import co.nvqa.commons.model.dp.persisted_classes.DpReservationEvent;
import co.nvqa.commons.model.dp.persisted_classes.LodgeInOrder;
import co.nvqa.commons.model.dp.persisted_classes.LodgeInStatus;
import co.nvqa.operator_v2.cucumber.glue.AbstractSteps;
import co.nvqa.operator_v2.model.dp.DpOrderAnalytic;
import co.nvqa.operator_v2.model.dp.DpOrderDetailsContent;
import co.nvqa.operator_v2.model.dp.OrderCsvData;
import co.nvqa.operator_v2.selenium.page.AllOrdersPage;
import co.nvqa.operator_v2.selenium.page.DpDataCheckingPage;
import io.cucumber.java.en.Then;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DpDataCheckingSteps extends AbstractSteps {

  private DpDataCheckingPage dpDataCheckingPage;

  private static final Logger LOGGER = LoggerFactory.getLogger(DpDataCheckingSteps.class);

  private static final String RESERVATION = "RESERVATION";
  private static final String LODGE_IN_ORDER = "LODGE_IN_ORDER";
  private static final String LODGE_IN_STATUS = "LODGE_IN_STATUS";
  private static final String DP_JOB_ORDER = "DP_JOB_ORDER";
  private static final String DP_JOB = "DP_JOB";
  private static final String CREATING_SEND_ORDER = "creating_send_order";
  private static final String CREATING_SEND_ORDER_RELEASED = "creating_send_order_released";
  private static final String CREATING_NORMAL_ORDER_AFTER_DRIVER_SCAN = "creating_normal_order_after_driver_scan";
  private static final String ORDER_REGULAR_PICKUP = "order_regular_pickup";
  private static final String CONFIRMED = "CONFIRMED";
  private static final String ORDER_DETAILS = "ORDER_DETAILS";
  private static final String PROCESSED = "PROCESSED";
  private static final String RELEASED = "RELEASED";
  private static final String SUCCESS = "SUCCESS";
  private static final String SEND = "SEND";
  private static final String DRIVER = "DRIVER";
  private static final String DRIVER_DROPPED_OFF = "DRIVER_DROPPED_OFF";
  private static final String PENDING = "PENDING";
  private static final String PENDING_PICKUP = "PENDING_PICKUP";
  private static final String SHIPPER = "SHIPPER";

  @Override
  public void init() {
    dpDataCheckingPage = new DpDataCheckingPage(getWebDriver());
  }


  @Then("Operator verified the order data is based on the data below:")
  public void verifiedNewBulkUploadForThailandError(Map<String, String> dataTableAsMap) {
    Map<String, String> map = resolveKeyValues(dataTableAsMap);
    String[] reasons = map.get("reasonList").split("/");
    List<String> reasonList = Arrays.asList(reasons);
    pause2s();
    String fileDir = dpDataCheckingPage.getLatestDownloadOrderDataPathFile();
    final List<OrderCsvData> orderCsvData = OrderCsvData.fromCsvFile(
        OrderCsvData.class,
        fileDir, true);

    dpDataCheckingPage.checkMsgFromRegularPickupCsv(reasonList,orderCsvData);
  }

  @Then("Ninja Point V3 verifies that the data from newly created order with DB table is right")
  public void ninjaPointVVerifiesThatTheDataOfTheNewlyCreatedOrderIsRight(
      Map<String, String> dataTableAsMap) {
    String dataChecking = resolveValue(dataTableAsMap.get("dataChecking"));
    List<DpJobOrder> dpJobOrders;
    switch (dataChecking) {
      case RESERVATION:
        dpReservationDataChecking(dataTableAsMap);
        break;
      case LODGE_IN_ORDER:
        lodgeInOrderDataChecking(resolveValue(dataTableAsMap.get("condition")),
            resolveValue(dataTableAsMap.get("dataCheckFromDb")));
        break;
      case LODGE_IN_STATUS:
        setLodgeInStatusDataChecking(resolveValue(dataTableAsMap.get("condition")),
            resolveValue(dataTableAsMap.get("dataCheckFromDb")));
        break;

      case DP_JOB_ORDER:
        dpJobOrders = resolveValue(dataTableAsMap.get("dataCheckFromDb"));
        dpJobOrderDataChecking(resolveValue(dataTableAsMap.get("condition")), dpJobOrders);
        break;
      case DP_JOB:
        List<DpJob> dpJobs = resolveValue(
            dataTableAsMap.get("dataCheckFromDb"));
        dpJobOrders = resolveValue(
            dataTableAsMap.get("dpJobOrderFromDb"));

        dpJobDataChecking(dataTableAsMap.get("condition"),
            dpJobs, dpJobOrders);
        break;


      case ORDER_DETAILS:
        DpOrderDetail dpOrderDetails = resolveValue(dataTableAsMap.get("dataCheckFromDb"));

        DpOrderAnalyticDetail dpOrderAnalyticDetails = resolveValue(
            dataTableAsMap.get("dpOrderAnalyticFromDb"));
        DpOrderDetailsContent orderContent = JsonUtils.fromJsonSnakeCase(
            dpOrderAnalyticDetails.getContent(),
            DpOrderDetailsContent.class);
        DpOrderAnalytic dpOrderAnalytic = new DpOrderAnalytic(dpOrderAnalyticDetails.getId(),
            dpOrderAnalyticDetails.getSystemId(), dpOrderAnalyticDetails.getOrderId(), orderContent,
            dpOrderAnalyticDetails.getCreatedAt(), dpOrderAnalyticDetails.getUpdatedAt());

        if (dataTableAsMap.get("order") != null) {
          Order order = resolveValue(dataTableAsMap.get("order"));
          checkDpOrderDetails(dpOrderDetails, dataTableAsMap.get("condition"), order);
          checkDpOrderAnalyticDetails(dpOrderAnalytic, dataTableAsMap.get("condition"), order);
        } else {
          checkDpOrderDetails(dpOrderDetails, dataTableAsMap.get("condition"), null);
          checkDpOrderAnalyticDetails(dpOrderAnalytic, dataTableAsMap.get("condition"), null);
        }

        break;

      default:
        LOGGER.warn("Condition is not valid");
    }
  }

  public void checkDpOrderDetails(DpOrderDetail dpOrderDetail, String condition, Order order) {
    final String conditionEnum = condition;
    SoftAssertions softAssertions = new SoftAssertions();
    softAssertions.assertThat(dpOrderDetail.getBarcode())
        .as(f("dp_qa_gl/dp_order_details: Barcode is %s", dpOrderDetail.getBarcode()))
        .isNotNull();
    switch (conditionEnum) {
      case CREATING_SEND_ORDER:
        if (order != null) {
          softAssertions.assertThat(dpOrderDetail.getPrimaryRecipientName())
              .as(f("dp_qa_gl/dp_order_details: Primary Recipient Name is %s", order.getToName()))
              .isEqualTo(order.getToName());
          softAssertions.assertThat(dpOrderDetail.getPrimaryRecipientContact())
              .as(f("dp_qa_gl/dp_order_details: Primary Recipient Contact is %s",
                  order.getToContact())).isEqualTo(order.getToContact());
          softAssertions.assertThat(dpOrderDetail.getPrimaryRecipientEmail())
              .as(f("dp_qa_gl/dp_order_details: Primary Recipient Email is %s", order.getToEmail()))
              .isEqualTo(order.getToEmail());
          softAssertions.assertThat(dpOrderDetail.getPrimaryRecipientAddress1())
              .as(f("dp_qa_gl/dp_order_details: Primary Recipient Adress 1 is %s",
                  order.getToAddress1())).isEqualTo(order.getToAddress1());
          softAssertions.assertThat(dpOrderDetail.getPrimaryRecipientAddress2())
              .as(f("dp_qa_gl/dp_order_details: Primary Recipient Adress 2 is %s",
                  order.getToAddress2())).isEqualTo(order.getToAddress2());
        }
        softAssertions.assertThat(dpOrderDetail.getRtsReason())
            .as("dp_qa_gl/dp_order_details: RTS Reason is NULL").isNull();
        softAssertions.assertThat(dpOrderDetail.getLatestDeliveryFailyreReason())
            .as("dp_qa_gl/dp_order_details: Latest Delivery Failure Reason is NULL").isNull();
        softAssertions.assertThat(dpOrderDetail.getStatus())
            .as("dp_qa_gl/dp_order_details: Status is Pending").isEqualToIgnoringCase(PENDING);
        softAssertions.assertThat(dpOrderDetail.getGranularStatus())
            .as("dp_qa_gl/dp_order_details: Granular Status is Pending Pickup")
            .isEqualToIgnoringCase(PENDING_PICKUP);
        softAssertions.assertThat(dpOrderDetail.getRtsAt())
            .as("dp_qa_gl/dp_order_details: RTS At is NULL").isNull();
        softAssertions.assertThat(dpOrderDetail.getCompletedAt())
            .as("dp_qa_gl/dp_order_details: Completed At is NULL").isNull();
        softAssertions.assertThat(dpOrderDetail.getOrderCreatedAt())
            .as(f("dp_qa_gl/dp_order_details: Order Created At is %s",
                dpOrderDetail.getOrderCreatedAt())).isNotNull();
        break;
    }
  }

  public void checkDpOrderAnalyticDetails(DpOrderAnalytic dpOrderAnalytic, String condition,
      Order order) {
    final String conditionEnum = condition;
    SoftAssertions softAssertions = new SoftAssertions();
    if (order != null) {
      softAssertions.assertThat(dpOrderAnalytic.getContent().getOrderId())
          .as(f("dp_analytics_qa_gl/dp_order_details: Order Id is %s",
              dpOrderAnalytic.getContent().getOrderId())).isEqualTo(order.getId());
    } else {
      softAssertions.assertThat(dpOrderAnalytic.getContent().getOrderId())
          .as(f("dp_analytics_qa_gl/dp_order_details: Order Id is %s",
              dpOrderAnalytic.getContent().getOrderId())).isNotNull();
    }

    switch (conditionEnum) {
      case CREATING_SEND_ORDER:
        softAssertions.assertThat(dpOrderAnalytic.getContent().getStatus())
            .as("dp_analytics_qa_gl/dp_order_details: Status is Pending")
            .isEqualToIgnoringCase(PENDING);
        softAssertions.assertThat(dpOrderAnalytic.getContent().getGranularStatus())
            .as("dp_analytics_qa_gl/dp_order_details: Granular Status is Pending Pickup")
            .isEqualToIgnoringCase(PENDING_PICKUP);
        break;
    }
  }


  public void lodgeInOrderDataChecking(String condition, List<LodgeInOrder> lodgeInOrders) {
    final String conditionEnum = condition;
    switch (conditionEnum) {
      case CREATING_SEND_ORDER:
        for (LodgeInOrder lodgeInOrderData : lodgeInOrders) {
          Assertions.assertThat(lodgeInOrderData.getBarcode())
              .as(f("dp_qa_gl/lodge_in_order: Barcode is %s", lodgeInOrderData.getBarcode()))
              .isNotNull();
          Assertions.assertThat(lodgeInOrderData.getStatus())
              .as("dp_qa_gl/lodge_in_order: Status is SUCCESS").isEqualTo(SUCCESS);
          Assertions.assertThat(lodgeInOrderData.getStatusId())
              .as(f("dp_qa_gl/lodge_in_order: Status ID is %s", lodgeInOrderData.getStatusId()))
              .isNotNull();
          Assertions.assertThat(lodgeInOrderData.getErrorMessage())
              .as("dp_qa_gl/lodge_in_order: Error Message is NULL").isNull();
          Assertions.assertThat(lodgeInOrderData.getUpdatedAt())
              .as(f("dp_qa_gl/lodge_in_order: Updated At is %s", lodgeInOrderData.getUpdatedAt()))
              .isNotNull();
          Assertions.assertThat(lodgeInOrderData.getDeletedAt())
              .as("dp_qa_gl/lodge_in_order: Deleted At is NULL").isNull();
        }
        break;

      default:
        LOGGER.warn("Condition is not valid");
    }
  }

  public void setLodgeInStatusDataChecking(String condition, List<LodgeInStatus> lodgeInStatuses) {
    final String conditionEnum = condition;
    LocalDateTime ldt = LocalDateTime.now();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    switch (conditionEnum) {
      case CREATING_SEND_ORDER:
        for (LodgeInStatus lodgeInStatusData : lodgeInStatuses) {
          Assertions.assertThat(lodgeInStatusData.getStatus())
              .as("dp_qa_gl/lodge_in_status: Status is SUCCESS").isEqualTo(PROCESSED);
          Assertions.assertThat(lodgeInStatusData.getDpId())
              .as(f("dp_qa_gl/lodge_in_status: DP ID is %s", lodgeInStatusData.getDpId()))
              .isNotNull();
          Assertions.assertThat(lodgeInStatusData.getDpId())
              .as(f("dp_qa_gl/lodge_in_status: Updated At is %s", lodgeInStatusData.getUpdatedAt()))
              .isNotNull();
          Assertions.assertThat(sdf.format(lodgeInStatusData.getCreatedAt()))
              .as("dp_qa_gl/lodge_in_status: Created At is At Current Time")
              .isEqualTo(DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH).format(ldt));
          Assertions.assertThat(lodgeInStatusData.getDeletedAt())
              .as("dp_qa_gl/lodge_in_status: Deleted At is NULL").isNull();
        }
        break;

      default:
        LOGGER.warn("Condition is not valid");
    }
  }

  public void dpReservationDataChecking(Map<String, String> dataTableAsMap) {
    final String conditionEnum = dataTableAsMap.get("condition");
    List<DpReservation> dpReservations = resolveValue(dataTableAsMap.get("dataCheckFromDb"));
    LocalDateTime ldt = LocalDateTime.now();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    final String NA = "NA";

    switch (conditionEnum) {
      case CREATING_SEND_ORDER:

        Assertions.assertThat(dpReservations.get(0).getBarcode())
            .as(f("dp_qa_gl/dp_reservations: Barcode is %s", dpReservations.get(0).getBarcode()))
            .isNotNull();

        Assertions.assertThat(dpReservations.get(0).getStatus())
            .as("dp_qa_gl/dp_reservations: Status Confirmed").isEqualTo(CONFIRMED);
        Assertions.assertThat(dpReservations.get(0).getReceiptId())
            .as("dp_qa_gl/dp_reservations: Receipt ID Not Null").isNotNull();

        Assertions.assertThat(sdf.format(dpReservations.get(0).getConfirmedAt()))
            .as("dp_qa_gl/dp_reservations: Confirmed At is At Current Time")
            .isEqualTo(DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH).format(ldt));

        Assertions.assertThat(sdf.format(dpReservations.get(0).getReceivedAt()))
            .as("dp_qa_gl/dp_reservations: Received At is At Current Time")
            .isEqualTo(DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH).format(ldt));

        Assertions.assertThat(dpReservations.get(0).getReceivedFrom())
            .as("dp_qa_gl/dp_reservations: Received From is from SHIPPER").isEqualTo(SHIPPER);
        Assertions.assertThat(sdf.format(dpReservations.get(0).getDroppedOffAt()))
            .as("dp_qa_gl/dp_reservations: Dropped Off At is At Current Time")
            .isEqualTo(DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH).format(ldt));

        Assertions.assertThat(dpReservations.get(0).getSource())
            .as("dp_qa_gl/dp_reservations: Source is equal to SEND").isEqualTo(SEND);

        break;

      case CREATING_SEND_ORDER_RELEASED:
        Assertions.assertThat(dpReservations.get(0).getBarcode())
            .as(f("dp_qa_gl/dp_reservations: Barcode is %s", dpReservations.get(0).getBarcode()))
            .isNotNull();
        Assertions.assertThat(sdf.format(dpReservations.get(0).getReleasedAt()))
            .as("dp_qa_gl/dp_reservations: Released At is At Current Time")
            .isEqualTo(DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH).format(ldt));

        Assertions.assertThat(sdf.format(dpReservations.get(0).getCollectedAt()))
            .as("dp_qa_gl/dp_reservations: Collected At At is At Current Time")
            .isEqualTo(DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH).format(ldt));

        Assertions.assertThat(dpReservations.get(0).getReleasedTo())
            .as("dp_qa_gl/dp_reservations: Released To is Driver").isEqualTo(DRIVER);

        Assertions.assertThat(dpReservations.get(0).getStatus())
            .as("dp_qa_gl/dp_reservations: Status is Released").isEqualTo(RELEASED);

        Assertions.assertThat(dpReservations.get(0).getSource())
            .as("dp_qa_gl/dp_reservations: Source is equal to SEND").isEqualTo(SEND);
        break;

      case CREATING_NORMAL_ORDER_AFTER_DRIVER_SCAN:
        SoftAssertions sa = new SoftAssertions();
        sa.assertThat(dpReservations.get(0).getBarcode())
            .as(f("dp_qa_gl/dp_reservations: Barcode is %s", dpReservations.get(0).getBarcode()))
            .isNotNull();

        sa.assertThat(dpReservations.get(0).getStatus())
            .as("dp_qa_gl/dp_reservations: Status Confirmed").isEqualTo(CONFIRMED);

        sa.assertThat(dpReservations.get(0).getReceivedAt())
            .as("dp_qa_gl/dp_reservations: Received At is At Current Time")
            .isEqualTo(DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH).format(ldt));

        sa.assertThat(dpReservations.get(0).getReceivedFrom())
            .as("dp_qa_gl/dp_reservations: Received From is From DRIVER")
            .isEqualTo(DRIVER);

        sa.assertThat(dpReservations.get(0).getDroppedOffAt())
            .as("dp_qa_gl/dp_reservations: Dropped Off At is At Current Time")
            .isEqualTo(DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH).format(ldt));
        break;
      default:
        LOGGER.warn("Condition is not valid");
    }

    if (dataTableAsMap.get("dpReservationEventsFromDb") != null) {
      List<DpReservationEvent> dpReservationEvents = resolveValue(
          dataTableAsMap.get("dpReservationEventsFromDb"));
      dpReservationEventsDataChecking(dataTableAsMap.get("condition"), dpReservationEvents);
    }
    if (dataTableAsMap.get("dpJobOrderFromDb") != null) {
      List<DpJobOrder> dpJobOrders = resolveValue(
          dataTableAsMap.get("dpJobOrderFromDb"));
      dpJobOrderDataChecking(dataTableAsMap.get("condition"), dpJobOrders);
    }
    if (dataTableAsMap.get("dpJobFromDb") != null
        && dataTableAsMap.get("dpJobOrderFromDb") != null) {
      List<DpJob> dpJobs = resolveValue(
          dataTableAsMap.get("dpJobFromDb"));
      List<DpJobOrder> dpJobOrders = resolveValue(
          dataTableAsMap.get("dpJobOrderFromDb"));
      dpJobDataChecking(dataTableAsMap.get("condition"),
          dpJobs, dpJobOrders);
    }
  }

  public void dpReservationEventsDataChecking(String condition,
      List<DpReservationEvent> dpReservationEvents) {
    final String conditionEnum = condition;
    final String DP_RELEASED_TO_DRIVER = "DP_RELEASED_TO_DRIVER";
    final String DRIVER_COLLECTED = "DRIVER_COLLECTED";
    final String DP_RECEIVED_FROM_SHIPPER = "DP_RECEIVED_FROM_SHIPPER";
    boolean isExist = false;

    switch (conditionEnum) {

      case CREATING_SEND_ORDER:
        Assertions.assertThat(dpReservationEvents.get(0).getName())
            .as("dp_qa_gl/dp_reservation_events: Name is DP_RECEIVED_FROM_SHIPPER")
            .isEqualTo(DP_RECEIVED_FROM_SHIPPER);

        break;

      case CREATING_SEND_ORDER_RELEASED:
        for (DpReservationEvent dpReservationEvent : dpReservationEvents) {
          if (dpReservationEvent.getName().equals("DP_RELEASED_TO_DRIVER")) {
            Assertions.assertThat(dpReservationEvent.getName())
                .as("dp_qa_gl/dp_reservation_events: Name is DP_RELEASED_TO_DRIVER")
                .isEqualTo(DP_RELEASED_TO_DRIVER);

            isExist = true;
          } else if (dpReservationEvent.getName().equals("DRIVER_COLLECTED")) {
            Assertions.assertThat(dpReservationEvent.getName())
                .as("dp_qa_gl/dp_reservation_events: Name is DRIVER_COLLECTED")
                .isEqualTo(DRIVER_COLLECTED);

            isExist = true;
          }
        }
        Assertions.assertThat(isExist).isTrue();
        break;

      case CREATING_NORMAL_ORDER_AFTER_DRIVER_SCAN:
        Assertions.assertThat(dpReservationEvents.get(0).getName())
            .as("dp_qa_gl/dp_reservation_events: Name is DRIVER_DROPPED_OFF")
            .isEqualTo(DRIVER_DROPPED_OFF);
        break;

      default:
        LOGGER.warn("Condition is not valid");

    }
  }

  public void dpJobOrderDataChecking(String condition,
      List<DpJobOrder> dpJobOrders) {
    final String conditionEnum = condition;
    final String PENDING = "PENDING";

    switch (conditionEnum) {

      case ORDER_REGULAR_PICKUP:
      case CREATING_SEND_ORDER:
        Assertions.assertThat(dpJobOrders.get(0).getStatus())
            .as("dp_qa_gl/dp_job_orders: Status is PENDING")
            .isEqualTo(PENDING);

        break;

      case CREATING_NORMAL_ORDER_AFTER_DRIVER_SCAN:
      case CREATING_SEND_ORDER_RELEASED:
        Assertions.assertThat(dpJobOrders.get(0).getStatus())
            .as("dp_qa_gl/dp_job_orders: Status is SUCCESS")
            .isEqualTo(SUCCESS);

        Assertions.assertThat(dpJobOrders.get(0).getIsSwappable())
            .as("dp_qa_gl/dp_job_orders: Is Swappable is False")
            .isFalse();
        break;

      default:
        LOGGER.warn("Condition is not valid");
    }
  }

  public void dpJobDataChecking(String condition,
      List<DpJob> dpJobs, List<DpJobOrder> dpJobOrders) {
    final String conditionEnum = condition;
    final String ACTIVE = "ACTIVE";
    final String COLLECT = "COLLECT";
    final String COMPLETED = "COMPLETED";

    switch (conditionEnum) {
      case ORDER_REGULAR_PICKUP:
      case CREATING_SEND_ORDER:
        if (dpJobs.get(0).getStatus().equals(ACTIVE)) {
          Assertions.assertThat(dpJobs.get(0).getStatus())
              .as("dp_qa_gl/dp_jobs: Status is ACTIVE")
              .isEqualTo(ACTIVE);
        } else if (dpJobs.get(0).getStatus().equals(COMPLETED)) {
          Assertions.assertThat(dpJobs.get(0).getStatus())
              .as("dp_qa_gl/dp_jobs: Status is COMPLETED")
              .isEqualTo(COMPLETED);
        }
        Assertions.assertThat(dpJobs.get(0).getType())
            .as("dp_qa_gl/dp_jobs: Type is COLLECT")
            .isEqualTo(COLLECT);
        Assertions.assertThat(dpJobs.get(0).getId())
            .as("dp_qa_gl/dp_jobs: Id is same for each order")
            .isEqualTo(dpJobOrders.get(0).getDpJobId());
        Assertions.assertThat(dpJobs.get(0).getDate())
            .as(f("dp_qa_gl/dp_jobs: Date is %s",dpJobs.get(0).getDate()))
            .isNotNull();
        break;

      case CREATING_SEND_ORDER_RELEASED:
        Assertions.assertThat(dpJobs.get(0).getStatus())
            .as("dp_qa_gl/dp_jobs: Status is Completed")
            .isEqualTo(COMPLETED);
        break;
      default:
        LOGGER.warn("Condition is not valid");
    }
  }


}
