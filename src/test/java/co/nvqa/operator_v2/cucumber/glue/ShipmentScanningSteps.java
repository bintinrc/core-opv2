package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.hub.Shipments;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.ShipmentInfo;
import co.nvqa.operator_v2.selenium.page.ShipmentScanningPage;
import co.nvqa.operator_v2.util.TestConstants;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import org.openqa.selenium.JavascriptExecutor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Lanang Jati
 * <p>
 * Modified by Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ShipmentScanningSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(ShipmentScanningSteps.class);

  private ShipmentScanningPage shipmentScanningPage;
  public ShipmentScanningSteps() {
  }

  @Override
  public void init() {
    shipmentScanningPage = new ShipmentScanningPage(getWebDriver());
  }

  @When("^Operator scan the created order to shipment in hub ([^\"]*) to hub id = ([^\"]*)$")
  public void operatorScanTheCreatedOrderToShipmentInHub(String hub, String destHub) {
    retryIfRuntimeExceptionOccurred(() ->
    {
      try {

        pause10s();
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
        String shipmentType = containsKey(KEY_SHIPMENT_INFO) ?
            ((ShipmentInfo) get(KEY_SHIPMENT_INFO)).getShipmentType() :
            ((Shipments) get(KEY_CREATED_SHIPMENT)).getShipment().getShipmentType();

        shipmentScanningPage.switchTo();
        shipmentScanningPage.selectHub(resolveValue(hub));
        shipmentScanningPage.selectDestinationHub(resolveValue(destHub));
        shipmentScanningPage.selectShipmentType(shipmentType);
        shipmentScanningPage.waitUntilElementIsClickable("//input[@id='shipment_id']");
        shipmentScanningPage.selectShipmentId(shipmentId);
        shipmentScanningPage.waitUntilShipmentIdFilled(shipmentId);
        shipmentScanningPage.clickSelectShipment();
        shipmentScanningPage.scanBarcode(trackingId);
        shipmentScanningPage.waitUntilVisibilityOfElementLocated("//div[@data-testid='add-parcel-scan-container']//span[contains(.,'"+trackingId+"')]");
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        LOGGER.info("Searched element is not found, retrying after 2 seconds...");
        navigateRefresh();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 5);
  }

  @When("^Operator add to shipment in hub ([^\"]*) to hub id = ([^\"]*)$")
  public void operatorAddToShipmentInHub(String hub, String destHub) {
    retryIfRuntimeExceptionOccurred(() ->
    {
      try {
        Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
        String shipmentType = containsKey(KEY_SHIPMENT_INFO) ?
            ((ShipmentInfo) get(KEY_SHIPMENT_INFO)).getShipmentType() :
            ((Shipments) get(KEY_CREATED_SHIPMENT)).getShipment().getShipmentType();

        shipmentScanningPage.switchTo();
        shipmentScanningPage.pause10s();
        shipmentScanningPage.selectHub(resolveValue(hub));
        shipmentScanningPage.selectDestinationHub(resolveValue(destHub));
        shipmentScanningPage.selectShipmentType(shipmentType);
        shipmentScanningPage.waitUntilElementIsClickable("//input[@id='shipment_id']");
        shipmentScanningPage.selectShipmentId(shipmentId);
        shipmentScanningPage.clickSelectShipment();
        shipmentScanningPage.waitUntilInvisibilityOfElementLocated("//div[@id='toast-container']");
        shipmentScanningPage.waitUntilVisibilityOfElementLocated("//button//span[.='Close Shipment']");
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        LOGGER.info("Searched element is not found, retrying after 2 seconds...");
        navigateRefresh();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 5);
  }

  @When("Operator open add to shipment for shipment {string} in hub {string} to hub id = {string} with shipmentType {string}")
  public void operatorScanTheCreatedOrderToShipmentInHub(String shipmentIdAsString, String hub,
      String destHub, String shipmentType) {
    retryIfRuntimeExceptionOccurred(() ->
    {
      try {
        Long shipmentId = Long.valueOf(resolveValue(shipmentIdAsString));
        shipmentScanningPage.switchTo();
        shipmentScanningPage.selectHub(resolveValue(hub));
        shipmentScanningPage.selectDestinationHub(resolveValue(destHub));
        shipmentScanningPage.selectShipmentType(shipmentType);
        shipmentScanningPage.waitUntilElementIsClickable("//input[@id='shipment_id']");
        shipmentScanningPage.selectShipmentId(shipmentId);
        shipmentScanningPage.clickSelectShipment();
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        LOGGER.info("Searched element is not found, retrying after 2 seconds...");
        navigateRefresh();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 5);
  }

  @And("Operator close the shipment which has been created")
  public void operatorCloseTheShipmentWhichHasBeenCreated() {
    shipmentScanningPage.switchTo();
    shipmentScanningPage.closeShipment();
  }

  @And("Operator close shipment with data below:")
  public void operatorCloseShipmentWithDataBelow(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String origHubName = mapOfData.get("origHubName");
    String destHubName = mapOfData.get("destHubName");
    String shipmentType = mapOfData.get("shipmentType");
    String shipmentId = mapOfData.get("shipmentId");
    shipmentScanningPage.closeShipmentWithData(origHubName, destHubName, shipmentType, shipmentId);
  }

  @And("Set constant order for Indonesia:")
  public void setConstantOrder(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String constantOrder = mapOfData.get("constantOrder");
    put(KEY_CREATED_ORDER_TRACKING_ID, constantOrder);
  }

  @And("Set temporary order:")
  public void setTempOrder(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String constantOrder = mapOfData.get("constantOrder");
    put(KEY_CREATED_ORDER_TRACKING_ID, constantOrder);
  }

  @And("Operator scan and close shipment with data below:")
  public void operatorScanAndCloseShipmentWithDataBelow(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String origHubName = mapOfData.get("origHubName");
    String destHubName = mapOfData.get("destHubName");
    String shipmentType = mapOfData.get("shipmentType");
    String shipmentId = mapOfData.get("shipmentId");
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    shipmentScanningPage.scanAndCloseShipmentWithData(origHubName, destHubName, shipmentType, shipmentId, trackingId);
  }

  @And("Operator close multiple shipments with data below:")
  public void operatorCloseMultipleShipmentWithDataBelow(Map<String, String> mapOfData) {
    String shipmentsCount = mapOfData.get("shipmentCount");
    String origHubName = resolveValue(mapOfData.get("origHubName"));
    String destHubName = resolveValue(mapOfData.get("destHubName"));
    String shipmentType = mapOfData.get("shipmentType");
    String shipment = mapOfData.get("shipmentId");
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    for(int i=1; i<=Integer.parseInt(shipmentsCount); i++){
      String shipmentId = resolveValue(f(shipment,i));
      LOGGER.info("Shipment Count: " + i + ", Shipment Id: " + shipmentId);
      if(i>1){
        shipmentScanningPage.scanAndCloseShipmentsWithData(origHubName, destHubName, shipmentType, shipmentId, trackingId);
      }else{
        shipmentScanningPage.scanAndCloseShipmentWithData(origHubName, destHubName, shipmentType, shipmentId, trackingId);
      }
    }
  }

  @When("^Operator scan multiple created order to shipment in hub ([^\"]*) to hub id = ([^\"]*)$")
  public void aPIShipperTagsMultipleParcelsAsPerTheBelowTag(String hub, String destHub) {
    retryIfRuntimeExceptionOccurred(() ->
    {
      try {
        List<String> trackingIds = (get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID));
        Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
        String shipmentType = containsKey(KEY_SHIPMENT_INFO) ?
            ((ShipmentInfo) get(KEY_SHIPMENT_INFO)).getShipmentType() :
            ((Shipments) get(KEY_CREATED_SHIPMENT)).getShipment().getShipmentType();

        String resolvedDestHub = resolveValue(destHub);
        pause10s();
        shipmentScanningPage.switchTo();
        shipmentScanningPage.waitUntilVisibilityOfElementLocated("//div[span[input[@id='orig_hub']]]//span[.='Search or Select']");
        shipmentScanningPage.selectHub(hub);
        shipmentScanningPage.selectDestinationHub(resolvedDestHub);
        shipmentScanningPage.selectShipmentType(shipmentType);
        shipmentScanningPage.waitUntilElementIsClickable("//input[@id='shipment_id']");
        shipmentScanningPage.selectShipmentId(shipmentId);
        shipmentScanningPage.clickSelectShipment();
        shipmentScanningPage.waitUntilVisibilityOfElementLocated("//button//span[.='Close Shipment']");

        for (String trackingId : trackingIds) {
          pause1s();
          shipmentScanningPage.scanBarcode(trackingId);
          shipmentScanningPage.checkOrderInShipment(trackingId);
        }
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        LOGGER.info("Searched element is not found, retrying after 2 seconds...");
        navigateRefresh();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 10);
  }

  @When("Operator add order to shipment in hub {value} to hub {value}")
  public void operatorAddOrderToShipment(String hub, String destHub) {
    retryIfRuntimeExceptionOccurred(() ->
    {
      try {
        List<String> trackingIds = (get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID));
        Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
        String shipmentType = containsKey(KEY_SHIPMENT_INFO) ?
            ((ShipmentInfo) get(KEY_SHIPMENT_INFO)).getShipmentType() :
            ((Shipments) get(KEY_CREATED_SHIPMENT)).getShipment().getShipmentType();

        shipmentScanningPage.switchTo();
        pause10s();
        shipmentScanningPage.selectHub(resolveValue(hub));
        shipmentScanningPage.selectDestinationHub(resolveValue(destHub));
        shipmentScanningPage.selectShipmentType(shipmentType);
        shipmentScanningPage.waitUntilElementIsClickable("//input[@id='shipment_id']");
        shipmentScanningPage.selectShipmentId(shipmentId);
        shipmentScanningPage.waitUntilShipmentIdFilled(shipmentId);
        shipmentScanningPage.clickSelectShipment();

        for (String trackingId : trackingIds) {
          pause1s();
          shipmentScanningPage.scanBarcode(trackingId);
          shipmentScanningPage.checkAndRemoveScannedOrdersIfInvalid();
          shipmentScanningPage.checkOrderInShipment(trackingId);
        }
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        LOGGER.info("Searched element is not found, retrying after 2 seconds...");
        navigateRefresh();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 10);
  }

  @And("Operator removes the parcel from the shipment")
  public void operatorRemovesTheParcelFromTheShipment() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    shipmentScanningPage.removeShipmentWithId(trackingId);
    shipmentScanningPage.checkOrderNotInShipment(trackingId);
  }

  @And("Operator removes the parcel from the shipment with error alert")
  public void operatorRemovesTheParcelFromTheShipmentWithErrorAlert() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    shipmentScanningPage.removeOrderFromShipmentWithErrorAlert(trackingId);
  }

  @Then("Operator verifies that the parcels shown are decreased")
  public void operatorVerifiesThatTheParcelsShownAreDecreased() {
    List<Order> orders = get(KEY_LIST_OF_CREATED_ORDER);
    int actualSumOfOrder = orders.size() - 1;
    shipmentScanningPage.verifyTheSumOfOrderIsDecreased(actualSumOfOrder);
  }

  @And("Operator removes all the parcel from the shipment")
  public void operatorRemovesAllTheParcelFromTheShipment() {
    List<String> trackingIds = (get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID));
    for (String trackingId : trackingIds) {
      pause2s();
      shipmentScanningPage.removeShipmentWithId(trackingId);
      pause2s();
      shipmentScanningPage.removeTrackingIdField.clear();
    }
  }

  @Then("Operator verifies that the parcel shown is zero")
  public void operatorVerifiesThatTheParcelShownIsZero() {
    pause2s();
    shipmentScanningPage.verifyTheSumOfOrderIsZero();
  }

  @And("Operator verifies that the row of the added order is red highlighted")
  public void operatorVerifiesThatTheRowOfTheAddedOrderIsRedHighlighted() {
    shipmentScanningPage.verifyOrderIsRedHighlighted();
  }

  @And("Operator verifies that the row of the added order is blue highlighted")
  public void operatorVerifiesThatTheRowOfTheAddedOrderIsBlueHighlighted() {
    shipmentScanningPage.verifyOrderIsBlueHighlighted();
  }

  @And("Operator scan shipment with id {string}")
  public void operatorScanTheCreatedShipment(String shipmentIdAsString) {
    String shipmentId = resolveValue(shipmentIdAsString);
    shipmentScanningPage.scanBarcode(shipmentId);
    shipmentScanningPage.waitUntilVisibilityOfElementLocated(shipmentScanningPage.XPATH_SMALL_SUCCESS_MESSAGE);
    pause2s();
  }

  @Then("Operator verifies toast with message {string} is shown on Shipment Inbound Scanning page")
  public void operatorVerifiesToastWithMessageIsShown(String toastMessage) {
    String resolvedToastMessage = resolveValue(toastMessage);
    shipmentScanningPage.verifyToastWithMessageIsShown(resolvedToastMessage);
  }

  @Then("Capture the toast with message is shown on Shipment Inbound Scanning page")
  public void operatorCaptureToastWithMessageIsShown() {
    shipmentScanningPage.getAntNotificationMessage();
  }

  @Then("Click on No, goback on dialog box for shipment {string}")
  public void operatorClickProceedOnCancelledDialog(String shipmentId) {
    shipmentId = resolveValue(shipmentId);
    shipmentScanningPage.clickGoBackInCancelledTripDepartureDialog(shipmentId);
  }

  @Then("Click on Yes, continue on dialog box")
  public void operatorClickOnYesContinueOnDialog() {
    shipmentScanningPage.clickYesContinueInInboundScanningDialog();
  }
  @Then("Operator verifies toast bottom with message {string} is shown on Shipment Inbound Scanning page")
  public void operatorVerifiesToastBottomWithMessageIsShownOnShipmentInboundScanningPage(
      String toastMessage) {
    toastMessage = resolveValue(toastMessage);
    shipmentScanningPage.verifyBottomToastWithMessageIsShown(toastMessage);
  }

  @Then("Operator verifies toast with message containing {string} is shown on Shipment Inbound Scanning page")
  public void operatorVerifiesToastContainingMessageIsShown(String toastMessage) {
    toastMessage = resolveValue(toastMessage);
    shipmentScanningPage.verifyToastContainingMessageIsShown(toastMessage);
  }

  @Then("Operator verifies toast bottom containing message {string} is shown on Shipment Inbound Scanning page")
  public void operatorVerifiesToastBottomContainingMessageIsShownOnShipmentInboundScanningPage(
      String toastMessage) {
    toastMessage = resolveValue(toastMessage);
    shipmentScanningPage.verifyBottomToastContainingMessageIsShown(toastMessage);
  }

  @Then("Operator verifies toast bottom containing following messages is shown on Shipment Inbound Scanning page:")
  public void operatorVerifiesToastBottomContainingFollowingMessagesIsShownOnShipmentInboundScanningPage(
      List<String> listOfMessages) {
    List<String> resolvedListOfMessages = listOfMessages.stream().<String>map(this::resolveValue)
        .collect(Collectors.toList());
    shipmentScanningPage
        .verifyBottomToastDriverInTripContainingEitherMessage(resolvedListOfMessages);
    shipmentScanningPage.forceCompleteButton.waitUntilClickable();
    shipmentScanningPage.forceCompleteButton.click();
    pause5s();
    shipmentScanningPage
        .verifyBottomToastDriverInTripContainingEitherMessage(resolvedListOfMessages);
    shipmentScanningPage.forceCompleteButton.waitUntilClickable();
    shipmentScanningPage.forceCompleteButton.click();
    pause5s();
  }

  @And("Operator verifies Scan Shipment Container color is {string}")
  public void operatorVerifiesScanShipmentContainerColorIs(String containerColorAsHex) {
    shipmentScanningPage.verifyScanShipmentColor(containerColorAsHex);
  }

  @Then("Operator verifies Scanned Shipment color is {string}")
  public void operatorVerifiesScannedShipmentColorIs(String boxColor) {
    shipmentScanningPage.verifyScannedShipmentColor(boxColor);
  }

  @Then("Operator verifies Scanned Shipment {string} exist color is {string}")
  public void operatorVerifiesScannedShipmentColorIs(String shipmentIdAsString, String boxColor) {
    String shipmentId = resolveValue(shipmentIdAsString);
    shipmentScanningPage.verifyScannedShipmentColorById(boxColor, shipmentId);
  }

  @Then("Operator verifies shipment {string} scanned")
  public void operatorVerifiesShipmentScanned(String shipmentIdAsString) {
    shipmentIdAsString = resolveValue(shipmentIdAsString);
    shipmentScanningPage.verifyShipmentInTrip(shipmentIdAsString);
  }

  @When("Operator clicks end inbound button")
  public void operatorEndsShipmentInbound() {
    shipmentScanningPage.clickEndShipmentInbound();
  }

  @When("Operator close error shipment dialog on Shipment Inbound Scanning page")
  public void operatorCloseErrorShipmentDialogOnShipmentInboundScanningPage() {
    shipmentScanningPage.clickCancelInMdDialog();
  }

  @Then("^Operator verify the trip Details is correct on shipment inbound scanning page using data below:$")
  public void operatorVerifyTheTripDetailsIsCorrectOnShipmentInboundScanningPageUsingDataBelow(
      Map<String, String> data) {
    final Map<String, String> finalData = resolveKeyValues(data);
    String inboundHub = finalData.get("inboundHub");
    String inboundType = finalData.get("inboundType");
    String driver = finalData.get("driver");
    String destinationHub = finalData.get("destinationHub");
    shipmentScanningPage.verifyTripData(inboundHub, inboundType, driver, destinationHub);
  }

  @And("Operator clicks proceed in end inbound dialog {string}")
  public void operatorClicksProceedInEndInboundDialog(String inboundType) {
    if ("Van Inbound".equals(inboundType)) {
      shipmentScanningPage.clickProceedInTripDepartureDialog();
    }else{
      shipmentScanningPage.clickProceedInEndInboundDialog();
    }
  }

  @And("Operator clicks leave in leaving page dialog")
  public void operatorClicksLeaveInLeavingPageDialog() {
    shipmentScanningPage.clickLeavePageDialog();
  }

  @When("Operator remove scanned shipment from remove button in scanned shipment table")
  public void operatorClickRemoveButtonInScannedShipmentTable() {
    shipmentScanningPage.clickRemoveButton();
  }

  @And("Operator verifies shipment counter is {string}")
  public void operatorVerifiesShipmentNotInShipmentScannedIntoTrip(String shipmentCounter) {
    shipmentScanningPage.verifyShipmentCount(shipmentCounter);
  }

  @And("Operator enter shipment with id {string} in remove shipment")
  public void operatorEnterShipmentWithIdInRemoveShipment(String shipmentIdAsString) {
    String shipmentId = resolveValue(shipmentIdAsString);
    shipmentScanningPage.removeShipmentWithId(shipmentId);
  }

  @When("Operator verifies shipment with id {string} appears in error shipment dialog with result {string}")
  public void operatorVerifiesShipmentWithIdAppearsInErrorShipmentDialogWithResult(
      String shipmentIdAsString, String resultString) {
    retryIfAssertionErrorOccurred(() -> {
      try {
        String shipmentId = resolveValue(shipmentIdAsString);
        String resultStringValue = resolveValue(resultString);
        shipmentScanningPage.verifyErrorShipmentWithMessage(shipmentId, resultStringValue);
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        shipmentScanningPage.clickCancelInMdDialog();
        pause1s();
        shipmentScanningPage.clickEndShipmentInbound();
        throw ex;
      }
    }, "trying to find error shipment dialog");
  }

  @When("Operator verifies shipment with id {string} appears in error shipment dialog with result {string} in {string}")
  public void operatorVerifiesShipmentWithIdAppearsInErrorShipmentDialogWithResult(
      String shipmentIdAsString, String resultString, String errorShipmentType) {
    retryIfAssertionErrorOccurred(() -> {
      try {
        String shipmentId = resolveValue(shipmentIdAsString);
        String resultStringValue = resolveValue(resultString);
        shipmentScanningPage
            .verifyErrorShipmentWithMessage(shipmentId, resultStringValue, errorShipmentType);
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        shipmentScanningPage.clickCancelInMdDialog();
        pause1s();
        shipmentScanningPage.clickEndShipmentInbound();
        throw ex;
      }
    }, "trying to find error shipment dialog");
  }

  @When("Operator click proceed in error shipment dialog")
  public void operatorClickProceedInErrorShipmentDialog() {
    shipmentScanningPage.clickProceedButtonInErrorShipmentDialog();
  }

  @Then("Operator verify small message {string} appears in Shipment Inbound Box")
  public void operatorVerifySmallMessageAppearsInShipmentInboundBox(String smallMessageAsString) {
    retryIfAssertionErrorOccurred(() -> {
      try {
        String smallMessage = resolveValue(smallMessageAsString);
        shipmentScanningPage.verifySmallMessageAppearsInScanShipmentBox(smallMessage);
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        throw ex;
      }
    }, getCurrentMethodName(), 500, 2);
  }

  @Then("Operator verify scan text message {string} appears in Shipment Inbound Box")
  public void operatorVerifyScanTextInShipmentInboundBox(String smallMessageAsString) {
    retryIfAssertionErrorOccurred(() -> {
      try {
        String smallMessage = resolveValue(smallMessageAsString);
        shipmentScanningPage.verifyScanTextAppearsInScanShipmentBox(smallMessage);
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        throw ex;
      }
    }, getCurrentMethodName(), 500, 2);
  }

  @Then("Operator verify small message {string} appears in Remove Shipment Container")
  public void operatorVerifySmallMessageAppearsInRemoveShipmentContainer(
      String smallMessageAsString) {
    String smallMessage = resolveValue(smallMessageAsString);
    shipmentScanningPage.verifySmallMessageAppearsInRemoveShipmentBox(smallMessage);
  }

  @Then("Operator verifies shipment to go with trip is shown with total {string}")
  public void operatorVerifiesShipmentToGoWithTripIsShownWithTotal(String totalAsString) {
    Long totalShipmentToGo = Long.valueOf(totalAsString);
    shipmentScanningPage.verifyShipmentToGoWithTrip(totalShipmentToGo);
  }

  @Then("Operator verifies shipment to unload is shown with total {string}")
  public void operatorVerifiesShipmentToUnloadIsShownWithTotal(String totalAsString) {
    Long totalShipmentToUnload = Long.valueOf(totalAsString);
    shipmentScanningPage.verifyShipmentToUnload(totalShipmentToUnload);
  }

  @When("Operator clicks shipment to go with trip")
  public void operatorClicksShipmentToGoWithTrip() {
    shipmentScanningPage.shipmentToGo.waitUntilClickable();
    shipmentScanningPage.shipmentToGo.click();
  }

  @When("Operator clicks shipment to unload")
  public void operatorClicksShipmentToUnload() {
    shipmentScanningPage.shipmentToUnload.waitUntilClickable();
    shipmentScanningPage.shipmentToUnload.click();
  }

  @Then("Operator verifies shipment with trip with data below:")
  public void operatorVerifiesShipmentWithTripWithData(Map<String, String> data) {
    final Map<String, String> finalData = resolveKeyValues(data);
    shipmentScanningPage.verifyShipmentWithTripData(finalData, "shipments to go with trip");
  }

  @Then("Operator verifies shipment to unload with data below:")
  public void operatorVerifiesShipmentToUnloadWithData(Map<String, String> data) {
    final Map<String, String> finalData = resolveKeyValues(data);
    shipmentScanningPage.verifyShipmentWithTripData(finalData, "shipments to unload");
  }

  @Then("Operator verifies created shipments data in shipment to go with trip with data below:")
  public void operatorVerifiesCreatedShipmentsDataInShipmentToGoWithTripData(
      Map<String, String> data) {
    final Map<String, String> finalData = resolveKeyValues(data);
    List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_IDS);
    finalData.put("shipmentIds", shipmentIds.toString().replace("[", "").replace("]", ""));
    shipmentScanningPage
        .verifyCreatedShipmentsShipmentToGoWithTripDataLastIndexTransitHub(finalData);
  }

  @When("Operator clicks shipment with id {string}")
  public void operatorClicksShipmentWithId(String shipmentIdAsString) {
    shipmentIdAsString = resolveValue(shipmentIdAsString);
    shipmentScanningPage.clickShipmentToGoWithId(shipmentIdAsString);
  }

  @Then("Operator verifies it will direct to shipment details page for shipment {string}")
  public void operatorVerifiesItWillDirectToShipmentDetailsPage(String shipmentIdAsString) {
    shipmentIdAsString = resolveValue(shipmentIdAsString);
    shipmentScanningPage.verifyShipmentDetailPageIsOpenedForShipmentWithId(shipmentIdAsString);
  }

  @Then("Operator verifies it able to scroll into row with shipment {string}")
  public void operatorVerifiesItAbleToScrollIntoRowWithShipment(String shipmentIdAsString) {
    shipmentIdAsString = resolveValue(shipmentIdAsString);
    shipmentScanningPage.verifyShipmentToGoTableToScrollInto(shipmentIdAsString);

  }

  @When("^Operator close current window and switch to Shipment management page$")
  public void operatorCloseCurrentWindow() {
    if (shipmentScanningPage.getWebDriver().getWindowHandles().size() > 1) {
      shipmentScanningPage.getWebDriver().close();
      String mainWindowHandle = get(KEY_MAIN_WINDOW_HANDLE);
      shipmentScanningPage.getWebDriver().switchTo().window(mainWindowHandle);
//            shipmentScanningPage.switchTo();
    }
  }

  @When("Operator click force complete trip in shipment inbound scanning page")
  public void operatorClickForceCompleteTripInShipmentInboundScanningPage() {
    shipmentScanningPage.forceCompleteButton.waitUntilClickable();
    shipmentScanningPage.forceCompleteButton.click();
    pause2s();
    shipmentScanningPage.getAntNotificationMessage();
  }

  @When("Operator opens new tab and switch to new tab in shipment inbound scanning page")
  public void operatorOpensNewTabInShipmentInboundScanningPage() {
    String mainWindowHandle = shipmentScanningPage.getWebDriver().getWindowHandle();
    put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
    ((JavascriptExecutor) shipmentScanningPage.getWebDriver()).executeScript("window.open()");
    Set<String> windowHandles = shipmentScanningPage.getWebDriver().getWindowHandles();
    for (String windowHandle : windowHandles) {
      if (!windowHandle.equalsIgnoreCase(mainWindowHandle)) {
        shipmentScanningPage.getWebDriver().switchTo().window(windowHandle);
      }
    }
    shipmentScanningPage.getWebDriver().get(TestConstants.OPERATOR_PORTAL_LOGIN_URL);
    shipmentScanningPage.waitUntilPageLoaded();
  }

  @When("Operator switch to main tab in shipment inbound scanning page")
  public void operatorSwitchToMainTabInShipmentInboundScanningPage() {
    String mainWindowHandle = get(KEY_MAIN_WINDOW_HANDLE);
    shipmentScanningPage.getWebDriver().switchTo().window(mainWindowHandle);
  }

  @When("Operator switch to new tab in shipment inbound scanning page")
  public void operatorSwitchToNewTabInShipmentInboundScanningPage() {
    Set<String> windowHandles = shipmentScanningPage.getWebDriver().getWindowHandles();
    String mainWindowHandle = get(KEY_MAIN_WINDOW_HANDLE);
    for (String windowHandle : windowHandles) {
      if (!windowHandle.equalsIgnoreCase(mainWindowHandle)) {
        shipmentScanningPage.getWebDriver().switchTo().window(windowHandle);
      }
    }

  }

  @Then("Operator close new tabs")
  @When("Operator close new tab in shipment inbound scanning page")
  public void operatorCloseNewTabInShipmentInboundScanningPage() {
    Set<String> windowHandles = shipmentScanningPage.getWebDriver().getWindowHandles();
    String mainWindowHandle = get(KEY_MAIN_WINDOW_HANDLE);
    for (String windowHandle : windowHandles) {
      if (!windowHandle.equalsIgnoreCase(mainWindowHandle)) {
        shipmentScanningPage.getWebDriver().switchTo().window(windowHandle).close();
      }
    }
    getWebDriver().switchTo().window(mainWindowHandle);
    shipmentScanningPage.switchTo();
    pause5s();
  }

  @And("Operator clicks {string} button on Add To Shipment page")
  public void operatorClicksButtonOnAddToShipmentPage(String buttonName) {
    switch (buttonName) {
      case "Close Shipment":
        shipmentScanningPage.closeShipment.click();
        break;
      case "Confirm Close Shipment":
        shipmentScanningPage.confirmCloseShipment.click();
        break;
    }
  }
}
