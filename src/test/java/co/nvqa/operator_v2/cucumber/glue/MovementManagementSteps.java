package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Driver;
import co.nvqa.commons.model.core.hub.Hub;
import co.nvqa.commons.model.sort.hub.movement_trips.HubRelation;
import co.nvqa.commons.model.sort.hub.movement_trips.HubRelationSchedule;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.commons.util.StandardTestUtils;
import co.nvqa.operator_v2.model.MovementSchedule;
import co.nvqa.operator_v2.model.MovementSchedule.Schedule;
import co.nvqa.operator_v2.model.StationMovementSchedule;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.MovementManagementPage;
import com.google.common.collect.ImmutableMap;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.After;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.time.ZoneId;
import java.util.*;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.operator_v2.selenium.page.MovementManagementPage.SchedulesTable.COLUMN_DESTINATION_HUB;
import static co.nvqa.operator_v2.selenium.page.MovementManagementPage.SchedulesTable.COLUMN_ORIGIN_HUB;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class MovementManagementSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(MovementManagementSteps.class);
  private MovementManagementPage movementManagementPage;
  private static final String HUB_CD_CD = "CD->CD";
  private static final String HUB_CD_ITS_ST = "CD->its ST";
  private static final String HUB_CD_ST_DIFF_CD = "CD->ST under another CD";
  private static final String HUB_ST_ST_SAME_CD = "ST->ST under same CD";
  private static final String HUB_ST_ST_DIFF_CD = "ST->ST under diff CD";
  private static final String HUB_ST_ITS_CD = "ST->its CD";
  private static final String HUB_ST_CD_DIFF_CD = "ST->another CD";

  public MovementManagementSteps() {
  }

  @Override
  public void init() {
    movementManagementPage = new MovementManagementPage(getWebDriver());
  }

  @Then("Operator can select {string} crossdock hub when create crossdock movement schedule")
  public void operatorCanSelectCrossdockHubWhenCreateCrossdockMovementSchedule(String hubName) {
    retryIfRuntimeExceptionOccurred(() ->
    {
      try {
        final String finalHubName = resolveValue(hubName);
        movementManagementPage.addMovementScheduleModal.getScheduleForm(1).originHub.selectValue(
            finalHubName);
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        LOGGER.info(
            f("Cannot select [%s] value in Origin Crossdock Hub field on the New Crossdock Movement Schedule dialog",
                hubName));
        navigateRefresh();
        movementManagementPage.switchTo();
        movementManagementPage.addSchedule.waitUntilClickable(60);
        movementManagementPage.addSchedule.click();
        movementManagementPage.addMovementScheduleModal.waitUntilVisible();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 10);
  }

  @Then("Operator can not select {string} destination crossdock hub on Add Movement Schedule dialog")
  public void operatorCannotSelectDestinationCrossdockHub(String hubName) {
    hubName = resolveValue(hubName);
    try {
      movementManagementPage.addMovementScheduleModal.getScheduleForm(1).destinationHub
          .selectValue(hubName);
      fail(
          f("Operator can select [%s] value in Destination Crossdock Hub field on the New Crossdock Movement Schedule dialog, but must not",
              hubName));
    } catch (NoSuchElementException ex) {
      // Step passed. Do nothing
    }
  }

  @When("Movement Management page is loaded")
  public void movementManagementPageIsLoaded() {
    movementManagementPage.addSchedule.waitUntilVisible(10);
    movementManagementPage.switchTo();
    movementManagementPage.addSchedule.waitUntilClickable(60);
  }

  @Then("Operator adds new Movement Schedule on Movement Management page using data below:")
  public void operatorAddsNewMovementScheduleOnMovementManagementPageUsingDataBelow(
      Map<String, String> data) {
      pause5s();
        operatorOpensAddMovementScheduleDialogOnMovementManagementPage();
        operatorFillAddMovementScheduleFormUsingDataBelow(data);
        operatorClickButtonOnAddMovementScheduleDialog("OK");
        pause6s();
  }

  @When("Operator clicks on assign_driver icon on the action column in movement schedule page")
  public void operatorClicksOnAssignDriverOnTheActionColumn() {
    movementManagementPage.clickAssignDriverIcon();
  }

  @And("Operator assign driver {string} to created movement schedule")
  public void operatorAssignDriverToCreatedMovementScheduleWithData(String driverUsername) {
    String resolvedDriverUsername = resolveValue(driverUsername);
    movementManagementPage.assignDriver(resolvedDriverUsername);
  }

  @Then("Operator edits Crossdock Movement Schedule on Movement Management page using data below:")
  public void operatorEditsCrossdockMovementScheduleOnMovementManagementPageUsingDataBelow(
      Map<String, String> mapOfData) {
    MovementSchedule movementSchedule = get(KEY_CREATED_MOVEMENT_SCHEDULE);
    Map<String, String> data = resolveKeyValues(mapOfData);
    data = StandardTestUtils.replaceDataTableTokens(data);
    movementSchedule.fromMap(data);

    movementManagementPage.modify.click();
    movementManagementPage.schedulesTable
        .filterByColumn(COLUMN_ORIGIN_HUB, movementSchedule.getSchedule(0).getOriginHub());
    movementManagementPage.schedulesTable.filterByColumn(COLUMN_DESTINATION_HUB,
        movementSchedule.getSchedule(0).getDestinationHub());
    movementManagementPage.schedulesTable.editSchedule(movementSchedule.getSchedule(0));
    movementManagementPage.save.click();
    movementManagementPage.updateSchedulesConfirmationModal.update.click();
    pause3s();
  }

  @Then("Operator adds new relation on Movement Management page using data below:")
  public void operatorAddsNewRelationOnMovementManagementPageUsingDataBelow(
      Map<String, String> data) {
    retryIfRuntimeExceptionOccurred(() ->
    {
      try {
        final Map<String, String> finalData = resolveKeyValues(data);
        String station = finalData.get("station");
        String crossdockHub = finalData.get("crossdockHub");
        String stationId = finalData.get("stationId");
        String crossdockId = finalData.get("crossdockHubId");
        String tabName = "Pending";
        if (stationId != null && crossdockId != null) {
          putInList(KEY_LIST_OF_CROSSDOCK_DETAIL_STATION_ID, Long.valueOf(stationId));
          putInList(KEY_LIST_OF_CROSSDOCK_DETAIL_CROSSDOCK_ID, Long.valueOf(crossdockId));
        }
        operatorSelectTabOnMovementManagementPage("Relations");
        operatorSelectTabOnMovementManagementPage(tabName);
        pause(50000);
        movementManagementPage.stationFilter.forceClear();
        movementManagementPage.stationFilter.setValue(station);
        if (movementManagementPage.relationsTable.rows.size()==0 || !movementManagementPage.relationsTable.rows.get(0).editRelations.isDisplayed()) {
          tabName = "All";
          operatorSelectTabOnMovementManagementPage(tabName);
        }
        movementManagementPage.relationsTable.rows.get(0).editRelations.click();
        movementManagementPage.editStationRelationsModal.waitUntilVisible();
        retryIfRuntimeExceptionOccurred(() ->
            movementManagementPage.editStationRelationsModal.fill(crossdockHub), 2);
        movementManagementPage.editStationRelationsModal.save.click();
        if (tabName.equals("All")) {
          movementManagementPage.successUpdateRelation.waitUntilVisible();
          movementManagementPage.successUpdateRelation.waitUntilInvisible();
        } else {
          movementManagementPage.successCreateRelation.waitUntilVisible();
          movementManagementPage.successCreateRelation.waitUntilInvisible();
        }
        movementManagementPage.editStationRelationsModal.waitUntilInvisible();
        pause5s();
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        LOGGER.info("Searched element is not found, retrying...");
        movementManagementPage.refreshPage();
        movementManagementPage.switchTo();
        movementManagementPage.relationsTab.waitUntilClickable(60);
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 3);
  }

  @Then("Operator search for Pending relation on Movement Management page using data below:")
  public void operatorSearchForPendingRelationOnMovementManagementPageUsingDataBelow(
      Map<String, String> data) {
    retryIfRuntimeExceptionOccurred(() ->
    {
      try {
        final Map<String, String> finalData = resolveKeyValues(data);
        String station = finalData.get("station");
        operatorSelectTabOnMovementManagementPage("Relations");
        operatorSelectTabOnMovementManagementPage("Pending");
        Optional.ofNullable(station)
            .ifPresent(value -> movementManagementPage.stationFilter.setValue(value));
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        LOGGER.info("Searched element is not found, retrying after 2 seconds...");
        navigateRefresh();
        movementManagementPage.switchTo();
        movementManagementPage.relationsTab.waitUntilClickable(60);
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 3);
  }

  @Then("Operator verify relations table on Movement Management page using data below:")
  public void operatorVerifyRelationTableOnMovementManagementPageUsingDataBelow(
      Map<String, String> data) {
    data = resolveKeyValues(data);
    Optional.ofNullable(data.get("station"))
        .ifPresent(value -> assertEquals("Station", value,
            movementManagementPage.relationsTable.rows.get(0).station.getText()));
    Optional.ofNullable(data.get("crossdockHub"))
        .ifPresent(value -> assertEquals("Crossdock Hub", value,
            movementManagementPage.relationsTable.rows.get(0).crossdock.getText()));
  }

  @Then("Operator verify relations table on Movement Management page is empty")
  public void operatorVerifyRelationTableOnMovementManagementPageIsEmpty() {
    assertEquals("Numbers of row in Relations table", 0,
        movementManagementPage.relationsTable.rows.size());
  }

  @Then("Operator adds new Station Movement Schedule on Movement Management page using data below:")
  public void operatorAddsNewStationMovementScheduleOnMovementManagementPageUsingDataBelow(
      Map<String, String> data) {
    movementManagementPage.waitForLoadingIconDisappear();
    retryIfRuntimeExceptionOccurred(() ->
    {
      try {
        Map<String, String> finalData = resolveKeyValues(data);
        if(finalData.get("departureTime").equalsIgnoreCase("EXISTED")){
          movementManagementPage.modify.click();
          String UpdatedStartTime = movementManagementPage.getValueInLastItem("start time", "value");
          String UpdatedDurationTime = movementManagementPage.getValueInLastItem("duration", "value");
          finalData.put("departureTime",UpdatedStartTime);
          finalData.put("endTime",UpdatedDurationTime);
          movementManagementPage.close.click();
          movementManagementPage.StartTime = UpdatedStartTime;
        }
        StationMovementSchedule stationMovementSchedule = new StationMovementSchedule(finalData);
        movementManagementPage.addSchedule.click();
        movementManagementPage.addStationMovementScheduleModal.waitUntilVisible();
        movementManagementPage.addStationMovementScheduleModal.fill(stationMovementSchedule, "0");
        if (StringUtils.isNotBlank(finalData.get("assignDrivers"))){
          List<Driver> middleMileDrivers = get(KEY_LIST_OF_CREATED_DRIVERS);
          int numberOfDrivers = Integer.parseInt(finalData.get("assignDrivers"));
          movementManagementPage.assignDrivers(numberOfDrivers,middleMileDrivers,0);
        }
        putInList(KEY_LIST_OF_CREATED_STATION_MOVEMENT_SCHEDULE, stationMovementSchedule);
        if (StringUtils.isNotBlank(finalData.get("addAnother"))) {
          movementManagementPage.addStationMovementScheduleModal.addAnotherSchedule.click();
          StationMovementSchedule secondStationMovementSchedule = new StationMovementSchedule(
              finalData);
          secondStationMovementSchedule.setDepartureTime("21:01");
          movementManagementPage.addStationMovementScheduleModal.fillAnother(
              secondStationMovementSchedule, "1");
          if (StringUtils.isNotBlank(finalData.get("assignDrivers"))){
            List<Driver> middleMileDrivers = get(KEY_LIST_OF_CREATED_DRIVERS);
            int numberOfDrivers = Integer.parseInt(finalData.get("assignDrivers"));
            movementManagementPage.assignDrivers(numberOfDrivers,middleMileDrivers,1);
          }
          putInList(KEY_LIST_OF_CREATED_STATION_MOVEMENT_SCHEDULE, secondStationMovementSchedule);
        }

        movementManagementPage.addStationMovementScheduleModal.create.click();
        movementManagementPage.addStationMovementScheduleModal.waitUntilInvisible();
      } catch (Exception ex) {
        LOGGER.error(ex.getMessage());
        LOGGER.info("Searched element is not found, retrying after 2 seconds...");
        navigateRefresh();
        movementManagementPage.switchTo();
        movementManagementPage.stationsTab.click();
        movementManagementPage.addSchedule.click();
        movementManagementPage.addSchedule.waitUntilClickable(60);
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 3);

  }

  @Then("Operator try adds new Station Movement Schedule on Movement Management page using data below:")
  public void operatorTryAddsNewStationMovementScheduleOnMovementManagementPageUsingDataBelow(
      Map<String, String> data) {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() ->
    {
      try {
        final Map<String, String> finalData = resolveKeyValues(data);
        StationMovementSchedule stationMovementSchedule = new StationMovementSchedule(finalData);
        movementManagementPage.stationsTab.click();
          movementManagementPage.addSchedule.click();
          movementManagementPage.addStationMovementScheduleModal.waitUntilVisible();
          movementManagementPage.addStationMovementScheduleModal.fill(stationMovementSchedule, "0");
        putInList(KEY_LIST_OF_CREATED_STATION_MOVEMENT_SCHEDULE, stationMovementSchedule);
        if (StringUtils.isNotBlank(finalData.get("addAnother"))) {
          movementManagementPage.addStationMovementScheduleModal.addAnotherSchedule.click();
          StationMovementSchedule secondStationMovementSchedule = new StationMovementSchedule(
              finalData);
          secondStationMovementSchedule.setDepartureTime("21:15");
          movementManagementPage.addStationMovementScheduleModal.fillAnother(
              secondStationMovementSchedule, "1");
          putInList(KEY_LIST_OF_CREATED_STATION_MOVEMENT_SCHEDULE, secondStationMovementSchedule);
        }
        movementManagementPage.addStationMovementScheduleModal.create.click();
        movementManagementPage.addStationMovementScheduleModal.waitUntilInvisible();
        pause6s();
      } catch (Exception ex) {
        LOGGER.error(ex.getMessage());
        LOGGER.info("Searched element is not found, retrying after 2 seconds...");
        navigateRefresh();
        movementManagementPage.stationsTab.click();
        movementManagementPage.addSchedule.click();
        movementManagementPage.addSchedule.waitUntilClickable(60);
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 3);

  }

  @Then("Operator adds new Station Movement Schedules on Movement Management page:")
  public void operatorAddsNewStationMovementScheduleOnMovementManagementPageUsingDataBelow(
      List<Map<String, String>> data) {
    data = resolveListOfMaps(data);
    Boolean isSameWave = false;
    movementManagementPage.stationsTab.click();
    movementManagementPage.addSchedule.click();
    movementManagementPage.addStationMovementScheduleModal.waitUntilVisible();
    for (int i = 0; i < data.size(); i++) {
      Map<String, String> map = data.get(i);
      StationMovementSchedule stationMovementSchedule = new StationMovementSchedule(map);
      if (i > 0) {
        Map<String,String> item1 = map;
        Map<String,String> item2 = data.get(i-1);
        item1.remove("daysOfWeek");
        item2.remove("daysOfWeek");
        if (item1.equals(item2)) isSameWave = true;
        movementManagementPage.addStationMovementScheduleModal.addAnotherSchedule.click();
        movementManagementPage.addStationMovementScheduleModal.fillAnother(stationMovementSchedule,
            String.valueOf(i));
      } else {
        movementManagementPage.addStationMovementScheduleModal.fill(stationMovementSchedule,
            String.valueOf(i));
      }
      if(!isSameWave) putInList(KEY_LIST_OF_CREATED_STATION_MOVEMENT_SCHEDULE, stationMovementSchedule);
    }
    movementManagementPage.addStationMovementScheduleModal.create.click();
    movementManagementPage.addStationMovementScheduleModal.waitUntilInvisible();
  }

  @And("Operator load schedules on Movement Management page using data below:")
  public void operatorLoadSchedulesOnMovementManagementPageUsingDataBelow(
      Map<String, String> data) {
    data = resolveKeyValues(data);
    String crossdockHub = data.get("crossdockHub");
    String originHub = data.get("originHub");
    String destinationHub = data.get("destinationHub");
    movementManagementPage.loadSchedules(crossdockHub, originHub, destinationHub);
  }

  @And("Operator load schedules on Movement Management page with retry using data below:")
  public void operatorLoadSchedulesOnMovementManagementPageWithRetryUsingDataBelow(
      Map<String, String> inputData) {
    retryIfRuntimeExceptionOccurred(() ->
    {
      try {
        final Map<String, String> data = resolveKeyValues(inputData);
        String crossdockHub = data.get("crossdockHub");
        String originHub = data.get("originHub");
        String destinationHub = data.get("destinationHub");
        movementManagementPage.loadSchedules(crossdockHub, originHub, destinationHub);
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        LOGGER.info("Searched element is not found, retrying after 2 seconds...");
        LOGGER.info(ex.getMessage());
        movementManagementPage.refreshPage();
        movementManagementPageIsLoaded();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 10);
  }

  @And("Operator load schedules and verifies on Movement Management page with retry using data below:")
  public void operatorLoadSchedulesAndVerifiesOnMovementManagementPageWithRetryUsingDataBelow(
      Map<String, String> inputData) {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() ->
    {
      try {
        final Map<String, String> data = resolveKeyValues(inputData);
        String crossdockHub = data.get("crossdockHub");
        String originHub = data.get("originHub");
        String destinationHub = data.get("destinationHub");
        movementManagementPage.loadSchedules(crossdockHub, originHub, destinationHub);

        MovementSchedule movementSchedule = get(KEY_CREATED_MOVEMENT_SCHEDULE);
        assertEquals("Number of displayed schedules", movementSchedule.getSchedules().size(),
            movementManagementPage.schedulesTable.getRowsCount());
        for (int i = 0; i < movementSchedule.getSchedules().size(); i++) {
          MovementSchedule.Schedule actual = movementManagementPage.schedulesTable.readEntity(
              i + 1);
          movementSchedule.getSchedule(i).compareWithActual(actual);
        }

      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        LOGGER.info("Searched element is not found, retrying after 2 seconds...");
        movementManagementPage.refreshPage();
        movementManagementPageIsLoaded();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 3);
  }

  @And("Operator load schedules on Movement Management page")
  public void operatorLoadSchedulesOnMovementManagementPage() {
    if (movementManagementPage.editFilters.isDisplayedFast()) {
      movementManagementPage.editFilters.click();
    }
    movementManagementPage.loadSchedules.click();
    pause5s();
  }

  @Then("Operator verifies a new schedule is created on Movement Management page")
  @And("Operator verifies Crossdock Movement Schedule parameters on Movement Management page")
  public void operatorVerifiesANewScheduleIsCreatedOnMovementManagementPage() {
    MovementSchedule movementSchedule = get(KEY_CREATED_MOVEMENT_SCHEDULE);
    assertEquals("Number of displayed schedules", movementSchedule.getSchedules().size(),
        movementManagementPage.schedulesTable.getRowsCount());
    for (int i = 0; i < movementSchedule.getSchedules().size(); i++) {
      MovementSchedule.Schedule actual = movementManagementPage.schedulesTable.readEntity(i + 1);
      movementSchedule.getSchedule(i).compareWithActual(actual);
    }
    if (movementManagementPage.middleMileDrivers !=null) movementManagementPage.verifyListDriver(movementManagementPage.middleMileDrivers);
  }

  @And("Operator opens Add Movement Schedule modal on Movement Management page")
  public void operatorOpensAddMovementScheduleDialogOnMovementManagementPage() {
    movementManagementPage.addSchedule.click();
    movementManagementPage.addMovementScheduleModal.waitUntilVisible();
  }

  @And("Operator click {string} button on Add Movement Schedule dialog")
  public void operatorClickButtonOnAddMovementScheduleDialog(String buttonName) {
    switch (StringUtils.normalizeSpace(buttonName.toLowerCase())) {
      case "ok":
        movementManagementPage.addMovementScheduleModal.create.click();
        movementManagementPage.addMovementScheduleModal.waitUntilInvisible();
        break;
      case "cancel":
        movementManagementPage.addMovementScheduleModal.cancel.click();
        movementManagementPage.addMovementScheduleModal.waitUntilInvisible();
        break;
      default:
        throw new IllegalArgumentException(
            f("Unknown button name [%s] on 'Add Movement Schedule' dialog", buttonName));
    }
  }

  @And("Operator fill Add Movement Schedule form using data below:")
  public void operatorFillAddMovementScheduleFormUsingDataBelow(Map<String, String> data) {
    retryIfRuntimeExceptionOccurred(() -> {
      try {
        final Map<String, String> finalData = StandardTestUtils
            .replaceDataTableTokens(resolveKeyValues(data));
        MovementSchedule movementSchedule = new MovementSchedule();
        movementSchedule.fromMap(finalData);
        List<String> drivers =
                finalData.keySet().stream()
                        .filter(key -> key.contains("numberOfDrivers"))
                        .map(finalData::get)
                        .collect(Collectors.toList());

    if (drivers.size()>0){
      movementManagementPage.middleMileDrivers = get(KEY_LIST_OF_CREATED_DRIVERS);
      System.out.println("Dreiver test: "+ drivers);
    }

        movementManagementPage.addMovementScheduleModal.fill(movementSchedule);

        MovementSchedule existed = get(KEY_CREATED_MOVEMENT_SCHEDULE);
        if (existed == null) {
          put(KEY_CREATED_MOVEMENT_SCHEDULE, movementSchedule);
        } else {
          Optional<Schedule> scheduleExist = existed.getSchedules().stream()
              .filter((schedule) -> schedule.getDepartureTime()
                  .equals(movementSchedule.getSchedule(0).getDepartureTime())).findFirst();

          if (!scheduleExist.isPresent()) {
            existed.getSchedules().addAll(movementSchedule.getSchedules());
          }
        }
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        LOGGER.info("Searched element is not found, retrying after 2 seconds...");
        LOGGER.info(ex.getMessage());
        navigateRefresh();
        movementManagementPage.switchTo();
        movementManagementPage.addSchedule.waitUntilClickable(60);
        movementManagementPage.addSchedule.click();
        movementManagementPage.addMovementScheduleModal.waitUntilVisible();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 3);
  }

  @Then("Operator verify Add Movement Schedule form is empty")
  public void operatorVerifyAddMovementScheduleFormIsEmpty() {
    assertNull("Origin Crossdock Hub value",
        movementManagementPage.addMovementScheduleModal.getScheduleForm(1).originHub.getValue());
    assertNull("Destination Crossdock Hub value",
        movementManagementPage.addMovementScheduleModal.getScheduleForm(1).destinationHub
            .getValue());
    assertNull("Movement Type value",
        movementManagementPage.addMovementScheduleModal.getScheduleForm(
            1).movementType.getValue());
    assertEquals("Comment value", null,
        movementManagementPage.addMovementScheduleModal.getScheduleForm(1).comment.getValue());
  }

  @Then("Operator verifies Add Movement Schedule dialog is closed on Movement Management page")
  public void operatorVerifiesAddMovementScheduleDialogIsClosedOnMovementManagementPage() {
    assertFalse("Add Movement Schedule dialog is opened",
        movementManagementPage.addMovementScheduleModal.isDisplayed());
  }

  @Then("Operator verify schedules list is empty on Movement Management page")
  public void operatorVerifySchedulesListIsEmptyOnMovementManagementPage() {
    assertTrue("Schedules list is not empty", movementManagementPage.schedulesTable.isEmpty());
  }

  @And("Operator filters schedules list on Movement Management page using data below:")
  public void operatorFiltersSchedulesListOnMovementManagementPageUsingDataBelow(
      Map<String, String> dataMap) {
    Map<String, String> data = resolveKeyValues(dataMap);
    String originHub = data.get("originHub");
    if (StringUtils.isNotBlank(originHub)) {
      movementManagementPage.schedulesTable.filterByColumn(COLUMN_ORIGIN_HUB, originHub);
    }
    String destinationHub = data.get("destinationHub");
    if (StringUtils.isNotBlank(destinationHub)) {
      movementManagementPage.schedulesTable.filterByColumn(COLUMN_DESTINATION_HUB,
          destinationHub);
    }
  }

  @Then("Operator verify schedules list on Movement Management page using data below:")
  public void operatorVerifySchedulesListOnMovementManagementPageUsingDataBelow(
      Map<String, String> data) {
    data = resolveKeyValues(data);
    String originHub = data.get("originHub");
    String destinationHub = data.get("destinationHub");

    int schedulesCount = movementManagementPage.schedulesTable.getRowsCount();
    for (int i = 0; i < schedulesCount; i++) {
      if (StringUtils.isNotBlank(originHub)) {
        String actualOriginHub = movementManagementPage.schedulesTable
            .getColumnText(i + 1, COLUMN_ORIGIN_HUB);
        assertTrue(f("Row [%d] - Origin Hub name - doesn't contains [%s]", i + 1, originHub),
            StringUtils.containsIgnoreCase(originHub, actualOriginHub));
      }
      if (StringUtils.isNotBlank(destinationHub)) {
        String actualDestinationHub = movementManagementPage.schedulesTable
            .getColumnText(i + 1, MovementManagementPage.SchedulesTable.COLUMN_DESTINATION_HUB);
        assertTrue(
            f("Row [%d] - Destination Hub name - doesn't contains [%s]", i + 1, destinationHub),
            StringUtils.containsIgnoreCase(destinationHub, actualDestinationHub));
      }
    }
  }

  @After("@SwitchToDefaultContent")
  public void closeScheduleDialog() {
    getWebDriver().switchTo().defaultContent();
  }

  @When("Operator deletes created movement schedule on Movement Management page")
  public void operatorDeletesCreatedMovementScheduleOnMovementManagementPage() {
    movementManagementPage.modify.click();
    movementManagementPage.rowCheckBox.check();
    pause1s();
    movementManagementPage.delete.click();
    pause1s();
    movementManagementPage.modalDeleteButton.click();
    List<HubRelation> hubRelations = get(KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP);
    if (hubRelations != null) {
      hubRelations.remove(0);
    }
  }

  @And("Operator clicks close button in movement management page")
  public void operatorClicksCloseButtonInMovementManagementPage() {
    movementManagementPage.closeButton.click();
  }

  @Then("Operator verifies movement schedule deleted toast is shown on Movement Management page")
  public void operatorVerifiesMovementScheduleDeletedToastIsShownOnMovementManagementPage() {
    movementManagementPage.verifyNotificationWithMessage("1 schedule(s) have been deleted");
  }

  @Deprecated
  @When("Operator open view modal of a created movement schedule on Movement Management page")
  public void operatorOpenViewDialogOfACreatedMovementScheduleOnMovementManagementPage() {
    MovementSchedule movementSchedule = get(KEY_CREATED_MOVEMENT_SCHEDULE);
    Map<String, String> filters = ImmutableMap
        .of("originHub", movementSchedule.getSchedule(0).getOriginHub(), "destinationHub",
            movementSchedule.getSchedule(0).getDestinationHub());
    operatorFiltersSchedulesListOnMovementManagementPageUsingDataBelow(filters);
    //TODO Rework this according new scenarios
//        movementManagementPage.schedulesTable.rows.get(0).clickAction("View Schedule");
    movementManagementPage.movementScheduleModal.waitUntilVisible();
    pause1s();
  }

  @And("Operator verifies created movement schedule data on Movement Schedule modal on Movement Management page")
  public void operatorVerifiesCreatedMovementScheduleDataOnMovementScheduleModalOnMovementManagementPage
      () {
    MovementSchedule movementSchedule = get(KEY_CREATED_MOVEMENT_SCHEDULE);
    String actualOriginHub = movementManagementPage.movementScheduleModal.originCrossdockHub
        .getText();
    assertEquals("Origin Crossdock Hub", movementSchedule.getSchedule(0).getOriginHub(),
        actualOriginHub);

    String actualDestinationHub = movementManagementPage.movementScheduleModal.destinationCrossdockHub
        .getText();
    assertEquals("Destination Crossdock Hub", movementSchedule.getSchedule(0).getDestinationHub(),
        actualDestinationHub);

    assertTrue("Edit Schedule button is disabled",
        movementManagementPage.movementScheduleModal.editSchedule.isEnabled());
  }

  @When("^Operator select \"(.+)\" tab on Movement Management page$")
  public void operatorSelectTabOnMovementManagementPage(String tabName) {
    switch (StringUtils.normalizeSpace(tabName.toLowerCase())) {
      case "crossdock hubs":
        movementManagementPage.crossdockHubsTab.click();
        break;
      case "stations":
        movementManagementPage.stationsTab.click();
        Assertions.assertThat(movementManagementPage.loadSchedules.isEnabled()).as("Load Schedules Button is disable").isFalse();
        break;
      case "relations":
        movementManagementPage.relationsTab.click();
        pause1s();
        movementManagementPage
            .waitUntil(
                () -> !StringUtils.contains(movementManagementPage.allTab.getText(), "(0)"),
                10000);
        break;
      case "pending":
        movementManagementPage.pendingTab.click();
        break;
      case "complete":
        movementManagementPage.completedTab.click();
        break;
      case "all":
        movementManagementPage.allTab.click();
        break;
      default:
        fail("Unknown tab name [%s]", tabName);
    }
  }

  @When("Operator verify 'All' 'Pending' and 'Complete' tabs are displayed on 'Relations' tab")
  public void operatorVerifyTabsAreDisplayedOnRelationsTab() {
    assertTrue("All tab is displayed", movementManagementPage.allTab.isDisplayedFast());
    assertTrue("Pending tab is displayed", movementManagementPage.pendingTab.isDisplayedFast());
    assertTrue("Complete tab is displayed",
        movementManagementPage.completedTab.isDisplayedFast());
  }

  @When("^Operator verify \"(.+)\" tab is selected on 'Relations' tab$")
  public void operatorVerifyTabIsSelectedOnRelationsTab(String tabName) {
    PageElement tabElement = null;
    switch (StringUtils.normalizeSpace(tabName.toLowerCase())) {
      case "all":
        tabElement = movementManagementPage.allTab;
        break;
      case "pending":
        tabElement = movementManagementPage.pendingTab;
        break;
      case "completed":
        tabElement = movementManagementPage.completedTab;
        break;
      default:
        fail("Unknown tab name [%s]", tabName);
    }
    assertTrue(f("%s tab is selected", tabName),
        tabElement.hasClass("ant-radio-button-wrapper-checked"));
  }

  @When("^Operator verify all Crossdock Hub in Pending tab have \"(.+)\" value$")
  public void operatorVerifyCrossdockHubInPendingTabOnRelationsTab(String expectedValue) {
    assertTrue(f("All Crossdock Hub in Pending tab have '%s' value", expectedValue),
        movementManagementPage.relationsTable.rows.stream().map(row -> row.crossdock.getText())
            .allMatch(expectedValue::equals));
  }

  @When("Operator verify all Crossdock Hub of all listed Stations already defined")
  public void operatorVerifyCrossdockHubAlreadyDefinedOnRelationsTab() {
    assertTrue("all Crossdock Hub of all listed Stations already defined",
        movementManagementPage.relationsTable.rows.stream().map(row -> row.crossdock.getText())
            .noneMatch("Unfilled"::equals));
  }

  @When("Operator verify there is 'Edit Relation' link in Relations table on 'Relations' tab")
  public void operatorVerifyEditRelationLinkOnRelationsTab() {
    assertTrue("there is hyperlink for 'Edit Relations' on the right side",
        movementManagementPage.relationsTable.rows.stream()
            .map(row -> row.editRelations.getText())
            .allMatch("Edit Relations"::equals));
  }

  @When("Operator verify {string} error Message is displayed in Add Crossdock Movement Schedule dialog")
  public void operatorVerifyErrorMessageInAddCrossdockMovementScheduleDialog(
      String expectedMessage) {
    assertTrue("Error message is not displayed",
        movementManagementPage.addMovementScheduleModal.errorMessage.isDisplayedFast());
    assertEquals("Error message text", expectedMessage,
        movementManagementPage.addMovementScheduleModal.errorMessage.getText());
  }

  @When("Operator deletes schedule for {string} movement")
  public void operatorDeletesScheduleForMovement(String scheduleType) {
    retryIfRuntimeExceptionOccurred(() -> {
      try {
        List<Hub> hubs = get(KEY_LIST_OF_CREATED_HUBS);
        String originHub = hubs.get(0).getName();
        String destinationHub = hubs.get(1).getName();
        switch (scheduleType) {
          case HUB_CD_CD:
            movementManagementPage.originCrossdockHub.selectValue(originHub);
            movementManagementPage.destinationCrossdockHub.selectValue(destinationHub);
            break;
          case HUB_CD_ITS_ST:
            movementManagementPage.stationsTab.click();
            movementManagementPage.crossdockHub.selectValue(originHub);
            movementManagementPage.originStationHub.selectValue(originHub);
            movementManagementPage.destinationStationHub.selectValue(destinationHub);
            break;
          case HUB_CD_ST_DIFF_CD:
            destinationHub = hubs.get(2).getName();
            movementManagementPage.originCrossdockHub.selectValue(originHub);
            movementManagementPage.destinationCrossdockHub.selectValue(destinationHub);
            break;
          case HUB_ST_ST_SAME_CD:
          case HUB_ST_ST_DIFF_CD:
          case HUB_ST_CD_DIFF_CD:
            destinationHub = hubs.get(2).getName();
            movementManagementPage.stationsTab.click();
            movementManagementPage.crossdockHub.selectValue(destinationHub);
            movementManagementPage.originStationHub.selectValue(originHub);
            movementManagementPage.destinationStationHub.selectValue(destinationHub);
            break;
          case HUB_ST_ITS_CD:
            movementManagementPage.stationsTab.click();
            movementManagementPage.crossdockHub.selectValue(destinationHub);
            movementManagementPage.originStationHub.selectValue(originHub);
            movementManagementPage.destinationStationHub.selectValue(destinationHub);
            break;
        }
        movementManagementPage.loadSchedules.click();
        movementManagementPage.modify.click();
        movementManagementPage.rowCheckBox.check();
        movementManagementPage.rowCheckBoxSecond.check();
        movementManagementPage.delete.click();
        movementManagementPage.modalDeleteButton.click();
        movementManagementPage
            .verifyNotificationWithMessage("2 schedule(s) have been deleted.");
        assertThat("effecting path text is equal",
            movementManagementPage.effectingPathText.getText(), equalTo("Effecting Paths"));
        movementManagementPage.effectingPathClose.click();
        assertThat("No results found is true",
            movementManagementPage.noResultsFoundText.getText(),
            equalTo("No Results Found"));
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        LOGGER.info(
            f("Cannot select hub name value in Origin Crossdock Hub field on the Movement Schedule page"));
        movementManagementPage.refreshPage();
        movementManagementPage.switchTo();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 5);
  }

  @When("Operator updates schedule for {string} movement")
  public void operatorUpdatesScheduleForMovement(String scheduleType) {
    retryIfRuntimeExceptionOccurred(() -> {
      try {
        List<Hub> hubs = get(KEY_LIST_OF_CREATED_HUBS);
        String originHub = hubs.get(0).getName();
        String destinationHub = hubs.get(1).getName();
        switch (scheduleType) {
          case HUB_CD_CD:
            movementManagementPage.originCrossdockHub.selectValue(originHub);
            movementManagementPage.destinationCrossdockHub.selectValue(destinationHub);
            break;
          case HUB_CD_ITS_ST:
            movementManagementPage.stationsTab.click();
            movementManagementPage.crossdockHub.selectValue(originHub);
            movementManagementPage.originStationHub.selectValue(originHub);
            movementManagementPage.destinationStationHub.selectValue(destinationHub);
            break;
          case HUB_CD_ST_DIFF_CD:
            destinationHub = hubs.get(2).getName();
            movementManagementPage.originCrossdockHub.selectValue(originHub);
            movementManagementPage.destinationCrossdockHub.selectValue(destinationHub);
            break;
          case HUB_ST_ST_SAME_CD:
          case HUB_ST_ST_DIFF_CD:
          case HUB_ST_CD_DIFF_CD:
            destinationHub = hubs.get(2).getName();
            movementManagementPage.stationsTab.click();
            movementManagementPage.crossdockHub.selectValue(destinationHub);
            movementManagementPage.originStationHub.selectValue(originHub);
            movementManagementPage.destinationStationHub.selectValue(destinationHub);
            break;
          case HUB_ST_ITS_CD:
            movementManagementPage.stationsTab.click();
            movementManagementPage.crossdockHub.selectValue(destinationHub);
            movementManagementPage.originStationHub.selectValue(originHub);
            movementManagementPage.destinationStationHub.selectValue(destinationHub);
            break;
        }
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        LOGGER.info(
            f("Cannot select hub name value in Origin Crossdock Hub field on the Movement Schedule page"));
        movementManagementPage.refreshPage();
        movementManagementPage.switchTo();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 5);
    movementManagementPage.loadSchedules.click();
    movementManagementPage.modify.click();
    String displayTime = DateUtil
        .displayTime(DateUtil.getDate(ZoneId.of("UTC")).plusHours(7), true);
    movementManagementPage.departureTimeInputs.get(0).sendKeys(displayTime);
    movementManagementPage.departureTimeInputs.get(0).sendKeys(Keys.RETURN);
    movementManagementPage.departureTimeInputs.get(1).sendKeys(displayTime);
    movementManagementPage.departureTimeInputs.get(1).sendKeys(Keys.RETURN);
    movementManagementPage.durationInputs.get(0).sendKeys("00:45");
    movementManagementPage.durationInputs.get(0).sendKeys(Keys.RETURN);
    movementManagementPage.durationInputs.get(1).sendKeys("00:45");
    movementManagementPage.durationInputs.get(1).sendKeys(Keys.RETURN);
    movementManagementPage.commentInputs.get(0)
        .clearAndSendKeys("This schedule has been updated by Automation Test");
    movementManagementPage.commentInputs.get(1)
        .clearAndSendKeys("This schedule has been updated by Automation Test");
    movementManagementPage.save.click();
    movementManagementPage.modalUpdateButton.click();
    movementManagementPage
        .verifyNotificationWithMessage("2 schedule(s) have been updated.");

    switch (scheduleType) {
      case HUB_CD_ITS_ST:
      case HUB_ST_ST_SAME_CD:
      case HUB_ST_ST_DIFF_CD:
      case HUB_ST_CD_DIFF_CD:
      case HUB_ST_ITS_CD:
        movementManagementPage.closeButton.click();
        break;
    }

    assertThat("departure time 1 is true",
        movementManagementPage.departureTimes.get(0).getText(), equalTo(displayTime));
    assertThat("departure time 2 is true",
        movementManagementPage.departureTimes.get(1).getText(), equalTo(displayTime));
    assertThat("duration 1 is true",
        movementManagementPage.durations.get(0).getText(), equalTo("00d 00h 45m"));
    assertThat("duration 2 is true",
        movementManagementPage.durations.get(0).getText(), equalTo("00d 00h 45m"));
    assertThat("comments 1 is true",
        movementManagementPage.comments.get(0).getText(),
        equalTo("This schedule has been updated by Automation Test"));
    assertThat("comments 2 is true",
        movementManagementPage.comments.get(0).getText(),
        equalTo("This schedule has been updated by Automation Test"));
  }

  @Then("Operator verify all station schedules are correct from UI")
  public void operatorVerifyAllStationSchedulesAreCorrectFromUI() {
    movementManagementPage.waitForLoadingIconDisappear();
    List<StationMovementSchedule> stationMovementSchedules = get(
        KEY_LIST_OF_CREATED_STATION_MOVEMENT_SCHEDULE);
    List<Driver> middleMileDrivers = get(KEY_LIST_OF_CREATED_DRIVERS);
    Assertions.assertThat(movementManagementPage.stationMovementSchedulesTable.getRowsCount())
        .as("Number of displayed schedules:").isEqualTo(stationMovementSchedules.size());
    for (int i = 0; i < stationMovementSchedules.size(); i++) {
      StationMovementSchedule actual = movementManagementPage.stationMovementSchedulesTable
          .readEntity(i + 2);
      stationMovementSchedules.get(i).setCrossdockHub(null);
      stationMovementSchedules.get(i).setDaysOfWeek((Set<String>) null);
      stationMovementSchedules.get(i).setDuration((Integer) null);
      stationMovementSchedules.get(i).compareWithActual(actual);
    }
    if (middleMileDrivers !=null) movementManagementPage.verifyListDriver(middleMileDrivers);
  }

  @Then("Operator verify all station schedules are correct")
  public void operatorVerifyAllStationSchedulesAreCorrect() {
    movementManagementPage.waitForLoadingIconDisappear();
    List<HubRelation> hubRelations = get(KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP);
    Assertions.assertThat(movementManagementPage.schedulesTable.getRowsCount())
        .as("Number of displayed schedules:").isEqualTo(hubRelations.size());
    for (int i = 0; i < hubRelations.size(); i++) {
      HubRelationSchedule actual = movementManagementPage.hubRelationScheduleTable
          .readEntity(i + 1);
      hubRelations.get(i).getSchedules().get(i).setId(null);
      hubRelations.get(i).getSchedules().get(i).setStartTime(null);
      hubRelations.get(i).getSchedules().get(i).setDay(null);
      hubRelations.get(i).getSchedules().get(i)
          .setOriginHubName(hubRelations.get(i).getOriginHubName());
      hubRelations.get(i).getSchedules().get(i)
          .setDestinationHubName(hubRelations.get(i).getDestinationHubName());
      hubRelations.get(i).getSchedules().get(i).compareWithActual(actual, "drivers");
    }
  }

  @When("Operator updates created station schedule")
  public void operatorUpdatesCreatedStationSchedule() {
    movementManagementPage.modify.click();
    movementManagementPage.UpdatesdepartureTime("21:00", 0);
    movementManagementPage.UpdatesdurationTime("01:00", 0);
    movementManagementPage.commentInputs.get(0)
        .clearAndSendKeys("This schedule has been updated by Automation Test");
    movementManagementPage.save.click();
    movementManagementPage.modalUpdateButton.click();
    movementManagementPage
        .verifyNotificationWithMessage("1 schedule(s) have been updated");
    List<HubRelation> hubRelations = get(KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP);
    hubRelations.get(0).getSchedules().get(0).setDuration("00:01:00");
    hubRelations.get(0).getSchedules().get(0).setStartTime("21:00");
    hubRelations.get(0).getSchedules().get(0)
        .setComment("This schedule has been updated by Automation Test");
  }

  @When("Operator deletes schedule {int} from Edit Schedule dialog")
  public void operatorDeletesCreatedStationSchedule(int index) {
    movementManagementPage.closeNotificationMessage();
    movementManagementPage.deleteMovementSchedule(index);
    movementManagementPage
        .verifyNotificationWithMessage("1 schedule(s) have been deleted");
  }

  @When("Operator updates all created station schedules using same values")
  public void operatorUpdatesAllCreatedStationSchedules() {
    movementManagementPage.modify.click();
    movementManagementPage.UpdatesdepartureTime("21:00");
    movementManagementPage.UpdatesdurationTime("01:00");
    movementManagementPage.commentInputs.get(0)
            .clearAndSendKeys("This schedule has been updated by Automation Test");
    movementManagementPage.save.click();
    movementManagementPage.modalUpdateButton.click();
  }

  @When("Operator updates Station Schedule to Duplicate and Existing Schedule and verifies error messages")
  public void operatorUpdatesCreatedStationSchedulesToDuplicateAndExistingShcedule(){
    HubRelation lastCreatedHub = get(KEY_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP);
    movementManagementPage.modify.click();
    String UpdatedStartTime = movementManagementPage.getValueInLastItem("start time", "value");
    String UpdatedDurationTime = movementManagementPage.getValueInLastItem("duration", "value");
    movementManagementPage.UpdatesdepartureTime(UpdatedStartTime);
    movementManagementPage.UpdatesdurationTime(UpdatedDurationTime);
    movementManagementPage.save.click();
    movementManagementPage.modalUpdateButton.click();

    List<String> errorMessageList = new ArrayList<String>();
    errorMessageList.add("duplicate schedule in the request: from origin "+lastCreatedHub.getOriginHubName()+" to destination "+
            lastCreatedHub.getDestinationHubName()+" for LAND_HAUL on MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY at "+UpdatedStartTime);
    errorMessageList.add("schedule from origin "+lastCreatedHub.getOriginHubName()+" to destination "+
            lastCreatedHub.getDestinationHubName()+" for LAND_HAUL on MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY at "+UpdatedStartTime+" already exists");

    movementManagementPage.verifyNotificationWithMessage(errorMessageList);
  }

  @When("Operator updates Station Schedule to Duplicate Schedule and verifies error messages")
  public void operatorUpdatesCreatedStationSchedulesToDuplicateShcedule(){
    HubRelation lastCreatedHub = get(KEY_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP);
    movementManagementPage.modify.click();
    String UpdatedStartTime = "00:01";
    String UpdatedDurationTime = "00:01";
    movementManagementPage.UpdatesdepartureTime(UpdatedStartTime);
    movementManagementPage.UpdatesdurationTime(UpdatedDurationTime);
    movementManagementPage.save.click();
    movementManagementPage.modalUpdateButton.click();

    List<String> errorMessageList = new ArrayList<String>();
    errorMessageList.add("duplicate schedule in the request: from origin "+lastCreatedHub.getOriginHubName()+" to destination "+
            lastCreatedHub.getDestinationHubName()+" for LAND_HAUL on MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY at "+UpdatedStartTime);

    movementManagementPage.verifyNotificationWithMessage(errorMessageList);
  }

  @When("Operator updates Station Schedule to Existing Schedule and verifies error messages")
  public void operatorUpdatesCreatedStationSchedulesToExistingShcedule(){
    HubRelation lastCreatedHub = get(KEY_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP);
    movementManagementPage.modify.click();
    String UpdatedStartTime = movementManagementPage.getValueInLastItem("start time", "value");
    String UpdatedDurationTime = movementManagementPage.getValueInLastItem("duration", "value");
    movementManagementPage.UpdatesdepartureTime(UpdatedStartTime);
    movementManagementPage.UpdatesdurationTime(UpdatedDurationTime);
    movementManagementPage.save.click();
    movementManagementPage.modalUpdateButton.click();

    List<String> errorMessageList = new ArrayList<String>();
    errorMessageList.add("schedule from origin "+lastCreatedHub.getOriginHubName()+" to destination "+
            lastCreatedHub.getDestinationHubName()+" for LAND_HAUL on MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY at "+UpdatedStartTime+" already exists");

    movementManagementPage.verifyNotificationWithMessage(errorMessageList);
  }

  @Then("Operator verifies {string} error message")
  public void OperatorVerifiesErrorMessage(String errorType){
    HubRelation lastCreatedHub = get(KEY_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP);
    List<String> errorMessageList = new ArrayList<String>();
    System.out.println("Debug Start time: "+movementManagementPage.StartTime);
    switch (errorType){
      case "Existing Schedule":
        errorMessageList.add("schedule from origin "+lastCreatedHub.getOriginHubName()+" to destination "+
                lastCreatedHub.getDestinationHubName()+" for LAND_HAUL on MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY at "+movementManagementPage.StartTime+" already exists");
        break;
      case "Duplicate Schedule":
        errorMessageList.add("duplicate schedule in the request: from origin "+lastCreatedHub.getOriginHubName()+" to destination "+
                lastCreatedHub.getDestinationHubName()+" for LAND_HAUL on MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY at "+movementManagementPage.StartTime);
        break;
      case "Duplicate and Existing Schedule":
        errorMessageList.add("duplicate schedule in the request: from origin "+lastCreatedHub.getOriginHubName()+" to destination "+
                lastCreatedHub.getDestinationHubName()+" for LAND_HAUL on MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY at "+movementManagementPage.StartTime);
        errorMessageList.add("schedule from origin "+lastCreatedHub.getOriginHubName()+" to destination "+
                lastCreatedHub.getDestinationHubName()+" for LAND_HAUL on MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY at "+movementManagementPage.StartTime+" already exists");
        break;
    }

    movementManagementPage.verifyNotificationWithMessage(errorMessageList);
  }

  @When("Operator clicks Error Message close icon")
  public void operatorCloseMessage(){
    movementManagementPage.closeNotificationMessage();
  }

  @Then("Operator verifies page is back to view mode")
  public void operatorVerifiesPageIsViewMode(){
    movementManagementPage.verifyPageInViewMode();
  }

  @Then("Operator verifies {string} with value {string} is not shown on Movement Schedules page")
  public void operatorVerifiesInvalidDriver(String name, String value){
    movementManagementPage.stationsTab.click();
    movementManagementPage.addSchedule.click();
    movementManagementPage.addStationMovementScheduleModal.waitUntilVisible();
    movementManagementPage.verifyInvalidItem(name, value,0);
  }

  @When("Operator updates created station schedule with filter using data below:")
  public void operatorUpdatesCreatedStationScheduleWithFilter(Map<String, String> data) {
    data = resolveKeyValues(data);
    String crossdockHub = data.get("crossdockHub");
    String originHub = data.get("originHub");
    String destinationHub = data.get("destinationHub");
    movementManagementPage.modify.click();
    movementManagementPage.EditFilter(crossdockHub, originHub, destinationHub);
    movementManagementPage.UpdatesdepartureTime("21:00", 0);
    movementManagementPage.UpdatesdurationTime("01:00", 0);
    movementManagementPage.commentInputs.get(0)
            .clearAndSendKeys("This schedule has been updated by Automation Test");
    movementManagementPage.save.click();
    movementManagementPage.modalUpdateButton.click();
    movementManagementPage
            .verifyNotificationWithMessage("1 schedule(s) have been updated");
    List<HubRelation> hubRelations = get(KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP);
    hubRelations.get(0).getSchedules().get(0).setDuration("00:01:00");
    hubRelations.get(0).getSchedules().get(0).setStartTime("21:00");
    hubRelations.get(0).getSchedules().get(0)
            .setComment("This schedule has been updated by Automation Test");
  }

  @When("Operator cancels Update Schedules on Movement Schedule page")
  public void operatorCancelsUpdateSchedule() {
    movementManagementPage.modify.click();
    movementManagementPage.UpdatesdepartureTime("21:00", 0);
    movementManagementPage.UpdatesdurationTime("01:00", 0);
    movementManagementPage.commentInputs.get(0)
            .clearAndSendKeys("This schedule has been updated by Automation Test");
    movementManagementPage.close.click();
  }

  @Then("Operator verifies dialog confirm with message {string} show on Movement Schedules page")
  public void operatorVerifiesConfirmMessage(String message){
    movementManagementPage.verifyConfirmDialog(message);
  }

  @When("Operator click on OK button")
  public void operatorClickOKbutton(){
    movementManagementPage.OK.click();
  }

  @When("Operator upgrades new Station Movement Schedules on Movement Management page:")
  public void operatorUpdatesScheduleOnMovementPage(List<Map<String, String>> data){
    data = resolveListOfMaps(data);
    String UpdatedStartTime ="";
    String UpdatedDurationTime ="";

    movementManagementPage.modify.click();
    if(data.get(0).get("departureTime").equalsIgnoreCase("SAMEWAVE")){
      UpdatedStartTime = movementManagementPage.getValueInLastItem("start time", "value");
      UpdatedDurationTime = movementManagementPage.getValueInLastItem("duration", "value");
      for (int i = 0; i < data.size(); i++){
        data.get(i).put("departureTime",UpdatedStartTime);
        data.get(i).put("endTime",UpdatedDurationTime);
      }
    }
    for (int i = 0; i < data.size(); i++) {
      Map<String, String> map = data.get(i);
      movementManagementPage.UpdatesdepartureTime(map.get("departureTime"), i);
      movementManagementPage.UpdatesdurationTime(map.get("endTime"), i);
      Set<String> test = new HashSet<String>();
      String[] days = map.get("daysOfWeek").split(",");
      test= Arrays.stream(days).map(day -> day.trim().toLowerCase()).collect(Collectors.toSet());
      movementManagementPage.updateDaysOfWeek(test,i+1);
      if (i>0){
        Map<String,String> item1 = map;
        Map<String,String> item2 = data.get(i-1);
        item1.remove("daysOfWeek");
        item2.remove("daysOfWeek");
        if (item1.equals(item2)) {
          List<HubRelation> hubRelations = get(KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP);
          remove(KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP);
          putInList(KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP,hubRelations.get(hubRelations.size()-1));
        }
      }
    }
    movementManagementPage.save.click();
    movementManagementPage.modalUpdateButton.click();
    movementManagementPage
            .verifyNotificationWithMessage("2 schedule(s) have been updated");
  }

  @Then("Operator verifies {string} with value {string} is not shown on Crossdock page")
  public void operatorVerifiesInvalidDriverOnCrossdocke(String name, String value){
    movementManagementPage.addSchedule.click();
    movementManagementPage.addStationMovementScheduleModal.waitUntilVisible();
    movementManagementPage.verifyInvalidItem(name, value,0);
  }
}
