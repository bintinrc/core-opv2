package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.operator_v2.model.GlobalInboundParams;
import co.nvqa.operator_v2.selenium.page.GlobalInboundPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.support.Color;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class GlobalInboundSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(GlobalInboundSteps.class);

  private GlobalInboundPage globalInboundPage;

  public GlobalInboundSteps() {
  }

  @Override
  public void init() {
    globalInboundPage = new GlobalInboundPage(getWebDriver());
  }

  private Double parseDoubleOrNull(String str) {
    Double result = null;

    if (str != null) {
      try {
        result = Double.parseDouble(str);
      } catch (NumberFormatException ex) {
        LOGGER.warn("Failed to parse String to Double. Cause: {}", ex.getMessage());
      }
    }

    return result;
  }

  private GlobalInboundParams buildGlobalInboundParams(Map<String, String> mapOfData) {
    String hubName = mapOfData.get("hubName");
    String deviceId = mapOfData.get("deviceId");
    String parcelType = mapOfData.get("parcelType");
    String trackingId = mapOfData.get("trackingId");
    String overrideSize = mapOfData.get("overrideSize");
    String tags = mapOfData.get("tags");

   if(parcelType==null){
     parcelType = "Bulky";
   }
    Double overrideWeight = parseDoubleOrNull(mapOfData.get("overrideWeight"));
    Double overrideDimHeight = parseDoubleOrNull(mapOfData.get("overrideDimHeight"));
    Double overrideDimWidth = parseDoubleOrNull(mapOfData.get("overrideDimWidth"));
    Double overrideDimLength = parseDoubleOrNull(mapOfData.get("overrideDimLength"));

    if ("GET_FROM_CREATED_ORDER".equalsIgnoreCase(trackingId)) {
      trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    }

    GlobalInboundParams globalInboundParams = new GlobalInboundParams();
    globalInboundParams.setHubName(hubName);
    globalInboundParams.setDeviceId(deviceId);
    globalInboundParams.setParcelType(parcelType);
    globalInboundParams.setTrackingId(trackingId);
    globalInboundParams.setOverrideSize(overrideSize);
    globalInboundParams.setOverrideWeight(overrideWeight);
    globalInboundParams.setOverrideDimHeight(overrideDimHeight);
    globalInboundParams.setOverrideDimWidth(overrideDimWidth);
    globalInboundParams.setOverrideDimLength(overrideDimLength);
    globalInboundParams.setTags(tags);
    return globalInboundParams;
  }

  @When("^Operator global inbounds parcel using data below:$")
  public void operatorGlobalInboundsParcelUsingThisDataBelow(Map<String, String> mapOfData) {
    doWithRetry(() ->
    {
      try {
        final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
        GlobalInboundParams globalInboundParams = buildGlobalInboundParams(finalMapOfData);
        globalInboundPage.switchTo();
        globalInboundPage.successfulGlobalInbound(globalInboundParams);
        put(KEY_GLOBAL_INBOUND_PARAMS, globalInboundParams);
      } catch (Throwable ex) {
        LOGGER.info("Element in Global inbound scanning not found, retrying...");
        globalInboundPage.refreshPage();
        throw new NvTestRuntimeException(ex);
      }
    }, "OperatorV2 Global Inbound Parcel");
  }

  @When("^Operator global inbounds parcel using data below and check alert:$")
  public void operatorGlobalInboundsParcelUsingThisDataBelowAndCheckAlert(
      Map<String, String> mapOfData) {
    pause1s();
    mapOfData = resolveKeyValues(mapOfData);
    GlobalInboundParams globalInboundParams = buildGlobalInboundParams(mapOfData);
    String toastText = mapOfData.get("toastText");
    String rackInfo = mapOfData.get("rackInfo");
    String rackColor = mapOfData.get("rackColor");
    String weightWarning = mapOfData.get("weightWarning");
    String destinationHub = mapOfData.get("destinationHub");
    String rackSector = mapOfData.get("rackSector");

    globalInboundPage.switchTo();
    globalInboundPage
        .globalInboundAndCheckAlert(globalInboundParams, toastText, rackInfo, rackColor,
            weightWarning, rackSector, destinationHub);
    put(KEY_GLOBAL_INBOUND_PARAMS, globalInboundParams);
  }

  @When("^Operator verifies priority level info is correct using data below:$")
  public void operatorVerifiesPriorityLevelInfoIsCorrectUsingDataBelow(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    int expectedPriorityLevel = Integer.parseInt(mapOfData.get("priorityLevel"));
    String expectedPriorityLevelColorAsHex = mapOfData.get("priorityLevelColorAsHex");
    globalInboundPage
        .verifiesPriorityLevelInfoIsCorrect(expectedPriorityLevel, expectedPriorityLevelColorAsHex);
    takesScreenshot();
  }

  @Then("Operator global inbound and verify the ticket's type of {string} shown in the Global Inbound Page with data:")
  public void operatorVerifyTheTicketSTypeShownInTheGlobalInboundPage(String ticketType,
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    GlobalInboundParams globalInboundParams = buildGlobalInboundParams(mapOfData);

    globalInboundPage.verifyPetsGlobalInbound(globalInboundParams, ticketType);
    put(KEY_GLOBAL_INBOUND_PARAMS, globalInboundParams);
    takesScreenshot();
  }

  @Then("Operator verify info on Global Inbound page using data below:")
  public void operatorVerifyInfoOnGlobalInboundPageUsingDataBelow(Map<String, String> data) {
    data = resolveKeyValues(data);
    pause3s();
    if (data.containsKey("destinationHub")) {
      String expected = data.get("destinationHub");
      String actual = globalInboundPage.destinationHub.getText();
      actual = StringUtils.normalizeSpace(StringUtils.remove(actual, "Assigned Hub:"));
      Assertions.assertThat(actual).as("Destination Hub").isEqualToIgnoringCase(expected);
    }

    if (data.containsKey("rackInfo")) {
      String expected = data.get("rackInfo");
      String actual = globalInboundPage.rackInfo.getText();
      actual = StringUtils.normalizeSpace(actual);
      Assertions.assertThat(actual).as("Rack Info").isEqualToIgnoringCase(expected);
    }
    if (data.containsKey("rtsTag")) {
      String expected = data.get("rtsTag");
      String actual = globalInboundPage.rtsTag.getText();
      actual = StringUtils.normalizeSpace(actual);
      Assertions.assertThat(actual).as("RTS Info").isEqualToIgnoringCase(expected);
    }
    if (data.containsKey("priorTag")) {
      String expected = data.get("priorTag");
      String actual = globalInboundPage.priorTag.getText();
      actual = StringUtils.normalizeSpace(actual);
      Assertions.assertThat(actual).as("Prior Info").isEqualToIgnoringCase(expected);
    }

    if (data.containsKey("setAsideGroup")) {
      String expected = data.get("setAsideGroup");
      String actual = globalInboundPage.setAsideGroup.getText();
      actual = StringUtils.normalizeSpace(actual);
      Assertions.assertThat(actual).as("Set Aside Group").isEqualToIgnoringCase(expected);
    }

    if (data.containsKey("setAsideRackSector")) {
      String expected = data.get("setAsideRackSector");
      String actual = globalInboundPage.setAsideRackSector.getText();
      actual = StringUtils.normalizeSpace(StringUtils.remove(actual, "Rack Sector:"));
      Assertions.assertThat(actual).as("Set Aside Rack Sector").isEqualToIgnoringCase(expected);
    }

    if (data.containsKey("color")) {
      String expected = data.get("color");
      Color actualColor = Color.fromString(
          globalInboundPage.getCssValue(globalInboundPage.XPATH_CONTAINER, "background-color"));
      Assertions.assertThat(actualColor.asHex())
          .as("Expected another color for Route ID background").isEqualTo(expected);
    }

    takesScreenshot();
    pause3s();
  }

  @Then("Ninja Collect Operator verifies that all the details for Confirmed Status via {string} are right")
  public void ninjaCollectOperatorVerifiesThatAllTheDetailsForConfirmedStatusViaAreRightAndIsFollowedByStatus(
      String source, Map <String,String> dataTable) {
    dataTable = resolveKeyValues(dataTable);
    String barcode = dataTable.get("barcode");
    String id = dataTable.get("id");
    String dpBarcode = dataTable.get("dpBarcode");
    String dpDetailsId=dataTable.get("dpDetailsId");
    String dpSource=dataTable.get("dpSource");
    String dpStatus = dataTable.get("dpStatus");
    globalInboundPage
        .verifiesDetailsAreRightForGlobalInbound(barcode, dpBarcode, id, dpDetailsId,dpSource,source,dpStatus);
  }

  @Then("Operator verifies tags on Global Inbound page")
  public void operatorVerifiesTagsOnGlobalInboundPage(List<String> expectedOrderTags) {
    globalInboundPage.verifiesTagsOnOrder(expectedOrderTags);
    takesScreenshot();
  }

  @Then("Operator global inbounds {string} ticket using data below:")
  public void operatorGlobalInboundsTicketUsingDataBelow(String recoveryTicketType,
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    GlobalInboundParams globalInboundParams = buildGlobalInboundParams(mapOfData);
    globalInboundPage.unSuccessfulGlobalInbound(recoveryTicketType, globalInboundParams);
    put(KEY_GLOBAL_INBOUND_PARAMS, globalInboundParams);
  }

  @When("Operator verifies DP tag is displayed")
  public void OperatorVerifiesDpTagIsDisplayed() {
    globalInboundPage.verifiesDpTag();
    takesScreenshot();
  }

  @And("Operator add the order tags")
  public void operatorTagsOrderWith(List<String> orderTag) {
    globalInboundPage.addTag(orderTag);
  }

  @Then("Operator verify failed tagging error toast is shown")
  public void operatorVerifyFailedTaggingToast() {
    globalInboundPage.verifyFailedTaggingToast("Tagging Failed: Order exceed 4 tags limit");
    takesScreenshot();
  }

  @When("^Operator verifies prior tag is displayed$")
  public void operatorVerifiesPriorTagIsDisplayed() {
    globalInboundPage.verifiesPriorTag();
  }

  @When("^Operator verifies RTS tag is displayed$")
  public void operatorVerifiesRtsTagIsDisplayed() {
    globalInboundPage.verifiesPriorTag();
  }

  @Then("Operator verifies Recovery Ticket status is {string} for {string}")
  public void operatorVerifiesRecoveryTicketStatusIs(String ticketStatus , String recoveryTicket) {
    recoveryTicket = resolveValue(recoveryTicket);
    Assertions.assertThat(ticketStatus).isEqualToIgnoringCase(recoveryTicket);
  }

  @And("Operator verifies order weight is overridden based on the volumetric weight")
  public void operatorVerifiesOrderWeightIsOverriddenBasedOnTheVolumetricWeight(Map<String,String>dataAsMap) {
    String countryCode = StandardTestConstants.NV_SYSTEM_ID;
    dataAsMap = resolveKeyValues(dataAsMap);

    double orderWeight;
    double height = Double.parseDouble(dataAsMap.get("orderHeight"));
    double width = Double.parseDouble(dataAsMap.get("orderWidth"));
    double length = Double.parseDouble(dataAsMap.get("orderLength"));
    switch (countryCode) {
      case "ID":
        orderWeight = (length + width + height) / 6000;
        break;

      case "MY":
        orderWeight = (length + width + height) / 3500;
        break;

      case "PH":
        orderWeight = (length + width + height) / 6000;
        break;

      case "SG":
        orderWeight = Double.parseDouble(dataAsMap.get("orderWeight"));
        break;

      case "VN":
        orderWeight = (length + width + height) / 6000;
        break;

      default:
        orderWeight = Double.parseDouble(dataAsMap.get("orderWeight"));
    }

    String orderWeightAsString = String.valueOf(orderWeight);
    String actualOrderWeightAsString = String.valueOf(dataAsMap.get("orderWeight"));
//
    Assertions.assertThat(orderWeightAsString.contains(actualOrderWeightAsString))
        .as("Order weight is overridden").isTrue();
    takesScreenshot();
  }

  @When("Operator save current order cost {string}")
  public void operatorSaveCurrentOrderCost(String currentCost) {
    String cost = resolveValue(currentCost);
    put("KEY_CURRENT_COST",cost);
  }

  @When("Operator verifies order cost is updated")
  public void operatorVerifiesOrderCostIsUpdated(Map<String, String> mapOfData) {
    String previousCost= resolveValue(mapOfData.get("previousCost")).toString();
    String costAfterInbound= resolveValue(mapOfData.get("costAfterInbound")).toString();
    Assertions.assertThat(previousCost).isNotEqualTo(costAfterInbound).as("order cost is updated");
  }

  @And("Operator verify DP details {string} is {string}")
  public void operatorVerifyDPDetailsIs(String dpDetail, String expected) {
    String actual = resolveValue(dpDetail);
    Assertions.assertThat(actual).isEqualToIgnoringCase(expected);
  }

  @And("Operator verify multiple Key details with data below:")
  public void operatorVerifyMultipleKeyDetailsWithDataBelow(List<Map<String, String>> data) {
    List<String> key = new ArrayList<>();
    List<String> KeyName = new ArrayList<>();
    List<String> expectedValue = new ArrayList<>();
    for (Map<String, String> entry : data) {
      KeyName.add(entry.get("key"));
      key.add(resolveValue(entry.get("key")));
      expectedValue.add(resolveValue(entry.get("expectedValue")));
    }

    for (int i = 0; i < key.size(); i++) {
      String actual = key.get(i);
      String expected = expectedValue.get(i);
      Assertions.assertThat(actual).as(KeyName.get(i)+" Key Details is correct").containsIgnoringCase(expected);
    }
  }
}
