package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.model.DataEntity;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.model.OrderEvent;
import co.nvqa.operator_v2.model.PodDetail;
import co.nvqa.operator_v2.model.RecoveryTicket;
import co.nvqa.operator_v2.model.TransactionInfo;
import co.nvqa.operator_v2.selenium.page.EditOrderV2Page;
import co.nvqa.operator_v2.selenium.page.EditOrderV2Page.EventsTable;
import co.nvqa.operator_v2.selenium.page.MaskedPage;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableList;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.text.ParseException;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.assertj.core.data.Offset;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.operator_v2.selenium.page.EditOrderPage.EventsTable.EVENT_NAME;
import static org.apache.commons.lang3.StringUtils.equalsIgnoreCase;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class EditOrderV2Steps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(EditOrderV2Steps.class);
  public static final String KEY_CHAT_MESSAGE = "KEY_CHAT_MESSAGE";
  public static final String KEY_CHAT_MESSAGE_ID = "KEY_CHAT_MESSAGE_ID";

  private EditOrderV2Page page;

  public EditOrderV2Steps() {
  }

  @Override
  public void init() {
    page = new EditOrderV2Page(getWebDriver());
  }

  @When("^Operator click ([^\"]*) -> ([^\"]*) on Edit Order V2 page$")
  public void operatorClickMenuOnEditOrderPage(String parentMenuName, String childMenuName) {
    page.inFrame(() -> page.clickMenu(parentMenuName, childMenuName));
  }

  @When("Operator Edit Order Details on Edit Order V2 page:")
  public void operatorEditOrderDetailsOnEditOrderPage(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    page.inFrame(() -> {
      page.editOrderDetailsDialog.waitUntilVisible();
      if (data.containsKey("deliveryTypes")) {
        List<String> values = splitAndNormalize(finalData.get("deliveryTypes"));
        page.editOrderDetailsDialog.deliveryTypes.selectValues(values);
      }
      if (data.containsKey("size")) {
        page.editOrderDetailsDialog.parcelSize.selectValue(finalData.get("size"));
      }
      if (data.containsKey("weight")) {
        page.editOrderDetailsDialog.weight.setValue(finalData.get("weight"));
      }
      if (data.containsKey("length")) {
        page.editOrderDetailsDialog.length.setValue(finalData.get("length"));
      }
      if (data.containsKey("width")) {
        page.editOrderDetailsDialog.width.setValue(finalData.get("width"));
      }
      if (data.containsKey("breadth")) {
        page.editOrderDetailsDialog.breadth.setValue(finalData.get("breadth"));
      }
      if (data.containsKey("insuredValue")) {
        page.editOrderDetailsDialog.insuredValue.setValue(finalData.get("insuredValue"));
      }
      page.editOrderDetailsDialog.saveChanges.click();
    });
  }

  @Then("Operator Edit Order Details on Edit Order V2 page successfully")
  public void operatorEditOrderDetailsOnEditOrderPageSuccessfully() {
    Order orderEdited = get("orderEdited");
    page.verifyEditOrderDetailsIsSuccess(orderEdited);
    takesScreenshot();
  }

  @Then("Operator verifies order details on Edit Order V2 page:")
  public void operatorVerifyDimensionInformation(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    SoftAssertions softAssertions = new SoftAssertions();
    page.inFrame(() -> {
      String expected = finalData.get("size");
      if (StringUtils.isNotBlank(expected)) {
        softAssertions.assertThat(page.size.getText()).as("Parcel size")
            .isEqualToIgnoringCase(expected);
      }
      expected = finalData.get("weight");
      if (StringUtils.isNotBlank(expected)) {
        softAssertions.assertThat(page.getWeight()).as("Parcel weight")
            .isEqualTo(Double.parseDouble(expected));
      }
      expected = finalData.get("length");
      if (StringUtils.isNotBlank(expected)) {
        softAssertions.assertThat(page.getLength()).as("Parcel length")
            .isEqualTo(Double.parseDouble(expected));
      }
      expected = finalData.get("width");
      if (StringUtils.isNotBlank(expected)) {
        softAssertions.assertThat(page.getWidth()).as("Parcel width")
            .isEqualTo(Double.parseDouble(expected));
      }
      expected = finalData.get("height");
      if (StringUtils.isNotBlank(expected)) {
        softAssertions.assertThat(page.getHeighth()).as("Parcel height")
            .isEqualTo(Double.parseDouble(expected));
      }
      expected = finalData.get("deliveryVerificationType");
      if (StringUtils.isNotBlank(expected)) {
        softAssertions.assertThat(page.deliveryVerificationType.getText())
            .as("Delivery verification required").isEqualTo(expected);
      }
      expected = finalData.get("insuredValue");
      if (StringUtils.isNotBlank(expected)) {
        softAssertions.assertThat(page.insuredValue.getText()).as("Insured value")
            .isEqualTo(expected);
      }
      expected = finalData.get("deliveryType");
      if (StringUtils.isNotBlank(expected)) {
        softAssertions.assertThat(page.deliveryType.getText()).as("Delivery type")
            .isEqualTo(expected);
      }
      expected = finalData.get("cop");
      if (StringUtils.isNotBlank(expected)) {
        softAssertions.assertThat(page.copValue.getText()).as("COP").isEqualTo(expected);
      }
      expected = finalData.get("cod");
      if (StringUtils.isNotBlank(expected)) {
        softAssertions.assertThat(page.codValue.getText()).as("COD").isEqualTo(expected);
      }
      expected = finalData.get("status");
      if (StringUtils.isNotBlank(expected)) {
        softAssertions.assertThat(page.status.getText()).as("Status").isEqualTo(expected);
      }
      expected = finalData.get("granularStatus");
      if (StringUtils.isNotBlank(expected)) {
        softAssertions.assertThat(page.granular.getText()).as("Granular status")
            .isEqualTo(expected);
      }
      expected = finalData.get("zone");
      if (StringUtils.isNotBlank(expected)) {
        softAssertions.assertThat(page.zone.getText()).as("Zone").isEqualTo(expected);
      }
      expected = finalData.get("zone");
      if (StringUtils.isNotBlank(expected)) {
        softAssertions.assertThat(page.zone.getText()).as("Zone").isEqualTo(expected);
      }
      expected = finalData.get("latestRouteId");
      if (StringUtils.isNotBlank(expected)) {
        softAssertions.assertThat(page.latestRouteId.getText()).as("Latest Route ID")
            .isEqualTo(expected);
      }
    });
    softAssertions.assertAll();
  }

  @Then("Operator verify COP icon is not displayed on Edit Order V2 page")
  public void operatorVerifyCopNotDisplayed() {
    page.inFrame(() -> Assertions.assertThat(page.copValue.isDisplayed())
        .withFailMessage("Unexpected COP icon is displayed").isFalse());
  }

  @Then("Operator verify COD icon is not displayed on Edit Order V2 page")
  public void operatorVerifyCodNotDisplayed() {
    page.inFrame(() -> Assertions.assertThat(page.codValue.isDisplayed())
        .withFailMessage("Unexpected COD icon is displayed").isFalse());
  }

  @Then("^Operator verifies pricing information on Edit Order V2 page:$")
  public void operatorVerifyPricingInformation(Map<String, String> data) {
    data = resolveKeyValues(data);
    SoftAssertions softAssertions = new SoftAssertions();
    String expectedValue;

    if (data.containsKey("total")) {
      expectedValue = data.get("total");
      if (expectedValue.equals("-")) {
        softAssertions.assertThat(page.totalPrice.getText()).as("Total Fee is correct")
            .isEqualTo("-");
      } else {
        softAssertions.assertThat(page.getTotal()).as("Total is correct")
            .isCloseTo(StandardTestUtils.getDoubleValue(data.get("total")), Offset.offset(0.09));
      }
    }

    if (data.containsKey("deliveryFee")) {
      expectedValue = data.get("deliveryFee");
      if (expectedValue.equals("-")) {
        softAssertions.assertThat(page.deliveryFee.getText()).as("Delivery Fee is correct")
            .isEqualTo("-");
      } else {
        softAssertions.assertThat(StandardTestUtils.getDoubleValue(page.deliveryFee.getText()))
            .as("Delivery Fee is correct")
            .isCloseTo(StandardTestUtils.getDoubleValue(data.get("deliveryFee")),
                Offset.offset(0.09));
      }
    }

    if (data.containsKey("codFee")) {
      expectedValue = data.get("codFee");
      if (expectedValue.equals("-")) {
        softAssertions.assertThat(page.codFee.getText()).as("COD Fee is correct").isEqualTo("-");
      } else {
        softAssertions.assertThat(StandardTestUtils.getDoubleValue(page.codFee.getText()))
            .as("COD Fee is correct")
            .isCloseTo(StandardTestUtils.getDoubleValue(expectedValue), Offset.offset(0.09));
      }
    }

    if (data.containsKey("insuranceFee")) {
      expectedValue = data.get("insuranceFee");
      if (expectedValue.equals("-")) {
        softAssertions.assertThat(page.insuranceFee.getText()).as("Insurance Fee is correct")
            .isEqualTo("-");
      } else {
        softAssertions.assertThat(StandardTestUtils.getDoubleValue(page.insuranceFee.getText()))
            .as("Insurance Fee is correct")
            .isCloseTo(StandardTestUtils.getDoubleValue(expectedValue), Offset.offset(0.09));
      }
    }

    if (data.containsKey("handlingFee")) {
      expectedValue = data.get("handlingFee");
      if (expectedValue.equals("-")) {
        softAssertions.assertThat(page.handlingFee.getText()).as("Handling Fee is correct")
            .isEqualTo("-");
      } else {
        softAssertions.assertThat(StandardTestUtils.getDoubleValue(page.handlingFee.getText()))
            .as("Handling Fee is correct")
            .isCloseTo(StandardTestUtils.getDoubleValue(expectedValue), Offset.offset(0.09));
      }
    }

    if (data.containsKey("rtsFee")) {
      expectedValue = data.get("rtsFee");
      if (expectedValue.equals("-")) {
        softAssertions.assertThat(page.rtsFee.getText()).as("Rts Fee is correct").isEqualTo("-");
      } else {
        softAssertions.assertThat(StandardTestUtils.getDoubleValue(page.rtsFee.getText()))
            .as("Rts Fee is correct")
            .isCloseTo(StandardTestUtils.getDoubleValue(expectedValue), Offset.offset(0.09));
      }
    }

    if (data.containsKey("gst")) {
      expectedValue = data.get("gst");
      if (expectedValue.equals("-")) {
        softAssertions.assertThat(page.gst.getText()).as("GST Fee is correct").isEqualTo("-");
      } else {
        softAssertions.assertThat(StandardTestUtils.getDoubleValue(page.gst.getText()))
            .as("Gst is correct")
            .isCloseTo(StandardTestUtils.getDoubleValue(expectedValue), Offset.offset(0.09));
      }
    }

    if (data.containsKey("insuredValue")) {
      expectedValue = data.get("insuredValue");
      if (expectedValue.equals("-")) {
        softAssertions.assertThat(page.insuredValue.getText()).as("Insurance Value is correct")
            .isEqualTo("-");
      } else {
        softAssertions.assertThat(StandardTestUtils.getDoubleValue(page.insuredValue.getText()))
            .as("Insured Fee is correct")
            .isCloseTo(StandardTestUtils.getDoubleValue(expectedValue), Offset.offset(0.09));
      }
    }

    if (data.containsKey("billingWeight")) {
      expectedValue = data.get("billingWeight");
      if (expectedValue.equals("notAvailable")) {
        softAssertions.assertThat(page.billingWeight.isDisplayed())
            .as("Billing Weight Value is correct").isFalse();
      } else {
        softAssertions.assertThat(page.billingWeight.getText()).as("Billing Weight is correct")
            .isEqualTo(expectedValue);
      }
    }

    if (data.containsKey("billingSize")) {
      expectedValue = data.get("billingSize");
      if (expectedValue.equals("notAvailable")) {
        softAssertions.assertThat(page.billingSize.isDisplayed())
            .as("Billing Size Value is correct").isFalse();
      } else {
        softAssertions.assertThat(page.billingSize.getText()).as("Billing Size is correct")
            .isEqualTo(expectedValue);
      }
    }

    if (data.containsKey("source")) {
      expectedValue = data.get("source");
      if (expectedValue.equals("notAvailable")) {
        softAssertions.assertThat(page.source.isDisplayed()).as("Source is correct").isFalse();
      } else {
        softAssertions.assertThat(page.source.getText()).as("Source is correct")
            .isEqualTo(expectedValue);
      }
    }

    softAssertions.assertAll();
  }

  @When("Operator enter Order Instructions on Edit Order V2 page:")
  public void operatorEnterOrderInstructionsOnEditOrderPage(Map<String, String> data) {
    String pickupInstruction = data.get("pickupInstruction");
    String deliveryInstruction = data.get("deliveryInstruction");
    String orderInstruction = data.get("orderInstruction");

    page.inFrame(() -> {
      page.editInstructionsDialog.waitUntilVisible();
      if (StringUtils.isNotBlank(pickupInstruction)) {
        if ("empty".equalsIgnoreCase(pickupInstruction)) {
          page.editInstructionsDialog.pickupInstruction.forceClear();
        } else {
          page.editInstructionsDialog.pickupInstruction.setValue(pickupInstruction);
        }
      }
      if (StringUtils.isNotBlank(deliveryInstruction)) {
        if ("empty".equalsIgnoreCase(deliveryInstruction)) {
          page.editInstructionsDialog.deliveryInstruction.forceClear();
        } else {
          page.editInstructionsDialog.deliveryInstruction.setValue(deliveryInstruction);
        }
      }
      if (StringUtils.isNotBlank(orderInstruction)) {
        if ("empty".equalsIgnoreCase(orderInstruction)) {
          page.editInstructionsDialog.orderInstruction.forceClear();
        } else {
          page.editInstructionsDialog.orderInstruction.setValue(orderInstruction);
        }
      }
      page.editInstructionsDialog.saveChanges.click();
    });
  }

  @When("Operator verify Order Instructions on Edit Order V2 page:")
  public void operatorVerifyOrderInstructionsAreUpdatedOnEditOrderPage(Map<String, String> data) {
    data = resolveKeyValues(data);

    String pickupInstruction = data.get("pickupInstruction");
    String deliveryInstruction = data.get("deliveryInstruction");

    SoftAssertions assertions = new SoftAssertions();
    page.inFrame(() -> {
      if (StringUtils.isNotBlank(pickupInstruction)) {
        String actualPickupInstructions = page.pickupDetailsBox.pickupInstructions.getText();
        assertions.assertThat(actualPickupInstructions).as("Pick Up Instructions")
            .isEqualToIgnoringCase(pickupInstruction);
      }
      if (StringUtils.isNotBlank(deliveryInstruction)) {
        String actualDeliveryInstructions = page.deliveryDetailsBox.deliveryInstructions.getText();
        assertions.assertThat(actualDeliveryInstructions).as("Delivery Instructions")
            .isEqualToIgnoringCase(deliveryInstruction);
      }
      assertions.assertAll();
    });
  }

  @When("Operator confirm manually complete order on Edit Order V2 page:")
  public void operatorManuallyCompleteOrderOnEditOrderPage(Map<String, String> data) {
    var finalData = resolveKeyValues(data);
    page.inFrame(() -> {
      page.manuallyCompleteOrderDialog.waitUntilVisible();
      page.manuallyCompleteOrderDialog.changeReason.selectValue(finalData.get("reason"));
      if (finalData.containsKey("reasonForChange")) {
        page.manuallyCompleteOrderDialog.reasonForChange.setValue(finalData.get("reasonForChange"));
      }
      if (finalData.containsKey("markAll")) {
        page.manuallyCompleteOrderDialog.markAll.click();
      }
      page.manuallyCompleteOrderDialog.completeOrder.click();
    });
  }

  @When("Operator verify 'COD Collected' checkbox is disabled in Manually complete order dialog on Edit Order V2 page")
  public void verifyCodCollectedIsDisabled() {
    page.inFrame(() -> {
      page.manuallyCompleteOrderDialog.waitUntilVisible();
      Assertions.assertThat(page.manuallyCompleteOrderDialog.codCheckboxes.get(0).isEnabled())
          .as("COD Collected checkbox is enabled").isFalse();
    });
  }

  @When("Operator verify Complete order button is disabled in Manually complete order dialog on Edit Order V2 page")
  public void verifyCompleteOrderIsDisabled() {
    page.inFrame(() -> {
      page.manuallyCompleteOrderDialog.waitUntilVisible();
      Assertions.assertThat(page.manuallyCompleteOrderDialog.completeOrder.isEnabled())
          .as("Complete order button is enabled").isFalse();
    });
  }

  @When("Operator confirm manually complete order with COD on Edit Order V2 page")
  public void operatorManuallyCompleteOrderWithCodOnEditOrderPage() {
    page.manuallyCompleteOrderDialog.waitUntilVisible();
    page.manuallyCompleteOrderDialog.changeReason.selectValue("Others (fill in below)");
    page.manuallyCompleteOrderDialog.reasonForChange.setValue("Completed by automated test");
    page.manuallyCompleteOrderDialog.markAll.click();
    page.manuallyCompleteOrderDialog.completeOrder.click();
    page.waitUntilInvisibilityOfToast("The order has been completed", true);
  }

  @When("Operator confirm manually complete order without collecting COD on Edit Order V2 page")
  public void operatorManuallyCompleteOrderWithoutCodOnEditOrderPage() {
    page.manuallyCompleteOrderDialog.waitUntilVisible();
    page.manuallyCompleteOrderDialog.changeReason.selectValue("Others (fill in below)");
    page.manuallyCompleteOrderDialog.reasonForChange.setValue("Completed by automated test");
    page.manuallyCompleteOrderDialog.unmarkAll.click();
    takesScreenshot();
    page.manuallyCompleteOrderDialog.completeOrder.click();
    page.waitUntilInvisibilityOfToast("The order has been completed", true);
  }

  @When("^Operator change Priority Level to \"(\\d+)\" on Edit Order V2 page$")
  public void operatorChangePriorityLevelToOnEditOrderPage(int priorityLevel) {
    page.clickMenu("Order Settings", "Edit Priority Level");
    page.editPriorityLevelDialog.waitUntilVisible();
    page.editPriorityLevelDialog.priorityLevel.setValue(priorityLevel);
    page.editPriorityLevelDialog.saveChanges.click();
  }

  @When("Operator enter {value} Priority Level in Edit priority level dialog on Edit Order V2 page")
  public void enterPriorityLevel(String priorityLevel) {
    page.inFrame(() -> {
      page.editPriorityLevelDialog.waitUntilVisible();
      page.editPriorityLevelDialog.priorityLevel.setValue(priorityLevel);
    });
  }

  @When("Operator verify {value} error message in Edit priority level dialog on Edit Order V2 page")
  public void verifyErrorInEdipPriorityLevel(String error) {
    page.inFrame(() -> {
      page.editPriorityLevelDialog.waitUntilVisible();
      Assertions.assertThat(page.editPriorityLevelDialog.errorMessage.isDisplayed())
          .withFailMessage("Error message is not displayed").isTrue();
      Assertions.assertThat(page.editPriorityLevelDialog.errorMessage.getNormalizedText())
          .as("Error message").isEqualTo(error);
    });
  }

  @When("Operator verify Save changes button is disabled in Edit priority level dialog on Edit Order V2 page")
  public void verifySaveChangesDisabled() {
    page.inFrame(() -> {
      page.editPriorityLevelDialog.waitUntilVisible();
      Assertions.assertThat(page.editPriorityLevelDialog.saveChanges.isEnabled())
          .withFailMessage("Save changes button is not disabled").isFalse();
    });
  }

  @Then("^Operator verify (.+) Priority Level is \"(\\d+)\" on Edit Order V2 page$")
  public void operatorVerifyDeliveryPriorityLevelIsOnEditOrderPage(String txnType,
      int expectedPriorityLevel) {
    page.inFrame(() -> page.verifyPriorityLevel(txnType, expectedPriorityLevel));
  }

  @When("Operator print Airway Bill on Edit Order V2 page")
  public void operatorPrintAirwayBillOnEditOrderPage() {
    page.printAirwayBill();
  }

  @Then("Operator verify the printed Airway bill for single order on Edit Order V2 page contains correct info")
  public void operatorVerifyThePrintedAirwayBillForSingleOrderOnEditOrdersPageContainsCorrectInfo() {
    Order order = get(KEY_CREATED_ORDER);
    page.verifyAirwayBillContentsIsCorrect(order);
  }

  @When("Operator add created order route on Edit Order V2 page using data below:")
  public void operatorAddCreatedOrderToTheRouteOnEditOrderPage(Map<String, String> data) {
    data = resolveKeyValues(data);
    String type = data.get("type");
    String routeId = data.get("routeId");
    page.inFrame(() -> {
      page.addToRouteDialog.waitUntilVisible();
      page.addToRouteDialog.route.setValue(routeId);
      if (StringUtils.isNotBlank(type)) {
        page.addToRouteDialog.type.selectValue(type);
      }
      page.addToRouteDialog.addToRoute.click();
    });
  }

  @Then("Operator verify the order is added to the {string} route on Edit Order V2 page")
  public void operatorVerifyTheOrderIsAddedToTheRouteOnEditOrderPage(String type) {
    switch (type.toUpperCase()) {
      case "DELIVERY":
        page.verifyDeliveryRouteInfo(get(KEY_CREATED_ROUTE));
        takesScreenshot();
        break;
      case "PICKUP":
        page.verifyPickupRouteInfo(get(KEY_CREATED_ROUTE));
        takesScreenshot();
        break;
      default:
        throw new IllegalArgumentException("Unknown route type: " + type);
    }
  }

  @Then("Operator verify order status is {value} on Edit Order V2 page")
  public void operatorVerifyOrderStatusOnEditOrderPage(String expectedValue) {
    page.inFrame(() -> Assertions.assertThat(page.status.getText()).as("Status")
        .isEqualToIgnoringCase(expectedValue));
  }

  @Then("Operator verify Current priority is {value} on Edit Order V2 page")
  public void operatorVerifyCurrentPriority(String expectedValue) {
    page.inFrame(() -> {
      page.waitUntilLoaded();
      Assertions.assertThat(page.currentPriority.getNormalizedText()).as("Current priority")
          .isEqualTo(expectedValue);
    });
  }

  @Then("^Operator verify Current DNR Group is \"(.+)\" on Edit Order V2 page$")
  public void operatorVerifyCurrentDnrGroupOnEditOrderPage(String expected) {
    expected = resolveValue(expected);
    String actual = page.currentDnrGroup.getText();
    Assertions.assertThat(actual).as("Current DNR Group").isEqualToIgnoringCase(expected);
  }

  @Then("Operator verify order granular status is {value} on Edit Order V2 page")
  public void operatorVerifyOrderGranularStatusOnEditOrderPage(String expectedValue) {
    page.inFrame(() -> Assertions.assertThat(page.granular.getText()).as("Granular Status")
        .isEqualToIgnoringCase(expectedValue));
  }

  @Then("^Operator verify order delivery title is \"(.+)\" on Edit Order V2 page$")
  public void operatorVerifyOrderDeliveryTitleOnEditOrderPage(String expectedValue) {
    page.verifyOrderDeliveryTitle(expectedValue);
  }

  @Then("^Operator verify RTS event displayed on Edit Order V2 page with following properties:$")
  public void operatorVerifyRtsEventOnEditOrderPage(Map<String, String> mapOfData) {
    Map<String, String> mapOfTokens = StandardTestUtils.createDefaultTokens();
    mapOfData = StandardTestUtils.replaceDataTableTokens(mapOfData, mapOfTokens);

    OrderEvent orderEvent = page.eventsTable().filterByColumn(EVENT_NAME, "RTS").readEntity(1);
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

  @When("^Operator change Stamp ID of the created order to \"(.+)\" on Edit Order V2 page$")
  public void operatorEditStampIdOnEditOrderPage(String stampId) {
    if (equalsIgnoreCase(stampId, "GENERATED")) {
      stampId = "NVSGSTAMP" + TestUtils.generateAlphaNumericString(7).toUpperCase();
    }
    String finalStampId = stampId;
    page.inFrame(() -> {
      page.editOrderStamp(finalStampId);
      Order order = get(KEY_CREATED_ORDER);
      if (order != null) {
        order.setStampId(finalStampId);
      } else {
        List<co.nvqa.common.core.model.order.Order> orders = get(KEY_LIST_OF_CREATED_ORDERS);
        if (CollectionUtils.isNotEmpty(orders)) {
          orders.get(0).setStampId(finalStampId);
        }
      }
      put(KEY_STAMP_ID, finalStampId);
    });
  }

  @When("^Operator unable to change Stamp ID of the created order to \"(.+)\" on Edit Order V2 page$")
  public void operatorUnableToEditStampIdToExistingOnEditOrderPage(String stampId) {
        /*
          Replace searchTerm value to value on ScenarioStorage.
         */
    String trackingIdOfExistingOrder = get(KEY_TRACKING_ID_BY_ACCESSING_STAMP_ID);
    page.editOrderStampToExisting(resolveValue(stampId), trackingIdOfExistingOrder);
  }

  @When("^Operator remove Stamp ID of the created order on Edit Order V2 page$")
  public void operatorRemoveStampIdOnEditOrderPage() {
    page.inFrame(() -> {
      page.clickMenu("Order Settings", "Edit Order Stamp");
      page.editOrderStampDialog.waitUntilVisible();
      page.editOrderStampDialog.remove.click();
      page.waitUntilInvisibilityOfToast("Stamp ID removed successfully", true);
    });
  }

  @When("Operator update order status on Edit Order V2 page:")
  public void operatorUpdateStatusOnEditOrderPage(Map<String, String> data) {
    var finalData = resolveKeyValues(data);
    page.inFrame(() -> {
      page.clickMenu("Order settings", "Update status");
      page.updateStatusDialog.waitUntilVisible();
      String value = finalData.get("granularStatus");
      page.updateStatusDialog.granularStatus.selectValue(value);
      value = finalData.get("changeReason");
      page.updateStatusDialog.changeReason.setValue(value);
      page.updateStatusDialog.saveChanges.click();
    });
  }

  @Then("^Operator verify color of order header on Edit Order V2 page is \"(.+)\"$")
  public void operatorVerifyColorOfOrderHeaderOnEditOrderPage(String color) {
    switch (color.toLowerCase()) {
      case "green":
        color = "rgba(28, 111, 52, 1)";
        break;
      case "red":
        color = "rgba(193, 36, 68, 1)";
        break;
    }
    page.verifyOrderHeaderColor(color);
    takesScreenshot();
  }

  @Then("Operator verifies event is present for order id {string} on Edit Order V2 page")
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
          page.verifyEvent(order, hubName, hubId, event, descriptionString);
          return;
        }
        page.verifyEvent(order, hubName, hubId, event, "Scanned");
        return;
      }
    }
    takesScreenshot();
  }

  @Then("Operator verifies event is present for order on Edit Order V2 page")
  public void operatorVerifiesEventIsPresentOnEditOrderPage(Map<String, String> mapOfData) {
    Map<String, String> map = resolveKeyValues(mapOfData);
    String event = map.get("eventName");
    String hubName = map.get("hubName");
    String hubId = map.get("hubId");
    String descriptionString = map.get("descriptionString");
    List<Order> lists = get(KEY_LIST_OF_CREATED_ORDER);

    lists.forEach(order -> {
      navigateTo(
          f("%s/%s/order/%d", TestConstants.OPERATOR_PORTAL_BASE_URL, TestConstants.NV_SYSTEM_ID,
              order.getId()));
      if (descriptionString != null) {
        page.verifyEvent(order, hubName, hubId, event, descriptionString);
        return;
      }
      takesScreenshot();
      page.verifyEvent(order, hubName, hubId, event, "Scanned");
    });
  }

  @Then("^Operator cancel order on Edit Order V2 page using data below:$")
  public void operatorCancelOrderOnEditOrderPage(Map<String, String> mapOfData) {
    String cancellationReason = mapOfData.get("cancellationReason");
    page.inFrame(() -> {
      page.clickMenu("Order Settings", "Cancel Order");
      page.cancelOrderDialog.waitUntilVisible();
      page.cancelOrderDialog.cancellationReason.setValue(cancellationReason);
      page.cancelOrderDialog.cancelOrder.click();
    });
    put(KEY_CANCELLATION_REASON, cancellationReason);
  }

  @And("Operator does the Manually Complete Order from Edit Order V2 page")
  public void operatorDoesTheManuallyCompleteOrderFromEditOrderPage() {
    page.manuallyCompleteOrder();
  }

  @And("^Operator selects the Route Tags of \"([^\"]*)\" from the Route Finder on Edit Order V2 page$")
  public void operatorSelectTheRouteTagsOfFromTheRouteFinder(String routeTag) {
    page.clickMenu("Delivery", "Add To Route");
    page.addToRouteDialog.waitUntilVisible();
    page.addToRouteDialog.routeTags.selectValues(ImmutableList.of(resolveValue(routeTag)));
    page.addToRouteDialog.suggestRoute.clickAndWaitUntilDone();
    if (page.toastErrors.size() > 0) {
      Assertions.fail(f("Error on attempt to suggest routes: %s",
          page.toastErrors.get(0).toastBottom.getText()));
    }
    page.addToRouteDialog.addToRoute.click();
    page.addToRouteDialog.waitUntilInvisible();
    page.waitUntilInvisibilityOfToast(true);
  }

  @And("Operator suggest route of {string} tag from the Route Finder on Edit Order V2 page")
  public void operatorSuggestRouteFromTheRouteFinder(String routeTag) {
    page.addToRouteDialog.waitUntilVisible();
    page.addToRouteDialog.routeTags.selectValues(ImmutableList.of(resolveValue(routeTag)));
    takesScreenshot();
    page.addToRouteDialog.suggestRoute.clickAndWaitUntilDone();
  }

  @And("Operator verify Route value is {string} in Add To Route dialog on Edit Order V2 page")
  public void operatorVerifyRouteValue(String expected) {
    Assertions.assertThat(page.addToRouteDialog.route.getValue()).as("Route value")
        .isEqualTo(resolveValue(expected));
  }

  @Then("^Operator verify order event on Edit Order V2 page using data below:$")
  public void operatorVerifyOrderEventOnEditOrderPage(Map<String, String> mapOfData) {
    page.inFrame(() -> {
      page.waitUntilLoaded();
      OrderEvent expectedEvent = new OrderEvent(resolveKeyValues(mapOfData));
      OrderEvent actualEvent = page.eventsTable().readAllEntities().stream()
          .filter(event -> equalsIgnoreCase(event.getName(), expectedEvent.getName())).findFirst()
          .orElse(null);
      if (actualEvent == null) {
        pause5s();
        page.refreshPage();
        page.switchTo();
        actualEvent = page.eventsTable().readAllEntities().stream()
            .filter(event -> equalsIgnoreCase(event.getName(), expectedEvent.getName())).findFirst()
            .orElse(null);
      }
      Assertions.assertThat(actualEvent)
          .withFailMessage("There is no [%s] event on Edit Order V2 page", expectedEvent.getName())
          .isNotNull();

      expectedEvent.compareWithActual(actualEvent);
    });
  }

  @Then("^Operator verify order events on Edit Order V2 page using data below:$")
  public void operatorVerifyOrderEventsOnEditOrderPage(List<Map<String, String>> data) {
    page.inFrame(() -> data.forEach(eventData -> {
      OrderEvent expectedEvent = new OrderEvent(resolveKeyValues(eventData));
      OrderEvent actualEvent = page.eventsTable().readAllEntities().stream()
          .filter(event -> equalsIgnoreCase(event.getName(), expectedEvent.getName())).findFirst()
          .orElse(null);
      if (actualEvent == null) {
        pause5s();
        page.refreshPage();
        page.switchTo();
        actualEvent = page.eventsTable().readAllEntities().stream()
            .filter(event -> equalsIgnoreCase(event.getName(), expectedEvent.getName())).findFirst()
            .orElse(null);
      }
      Assertions.assertThat(actualEvent)
          .withFailMessage("There is no [%s] event on Edit Order V2 page", expectedEvent.getName())
          .isNotNull();
      expectedEvent.compareWithActual(actualEvent);
    }));
  }

  @Then("Operator verify order events are not presented on Edit Order V2 page:")
  public void operatorVerifyOrderEventsNotPresentedOnEditOrderPage(List<String> data) {
    List<OrderEvent> events = page.eventsTable().readAllEntities();
    data = resolveValues(data);
    SoftAssertions assertions = new SoftAssertions();
    data.forEach(expected -> assertions.assertThat(
            events.stream().anyMatch(e -> equalsIgnoreCase(e.getName(), expected)))
        .as("%s event was found").isFalse());
    assertions.assertAll();
    takesScreenshot();
  }

  @Then("Operator unmask Delivery details on Edit Order V2 page")
  public void unmaskDeliveryDetails() {
    page.inFrame(() -> {
      while (page.deliveryDetailsBox.mask.isDisplayedFast()) {
        page.deliveryDetailsBox.mask.click();
        page.waitUntilLoaded();
      }
    });
  }

  @Then("^Operator verify Delivery details on Edit Order V2 page using data below:$")
  public void verifyDeliveryDetails(Map<String, String> data) throws ParseException {
    Map<String, String> expectedData = StandardTestUtils.replaceDataTableTokens(
        resolveKeyValues(data));

    page.inFrame(() -> {
      SoftAssertions assertions = new SoftAssertions();
      if (expectedData.containsKey("status")) {
        assertions.assertThat(page.deliveryDetailsBox.status.getText())
            .as("Delivery Details - Status").isEqualTo(f("Status: %s", expectedData.get("status")));
      }
      if (expectedData.containsKey("name")) {
        assertions.assertThat(page.deliveryDetailsBox.to.getNormalizedText())
            .as("Delivery Details - Name")
            .isEqualToIgnoringCase(StringUtils.normalizeSpace(expectedData.get("name")));
      }
      if (expectedData.containsKey("contact")) {
        assertions.assertThat(page.deliveryDetailsBox.toContact.getNormalizedText())
            .as("Delivery Details - Contact")
            .isEqualToIgnoringCase(StringUtils.normalizeSpace(expectedData.get("contact")));
      }
      if (expectedData.containsKey("email")) {
        assertions.assertThat(page.deliveryDetailsBox.toEmail.getNormalizedText())
            .as("Delivery Details - Email")
            .isEqualToIgnoringCase(StringUtils.normalizeSpace(expectedData.get("email")));
      }
      if (expectedData.containsKey("address")) {
        assertions.assertThat(page.deliveryDetailsBox.toAddress.getNormalizedText())
            .as("Delivery Details - address")
            .isEqualToIgnoringCase(StringUtils.normalizeSpace(expectedData.get("address")));
      }
      if (expectedData.containsKey("startDate")) {
        String actual = page.deliveryDetailsBox.startDateTime.getText();
        Date actualDateTime = Date.from(DateUtil.getDate(actual,
            DateUtil.DATE_TIME_FORMATTER.withZone(
                ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE))).toInstant());
        Date expectedDateTime = null;
        try {
          expectedDateTime = DateUtil.SDF_YYYY_MM_DD.parse(expectedData.get("startDate"));
        } catch (ParseException e) {
          throw new RuntimeException(e);
        }
        Assertions.assertThat(actualDateTime).as("Delivery Details - Start Date / Time")
            .isInSameDayAs(expectedDateTime);
      }
      if (expectedData.containsKey("startDateTime")) {
        String actual = page.deliveryDetailsBox.startDateTime.getText();
        Date actualDateTime = Date.from(DateUtil.getDate(actual,
            DateUtil.DATE_TIME_FORMATTER.withZone(
                ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE))).toInstant());
        Date expectedDateTime = null;
        try {
          expectedDateTime = DateUtil.SDF_YYYY_MM_DD_HH_MM_SS.parse(
              expectedData.get("startDateTime"));
        } catch (ParseException e) {
          throw new RuntimeException(e);
        }
        Assertions.assertThat(actualDateTime).as("Delivery Details - Start Date / Time")
            .isInSameSecondAs(expectedDateTime);
      }
      if (expectedData.containsKey("endDate")) {
        String actual = page.deliveryDetailsBox.endDateTime.getText();
        Date actualDateTime = Date.from(DateUtil.getDate(actual,
            DateUtil.DATE_TIME_FORMATTER.withZone(
                ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE))).toInstant());
        Date expectedDateTime = null;
        try {
          expectedDateTime = DateUtil.SDF_YYYY_MM_DD.parse(expectedData.get("endDate"));
        } catch (ParseException e) {
          throw new RuntimeException(e);
        }
        Assertions.assertThat(actualDateTime).as("Delivery Details - End Date / Time")
            .isInSameDayAs(expectedDateTime);
      }
      if (expectedData.containsKey("endDateTime")) {
        String actual = page.deliveryDetailsBox.endDateTime.getText();
        Date actualDateTime = Date.from(DateUtil.getDate(actual,
            DateUtil.DATE_TIME_FORMATTER.withZone(
                ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE))).toInstant());
        Date expectedDateTime = null;
        try {
          expectedDateTime = DateUtil.SDF_YYYY_MM_DD_HH_MM_SS.parse(
              expectedData.get("endDateTime"));
        } catch (ParseException e) {
          throw new RuntimeException(e);
        }
        Assertions.assertThat(actualDateTime).as("Delivery Details - End Date / Time")
            .isInSameSecondAs(expectedDateTime);
      }
      assertions.assertAll();
    });
  }

  @Then("Operator unmask Edit Order V2 page")
  public void unmaskPage() {
    page.inFrame(() -> {
      while (page.mask.existsFast()) {
        page.mask.scrollIntoView();
        page.mask.jsClick();
        page.waitUntilLoaded(1);
      }
    });
  }

  @Then("Operator verify Pickup details on Edit Order V2 page using data below:")
  public void verifyPickupDetails(Map<String, String> data) throws ParseException {
    Map<String, String> expectedData = StandardTestUtils.replaceDataTableTokens(
        resolveKeyValues(data));

    page.inFrame(() -> {
      SoftAssertions assertions = new SoftAssertions();
      if (expectedData.containsKey("status")) {
        assertions.assertThat(page.pickupDetailsBox.status.getText()).as("Pickup Details - Status")
            .isEqualTo(f("Status: %s", expectedData.get("status")));
      }
      if (expectedData.containsKey("name")) {
        assertions.assertThat(page.pickupDetailsBox.from.getNormalizedText())
            .as("Pickup Details - Name")
            .isEqualToIgnoringCase(StringUtils.normalizeSpace(expectedData.get("name")));
      }
      if (expectedData.containsKey("contact")) {
        assertions.assertThat(page.pickupDetailsBox.fromContact.getNormalizedText())
            .as("Pickup Details - Contact")
            .isEqualToIgnoringCase(StringUtils.normalizeSpace(expectedData.get("contact")));
      }
      if (expectedData.containsKey("email")) {
        assertions.assertThat(page.pickupDetailsBox.fromEmail.getNormalizedText())
            .as("Pickup Details - Email")
            .isEqualToIgnoringCase(StringUtils.normalizeSpace(expectedData.get("email")));
      }
      if (expectedData.containsKey("address")) {
        assertions.assertThat(page.pickupDetailsBox.fromAddress.getNormalizedText())
            .as("Pickup Details - address")
            .isEqualToIgnoringCase(StringUtils.normalizeSpace(expectedData.get("address")));
      }
      if (expectedData.containsKey("startDate")) {
        String actual = page.pickupDetailsBox.startDateTime.getText();
        Date actualDateTime = Date.from(DateUtil.getDate(actual,
            DateUtil.DATE_TIME_FORMATTER.withZone(
                ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE))).toInstant());
        Date expectedDateTime = null;
        try {
          expectedDateTime = DateUtil.SDF_YYYY_MM_DD.parse(expectedData.get("startDate"));
        } catch (ParseException e) {
          throw new RuntimeException(e);
        }
        Assertions.assertThat(actualDateTime).as("Pickup Details - Start Date / Time")
            .isInSameDayAs(expectedDateTime);
      }
      if (expectedData.containsKey("startDateTime")) {
        String actual = page.pickupDetailsBox.startDateTime.getText();
        Date actualDateTime = Date.from(DateUtil.getDate(actual,
            DateUtil.DATE_TIME_FORMATTER.withZone(
                ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE))).toInstant());
        Date expectedDateTime;
        try {
          expectedDateTime = DateUtil.SDF_YYYY_MM_DD_HH_MM_SS.parse(
              expectedData.get("startDateTime"));
        } catch (ParseException e) {
          throw new RuntimeException(e);
        }
        Assertions.assertThat(actualDateTime).as("Pickup Details - Start Date / Time")
            .isInSameSecondAs(expectedDateTime);
      }
      if (expectedData.containsKey("endDate")) {
        String actual = page.pickupDetailsBox.endDateTime.getText();
        Date actualDateTime = Date.from(DateUtil.getDate(actual,
            DateUtil.DATE_TIME_FORMATTER.withZone(
                ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE))).toInstant());
        Date expectedDateTime;
        try {
          expectedDateTime = DateUtil.SDF_YYYY_MM_DD.parse(expectedData.get("endDate"));
        } catch (ParseException e) {
          throw new RuntimeException(e);
        }
        Assertions.assertThat(actualDateTime).as("Pickup Details - End Date / Time")
            .isInSameDayAs(expectedDateTime);
      }
      if (expectedData.containsKey("endDateTime")) {
        String actual = page.pickupDetailsBox.endDateTime.getText();
        Date actualDateTime = Date.from(DateUtil.getDate(actual,
            DateUtil.DATE_TIME_FORMATTER.withZone(
                ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE))).toInstant());
        Date expectedDateTime = null;
        try {
          expectedDateTime = DateUtil.SDF_YYYY_MM_DD_HH_MM_SS.parse(
              expectedData.get("endDateTime"));
        } catch (ParseException e) {
          throw new RuntimeException(e);
        }
        Assertions.assertThat(actualDateTime).as("Pickup Details - End Date / Time")
            .isInSameSecondAs(expectedDateTime);
      }
      assertions.assertAll();
    });
  }

  @Then("^Operator verify (Pickup|Delivery) \"(.+)\" order event description on Edit Order V2 page$")
  public void operatorVerifyOrderEventOnEditOrderPage(String type, String expectedEventName) {
    final Order order = get(KEY_CREATED_ORDER);
    final List<OrderEvent> events = page.eventsTable().readAllEntities();
    final OrderEvent actualEvent = events.stream()
        .filter(event -> equalsIgnoreCase(event.getName(), expectedEventName)).findFirst()
        .orElseThrow(() -> new AssertionError(
            f("There is no [%s] event on Edit Order V2 page", expectedEventName)));
    final String eventDescription = actualEvent.getDescription();
    if (equalsIgnoreCase(type, "Pickup")) {
      if (equalsIgnoreCase(expectedEventName, "UPDATE ADDRESS")) {
        page.eventsTable().verifyUpdatePickupAddressEventDescription(order, eventDescription);
      }
      if (equalsIgnoreCase(expectedEventName, "UPDATE CONTACT INFORMATION")) {
        page.eventsTable()
            .verifyUpdatePickupContactInformationEventDescription(order, eventDescription);
      }
      if (equalsIgnoreCase(expectedEventName, "UPDATE SLA")) {
        page.eventsTable().verifyUpdatePickupSlaEventDescription(order, eventDescription);
      }
      if (equalsIgnoreCase(expectedEventName, "VERIFY ADDRESS")) {
        page.eventsTable().verifyPickupAddressEventDescription(order, eventDescription);
      }
    } else {
      if (equalsIgnoreCase(expectedEventName, "UPDATE ADDRESS")) {
        page.eventsTable().verifyUpdateDeliveryAddressEventDescription(order, eventDescription);
      }
      if (equalsIgnoreCase(expectedEventName, "UPDATE CONTACT INFORMATION")) {
        page.eventsTable()
            .verifyUpdateDeliveryContactInformationEventDescription(order, eventDescription);
      }
      if (equalsIgnoreCase(expectedEventName, "UPDATE SLA")) {
        page.eventsTable().verifyUpdateDeliverySlaEventDescription(order, eventDescription);
      }
      if (equalsIgnoreCase(expectedEventName, "VERIFY ADDRESS")) {
        page.eventsTable().verifyDeliveryAddressEventDescription(order, eventDescription);
      }
      if (equalsIgnoreCase(expectedEventName, "HUB INBOUND SCAN")) {
        page.eventsTable().verifyHubInboundWithDeviceIdEventDescription(order, eventDescription);
      }
    }
    takesScreenshot();
  }

  @Then("Operator verify {word} transaction on Edit Order V2 page using data below:")
  public void operatorVerifyTransactionOnEditOrderPage(String transactionType,
      Map<String, String> data) {
    int rowIndex = transactionType.equalsIgnoreCase("Delivery") ? 2 : 1;

    var expected = new TransactionInfo(resolveKeyValues(data));
    page.inFrame(() -> {
      TransactionInfo actual = page.transactionsTable.readEntity(rowIndex);
      expected.compareWithActual(actual);
    });
  }

  @Then("Operator unmask contact number of {word} transaction on Edit Order V2 page")
  public void operatorUnmastTransactionContact(String transactionType) {
    int rowIndex = transactionType.equalsIgnoreCase("Delivery") ? 2 : 1;
    page.inFrame(() -> {
      page.transactionsTable.unmaskColumn(rowIndex, "contact");
      page.waitUntilLoaded();
    });
  }

  @Then("Operator unmask destination address of {word} transaction on Edit Order V2 page")
  public void operatorUnmastTransactionAddress(String transactionType) {
    int rowIndex = transactionType.equalsIgnoreCase("Delivery") ? 2 : 1;
    page.inFrame(() -> {
      page.transactionsTable.unmaskColumn(rowIndex, "destinationAddress");
    });
  }

  @Then("Operator unmask description of {value} event on Edit Order V2 page")
  public void operatorUnmaskEventDescription(String event) {
    page.inFrame(() -> {
      int index = page.eventsTable.findEventRow(event);
      Assertions.assertThat(index).withFailMessage("Event %s is not displayed", event).isPositive();
      page.eventsTable.unmaskColumn(index, EventsTable.DESCRIPTION);
      page.waitUntilLoaded();
    });
  }

  @Then("Operator verify transaction on Edit Order V2 page using data below:")
  public void operatorVerifyTransactionOnEditOrderPage(Map<String, String> data) {
    page.inFrame(() -> {
      final TransactionInfo expected = new TransactionInfo(resolveKeyValues(data));
      final List<TransactionInfo> transactions = page.transactionsTable.readAllEntities();
      DataEntity.assertListContains(transactions, expected, "Transactions");
    });
  }

  @Then("Operator verify order summary on Edit Order V2 page using data below:")
  public void operatorVerifyOrderSummaryOnEditOrderPage(Map<String, String> mapOfData) {
    final Order expectedOrder = new Order(resolveKeyValues(mapOfData));
    page.inFrame(
        () -> Assertions.assertThat(page.comments.getNormalizedText()).as("Order Summary: Comments")
            .isEqualTo(expectedOrder.getComments()));
  }

  @Then("^Operator verify menu item \"(.+)\" > \"(.+)\" is disabled on Edit Order V2 page$")
  public void operatorVerifyMenuItemIsDisabledOnEditOrderPage(String parentMenuItem,
      String childMenuItem) {
    page.inFrame(() -> Assertions.assertThat(page.isMenuItemEnabled(parentMenuItem, childMenuItem))
        .as("%s > %s menu item is enabled", parentMenuItem, childMenuItem).isFalse());
  }

  @Then("Operator verifies Pickup Details are updated on Edit Order V2 page")
  public void operatorVerifiesPickupDetailsUpdated() {
    Order order = get(KEY_CREATED_ORDER);
    page.verifyPickupInfo(order);
  }

  @Then("Operator verifies Delivery Details are updated on Edit Order V2 page")
  public void operatorVerifiesDeliveryDetailsUpdated() {
    Order order = get(KEY_CREATED_ORDER);
    page.verifyDeliveryInfo(order);
  }

  @Then("Operator edit delivery details on Edit Order V2 page:")
  @Then("Operator update delivery reschedule on Edit Order V2 page:")
  @Then("Operator reschedule Delivery on Edit Order V2 page:")
  @Then("Operator edit Return details on Edit Order V2 page:")
  public void editDeliveryDetails(Map<String, String> data) {
    var finalData = resolveKeyValues(data);
    page.inFrame(() -> {
      page.editDeliveryDetailsDialog.waitUntilVisible();
      if (finalData.containsKey("recipientName")) {
        page.editDeliveryDetailsDialog.recipientName.setValue(finalData.get("recipientName"));
      }
      if (finalData.containsKey("recipientContact")) {
        if (page.editDeliveryDetailsDialog.recipientContactCtr.isDisplayedFast()) {
          page.editDeliveryDetailsDialog.recipientContactCtr.click();
          page.waitUntilLoaded();
        }
        page.editDeliveryDetailsDialog.recipientContact.setValue(finalData.get("recipientContact"));
      }
      if (finalData.containsKey("recipientEmail")) {
        page.editDeliveryDetailsDialog.recipientEmail.setValue(finalData.get("recipientEmail"));
      }
      var value = finalData.get("internalNotes");
      if (StringUtils.isNotBlank(value)) {
        page.editDeliveryDetailsDialog.internalNotes.setValue(value);
      }
      value = finalData.get("deliveryDate");
      if (StringUtils.isNotBlank(value)) {
        if (page.editDeliveryDetailsDialog.schedule.existsFast()) {
          page.editDeliveryDetailsDialog.schedule.check();
          pause1s();
        }
        page.editDeliveryDetailsDialog.deliveryDate.setValue(value);
      }
      value = finalData.get("timeslot");
      if (StringUtils.isNotBlank(value)) {
        page.editDeliveryDetailsDialog.timeslot.selectValue(value);
      }
      value = finalData.get("country");
      if (StringUtils.isNotBlank(value)) {
        page.editDeliveryDetailsDialog.changeAddress.click();
        page.editDeliveryDetailsDialog.country.setValue(value);
      }
      value = finalData.get("city");
      if (StringUtils.isNotBlank(value)) {
        page.editDeliveryDetailsDialog.city.setValue(value);
      }
      value = finalData.get("address1");
      if (StringUtils.isNotBlank(value)) {
        page.editDeliveryDetailsDialog.address1.setValue(value);
      }
      value = finalData.get("address2");
      if (StringUtils.isNotBlank(value)) {
        page.editDeliveryDetailsDialog.address2.setValue(value);
      }
      value = finalData.get("postalCode");
      if (StringUtils.isNotBlank(value)) {
        page.editDeliveryDetailsDialog.postcode.setValue(value);
      }
      if (page.editDeliveryDetailsDialog.saveChanges.isDisplayedFast()) {
        page.editDeliveryDetailsDialog.saveChanges.click();
      } else {
        page.editDeliveryDetailsDialog.rescheduleSaveChanges.click();
      }
    });
  }

  @Then("Operator verify values in Edit return details dialog on Edit Order V2 page:")
  @Then("Operator verify values in Edit delivery details dialog on Edit Order V2 page:")
  @Then("Operator verify values in Delivery reschedule dialog on Edit Order V2 page:")
  public void verifyDeliveryDetailsDetails(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    SoftAssertions assertions = new SoftAssertions();
    page.inFrame(() -> {
      page.editDeliveryDetailsDialog.waitUntilVisible();

      String value = finalData.get("recipientName");
      if (StringUtils.isNotBlank(value)) {
        assertions.assertThat(page.editDeliveryDetailsDialog.recipientName.getValue())
            .as("Recipient name").isEqualTo(value);
      }
      value = finalData.get("recipientContact");
      if (StringUtils.isNotBlank(value)) {
        var actual = page.editDeliveryDetailsDialog.recipientContactText.isDisplayedFast()
            ? page.editDeliveryDetailsDialog.recipientContactText.getNormalizedText()
            : page.editDeliveryDetailsDialog.recipientContact.getValue();
        assertions.assertThat(actual).as("Recipient contact").isEqualTo(value);
      }
      value = finalData.get("recipientEmail");
      if (StringUtils.isNotBlank(value)) {
        assertions.assertThat(page.editDeliveryDetailsDialog.recipientEmail.getValue())
            .as("Recipient email").isEqualTo(value);
      }
      value = finalData.get("country");
      if (StringUtils.isNotBlank(value)) {
        assertions.assertThat(page.editDeliveryDetailsDialog.currentCountry.getNormalizedText())
            .as("Country").isEqualTo(value);
      }
      value = finalData.get("city");
      if (StringUtils.isNotBlank(value)) {
        assertions.assertThat(page.editDeliveryDetailsDialog.currentCity.getNormalizedText())
            .as("City").isEqualTo(value);
      }
      value = finalData.get("address1");
      if (StringUtils.isNotBlank(value)) {
        assertions.assertThat(page.editDeliveryDetailsDialog.currentAddress1.getNormalizedText())
            .as("Address 1").isEqualTo(value);
      }
      value = finalData.get("address2");
      if (StringUtils.isNotBlank(value)) {
        assertions.assertThat(page.editDeliveryDetailsDialog.currentAddress2.getNormalizedText())
            .as("Address 2").isEqualTo(value);
      }
      value = finalData.get("postalCode");
      if (StringUtils.isNotBlank(value)) {
        assertions.assertThat(page.editDeliveryDetailsDialog.currentPostcode.getNormalizedText())
            .as("Postal code").isEqualTo(value);
      }
      assertions.assertAll();
    });
  }

  @Then("Operator edit pickup details on Edit Order V2 page:")
  @Then("Operator reschedule Pickup on Edit Order V2 page:")
  public void editPickupDetails(Map<String, String> data) {
    var finalData = resolveKeyValues(data);
    page.inFrame(() -> {
      page.editPickupDetailsDialog.waitUntilVisible();
      if (finalData.containsKey("senderName")) {
        page.editPickupDetailsDialog.senderName.setValue(finalData.get("senderName"));
      }
      if (finalData.containsKey("senderContact")) {
        page.editPickupDetailsDialog.senderContact.setValue(finalData.get("senderContact"));
      }
      if (finalData.containsKey("senderEmail")) {
        page.editPickupDetailsDialog.senderEmail.setValue(finalData.get("senderEmail"));
      }
      var value = finalData.get("internalNotes");
      if (StringUtils.isNotBlank(value)) {
        page.editPickupDetailsDialog.internalNotes.setValue(value);
      }
      value = finalData.get("pickupDate");
      if (StringUtils.isNotBlank(value)) {
        page.editPickupDetailsDialog.pickupDate.setDate(value);
      }
      value = finalData.get("timeslot");
      if (StringUtils.isNotBlank(value)) {
        page.editPickupDetailsDialog.timeslot.selectValue(value);
      }
      value = finalData.get("shipperRequestedToChange");
      if (StringUtils.isNotBlank(value)) {
        page.editPickupDetailsDialog.shipperRequestedToChange.setValue(Boolean.parseBoolean(value));
      }
      value = finalData.get("assignPickupLocation");
      if (StringUtils.isNotBlank(value)) {
        page.editPickupDetailsDialog.assignPickupLocation.setValue(Boolean.parseBoolean(value));
      }
      value = finalData.get("country");
      if (StringUtils.isNotBlank(value)) {
        page.editPickupDetailsDialog.changeAddress.click();
        page.editPickupDetailsDialog.country.setValue(value);
      }
      value = finalData.get("city");
      if (StringUtils.isNotBlank(value)) {
        page.editPickupDetailsDialog.city.setValue(value);
      }
      value = finalData.get("address1");
      if (StringUtils.isNotBlank(value)) {
        page.editPickupDetailsDialog.address1.setValue(value);
      }
      value = finalData.get("address2");
      if (StringUtils.isNotBlank(value)) {
        page.editPickupDetailsDialog.address2.setValue(value);
      }
      value = finalData.get("postalCode");
      if (StringUtils.isNotBlank(value)) {
        page.editPickupDetailsDialog.postcode.setValue(value);
      }
      if (page.editPickupDetailsDialog.saveChanges.existsFast()) {
        page.editPickupDetailsDialog.saveChanges.click();
      } else {
        page.editPickupDetailsDialog.rescheduleSaveChanges.click();
      }
    });
  }

  @Then("Operator verifies Delivery Details on Edit Order V2 page:")
  public void operatorVerifiesDeliveryDetailsUpdated(Map<String, String> data) {
    Order order = new Order(resolveKeyValues(data));
    page.verifyDeliveryInfo(order);
  }

  @Then("^Operator verifies (Pickup|Delivery) Transaction is updated on Edit Order V2 page$")
  public void operatorVerifiesTransactionUpdated(String txnType) {
    Order order = get(KEY_CREATED_ORDER);
    if (equalsIgnoreCase(txnType, "Pickup")) {
      page.verifyPickupDetailsInTransaction(order, txnType);
    } else {
      page.verifyDeliveryDetailsInTransaction(order, txnType);
    }
    takesScreenshot();
  }

  @Then("^Operator tags order to \"(.+)\" DP on Edit Order V2 page$")
  public void operatorTagOrderToDP(String dpId) {
    page.inFrame(() -> {
      page.dpDropOffSettingDialog.waitUntilVisible();
      page.waitUntilLoaded();
      page.dpDropOffSettingDialog.dropOffDp.selectValue(dpId);
      page.dpDropOffSettingDialog.saveChanges.click();
    });
  }

  @Then("Operator untags order from DP on Edit Order V2 page")
  public void operatorUnTagOrderFromDP() {
    page.inFrame(() -> {
      page.dpDropOffSettingDialog.waitUntilVisible();
      page.dpDropOffSettingDialog.dropOffDp.clearValue();
      page.dpDropOffSettingDialog.saveChanges.click();
    });
  }

  @Then("^Operator verifies delivery (is|is not) indicated by 'Ninja Collect' icon on Edit Order V2 page$")
  public void deliveryIsIndicatedByIcon(String indicationValue) {
    page.inFrame(() -> {
      if (Objects.equals(indicationValue, "is")) {
        Assertions.assertThat(page.deliveryDetailsBox.ninjaCollectTag.isDisplayedFast())
            .as("Expected that Delivery is indicated by 'Ninja Collect' icon on Edit Order V2 page")
            .isTrue();
      } else if (Objects.equals(indicationValue, "is not")) {
        Assertions.assertThat(page.deliveryDetailsBox.ninjaCollectTag.isDisplayedFast())
            .as("Expected that Delivery is not indicated by 'Ninja Collect' icon on Edit Order V2 page")
            .isFalse();
      }
    });
  }

  @Then("Operator delete order on Edit Order V2 page")
  public void operatorDeleteOrder() {
    page.inFrame(() -> {
      page.menuBar.selectOption("Order settings", "Delete order");
      page.deleteOrderDialog.waitUntilVisible();
      page.deleteOrderDialog.password.setValue("1234567890");
      page.deleteOrderDialog.deleteOrder.click();
    });
  }

  @Then("Operator delete order on Edit Order V2 page with invalid password")
  public void operatorDeleteOrderInvalidPassword() {
    page.inFrame(() -> {
      page.menuBar.selectOption("Order settings", "Delete order");
      page.deleteOrderDialog.waitUntilVisible();
      page.deleteOrderDialog.password.setValue("wrong");
      page.deleteOrderDialog.deleteOrder.click();
    });
  }

  @Then("Operator reschedule Pickup on Edit Order V2 page with address changes")
  public void operatorReschedulePickupWithAddressChangeOnEditOrderPage(
      Map<String, String> mapOfData) {
    Map<String, String> mapOfTokens = StandardTestUtils.createDefaultTokens();
    mapOfData = StandardTestUtils.replaceDataTableTokens(mapOfData, mapOfTokens);
    page.reschedulePickupWithAddressChanges(mapOfData);
    takesScreenshot();
  }

  @Then("Operator reschedule Pickup on Edit Order V2 page")
  public void operatorReschedulePickupOnEditOrderPage(Map<String, String> mapOfData) {
    Map<String, String> mapOfTokens = StandardTestUtils.createDefaultTokens();
    mapOfData = StandardTestUtils.replaceDataTableTokens(mapOfData, mapOfTokens);
    page.reschedulePickup(mapOfData);
    takesScreenshot();
  }

  @Then("Operator reschedule Delivery on Edit Order V2 page with address changes")
  public void operatorRescheduleDeliveryOnEditOrderPageWithAddressChange(
      Map<String, String> mapOfData) {
    Map<String, String> mapOfTokens = StandardTestUtils.createDefaultTokens();
    mapOfData = StandardTestUtils.replaceDataTableTokens(mapOfData, mapOfTokens);
    page.rescheduleDeliveryWithAddressChange(mapOfData);
    takesScreenshot();
  }

  @Then("Operator reschedule Delivery on Edit Order V2 page")
  public void operatorRescheduleDeliveryOnEditOrderPage(Map<String, String> mapOfData) {
    Map<String, String> mapOfTokens = StandardTestUtils.createDefaultTokens();
    mapOfData = StandardTestUtils.replaceDataTableTokens(mapOfData, mapOfTokens);
    page.rescheduleDelivery(mapOfData);
    takesScreenshot();
  }

  @Then("Operator pull out parcel from route on Edit Order V2 page")
  public void operatorPullsOrderFromRouteOnEditOrderPage() {
    page.inFrame(() -> {
      page.pullFromRouteDialog.waitUntilVisible();
      page.pullFromRouteDialog.toPull.check();
      page.pullFromRouteDialog.pullFromRoute.click();
    });
  }

  @Then("Operator verify order cannot be pulled from route on Edit Order V2 page")
  public void cannotPullFromRoute() {
    page.inFrame(() -> {
      page.pullFromRouteDialog.waitUntilVisible();
      Assertions.assertThat(page.pullFromRouteDialog.errorHint.isDisplayed())
          .withFailMessage("Error hint is not displayed").isTrue();
      Assertions.assertThat(page.pullFromRouteDialog.toPull.isEnabled())
          .withFailMessage("To pull checkbox is enabled").isFalse();
      Assertions.assertThat(page.pullFromRouteDialog.pullFromRoute.isEnabled())
          .withFailMessage("Pull from route button is enabled").isFalse();
    });
  }

  @When("^Operator verify next order info on Edit Order V2 page:$")
  public void operatorVerifyOrderInfoOnEditOrderPage(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    Map<String, String> finalMapOfData = mapOfData;
    page.inFrame(() -> {
      page.waitUntilLoaded();
      String fieldToValidate = finalMapOfData.get("stampId");
      if (StringUtils.isNotBlank(fieldToValidate)) {
        Assertions.assertThat(page.stampId.getNormalizedText()).as("Stamp ID")
            .isEqualTo(fieldToValidate);
      }
    });
  }

  @Then("^Operator verify \"(.+)\" order event description on Edit Order V2 page$")
  public void OperatorVerifyOrderEvent(String expectedEventName) {
    Order order = get(KEY_CREATED_ORDER);
    List<OrderEvent> events = page.eventsTable().readAllEntities();
    OrderEvent actualEvent = events.stream()
        .filter(event -> equalsIgnoreCase(event.getName(), expectedEventName)).findFirst()
        .orElseThrow(() -> new AssertionError(
            f("There is no [%s] event on Edit Order V2 page", expectedEventName)));
    String eventDescription = actualEvent.getDescription();
    if (equalsIgnoreCase(expectedEventName, "UPDATE CASH")) {
      page.eventsTable().verifyVerifyUpdateCashDescription(order, eventDescription);
    }
    if (equalsIgnoreCase(expectedEventName, "HUB INBOUND SCAN")) {
      page.eventsTable().verifyHubInboundEventDescription(order, eventDescription);
    }
  }

  @When("Operator switch to Edit Order V2 page using direct URL")
  public void switchPage() {
    Order order = get(KEY_CREATED_ORDER);
    navigateTo(
        f("%s/%s/order/%d", TestConstants.OPERATOR_PORTAL_BASE_URL, TestConstants.NV_SYSTEM_ID,
            order.getId()));
  }

  @When("^Operator open Edit Order V2 page for order ID \"(.+)\"$")
  public void operatorOpenEditOrderPage(String orderId) {
    orderId = resolveValue(orderId);
    page.openPage(Long.parseLong(orderId));
    if (!page.status.isDisplayedFast()) {
      page.refreshPage();
    }
  }

  @Then("Operator set Delivery Verification Required to {value} on Edit Order V2 page")
  public void operatorSetDeliveryVerificationRequired(String deliveryVerificationRequired) {
    page.inFrame(() -> {
      page.deliveryVerificationTypeEdit.click();
      page.editDeliveryVerificationRequiredDialog.waitUntilVisible();
      page.editDeliveryVerificationRequiredDialog.deliveryVerificationRequired.selectValue(
          deliveryVerificationRequired);
      page.editDeliveryVerificationRequiredDialog.saveChanges.click();
    });
  }

  @Then("^Operator verify Latest Route ID is \"(.+)\" on Edit Order V2 page$")
  public void operatorVerifyRouteIdOnEditOrderPage(String routeId) {
    Assertions.assertThat(page.latestRouteId.getNormalizedText()).as("Latest Route ID")
        .isEqualTo(resolveValue(routeId));
  }

  @Then("^Operator cancel RTS on Edit Order V2 page$")
  public void operatorCancelRtsOnEditOrderPage() {
    page.inFrame(() -> {
      page.cancelRtsDialog.waitUntilVisible();
      page.cancelRtsDialog.cancelRts.click();
    });
  }

  @Then("^Operator verifies RTS tag is (displayed|hidden) in delivery details box on Edit Order V2 page$")
  public void operatorVerifyRtsTag(String state) {
    page.inFrame(() -> {
      Assertions.assertThat(page.deliveryDetailsBox.rtsTag.isDisplayed()).as("RTS tag is displayed")
          .isEqualTo(equalsIgnoreCase(state, "displayed"));
    });
  }

  @Then("Operator verifies Latest Event is {string} on Edit Order V2 page")
  public void operatorVerifyLatestEvent(String value) {
    retryIfAssertionErrorOccurred(
        () -> Assertions.assertThat(page.latestEvent.getNormalizedText()).as("Latest Event")
            .isEqualTo(resolveValue(value)), "Latest Event", 1000, 3);
  }

  @Then("Operator verify {value} RTS hint is displayed on Edit Order V2 page")
  public void verifyRtsHint(String value) {
    page.inFrame(() -> {
      page.editRtsDetailsDialog.waitUntilVisible();
      Assertions.assertThat(page.editRtsDetailsDialog.hint.isDisplayed())
          .withFailMessage("RTS hint is not displayed").isTrue();
      Assertions.assertThat(page.editRtsDetailsDialog.hint.getText()).as("RTS hint text")
          .isEqualTo(value);
    });
  }

  @Then("Operator RTS order on Edit Order V2 page using data below:")
  public void operatorRtsOnEditOrderPage(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    ;
    page.inFrame(() -> {
      if (!page.editRtsDetailsDialog.isDisplayedFast()) {
        page.clickMenu("Delivery", "Return to Sender");
        page.editRtsDetailsDialog.waitUntilVisible();
      }
      String value = finalData.get("reason");
      if (StringUtils.isNotBlank(value)) {
        page.editRtsDetailsDialog.reason.selectValue(value);
      }
      value = finalData.get("recipientName");
      if (StringUtils.isNotBlank(value)) {
        page.editRtsDetailsDialog.recipientName.setValue(value);
      }
      value = finalData.get("recipientContact");
      if (StringUtils.isNotBlank(value)) {
        page.editRtsDetailsDialog.recipientContact.setValue(value);
      }
      value = finalData.get("recipientEmail");
      if (StringUtils.isNotBlank(value)) {
        page.editRtsDetailsDialog.recipientEmail.setValue(value);
      }
      value = finalData.get("internalNotes");
      if (StringUtils.isNotBlank(value)) {
        page.editRtsDetailsDialog.internalNotes.setValue(value);
      }
      value = finalData.get("deliveryDate");
      if (StringUtils.isNotBlank(value)) {
        page.editRtsDetailsDialog.deliveryDate.setValue(value);
      }
      value = finalData.get("timeslot");
      if (StringUtils.isNotBlank(value)) {
        page.editRtsDetailsDialog.timeslot.selectValue(value);
      }
      value = finalData.get("country");
      if (StringUtils.isNotBlank(value)) {
        page.editRtsDetailsDialog.changeAddress.click();
        page.editRtsDetailsDialog.country.setValue(value);
      }
      value = finalData.get("city");
      if (StringUtils.isNotBlank(value)) {
        page.editRtsDetailsDialog.city.setValue(value);
      }
      value = finalData.get("address1");
      if (StringUtils.isNotBlank(value)) {
        page.editRtsDetailsDialog.address1.setValue(value);
      }
      value = finalData.get("address2");
      if (StringUtils.isNotBlank(value)) {
        page.editRtsDetailsDialog.address2.setValue(value);
      }
      value = finalData.get("postalCode");
      if (StringUtils.isNotBlank(value)) {
        page.editRtsDetailsDialog.postcode.setValue(value);
      }
      page.editRtsDetailsDialog.saveChanges.click();
    });
  }

  @Then("Operator verifies values in Edit RTS details dialog on Edit Order V2 page:")
  public void verifyRtsDetails(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    SoftAssertions assertions = new SoftAssertions();
    page.inFrame(() -> {
      page.editRtsDetailsDialog.waitUntilVisible();

      String value = finalData.get("recipientName");
      if (StringUtils.isNotBlank(value)) {
        assertions.assertThat(page.editRtsDetailsDialog.recipientName.getValue())
            .as("Recipient name").isEqualTo(value);
      }
      value = finalData.get("recipientContact");
      if (StringUtils.isNotBlank(value)) {
        assertions.assertThat(page.editRtsDetailsDialog.recipientContact.getValue())
            .as("Recipient contact").isEqualTo(value);
      }
      value = finalData.get("recipientEmail");
      if (StringUtils.isNotBlank(value)) {
        assertions.assertThat(page.editRtsDetailsDialog.recipientEmail.getValue())
            .as("Recipient email").isEqualTo(value);
      }
      value = finalData.get("country");
      if (StringUtils.isNotBlank(value)) {
        assertions.assertThat(page.editRtsDetailsDialog.currentCountry.getNormalizedText())
            .as("Country").isEqualTo(value);
      }
      value = finalData.get("city");
      if (StringUtils.isNotBlank(value)) {
        assertions.assertThat(page.editRtsDetailsDialog.currentCity.getNormalizedText()).as("City")
            .isEqualTo(value);
      }
      value = finalData.get("address1");
      if (StringUtils.isNotBlank(value)) {
        assertions.assertThat(page.editRtsDetailsDialog.currentAddress1.getNormalizedText())
            .as("Address 1").isEqualTo(value);
      }
      value = finalData.get("address2");
      if (StringUtils.isNotBlank(value)) {
        assertions.assertThat(page.editRtsDetailsDialog.currentAddress2.getNormalizedText())
            .as("Address 2").isEqualTo(value);
      }
      value = finalData.get("postalCode");
      if (StringUtils.isNotBlank(value)) {
        assertions.assertThat(page.editRtsDetailsDialog.currentPostcode.getNormalizedText())
            .as("Postal code").isEqualTo(value);
      }
      assertions.assertAll();
    });
  }

  @Then("Operator resume order on Edit Order V2 page")
  public void operatorResumeOrder() {
    page.inFrame(() -> {
      page.clickMenu("Order settings", "Resume order");
      page.resumeOrderDialog.waitUntilVisible();
      page.resumeOrderDialog.resumeOrder.click();
    });
  }

  @And("Operator verify the tags shown on Edit Order V2 page")
  public void operatorVerifyTheTagsShownOnEditOrderPage(List<String> expectedOrderTags) {
    expectedOrderTags = resolveValues(expectedOrderTags);
    List<String> actualOrderTags = page.getTags();

    final List<String> normalizedExpectedList = expectedOrderTags.stream().map(String::toLowerCase)
        .sorted().collect(Collectors.toList());
    final List<String> normalizedActualList = actualOrderTags.stream().map(String::toLowerCase)
        .sorted().collect(Collectors.toList());

    Assertions.assertThat(normalizedActualList)
        .as("Actual tags is not equal to expected tags set on Order Tag Management page")
        .containsExactlyElementsOf(normalizedExpectedList);
  }

  @And("Operator verifies no tags shown on Edit Order V2 page")
  public void operatorVerifyNoTagsShownOnEditOrderPage() {
    List<String> actualOrderTags = page.getTags();
    Assertions.assertThat(actualOrderTags).as("List of displayed order tags").isEmpty();
    takesScreenshot();
  }

  @When("Operator click Chat With Driver on Edit Order V2 page")
  public void clickChatWithDriver() {
    page.chatWithDriver.click();
  }

  @When("Chat With Driver dialog is displayed on Edit Order V2 page")
  public void verifyChatWithDriverDialogDisplayed() {
    pause5s();
    page.chatWithDriverDialog.waitUntilVisible();
  }

  @When("Operator selects {string} in Events Filter menu on Edit Order V2 page")
  public void selectEventsFilter(String option) {
    page.eventsTableFilter.selectOption(resolveValue(option));
  }

  @Then("Operator verify POD details on Edit Order V2 page:")
  public void verifyDeliveryPodDetails(Map<String, String> data) {
    var expected = new PodDetail(resolveKeyValues(data));
    page.inFrame(() -> {
      page.podDetailsDialog.waitUntilVisible();
      page.waitUntilLoaded();
      var actual = page.podDetailsDialog.podDetailTable.readAllEntities();
      DataEntity.assertListContains(actual, expected, "PODs list");
    });
  }

  @Then("Operator verifies ticket status is {value} on Edit Order V2 page")
  public void updateRecoveryTicket(String data) {
    String status = page.recoveryTicket.getText();
    Pattern p = Pattern.compile(".*Status:\\s*(.+?)\\s.*");
    Matcher m = p.matcher(status);
    if (m.matches()) {
      Assertions.assertThat(m.group(1)).as("Ticket status").isEqualToIgnoringCase(data);
    } else {
      Assertions.fail("Could not get ticket status from string: " + status);
    }
  }

  @Then("Operator updates recovery ticket on Edit Order V2 page:")
  public void updateRecoveryTicket(Map<String, String> data) {
    data = resolveKeyValues(data);
    page.recoveryTicket.click();
    page.editTicketDialog.waitUntilVisible();
    pause5s();
    if (data.containsKey("status")) {
      page.editTicketDialog.ticketStatus.selectValue(data.get("status"));
    }
    pause5s();
    if (data.containsKey("keepCurrentOrderOutcome")) {
      page.chooseCurrentOrderOutcome(data.get("keepCurrentOrderOutcome"));
    }
    pause5s();
    if (data.containsKey("outcome")) {
      page.editTicketDialog.orderOutcome.selectValue(data.get("outcome"));
    }
    if (data.containsKey("assignTo")) {
      page.editTicketDialog.assignTo.selectValue(data.get("assignTo"));
    }
    if (data.containsKey("rtsReason")) {
      page.editTicketDialog.rtsReason.selectValue(data.get("rtsReason"));
    }
    if (data.containsKey("newInstructions")) {
      String instruction = data.get("newInstructions");
      if ("GENERATED".equals(instruction)) {
        instruction = f("This damage description is created by automation at %s.",
            DTF_CREATED_DATE.format(ZonedDateTime.now()));
      }
      page.editTicketDialog.newInstructions.setValue(instruction);
    }
    page.editTicketDialog.updateTicket.clickAndWaitUntilDone(60);
  }

  @When("^Operator create new recovery ticket on Edit Order V2 page:$")
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

    page.inFrame(() -> {
      page.clickMenu("Order Settings", "Create recovery ticket");
      page.createTicket(recoveryTicket);
      put("recoveryTicket", recoveryTicket);
    });
  }

  @When("Operator edit cash collection details on Edit Order V2 page:")
  public void editCashCollectionDetails(Map<String, String> data) {
    data = resolveKeyValues(data);
    String cop = data.get("cashOnPickup");
    String cod = data.get("cashOnDelivery");
    String amount = data.get("amount");
    page.inFrame(() -> {
      page.clickMenu("Order settings", "Edit cash collection details");
      page.editCashCollectionDetailsDialog.waitUntilVisible();
      page.editCashCollectionDetailsDialog.cop.setValue(
          StringUtils.equalsAnyIgnoreCase(cop, "yes", "true"));
      page.editCashCollectionDetailsDialog.cod.setValue(
          StringUtils.equalsAnyIgnoreCase(cod, "yes", "true"));
      if (StringUtils.isNotBlank(cop) && StringUtils.isNotBlank(amount)) {
        page.editCashCollectionDetailsDialog.copAmount.setValue(amount);
      }
      if (StringUtils.isNotBlank(cod) && StringUtils.isNotBlank(amount)) {
        page.editCashCollectionDetailsDialog.codAmount.setValue(amount);
      }
      page.editCashCollectionDetailsDialog.saveChanges.click();
    });
  }

  @Given("Operator unmask edit order V2 page")
  public void unmaskEditOrder() {
    List<WebElement> elements = getWebDriver().findElements(By.xpath(MaskedPage.MASKING_XPATH));
    page.operatorClickMaskingText(elements);
  }
}