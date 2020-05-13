package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Reservation;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.ExpectedScans;
import co.nvqa.operator_v2.model.MoneyCollection;
import co.nvqa.operator_v2.model.WaypointOrderInfo;
import co.nvqa.operator_v2.model.WaypointPerformance;
import co.nvqa.operator_v2.model.WaypointReservationInfo;
import co.nvqa.operator_v2.model.WaypointShipperInfo;
import co.nvqa.operator_v2.selenium.page.RouteInboundPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.StringUtils;
import org.junit.jupiter.api.Assertions;

import java.text.ParseException;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteInboundSteps extends AbstractSteps
{
    private static final String FETCH_BY_ROUTE_ID = "FETCH_BY_ROUTE_ID";
    private static final String FETCH_BY_TRACKING_ID = "FETCH_BY_TRACKING_ID";
    private static final String FETCH_BY_DRIVER = "FETCH_BY_DRIVER";
    private static final String KEY_ROUTE_INBOUND_COMMENT = "KEY_ROUTE_INBOUND_COMMENT";

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
        mapOfData = resolveKeyValues(mapOfData);
        String hubName = mapOfData.get("hubName");
        String fetchBy = mapOfData.get("fetchBy");
        String fetchByValue = mapOfData.get("fetchByValue");
        String routeIdValue = mapOfData.get("routeId");
        Long routeId = getRouteId(routeIdValue);

        switch (fetchBy.toUpperCase())
        {
            case FETCH_BY_ROUTE_ID:
                routeId = routeId != null ? routeId : Long.valueOf(fetchByValue);
                routeInboundPage.fetchRouteByRouteId(hubName, routeId);
                break;
            case FETCH_BY_TRACKING_ID:
                String trackingId = "GET_FROM_CREATED_ROUTE".equals(fetchByValue) ? get(KEY_CREATED_ORDER_TRACKING_ID) : fetchByValue;
                routeInboundPage.fetchRouteByTrackingId(hubName, trackingId, routeId);
                break;
            case FETCH_BY_DRIVER:
                routeInboundPage.fetchRouteByDriver(hubName, fetchByValue, routeId);
                break;
        }
    }

    private Long getRouteId(String value)
    {
        if (StringUtils.isBlank(value))
        {
            return get(KEY_CREATED_ROUTE_ID);
        }
        if (StringUtils.isNumeric(value))
        {
            return Long.valueOf(value);
        }
        Pattern p = Pattern.compile("(GET_FROM_CREATED_ROUTE)(\\[\\s*)(\\d+)(\\s*])");
        Matcher m = p.matcher(value);
        if (m.matches())
        {
            List<Long> routeIds = get(KEY_LIST_OF_CREATED_ROUTE_ID);
            return routeIds.get(Integer.parseInt(m.group(3)) - 1);
        } else if (StringUtils.equals(value, "GET_FROM_CREATED_ROUTE"))
        {
            return get(KEY_CREATED_ROUTE_ID);
        } else
        {
            return null;
        }
    }

    @When("^Operator verify error message displayed on Route Inbound:$")
    public void checkErrorMessage(Map<String, String> data)
    {
        String status = data.get("status");
        String url = data.get("url");
        String errorCode = data.get("errorCode");
        String errorMessage = data.get("errorMessage");

        routeInboundPage.verifyErrorMessage(status, url, errorCode, errorMessage);
    }

    @Then("^Operator verify the Route Summary Details is correct using data below:$")
    public void operatorVerifyTheRouteSummaryDetailsIsCorrectUsingDataBelow(Map<String, String> mapOfData)
    {
        mapOfData = resolveKeyValues(mapOfData);
        String routeIdAsString = mapOfData.get("routeId");
        String driverName = mapOfData.get("driverName");
        String hubName = mapOfData.get("hubName");
        String routeDateAsString = mapOfData.get("routeDate");

        Long routeId = getRouteId(routeIdAsString);

        Date routeDate;

        try
        {
            if ("GET_FROM_CREATED_ROUTE".equals(routeDateAsString))
            {
                Route route = get(KEY_CREATED_ROUTE);
                routeDate = ISO_8601_WITHOUT_MILLISECONDS.parse(route.getCreatedAt());
            } else
            {
                routeDate = ISO_8601_WITHOUT_MILLISECONDS.parse(routeDateAsString);
            }
        } catch (ParseException ex)
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

    @Then("^Operator verify the Route Inbound Details is correct using data below:$")
    public void operatorVerifyTheRouteInboundDetailsIsCorrectUsingDataBelow(Map<String, String> mapOfData)
    {
        mapOfData = resolveKeyValues(mapOfData);
        String routeIdAsString = mapOfData.get("routeId");
        String driverName = mapOfData.get("driverName");
        String hubName = mapOfData.get("hubName");
        String routeDateAsString = mapOfData.get("routeDate");

        Long routeId = getRouteId(routeIdAsString);

        Date routeDate = null;
        if (StringUtils.isNotBlank(routeDateAsString))
        {
            try
            {
                if ("GET_FROM_CREATED_ROUTE".equals(routeDateAsString))
                {
                    Route route = get(KEY_CREATED_ROUTE);
                    routeDate = ISO_8601_WITHOUT_MILLISECONDS.parse(route.getCreatedAt());
                } else
                {
                    routeDate = ISO_8601_WITHOUT_MILLISECONDS.parse(routeDateAsString);
                }
            } catch (ParseException ex)
            {
                throw new NvTestRuntimeException("Failed to parse route date.", ex);
            }
        }

        ExpectedScans expectedScans = new ExpectedScans();
        String value = mapOfData.get("pendingDeliveriesTotal");
        if (StringUtils.isNotBlank(value))
        {
            expectedScans.setPendingDeliveriesTotal(Integer.parseInt(value));
        }
        value = mapOfData.get("pendingDeliveriesScans");
        if (StringUtils.isNotBlank(value))
        {
            expectedScans.setPendingDeliveriesScans(Integer.parseInt(value));
        }
        value = mapOfData.get("parcelProcessedTotal");
        if (StringUtils.isNotBlank(value))
        {
            expectedScans.setParcelProcessedTotal(Integer.parseInt(value));
        }
        value = mapOfData.get("parcelProcessedScans");
        if (StringUtils.isNotBlank(value))
        {
            expectedScans.setParcelProcessedScans(Integer.parseInt(value));
        }
        value = mapOfData.get("failedDeliveriesValidTotal");
        if (StringUtils.isNotBlank(value))
        {
            expectedScans.setFailedDeliveriesValidTotal(Integer.parseInt(value));
        }
        value = mapOfData.get("failedDeliveriesValidScans");
        if (StringUtils.isNotBlank(value))
        {
            expectedScans.setFailedDeliveriesValidScans(Integer.parseInt(value));
        }
        value = mapOfData.get("failedDeliveriesInvalidTotal");
        if (StringUtils.isNotBlank(value))
        {
            expectedScans.setFailedDeliveriesInvalidTotal(Integer.parseInt(value));
        }
        value = mapOfData.get("failedDeliveriesInvalidScans");
        if (StringUtils.isNotBlank(value))
        {
            expectedScans.setFailedDeliveriesInvalidScans(Integer.parseInt(value));
        }
        value = mapOfData.get("c2cReturnPickupsTotal");
        if (StringUtils.isNotBlank(value))
        {
            expectedScans.setC2cReturnPickupsTotal(Integer.parseInt(value));
        }
        value = mapOfData.get("c2cReturnPickupsScans");
        if (StringUtils.isNotBlank(value))
        {
            expectedScans.setC2cReturnPickupsScans(Integer.parseInt(value));
        }
        value = mapOfData.get("reservationPickupsTotal");
        if (StringUtils.isNotBlank(value))
        {
            expectedScans.setReservationPickupsTotal(Integer.parseInt(value));
        }
        value = mapOfData.get("reservationPickupsScans");
        if (StringUtils.isNotBlank(value))
        {
            expectedScans.setReservationPickupsScans(Integer.parseInt(value));
        }
        routeInboundPage.verifyRouteInboundInfoIsCorrect(routeId, driverName, hubName, routeDate, expectedScans);
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

    @When("^Operator click 'View orders or reservations' button for shipper #(\\d+) in (.+) Waypoints dialog$")
    public void operatorClickViewOrdersOrReservationsButtonForShipperInPendingWaypointsDialog(int index, String status)
    {
        routeInboundPage.openViewOrdersOrReservationsDialog(index);
    }

    @SuppressWarnings("unchecked")
    @Then("^Operator verify Reservations table in (.+) Waypoints dialog using data below:$")
    public void operatorVerifyReservationsTableInPendingWaypointsDialogUsingDataBelow(String status, List<Map<String, String>> listOfData)
    {
        List<WaypointReservationInfo> expectedReservationsInfo = listOfData.stream().map(data ->
        {
            data = resolveKeyValues(data);
            WaypointReservationInfo reservationInfo = new WaypointReservationInfo();
            String value = data.get("reservationId");
            if (StringUtils.isNotBlank(value))
            {
                reservationInfo.setReservationId(value);
            }

            value = data.get("location");

            if (StringUtils.equalsIgnoreCase("GET_FROM_CREATED_ADDRESS", value))
            {
                reservationInfo.setLocation((Address) get(KEY_CREATED_ADDRESS));
            } else if (StringUtils.startsWithIgnoreCase(value, "GET_FROM_CREATED_ADDRESS_"))
            {
                int index = Integer.parseInt(value.replace("GET_FROM_CREATED_ADDRESS_", "").trim()) - 1;
                reservationInfo.setLocation(((List<Address>) get(KEY_LIST_OF_CREATED_ADDRESSES)).get(index));
            } else if (StringUtils.isNotBlank(value))
            {
                reservationInfo.setLocation(value);
            }

            value = data.get("readyToLatestTime");

            if (StringUtils.equalsIgnoreCase("GET_FROM_CREATED_RESERVATION", value))
            {
                Reservation reservation = get(KEY_CREATED_RESERVATION);
                value = reservation.getReadyDatetime() + " - " + reservation.getLatestDatetime();
            } else if (StringUtils.startsWithIgnoreCase(value, "GET_FROM_CREATED_RESERVATION_"))
            {
                int index = Integer.parseInt(value.replace("GET_FROM_CREATED_RESERVATION_", "").trim()) - 1;
                Reservation reservation = ((List<Reservation>) get(KEY_LIST_OF_CREATED_RESERVATIONS)).get(index);
                value = reservation.getReadyDatetime() + " - " + reservation.getLatestDatetime();
            }

            if (StringUtils.isNotBlank(value))
            {
                //reservationInfo.setReadyToLatestTime(value);
            }

            value = data.get("approxVolume");

            if (StringUtils.equalsIgnoreCase("GET_FROM_CREATED_RESERVATION", value))
            {
                Reservation reservation = get(KEY_CREATED_RESERVATION);
                value = reservation.getApproxVolume();
            } else if (StringUtils.startsWithIgnoreCase(value, "GET_FROM_CREATED_RESERVATION_"))
            {
                int index = Integer.parseInt(value.replace("GET_FROM_CREATED_RESERVATION_", "").trim()) - 1;
                Reservation reservation = ((List<Reservation>) get(KEY_LIST_OF_CREATED_RESERVATIONS)).get(index);
                value = reservation.getApproxVolume();
            }

            if (StringUtils.isNotBlank(value))
            {
                reservationInfo.setApproxVolume(value);
            }

            value = data.get("status");

            if (StringUtils.isNotBlank(value))
            {
                reservationInfo.setStatus(value);
            }

            value = data.get("receivedParcels");

            if (StringUtils.isNotBlank(value))
            {
                reservationInfo.setReceivedParcels(value);
            }

            return reservationInfo;
        }).collect(Collectors.toList());

        routeInboundPage.validateReservationsTable(expectedReservationsInfo);
    }

    @SuppressWarnings("unchecked")
    @Then("^Operator verify Orders table in (.+) Waypoints dialog using data below:$")
    public void operatorVerifyOrdersTableInPendingWaypointsDialogUsingDataBelow(String status, List<Map<String, String>> listOfData)
    {
        List<WaypointOrderInfo> expectedOrdersInfo = listOfData.stream().map(data ->
        {
            data = resolveKeyValues(data);
            WaypointOrderInfo orderInfo = new WaypointOrderInfo();
            String value = data.get("trackingId");
            if (StringUtils.isNotBlank(value))
            {
                orderInfo.setTrackingId(value);
            }

            value = data.get("location");
            if (StringUtils.equalsIgnoreCase("GET_FROM_CREATED_ORDER", value))
            {
                Order order = get(KEY_CREATED_ORDER);
                orderInfo.setLocation(order);
            } else if (StringUtils.startsWithIgnoreCase(value, "GET_FROM_CREATED_ORDER_"))
            {
                int index = Integer.parseInt(value.replace("GET_FROM_CREATED_ORDER_", "").trim()) - 1;
                orderInfo.setLocation(((List<Order>) get(KEY_LIST_OF_CREATED_ORDER)).get(index));
            } else if (StringUtils.startsWithIgnoreCase(value, "CREATED_ORDER_FROM_"))
            {
                int index = Integer.parseInt(value.replace("CREATED_ORDER_FROM_", "").trim()) - 1;
                Order order = ((List<Order>) get(KEY_LIST_OF_CREATED_ORDER)).get(index);
                String address = order.getFromAddress1() + " " + order.getFromAddress2() + " " + order.getFromPostcode() + " " + order.getFromCountry();
                orderInfo.setLocation(address.trim());
            } else if (StringUtils.equalsIgnoreCase("GET_FROM_CREATED_ADDRESS", value))
            {
                Address location = get(KEY_CREATED_ADDRESS);
                String address = location.getAddress1() + " " + location.getAddress2() + " " + location.getPostcode() + " " + location.getCountry();
                orderInfo.setLocation(address);
            } else if (StringUtils.startsWithIgnoreCase(value, "GET_FROM_CREATED_ADDRESS_"))
            {
                int index = Integer.parseInt(value.replace("GET_FROM_CREATED_ADDRESS_", "").trim()) - 1;
                Address location = ((List<Address>) get(KEY_LIST_OF_CREATED_ADDRESSES)).get(index);
                String address = location.getAddress1() + " " + location.getAddress2() + " " + location.getPostcode() + " " + location.getCountry();
                orderInfo.setLocation(address);
            } else if (StringUtils.isNotBlank(value))
            {
                orderInfo.setLocation(value);
            }

            value = data.get("type");

            if (StringUtils.isNotBlank(value))
            {
                orderInfo.setType(value);
            }

            value = data.get("status");

            if (StringUtils.isNotBlank(value))
            {
                orderInfo.setStatus(value);
            }

            value = data.get("cmiCount");

            if (StringUtils.isNotBlank(value))
            {
                orderInfo.setCmiCount(value);
            }

            value = data.get("routeInboundStatus");

            if (StringUtils.isNotBlank(value))
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

    @When("^Operator add route inbound comment \"(.+)\"  on Route Inbound page$")
    public void operatorAddRouteInboundCommentOnRouteInboundPage(String comment)
    {
        routeInboundPage.addRoutInboundComment(comment);
        put(KEY_ROUTE_INBOUND_COMMENT, comment);
    }

    @When("^Operator verify route inbound comment on Route Inbound page$")
    public void operatorVerifyRouteInboundCommentOnRouteInboundPage()
    {
        String expectedComment = get(KEY_ROUTE_INBOUND_COMMENT);
        routeInboundPage.verifyRouteInboundComment(expectedComment);
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

    @When("^Operator open Total Waypoints Info dialog on Route Inbound page$")
    public void operatorOpenTotalWaypointsInfoDialogOnRouteInboundPage()
    {
        routeInboundPage.openTotalWaypointsDialog();
    }

    @When("^Operator open Partial Waypoints Info dialog on Route Inbound page$")
    public void operatorOpenPartialWaypointsInfoDialogOnRouteInboundPage()
    {
        routeInboundPage.openPartialWaypointsDialog();
    }

    @When("^Operator open Pending Deliveries dialog on Route Inbound page$")
    public void operatorOpenPendingDeliveriesInfoDialogOnRouteInboundPage()
    {
        routeInboundPage.openPendingDeliveriesDialog();
    }

    @When("^Operator open Failed Deliveries Valid dialog on Route Inbound page$")
    public void operatorOpenFailedDeliveriesValidDialogOnRouteInboundPage()
    {
        routeInboundPage.openFailedDeliveriesValidDialog();
    }

    @When("^Operator open Failed Deliveries Invalid dialog on Route Inbound page$")
    public void operatorOpenFailedDeliveriesInvalidDialogOnRouteInboundPage()
    {
        routeInboundPage.openFailedDeliveriesInvalidDialog();
    }

    @When("^Operator open C2C / Return Pickups dialog on Route Inbound page$")
    public void operatorOpenC2CReturnPickupsDialogOnRouteInboundPage()
    {
        routeInboundPage.openC2CReturnPickupsDialog();
    }

    @When("^Operator open Reservation Pickups dialog on Route Inbound page$")
    public void operatorOpenReservationPickupsDialogOnRouteInboundPage()
    {
        routeInboundPage.openReservationPickupsDialog();
    }

    @When("^Operator close (.+) dialog on Route Inbound page$")
    public void operatorCloseDialogOnRouteInboundPage(String status)
    {
        routeInboundPage.closeDialog();
    }

    @When("^Operator open Money Collection dialog on Route Inbound page$")
    public void operatorOpenMoneyCollectionDialogOnRouteInboundPage()
    {
        routeInboundPage.openMoneyCollectionDialog();
    }

    @Then("^Operator verify 'Money to collect' value is \"(.+)\" on Route Inbound page$")
    public void operatorVerifyMoneyToCollectValueOnRouteInboundPage(String expectedValue)
    {
        String actualValue = routeInboundPage.getMoneyToCollectValue();
        Assertions.assertEquals(expectedValue, actualValue, "Money to collect value");
    }

    @Then("^Operator verify 'Expected Total' value is \"(.+)\" on Money Collection dialog$")
    public void operatorVerifyExpectedTotalValueOnMoneyCollectionDialog(String expectedValue)
    {
        String actualValue = routeInboundPage.moneyCollectionDialog().getExpectedTotal();
        Assertions.assertEquals(expectedValue, actualValue, "Expected Total value");
    }

    @Then("^Operator verify 'Outstanding amount' value is \"(.+)\" on Money Collection dialog$")
    public void operatorVerifyOutstandingAmountValueOnMoneyCollectionDialog(String expectedValue)
    {
        String actualValue = routeInboundPage.moneyCollectionDialog().getOutstandingAmount();
        Assertions.assertEquals(expectedValue, actualValue, "Outstanding Amount value");
    }

    @Then("^Operator submit following values on Money Collection dialog:$")
    public void operatorSubmitValuesOnMoneyCollectionDialog(Map<String, String> mapOfData)
    {
        MoneyCollection moneyCollection = new MoneyCollection(mapOfData);
        routeInboundPage.moneyCollectionDialog().fillForm(moneyCollection).save();
    }
}
