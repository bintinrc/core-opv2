package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.util.NvLogger;
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
import org.apache.commons.lang3.StringUtils;
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
        retryIfRuntimeExceptionOccurred(() ->
        {
            try {
                final String finalHubName = resolveValue(hubName);
                movementManagementPage.addMovementScheduleModal.getScheduleForm(1).originHub.selectValue(finalHubName);
            } catch (Throwable ex) {
                NvLogger.error(ex.getMessage());
                NvLogger.info(f("Cannot select [%s] value in Origin Crossdock Hub field on the New Crossdock Movement Schedule dialog", hubName));
                navigateRefresh();
                pause2s();
                movementManagementPage.switchTo();
                movementManagementPage.addSchedule.waitUntilClickable(60);
                movementManagementPage.addSchedule.click();
                movementManagementPage.addMovementScheduleModal.waitUntilVisible();
                throw ex;
            }
        }, 10);
//        hubName = resolveValue(hubName);
//        try
//        {
//            movementManagementPage.addMovementScheduleModal.getScheduleForm(1).originHub.selectValue(hubName);
//        } catch (Throwable ex)
//        {
//            fail(f("Cannot select [%s] value in Origin Crossdock Hub field on the New Crossdock Movement Schedule dialog", hubName));
//        }
    }

    @Then("Operator can not select {string} destination crossdock hub on Add Movement Schedule dialog")
    public void operatorCannotSelectDestinationCrossdockHub(String hubName)
    {
        hubName = resolveValue(hubName);
        try
        {
            movementManagementPage.addMovementScheduleModal.getScheduleForm(1).destinationHub.selectValue(hubName);
            fail(f("Operator can select [%s] value in Destination Crossdock Hub field on the New Crossdock Movement Schedule dialog, but must not", hubName));
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
    }

    @Then("Operator adds new Movement Schedule on Movement Management page using data below:")
    public void operatorAddsNewMovementScheduleOnMovementManagementPageUsingDataBelow(Map<String, String> data)
    {
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
                pause2s();
                movementManagementPage.switchTo();
                movementManagementPage.addSchedule.waitUntilClickable(60);
                throw ex;
            }
        }, 10);
    }

    @And("Operator assign driver {string} to created movement schedule")
    public void operatorAssignDriverToCreatedMovementScheduleWithData(String driverUsername)
    {
        driverUsername = resolveValue(driverUsername);
        movementManagementPage.assignDriver(driverUsername);
    }

    @Then("Operator edits Crossdock Movement Schedule on Movement Management page using data below:")
    public void operatorEditsCrossdockMovementScheduleOnMovementManagementPageUsingDataBelow(Map<String, String> mapOfData)
    {
        MovementSchedule movementSchedule = get(KEY_CREATED_MOVEMENT_SCHEDULE);
        Map<String, String> data = resolveKeyValues(mapOfData);
        data = StandardTestUtils.replaceDataTableTokens(data);
        movementSchedule.fromMap(data);

        movementManagementPage.modify.click();
        movementManagementPage.schedulesTable.filterByColumn(COLUMN_ORIGIN_HUB, movementSchedule.getSchedule(0).getOriginHub());
        movementManagementPage.schedulesTable.filterByColumn(COLUMN_DESTINATION_HUB, movementSchedule.getSchedule(0).getDestinationHub());
        movementManagementPage.schedulesTable.editSchedule(movementSchedule.getSchedule(0));
        movementManagementPage.save.click();
        movementManagementPage.updateSchedulesConfirmationModal.update.click();
        pause3s();
    }

    @Then("Operator adds new relation on Movement Management page using data below:")
    public void operatorAddsNewRelationOnMovementManagementPageUsingDataBelow(Map<String, String> data)
    {
        data = resolveKeyValues(data);
        String station = data.get("station");
        String crossdockHub = data.get("crossdockHub");
        operatorSelectTabOnMovementManagementPage("Relations");
        operatorSelectTabOnMovementManagementPage("Pending");
        movementManagementPage.stationFilter.forceClear();
        movementManagementPage.stationFilter.setValue(station);
        movementManagementPage.relationsTable.rows.get(0).editRelations.click();
        movementManagementPage.editStationRelationsModal.waitUntilVisible();
        retryIfRuntimeExceptionOccurred(() ->
                        movementManagementPage.editStationRelationsModal.crossdockHub.selectValue(crossdockHub),
                2
        );
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
        String crossdockHub = data.get("crossdockHub");
        String originHub = data.get("originHub");
        String destinationHub = data.get("destinationHub");
        movementManagementPage.loadSchedules(crossdockHub, originHub, destinationHub);
    }

    @And("Operator load schedules on Movement Management page with retry using data below:")
    public void operatorLoadSchedulesOnMovementManagementPageWithRetryUsingDataBelow(Map<String, String> inputData)
    {
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
                navigateRefresh();
                pause2s();
                throw ex;
            }
        }, 10);
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
    @And("Operator verifies Crossdock Movement Schedule parameters on Movement Management page")
    public void operatorVerifiesANewScheduleIsCreatedOnMovementManagementPage()
    {
        MovementSchedule movementSchedule = get(KEY_CREATED_MOVEMENT_SCHEDULE);
        assertEquals("Number of displayed schedules", movementSchedule.getSchedules().size(), movementManagementPage.schedulesTable.getRowsCount());
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
            case "create":
                movementManagementPage.addMovementScheduleModal.create.click();
                break;
            case "cancel":
                movementManagementPage.addMovementScheduleModal.cancel.click();
                movementManagementPage.addMovementScheduleModal.waitUntilInvisible();
                break;
            default:
                throw new IllegalArgumentException(f("Unknown button name [%s] on 'Add Movement Schedule' dialog", buttonName));
        }
    }

    @And("Operator fill Add Movement Schedule form using data below:")
    public void operatorFillAddMovementScheduleFormUsingDataBelow(Map<String, String> data)
    {
        retryIfRuntimeExceptionOccurred(() ->
        {
            try {
                final Map<String, String> finalData = StandardTestUtils.replaceDataTableTokens(resolveKeyValues(data));
                MovementSchedule movementSchedule = new MovementSchedule();
                movementSchedule.fromMap(finalData);
                movementManagementPage.addMovementScheduleModal.fill(movementSchedule);

                MovementSchedule existed = get(KEY_CREATED_MOVEMENT_SCHEDULE);
                if (existed == null)
                {
                    put(KEY_CREATED_MOVEMENT_SCHEDULE, movementSchedule);
                } else
                {
                    existed.getSchedules().addAll(movementSchedule.getSchedules());
                }
            } catch (Throwable ex) {
                NvLogger.error(ex.getMessage());
                NvLogger.info("Searched element is not found, retrying after 2 seconds...");
                navigateRefresh();
                pause2s();
                movementManagementPage.switchTo();
                movementManagementPage.addSchedule.waitUntilClickable(60);
                movementManagementPage.addSchedule.click();
                movementManagementPage.addMovementScheduleModal.waitUntilVisible();
                throw ex;
            }
        }, 10);

//        data = resolveKeyValues(data);
//        data = StandardTestUtils.replaceDataTableTokens(data);
//        MovementSchedule movementSchedule = new MovementSchedule();
//        movementSchedule.fromMap(data);
//        movementManagementPage.addMovementScheduleModal.fill(movementSchedule);
//
//        MovementSchedule existed = get(KEY_CREATED_MOVEMENT_SCHEDULE);
//        if (existed == null)
//        {
//            put(KEY_CREATED_MOVEMENT_SCHEDULE, movementSchedule);
//        } else
//        {
//            existed.getSchedules().addAll(movementSchedule.getSchedules());
//        }
    }

    @Then("Operator verify Add Movement Schedule form is empty")
    public void operatorVerifyAddMovementScheduleFormIsEmpty()
    {
        assertNull("Origin Crossdock Hub value", movementManagementPage.addMovementScheduleModal.getScheduleForm(1).originHub.getValue());
        assertNull("Destination Crossdock Hub value", movementManagementPage.addMovementScheduleModal.getScheduleForm(1).destinationHub.getValue());
        assertNull("Movement Type value", movementManagementPage.addMovementScheduleModal.getScheduleForm(1).movementType.getValue());
        assertEquals("Comment value", "", movementManagementPage.addMovementScheduleModal.getScheduleForm(1).comment.getValue());
    }

    @Then("Operator verifies Add Movement Schedule dialog is closed on Movement Management page")
    public void operatorVerifiesAddMovementScheduleDialogIsClosedOnMovementManagementPage()
    {
        assertFalse("Add Movement Schedule dialog is opened", movementManagementPage.addMovementScheduleModal.isDisplayed());
    }

    @Then("Operator verify schedules list is empty on Movement Management page")
    public void operatorVerifySchedulesListIsEmptyOnMovementManagementPage()
    {
        assertTrue("Schedules list is not empty", movementManagementPage.schedulesTable.isEmpty());
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
                assertTrue(f("Row [%d] - Origin Hub name - doesn't contains [%s]", i + 1, originHub), StringUtils.containsIgnoreCase(originHub, actualOriginHub));
            }
            if (StringUtils.isNotBlank(destinationHub))
            {
                String actualDestinationHub = movementManagementPage.schedulesTable.getColumnText(i + 1, MovementManagementPage.SchedulesTable.COLUMN_DESTINATION_HUB);
                assertTrue(f("Row [%d] - Destination Hub name - doesn't contains [%s]", i + 1, destinationHub), StringUtils.containsIgnoreCase(destinationHub, actualDestinationHub));
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
        //TODO Rework this according new scenarios
//        movementManagementPage.schedulesTable.rows.get(0).clickAction("Delete Schedule");
        pause1s();
        movementManagementPage.popoverDeleteButton.click();
        movementManagementPage.waitUntilInvisibilityOfNotification("Movement schedules deleted", true);
    }

    @Deprecated
    @When("Operator open view modal of a created movement schedule on Movement Management page")
    public void operatorOpenViewDialogOfACreatedMovementScheduleOnMovementManagementPage()
    {
        MovementSchedule movementSchedule = get(KEY_CREATED_MOVEMENT_SCHEDULE);
        Map<String, String> filters = ImmutableMap.of("originHub", movementSchedule.getSchedule(0).getOriginHub(), "destinationHub", movementSchedule.getSchedule(0).getDestinationHub());
        operatorFiltersSchedulesListOnMovementManagementPageUsingDataBelow(filters);
        //TODO Rework this according new scenarios
//        movementManagementPage.schedulesTable.rows.get(0).clickAction("View Schedule");
        movementManagementPage.movementScheduleModal.waitUntilVisible();
        pause1s();
    }

    @And("Operator verifies created movement schedule data on Movement Schedule modal on Movement Management page")
    public void operatorVerifiesCreatedMovementScheduleDataOnMovementScheduleModalOnMovementManagementPage()
    {
        MovementSchedule movementSchedule = get(KEY_CREATED_MOVEMENT_SCHEDULE);
        String actualOriginHub = movementManagementPage.movementScheduleModal.originCrossdockHub.getText();
        assertEquals("Origin Crossdock Hub", movementSchedule.getSchedule(0).getOriginHub(), actualOriginHub);

        String actualDestinationHub = movementManagementPage.movementScheduleModal.destinationCrossdockHub.getText();
        assertEquals("Destination Crossdock Hub", movementSchedule.getSchedule(0).getDestinationHub(), actualDestinationHub);

        assertTrue("Edit Schedule button is disabled", movementManagementPage.movementScheduleModal.editSchedule.isEnabled());
    }

    @When("Operator select \"(.+)\" tab on Movement Management page")
    public void operatorSelectTabOnMovementManagementPage(String tabName)
    {
        switch (StringUtils.normalizeSpace(tabName.toLowerCase()))
        {
            case "crossdock hubs":
                movementManagementPage.crossdockHubsTab.click();
                break;
            case "stations":
                movementManagementPage.stationsTab.click();
                break;
            case "relations":
                movementManagementPage.relationsTab.click();
                pause1s();
                movementManagementPage.waitUntil(() -> !StringUtils.contains(movementManagementPage.allTab.getText(), "(0)"), 10000);
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
    public void operatorVerifyTabsAreDisplayedOnRelationsTab()
    {
        assertTrue("All tab is displayed", movementManagementPage.allTab.isDisplayedFast());
        assertTrue("Pending tab is displayed", movementManagementPage.pendingTab.isDisplayedFast());
        assertTrue("Completed tab is displayed", movementManagementPage.completedTab.isDisplayedFast());
    }

    @When("Operator verify \"(.+)\" tab is selected on 'Relations' tab")
    public void operatorVerifyTabIsSelectedOnRelationsTab(String tabName)
    {
        PageElement tabElement = null;
        switch (StringUtils.normalizeSpace(tabName.toLowerCase()))
        {
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
        assertTrue(f("%s tab is selected", tabName), tabElement.hasClass("ant-radio-button-wrapper-checked"));
    }

    @When("Operator verify all Crossdock Hub in Pending tab have \"(.+)\" value")
    public void operatorVerifyCrossdockHubInPendingTabOnRelationsTab(String expectedValue)
    {
        assertTrue(f("All Crossdock Hub in Pending tab have '%s' value", expectedValue),
                movementManagementPage.relationsTable.rows.stream().map(row -> row.crossdock.getText()).allMatch(expectedValue::equals));
    }

    @When("Operator verify all Crossdock Hub of all listed Stations already defined")
    public void operatorVerifyCrossdockHubAlreadyDefinedOnRelationsTab()
    {
        assertTrue("all Crossdock Hub of all listed Stations already defined",
                movementManagementPage.relationsTable.rows.stream().map(row -> row.crossdock.getText()).noneMatch("Unfilled"::equals));
    }

    @When("Operator verify there is 'Edit Relation' link in Relations table on 'Relations' tab")
    public void operatorVerifyEditRelationLinkOnRelationsTab()
    {
        assertTrue("there is hyperlink for 'Edit Relations' on the right side",
                movementManagementPage.relationsTable.rows.stream().map(row -> row.editRelations.getText()).allMatch("Edit Relations"::equals));
    }

    @When("Operator verify {string} error Message is displayed in Add Crossdock Movement Schedule dialog")
    public void operatorVerifyErrorMessageInAddCrossdockMovementScheduleDialog(String expectedMessage)
    {
        assertTrue("Error message is not displayed", movementManagementPage.addMovementScheduleModal.errorMessage.isDisplayedFast());
        assertEquals("Error message text", expectedMessage, movementManagementPage.addMovementScheduleModal.errorMessage.getText());
    }
}
