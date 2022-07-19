package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.ReservationGroup;
import co.nvqa.operator_v2.selenium.page.ReservationPresetManagementPage;
import co.nvqa.operator_v2.selenium.page.ReservationPresetManagementPage.PendingTaskBlock;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.Map;

import static co.nvqa.operator_v2.selenium.page.HubsGroupManagementPage.HubsGroupTable.COLUMN_NAME;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class ReservationPresetManagementSteps extends AbstractSteps {

  private ReservationPresetManagementPage reservationPresetManagementPage;

  public ReservationPresetManagementSteps() {
  }

  @Override
  public void init() {
    reservationPresetManagementPage = new ReservationPresetManagementPage(getWebDriver());
  }

  @When("^Operator create new Reservation Group on Reservation Preset Management page using data below:$")
  public void operatorCreateNewReservationGroupOnReservationPresetManagementPageUsingDataBelow(
      Map<String, String> mapOfData) {
    ReservationGroup reservationGroup = new ReservationGroup();
    reservationGroup.fromMap(resolveKeyValues(mapOfData));
    reservationPresetManagementPage.addNewGroup(reservationGroup);
    put(KEY_CREATED_RESERVATION_GROUP, reservationGroup);
  }

  @Then("^Operator verify created Reservation Group properties on Reservation Preset Management page$")
  public void operatorVerifyANewReservationGroupIsCreatedSuccessfullyOnPageReservationPresetManagement() {
    ReservationGroup reservationGroup = get(KEY_CREATED_RESERVATION_GROUP);
    reservationPresetManagementPage
        .verifyGroupProperties(reservationGroup.getName(), reservationGroup);
  }

  @When("^Operator edit created Reservation Group on Reservation Preset Management page using data below:$")
  public void operatorEditCreatedReservationGroupOnHubsGroupManagementPageUsingDataBelow(
      Map<String, String> mapOfData) {
    ReservationGroup reservationGroup = get(KEY_CREATED_RESERVATION_GROUP);
    String reservationGroupName = reservationGroup.getName();
    reservationGroup.fromMap(mapOfData);
    reservationPresetManagementPage.editGroup(reservationGroupName, reservationGroup);
  }

  @When("^Operator delete created Reservation Group on Reservation Preset Management page$")
  public void operatorDeleteCreatedReservationGroupOnReservationPresetManagementPage() {
    ReservationGroup reservationGroup = get(KEY_CREATED_RESERVATION_GROUP);
    reservationPresetManagementPage.deleteGroup(reservationGroup.getName());
  }

  @Then("^Operator verify created Reservation Group was deleted successfully on Reservation Preset Management page$")
  public void operatorVerifyCreatedReservationGroupWasDeletedSuccessfullyOnReservationPresetManagementPage() {
    ReservationGroup reservationGroup = get(KEY_CREATED_RESERVATION_GROUP);
    reservationPresetManagementPage.verifyGroupDeleted(reservationGroup.getName());
    remove(KEY_CREATED_RESERVATION_GROUP);
    remove(KEY_CREATED_RESERVATION_GROUP_ID);
  }

  @Then("^Operator assign pending task on Reservation Preset Management page:$")
  public void assignPendingTask(Map<String, String> data) {
    data = resolveKeyValues(data);
    String shipper = data.get("shipper");
    String group = data.get("group");
    reservationPresetManagementPage.pendingTab.click();
    pause2s();
    PendingTaskBlock pendingTaskBlock = reservationPresetManagementPage.pendingTasks.stream()
        .filter(t -> t.shipper.getText().replace("Assign:", "").trim().equalsIgnoreCase(shipper))
        .findFirst()
        .orElseThrow(() -> new AssertionError("Task for shipper " + shipper + " was not found"));
    pendingTaskBlock.assign.click();
    reservationPresetManagementPage.assignShipperDialog.waitUntilVisible();
    reservationPresetManagementPage.assignShipperDialog.group.selectValue(group);
    reservationPresetManagementPage.assignShipperDialog.assignShipper.clickAndWaitUntilDone();
  }

  @Then("^Operator unassign pending task on Reservation Preset Management page:$")
  public void unassignPendingTask(Map<String, String> data) {
    data = resolveKeyValues(data);
    String shipper = data.get("shipper");
    reservationPresetManagementPage.pendingTab.click();
    pause2s();
    PendingTaskBlock pendingTaskBlock = reservationPresetManagementPage.pendingTasks.stream()
        .filter(t -> t.shipper.getText().startsWith("Unassign: " + shipper))
        .findFirst()
        .orElseThrow(() -> new AssertionError("Task for shipper " + shipper + " was not found"));
    pendingTaskBlock.unassign.click();
    reservationPresetManagementPage.unassignShipperDialog.waitUntilVisible();
    reservationPresetManagementPage.unassignShipperDialog.unassignShipper.clickAndWaitUntilDone();
  }

  @Then("^Operator route pending reservations on Reservation Preset Management page:$")
  public void routePendingReservations(Map<String, String> data) {
    data = resolveKeyValues(data);
    String group = data.get("group");
    reservationPresetManagementPage.overviewTab.click();
    pause2s();
    reservationPresetManagementPage.reservationPresetTable.filterByColumn(COLUMN_NAME, group);
    reservationPresetManagementPage.reservationPresetTable.selectRow(1);
    reservationPresetManagementPage.actionsMenu.selectOption("Route Pending Reservations");
  }

  @Then("^Operator create route on Reservation Preset Management page:$")
  public void createRoute(Map<String, String> data) {
    data = resolveKeyValues(data);
    String group = data.get("group");
    String routeDate = data.get("routeDate");
    reservationPresetManagementPage.overviewTab.click();
    pause2s();
    reservationPresetManagementPage.reservationPresetTable.filterByColumn(COLUMN_NAME, group);
    reservationPresetManagementPage.routeDate.simpleSetValue(routeDate);
    reservationPresetManagementPage.waitWhilePageIsLoading(2);
    reservationPresetManagementPage.reservationPresetTable.selectRow(1);
    reservationPresetManagementPage.actionsMenu.selectOption("Create Route");
    reservationPresetManagementPage.createRouteDialog.waitUntilVisible();
    reservationPresetManagementPage.createRouteDialog.confirm.clickAndWaitUntilDone();
  }
}
