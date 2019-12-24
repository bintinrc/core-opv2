package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.Reservation;
import co.nvqa.operator_v2.selenium.page.ReservationsPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import io.cucumber.datatable.DataTable;
import org.junit.platform.commons.util.StringUtils;

import java.util.Date;
import java.util.Map;

/**
 *
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class ReservationsSteps extends AbstractSteps
{
    private ReservationsPage reservationsPage;

    public ReservationsSteps()
    {
    }

    @Override
    public void init()
    {
        reservationsPage = new ReservationsPage(getWebDriver());
    }

    @When("^Operator create new Reservation using data below:$")
    public void operatorCreateNewReservationUsingDataBelow(DataTable dataTable)
    {
        Address address = get(KEY_CREATED_ADDRESS);

        String createdDate = CREATED_DATE_SDF.format(new Date());
        String scenarioName = getScenarioManager().getCurrentScenario().getName();

        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String shipperName = mapOfData.get("shipperName");
        String timeslot = mapOfData.get("timeslot");
        String approxVolume = mapOfData.get("approxVolume");
        String priorityLevel = mapOfData.get("priorityLevel");
        String comments = f("Please ignore this Automation test reservation. Created at %s by scenario \"%s\".", createdDate, scenarioName);

        Reservation reservation = new Reservation();
        reservation.setAddressId(address.getId());
        reservation.setApproxVolume(approxVolume);
        reservation.setComments(comments);
        if (StringUtils.isNotBlank(priorityLevel)){
            reservation.setPriorityLevel(Integer.parseInt(priorityLevel));
        }

        reservationsPage.waitUntilReservationsLoaded();
        reservationsPage.createNewReservation(shipperName, address, reservation, timeslot);

        put("shipperName", shipperName);
        put("reservation", KEY_CREATED_RESERVATION);
        put(KEY_CREATED_RESERVATION, reservation);
    }

    @Then("^Operator verify the new Reservation is created successfully$")
    public void operatorVerifyTheNewReservationIsCreatedSuccessfully(DataTable dataTable)
    {
        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String expectedTimeslotTextOnCalendar = mapOfData.get("expectedTimeslotTextOnCalendar");
        reservationsPage.verifyReservationIsCreatedSuccessfully(expectedTimeslotTextOnCalendar);
    }

    @When("^Operator update the new Reservation using data below:$")
    public void operatorUpdateTheNewReservation(DataTable dataTable)
    {
        Address address = get(KEY_CREATED_ADDRESS);
        String shipperName = get("shipperName");
        Reservation reservation = get(KEY_CREATED_RESERVATION);

        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String newTimeslot = mapOfData.get("timeslot");

        reservationsPage.editReservation(shipperName, address, reservation, newTimeslot);
    }

    @Then("^Operator verify the new Reservation is updated successfully$")
    public void operatorVerifyTheNewReservationIsUpdatedSuccessfully(DataTable dataTable)
    {
        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String expectedTimeslotTextOnCalendar = mapOfData.get("expectedTimeslotTextOnCalendar");
        reservationsPage.verifyReservationIsUpdatedSuccessfully(expectedTimeslotTextOnCalendar);
    }

    @When("^Operator delete the new Reservation$")
    public void operatorDeleteTheNewReservation()
    {
        Address address = get(KEY_CREATED_ADDRESS);
        String shipperName = get("shipperName");
        Reservation reservation = get(KEY_CREATED_RESERVATION);

        reservationsPage.deleteReservation(shipperName, address, reservation);
    }

    @Then("^Operator verify the new Reservation is deleted successfully$")
    public void operatorVerifyTheNewReservationIsDeletedSuccessfully()
    {
        reservationsPage.verifyReservationIsDeletedSuccessfully();
    }
}