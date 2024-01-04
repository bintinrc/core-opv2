package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.client.ReservationClient;
import co.nvqa.common.core.client.RouteClient;
import co.nvqa.common.core.model.pickup.MilkRunGroup;
import co.nvqa.common.core.model.pickup.MilkrunPendingTask;
import co.nvqa.common.core.model.reservation.ReservationFilter;
import co.nvqa.common.core.model.reservation.ReservationResponse;
import co.nvqa.common.core.utils.CoreScenarioStorageKeys;
import co.nvqa.common.driver.client.DriverManagementClient;
import co.nvqa.common.model.address.Address;
import co.nvqa.common.shipper.client.ShipperClient;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.operator_v2.cucumber.ScenarioStorageKeys;
import co.nvqa.operator_v2.exception.element.NvTestCoreElementNotFoundError;
import co.nvqa.operator_v2.model.ReservationGroup;
import co.nvqa.operator_v2.selenium.page.ReservationPresetManagementPage;
import co.nvqa.operator_v2.selenium.page.ReservationPresetManagementPage.PendingTaskBlock;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.After;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import lombok.Getter;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.inject.Inject;

import static co.nvqa.operator_v2.selenium.page.ReservationPresetManagementPage.ReservationPresetTable.COLUMN_NAME;
import static co.nvqa.operator_v2.util.TestConstants.RPM_SHIPPER_ID;
import static co.nvqa.operator_v2.util.TestConstants.RPM_SHIPPER_ID_LEGACY;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class ReservationPresetManagementSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(
      ReservationPresetManagementSteps.class);

  @Inject
  @Getter
  private DriverManagementClient driverManagementClient;

  @Inject
  @Getter
  private ShipperClient shipperClient;

  @Inject
  @Getter
  private RouteClient routeClient;

  @Inject
  @Getter
  private ReservationClient reservationClient;

  private ReservationPresetManagementPage reservationPresetManagementPage;

  public ReservationPresetManagementSteps() {
  }

  @Override
  public void init() {
    reservationPresetManagementPage = new ReservationPresetManagementPage(getWebDriver());
  }

  @When("Operator create new Reservation Group on Reservation Preset Management page using data below:")
  public void operatorCreateNewReservationGroupOnReservationPresetManagementPageUsingDataBelow(
      Map<String, String> mapOfData) {
    ReservationGroup reservationGroup = new ReservationGroup();
    reservationGroup.fromMap(resolveKeyValues(mapOfData));
    reservationPresetManagementPage.addNewGroup(reservationGroup);
    putInList(ScenarioStorageKeys.KEY_CREATED_RESERVATION_GROUP, reservationGroup);
  }

  @Then("Operator verify created Reservation Group properties on Reservation Preset Management page:")
  public void operatorVerifyANewReservationGroupIsCreatedSuccessfullyOnPageReservationPresetManagement(
      Map<String, String> mapOfData) {
    ReservationGroup reservationGroup = new ReservationGroup();
    reservationGroup.fromMap(resolveKeyValues(mapOfData));
    reservationPresetManagementPage
        .verifyGroupProperties(reservationGroup.getName(), reservationGroup);
  }

  @When("Operator edit {string} Reservation Group on Reservation Preset Management page with data below:")
  public void operatorEditCreatedReservationGroupOnHubsGroupManagementPageUsingDataBelow(
      String reservationGroupName, Map<String, String> mapOfData) {
    String resolvedReservationGroupName = resolveValue(reservationGroupName);
    ReservationGroup editReservationGroup = new ReservationGroup();
    editReservationGroup.fromMap(resolveKeyValues(mapOfData));

    editReservationGroup.setName(editReservationGroup.getName() + "-Edited");

    putInList(ScenarioStorageKeys.KEY_EDITED_RESERVATION_GROUP_NAME,
        editReservationGroup.getName());

    reservationPresetManagementPage.editGroup(resolvedReservationGroupName, editReservationGroup);
  }

  @When("Operator delete created Reservation Group on Reservation Preset Management page:")
  public void operatorDeleteCreatedReservationGroupOnReservationPresetManagementPage(
      Map<String, String> mapOfData) {
    ReservationGroup reservationGroup = new ReservationGroup();
    reservationGroup.fromMap(resolveKeyValues(mapOfData));
    reservationPresetManagementPage.deleteGroup(reservationGroup.getName());
  }

  @Then("Operator verify created Reservation Group was deleted successfully on Reservation Preset Management page:")
  public void operatorVerifyCreatedReservationGroupWasDeletedSuccessfullyOnReservationPresetManagementPage(
      Map<String, String> mapOfData) {
    ReservationGroup reservationGroup = new ReservationGroup();
    reservationGroup.fromMap(resolveKeyValues(mapOfData));
    reservationPresetManagementPage.verifyGroupDeleted(reservationGroup.getName());
    remove(ScenarioStorageKeys.KEY_CREATED_RESERVATION_GROUP);
    remove(ScenarioStorageKeys.KEY_CREATED_RESERVATION_GROUP_ID);
  }

  @Then("Operator assign pending task on Reservation Preset Management page:")
  public void assignPendingTask(Map<String, String> data) {
    data = resolveKeyValues(data);
    String shipper = data.get("shipper");
    String group = data.get("group");
    doWithRetry(() -> {
      try {
        reservationPresetManagementPage.pendingTab.click();
        PendingTaskBlock pendingTaskBlock = reservationPresetManagementPage.pendingTasks.stream()
            .filter(
                t -> t.shipper.getText().replace("Assign:", "").trim().equalsIgnoreCase(shipper))
            .findFirst()
            .orElseThrow(
                () -> new AssertionError("Task for shipper " + shipper + " was not found"));
        pendingTaskBlock.assign.click();
        reservationPresetManagementPage.assignShipperDialog.waitUntilVisible();
        reservationPresetManagementPage.assignShipperDialog.group.selectValue(group);
        reservationPresetManagementPage.assignShipperDialog.assignShipper.clickAndWaitUntilDone();
      } catch (Throwable t) {
        reservationPresetManagementPage.refreshPage();
        throw new NvTestCoreElementNotFoundError("Task for shipper " + shipper + " was not found");
      }
    }, "Operator assign pending task on Reservation Preset Management page");
  }

  @Then("Operator uploads CSV on Reservation Preset Management page:")
  public void assignPendingTask(List<Map<String, String>> data) {
    data = resolveListOfMaps(data);
    List<String> rows = new ArrayList<>();
    rows.add("shipper_id,address_id,action,milkrun_group_id,days,start_time,end_time");
    data.forEach(map -> {
      rows.add(map.getOrDefault("shipperId", "") + ","
          + map.getOrDefault("addressId", "") + ","
          + map.getOrDefault("action", "") + ","
          + map.getOrDefault("milkrunGroupId", "") + ","
          + map.getOrDefault("days", "") + ","
          + map.getOrDefault("startTime", "") + ","
          + map.getOrDefault("endTime", ""));
    });
    String content = StringUtils.join(rows, "\n");
    File file = StandardTestUtils.createFile("bulk-milkrun-action.csv", content);
    reservationPresetManagementPage.overviewTab.click();
    reservationPresetManagementPage.moreActions.selectOption("Upload CSV");
    reservationPresetManagementPage.uploadCsvDialog.waitUntilVisible();
    reservationPresetManagementPage.uploadCsvDialog.selectFile.setValue(file);
    reservationPresetManagementPage.uploadCsvDialog.submit.clickAndWaitUntilDone();
  }

  @Then("Operator downloads sample CSV on Reservation Preset Management page")
  public void downloadCsv() {
    reservationPresetManagementPage.overviewTab.click();
    reservationPresetManagementPage.moreActions.selectOption("Download Sample CSV");
  }

  @Then("sample CSV file on Reservation Preset Management page is downloaded successfully")
  public void operatorVerifySampleCsvFileIsDownloadedSuccessfully() {
    reservationPresetManagementPage.verifyFileDownloadedSuccessfully("bulk-milkrun-action.csv",
        "shipper_id,address_id,action,milkrun_group_id,days,start_time,end_time\n"
            + "101,901,add,12363,1,9:00,12:00\n"
            + "102,902,add,23241,\"1, 2\",12:00,15:00\n"
            + "103,903,add,32412,\"1, 2, 3\",15:00,19:00\n"
            + "108,908,delete,32132,,,\n"
            + "109,909,delete,32133,,,\n");
  }

  @Then("Operator unassign pending task on Reservation Preset Management page:")
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

  @Then("Operator route pending reservations on Reservation Preset Management page:")
  public void routePendingReservations(Map<String, String> data) {
    data = resolveKeyValues(data);
    String group = data.get("group");
    String routeDate = data.get("routeDate");
    reservationPresetManagementPage.overviewTab.click();
    pause2s();
    reservationPresetManagementPage.reservationPresetTable.filterByColumn(COLUMN_NAME, group);
    if (StringUtils.isNotBlank(routeDate)) {
      reservationPresetManagementPage.routeDate.simpleSetValue(routeDate);
      reservationPresetManagementPage.waitWhilePageIsLoading(2);
    }
    reservationPresetManagementPage.reservationPresetTable.selectRow(1);
    reservationPresetManagementPage.actionsMenu.selectOption("Route Pending Reservations");
    reservationPresetManagementPage.createRouteDialog.waitUntilVisible();
    reservationPresetManagementPage.createRouteDialog.confirm.clickAndWaitUntilDone();
  }

  @Then("Operator create route on Reservation Preset Management page:")
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

  @After(value = "@ReservationPresetManagementCleanup", order = 9999)
  public void rpmCleanup() {
    List<Address> shipperAddresses = shipperClient.readAddresses(RPM_SHIPPER_ID);
    if (!shipperAddresses.isEmpty()) {
      shipperAddresses.forEach(address -> {
        try {
          getShipperClient().deleteAddress(address.getShipperId(), address.getId());
          LOGGER.info("Success delete address [{}] of shipper [{}]", address.getId(),
              address.getShipperId());
        } catch (Throwable ex) {
          LOGGER.warn("Could not delete address [{}] of shipper [{}]", address.getId(),
              address.getShipperId());
        }
      });
    }
    // DELETE ALL SHIPPER RESERVATIONS
    ReservationFilter filter = new ReservationFilter();
    filter.setShipperId(RPM_SHIPPER_ID_LEGACY);
    List<ReservationResponse> shipperReservations = getReservationClient().getListOfReservations(
        filter);
    if (!shipperReservations.isEmpty()) {
      shipperReservations.forEach(
          reservation -> getReservationClient().updateReservation(reservation.getId(), 4)
      );
    }
    // UNSET MILKRUN FOR ALL ADDRESSES
    shipperClient.readAddresses(RPM_SHIPPER_ID).forEach(address -> {
      try {
        Address updateAddressRequest = fromJson(String.format("{\"is_milk_run\":%s}", false),
            Address.class);
        getShipperClient().updateAddressBasedOnRequest(address.getShipperId(), address.getId(),
            updateAddressRequest);
        LOGGER.info("Success unset milkrun address [{}] of shipper [{}] ", address.getId(),
            address.getShipperId());
      } catch (Exception e) {
        LOGGER.warn("Failed unset milkrun address [{}] of shipper [{}] ", address.getId(),
            address.getShipperId());
      }
    });
    // UNASSIGN ALL UNLINKED PENDING TASKS
    List<MilkrunPendingTask> unlinkedPendingTasks = getRouteClient().getMilkrunPendingTasks()
        .stream().filter(task -> !task.getLink()).collect(Collectors.toList());
    if (!unlinkedPendingTasks.isEmpty()) {
      unlinkedPendingTasks.forEach(unlinkedPendingTask -> {
        try {
          getRouteClient().unassignMilkrunPendingTask(unlinkedPendingTask.getId());
          LOGGER.info("Success unassign milkrun pending task: [{}]", unlinkedPendingTask.getId());
        } catch (Exception e) {
          LOGGER.warn("Failed unassign milkrun pending task: [{}]", unlinkedPendingTask.getId());
        }
      });
    }
    List<MilkRunGroup> createdMilkrunGroups = get(
        CoreScenarioStorageKeys.KEY_CORE_LIST_OF_CREATED_RESERVATION_GROUP);
    // REMOVE ALL PICKUP LOCATION FROM MILKRUN GROUP
    if (createdMilkrunGroups != null) {
      createdMilkrunGroups.forEach(
          group -> {
            try {
              routeClient.deleteAllMilkrunGroupPickupLocations(group);
              LOGGER.info("Success to remove all pickup locations from milkrun group id: [{}]",
                  group.getId());
            } catch (Exception e) {
              LOGGER.warn("Failed to remove all pickup locations from milkrun group id: [{}]",
                  group.getId());
            }
          });
    }
    // DELETE MILKRUN GROUP
    if (createdMilkrunGroups != null) {
      createdMilkrunGroups.forEach(group -> {
        try {
          getRouteClient().deleteMilkrunGroup(group.getId());
          LOGGER.info("Success to delete milkrun group id: [{}]", group.getId());
        } catch (Exception e) {
          LOGGER.warn("Failed to delete milkrun group id: [{}]", group.getId());
        }
      });
    }
    // DELETE SHIPPER ADDRESSES
    if (!shipperClient.readAddresses(RPM_SHIPPER_ID).isEmpty()) {
      shipperClient.readAddresses(RPM_SHIPPER_ID).forEach(address -> {
        try {
          getShipperClient().deleteAddress(address.getShipperId(), address.getId());
          LOGGER.info("Success delete address [{}] of shipper [{}]", address.getId(),
              address.getShipperId());
        } catch (Throwable ex) {
          LOGGER.warn("Could not delete address [{}] of shipper [{}]", address.getId(),
              address.getShipperId());
        }
      });
    }
  }
}
