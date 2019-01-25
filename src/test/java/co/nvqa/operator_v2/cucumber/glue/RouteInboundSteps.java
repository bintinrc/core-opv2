package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Reservation;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.model.WaypointOrderInfo;
import co.nvqa.operator_v2.model.WaypointPerformance;
import co.nvqa.operator_v2.model.WaypointReservationInfo;
import co.nvqa.operator_v2.model.WaypointShipperInfo;
import co.nvqa.operator_v2.selenium.page.RouteInboundPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import org.apache.commons.lang3.StringUtils;

import java.text.ParseException;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteInboundSteps extends AbstractSteps
{
    private static final String FETCH_BY_ROUTE_ID = "FETCH_BY_ROUTE_ID";
    private static final String FETCH_BY_TRACKING_ID = "FETCH_BY_TRACKING_ID";
    private static final String FETCH_BY_DRIVER = "FETCH_BY_DRIVER";

    private RouteInboundPage routeInboundPage;

    public RouteInboundSteps()
    {
    }

    @Override
    public void init()
    {
        routeInboundPage = new RouteInboundPage(getWebDriver());
    }

    @When("^Operator get Route Summary Details on Route Inbound page using data below:$")
    public void operatorGetRouteDetailsOnRouteInboundPageUsingDataBelow(Map<String, String> mapOfData)
    {
        String hubName = mapOfData.get("hubName");
        String fetchBy = mapOfData.get("fetchBy");
        String fetchByValue = mapOfData.get("fetchByValue");

        switch(fetchBy.toUpperCase())
        {
            case FETCH_BY_ROUTE_ID:
                Long routeId = "GET_FROM_CREATED_ROUTE".equals(fetchByValue) ? get(KEY_CREATED_ROUTE_ID) : Long.parseLong(fetchByValue);
                routeInboundPage.fetchRouteByRouteId(hubName, routeId);
                break;
            case FETCH_BY_TRACKING_ID:
                String trackingId = "GET_FROM_CREATED_ROUTE".equals(fetchByValue) ? get(KEY_CREATED_ORDER_TRACKING_ID) : fetchByValue;
                routeInboundPage.fetchRouteByTrackingId(hubName, trackingId);
                break;
            case FETCH_BY_DRIVER:
                routeId = get(KEY_CREATED_ROUTE_ID);
                routeInboundPage.fetchRouteByDriver(hubName, fetchByValue, routeId);
                break;
        }
    }

    @Then("^Operator verify the Route Summary Details is correct using data below:$")
    public void operatorVerifyTheRouteSummaryDetailsIsCorrectUsingDataBelow(Map<String, String> mapOfData)
    {
        String routeIdAsString = mapOfData.get("routeId");
        String driverName = mapOfData.get("driverName");
        String hubName = mapOfData.get("hubName");
        String routeDateAsString = mapOfData.get("routeDate");

        Long routeId;

        if("GET_FROM_CREATED_ROUTE".equals(routeIdAsString))
        {
            routeId = get(KEY_CREATED_ROUTE_ID);
        }
        else
        {
            routeId = Long.parseLong(routeIdAsString);
        }

        Date routeDate;

        try
        {
            if("GET_FROM_CREATED_ROUTE".equals(routeDateAsString))
            {
                Route route = get(KEY_CREATED_ROUTE);
                routeDate = ISO_8601_WITHOUT_MILLISECONDS.parse(route.getCreatedAt());
            }
            else
            {
                routeDate = ISO_8601_WITHOUT_MILLISECONDS.parse(routeDateAsString);
            }
        }
        catch(ParseException ex)
        {
            throw new NvTestRuntimeException("Failed to parse route date.", ex);
        }

        WaypointPerformance waypointPerformance = new WaypointPerformance();
        waypointPerformance.setPending(Integer.parseInt(mapOfData.get("wpPending")));
        waypointPerformance.setPartial(Integer.parseInt(mapOfData.get("wpPartial")));
        waypointPerformance.setFailed(Integer.parseInt(mapOfData.get("wpFailed")));
        waypointPerformance.setCompleted(Integer.parseInt(mapOfData.get("wpCompleted")));
        waypointPerformance.setTotal(Integer.parseInt(mapOfData.get("wpTotal")));

        routeInboundPage.verifyRouteSummaryInfoIsCorrect(routeId, driverName, hubName, routeDate, waypointPerformance, null);
    }

    @When("^Operator open Pending Waypoints Info dialog on Route Inbound page$")
    public void operatorOpenPendingWaypointsInfoDialogOnRouteInboundPage()
    {
        routeInboundPage.openPendingWaypointsDialog();
    }


    @Then("^Operator verify Shippers Info in (.+) Waypoints dialog using data below:$")
    public void operatorVerifyShippersInfoInPendingWaypointsDialogUsingDataBelow(String status, List<Map<String, String>> listOfData)
    {
        List<WaypointShipperInfo> expectedShippersInfo = listOfData.stream().map(data ->
        {
            WaypointShipperInfo shipperInfo = new WaypointShipperInfo();
            shipperInfo.fromMap(data);
            return shipperInfo;
        }).collect(Collectors.toList());
        routeInboundPage.validateShippersTable(expectedShippersInfo);
    }

    @When("^Operator click 'View orders or reservations' button for shipper #(\\d+) in Pending Waypoints dialog$")
    public void operatorClickViewOrdersOrReservationsButtonForShipperInPendingWaypointsDialog(int index)
    {
        routeInboundPage.openViewOrdersOrReservationsDialog(index);
    }

    @SuppressWarnings("unchecked")
    @Then("^Operator verify Reservations table in Pending Waypoints dialog using data below:$")
    public void operatorVerifyReservationsTableInPendingWaypointsDialogUsingDataBelow(List<Map<String, String>> listOfData)
    {
        List<WaypointReservationInfo> expectedReservationsInfo = listOfData.stream().map(data ->
        {
            WaypointReservationInfo reservationInfo = new WaypointReservationInfo();
            String value = data.get("reservationId");

            if(StringUtils.equalsIgnoreCase("GET_FROM_CREATED_RESERVATION", value))
            {
                value = String.valueOf(get(KEY_CREATED_RESERVATION_ID));
            }
            else if(StringUtils.startsWithIgnoreCase(value, "GET_FROM_CREATED_RESERVATION_"))
            {
                int index = Integer.parseInt(value.replace("GET_FROM_CREATED_RESERVATION_", "").trim()) - 1;
                value = String.valueOf(((List<Object>) get(KEY_LIST_OF_CREATED_RESERVATION_IDS)).get(index));
            }

            if(StringUtils.isNotBlank(value))
            {
                reservationInfo.setReservationId(value);
            }

            value = data.get("location");

            if(StringUtils.equalsIgnoreCase("GET_FROM_CREATED_ADDRESS", value))
            {
                reservationInfo.setLocation((Address) get(KEY_CREATED_ADDRESS));
            }
            else if(StringUtils.startsWithIgnoreCase(value, "GET_FROM_CREATED_ADDRESS_"))
            {
                int index = Integer.parseInt(value.replace("GET_FROM_CREATED_ADDRESS_", "").trim()) - 1;
                reservationInfo.setLocation(((List<Address>) get(KEY_LIST_OF_CREATED_ADDRESSES)).get(index));
            }
            else if(StringUtils.isNotBlank(value))
            {
                reservationInfo.setLocation(value);
            }

            value = data.get("readyToLatestTime");

            if(StringUtils.equalsIgnoreCase("GET_FROM_CREATED_RESERVATION", value))
            {
                Reservation reservation = get(KEY_CREATED_RESERVATION);
                value = reservation.getReadyDatetime() + " - " + reservation.getLatestDatetime();
            }
            else if(StringUtils.startsWithIgnoreCase(value, "GET_FROM_CREATED_RESERVATION_"))
            {
                int index = Integer.parseInt(value.replace("GET_FROM_CREATED_RESERVATION_", "").trim()) - 1;
                Reservation reservation = ((List<Reservation>) get(KEY_LIST_OF_CREATED_RESERVATIONS)).get(index);
                value = reservation.getReadyDatetime() + " - " + reservation.getLatestDatetime();
            }

            if(StringUtils.isNotBlank(value))
            {
                //reservationInfo.setReadyToLatestTime(value);
            }

            value = data.get("approxVolume");

            if(StringUtils.equalsIgnoreCase("GET_FROM_CREATED_RESERVATION", value))
            {
                Reservation reservation = get(KEY_CREATED_RESERVATION);
                value = reservation.getApproxVolume();
            }
            else if(StringUtils.startsWithIgnoreCase(value, "GET_FROM_CREATED_RESERVATION_"))
            {
                int index = Integer.parseInt(value.replace("GET_FROM_CREATED_RESERVATION_", "").trim()) - 1;
                Reservation reservation = ((List<Reservation>) get(KEY_LIST_OF_CREATED_RESERVATIONS)).get(index);
                value = reservation.getApproxVolume();
            }

            if(StringUtils.isNotBlank(value))
            {
                reservationInfo.setApproxVolume(value);
            }

            value = data.get("status");

            if(StringUtils.isNotBlank(value))
            {
                reservationInfo.setStatus(value);
            }

            value = data.get("receivedParcels");

            if(StringUtils.isNotBlank(value))
            {
                reservationInfo.setReceivedParcels(value);
            }

            return reservationInfo;
        }).collect(Collectors.toList());

        routeInboundPage.validateReservationsTable(expectedReservationsInfo);
    }

    @SuppressWarnings("unchecked")
    @Then("^Operator verify Orders table in Pending Waypoints dialog using data below:$")
    public void operatorVerifyOrdersTableInPendingWaypointsDialogUsingDataBelow(List<Map<String, String>> listOfData)
    {
        List<WaypointOrderInfo> expectedOrdersInfo = listOfData.stream().map(data ->
        {
            WaypointOrderInfo orderInfo = new WaypointOrderInfo();
            String value = data.get("trackingId");

            if(StringUtils.equalsIgnoreCase("GET_FROM_CREATED_ORDER", value))
            {
                value = String.valueOf(get(KEY_CREATED_ORDER_TRACKING_ID));
            }
            else if(StringUtils.startsWithIgnoreCase(value, "GET_FROM_CREATED_ORDER_"))
            {
                int index = Integer.parseInt(value.replace("GET_FROM_CREATED_ORDER_", "").trim()) - 1;
                value = String.valueOf(((List<Object>) get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID)).get(index));
            }

            if(StringUtils.isNotBlank(value))
            {
                orderInfo.setTrackingId(value);
            }

            value = data.get("location");

            if(StringUtils.equalsIgnoreCase("GET_FROM_CREATED_ORDER", value))
            {
                Order order = get(KEY_CREATED_ORDER);
                orderInfo.setLocation(order);
            }
            else if(StringUtils.startsWithIgnoreCase(value, "GET_FROM_CREATED_ORDER_"))
            {
                int index = Integer.parseInt(value.replace("GET_FROM_CREATED_ORDER_", "").trim()) - 1;
                orderInfo.setLocation(((List<Order>) get(KEY_LIST_OF_CREATED_ORDER)).get(index));
            }
            else if(StringUtils.isNotBlank(value))
            {
                orderInfo.setLocation(value);
            }

            value = data.get("type");

            if(StringUtils.isNotBlank(value))
            {
                orderInfo.setType(value);
            }

            value = data.get("status");

            if(StringUtils.isNotBlank(value))
            {
                orderInfo.setStatus(value);
            }

            value = data.get("cmiCount");

            if(StringUtils.isNotBlank(value))
            {
                orderInfo.setCmiCount(value);
            }

            value = data.get("routeInboundStatus");

            if(StringUtils.isNotBlank(value))
            {
                orderInfo.setRouteInboundStatus(value);
            }

            return orderInfo;
        }).collect(Collectors.toList());

        routeInboundPage.validateOrdersTable(expectedOrdersInfo);
    }

    @When("^Operator click 'Continue To Inbound' button on Route Inbound page$")
    public void operatorClickContinueToInboundButtonOnRouteInboundPage()
    {
        routeInboundPage.clickContinueToInbound();
    }

    @And("^Operator scan a tracking ID of created order on Route Inbound page$")
    public void operatorScanATrackingIDOfCreatedOrderOnRouteInboundPage()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        routeInboundPage.scanTrackingId(trackingId);
    }

    @When("^Operator click 'Go Back' button on Route Inbound page$")
    public void operatorClickGoBackButtonOnRouteInboundPage()
    {
        routeInboundPage.clickGoBack();
    }

    @When("^Operator open Completed Waypoints Info dialog on Route Inbound page$")
    public void operatorOpenCompletedWaypointsInfoDialogOnRouteInboundPage()
    {
        routeInboundPage.openCompletedWaypointsDialog();
    }

    @When("^Operator open Failed Waypoints Info dialog on Route Inbound page$")
    public void operatorOpenFailedWaypointsInfoDialogOnRouteInboundPage()
    {
        routeInboundPage.openFailedWaypointsDialog();
    }
}
