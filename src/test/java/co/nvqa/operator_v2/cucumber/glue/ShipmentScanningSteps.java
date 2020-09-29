package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.hub.Shipments;
import co.nvqa.operator_v2.model.ShipmentInfo;
import co.nvqa.operator_v2.selenium.page.ShipmentScanningPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.List;

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
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
        String shipmentType = containsKey(KEY_SHIPMENT_INFO) ?
                ((ShipmentInfo) get(KEY_SHIPMENT_INFO)).getShipmentType() :
                ((Shipments) get(KEY_CREATED_SHIPMENT)).getShipment().getShipmentType();


        shipmentScanningPage.selectHub(hub);
        shipmentScanningPage.selectShipmentType(shipmentType);
        shipmentScanningPage.selectShipmentId(shipmentId);
        shipmentScanningPage.clickSelectShipment();
        shipmentScanningPage.scanBarcode(trackingId);
        shipmentScanningPage.checkOrderInShipment(trackingId);
    }

    @And("Operator close the shipment which has been created")
    public void operatorCloseTheShipmentWhichHasBeenCreated() {
        shipmentScanningPage.closeShipment();
    }

    @When("^Operator scan multiple created order to shipment in hub ([^\"]*)$")
    public void aPIShipperTagsMultipleParcelsAsPerTheBelowTag(String hub) {
        List<String> trackingIds = (get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID));
        Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
        String shipmentType = containsKey(KEY_SHIPMENT_INFO) ?
                ((ShipmentInfo) get(KEY_SHIPMENT_INFO)).getShipmentType() :
                ((Shipments) get(KEY_CREATED_SHIPMENT)).getShipment().getShipmentType();


        shipmentScanningPage.selectHub(hub);
        shipmentScanningPage.selectShipmentType(shipmentType);
        shipmentScanningPage.selectShipmentId(shipmentId);
        shipmentScanningPage.clickSelectShipment();

        for (int i = 0; i < trackingIds.size(); i++) {
            shipmentScanningPage.scanBarcode(trackingIds.get(i));
        }
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
    public void operatorVerifiesShipmentNotFoundToastIsShown(String toastMessage) {
        toastMessage = resolveValue(toastMessage);
        shipmentScanningPage.verifyToastWithMessageIsShown(toastMessage);
    }

    @And("Operator verifies Scan Shipment Container color is {string}")
    public void operatorVerifiesScanShipmentContainerColorIs(String containerColorAsHex) {
        shipmentScanningPage.verifyScanShipmentColor(containerColorAsHex);
    }

    @When("Operator ends shipment inbound")
    public void operatorEndsShipmentInbound() {
        shipmentScanningPage.endShipmentInbound();
    }

    @When("Operator click remove button in scanned shipment table")
    public void operatorClickRemoveButtonInScannedShipmentTable() {
        shipmentScanningPage.clickRemoveButton();
    }

    @And("Operator verifies shipment not in shipment scanned into Trip")
    public void operatorVerifiesShipmentNotInShipmentScannedIntoTrip() {
        shipmentScanningPage.verifyShipmentNotExist();
    }

    @And("Operator enter shipment with id {string} in remove shipment")
    public void operatorEnterShipmentWithIdInRemoveShipment(String shipmentIdAsString) {
        String shipmentId = resolveValue(shipmentIdAsString);
        shipmentScanningPage.removeShipmentWithId(shipmentId);
    }
}
