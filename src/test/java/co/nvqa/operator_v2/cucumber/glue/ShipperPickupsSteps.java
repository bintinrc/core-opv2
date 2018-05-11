package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.Reservation;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.ReservationInfo;
import co.nvqa.operator_v2.selenium.page.ShipperPickupsPage;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.inject.Inject;
import cucumber.api.DataTable;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.awt.*;
import java.awt.event.InputEvent;
import java.time.ZoneId;
import java.util.*;
import java.util.List;

/**
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
        verifyReservationData(addressResult, dataTable);
    }

    @Then("^Operator verify the new reservations are listed on table in Shipper Pickups page using data below:$")
    public void operatorVerifyTheNewReservationsAreListedOnTableInShipperPickupsPageUsingDataBelow(DataTable dataTable)
    {
        List<Address> addresses = get(KEY_LIST_OF_CREATED_ADDRESSES);
        addresses.forEach(address -> verifyReservationData(address, dataTable));
    }

    private void verifyReservationData(Address address, DataTable dataTable){
        Map<String, String> mapOfData = dataTable.asMap(String.class, String.class);
        String shipperName = mapOfData.get("shipperName");
        String routeId = mapOfData.get("routeId");
        String driverName = mapOfData.get("driverName");
        String priorityLevel = mapOfData.get("priorityLevel");
        String approxVolume = mapOfData.get("approxVolume");
        String comments = mapOfData.get("comments");

        if ("GET_FROM_CREATED_SHIPPER".equalsIgnoreCase(shipperName))
        {
            shipperName = this.<Shipper>get(KEY_CREATED_SHIPPER).getName();
        }

        routeId = resolveExpectedRouteId(routeId);
        driverName = resolveExpectedDriverName(driverName);

        if ("GET_FROM_CREATED_RESERVATION".equals(comments))
        {
            Reservation reservationResult = get(KEY_CREATED_RESERVATION);
            comments = reservationResult.getComments();
        }

        shipperPickupsPage.verifyReservationInfo(address, shipperName, routeId, driverName, priorityLevel, approxVolume, comments);
    }

    private String resolveExpectedRouteId(String routeIdParam){
        switch (routeIdParam.toUpperCase()){
            case "GET_FROM_CREATED_ROUTE":
                return String.valueOf((Long) get(KEY_CREATED_ROUTE_ID));
            case "GET_FROM_SUGGESTED_ROUTE":
                return String.valueOf(((Route)get(KEY_SUGGESTED_ROUTE)).getId());
            default:
                return routeIdParam;
        }
    }

    private String resolveExpectedDriverName(String driverNameParam){
        Route route;
        switch (driverNameParam.toUpperCase()){
            case "GET_FROM_CREATED_ROUTE":
                route = get(KEY_CREATED_ROUTE);
                return route.getDriver().getFirstName() + " " + route.getDriver().getLastName();
            case "GET_FROM_SUGGESTED_ROUTE":
                route = get(KEY_SUGGESTED_ROUTE);
                return route.getDriver().getFirstName() + " " + route.getDriver().getLastName();
            default:
                return driverNameParam;
        }
    }

    @Then("^Operator verify the reservations details is correct on Shipper Pickups page using data below:$")
    public void operatorVerifyTheReservationsDetailsIsCorrectOnShipperPickupsPageUsingDataBelow(DataTable dataTable)
    {
        Address addressResult = get(KEY_CREATED_ADDRESS);

        Map<String, String> mapOfData = dataTable.asMap(String.class, String.class);
        String shipperName = mapOfData.get("shipperName");
        String shipperId = mapOfData.get("shipperId");
        String reservationId = mapOfData.get("reservationId");

        if ("GET_FROM_CREATED_RESERVATION".equals(reservationId))
        {
            Reservation reservationResult = get(KEY_CREATED_RESERVATION);
            reservationId = String.valueOf(reservationResult.getId());
        }

        shipperPickupsPage.verifyReservationDetails(addressResult, shipperName, shipperId, reservationId);
    }

    @When("^Operator duplicates created reservation$")
    public void operatorDuplicatesCreatedReservation()
    {
        Address address = get(KEY_CREATED_ADDRESS);
        Reservation reservation = get(KEY_CREATED_RESERVATION);
        ReservationInfo duplicatedReservationInfo =
                duplicateReservations(Collections.singletonList(address), reservation).get(0);
        put(KEY_DUPLICATED_RESERVATION_INFO, duplicatedReservationInfo);
    }

    @When("^Operator duplicates created reservations$")
    public void operatorDuplicatesCreatedReservations()
    {
        List<Address> addresses = get(KEY_LIST_OF_CREATED_ADDRESSES);
        List<Reservation> reservations = get(KEY_LIST_OF_CREATED_RESERVATIONS);
        List<ReservationInfo> duplicatedReservationsInfo =
                duplicateReservations(addresses, reservations.get(0));
        put(KEY_LIST_OF_DUPLICATED_RESERVATIONS_INFO, duplicatedReservationsInfo);
    }

    private List<ReservationInfo> duplicateReservations(List<Address> addresses, Reservation reservation)
    {
        int daysShift = 1;
        String newReadyBy = DateUtil.displayDateTime(
                DateUtil.getDate(reservation.getReadyDatetime()).withZoneSameInstant(ZoneId.systemDefault()).plusDays(daysShift));
        String newLatestBy = DateUtil.displayDateTime(
                DateUtil.getDate(reservation.getLatestDatetime()).withZoneSameInstant(ZoneId.systemDefault()).plusDays(daysShift));
        Date newDate = Date.from(DateUtil.getDate(reservation.getReadyDatetime()).plusDays(daysShift).toInstant());
        List<ReservationInfo> duplicatedReservationsInfo =
                shipperPickupsPage.duplicateReservations(addresses, newDate);
        duplicatedReservationsInfo.forEach(reservationInfo -> {
            reservationInfo.setReadyBy(newReadyBy);
            reservationInfo.setLatestBy(newLatestBy);
        });
        return duplicatedReservationsInfo;
    }

    @Then("^Operator verify the duplicated reservation is created successfully$")
    public void operatorVerifyTheDuplicatedReservationIsCreatedSuccessfully()
    {
        shipperPickupsPage.verifyReservationInfo(get(KEY_DUPLICATED_RESERVATION_INFO), get(KEY_CREATED_ADDRESS));
    }

    @Then("^Operator verify the duplicated reservations are created successfully$")
    public void operatorVerifyTheDuplicatedReservationsAreCreatedSuccessfully()
    {
        shipperPickupsPage.verifyReservationsInfo(get(KEY_LIST_OF_DUPLICATED_RESERVATIONS_INFO), get(KEY_LIST_OF_CREATED_ADDRESSES));
    }

    @And("^Operator use the Route Suggestion to add created reservation to the route$")
    public void operatorUseTheRouteSuggestionToAddCreatedReservationToTheRoute()
    {
        Address address = get(KEY_CREATED_ADDRESS);
        addRouteViaRouteSuggestion(Collections.singletonList(address), Collections.singletonList("ZZZ"));
    }

    @And("^Operator use the Route Suggestion to add created reservations to the route$")
    public void operatorUseTheRouteSuggestionToAddCreatedReservationsToTheRoute()
    {
        List<Address> addresses = get(KEY_LIST_OF_CREATED_ADDRESSES);
        addRouteViaRouteSuggestion(addresses, Collections.singletonList("ZZZ"));
    }

    private void addRouteViaRouteSuggestion(List<Address> addresses, List<String> routeTags){
        List<Route> zzzRoutes = get(KEY_LIST_OF_FOUND_ROUTES);
        Route suggestedRoute = shipperPickupsPage
                .suggestRoute(addresses, routeTags)
                .validateSuggestedRoutes(zzzRoutes);
        put(KEY_SUGGESTED_ROUTE, suggestedRoute);
        shipperPickupsPage.bulkRouteAssignmentDialog.submitForm();
        shipperPickupsPage.refreshRoutes();
    }

    @And("^Operator removes the route from the created reservation$")
    public void operatorRemovesTheRouteFromTheCreatedReservation()
    {
        Address address = get(KEY_CREATED_ADDRESS);
        shipperPickupsPage.removeRoute(address);
    }

    @And("^Operator removes the route from the created reservations$")
    public void operatorRemovesTheRouteFromTheCreatedReservations()
    {
        List<Address> addresses = get(KEY_LIST_OF_CREATED_ADDRESSES);
        shipperPickupsPage.removeRoutes(addresses);
    }

    @Then("^Operator verify the route was removed from the created reservation$")
    public void operatorVerifyTheRouteWasRemovedFromTheCreatedReservation()
    {
        Address address = get(KEY_CREATED_ADDRESS);
        ReservationInfo reservationInfo = new ReservationInfo();
        reservationInfo.setRouteId("-");
        reservationInfo.setDriverName("No Driver");
        shipperPickupsPage.verifyReservationInfo(reservationInfo, address);
    }

    @Then("^Operator verify the route was removed from the created reservations$")
    public void operatorVerifyTheRouteWasRemovedFromTheCreatedReservations()
    {
        List<Address> addresses = get(KEY_LIST_OF_CREATED_ADDRESSES);
        ReservationInfo reservationInfo = new ReservationInfo();
        reservationInfo.setRouteId("-");
        reservationInfo.setDriverName("No Driver");
        addresses.forEach(address -> shipperPickupsPage.verifyReservationInfo(reservationInfo, address));
    }

    public static void main(String[] args) throws AWTException
    {
        Robot r = new Robot();
        Date start = new Date();
        while (new Date().getTime() - start.getTime() < 300000){
            simulateMouse(r);
            typeRandom(r, 60);
            r.delay(30000);
        }
    }

    public static void moveMouse(Robot robot, int x, int y){
        System.out.println("move mouse to " + x + "," + y);
        robot.mouseMove(x, y);
        robot.delay(1000);
    }

    public static void simulateMouse(Robot robot){
        simulateMouse(robot, random.nextInt(10) + 10);
    }

    public static void simulateMouse(Robot robot, int count){
        for (int i=0; i<count; i++){
            moveMouseRandom(robot);
            if (random.nextBoolean()){
                mouseClick(robot);
            }
            if (random.nextBoolean()){
                mouseWheel(robot, random.nextInt(40) - 20);
            }
            robot.delay(random.nextInt(5000) + 5000);
        }
    }

    public static void mouseClick(Robot robot){
        System.out.println("Mouse click");
        robot.mousePress(InputEvent.BUTTON1_MASK);
        robot.mouseRelease(InputEvent.BUTTON1_MASK);
    }

    public static void mouseWheel(Robot robot, int wheelAmount){
        System.out.println("Mouse wheel " + wheelAmount);
        robot.mouseWheel(wheelAmount);
    }

    public static void moveMouseRandom(Robot robot){
        Random random = new Random();
        int x = random.nextInt(400)+500;
        int y = random.nextInt(300)+200;
        moveMouse(robot, x, y);
    }

    public static void typeRandom(Robot robot, int length){
        Random random = new Random();
        for (int i=0; i<length; i++){
            robot.delay(500);
            int keyCode = random.nextInt(200);
            try
            {
                robot.keyPress(keyCode);
                robot.keyRelease(keyCode);
            } catch (Exception ex){
                System.out.println((char)keyCode + " " + keyCode + " invalid");
                i--;
                continue;
            }
            System.out.println((char)keyCode + " " + keyCode);
        }
    }

    private static Random random = new Random();

    @Then("^Operator verify the reservation data is correct on Shipper Pickups page$")
    public void operatorVerifyTheReservationDataIsCorrectOnShipperPickupsPage() throws Throwable
    {
        ReservationInfo reservationInfo = get(KEY_CREATED_RESERVATION_INFO);
        Address address = get(KEY_CREATED_ADDRESS);
        shipperPickupsPage.verifyReservationInfo(reservationInfo, address);
    }
}
