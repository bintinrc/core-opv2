package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.hub.Hub;
import co.nvqa.commons.model.sort.hub.movement_trips.HubRelation;
import co.nvqa.commons.model.sort.hub.movement_trips.HubRelationSchedule;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.commons.util.StandardTestUtils;
import co.nvqa.operator_v2.model.MovementSchedule;
import co.nvqa.operator_v2.model.StationMovementSchedule;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.MovementManagementPage;
import com.google.common.collect.ImmutableMap;
import cucumber.api.java.After;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.time.ZoneId;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.NoSuchElementException;

import static co.nvqa.operator_v2.selenium.page.MovementManagementPage.SchedulesTable.COLUMN_DESTINATION_HUB;
import static co.nvqa.operator_v2.selenium.page.MovementManagementPage.SchedulesTable.COLUMN_ORIGIN_HUB;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class MovementManagementSteps extends AbstractSteps {

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
        movementManagementPage.addMovementScheduleModal.getScheduleForm(1).originHub
            .selectValue(finalHubName);
      } catch (Throwable ex) {
        NvLogger.error(ex.getMessage());
        NvLogger.info(
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
    movementManagementPage.switchTo();
    movementManagementPage.addSchedule.waitUntilClickable(60);
  }

  @Then("Operator adds new Movement Schedule on Movement Management page using data below:")
  public void operatorAddsNewMovementScheduleOnMovementManagementPageUsingDataBelow(
      Map<String, String> data) {
    retryIfRuntimeExceptionOccurred(() ->
    {
      try {
        operatorOpensAddMovementScheduleDialogOnMovementManagementPage();
        operatorFillAddMovementScheduleFormUsingDataBelow(data);
        operatorClickButtonOnAddMovementScheduleDialog("Create");
        pause6s();
      } catch (Throwable ex) {
        NvLogger.error(ex.getMessage());
        NvLogger.info("Searched element is not found, retrying after 2 seconds...");
        navigateRefresh();
        movementManagementPage.switchTo();
        movementManagementPage.addSchedule.waitUntilClickable(60);
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 10);
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
        if (stationId != null && crossdockId != null) {
          putInList(KEY_LIST_OF_CROSSDOCK_DETAIL_STATION_ID, Long.valueOf(stationId));
          putInList(KEY_LIST_OF_CROSSDOCK_DETAIL_CROSSDOCK_ID, Long.valueOf(crossdockId));
        }
        operatorSelectTabOnMovementManagementPage("Relations");
        operatorSelectTabOnMovementManagementPage("Pending");
        movementManagementPage.stationFilter.forceClear();
        movementManagementPage.stationFilter.setValue(station);
        movementManagementPage.relationsTable.rows.get(0).editRelations.click();
        movementManagementPage.editStationRelationsModal.waitUntilVisible();
        retryIfRuntimeExceptionOccurred(() ->
                movementManagementPage.editStationRelationsModal.crossdockHub.selectValue(crossdockHub),
            2);
        movementManagementPage.editStationRelationsModal.save.click();
        movementManagementPage.successCreateRelation.waitUntilVisible();
        movementManagementPage.successCreateRelation.waitUntilInvisible();
        movementManagementPage.editStationRelationsModal.waitUntilInvisible();
      } catch (Throwable ex) {
        NvLogger.error(ex.getMessage());
        NvLogger.info("Searched element is not found, retrying...");
        movementManagementPage.refreshPage();
        movementManagementPage.switchTo();
        movementManagementPage.relationsTab.waitUntilClickable(60);
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 10);
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
        NvLogger.error(ex.getMessage());
        NvLogger.info("Searched element is not found, retrying after 2 seconds...");
        navigateRefresh();
        movementManagementPage.switchTo();
        movementManagementPage.relationsTab.waitUntilClickable(60);
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 10);
  }

  @Then("Operator verify relations table on Movement Management page using data below:")
  public void operatorVerifyRelationTableOnMovementManagementPageUsingDataBelow(
      Map<String, String> data) {
    data = resolveKeyValues(data);
    Optional.ofNullable(data.get("station"))
        .ifPresent(value -> assertEquals("Station", value,
            movementManagementPage.relationsTable.rows.get(0).sation.getText()));
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
    final Map<String, String> finalData = resolveKeyValues(data);
    StationMovementSchedule stationMovementSchedule = new StationMovementSchedule(finalData);
    movementManagementPage.stationsTab.click();
    movementManagementPage.addSchedule.click();
    movementManagementPage.addStationMovementScheduleModal.waitUntilVisible();
    movementManagementPage.addStationMovementScheduleModal.fill(stationMovementSchedule);
    putInList(KEY_LIST_OF_CREATED_STATION_MOVEMENT_SCHEDULE, stationMovementSchedule);
    if (StringUtils.isNotBlank(finalData.get("addAnother"))) {
      movementManagementPage.addStationMovementScheduleModal.addAnotherSchedule.click();
      StationMovementSchedule secondStationMovementSchedule = new StationMovementSchedule(
          finalData);
      secondStationMovementSchedule.setDepartureTime("21:15");
      movementManagementPage.addStationMovementScheduleModal
          .fillAnother(secondStationMovementSchedule);
      putInList(KEY_LIST_OF_CREATED_STATION_MOVEMENT_SCHEDULE, secondStationMovementSchedule);
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
        NvLogger.error(ex.getMessage());
        NvLogger.info("Searched element is not found, retrying after 2 seconds...");
        movementManagementPage.refreshPage();
        movementManagementPageIsLoaded();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 10);
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
  }

  @And("Operator opens Add Movement Schedule modal on Movement Management page")
  public void operatorOpensAddMovementScheduleDialogOnMovementManagementPage() {
    movementManagementPage.addSchedule.click();
    movementManagementPage.addMovementScheduleModal.waitUntilVisible();
  }

  @And("Operator click {string} button on Add Movement Schedule dialog")
  public void operatorClickButtonOnAddMovementScheduleDialog(String buttonName) {
    switch (StringUtils.normalizeSpace(buttonName.toLowerCase())) {
      case "create":
        movementManagementPage.addMovementScheduleModal.create.click();
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
        movementManagementPage.addMovementScheduleModal.fill(movementSchedule);

        MovementSchedule existed = get(KEY_CREATED_MOVEMENT_SCHEDULE);
        if (existed == null) {
          put(KEY_CREATED_MOVEMENT_SCHEDULE, movementSchedule);
        } else {
          existed.getSchedules().addAll(movementSchedule.getSchedules());
        }
      } catch (Throwable ex) {
        NvLogger.error(ex.getMessage());
        NvLogger.info("Searched element is not found, retrying after 2 seconds...");
        navigateRefresh();
        movementManagementPage.switchTo();
        movementManagementPage.addSchedule.waitUntilClickable(60);
        movementManagementPage.addSchedule.click();
        movementManagementPage.addMovementScheduleModal.waitUntilVisible();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 10);
  }

  @Then("Operator verify Add Movement Schedule form is empty")
  public void operatorVerifyAddMovementScheduleFormIsEmpty() {
    assertNull("Origin Crossdock Hub value",
        movementManagementPage.addMovementScheduleModal.getScheduleForm(1).originHub.getValue());
    assertNull("Destination Crossdock Hub value",
        movementManagementPage.addMovementScheduleModal.getScheduleForm(1).destinationHub
            .getValue());
    assertNull("Movement Type value",
        movementManagementPage.addMovementScheduleModal.getScheduleForm(1).movementType.getValue());
    assertEquals("Comment value", "",
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
      movementManagementPage.schedulesTable.filterByColumn(COLUMN_DESTINATION_HUB, destinationHub);
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
    movementManagementPage.verifyNotificationWithMessage("1 schedule(s) have been deleted.");
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
  public void operatorVerifiesCreatedMovementScheduleDataOnMovementScheduleModalOnMovementManagementPage() {
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

  @When("Operator select \"(.+)\" tab on Movement Management page")
  public void operatorSelectTabOnMovementManagementPage(String tabName) {
    switch (StringUtils.normalizeSpace(tabName.toLowerCase())) {
      case "crossdock hubs":
        movementManagementPage.crossdockHubsTab.click();
        break;
      case "stations":
        movementManagementPage.stationsTab.click();
        break;
      case "relations":
        movementManagementPage.relationsTab.click();
        pause1s();
        movementManagementPage
            .waitUntil(() -> !StringUtils.contains(movementManagementPage.allTab.getText(), "(0)"),
                10000);
        break;
      case "pending":
        movementManagementPage.pendingTab.click();
        break;
      case "completed":
        movementManagementPage.completedTab.click();
        break;
      case "all":
        movementManagementPage.allTab.click();
        break;
      default:
        fail("Unknown tab name [%s]", tabName);
    }
  }

  @When("Operator verify 'All' 'Pending' and 'Completed' tabs are displayed on 'Relations' tab")
  public void operatorVerifyTabsAreDisplayedOnRelationsTab() {
    assertTrue("All tab is displayed", movementManagementPage.allTab.isDisplayedFast());
    assertTrue("Pending tab is displayed", movementManagementPage.pendingTab.isDisplayedFast());
    assertTrue("Completed tab is displayed", movementManagementPage.completedTab.isDisplayedFast());
  }

  @When("Operator verify \"(.+)\" tab is selected on 'Relations' tab")
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

  @When("Operator verify all Crossdock Hub in Pending tab have \"(.+)\" value")
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
        movementManagementPage.relationsTable.rows.stream().map(row -> row.editRelations.getText())
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
        NvLogger.error(ex.getMessage());
        NvLogger.info(
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
        NvLogger.error(ex.getMessage());
        NvLogger.info(
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
    movementManagementPage.departureTimeInputs.get(0).setValue(displayTime);
    movementManagementPage.departureTimeInputs.get(1).setValue(displayTime);
    movementManagementPage.durationInputs.get(0).setValue("00:45");
    movementManagementPage.durationInputs.get(1).setValue("00:45");
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
    List<StationMovementSchedule> stationMovementSchedules = get(
        KEY_LIST_OF_CREATED_STATION_MOVEMENT_SCHEDULE);
    assertThat("Number of displayed schedules",
        movementManagementPage.stationMovementSchedulesTable.getRowsCount(),
        equalTo(stationMovementSchedules.size()));
    for (int i = 0; i < stationMovementSchedules.size(); i++) {
      StationMovementSchedule actual = movementManagementPage.stationMovementSchedulesTable
          .readEntity(i + 1);
      stationMovementSchedules.get(i).setCrossdockHub(null);
      stationMovementSchedules.get(i).setDuration((Integer) null);
      stationMovementSchedules.get(i).compareWithActual(actual);
    }
    assertThat("Monday is checked",
        movementManagementPage.stationMovementSchedulesTable.monday.isChecked(), equalTo(true));
    movementManagementPage.stationMovementSchedulesTable.monday.click();
    assertThat("Monday still checked",
        movementManagementPage.stationMovementSchedulesTable.monday.isChecked(), equalTo(true));

    movementManagementPage.stationMovementSchedulesTable.filterStationsColumn();
    assertThat("Number of displayed schedules",
        movementManagementPage.stationMovementSchedulesTable.getRowsCount(),
        equalTo(1));
    StationMovementSchedule actual = movementManagementPage.stationMovementSchedulesTable
        .readEntity(1);
    stationMovementSchedules.get(0).setCrossdockHub(null);
    stationMovementSchedules.get(0).setDuration((Integer) null);
    stationMovementSchedules.get(0).compareWithActual(actual);
  }

  @Then("Operator verify all station schedules are correct")
  public void operatorVerifyAllStationSchedulesAreCorrect() {
    List<HubRelation> hubRelations = get(KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP);
    assertThat("Number of displayed schedules",
        movementManagementPage.schedulesTable.getRowsCount(),
        equalTo(hubRelations.size()));
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
      hubRelations.get(i).getSchedules().get(i).compareWithActual(actual);
    }
    assertThat("Monday is checked",
        movementManagementPage.hubRelationScheduleTable.monday.isChecked(), equalTo(true));
    movementManagementPage.hubRelationScheduleTable.monday.click();
    assertThat("Monday still checked",
        movementManagementPage.hubRelationScheduleTable.monday.isChecked(), equalTo(true));

    movementManagementPage.hubRelationScheduleTable.filterStationsColumn();
    assertThat("Number of displayed schedules",
        movementManagementPage.hubRelationScheduleTable.getRowsCount(),
        equalTo(1));
    HubRelationSchedule actual = movementManagementPage.hubRelationScheduleTable
        .readEntity(1);
    hubRelations.get(0).getSchedules().get(0).setId(null);
    hubRelations.get(0).getSchedules().get(0).setStartTime(null);
    hubRelations.get(0).getSchedules().get(0).setDay(null);
    hubRelations.get(0).getSchedules().get(0).compareWithActual(actual);
  }

  @When("Operator updates created station schedule")
  public void operatorUpdatesCreatedStationSchedule() {
    movementManagementPage.modify.click();
    movementManagementPage.departureTimeInputs.get(0).setValue("21:15");
    movementManagementPage.durationInputs.get(0).setValue("00:45");
    movementManagementPage.commentInputs.get(0)
        .clearAndSendKeys("This schedule has been updated by Automation Test");
    movementManagementPage.save.click();
    movementManagementPage.modalUpdateButton.click();
    movementManagementPage
        .verifyNotificationWithMessage("1 schedule(s) have been updated.");
    movementManagementPage.closeButton.click();
    List<HubRelation> hubRelations = get(KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP);
    hubRelations.get(0).getSchedules().get(0).setDuration("00:00:45");
    hubRelations.get(0).getSchedules().get(0).setStartTime("21:15");
    hubRelations.get(0).getSchedules().get(0)
        .setComment("This schedule has been updated by Automation Test");
  }
}
