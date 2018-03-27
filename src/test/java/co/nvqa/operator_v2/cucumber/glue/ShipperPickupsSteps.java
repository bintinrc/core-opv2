package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.Reservation;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.ShipperPickupsPage;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.inject.Inject;
import cucumber.api.DataTable;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Date;
import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ShipperPickupsSteps extends AbstractSteps
{
    private ShipperPickupsPage shipperPickupsPage;

    @Inject
    public ShipperPickupsSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        shipperPickupsPage = new ShipperPickupsPage(getWebDriver());
    }

    @When("^Operator set filter Reservation Date to current date and click Load Selection on Shipper Pickups page$")
    public void operatorSetFilterReservationDateToCurrentDateAndClickLoadSelectionOnShipperPickupsPage()
    {
        Date currentDate = new Date();
        Date nextDayDate = TestUtils.getNextDate(1);
        shipperPickupsPage.filterReservationDate(currentDate, nextDayDate);
        shipperPickupsPage.clickButtonLoadSelection();
    }

    @When("^Operator refresh routes on Shipper Pickups page$")
    public void operatorRefreshRoutesOnShipperPickupPage()
    {
        shipperPickupsPage.clickButtonRefresh();
    }

    @When("^Operator assign Reservation to Route on Shipper Pickups page$")
    public void operatorAssignReservationToRouteOnShipperPickupsPage()
    {
        Address addressResult = get(KEY_CREATED_ADDRESS);
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        shipperPickupsPage.assignReservationToRoute(addressResult, routeId);
    }

    @When("^Operator assign Reservation to Route with priority level = \"([^\"]*)\" on Shipper Pickups page$")
    public void operatorAssignReservationToRouteWithPriorityOnShipperPickupsPage(String priorityLevelAsString)
    {
        Address addressResult = get(KEY_CREATED_ADDRESS);
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        Integer priorityLevel = Integer.parseInt(priorityLevelAsString);
        shipperPickupsPage.assignReservationToRoute(addressResult, routeId, priorityLevel);
    }

    @Then("^Operator verify the new reservation is listed on table in Shipper Pickups page using data below:$")
    public void operatorVerifyTheNewReservationIsListedOnTableInShipperPickupsPageUsingDataBelow(DataTable dataTable)
    {
        Address addressResult = get(KEY_CREATED_ADDRESS);

        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String shipperName = mapOfData.get("shipperName");
        String routeId = mapOfData.get("routeId");
        String driverName = mapOfData.get("driverName");
        String priorityLevel = mapOfData.get("priorityLevel");
        String approxVolume = mapOfData.get("approxVolume");
        String comments = mapOfData.get("comments");

        if("GET_FROM_CREATED_SHIPPER".equalsIgnoreCase(shipperName))
        {
            shipperName = this.<Shipper>get(KEY_CREATED_SHIPPER).getName();
        }

        if("GET_FROM_CREATED_ROUTE".equals(routeId))
        {
            routeId = String.valueOf((Long)get(KEY_CREATED_ROUTE_ID));
        }

        if("GET_FROM_CREATED_RESERVATION".equals(comments))
        {
            Reservation reservationResult = get(KEY_CREATED_RESERVATION);
            comments = reservationResult.getComments();
        }

        shipperPickupsPage.verifyReservationInfo(addressResult, shipperName, routeId, driverName, priorityLevel, approxVolume, comments);
    }

    @Then("^Operator verify the reservations details is correct on Shipper Pickups page using data below:$")
    public void operatorVerifyTheReservationsDetailsIsCorrectOnShipperPickupsPageUsingDataBelow(DataTable dataTable)
    {
        Address addressResult = get(KEY_CREATED_ADDRESS);

        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String shipperName = mapOfData.get("shipperName");
        String shipperId = mapOfData.get("shipperId");
        String reservationId = mapOfData.get("reservationId");

        if("GET_FROM_CREATED_RESERVATION".equals(reservationId))
        {
            Reservation reservationResult = get(KEY_CREATED_RESERVATION);
            reservationId = String.valueOf(reservationResult.getId());
        }

        shipperPickupsPage.verifyReservationDetails(addressResult, shipperName, shipperId, reservationId);
    }
}
