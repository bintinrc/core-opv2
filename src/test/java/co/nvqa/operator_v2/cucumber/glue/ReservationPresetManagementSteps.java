package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.ReservationGroup;
import co.nvqa.operator_v2.selenium.page.ReservationPresetManagementPage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Map;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class ReservationPresetManagementSteps extends AbstractSteps
{
    private ReservationPresetManagementPage reservationPresetManagementPage;
    public static final String KEY_CREATED_RESERVATION_GROUP = "KEY_CREATED_RESERVATION_GROUP";

    @Inject
    public ReservationPresetManagementSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        reservationPresetManagementPage = new ReservationPresetManagementPage(getWebDriver());
    }

    @When("^Operator create new Reservation Group on Reservation Preset Management page using data below:$")
    public void operatorCreateNewReservationGroupOnReservationPresetManagementPageUsingDataBelow(Map<String, String> mapOfData)
    {
        ReservationGroup reservationGroup = new ReservationGroup();
        reservationGroup.fromMap(mapOfData);
        reservationPresetManagementPage.addNewGroup(reservationGroup);
        put(KEY_CREATED_RESERVATION_GROUP, reservationGroup);
    }

    @Then("^Operator verify created Reservation Group properties on Reservation Preset Management page$")
    public void operatorVerifyANewReservationGroupIsCreatedSuccessfullyOnPageReservationPresetManagement()
    {
        ReservationGroup reservationGroup = get(KEY_CREATED_RESERVATION_GROUP);
        reservationPresetManagementPage.verifyGroupProperties(reservationGroup.getName(), reservationGroup);
    }

    @When("^Operator edit created Reservation Group on Reservation Preset Management page using data below:$")
    public void operatorEditCreatedReservationGroupOnHubsGroupManagementPageUsingDataBelow(Map<String, String> mapOfData)
    {
        ReservationGroup reservationGroup = get(KEY_CREATED_RESERVATION_GROUP);
        String reservationGroupName = reservationGroup.getName();
        reservationGroup.fromMap(mapOfData);
        reservationPresetManagementPage.editGroup(reservationGroupName, reservationGroup);
    }

    @When("^Operator delete created Reservation Group on Reservation Preset Management page$")
    public void operatorDeleteCreatedReservationGroupOnReservationPresetManagementPage()
    {
        ReservationGroup reservationGroup = get(KEY_CREATED_RESERVATION_GROUP);
        reservationPresetManagementPage.deleteGroup(reservationGroup.getName());
    }

    @Then("^Operator verify created Reservation Group was deleted successfully on Reservation Preset Management page$")
    public void operatorVerifyCreatedReservationGroupWasDeletedSuccessfullyOnReservationPresetManagementPage()
    {
        ReservationGroup reservationGroup = get(KEY_CREATED_RESERVATION_GROUP);
        reservationPresetManagementPage.verifyGroupDeleted(reservationGroup.getName());
        remove(KEY_CREATED_RESERVATION_GROUP);
        remove(KEY_CREATED_RESERVATION_GROUP_ID);
    }
}
