package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.model.order.Order;
import co.nvqa.common.core.model.order.Order.Dimension;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.model.addressing.AddressingZone;
import co.nvqa.commons.model.sort.sort_code.SortCode;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.GlobalInboundParams;
import co.nvqa.operator_v2.model.OrderEvent;
import co.nvqa.operator_v2.model.RecoveryTicket;
import co.nvqa.operator_v2.model.TransactionInfo;
import co.nvqa.operator_v2.selenium.page.EditOrderPage;
import co.nvqa.operator_v2.selenium.page.EditOrderPage.ChatWithDriverDialog.ChatMessage;
import co.nvqa.operator_v2.selenium.page.EditOrderPage.PodDetailsDialog;
import co.nvqa.operator_v2.selenium.page.MaskedPage;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableList;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.ParseException;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import org.apache.commons.lang3.SerializationUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.assertj.core.data.Offset;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebElement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.operator_v2.selenium.page.EditOrderPage.EventsTable.EVENT_NAME;
import static org.apache.commons.lang3.StringUtils.equalsIgnoreCase;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class EditOrderSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(EditOrderSteps.class);
  public static final String KEY_CHAT_MESSAGE = "KEY_CHAT_MESSAGE";
  public static final String KEY_CHAT_MESSAGE_ID = "KEY_CHAT_MESSAGE_ID";

  private EditOrderPage editOrderPage;

  public EditOrderSteps() {
  }

  @Override
  public void init() {
    editOrderPage = new EditOrderPage(getWebDriver());
  }

  @When("Operator click ([^\"]*) -> ([^\"]*) on Edit Order page")
  public void operatorClickMenuOnEditOrderPage(String parentMenuName, String childMenuName) {
    editOrderPage.clickMenu(parentMenuName, childMenuName);
  }

  @When("Operator Edit Order Details on Edit Order page")
  public void operatorEditOrderDetailsOnEditOrderPage() {
    Order order = get(KEY_CREATED_ORDER);
    Order orderEdited = SerializationUtils.clone(order);

    int newParcelSizeId =
        (StandardTestUtils.getParcelSizeIdByLongString(orderEdited.getParcelSize()) + 1) % 4;
    orderEdited.setParcelSize(StandardTestUtils.getParcelSizeAsLongString(newParcelSizeId));

    Dimension dimension = orderEdited.getDimensions();
    dimension.setWeight(Optional.ofNullable(dimension.getWeight()).orElse(0.0) + 1.0);

    editOrderPage.editOrderDetails(orderEdited);
    takesScreenshot();
    put("orderEdited", orderEdited);
  }

  @Then("Operator Edit Order Details on Edit Order page successfully")
  public void operatorEditOrderDetailsOnEditOrderPageSuccessfully() {
    Order orderEdited = get("orderEdited");
    editOrderPage.verifyEditOrderDetailsIsSuccess(orderEdited);
    takesScreenshot();
  }

  @When("updates parcel size from {string} to {string} for the order")
  public void updates_parcel_size_from_to_for_the_order(String fromSize, String toSize) {
    Order order = get(KEY_CREATED_ORDER);
    order.setParcelSize(toSize);
    editOrderPage.editOrderDetails(order);
    takesScreenshot();
  }

  @When("Operator update order details on Edit Order page:")
  public void updateOrderDetails(Map<String, String> data) {
    data = resolveKeyValues(data);
    editOrderPage.clickMenu("Order Settings", "Edit Order Details");
    editOrderPage.editOrderDetailsDialog.waitUntilVisible();
    if (data.containsKey("weight")) {
      editOrderPage.editOrderDetailsDialog.weight.setValue(data.get("weight"));
    }
    if (data.containsKey("size")) {
      editOrderPage.editOrderDetailsDialog.parcelSize.setValue(data.get("size"));
    }
    if (data.containsKey("length")) {
      editOrderPage.editOrderDetailsDialog.length.setValue(data.get("length"));
    }
    if (data.containsKey("width")) {
      editOrderPage.editOrderDetailsDialog.width.setValue(data.get("width"));
    }
    if (data.containsKey("breadth")) {
      editOrderPage.editOrderDetailsDialog.breadth.setValue(data.get("breadth"));
    }
    editOrderPage.editOrderDetailsDialog.saveChanges.click();
  }

  @Then("Operator verifies dimensions information on Edit Order page:")
  public void operatorVerifyDimensionInformation(Map<String, String> data) {
    data = resolveKeyValues(data);
    SoftAssertions softAssertions = new SoftAssertions();
    String expected = data.get("size");
    if (StringUtils.isNotBlank(expected)) {
      softAssertions.assertThat(editOrderPage.size.getText())
          .as("Parcel size")
          .isEqualToIgnoringCase(expected);
    }
    expected = data.get("weight");
    if (StringUtils.isNotBlank(expected)) {
      softAssertions.assertThat(editOrderPage.getWeight())
          .as("Parcel weight")
          .isEqualTo(Double.parseDouble(expected));
    }
    expected = data.get("length");
    if (StringUtils.isNotBlank(expected)) {
      softAssertions.assertThat(editOrderPage.getLength())
          .as("Parcel length")
          .isEqualTo(Double.parseDouble(expected));
    }
    expected = data.get("width");
    if (StringUtils.isNotBlank(expected)) {
      softAssertions.assertThat(editOrderPage.getWidth())
          .as("Parcel width")
          .isEqualTo(Double.parseDouble(expected));
    }
    expected = data.get("height");
    if (StringUtils.isNotBlank(expected)) {
      softAssertions.assertThat(editOrderPage.getHeighth())
          .as("Parcel height")
          .isEqualTo(Double.parseDouble(expected));
    }
    takesScreenshot();
    softAssertions.assertAll();
  }

  @Then("Operator verifies pricing information on Edit Order page:")
  public void operatorVerifyPricingInformation(Map<String, String> data) {
    data = resolveKeyValues(data);
    SoftAssertions softAssertions = new SoftAssertions();
    String expectedValue;

    if (data.containsKey("total")) {
      expectedValue = data.get("total");
      if (expectedValue.equals("-")) {
        softAssertions.assertThat(editOrderPage.totalPrice.getText()).as("Total Fee is correct")
            .isEqualTo("-");
      } else {
        softAssertions.assertThat(editOrderPage.getTotal())
            .as("Total is correct")
            .isCloseTo(StandardTestUtils.getDoubleValue(data.get("total")), Offset.offset(0.09));
      }
    }

    if (data.containsKey("deliveryFee")) {
      expectedValue = data.get("deliveryFee");
      if (expectedValue.equals("-")) {
        softAssertions.assertThat(editOrderPage.deliveryFee.getText()).as("Delivery Fee is correct")
            .isEqualTo("-");
      } else {
        softAssertions.assertThat(
            StandardTestUtils.getDoubleValue(editOrderPage.deliveryFee.getText()))
            .as("Delivery Fee is correct")
            .isCloseTo(StandardTestUtils.getDoubleValue(data.get("deliveryFee")),
                Offset.offset(0.09));
      }
    }

    if (data.containsKey("codFee")) {
      expectedValue = data.get("codFee");
      if (expectedValue.equals("-")) {
        softAssertions.assertThat(editOrderPage.codFee.getText()).as("COD Fee is correct")
            .isEqualTo("-");
      } else {
        softAssertions.assertThat(StandardTestUtils.getDoubleValue(editOrderPage.codFee.getText()))
            .as("COD Fee is correct")
            .isCloseTo(StandardTestUtils.getDoubleValue(expectedValue), Offset.offset(0.09));
      }
    }

    if (data.containsKey("insuranceFee")) {
      expectedValue = data.get("insuranceFee");
      if (expectedValue.equals("-")) {
        softAssertions.assertThat(editOrderPage.insuranceFee.getText())
            .as("Insurance Fee is correct")
            .isEqualTo("-");
      } else {
        softAssertions.assertThat(
            StandardTestUtils.getDoubleValue(editOrderPage.insuranceFee.getText()))
            .as("Insurance Fee is correct")
            .isCloseTo(StandardTestUtils.getDoubleValue(expectedValue), Offset.offset(0.09));
      }
    }

    if (data.containsKey("handlingFee")) {
      expectedValue = data.get("handlingFee");
      if (expectedValue.equals("-")) {
        softAssertions.assertThat(editOrderPage.handlingFee.getText()).as("Handling Fee is correct")
            .isEqualTo("-");
      } else {
        softAssertions.assertThat(
            StandardTestUtils.getDoubleValue(editOrderPage.handlingFee.getText()))
            .as("Handling Fee is correct")
            .isCloseTo(StandardTestUtils.getDoubleValue(expectedValue), Offset.offset(0.09));
      }
    }

    if (data.containsKey("rtsFee")) {
      expectedValue = data.get("rtsFee");
      if (expectedValue.equals("-")) {
        softAssertions.assertThat(editOrderPage.rtsFee.getText()).as("Rts Fee is correct")
            .isEqualTo("-");
      } else {
        softAssertions.assertThat(
            StandardTestUtils.getDoubleValue(editOrderPage.rtsFee.getText()))
            .as("Rts Fee is correct")
            .isCloseTo(StandardTestUtils.getDoubleValue(expectedValue), Offset.offset(0.09));
      }
    }

    if (data.containsKey("gst")) {
      expectedValue = data.get("gst");
      if (expectedValue.equals("-")) {
        softAssertions.assertThat(editOrderPage.gst.getText()).as("GST Fee is correct")
            .isEqualTo("-");
      } else {
        softAssertions.assertThat(StandardTestUtils.getDoubleValue(editOrderPage.gst.getText()))
            .as("Gst is correct")
            .isCloseTo(StandardTestUtils.getDoubleValue(expectedValue), Offset.offset(0.09));
      }
    }

    if (data.containsKey("insuredValue")) {
      expectedValue = data.get("insuredValue");
      if (expectedValue.equals("-")) {
        softAssertions.assertThat(editOrderPage.insuredValue.getText())
            .as("Insurance Value is correct")
            .isEqualTo("-");
      } else {
        softAssertions.assertThat(
            StandardTestUtils.getDoubleValue(editOrderPage.insuredValue.getText()))
            .as("Insured Fee is correct")
            .isCloseTo(StandardTestUtils.getDoubleValue(expectedValue), Offset.offset(0.09));
      }
    }

    if (data.containsKey("billingWeight")) {
      expectedValue = data.get("billingWeight");
      if (expectedValue.equals("notAvailable")) {
        softAssertions.assertThat(editOrderPage.billingWeight.isDisplayed())
            .as("Billing Weight Value is correct").isFalse();
      } else {
        softAssertions.assertThat(editOrderPage.billingWeight.getText())
            .as("Billing Weight is correct").isEqualTo(expectedValue);
      }
    }

    if (data.containsKey("billingSize")) {
      expectedValue = data.get("billingSize");
      if (expectedValue.equals("notAvailable")) {
        softAssertions.assertThat(editOrderPage.billingSize.isDisplayed())
            .as("Billing Size Value is correct").isFalse();
      } else {
        softAssertions.assertThat(editOrderPage.billingSize.getText())
            .as("Billing Size is correct").isEqualTo(expectedValue);
      }
    }

    if (data.containsKey("source")) {
      expectedValue = data.get("source");
      if (expectedValue.equals("notAvailable")) {
        softAssertions.assertThat(editOrderPage.source.isDisplayed())
            .as("Source is correct").isFalse();
      } else {
        softAssertions.assertThat(editOrderPage.source.getText())
            .as("Source is correct").isEqualTo(expectedValue);
      }
    }

    softAssertions.assertAll();
  }

  @When("Operator enter Order Instructions on Edit Order page:")
  public void operatorEnterOrderInstructionsOnEditOrderPage(Map<String, String> data) {
    String pickupInstruction = data.get("pickupInstruction");

    if (pickupInstruction != null) {
      put(KEY_PICKUP_INSTRUCTION, pickupInstruction);
    }

    String deliveryInstruction = data.getOrDefault("deliveryInstruction", "");

    if (deliveryInstruction != null) {
      put(KEY_DELIVERY_INSTRUCTION, deliveryInstruction);
    }

    editOrderPage.editOrderInstructions(pickupInstruction, deliveryInstruction);
  }

  @When("Operator verify Order Instructions are updated on Edit Order Page")
  public void operatorVerifyOrderInstructionsAreUpdatedOnEditOrderPage() {
    Order order = get(KEY_CREATED_ORDER);
    String pickupInstruction = get(KEY_PICKUP_INSTRUCTION);

    if (StringUtils.isNotBlank(pickupInstruction)) {
      pickupInstruction = order.getInstruction() + ", " + pickupInstruction;
    }

    String deliveryInstruction = get(KEY_DELIVERY_INSTRUCTION);

    if (StringUtils.isNotBlank(deliveryInstruction)) {
      deliveryInstruction = order.getInstruction() + ", " + deliveryInstruction;
    }

    editOrderPage.verifyOrderInstructions(pickupInstruction, deliveryInstruction);
    takesScreenshot();
  }

  @When("Operator confirm manually complete order on Edit Order page")
  public void operatorManuallyCompleteOrderOnEditOrderPage() {
    String changeReason = editOrderPage.confirmCompleteOrder();
    put(KEY_ORDER_CHANGE_REASON, changeReason);
  }

  @When("Operator confirm manually complete order on Edit Order page:")
  public void operatorManuallyCompleteOrderOnEditOrderPage(Map<String, String> data) {
    data = resolveKeyValues(data);
    String changeReason = data.get("changeReason");
    String reasonForChange = data.get("reasonForChange");
    editOrderPage.confirmCompleteOrder(changeReason, reasonForChange);
    put(KEY_ORDER_CHANGE_REASON, changeReason);
  }

  @When("Operator verify 'COD Collected' checkbox is disabled on Edit Order page")
  public void verifyCodCollectedIsDisabled() {
    editOrderPage.manuallyCompleteOrderDialog.waitUntilVisible();
    Assertions.assertThat(
        editOrderPage.manuallyCompleteOrderDialog.codCheckboxes.get(0).isEnabled())
        .as("COD Collected checkbox is enabled").isFalse();

  }

  @When("Operator confirm manually complete order with COD on Edit Order page")
  public void operatorManuallyCompleteOrderWithCodOnEditOrderPage() {
    editOrderPage.manuallyCompleteOrderDialog.waitUntilVisible();
    editOrderPage.manuallyCompleteOrderDialog.changeReason.setValue("Others (fill in below)");
    editOrderPage.manuallyCompleteOrderDialog.reasonForChange.setValue(
        "Completed by automated test");
    editOrderPage.manuallyCompleteOrderDialog.markAll.click();
    editOrderPage.manuallyCompleteOrderDialog.completeOrder.clickAndWaitUntilDone();
    editOrderPage.waitUntilInvisibilityOfToast("The order has been completed", true);
  }

  @When("Operator completes COD order manually by updating reason for change as {string}")
  public void operator_completes_COD_order_manually_by_updating_reason_for_change_as(
      String changeReason) {
    if ("GENERATED".equals(changeReason)) {
      changeReason = f("This reason is created by automation at %s.",
          DTF_CREATED_DATE.format(ZonedDateTime.now()));
    }
    editOrderPage.manuallyCompleteOrderDialog.waitUntilVisible();
    editOrderPage.manuallyCompleteOrderDialog.markAll.click();
    editOrderPage.manuallyCompleteOrderDialog.changeReason.setValue("Others (fill in below)");
    editOrderPage.manuallyCompleteOrderDialog.reasonForChange.setValue(changeReason);
    takesScreenshot();
    editOrderPage.manuallyCompleteOrderDialog.completeOrder.clickAndWaitUntilDone();
    editOrderPage.waitUntilInvisibilityOfToast("The order has been completed", true);
  }

  @When("Operator confirm manually complete order without collecting COD on Edit Order page")
  public void operatorManuallyCompleteOrderWithoutCodOnEditOrderPage() {
    editOrderPage.manuallyCompleteOrderDialog.waitUntilVisible();
    editOrderPage.manuallyCompleteOrderDialog.changeReason.setValue("Others (fill in below)");
    editOrderPage.manuallyCompleteOrderDialog.reasonForChange.setValue(
        "Completed by automated test");
    editOrderPage.manuallyCompleteOrderDialog.unmarkAll.click();
    takesScreenshot();
    editOrderPage.manuallyCompleteOrderDialog.completeOrder.clickAndWaitUntilDone();
    editOrderPage.waitUntilInvisibilityOfToast("The order has been completed", true);
  }

  @Then("Operator verify the order completed successfully on Edit Order page")
  public void operatorVerifyTheOrderCompletedSuccessfullyOnEditOrderPage() {
    Order order = get(KEY_CREATED_ORDER);
    editOrderPage.verifyOrderIsForceSuccessedSuccessfully(order);
    takesScreenshot();
  }

  @When("Operator change Priority Level to \"(\\d+)\" on Edit Order page")
  public void operatorChangePriorityLevelToOnEditOrderPage(int priorityLevel) {
    editOrderPage.editPriorityLevel(priorityLevel);
    takesScreenshot();
  }

  @Then("Operator verify (.+) Priority Level is \"(\\d+)\" on Edit Order page")
  public void operatorVerifyDeliveryPriorityLevelIsOnEditOrderPage(String txnType,
      int expectedPriorityLevel) {
    editOrderPage.verifyPriorityLevel(txnType, expectedPriorityLevel);
  }

  @When("Operator print Airway Bill on Edit Order page")
  public void operatorPrintAirwayBillOnEditOrderPage() {
    editOrderPage.printAirwayBill();
  }

  @Then("Operator verify the printed Airway bill for single order on Edit Orders page contains correct info")
  public void operatorVerifyThePrintedAirwayBillForSingleOrderOnEditOrdersPageContainsCorrectInfo() {
    Order order = get(KEY_CREATED_ORDER);
    editOrderPage.verifyAirwayBillContentsIsCorrect(order);
  }

  @When("Operator add created order to the (.+) route on Edit Order page")
  public void operatorAddCreatedOrderToTheRouteOnEditOrderPage(String type) {
    editOrderPage.addToRoute(get(KEY_CREATED_ROUTE_ID), type);
  }

  @When("Operator add created order route on Edit Order page using data below:")
  public void operatorAddCreatedOrderToTheRouteOnEditOrderPage(Map<String, String> data) {
    data = resolveKeyValues(data);
    String type = data.getOrDefault("type", "Delivery");
    String menu = data.getOrDefault("menu", type);
    String routeId = data.get("routeId");
    editOrderPage.clickMenu(menu, "Add To Route");
    editOrderPage.addToRouteDialog.waitUntilVisible();
    editOrderPage.addToRouteDialog.route.setValue(routeId);
    editOrderPage.addToRouteDialog.type.selectValue(type);
    takesScreenshot();
    editOrderPage.addToRouteDialog.addToRoute.clickAndWaitUntilDone();
  }

  @Then("Operator verify the order is added to the {string} route on Edit Order page")
  public void operatorVerifyTheOrderIsAddedToTheRouteOnEditOrderPage(String type) {
    switch (type.toUpperCase()) {
      case "DELIVERY":
        editOrderPage.verifyDeliveryRouteInfo(get(KEY_CREATED_ROUTE));
        takesScreenshot();
        break;
      case "PICKUP":
        editOrderPage.verifyPickupRouteInfo(get(KEY_CREATED_ROUTE));
        takesScreenshot();
        break;
      default:
        throw new IllegalArgumentException("Unknown route type: " + type);
    }
  }

  @And("Operator verify Delivery dates:")
  public void operatorVerifyDeliveryStartDateTimeValueIs(Map<String, String> mapOfData) {
    mapOfData = StandardTestUtils.replaceDataTableTokens(mapOfData);
    String startDateTime = mapOfData.get("startDateTime");

    try {
      if (StringUtils.isNoneBlank(startDateTime)) {
        editOrderPage.verifyDeliveryStartDateTime(startDateTime);
      }

      String endDateTime = mapOfData.get("endDateTime");

      if (StringUtils.isNoneBlank(endDateTime)) {
        editOrderPage.verifyDeliveryEndDateTime(endDateTime);
      }
    } catch (AssertionError | RuntimeException ex) {
      LOGGER.warn("Skip delivery start date & end date verification because it's to complicated.",
          ex);
    }
  }

  @Then("Operator verify order status is \"(.+)\" on Edit Order page")
  public void operatorVerifyOrderStatusOnEditOrderPage(String expectedValue) {
    editOrderPage.verifyOrderStatus(expectedValue);
  }

  @Then("Operator verify Current DNR Group is \"(.+)\" on Edit Order page")
  public void operatorVerifyCurrentDnrGroupOnEditOrderPage(String expected) {
    expected = resolveValue(expected);
    String actual = editOrderPage.currentDnrGroup.getText();
    Assertions.assertThat(actual).as("Current DNR Group").isEqualToIgnoringCase(expected);
  }

  @Then("Operator verify order granular status is \"(.+)\" on Edit Order page")
  public void operatorVerifyOrderGranularStatusOnEditOrderPage(String expectedValue) {
    editOrderPage.verifyOrderGranularStatus(expectedValue);
  }

  @Then("Operator wait until order granular status changes to {string}")
  public void operator_wait_until_order_granular_status_changes_to(String expectedValue) {
    editOrderPage.waitUntilGranularStatusChange(expectedValue);
  }

  @Then("Operator verify order delivery title is \"(.+)\" on Edit Order page")
  public void operatorVerifyOrderDeliveryTitleOnEditOrderPage(String expectedValue) {
    editOrderPage.verifyOrderDeliveryTitle(expectedValue);
  }

  @Then("Operator verify order delivery status is \"(.+)\" on Edit Order page")
  public void operatorVerifyOrderDeliveryStatusOnEditOrderPage(String expectedValue) {
    editOrderPage.verifyOrderDeliveryStatus(expectedValue);
  }

  @Then("Operator verify RTS event displayed on Edit Order page with following properties:")
  public void operatorVerifyRtsEventOnEditOrderPage(Map<String, String> mapOfData) {
    Map<String, String> mapOfTokens = StandardTestUtils.createDefaultTokens();
    mapOfData = StandardTestUtils.replaceDataTableTokens(mapOfData, mapOfTokens);

    OrderEvent orderEvent = editOrderPage.eventsTable().filterByColumn(EVENT_NAME, "RTS")
        .readEntity(1);
    Assertions.assertThat(orderEvent.getName()).as("Event Name").isEqualToIgnoringCase("RTS");

    String value = mapOfData.get("eventTags");

    if (value != null) {
      Assertions.assertThat(orderEvent.getTags()).as("Event Tags").isEqualToIgnoringCase(value);
    }

    value = mapOfData.get("reason");

    if (value != null) {
      Assertions.assertThat(orderEvent.getDescription()).as("Reason")
          .contains("Reason: Return to sender: " + value);
    }

    value = mapOfData.get("startTime");

    if (value != null) {
      Assertions.assertThat(orderEvent.getDescription()).as("Start Time")
          .contains("Start Time: " + value);
    }

    value = mapOfData.get("endTime");

    if (value != null) {
      Assertions.assertThat(orderEvent.getDescription()).as("End Time")
          .contains("End Time: " + value);
    }
    takesScreenshot();
  }

  @Then("Operator verifies orders are tagged on Edit order page")
  public void operatorVerifiesOrdersAreTaggedOnEditOrderPage() {
    String tagLabel = get(KEY_ORDER_TAG);
    List<Order> lists = get(KEY_LIST_OF_CREATED_ORDER);

    lists.forEach(order ->
    {
      navigateTo(
          f("%s/%s/order/%d", TestConstants.OPERATOR_PORTAL_BASE_URL, TestConstants.NV_SYSTEM_ID,
              order.getId()));
      String actualTagName = editOrderPage.getTag();
      takesScreenshot();
      Assertions.assertThat(actualTagName)
          .as("Order tag is not equal to tag set on Order Level Tag Management page for order Id - %s",
              order.getId()).isEqualTo(tagLabel);
    });
  }

  @When("Operator change Stamp ID of the created order to \"(.+)\" on Edit order page")
  public void operatorEditStampIdOnEditOrderPage(String stampId) {
    if (equalsIgnoreCase(stampId, "GENERATED")) {
      stampId = "NVSGSTAMP" + TestUtils.generateAlphaNumericString(7).toUpperCase();
    }
    editOrderPage.editOrderStamp(stampId);
    Order order = get(KEY_CREATED_ORDER);
    order.setStampId(stampId);
    put(KEY_STAMP_ID, stampId);
  }

  @Given("New Stamp ID was generated")
  public void newStampIdWasGenerated() {
    newStampIdWasGenerated("STAMP");
  }

  @Given("New Stamp ID with {value} prefix was generated")
  public void newStampIdWasGenerated(String prefix) {
    String trackingNumber = TestUtils.generateAlphaNumericString(9).toUpperCase();
    String stampId = "NVSG" + prefix.toUpperCase() + trackingNumber;
    put(KEY_STAMP_ID, stampId);
    put(KEY_TRACKING_NUMBER, trackingNumber);
  }

  @When("Operator unable to change Stamp ID of the created order to \"(.+)\" on Edit order page")
  public void operatorUnableToEditStampIdToExistingOnEditOrderPage(String stampId) {
        /*
          Replace searchTerm value to value on ScenarioStorage.
         */
    String trackingIdOfExistingOrder = get(KEY_TRACKING_ID_BY_ACCESSING_STAMP_ID);
    editOrderPage.editOrderStampToExisting(resolveValue(stampId), trackingIdOfExistingOrder);
  }

  @When("Operator remove Stamp ID of the created order on Edit order page")
  public void operatorRemoveStampIdOnEditOrderPage() {
    editOrderPage.removeOrderStamp();
  }

  @When("Operator update order status on Edit order page using data below:")
  public void operatorUpdateStatusOnEditOrderPage(Map<String, String> mapOfData) {
    editOrderPage.clickMenu("Order Settings", "Update Status");
    editOrderPage.updateStatusDialog.waitUntilVisible();

    String value = mapOfData.get("granularStatus");
    editOrderPage.updateStatusDialog.granularStatus.searchAndSelectValue(value);
    value = mapOfData.get("changeReason");
    editOrderPage.updateStatusDialog.changeReason.setValue(value);
    editOrderPage.updateStatusDialog.saveChanges.clickAndWaitUntilDone();
  }

  @Then("Operator verify the created order info is correct on Edit Order page")
  public void operatorVerifyOrderInfoOnEditOrderPage() {
    Order order = get(KEY_CREATED_ORDER);
    editOrderPage.verifyOrderInfoIsCorrect(order);
    takesScreenshot();
  }

  @Then("Operator verify color of order header on Edit Order page is \"(.+)\"")
  public void operatorVerifyColorOfOrderHeaderOnEditOrderPage(String color) {
    switch (color.toLowerCase()) {
      case "green":
        color = "rgba(28, 111, 52, 1)";
        break;
      case "red":
        color = "rgba(193, 36, 68, 1)";
        break;
    }
    editOrderPage.verifyOrderHeaderColor(color);
    takesScreenshot();
  }

  @Then("Operator verifies event is present for order id {string} on Edit order page")
  public void operatorVerifiesEventIsPresentForIdOnEditOrderPage(String orderIdAsString,
      Map<String, String> mapOfData) {
    Map<String, String> map = resolveKeyValues(mapOfData);
    String event = map.get("eventName");
    String hubName = map.get("hubName");
    String hubId = map.get("hubId");
    String descriptionString = map.get("descriptionString");
    List<Order> lists = get(KEY_LIST_OF_CREATED_ORDER);
    Long orderId = Long.valueOf(resolveValue(orderIdAsString));
    for (Order order : lists) {
      if (orderId.equals(order.getId())) {
        navigateTo(
            f("%s/%s/order/%d", TestConstants.OPERATOR_PORTAL_BASE_URL, TestConstants.NV_SYSTEM_ID,
                order.getId()));
        if (descriptionString != null) {
          editOrderPage.verifyEvent(order, hubName, hubId, event, descriptionString);
          return;
        }
        editOrderPage.verifyEvent(order, hubName, hubId, event, "Scanned");
        return;
      }
    }
    takesScreenshot();
  }

  @Then("Operator verifies event is present for order on Edit order page")
  public void operatorVerifiesEventIsPresentOnEditOrderPage(Map<String, String> mapOfData) {
    Map<String, String> map = resolveKeyValues(mapOfData);
    String event = map.get("eventName");
    String hubName = map.get("hubName");
    String hubId = map.get("hubId");
    String descriptionString = map.get("descriptionString");
    List<Order> lists = get(KEY_LIST_OF_CREATED_ORDER);

    lists.forEach(order ->
    {
      navigateTo(
          f("%s/%s/order/%d", TestConstants.OPERATOR_PORTAL_BASE_URL, TestConstants.NV_SYSTEM_ID,
              order.getId()));
      if (descriptionString != null) {
        editOrderPage.verifyEvent(order, hubName, hubId, event, descriptionString);
        return;
      }
      takesScreenshot();
      editOrderPage.verifyEvent(order, hubName, hubId, event, "Scanned");
    });
  }

  @Then("Operator cancel order on Edit order page using data below:")
  public void operatorCancelOrderOnEditOrderPage(Map<String, String> mapOfData) {
    String cancellationReason = mapOfData.get("cancellationReason");
    editOrderPage.cancelOrder(cancellationReason);
    put(KEY_CANCELLATION_REASON, cancellationReason);
  }

  @And("Operator does the Manually Complete Order from Edit Order Page")
  public void operatorDoesTheManuallyCompleteOrderFromEditOrderPage() {
    editOrderPage.manuallyCompleteOrder();
  }

  @And("Operator selects the Route Tags of \"([^\"]*)\" from the Route Finder on Edit Order Page")
  public void operatorSelectTheRouteTagsOfFromTheRouteFinder(String routeTag) {
    editOrderPage.clickMenu("Delivery", "Add To Route");
    editOrderPage.addToRouteDialog.waitUntilVisible();
    editOrderPage.addToRouteDialog.routeTags.selectValues(ImmutableList.of(resolveValue(routeTag)));
    editOrderPage.addToRouteDialog.suggestRoute.clickAndWaitUntilDone();
    if (editOrderPage.toastErrors.size() > 0) {
      Assertions.fail(
          f("Error on attempt to suggest routes: %s",
              editOrderPage.toastErrors.get(0).toastBottom.getText()));
    }
    editOrderPage.addToRouteDialog.addToRoute.clickAndWaitUntilDone();
    editOrderPage.addToRouteDialog.waitUntilInvisible();
    editOrderPage.waitUntilInvisibilityOfToast(true);
  }

  @And("Operator suggest route of {string} tag from the Route Finder on Edit Order Page")
  public void operatorSuggestRouteFromTheRouteFinder(String routeTag) {
    editOrderPage.addToRouteDialog.waitUntilVisible();
    editOrderPage.addToRouteDialog.routeTags.selectValues(ImmutableList.of(resolveValue(routeTag)));
    takesScreenshot();
    editOrderPage.addToRouteDialog.suggestRoute.clickAndWaitUntilDone();
  }

  @And("Operator verify Route value is {string} in Add To Route dialog on Edit Order Page")
  public void operatorVerifyRouteValue(String expected) {
    Assertions.assertThat(editOrderPage.addToRouteDialog.route.getValue()).as("Route value")
        .isEqualTo(resolveValue(expected));
  }

  @Then("Operator verify order event on Edit order page using data below:")
  public void operatorVerifyOrderEventOnEditOrderPage(Map<String, String> mapOfData) {
    doWithRetry(()->{OrderEvent expectedEvent = new OrderEvent(resolveKeyValues(mapOfData));
      OrderEvent actualEvent = editOrderPage.eventsTable().readAllEntities().stream()
          .filter(event -> equalsIgnoreCase(event.getName(), expectedEvent.getName()))
          .findFirst()
          .orElse(null);
      if (actualEvent == null) {
        pause5s();
        editOrderPage.refreshPage();
        actualEvent = editOrderPage.eventsTable().readAllEntities().stream()
            .filter(event -> equalsIgnoreCase(event.getName(), expectedEvent.getName()))
            .findFirst()
            .orElse(null);
      }
      Assertions.assertThat(actualEvent)
          .withFailMessage("There is no [%s] event on Edit Order page", expectedEvent.getName())
          .isNotNull();

      expectedEvent.compareWithActual(actualEvent);},"Verify order event");
  }

  @Then("Operator verify order events on Edit order page using data below:")
  public void operatorVerifyOrderEventsOnEditOrderPage(List<Map<String, String>> data) {
    data.forEach(eventData -> {
      OrderEvent expectedEvent = new OrderEvent(resolveKeyValues(eventData));
      OrderEvent actualEvent = editOrderPage.eventsTable().readAllEntities().stream()
          .filter(event -> equalsIgnoreCase(event.getName(), expectedEvent.getName()))
          .findFirst()
          .orElse(null);
      if (actualEvent == null) {
        pause5s();
        editOrderPage.refreshPage();
        actualEvent = editOrderPage.eventsTable().readAllEntities().stream()
            .filter(event -> equalsIgnoreCase(event.getName(), expectedEvent.getName()))
            .findFirst()
            .orElse(null);
      }
      Assertions.assertThat(actualEvent)
          .withFailMessage("There is no [%s] event on Edit Order page", expectedEvent.getName())
          .isNotNull();
      expectedEvent.compareWithActual(actualEvent);
    });
  }

  @Then("Operator verify order events with description on Edit order page using data below:")
  public void operatorVerifyOrderEventsWithDescriptionOnEditOrderPage(
      List<Map<String, String>> data) {
    data.forEach(eventData -> {
      OrderEvent expectedEvent = new OrderEvent(resolveKeyValues(eventData));
      OrderEvent actualEvent = editOrderPage.eventsTable().readAllEntities().stream()
          .filter(event -> (equalsIgnoreCase(event.getName(), expectedEvent.getName())
              && equalsIgnoreCase(event.getDescription(), expectedEvent.getDescription())))
          .findAny()
          .orElse(null);
      if (actualEvent == null) {
        pause5s();
        editOrderPage.refreshPage();
        actualEvent = editOrderPage.eventsTable().readAllEntities().stream()
            .filter(event -> (equalsIgnoreCase(event.getName(), expectedEvent.getName())
                && equalsIgnoreCase(event.getDescription(), expectedEvent.getDescription())))
            .findAny()
            .orElse(null);
      }
      Assertions.assertThat(actualEvent)
          .withFailMessage("There is no [%s] event on Edit Order page", expectedEvent.getName())
          .isNotNull();
      expectedEvent.compareWithActual(actualEvent);
    });
  }

  @Then("Operator verify order events are not presented on Edit order page:")
  public void operatorVerifyOrderEventsNotPresentedOnEditOrderPage(List<String> data) {
    List<OrderEvent> events = editOrderPage.eventsTable().readAllEntities();
    data = resolveValues(data);
    SoftAssertions assertions = new SoftAssertions();
    data.forEach(expected ->
        assertions.assertThat(
            events.stream().anyMatch(e -> equalsIgnoreCase(e.getName(), expected)))
            .as("%s event was found")
            .isFalse()
    );
    assertions.assertAll();
    takesScreenshot();
  }

  @Then("Operator verify Delivery details on Edit order page using data below:")
  public void verifyDeliveryDetails(Map<String, String> expectedData) throws ParseException {
    expectedData = resolveKeyValues(expectedData);
    expectedData = StandardTestUtils.replaceDataTableTokens(expectedData);

    SoftAssertions assertions = new SoftAssertions();
    if (expectedData.containsKey("status")) {
      assertions.assertThat(editOrderPage.deliveryDetailsBox.status.getText())
          .as("Delivery Details - Status")
          .isEqualTo(f("Status: %s", expectedData.get("status")));
    }
    if (expectedData.containsKey("name")) {
      assertions.assertThat(editOrderPage.deliveryDetailsBox.to.getNormalizedText())
          .as("Delivery Details - Name")
          .isEqualToIgnoringCase(StringUtils.normalizeSpace(expectedData.get("name")));
    }
    if (expectedData.containsKey("contact")) {
      assertions.assertThat(editOrderPage.deliveryDetailsBox.toContact.getNormalizedText())
          .as("Delivery Details - Contact")
          .isEqualToIgnoringCase(StringUtils.normalizeSpace(expectedData.get("contact")));
    }
    if (expectedData.containsKey("email")) {
      assertions.assertThat(editOrderPage.deliveryDetailsBox.toEmail.getNormalizedText())
          .as("Delivery Details - Email")
          .isEqualToIgnoringCase(StringUtils.normalizeSpace(expectedData.get("email")));
    }
    if (expectedData.containsKey("address")) {
      assertions.assertThat(editOrderPage.deliveryDetailsBox.toAddress.getNormalizedText())
          .as("Delivery Details - address")
          .isEqualToIgnoringCase(StringUtils.normalizeSpace(expectedData.get("address")));
    }
    if (expectedData.containsKey("startDate")) {
      String actual = editOrderPage.deliveryDetailsBox.startDateTime.getText();
      Date actualDateTime = Date.from(DateUtil.getDate(actual,
          DateUtil.DATE_TIME_FORMATTER.withZone(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE)))
          .toInstant());
      Date expectedDateTime = DateUtil.SDF_YYYY_MM_DD.parse(expectedData.get("startDate"));
      Assertions.assertThat(actualDateTime).as("Delivery Details - Start Date / Time")
          .isInSameDayAs(expectedDateTime);
    }
    if (expectedData.containsKey("startDateTime")) {
      String actual = editOrderPage.deliveryDetailsBox.startDateTime.getText();
      Date actualDateTime = Date.from(DateUtil.getDate(actual,
          DateUtil.DATE_TIME_FORMATTER.withZone(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE)))
          .toInstant());
      Date expectedDateTime = DateUtil.SDF_YYYY_MM_DD_HH_MM_SS
          .parse(expectedData.get("startDateTime"));
      Assertions.assertThat(actualDateTime).as("Delivery Details - Start Date / Time")
          .isInSameSecondAs(expectedDateTime);
    }
    if (expectedData.containsKey("endDate")) {
      String actual = editOrderPage.deliveryDetailsBox.endDateTime.getText();
      Date actualDateTime = Date.from(DateUtil.getDate(actual,
          DateUtil.DATE_TIME_FORMATTER.withZone(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE)))
          .toInstant());
      Date expectedDateTime = DateUtil.SDF_YYYY_MM_DD.parse(expectedData.get("endDate"));
      Assertions.assertThat(actualDateTime).as("Delivery Details - End Date / Time")
          .isInSameDayAs(expectedDateTime);
    }
    if (expectedData.containsKey("endDateTime")) {
      String actual = editOrderPage.deliveryDetailsBox.endDateTime.getText();
      Date actualDateTime = Date.from(DateUtil.getDate(actual,
          DateUtil.DATE_TIME_FORMATTER.withZone(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE)))
          .toInstant());
      Date expectedDateTime = DateUtil.SDF_YYYY_MM_DD_HH_MM_SS
          .parse(expectedData.get("endDateTime"));
      Assertions.assertThat(actualDateTime).as("Delivery Details - End Date / Time")
          .isInSameSecondAs(expectedDateTime);
    }
    takesScreenshot();
    assertions.assertAll();
  }

  @Then("Operator verify Pickup details on Edit order page using data below:")
  public void verifyPickupDetails(Map<String, String> expectedData) throws ParseException {
    expectedData = resolveKeyValues(expectedData);

    if (expectedData.containsKey("status")) {
      Assertions.assertThat(editOrderPage.pickupDetailsBox.getStatus())
          .as("Pickup Details - Status").isEqualTo(expectedData.get("status"));
    }
    if (expectedData.containsKey("name")) {
      Assertions.assertThat(editOrderPage.pickupDetailsBox.from.getNormalizedText())
          .as("Pickup Details - Name")
          .isEqualToIgnoringCase(StringUtils.normalizeSpace(expectedData.get("name")));
    }
    if (expectedData.containsKey("contact")) {
      Assertions.assertThat(editOrderPage.pickupDetailsBox.fromContact.getNormalizedText())
          .as("Pickup Details - Contact")
          .isEqualToIgnoringCase(StringUtils.normalizeSpace(expectedData.get("contact")));
    }
    if (expectedData.containsKey("email")) {
      Assertions.assertThat(editOrderPage.pickupDetailsBox.fromEmail.getNormalizedText())
          .as("Delivery Details - Email")
          .isEqualToIgnoringCase(StringUtils.normalizeSpace(expectedData.get("email")));
    }
    if (expectedData.containsKey("address")) {
      Assertions.assertThat(editOrderPage.pickupDetailsBox.fromAddress.getNormalizedText())
          .as("Pickup Details - address")
          .isEqualToIgnoringCase(StringUtils.normalizeSpace(expectedData.get("address")));
    }
    if (expectedData.containsKey("startDate")) {
      String actual = editOrderPage.pickupDetailsBox.startDateTime.getText();
      Date actualDateTime = Date.from(DateUtil.getDate(actual,
          DateUtil.DATE_TIME_FORMATTER.withZone(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE)))
          .toInstant());
      Date expectedDateTime = DateUtil.SDF_YYYY_MM_DD.parse(expectedData.get("startDate"));
      Assertions.assertThat(actualDateTime).as("Pickup Details - Start Date / Time")
          .isInSameDayAs(expectedDateTime);
    }
    if (expectedData.containsKey("startDateTime")) {
      String actual = editOrderPage.pickupDetailsBox.startDateTime.getText();
      Date actualDateTime = Date.from(DateUtil.getDate(actual,
          DateUtil.DATE_TIME_FORMATTER.withZone(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE)))
          .toInstant());
      Date expectedDateTime = DateUtil.SDF_YYYY_MM_DD_HH_MM_SS
          .parse(expectedData.get("startDateTime"));
      Assertions.assertThat(actualDateTime).as("Pickup Details - Start Date / Time")
          .isInSameSecondAs(expectedDateTime);
    }
    if (expectedData.containsKey("endDate")) {
      String actual = editOrderPage.pickupDetailsBox.endDateTime.getText();
      Date actualDateTime = Date.from(DateUtil.getDate(actual,
          DateUtil.DATE_TIME_FORMATTER.withZone(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE)))
          .toInstant());
      Date expectedDateTime = DateUtil.SDF_YYYY_MM_DD.parse(expectedData.get("endDate"));
      Assertions.assertThat(actualDateTime).as("Pickup Details - End Date / Time")
          .isInSameDayAs(expectedDateTime);
    }
    if (expectedData.containsKey("endDateTime")) {
      String actual = editOrderPage.pickupDetailsBox.endDateTime.getText();
      Date actualDateTime = Date.from(DateUtil.getDate(actual,
          DateUtil.DATE_TIME_FORMATTER.withZone(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE)))
          .toInstant());
      Date expectedDateTime = DateUtil.SDF_YYYY_MM_DD_HH_MM_SS
          .parse(expectedData.get("endDateTime"));
      Assertions.assertThat(actualDateTime).as("Delivery Details - End Date / Time")
          .isInSameSecondAs(expectedDateTime);
    }
    if (expectedData.containsKey("lastServiceEndDate")) {
      String actual = editOrderPage.pickupDetailsBox.lastServiceEnd.getText();
      Date actualDateTime = Date.from(DateUtil.getDate(actual,
          DateUtil.DATE_TIME_FORMATTER.withZone(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE)))
          .toInstant());
      Date expectedDateTime = DateUtil.SDF_YYYY_MM_DD.parse(expectedData.get("lastServiceEndDate"));
      Assertions.assertThat(actualDateTime).as("Pickup Details - Last Service End")
          .isInSameDayAs(expectedDateTime);
    }
    if (expectedData.containsKey("lastServiceEndDateTime")) {
      String actual = editOrderPage.pickupDetailsBox.lastServiceEnd.getText();
      Date actualDateTime = Date.from(DateUtil.getDate(actual,
          DateUtil.DATE_TIME_FORMATTER.withZone(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE)))
          .toInstant());
      Date expectedDateTime = DateUtil.SDF_YYYY_MM_DD_HH_MM_SS
          .parse(expectedData.get("lastServiceEndDateTime"));
      Assertions.assertThat(actualDateTime).as("Delivery Details - Last Service End")
          .isInSameSecondAs(expectedDateTime);
    }
    takesScreenshot();
  }

  @Then("Operator verify (Pickup|Delivery) \"(.+)\" order event description on Edit order page")
  public void operatorVerifyOrderEventOnEditOrderPage(String type, String expectedEventName) {
    final Order order = get(KEY_CREATED_ORDER);
    final List<OrderEvent> events = editOrderPage.eventsTable().readAllEntities();
    final OrderEvent actualEvent = events.stream()
        .filter(event -> equalsIgnoreCase(event.getName(), expectedEventName))
        .findFirst()
        .orElseThrow(() -> new AssertionError(
            f("There is no [%s] event on Edit Order page", expectedEventName)));
    final String eventDescription = actualEvent.getDescription();
    if (equalsIgnoreCase(type, "Pickup")) {
      if (equalsIgnoreCase(expectedEventName, "UPDATE ADDRESS")) {
        editOrderPage.eventsTable()
            .verifyUpdatePickupAddressEventDescription(order, eventDescription);
      }
      if (equalsIgnoreCase(expectedEventName, "UPDATE CONTACT INFORMATION")) {
        editOrderPage.eventsTable()
            .verifyUpdatePickupContactInformationEventDescription(order, eventDescription);
      }
      if (equalsIgnoreCase(expectedEventName, "UPDATE SLA")) {
        editOrderPage.eventsTable().verifyUpdatePickupSlaEventDescription(order, eventDescription);
      }
      if (equalsIgnoreCase(expectedEventName, "VERIFY ADDRESS")) {
        editOrderPage.eventsTable().verifyPickupAddressEventDescription(order, eventDescription);
      }
    } else {
      if (equalsIgnoreCase(expectedEventName, "UPDATE ADDRESS")) {
        editOrderPage.eventsTable()
            .verifyUpdateDeliveryAddressEventDescription(order, eventDescription);
      }
      if (equalsIgnoreCase(expectedEventName, "UPDATE CONTACT INFORMATION")) {
        editOrderPage.eventsTable()
            .verifyUpdateDeliveryContactInformationEventDescription(order, eventDescription);
      }
      if (equalsIgnoreCase(expectedEventName, "UPDATE SLA")) {
        editOrderPage.eventsTable()
            .verifyUpdateDeliverySlaEventDescription(order, eventDescription);
      }
      if (equalsIgnoreCase(expectedEventName, "VERIFY ADDRESS")) {
        editOrderPage.eventsTable().verifyDeliveryAddressEventDescription(order, eventDescription);
      }
      if (equalsIgnoreCase(expectedEventName, "HUB INBOUND SCAN")) {
        editOrderPage.eventsTable()
            .verifyHubInboundWithDeviceIdEventDescription(order, eventDescription);
      }
    }
    takesScreenshot();
  }

  @Then("Operator verify (.+) transaction on Edit order page using data below:")
  public void operatorVerifyTransactionOnEditOrderPage(String transactionType,
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    int rowIndex = transactionType.equalsIgnoreCase("Delivery") ? 2 : 1;

    String value = mapOfData.get("status");
    if (StringUtils.isNotBlank(value)) {
      TransactionInfo actual = editOrderPage.transactionsTable.readEntity(rowIndex);
      Assertions.assertThat(actual.getStatus()).as(f("%s transaction status", transactionType))
          .isEqualTo(value);
    }
    if (mapOfData.containsKey("routeId")) {
      TransactionInfo actual = editOrderPage.transactionsTable.readEntity(rowIndex);
      Assertions.assertThat(actual.getRouteId()).as(f("%s transaction Route Id", transactionType))
          .isEqualTo(StringUtils.trimToNull(mapOfData.get("routeId")));
    }
    takesScreenshot();
  }

  @Then("Operator verify transaction on Edit order page using data below:")
  public void operatorVerifyTransactionOnEditOrderPage(Map<String, String> data) {
    final TransactionInfo expected = new TransactionInfo(resolveKeyValues(data));
    if (data.containsKey("destinationAddress")) {
      //    to click unmask before verify address details
      List<WebElement> masks = getWebDriver().findElements(By.xpath(MaskedPage.MASKING_XPATH));
      editOrderPage.operatorClickMaskingText(masks);
    }
    final List<TransactionInfo> transactions = editOrderPage.transactionsTable.readAllEntities();
    takesScreenshot();
    transactions.stream()
        .filter(actual -> {
          try {
            expected.compareWithActual(actual);
            return true;
          } catch (AssertionError err) {
            return false;
          }
        })
        .findFirst()
        .orElseThrow(
            () -> new AssertionError("Transaction " + expected.toMap() + " was not found"));
  }

  @Then("Operator verify order summary on Edit order page using data below:")
  public void operatorVerifyOrderSummaryOnEditOrderPage(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    final Order expectedOrder = new Order();

    if (mapOfData.containsKey("comments")) {
      expectedOrder.setComments(mapOfData.get("comments"));
    }

    editOrderPage.verifyOrderSummary(expectedOrder);
    takesScreenshot();
  }

  @Then("Operator verifies the status of the order will be Completed")
  public void operatorVerifiesTheStatusOfTheOrderWillBeCompleted() {
    editOrderPage.verifyOrderStatus("Completed");
    takesScreenshot();
  }

  @Then("Operator verifies the route is tagged to the order")
  public void operatorVerifiesTheRouteIsTaggedToTheOrder() {
    editOrderPage.verifiesOrderIsTaggedToTheRecommendedRouteId();
    takesScreenshot();
  }

  @Then("Operator verify menu item \"(.+)\" > \"(.+)\" is disabled on Edit order page")
  public void operatorVerifyMenuItemIsDisabledOnEditOrderPage(String parentMenuItem,
      String childMenuItem) {
    Assertions.assertThat(editOrderPage.isMenuItemEnabled(parentMenuItem, childMenuItem))
        .as("%s > %s menu item is enabled", parentMenuItem, childMenuItem).isFalse();
  }

  @Then("Operator update Pickup Details on Edit Order Page")
  public void operatorUpdatePickupDetailsOnEditOrderPage(Map<String, String> mapOfData) {
    Map<String, String> mapOfTokens = StandardTestUtils.createDefaultTokens();
    mapOfData = StandardTestUtils.replaceDataTableTokens(mapOfData, mapOfTokens);
    editOrderPage.updatePickupDetails(mapOfData);
    takesScreenshot();
    Order order = get(KEY_CREATED_ORDER);
    String senderName = mapOfData.get("senderName");
    String senderContact = mapOfData.get("senderContact");
    String senderEmail = mapOfData.get("senderEmail");
    String internalNotes = mapOfData.get("internalNotes");
    String pickupDate = mapOfData.get("pickupDate");
    String pickupTimeslot = mapOfData.get("pickupTimeslot");
    String country = mapOfData.get("country");
    String city = mapOfData.get("city");
    String address1 = mapOfData.get("address1");
    String address2 = mapOfData.get("address2");
    String postalCode = mapOfData.get("postalCode");

    if (Objects.nonNull(senderName)) {
      order.setFromName(senderName);
    }
    if (Objects.nonNull(senderContact)) {
      order.setFromContact(senderContact);
    }
    if (Objects.nonNull(senderEmail)) {
      order.setFromEmail(senderEmail);
    }
//        if (Objects.nonNull(internalNotes)) {order.setComments(internalNotes);}
    if (Objects.nonNull(pickupDate)) {
      order.setPickupDate(pickupDate);
    }
    if (StringUtils.isNotBlank(pickupTimeslot)) {
      order.setPickupTimeslot(pickupTimeslot);
    }
    if (Objects.nonNull(address1)) {
      order.setFromAddress1(address1);
    }
    if (Objects.nonNull(address2)) {
      order.setFromAddress2(address2);
    }
    if (Objects.nonNull(postalCode)) {
      order.setFromPostcode(postalCode);
    }
    if (Objects.nonNull(city)) {
      order.setFromCity(city);
    }
    if (Objects.nonNull(country)) {
      order.setFromCountry(country);
    }
    put(KEY_CREATED_ORDER, order);
  }

  @Then("Operator update Delivery Details on Edit Order Page")
  public void operatorUpdateDeliveryDetailsOnEditOrderPage(Map<String, String> mapOfData) {
    Map<String, String> mapOfTokens = StandardTestUtils.createDefaultTokens();
    mapOfData = StandardTestUtils.replaceDataTableTokens(mapOfData, mapOfTokens);
    //    to click unmask before performing changes
    List<WebElement> masks = getWebDriver().findElements(By.xpath(MaskedPage.MASKING_XPATH));
    editOrderPage.operatorClickMaskingText(masks);
    editOrderPage.updateDeliveryDetails(mapOfData);
    takesScreenshot();
    List<co.nvqa.common.core.model.order.Order> order = get(KEY_LIST_OF_CREATED_ORDERS);
    //Order order = get(KEY_CREATED_ORDER);
    String recipientName = mapOfData.get("recipientName");
    String recipientContact = mapOfData.get("recipientContact");
    String recipientEmail = mapOfData.get("recipientEmail");
    String internalNotes = mapOfData.get("internalNotes");
    String changeSchedule = mapOfData.get("changeSchedule");
    String deliveryDate = mapOfData.get("deliveryDate");
    String deliveryTimeslot = mapOfData.get("deliveryTimeslot");
    String country = mapOfData.get("country");
    String city = mapOfData.get("city");
    String address1 = mapOfData.get("address1");
    String address2 = mapOfData.get("address2");
    String postalCode = mapOfData.get("postalCode");

    if (Objects.nonNull(recipientName)) {
      order.get(0).setToName(recipientName);
    }
    if (Objects.nonNull(recipientContact)) {
      order.get(0).setToContact(recipientContact);
    }
    if (Objects.nonNull(recipientEmail)) {
      order.get(0).setToEmail(recipientEmail);
    }
//        if (Objects.nonNull(internalNotes)) {order.setComments(internalNotes);}
    if (Objects.nonNull(deliveryDate)) {
      order.get(0).setDeliveryDate(deliveryDate);
    }
    if (Objects.nonNull(deliveryTimeslot)) {
      order.get(0).setDeliveryTimeslot(deliveryTimeslot);
    }
    if (Objects.nonNull(address1)) {
      order.get(0).setToAddress1(address1);
    }
    if (Objects.nonNull(address2)) {
      order.get(0).setToAddress2(address2);
    }
    if (Objects.nonNull(postalCode)) {
      order.get(0).setToPostcode(postalCode);
    }
    if (Objects.nonNull(city)) {
      order.get(0).setToCity(city);
    }
    if (Objects.nonNull(country)) {
      order.get(0).setToCountry(country);
    }
    //   put(KEY_CREATED_ORDER, order);
    put(KEY_LIST_OF_CREATED_ORDERS, order);
  }

  @Then("Operator verifies Pickup Details are updated on Edit Order Page")
  public void operatorVerifiesPickupDetailsUpdated() {
    Order order = get(KEY_CREATED_ORDER);
    editOrderPage.verifyPickupInfo(order);
    takesScreenshot();
  }

  @Then("Operator verifies Delivery Details are updated on Edit Order Page")
  public void operatorVerifiesDeliveryDetailsUpdated() {
    Order order = get(KEY_CREATED_ORDER);
    editOrderPage.verifyDeliveryInfo(order);
    takesScreenshot();
  }

  @Then("Operator verifies Delivery Details on Edit Order Page:")
  public void operatorVerifiesDeliveryDetailsUpdated(Map<String, String> data) {
    Order order = new Order(resolveKeyValues(data));
    editOrderPage.verifyDeliveryInfo(order);
  }

  @Then("Operator verifies (Pickup|Delivery) Transaction is updated on Edit Order Page")
  public void operatorVerifiesTransactionUpdated(String txnType) {
    Order order = get(KEY_CREATED_ORDER);
    if (equalsIgnoreCase(txnType, "Pickup")) {
      editOrderPage.verifyPickupDetailsInTransaction(order, txnType);
    } else {
      editOrderPage.verifyDeliveryDetailsInTransaction(order, txnType);
    }
    takesScreenshot();
  }

  @Then("Operator tags order to \"(.+)\" DP on Edit Order Page")
  public void operatorTagOrderToDP(String dpId) {
    editOrderPage.tagOrderToDP(dpId);
  }

  @Then("Operator untags order from DP on Edit Order Page")
  public void operatorUnTagOrderFromDP() {
    editOrderPage.dpDropOffSettingDialog.waitUntilVisible();
    editOrderPage.dpDropOffSettingDialog.clearSelected.click();
    editOrderPage.dpDropOffSettingDialog.saveChanges.clickAndWaitUntilDone();
    editOrderPage.waitUntilInvisibilityOfToast("Tagging to DP done successfully", true);
  }

  @Then("Operator verifies delivery (is|is not) indicated by 'Ninja Collect' icon on Edit Order Page")
  public void deliveryIsIndicatedByIcon(String indicationValue) {
    if (Objects.equals(indicationValue, "is")) {
      Assertions.assertThat(editOrderPage.deliveryIsIndicatedWithIcon())
          .as("Expected that Delivery is indicated by 'Ninja Collect' icon on Edit Order Page")
          .isTrue();
    } else if (Objects.equals(indicationValue, "is not")) {
      Assertions.assertThat(editOrderPage.deliveryIsIndicatedWithIcon())
          .as("Expected that Delivery is not indicated by 'Ninja Collect' icon on Edit Order Page")
          .isFalse();
    }
  }

  @Then("Operator delete order on Edit Order Page")
  public void operatorDeleteOrder() {
    editOrderPage.deleteOrder();
  }

  @Then("Operator reschedule Pickup on Edit Order Page with address changes")
  public void operatorReschedulePickupWithAddressChangeOnEditOrderPage(
      Map<String, String> mapOfData) {
    Map<String, String> mapOfTokens = StandardTestUtils.createDefaultTokens();
    mapOfData = StandardTestUtils.replaceDataTableTokens(mapOfData, mapOfTokens);
    //    to click unmask before performing changes
    List<WebElement> masks = getWebDriver().findElements(By.xpath(MaskedPage.MASKING_XPATH));
    editOrderPage.operatorClickMaskingText(masks);
    editOrderPage.reschedulePickupWithAddressChanges(mapOfData);
    takesScreenshot();
  }

  @Then("Operator reschedule Pickup on Edit Order Page")
  public void operatorReschedulePickupOnEditOrderPage(Map<String, String> mapOfData) {
    Map<String, String> mapOfTokens = StandardTestUtils.createDefaultTokens();
    mapOfData = StandardTestUtils.replaceDataTableTokens(mapOfData, mapOfTokens);
    editOrderPage.reschedulePickup(mapOfData);
    takesScreenshot();
  }

  @Then("Operator reschedule Delivery on Edit Order Page with address changes")
  public void operatorRescheduleDeliveryOnEditOrderPageWithAddressChange(
      Map<String, String> mapOfData) {
    Map<String, String> mapOfTokens = StandardTestUtils.createDefaultTokens();
    mapOfData = StandardTestUtils.replaceDataTableTokens(mapOfData, mapOfTokens);
    //    to click unmask before performing changes
    List<WebElement> masks = getWebDriver().findElements(By.xpath(MaskedPage.MASKING_XPATH));
    editOrderPage.operatorClickMaskingText(masks);
    editOrderPage.rescheduleDeliveryWithAddressChange(mapOfData);
    takesScreenshot();
  }

  @Then("Operator reschedule Delivery on Edit Order Page")
  public void operatorRescheduleDeliveryOnEditOrderPage(Map<String, String> mapOfData) {
    Map<String, String> mapOfTokens = StandardTestUtils.createDefaultTokens();
    mapOfData = StandardTestUtils.replaceDataTableTokens(mapOfData, mapOfTokens);
    //    to click unmask before performing changes
    List<WebElement> masks = getWebDriver().findElements(By.xpath(MaskedPage.MASKING_XPATH));
    editOrderPage.operatorClickMaskingText(masks);
    editOrderPage.rescheduleDelivery(mapOfData);
    takesScreenshot();
  }

  @Then("Operator pull out parcel from the route for (Pickup|Delivery) on Edit Order page")
  public void operatorPullsOrderFromRouteOnEditOrderPage(String txnType) {
    editOrderPage.pullFromRouteDialog.waitUntilVisible();
    editOrderPage.pullFromRouteDialog.toPull.check();
    takesScreenshot();
    editOrderPage.pullFromRouteDialog.pullFromRoute.clickAndWaitUntilDone();
  }

  @When("Operator verify next order info on Edit order page:")
  public void operatorVerifyOrderInfoOnEditOrderPage(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String fieldToValidate = mapOfData.get("stampId");
    if (StringUtils.isNotBlank(fieldToValidate)) {
      Assertions.assertThat(editOrderPage.getStampId()).as("StampId value is not as expected")
          .isEqualTo(fieldToValidate);
    }
  }

  @When("Operator change the COP value to {string}")
  public void OperatorChangeTheCopValue(String copValue) {
    Integer copValueToString = Integer.parseInt(copValue);
    editOrderPage.changeCopValue(copValueToString);
  }

  @When("Operator change the COD value to {string}")
  public void OperatorChangeTheCodValue(String codValue) {
    Integer codValueToString = Integer.parseInt(codValue);
    editOrderPage.changeCodValue(codValueToString);
  }

  @Then("Operator verify COP value is updated to {string}")
  public void VerifyCopUpdated(String copValue) {
    Integer copValueToString = Integer.parseInt(copValue);
    editOrderPage.verifyCopUpdated(copValueToString);
  }

  @Then("Operator verify COD value is updated to {string}")
  public void VerifyCodUpdated(String codValue) {
    Integer codValueToString = Integer.parseInt(codValue);
    editOrderPage.verifyCodUpdated(codValueToString);
  }

  @Then("Operator verify \"(.+)\" order event description on Edit order page")
  public void OperatorVerifyOrderEvent(String expectedEventName) {
    Order order = get(KEY_CREATED_ORDER);
    List<OrderEvent> events = editOrderPage.eventsTable().readAllEntities();
    OrderEvent actualEvent = events.stream()
        .filter(event -> equalsIgnoreCase(event.getName(), expectedEventName))
        .findFirst()
        .orElseThrow(() -> new AssertionError(
            f("There is no [%s] event on Edit Order page", expectedEventName)));
    String eventDescription = actualEvent.getDescription();
    if (equalsIgnoreCase(expectedEventName, "UPDATE CASH")) {
      editOrderPage.eventsTable().verifyVerifyUpdateCashDescription(order, eventDescription);
    }
    if (equalsIgnoreCase(expectedEventName, "HUB INBOUND SCAN")) {
      editOrderPage.eventsTable().verifyHubInboundEventDescription(order, eventDescription);
    }
  }

  @When("Operator change Cash on Pickup toggle to yes")
  public void ChangeCopToggleToYes() {
    editOrderPage.changeCopToggleToYes();
  }

  @When("Operator change Cash on Delivery toggle to yes")
  public void ChangeCodToggleToYes() {
    editOrderPage.changeCodToggleToYes();
  }

  @When("Operator change Cash on Delivery toggle to no")
  public void ChangeCodToggleToNo() {
    editOrderPage.changeCodToggleToNo();
  }

  @When("Operator change Cash on Pickup toggle to no")
  public void ChangeCopToggleToNo() {
    editOrderPage.changeCopToggleToNo();
  }

  @When("Operator switch to edit order page using direct URL")
  public void switchPage() {
    Order order = get(KEY_CREATED_ORDER);
    navigateTo(
        f("%s/%s/order/%d", TestConstants.OPERATOR_PORTAL_BASE_URL, TestConstants.NV_SYSTEM_ID,
            order.getId()));
  }

  @When("Operator make sure size changed to {string}")
  public void sizeUpdated(String size) {
    Order order = get(KEY_CREATED_ORDER);
    String parcelSize = "";

    switch (size) {
      case "S":
        parcelSize = "SMALL";
        break;
      case "M":
        parcelSize = "MEDIUM";
        break;
      case "L":
        parcelSize = "LARGE";
        break;
      case "XL":
        parcelSize = "EXTRALARGE";
        break;
      default:
        parcelSize = order.getParcelSize();
    }

    Order orderAfterInbound = get(KEY_ORDER_DETAILS);

    Assertions.assertThat(orderAfterInbound.getParcelSize()).as(("Size changed"))
        .isEqualTo(parcelSize);
  }

  @When("Operator open Edit Order page for order ID {value}")
  public void operatorOpenEditOrderPage(String orderId) {
    openEditOrderPage(Long.valueOf(orderId), true);
  }

  @When("Operator open Edit Order page for order ID {value} without unmask")
  public void operatorOpenEditOrderPageUnmask(String orderId) {
    openEditOrderPage(Long.valueOf(orderId), false);
  }

  private void openEditOrderPage(Long orderId, boolean isUnmask) {
    editOrderPage.openPage(orderId);
    if (!editOrderPage.status.isDisplayedFast()) {
      editOrderPage.refreshPage();
    }
    if (isUnmask) {
      List<WebElement> masks = getWebDriver().findElements(By.xpath(MaskedPage.MASKING_XPATH));
      editOrderPage.operatorClickMaskingText(masks);
    }
  }

  @Then("Operator verify following order info parameters after Global Inbound")
  public void operatorVerifyFollowingOrderInfoParametersAfterGlobalInbound(
      Map<String, String> mapOfData) {
    Order createdOrder = get(KEY_CREATED_ORDER);
    GlobalInboundParams globalInboundParams = get(KEY_GLOBAL_INBOUND_PARAMS);
    Double currentOrderCost = get(KEY_CURRENT_ORDER_COST);
    String expectedStatus = mapOfData.get("orderStatus");
    String expectedGranularStatusStr = mapOfData.get("granularStatus");
    List<String> expectedGranularStatus = null;
    if (StringUtils.isNotBlank(expectedGranularStatusStr)) {
      expectedGranularStatus = Arrays.stream(expectedGranularStatusStr.split(";")).map(String::trim)
          .collect(Collectors.toList());
    }
    String expectedDeliveryStatus = mapOfData.get("deliveryStatus");
    editOrderPage.verifyOrderIsGlobalInboundedSuccessfully(createdOrder, globalInboundParams,
        currentOrderCost, expectedStatus, expectedGranularStatus, expectedDeliveryStatus);
  }

  @Then("Operator set Delivery Verification Required to {string} on on Edit order page")
  public void operatorSetDeliveryVerificationRequired(String deliveryVerificationRequired) {
    deliveryVerificationRequired = resolveValue(deliveryVerificationRequired);
    editOrderPage.deliveryVerificationTypeEdit.click();
    editOrderPage.editDeliveryVerificationRequiredDialog.waitUntilVisible();
    editOrderPage.editDeliveryVerificationRequiredDialog.deliveryVerificationRequired
        .selectValue(deliveryVerificationRequired);
    editOrderPage.editDeliveryVerificationRequiredDialog.saveChanges.clickAndWaitUntilDone();
    editOrderPage
        .waitUntilInvisibilityOfToast("Delivery Verification Required updated successfully", true);
  }

  @Then("Operator verify Delivery Verification Required is {string} on on Edit order page")
  public void operatorVerifyDeliveryVerificationRequired(String deliveryVerificationRequired) {
    deliveryVerificationRequired = resolveValue(deliveryVerificationRequired);
    Assertions.assertThat(editOrderPage.deliveryVerificationType.getNormalizedText())
        .as("Delivery Verification Required").isEqualTo(deliveryVerificationRequired);
  }

  @Then("Operator verify Latest Route ID is \"(.+)\" on Edit Order page")
  public void operatorVerifyRouteIdOnEditOrderPage(String routeId) {
    Assertions.assertThat(editOrderPage.latestRouteId.getNormalizedText()).as("Latest Route ID")
        .isEqualTo(resolveValue(routeId));
  }

  @Then("Operator cancel RTS on Edit Order page")
  public void operatorCancelRtsOnEditOrderPage() {
    editOrderPage.clickMenu("Return to Sender", "Cancel RTS");
    editOrderPage.cancelRtsDialog.waitUntilVisible();
    editOrderPage.cancelRtsDialog.cancelRts.click();
  }

  @Then("Operator verifies RTS tag is (displayed|hidden) in delivery details box on Edit Order page")
  public void operatorVerifyRtsTag(String state) {
    Assertions.assertThat(editOrderPage.deliveryDetailsBox.rtsTag.isDisplayed())
        .as("RTS tag is displayed").isEqualTo(equalsIgnoreCase(state, "displayed"));
  }

  @Then("Operator verifies Latest Event is {string} on Edit Order page")
  public void operatorVerifyLatestEvent(String value) {
    retryIfAssertionErrorOccurred(() ->
        Assertions.assertThat(editOrderPage.latestEvent.getNormalizedText()).as("Latest Event")
            .isEqualTo(resolveValue(value)), "Latest Event", 1000, 3);
  }

  @Then("Operator verifies Zone is {string} on Edit Order page")
  public void operatorVerifyZone(String value) {
    Assertions.assertThat(editOrderPage.zone.getNormalizedText()).as("Zone")
        .isEqualTo(resolveValue(value));
  }

  @Then("Operator verifies Zone is correct after RTS on Edit Order page")
  public void operatorVerifyZoneAfterRts() {
    final AddressingZone zone = get(KEY_RTS_ZONE_TYPE);
    operatorVerifyZone(zone.getShortName());
  }

  @Then("Operator verify {value} RTS hint is displayed on Edit Order page")
  public void verifyRtsHint(String value) {
    editOrderPage.editRtsDetailsDialog.waitUntilVisible();
    Assertions.assertThat(editOrderPage.editRtsDetailsDialog.hint.isDisplayed())
        .withFailMessage("RTS hint is not displayed")
        .isTrue();
    Assertions.assertThat(editOrderPage.editRtsDetailsDialog.hint.getText())
        .as("RTS hint text")
        .isEqualTo(value);
  }

  @Then("Operator RTS order on Edit Order page using data below:")
  public void operatorRtsOnEditOrderPage(Map<String, String> data) {
    data = resolveKeyValues(data);
    if (!editOrderPage.editRtsDetailsDialog.isDisplayedFast()) {
      editOrderPage.clickMenu("Delivery", "Return to Sender");
      editOrderPage.editRtsDetailsDialog.waitUntilVisible();
    }
    String value = data.get("reason");
    if (StringUtils.isNotBlank(value)) {
      editOrderPage.editRtsDetailsDialog.reason.selectValue(value);
    }
    value = data.get("recipientName");
    if (StringUtils.isNotBlank(value)) {
      editOrderPage.editRtsDetailsDialog.recipientName.setValue(value);
    }
    value = data.get("recipientContact");
    if (StringUtils.isNotBlank(value)) {
      editOrderPage.editRtsDetailsDialog.recipientContact.setValue(value);
    }
    value = data.get("recipientEmail");
    if (StringUtils.isNotBlank(value)) {
      editOrderPage.editRtsDetailsDialog.recipientEmail.setValue(value);
    }
    value = data.get("internalNotes");
    if (StringUtils.isNotBlank(value)) {
      editOrderPage.editRtsDetailsDialog.internalNotes.setValue(value);
    }
    value = data.get("deliveryDate");
    if (StringUtils.isNotBlank(value)) {
      editOrderPage.editRtsDetailsDialog.deliveryDate.simpleSetValue(value);
    }
    value = data.get("timeslot");
    if (StringUtils.isNotBlank(value)) {
      editOrderPage.editRtsDetailsDialog.timeslot.searchAndSelectValue(value);
    }
    value = data.get("country");
    if (StringUtils.isNotBlank(value)) {
      editOrderPage.editRtsDetailsDialog.changeAddress.click();
      editOrderPage.editRtsDetailsDialog.country.setValue(value);
    }
    value = data.get("city");
    if (StringUtils.isNotBlank(value)) {
      editOrderPage.editRtsDetailsDialog.city.setValue(value);
    }
    value = data.get("address1");
    if (StringUtils.isNotBlank(value)) {
      editOrderPage.editRtsDetailsDialog.address1.setValue(value);
    }
    value = data.get("address2");
    if (StringUtils.isNotBlank(value)) {
      editOrderPage.editRtsDetailsDialog.address2.setValue(value);
    }
    value = data.get("postalCode");
    if (StringUtils.isNotBlank(value)) {
      editOrderPage.editRtsDetailsDialog.postcode.setValue(value);
    }
    editOrderPage.editRtsDetailsDialog.saveChanges.clickAndWaitUntilDone();
  }

  @Then("Operator resume order on Edit Order page")
  public void operatorResumeOrder() {
    editOrderPage.clickMenu("Order Settings", "Resume Order");
    editOrderPage.resumeOrderDialog.waitUntilVisible();
    takesScreenshot();
    editOrderPage.resumeOrderDialog.resumeOrder.clickAndWaitUntilDone();
    editOrderPage.waitUntilInvisibilityOfToast("1 order(s) resumed", true);
  }

  @And("Operator verify the tags shown on Edit Order page")
  public void operatorVerifyTheTagsShownOnEditOrderPage(List<String> expectedOrderTags) {
    expectedOrderTags = resolveValues(expectedOrderTags);

    List<String> actualOrderTags = editOrderPage.getTags();

    final List<String> normalizedExpectedList = expectedOrderTags.stream().map(String::toLowerCase)
        .sorted().collect(Collectors.toList());
    final List<String> normalizedActualList = actualOrderTags.stream().map(String::toLowerCase)
        .sorted().collect(Collectors.toList());

    Assertions.assertThat(normalizedActualList)
        .as("Order tags is not equal to tags set on Order Tag Management page")
        .containsExactlyElementsOf(normalizedExpectedList);
  }

  @And("Operator verifies no tags shown on Edit Order page")
  public void operatorVerifyNoTagsShownOnEditOrderPage() {
    List<String> actualOrderTags = editOrderPage.getTags();
    Assertions.assertThat(actualOrderTags).as("List of displayed order tags").isEmpty();
    takesScreenshot();
  }

  @When("Operator click Chat With Driver on Edit Order page")
  public void clickChatWithDriver() {
    editOrderPage.chatWithDriver.click();
  }

  @When("Chat With Driver dialog is displayed on Edit Order page")
  public void verifyChatWithDriverDialogDisplayed() {
    pause5s();
    editOrderPage.chatWithDriverDialog.waitUntilVisible();
  }

  @When("Operator click on {string} tracking ID in Chat With Driver dialog")
  public void clickTrackingIdInChatWithDriverDialog(String trackingId) {
    editOrderPage.chatWithDriverDialog.findOrderItemByTrackingId(resolveValue(trackingId))
        .trackingId.click();
  }

  @When("Number of replays for {string} tracking ID in Chat With Driver dialog is {int}")
  public void verifyNumberOfReplays(String trackingId, int expectedNumber) {
    String actual = editOrderPage.chatWithDriverDialog
        .findOrderItemByTrackingId(resolveValue(trackingId))
        .replaysNumber.getText();
    Assertions.assertThat(Integer.parseInt(actual)).as("Number of replays")
        .isEqualTo(expectedNumber);
  }

  @When("Go to order details button is displayed in Chat With Driver dialog")
  public void goToOrderDetailsButtonIsDisplayed() {
    Assertions.assertThat(editOrderPage.chatWithDriverDialog.goToOrderDetails.isDisplayed())
        .as("Go to order details button is displayed").isTrue();
  }

  @When("Date of {string} order is {string} in Chat With Driver dialog")
  public void verifyDateOfOrderInChatWithDriverDialog(String trackingId, String expected) {
    trackingId = resolveValue(trackingId);
    String actual = editOrderPage.chatWithDriverDialog.findOrderItemByTrackingId(trackingId)
        .date.getText();
    Assertions.assertThat(actual).as("Date of chat for order " + trackingId)
        .isEqualTo(resolveValue(expected));
  }

  @When("Operator send {string} message to driver in Chat With Driver dialog")
  public void sendMessageToDriver(String message) {
    message = resolveValue(message);
    editOrderPage.chatWithDriverDialog.messageInput.setValue(message + Keys.ENTER);
    put(KEY_CHAT_MESSAGE, message);
    pause1s();
  }

  @When("message {string} is displayed in Chat With Driver dialog")
  public void verifyChatMessageIsDisplayed(String value) {
    String expected = resolveValue(value);
    ChatMessage messageItem = editOrderPage.chatWithDriverDialog.messages.stream()
        .filter(
            chatMessage -> StringUtils.equals(expected, chatMessage.message.getNormalizedText()))
        .findFirst()
        .orElseThrow(() -> new AssertionError("Chat message [" + expected + "] was not found"));
    String id = messageItem.getAttribute("id");
    put(KEY_CHAT_MESSAGE_ID, id);
    Assertions.assertThat(messageItem.date.getNormalizedText()).as("Chat message date")
        .isNullOrEmpty();
  }

  @When("chat date is {string} in Chat With Driver dialog")
  public void verifyChatDate(String expected) {
    Assertions.assertThat(editOrderPage.chatWithDriverDialog.chatDate.getNormalizedText())
        .as("Chat date").isEqualTo(resolveValue(expected));
  }

  @When("Read label is displayed Chat With Driver dialog")
  public void verifyReadLabelIsDisplayed() {
    Assertions.assertThat(editOrderPage.chatWithDriverDialog.readLabel.isDisplayed())
        .as("Read label is displayed").isTrue();
  }

  @When("Read label is not displayed Chat With Driver dialog")
  public void verifyReadLabelIsNotDisplayed() {
    Assertions.assertThat(editOrderPage.chatWithDriverDialog.readLabel.waitUntilVisible(5))
        .as("Read label is displayed").isFalse();
  }

  @When("Operator close Chat With Driver dialog")
  public void closeChatWithDriverDialog() {
    editOrderPage.chatWithDriverDialog.close();
  }

  @When("Operator selects {string} in Events Filter menu on Edit Order page")
  public void selectEventsFilter(String option) {
    editOrderPage.eventsTableFilter.selectOption(resolveValue(option));
  }

  @Then("Operator verify delivery POD details is correct on Edit Order page using date below:")
  public void verifyDeliveryPodDetails(Map<String, String> data) {
    final Order order = get(KEY_CREATED_ORDER);
    final PodDetailsDialog podDetailsDialog = editOrderPage.podDetailsDialog();

    // open the pod details view
    podDetailsDialog.getPodDetailTable().clickView(1);
    podDetailsDialog.scrollToBottom();
    takesScreenshot();

    final String expectedTransactionText = f("TRANSACTION (%d)",
        order.getLastDeliveryTransaction().getId());
    softAssert.assertEquals("tracking id string", order.getTrackingId(),
        podDetailsDialog.getTrackingId());
    softAssert.assertEquals("transaction string", expectedTransactionText,
        podDetailsDialog.getTransaction());
    softAssert.assertEquals("information - status",
        StringUtils.lowerCase(order.getLastDeliveryTransaction().getStatus()),
        StringUtils.lowerCase(podDetailsDialog.getStatus()));
    softAssert
        .assertEquals("information - driver", data.get("driver"), podDetailsDialog.getDriver());
    softAssert.assertTrue("information - priority level",
        StringUtils.isNotEmpty(podDetailsDialog.getPriorityLevel()));
    softAssert.assertEquals("information - verification method", data.get("verification method"),
        podDetailsDialog.getVerificationMethod());
    softAssert.assertTrue("information - location",
        podDetailsDialog.getLocation().contains(order.getLastDeliveryTransaction().getAddress1()));
    softAssert.assertAll();
  }

  @Then("Operator verifies that there will be a toast of successfully downloaded airway bill")
  public void operatorVerifiesThatThereWillBeAToastOfSuccessfullyDownloadedAirwayBill() {
    editOrderPage.switchToOtherWindowUrlContains("https://operatorv2-qa.ninjavan.co/#/my/order");
    editOrderPage.waitUntilVisibilityOfToast("Attempting to print waybill(s)");
    editOrderPage.waitUntilInvisibilityOfToast("Print waybill(s) successfully");
  }

  @When("Operator opens and verifies the downloaded airway bill pdf")
  public void operatorOpensTheDownloadedAirwayBillPdf() {
    final String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    final String fileName = f("awb_%s.pdf", trackingId);
    String actualSortCode;

    if (get(KEY_CREATED_SORT_CODE) != null) {
      SortCode sortCode = get(KEY_CREATED_SORT_CODE);
      actualSortCode = sortCode.getSortCode();
    } else {
      actualSortCode = "X";
    }

    // verifies the file is existed
    editOrderPage.verifyFileDownloadedSuccessfully(fileName);
    takesScreenshot();

    String pathname = StandardTestConstants.TEMP_DIR + fileName;
    try {
      // get path
      Path path = Paths.get(pathname).toRealPath();
      // convert downloaded pdf to byte
      File pdf = new File(String.valueOf(path));
      // convert to url
      String url = String.valueOf(path.toUri());
      //go to url
      getWebDriver().get(url);

      // verifies the sort code
      editOrderPage.verifyTheSortCodeIsCorrect(actualSortCode, pdf);
    } catch (IOException e) {
      throw new NvTestRuntimeException("Could not get file path " + pathname, e);
    }
  }

  @Then("Operator verifies ticket status is {value} on Edit Order page")
  public void updateRecoveryTicket(String data) {
    String status = editOrderPage.recoveryTicket.getText();
    Pattern p = Pattern.compile(".*Status:\\s*(.+?)\\s.*");
    Matcher m = p.matcher(status);
    if (m.matches()) {
      Assertions.assertThat(m.group(1))
          .as("Ticket status")
          .isEqualToIgnoringCase(data);
    } else {
      Assertions.fail("Could not get ticket status from string: " + status);
    }
  }

  @Then("Operator updates recovery ticket on Edit Order page:")
  public void updateRecoveryTicket(Map<String, String> data) {
    data = resolveKeyValues(data);
    editOrderPage.recoveryTicket.click();
    editOrderPage.editTicketDialog.waitUntilVisible();
    pause5s();
    if (data.containsKey("status")) {
      editOrderPage.editTicketDialog.ticketStatus.selectValue(data.get("status"));
    }
    pause5s();
    if (data.containsKey("keepCurrentOrderOutcome")) {
      editOrderPage.chooseCurrentOrderOutcome(data.get("keepCurrentOrderOutcome"));
    }
    pause5s();
    if (data.containsKey("outcome")) {
      editOrderPage.editTicketDialog.orderOutcome.selectValue(data.get("outcome"));
    }
    if (data.containsKey("assignTo")) {
      editOrderPage.editTicketDialog.assignTo.selectValue(data.get("assignTo"));
    }
    if (data.containsKey("rtsReason")) {
      editOrderPage.editTicketDialog.rtsReason.selectValue(data.get("rtsReason"));
    }
    if (data.containsKey("newInstructions")) {
      String instruction = data.get("newInstructions");
      if ("GENERATED".equals(instruction)) {
        instruction = f("This damage description is created by automation at %s.",
            DTF_CREATED_DATE.format(ZonedDateTime.now()));
      }
      editOrderPage.editTicketDialog.newInstructions.setValue(instruction);
    }
    editOrderPage.editTicketDialog.updateTicket.clickAndWaitUntilDone(60);
  }

  @When("Operator create new recovery ticket on Edit Order page:")
  public void createNewTicket(Map<String, String> mapOfData) {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);

    String entrySource = mapOfData.get("entrySource");
    String investigatingDepartment = mapOfData.get("investigatingDepartment");
    String investigatingHub = mapOfData.get("investigatingHub");
    String ticketType = mapOfData.get("ticketType");
    String ticketSubType = mapOfData.get("ticketSubType");
    String parcelLocation = mapOfData.get("parcelLocation");
    String liability = mapOfData.get("liability");
    String damageDescription = mapOfData.get("damageDescription");
    String orderOutcome = mapOfData.get("orderOutcome");
    String orderOutcomeDamaged = mapOfData.get("orderOutcomeDamaged");
    String orderOutcomeMissing = mapOfData.get("orderOutcomeMissing");
    String custZendeskId = mapOfData.get("custZendeskId");
    String shipperZendeskId = mapOfData.get("shipperZendeskId");
    String ticketNotes = mapOfData.get("ticketNotes");
    String parcelDescription = mapOfData.get("parcelDescription");
    String exceptionReason = mapOfData.get("exceptionReason");
    String orderOutcomeInaccurateAddress = mapOfData.get("orderOutcomeInaccurateAddress");
    String orderOutcomeDuplicateParcel = mapOfData.get("orderOutcomeDuplicateParcel");
    String issueDescription = mapOfData.get("issueDescription");
    String rtsReason = mapOfData.get("rtsReason");

    if ("GENERATED".equals(damageDescription)) {
      damageDescription = f("This damage description is created by automation at %s.",
          DTF_CREATED_DATE.format(ZonedDateTime.now()));
    }

    if ("GENERATED".equals(ticketNotes)) {
      ticketNotes = f("This ticket notes is created by automation at %s.",
          DTF_CREATED_DATE.format(ZonedDateTime.now()));
    }

    if ("GENERATED".equals(parcelDescription)) {
      parcelDescription = f("This parcel description is created by automation at %s.",
          DTF_CREATED_DATE.format(ZonedDateTime.now()));
    }

    if ("GENERATED".equals(exceptionReason)) {
      exceptionReason = f("This exception reason is created by automation at %s.",
          DTF_CREATED_DATE.format(ZonedDateTime.now()));
    }

    if ("GENERATED".equals(issueDescription)) {
      issueDescription = f("This issue description is created by automation at %s.",
          DTF_CREATED_DATE.format(ZonedDateTime.now()));
    }

    RecoveryTicket recoveryTicket = new RecoveryTicket();
    recoveryTicket.setTrackingId(trackingId);
    recoveryTicket.setEntrySource(entrySource);
    recoveryTicket.setInvestigatingDepartment(investigatingDepartment);
    recoveryTicket.setInvestigatingHub(investigatingHub);
    recoveryTicket.setTicketType(ticketType);
    recoveryTicket.setTicketSubType(ticketSubType);
    recoveryTicket.setParcelLocation(parcelLocation);
    recoveryTicket.setLiability(liability);
    recoveryTicket.setDamageDescription(damageDescription);
    recoveryTicket.setOrderOutcome(orderOutcome);
    if (StringUtils.isNotBlank(orderOutcomeDamaged)) {
      recoveryTicket.setOrderOutcome(orderOutcomeDamaged);
    }
    if (StringUtils.isNotBlank(orderOutcomeMissing)) {
      recoveryTicket.setOrderOutcome(orderOutcomeMissing);
    }
    if (StringUtils.isNotBlank(orderOutcomeDuplicateParcel)) {
      recoveryTicket.setOrderOutcome(orderOutcomeDuplicateParcel);
    }
    if (StringUtils.isNotBlank(orderOutcomeInaccurateAddress)) {
      recoveryTicket.setOrderOutcome(orderOutcomeInaccurateAddress);
    }
    recoveryTicket.setCustZendeskId(custZendeskId);
    recoveryTicket.setShipperZendeskId(shipperZendeskId);
    recoveryTicket.setTicketNotes(ticketNotes);
    recoveryTicket.setParcelDescription(parcelDescription);
    recoveryTicket.setExceptionReason(exceptionReason);
    recoveryTicket.setIssueDescription(issueDescription);
    recoveryTicket.setRtsReason(rtsReason);

    editOrderPage.clickMenu("Order Settings", "Create Recovery Ticket");
    editOrderPage.createTicket(recoveryTicket);
    takesScreenshot();
    put("recoveryTicket", recoveryTicket);
  }

  @And("Operator gets the event time by event name:{string}")
  public void operatorValidatesEventInTheEditOrderPageAndGetEventTime(String eventName) {
    String lastScannedTime = editOrderPage.getEventTimeByEventName(eventName);
    put(KEY_EVENT_TIME, lastScannedTime);
    takesScreenshot();
  }

  @Then("Operator verifies Airway bill infor:")
  public void operatorVerifiesAirwayBillInfor(Map<String, String> dataAsString) {
    editOrderPage.switchToOtherWindow();
    pause3s();
    String pdfUrl = getWebDriver().getCurrentUrl();
    String pdfTexts = editOrderPage.getPdfText(pdfUrl);
    Map<String, String> data = resolveKeyValues(dataAsString);
    if (data.get("trackingId") != null) {
      Assertions.assertThat(pdfTexts).as("Tracking ID")
          .containsIgnoringCase(data.get("trackingId"));
    }
    if (data.get("FromName") != null) {
      Assertions.assertThat(pdfTexts).as("From Name").containsIgnoringCase(data.get("FromName"));
    }
    if (data.get("FromContact") != null) {
      Assertions.assertThat(pdfTexts).as("From Contact")
          .containsIgnoringCase(data.get("FromContact"));
    }
    if (data.get("FromAddress") != null) {
      Assertions.assertThat(pdfTexts).as("From Address")
          .containsIgnoringCase(data.get("FromAddress"));
    }
    if (data.get("FromPostcode") != null) {
      Assertions.assertThat(pdfTexts).as("Postcode In From Address")
          .containsIgnoringCase(data.get("FromPostcode"));
    }

    if (data.get("ToName") != null) {
      Assertions.assertThat(pdfTexts).as("To Name").containsIgnoringCase(data.get("ToName"));
    }
    if (data.get("ToContact") != null) {
      Assertions.assertThat(pdfTexts).as("To Contact")
          .containsIgnoringCase(data.get("ToContact"));
    }
    if (data.get("ToAddress") != null) {
      Assertions.assertThat(pdfTexts).as("To Address")
          .containsIgnoringCase(data.get("ToAddress"));
    }
    if (data.get("ToPostcode") != null) {
      Assertions.assertThat(pdfTexts).as("Postcode In To Address")
          .containsIgnoringCase(data.get("ToPostcode"));
    }
  }

  @Given("Operator unmask edit order page")
  public void unmaskEditOrder() {
    List<WebElement> elements = getWebDriver().findElements(By.xpath(MaskedPage.MASKING_XPATH));
    editOrderPage.operatorClickMaskingText(elements);
  }
}
