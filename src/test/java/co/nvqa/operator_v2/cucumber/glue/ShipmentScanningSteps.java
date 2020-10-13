package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.hub.Shipments;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.ShipmentInfo;
import co.nvqa.operator_v2.selenium.page.ShipmentScanningPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.List;
import java.util.Map;

/**
 * @author Lanang Jati
 * <p>
 * Modified by Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ShipmentScanningSteps extends AbstractSteps {
    private ShipmentScanningPage shipmentScanningPage;

    public ShipmentScanningSteps() {
    }

    @Override
    public void init() {
        shipmentScanningPage = new ShipmentScanningPage(getWebDriver());
    }

    @When("^Operator scan the created order to shipment in hub ([^\"]*)$")
    public void operatorScanTheCreatedOrderToShipmentInHub(String hub) {
        retryIfRuntimeExceptionOccurred(() ->
        {
            try {
                String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
                Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
                String shipmentType = containsKey(KEY_SHIPMENT_INFO) ?
                        ((ShipmentInfo) get(KEY_SHIPMENT_INFO)).getShipmentType() :
                        ((Shipments) get(KEY_CREATED_SHIPMENT)).getShipment().getShipmentType();

                shipmentScanningPage.selectHub(hub);
                shipmentScanningPage.selectShipmentType(shipmentType);
                shipmentScanningPage.selectShipmentFilter.waitUntilVisible();
                shipmentScanningPage.selectShipmentFilter.selectValue(String.valueOf(shipmentId));
                shipmentScanningPage.clickSelectShipment();
                shipmentScanningPage.scanBarcode(trackingId);
                shipmentScanningPage.checkOrderInShipment(trackingId);
            } catch (Throwable ex) {
                NvLogger.error(ex.getMessage());
                NvLogger.info("Searched element is not found, retrying after 2 seconds...");
                navigateRefresh();
                pause2s();
                throw ex;
            }
        }, 10);
    }

    @And("Operator close the shipment which has been created")
    public void operatorCloseTheShipmentWhichHasBeenCreated() {
        shipmentScanningPage.closeShipment();
    }

    @And("Operator close shipment with data below:")
    public void operatorCloseShipmentWithDataBelow(Map<String, String> mapOfData) {
        mapOfData = resolveKeyValues(mapOfData);
        String hubName = mapOfData.get("origHubName");
        String shipmentType = mapOfData.get("shipmentType");
        String shipmentId = mapOfData.get("shipmentId");
        shipmentScanningPage.closeShipmentWithData(hubName, shipmentType, shipmentId);
    }

    @When("^Operator scan multiple created order to shipment in hub ([^\"]*)$")
    public void aPIShipperTagsMultipleParcelsAsPerTheBelowTag(String hub) {
        retryIfRuntimeExceptionOccurred(() ->
        {
            try {
                List<String> trackingIds = (get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID));
                Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
                String shipmentType = containsKey(KEY_SHIPMENT_INFO) ?
                        ((ShipmentInfo) get(KEY_SHIPMENT_INFO)).getShipmentType() :
                        ((Shipments) get(KEY_CREATED_SHIPMENT)).getShipment().getShipmentType();


                shipmentScanningPage.selectHub(hub);
                shipmentScanningPage.selectShipmentType(shipmentType);
                shipmentScanningPage.selectShipmentId(shipmentId);
                shipmentScanningPage.clickSelectShipment();

                for (String trackingId : trackingIds) {
                    shipmentScanningPage.scanBarcode(trackingId);
                }
            } catch (Throwable ex) {
                NvLogger.error(ex.getMessage());
                NvLogger.info("Searched element is not found, retrying after 2 seconds...");
                navigateRefresh();
                pause2s();
                throw ex;
            }
        }, 10);
    }

    @And("Operator removes the parcel from the shipment")
    public void operatorRemovesTheParcelFromTheShipment() {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        shipmentScanningPage.removeOrderFromShipment(trackingId);
    }

    @Then("Operator verifies that the parcels shown are decreased")
    public void operatorVerifiesThatTheParcelsShownAreDecreased() {
        List<Order> orders = get(KEY_LIST_OF_CREATED_ORDER);
        int actualSumOfOrder = orders.size() - 1;
        shipmentScanningPage.verifyTheSumOfOrderIsDecreased(actualSumOfOrder);
    }

    @And("Operator removes all the parcel from the shipment")
    public void operatorRemovesAllTheParcelFromTheShipment() {
        shipmentScanningPage.removeAllOrdersFromShipment();
    }

    @Then("Operator verifies that the parcel shown is zero")
    public void operatorVerifiesThatTheParcelShownIsZero() {
        shipmentScanningPage.verifyTheSumOfOrderIsZero();
    }

    @And("Operator verifies that the row of the added order is red highlighted")
    public void operatorVerifiesThatTheRowOfTheAddedOrderIsRedHighlighted() {
        shipmentScanningPage.verifyOrderIsRedHighlighted();
    }

    @And("Operator scan shipment with id {string}")
    public void operatorScanTheCreatedShipment(String shipmentIdAsString) {
        String shipmentId = resolveValue(shipmentIdAsString);
        shipmentScanningPage.scanBarcode(shipmentId);
    }

    @Then("Operator verifies toast with message {string} is shown on Shipment Inbound Scanning page")
    public void operatorVerifiesToastWithMessageIsShown(String toastMessage) {
        toastMessage = resolveValue(toastMessage);
        shipmentScanningPage.verifyToastWithMessageIsShown(toastMessage);
    }

    @Then("Operator verifies toast bottom with message {string} is shown on Shipment Inbound Scanning page")
    public void operatorVerifiesToastBottomWithMessageIsShownOnShipmentInboundScanningPage(String toastMessage) {
        toastMessage = resolveValue(toastMessage);
        shipmentScanningPage.verifyBottomToastWithMessageIsShown(toastMessage);
    }

    @Then("Operator verifies toast with message containing {string} is shown on Shipment Inbound Scanning page")
    public void operatorVerifiesToastContainingMessageIsShown(String toastMessage) {
        toastMessage = resolveValue(toastMessage);
        shipmentScanningPage.verifyToastContainingMessageIsShown(toastMessage);
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

    @Then("^Operator verify the trip Details is correct on shipment inbound scanning page using data below:$")
    public void operatorVerifyTheTripDetailsIsCorrectOnShipmentInboundScanningPageUsingDataBelow(Map<String, String> data) {
        final Map<String, String> finalData = resolveKeyValues(data);
        String inboundHub = finalData.get("inboundHub");
        String inboundType = finalData.get("inboundType");
        String driver = finalData.get("driver");
        String destinationHub = finalData.get("destinationHub");
        shipmentScanningPage.verifyTripData(inboundHub, inboundType, driver, destinationHub);
    }

    @And("Operator clicks proceed in end inbound dialog {string}")
    public void operatorClicksProceedInEndInboundDialog(String inboundType) {
        if (inboundType.equals("Van Inbound")) {
            shipmentScanningPage.clickProceedInTripDepartureDialog();
            return;
        }
        shipmentScanningPage.clickProceedInEndInboundDialog();
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
    public void operatorVerifiesShipmentWithIdAppearsInErrorShipmentDialogWithResult(String shipmentIdAsString, String resultString) {
        retryIfAssertionErrorOccurred(() -> {
            try {
                String shipmentId = resolveValue(shipmentIdAsString);
                String resultStringValue = resolveValue(resultString);
                shipmentScanningPage.verifyErrorShipmentWithMessage(shipmentId, resultStringValue);
            } catch (Throwable ex) {
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
    public void operatorVerifySmallMessageAppearsInShipmentInboundBox(String smallMessageAsStrin) {
        String smallMessage = resolveValue(smallMessageAsStrin);
        shipmentScanningPage.verifySmallMessageAppearsInScanShipmentBox(smallMessage);
    }

    @Then("Operator verify small message {string} appears in Remove Shipment Container")
    public void operatorVerifySmallMessageAppearsInRemoveShipmentContainer(String smallMessage) {
        smallMessage = resolveValue(smallMessage);
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
        shipmentScanningPage.verifyShipmentWithTripData(finalData);
    }

    @Then("Operator verifies created shipments data in shipment to go with trip with data below:")
    public void operatorVerifiesCreatedShipmentsDataInShipmentToGoWithTripData(Map<String, String> data) {
        final Map<String, String> finalData = resolveKeyValues(data);
        List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_IDS);
        finalData.put("shipmentIds", shipmentIds.toString().replace("[", "").replace("]", ""));
        shipmentScanningPage.verifyCreatedShipmentsShipmentToGoWithTripDataLastIndexTransitHub(finalData);
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
}
