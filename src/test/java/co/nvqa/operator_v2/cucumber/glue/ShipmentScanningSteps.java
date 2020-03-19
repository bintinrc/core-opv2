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
 *
 * @author Lanang Jati
 *
 * Modified by Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ShipmentScanningSteps extends AbstractSteps
{
    private ShipmentScanningPage shipmentScanningPage;

    public ShipmentScanningSteps()
    {
    }

    @Override
    public void init()
    {
        shipmentScanningPage = new ShipmentScanningPage(getWebDriver());
    }

    @When("^Operator scan the created order to shipment in hub ([^\"]*)$")
    public void operatorScanTheCreatedOrderToShipmentInHub(String hub)
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
        String shipmentType = containsKey(KEY_SHIPMENT_INFO) ?
                ((ShipmentInfo) get(KEY_SHIPMENT_INFO)).getShipmentType() :
                ((Shipments)get(KEY_CREATED_SHIPMENT)).getShipment().getShipmentType();


        shipmentScanningPage.selectHub(hub);
        shipmentScanningPage.selectShipmentType(shipmentType);
        shipmentScanningPage.selectShipmentId(shipmentId);
        shipmentScanningPage.clickSelectShipment();
        shipmentScanningPage.scanBarcode(trackingId);
        shipmentScanningPage.checkOrderInShipment(trackingId);
    }

    @And("Operator close the shipment which has been created")
    public void operatorCloseTheShipmentWhichHasBeenCreated()
    {
        shipmentScanningPage.closeShipment();
    }

    @When("^Operator scan multiple created order to shipment in hub ([^\"]*)$")
    public void aPIShipperTagsMultipleParcelsAsPerTheBelowTag(String hub)
    {
        List<String> trackingIds = (get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID));
        Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
        String shipmentType = containsKey(KEY_SHIPMENT_INFO) ?
                ((ShipmentInfo) get(KEY_SHIPMENT_INFO)).getShipmentType() :
                ((Shipments)get(KEY_CREATED_SHIPMENT)).getShipment().getShipmentType();


        shipmentScanningPage.selectHub(hub);
        shipmentScanningPage.selectShipmentType(shipmentType);
        shipmentScanningPage.selectShipmentId(shipmentId);
        shipmentScanningPage.clickSelectShipment();

        for (int i = 0; i < trackingIds.size(); i++) {
            shipmentScanningPage.scanBarcode(trackingIds.get(i));
        }
    }

    @And("Operator removes the parcel from the shipment")
    public void operatorRemovesTheParcelFromTheShipment()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        shipmentScanningPage.removeOrderFromShipment(trackingId);
    }

    @Then("Operator verifies that the parcels shown are decreased")
    public void operatorVerifiesThatTheParcelsShownAreDecreased()
    {
        List<Order> orders = get(KEY_LIST_OF_CREATED_ORDER);
        int actualSumOfOrder = orders.size()-1;
        shipmentScanningPage.verifiesTheSumOfOrderIsDecreased(actualSumOfOrder);
    }

    @And("Operator removes all the parcel from the shipment")
    public void operatorRemovesAllTheParcelFromTheShipment()
    {
        shipmentScanningPage.removeAllOrdersFromShipment();
    }

    @Then("Operator verifies that the parcel shown is zero")
    public void operatorVerifiesThatTheParcelShownIsZero()
    {
        shipmentScanningPage.verifiesTheSumOfOrderIsZero();
    }

    @And("Operator verifies that the row of the added order is red highlighted")
    public void operatorVerifiesThatTheRowOfTheAddedOrderIsRedHighlighted()
    {
        shipmentScanningPage.verifiesOrderIsRedHighlighted();
    }
}
