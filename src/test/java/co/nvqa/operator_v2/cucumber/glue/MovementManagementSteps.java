package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.util.StandardTestUtils;
import co.nvqa.operator_v2.model.MovementSchedule;
import co.nvqa.operator_v2.model.StationMovementSchedule;
import co.nvqa.operator_v2.selenium.page.MovementManagementPage;
import com.google.common.collect.ImmutableMap;
import cucumber.api.java.After;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.StringUtils;
import org.junit.jupiter.api.Assertions;
import org.openqa.selenium.NoSuchElementException;

import java.util.Map;
import java.util.Optional;

import static co.nvqa.operator_v2.selenium.page.MovementManagementPage.SchedulesTable.COLUMN_DESTINATION_HUB;
import static co.nvqa.operator_v2.selenium.page.MovementManagementPage.SchedulesTable.COLUMN_ORIGIN_HUB;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class MovementManagementSteps extends AbstractSteps
{
    private MovementManagementPage movementManagementPage;

    public MovementManagementSteps()
    {
    }

    @Override
    public void init()
    {
        movementManagementPage = new MovementManagementPage(getWebDriver());
    }

    @Then("Operator can select {string} crossdock hub when create crossdock movement schedule")
    public void operatorCanSelectCrossdockHubWhenCreateCrossdockMovementSchedule(String hubName)
    {
        hubName = resolveValue(hubName);

        try
        {
            movementManagementPage.addMovementScheduleModal.getScheduleForm(1).originHub.selectValue(hubName);
        } catch (Throwable ex)
        {
            Assertions.fail(f("Cannot select [%s] value in Origin Crossdock Hub field on the New Crossdock Movement Schedule dialog", hubName));
        }
    }

    @Then("Operator can not select {string} destination crossdock hub on Add Movement Schedule dialog")
    public void operatorCannotSelectDestinationCrossdockHub(String hubName)
    {
        hubName = resolveValue(hubName);
        try
        {
            movementManagementPage.addMovementScheduleModal.getScheduleForm(1).destinationHub.selectValue(hubName);
            Assertions.fail(f("Operator can select [%s] value in Destination Crossdock Hub field on the New Crossdock Movement Schedule dialog, but must not", hubName));
        } catch (NoSuchElementException ex)
        {
            // Step passed. Do nothing
        }
    }

    @When("Movement Management page is loaded")
    public void movementManagementPageIsLoaded()
    {
        movementManagementPage.switchTo();
        movementManagementPage.addSchedule.waitUntilClickable(60);
//        getWebDriver().navigate().refresh();
//        movementManagementPage.switchTo();
//        movementManagementPage.addSchedule.waitUntilClickable(60);
    }

    @Then("Operator adds new Movement Schedule on Movement Management page using data below:")
    public void operatorAddsNewMovementScheduleOnMovementManagementPageUsingDataBelow(Map<String, String> data)
    {
        operatorOpensAddMovementScheduleDialogOnMovementManagementPage();
        operatorFillAddMovementScheduleFormUsingDataBelow(data);
        operatorClickButtonOnAddMovementScheduleDialog("Save Schedule");
        pause3s();
    }

    @Then("Operator adds new relation on Movement Management page using data below:")
    public void operatorAddsNewRelationOnMovementManagementPageUsingDataBelow(Map<String, String> data)
    {
        data = resolveKeyValues(data);
        String station = data.get("station");
        String crossdockHub = data.get("crossdockHub");
        movementManagementPage.relationsTab.click();
        movementManagementPage.pendingTab.click();
        movementManagementPage.stationFilter.setValue(station);
        movementManagementPage.relationsTable.rows.get(0).editRelation.click();
        movementManagementPage.editStationRelationsModal.waitUntilVisible();
        movementManagementPage.editStationRelationsModal.crossdockHub.selectValue(crossdockHub);
        movementManagementPage.editStationRelationsModal.save.click();
        movementManagementPage.editStationRelationsModal.waitUntilInvisible();
    }

    @Then("Operator search for Pending relation on Movement Management page using data below:")
    public void operatorSearchForPendingRelationOnMovementManagementPageUsingDataBelow(Map<String, String> data)
    {
        data = resolveKeyValues(data);
        String station = data.get("station");
        movementManagementPage.relationsTab.click();
        movementManagementPage.pendingTab.click();
        Optional.ofNullable(station).ifPresent(value -> movementManagementPage.stationFilter.setValue(value));
    }

    @Then("Operator verify relations table on Movement Management page using data below:")
    public void operatorVerifyRelationTableOnMovementManagementPageUsingDataBelow(Map<String, String> data)
    {
        data = resolveKeyValues(data);
        Optional.ofNullable(data.get("station"))
                .ifPresent(value -> assertEquals("Station", value, movementManagementPage.relationsTable.rows.get(0).sation.getText()));
        Optional.ofNullable(data.get("crossdockHub"))
                .ifPresent(value -> assertEquals("Crossdock Hub", value, movementManagementPage.relationsTable.rows.get(0).crossdock.getText()));
    }

    @Then("Operator verify relations table on Movement Management page is empty")
    public void operatorVerifyRelationTableOnMovementManagementPageIsEmpty()
    {
        assertEquals("Numbers of row in Relations table", 0, movementManagementPage.relationsTable.rows.size());
    }

    @Then("Operator adds new Station Movement Schedule on Movement Management page using data below:")
    public void operatorAddsNewStationMovementScheduleOnMovementManagementPageUsingDataBelow(Map<String, String> data)
    {
        data = resolveKeyValues(data);
        StationMovementSchedule stationMovementSchedule = new StationMovementSchedule(data);
        movementManagementPage.stationsTab.click();
        movementManagementPage.addSchedule.click();
        movementManagementPage.addStationMovementScheduleModal.waitUntilVisible();
        movementManagementPage.addStationMovementScheduleModal.fill(stationMovementSchedule);
        movementManagementPage.addStationMovementScheduleModal.create.click();
        movementManagementPage.addStationMovementScheduleModal.waitUntilInvisible();
    }

    @And("Operator load schedules on Movement Management page using data below:")
    public void operatorLoadSchedulesOnMovementManagementPageUsingDataBelow(Map<String, String> data)
    {
        data = resolveKeyValues(data);
        String originHub = data.get("originHub");
        String destinationHub = data.get("destinationHub");
        movementManagementPage.loadSchedules(originHub, destinationHub);
    }

    @And("Operator load schedules on Movement Management page")
    public void operatorLoadSchedulesOnMovementManagementPage()
    {
        if (movementManagementPage.editFilters.isDisplayedFast())
        {
            movementManagementPage.editFilters.click();
        }
        movementManagementPage.loadSchedules.click();
        pause5s();
    }

    @Then("Operator verifies a new schedule is created on Movement Management page")
    public void operatorVerifiesANewScheduleIsCreatedOnMovementManagementPage()
    {
        MovementSchedule movementSchedule = get(KEY_CREATED_MOVEMENT_SCHEDULE);
        Assertions.assertEquals(movementSchedule.getSchedules().size(), movementManagementPage.schedulesTable.getRowsCount(), "Number of displayed schedules");
        for (int i = 0; i < movementSchedule.getSchedules().size(); i++)
        {
            MovementSchedule.Schedule actual = movementManagementPage.schedulesTable.readEntity(i + 1);
            movementSchedule.getSchedule(i).compareWithActual(actual);
        }
    }

    @And("Operator opens Add Movement Schedule modal on Movement Management page")
    public void operatorOpensAddMovementScheduleDialogOnMovementManagementPage()
    {
        movementManagementPage.addSchedule.click();
        movementManagementPage.addMovementScheduleModal.waitUntilVisible();
    }

    @And("Operator click {string} button on Add Movement Schedule dialog")
    public void operatorClickButtonOnAddMovementScheduleDialog(String buttonName)
    {
        switch (StringUtils.normalizeSpace(buttonName.toLowerCase()))
        {
            case "save schedule":
                movementManagementPage.addMovementScheduleModal.create.click();
                break;
            case "cancel":
                movementManagementPage.addMovementScheduleModal.cancel.click();
                break;
            default:
                throw new IllegalArgumentException(f("Unknown button name [%s] on 'Add Movement Schedule' dialog", buttonName));
        }
        movementManagementPage.addMovementScheduleModal.waitUntilInvisible();
    }

    @And("Operator fill Add Movement Schedule form using data below:")
    public void operatorFillAddMovementScheduleFormUsingDataBelow(Map<String, String> data)
    {
        data = resolveKeyValues(data);
        data = StandardTestUtils.replaceDataTableTokens(data);
        MovementSchedule movementSchedule = new MovementSchedule();
        movementSchedule.fromMap(data);
        movementManagementPage.addMovementScheduleModal.fill(movementSchedule);
        put(KEY_CREATED_MOVEMENT_SCHEDULE, movementSchedule);
    }

    @Then("Operator verify Add Movement Schedule form is empty")
    public void operatorVerifyAddMovementScheduleFormIsEmpty()
    {
        Assertions.assertNull(movementManagementPage.addMovementScheduleModal.getScheduleForm(1).originHub.getValue(), "Origin Crossdock Hub value");
        Assertions.assertNull(movementManagementPage.addMovementScheduleModal.getScheduleForm(1).destinationHub.getValue(), "Destination Crossdock Hub value");
        Assertions.assertNull(movementManagementPage.addMovementScheduleModal.getScheduleForm(1).movementType.getValue(), "Movement Type value");
        Assertions.assertEquals("", movementManagementPage.addMovementScheduleModal.getScheduleForm(1).comment.getValue(), "Comment value");
    }

    @Then("Operator verifies Add Movement Schedule dialog is closed on Movement Management page")
    public void operatorVerifiesAddMovementScheduleDialogIsClosedOnMovementManagementPage()
    {
        Assertions.assertFalse(movementManagementPage.addMovementScheduleModal.isDisplayed(), "Add Movement Schedule dialog is opened");
    }

    @Then("Operator verify schedules list is empty on Movement Management page")
    public void operatorVerifySchedulesListIsEmptyOnMovementManagementPage()
    {
        Assertions.assertTrue(movementManagementPage.schedulesTable.isEmpty(), "Schedules list is not empty");
    }

    @And("Operator filters schedules list on Movement Management page using data below:")
    public void operatorFiltersSchedulesListOnMovementManagementPageUsingDataBelow(Map<String, String> dataMap)
    {
        Map<String, String> data = resolveKeyValues(dataMap);
        String originHub = data.get("originHub");
        if (StringUtils.isNotBlank(originHub))
        {
            movementManagementPage.schedulesTable.filterByColumn(COLUMN_ORIGIN_HUB, originHub);
        }
        String destinationHub = data.get("destinationHub");
        if (StringUtils.isNotBlank(destinationHub))
        {
            movementManagementPage.schedulesTable.filterByColumn(COLUMN_DESTINATION_HUB, destinationHub);
        }
    }

    @Then("Operator verify schedules list on Movement Management page using data below:")
    public void operatorVerifySchedulesListOnMovementManagementPageUsingDataBelow(Map<String, String> data)
    {
        data = resolveKeyValues(data);
        String originHub = data.get("originHub");
        String destinationHub = data.get("destinationHub");

        int schedulesCount = movementManagementPage.schedulesTable.getRowsCount();
        for (int i = 0; i < schedulesCount; i++)
        {
            if (StringUtils.isNotBlank(originHub))
            {
                String actualOriginHub = movementManagementPage.schedulesTable.getColumnText(i + 1, COLUMN_ORIGIN_HUB);
                Assertions.assertTrue(StringUtils.containsIgnoreCase(originHub, actualOriginHub), f("Row [%d] - Origin Hub name - doesn't contains [%s]", i + 1, originHub));
            }
            if (StringUtils.isNotBlank(destinationHub))
            {
                String actualDestinationHub = movementManagementPage.schedulesTable.getColumnText(i + 1, MovementManagementPage.SchedulesTable.COLUMN_DESTINATION_HUB);
                Assertions.assertTrue(StringUtils.containsIgnoreCase(destinationHub, actualDestinationHub), f("Row [%d] - Destination Hub name - doesn't contains [%s]", i + 1, destinationHub));
            }
        }
    }

    @After("@SwitchToDefaultContent")
    public void closeScheduleDialog()
    {
        getWebDriver().switchTo().defaultContent();
    }

    @When("Operator deletes created movement schedule on Movement Management page")
    public void operatorDeletesCreatedMovementScheduleOnMovementManagementPage()
    {
        MovementSchedule movementSchedule = get(KEY_CREATED_MOVEMENT_SCHEDULE);
        Map<String, String> filters = ImmutableMap.of("originHub", movementSchedule.getSchedule(0).getOriginHub(), "destinationHub", movementSchedule.getSchedule(0).getDestinationHub());
        operatorFiltersSchedulesListOnMovementManagementPageUsingDataBelow(filters);
//        movementManagementPage.schedulesTable.rows.get(0).clickAction("Delete Schedule");
        pause1s();
        movementManagementPage.popoverDeleteButton.click();
        movementManagementPage.waitUntilInvisibilityOfNotification("Movement schedules deleted", true);
    }

    @When("Operator open view modal of a created movement schedule on Movement Management page")
    public void operatorOpenViewDialogOfACreatedMovementScheduleOnMovementManagementPage()
    {
        MovementSchedule movementSchedule = get(KEY_CREATED_MOVEMENT_SCHEDULE);
        Map<String, String> filters = ImmutableMap.of("originHub", movementSchedule.getSchedule(0).getOriginHub(), "destinationHub", movementSchedule.getSchedule(0).getDestinationHub());
        operatorFiltersSchedulesListOnMovementManagementPageUsingDataBelow(filters);
//        movementManagementPage.schedulesTable.rows.get(0).clickAction("View Schedule");
        movementManagementPage.movementScheduleModal.waitUntilVisible();
        pause1s();
    }

    @And("Operator verifies created movement schedule data on Movement Schedule modal on Movement Management page")
    public void operatorVerifiesCreatedMovementScheduleDataOnMovementScheduleModalOnMovementManagementPage()
    {
        MovementSchedule movementSchedule = get(KEY_CREATED_MOVEMENT_SCHEDULE);
        String actualOriginHub = movementManagementPage.movementScheduleModal.originCrossdockHub.getText();
        Assertions.assertEquals(movementSchedule.getSchedule(0).getOriginHub(), actualOriginHub, "Origin Crossdock Hub");

        String actualDestinationHub = movementManagementPage.movementScheduleModal.destinationCrossdockHub.getText();
        Assertions.assertEquals(movementSchedule.getSchedule(0).getDestinationHub(), actualDestinationHub, "Destination Crossdock Hub");

        Assertions.assertTrue(movementManagementPage.movementScheduleModal.editSchedule.isEnabled(), "Edit Schedule button is disabled");
    }
}
