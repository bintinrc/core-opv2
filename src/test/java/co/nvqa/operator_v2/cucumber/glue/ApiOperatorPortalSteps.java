package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.StandardApiOperatorPortalSteps;
import co.nvqa.commons.utils.StandardScenarioStorage;
import com.google.inject.Inject;
import cucumber.api.DataTable;
import cucumber.api.java.After;
import cucumber.api.java.en.Given;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class ApiOperatorPortalSteps extends StandardApiOperatorPortalSteps<ScenarioManager>
{
    @Inject
    public ApiOperatorPortalSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
    }

    @After("@ArchiveRoute")
    public void apiOperatorArchiveRoute()
    {
        super.apiOperatorArchiveRoute();
    }

    @After("@CleanUpReservationAndAddress")
    public void apiOperatorCleanUpReservationAndAddress()
    {
        /**
         * This method is not use anymore because we cannot delete reservation & address.
         */
    }

    @Given("^API Operator create new shipper address using data below:$")
    @Override
    public void apiOperatorCreateNewShipperAddressUsingDataBelow(DataTable dataTable)
    {
        super.apiOperatorCreateNewShipperAddressUsingDataBelow(dataTable);
    }

    @Given("^API Operator create reservation using data below:$")
    @Override
    public void apiOperatorCreateReservationUsingDataBelow(DataTable dataTable)
    {
        super.apiOperatorCreateReservationUsingDataBelow(dataTable);
    }

    @Given("^API Operator create new route using data below:$")
    @Override
    public void apiOperatorCreateNewRouteUsingDataBelow(DataTable dataTable)
    {
        super.apiOperatorCreateNewRouteUsingDataBelow(dataTable);
    }

    @Given("^Operator set tags of the new created route to \\[([^\"]*)]$")
    @Override
    public void operatorSetTagsOfTheNewCreatedRouteTo(String strTagIds)
    {
        super.operatorSetTagsOfTheNewCreatedRouteTo(strTagIds);
    }

    @Given("^API Operator add reservation pick-up to the route$")
    @Override
    public void apiOperatorAddReservationPickUpToTheRoute()
    {
        super.apiOperatorAddReservationPickUpToTheRoute();
    }

    @Given("^API Operator Global Inbound parcel using data below:$")
    @Override
    public void apiOperatorGlobalInboundParcelUsingDataBelow(DataTable dataTable)
    {
        super.apiOperatorGlobalInboundParcelUsingDataBelow(dataTable);
    }

    @Given("^API Operator Outbound Scan parcel using data below:$")
    @Override
    public void apiOperatorOutboundParcelUsingDataBelow(DataTable dataTable)
    {
        super.apiOperatorOutboundParcelUsingDataBelow(dataTable);
    }

    @Given("^API Operator Global Inbound multiple parcels using data below:$")
    @Override
    public void apiOperatorGlobalInboundMultipleParcelsUsingDataBelow(DataTable dataTable)
    {
        super.apiOperatorGlobalInboundMultipleParcelsUsingDataBelow(dataTable);
    }

    @Given("^API Operator add parcel to the route using data below:$")
    @Override
    public void apiOperatorAddParcelToTheRouteUsingDataBelow(DataTable dataTable)
    {
        super.apiOperatorAddParcelToTheRouteUsingDataBelow(dataTable);
    }

    @Given("^API Operator add multiple parcel to the route using data below:$")
    @Override
    public void apiOperatorAddMultipleParcelToTheRouteUsingDataBelow(DataTable dataTable)
    {
        super.apiOperatorAddMultipleParcelToTheRouteUsingDataBelow(dataTable);
    }

    @Given("^API Operator Van Inbound parcel$")
    @Override
    public void apiOperatorVanInboundParcel()
    {
        super.apiOperatorVanInboundParcel();
    }

    @Given("^API Operator start the route$")
    @Override
    public void apiOperatorStartTheRoute()
    {
        super.apiOperatorStartTheRoute();
    }

    @Given("^API Operator merge route transactions$")
    @Override
    public void apiOperatorMergeRouteTransactions()
    {
        super.apiOperatorMergeRouteTransactions();
    }

    @Given("^API Operator verify order info after Global Inbound$")
    @Override
    public void apiOperatorVerifyOrderInfoAfterGlobalInbound()
    {
        super.apiOperatorVerifyOrderInfoAfterGlobalInbound();
    }

    @Given("^API Operator get order details$")
    @Override
    public void apiOperatorGetOrderDetails()
    {
        super.apiOperatorGetOrderDetails();
    }

    @Given("^API Operator verify order info after Van Inbound$")
    @Override
    public void apiOperatorVerifyOrderInfoAfterVanInbound()
    {
        super.apiOperatorVerifyOrderInfoAfterVanInbound();
    }

    @Given("^API Operator verify order info after pickup \"([^\"]*)\"$")
    @Override
    public void apiOperatorVerifyOrderInfoAfterPickup(String expectedPickUpStatus)
    {
        super.apiOperatorVerifyOrderInfoAfterPickup(expectedPickUpStatus);
    }

    @Given("^API Operator verify order info after delivery \"([^\"]*)\"$")
    @Override
    public void apiOperatorVerifyOrderInfoAfterDelivery(String expectedDeliveryStatus)
    {
        super.apiOperatorVerifyOrderInfoAfterDelivery(expectedDeliveryStatus);
    }

    @Given("^API Operator assign delivery waypoint of an order to DP with ID = \"([^\"]*)\"$")
    @Override
    public void apiOperatorAssignDeliveryWaypointOfAnOrderToDpWithId(String dpIdAsString)
    {
        super.apiOperatorAssignDeliveryWaypointOfAnOrderToDpWithId(dpIdAsString);
    }

    @Given("^API Operator verify order info after Operator assign delivery waypoint of an order to DP$")
    @Override
    public void apiOperatorVerifyOrderInfoAfterOperatorAssignDeliveryWaypointOfAnOrderToDp()
    {
        super.apiOperatorVerifyOrderInfoAfterOperatorAssignDeliveryWaypointOfAnOrderToDp();
    }

    @Given("^API Operator get DP information by DP ID for DP with ID = \"([^\"]*)\"$")
    @Override
    public void apiOperatorGetDpInformationByDpIdForDpWithId(String dpIdAsString)
    {
        super.apiOperatorGetDpInformationByDpIdForDpWithId(dpIdAsString);
    }

    @Given("^API Operator ([^\"]*) auto reservation for Shipper with ID = \"([^\"]*)\"$")
    @Override
    public void apiOperatorEnableOrDisableAutoReservationForShipperWithId(String enableAutoReservation, String shipperIdAsString)
    {
        super.apiOperatorEnableOrDisableAutoReservationForShipperWithId(enableAutoReservation, shipperIdAsString);
    }

    @Given("^API Operator ([^\"]*) auto reservation for Shipper with ID = \"([^\"]*)\" and change shipper default address to the new address$")
    @Override
    public void apiOperatorEnableOrDisableAutoReservationForShipperWithSpecificIdAndChangeShipperDefaultAddressToTheNewAddress(String enableAutoReservation, String shipperIdAsString)
    {
        super.apiOperatorEnableOrDisableAutoReservationForShipperWithSpecificIdAndChangeShipperDefaultAddressToTheNewAddress(enableAutoReservation, shipperIdAsString);
    }

    @Given("^API Operator update DNR ID of Delivery Transaction to \"(-?\\d+)\"$")
    @Override
    public void apiOperatorUpdateDnrIdOfDeliveryTransaction(int expectedDnrId)
    {
        super.apiOperatorUpdateDnrIdOfDeliveryTransaction(expectedDnrId);
    }

    @Given("^API Operator trigger overstay job$")
    @Override
    public void apiOperatorTriggerOverstayJob()
    {
        super.apiOperatorTriggerOverstayJob();
    }

    @Given("^API Operator find automatically created reservation on shipper with ID = \"([^\"]*)\"$")
    @Override
    public void apiOperatorFindAutomaticallyCreatedReservationOnShipperWithId(String shipperIdAsString)
    {
        super.apiOperatorFindAutomaticallyCreatedReservationOnShipperWithId(shipperIdAsString);
    }

    @Given("^API Operator drop off parcel to DP using data below:$")
    @Override
    public void apiOperatorDropOffParcelToDpUsingDataBelow(DataTable dataTable)
    {
        super.apiOperatorDropOffParcelToDpUsingDataBelow(dataTable);
    }

    @Given("^API Operator add Reservation to Route Group with ID = \"([^\"]*)\"$")
    @Override
    public void apiOperatorAddReservationToRouteGroupWithId(String routeGroupIdAsString)
    {
        super.apiOperatorAddReservationToRouteGroupWithId(routeGroupIdAsString);
    }

    @Given("^API Operator verify order info after failed pickup C2C/Return order rescheduled on next day$")
    @Override
    public void apiOperatorVerifyOrderInfoAfterFailedPickupC2cOrReturnOrderRescheduledOnNextDay()
    {
        super.apiOperatorVerifyOrderInfoAfterFailedPickupC2cOrReturnOrderRescheduledOnNextDay();
    }

    @Given("^API Operator verify order info after failed pickup C2C/Return order rescheduled on next 2 days$")
    @Override
    public void apiOperatorVerifyOrderInfoAfterFailedPickupC2cOrReturnOrderRescheduledOnNext2Days()
    {
        super.apiOperatorVerifyOrderInfoAfterFailedPickupC2cOrReturnOrderRescheduledOnNext2Days();
    }

    @Given("^API Operator verify order info after failed delivery order rescheduled on next day$")
    @Override
    public void apiOperatorVerifyOrderInfoAfterFailedDeliveryOrderRescheduledOnNextDay()
    {
        super.apiOperatorVerifyOrderInfoAfterFailedDeliveryOrderRescheduledOnNextDay();
    }

    @Given("^API Operator verify order info after failed delivery order rescheduled on next 2 days$")
    @Override
    public void apiOperatorVerifyOrderInfoAfterFailedDeliveryOrderRescheduledOnNext2Days()
    {
        super.apiOperatorVerifyOrderInfoAfterFailedDeliveryOrderRescheduledOnNext2Days();
    }

    @Given("^API Operator verify order info after failed delivery order RTS-ed on next day$")
    @Override
    public void apiOperatorVerifyOrderInfoAfterFailedDeliveryOrderRtsedOnNextDay()
    {
        super.apiOperatorVerifyOrderInfoAfterFailedDeliveryOrderRtsedOnNextDay();
    }

    @Given("^API Operator verify order info after failed delivery aged parcel global inbounded and rescheduled on next day$")
    @Override
    public void apiOperatorVerifyOrderInfoAfterFailedDeliveryAgedParcelGlobalInboundedAndRescheduledOnNextDay()
    {
        super.apiOperatorVerifyOrderInfoAfterFailedDeliveryAgedParcelGlobalInboundedAndRescheduledOnNextDay();
    }

    @Given("^API Operator verify order info after failed delivery aged parcel global inbounded and rescheduled on next 2 days$")
    @Override
    public void apiOperatorVerifyOrderInfoAfterFailedDeliveryAgedParcelGlobalInboundedAndRescheduledOnNext2Days()
    {
        super.apiOperatorVerifyOrderInfoAfterFailedDeliveryAgedParcelGlobalInboundedAndRescheduledOnNext2Days();
    }

    @Given("^API Operator verify order info after failed delivery aged parcel global inbounded and RTS-ed on next day$")
    @Override
    public void apiOperatorVerifyOrderInfoAfterFailedDeliveryAgedParcelGlobalInboundedAndRtsedOnNextDay()
    {
        super.apiOperatorVerifyOrderInfoAfterFailedDeliveryAgedParcelGlobalInboundedAndRtsedOnNextDay();
    }
}
