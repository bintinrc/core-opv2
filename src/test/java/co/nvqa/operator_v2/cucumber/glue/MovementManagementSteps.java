package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.MovementSchedule;
import co.nvqa.operator_v2.selenium.page.MovementManagementPage;
import co.nvqa.operator_v2.util.TestUtils;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.collections4.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.junit.Assert;

import java.util.Arrays;
import java.util.Map;

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
            movementManagementPage.addMovementScheduleDialog.originCrossdockHub.selectValue(hubName);
        } catch (Throwable ex)
        {
            Assert.fail(f("Cannot select [%s] value in Origin Crossdock Hub field on the New Crossdock Movement Schedule dialog", hubName));
        }
    }

    @Then("Operator can not select {string} destination crossdock hub on Add Movement Schedule dialog")
    public void operatorCannotSelectDestinationCrossdockHub(String hubName)
    {
        hubName = resolveValue(hubName);
        try
        {
            movementManagementPage.addMovementScheduleDialog.destinationCrossdockHub.selectValue(hubName);
            Assert.fail(f("Operator can select [%s] value in Destination Crossdock Hub field on the New Crossdock Movement Schedule dialog, but must not", hubName));
        } catch (Throwable ex)
        {
            // Step passed. Do nothing
        }
    }

    @When("Movement Management page is loaded")
    public void movementManagementPageIsLoaded()
    {
        movementManagementPage.switchTo();
        movementManagementPage.newCrossdockMovementSchedule.waitUntilClickable(60);
    }

    @Then("Operator adds new Movement Schedule on Movement Management page using data below:")
    public void operatorAddsNewMovementScheduleOnMovementManagementPageUsingDataBelow(Map<String, String> data)
    {
        operatorOpensAddMovementScheduleDialogOnMovementManagementPage();
        operatorFillAddMovementScheduleFormUsingDataBelow(data);
        operatorClickButtonOnAddMovementScheduleDialog("Save Schedule");
    }

    private void addMovementScheduleData(MovementSchedule movementSchedule, Map<String, String> data, String day)
    {
        MovementSchedule.Schedule schedule = new MovementSchedule.Schedule();
        schedule.fromMap(data);
        schedule.setDay(day);
        movementSchedule.addSchedule(schedule);
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
        Assert.assertEquals("Number of displayed schedules", 1, movementManagementPage.schedulesTable.rows.size());
        Assert.assertEquals("Origin Crossdock Hub", movementSchedule.getOriginHub(), movementManagementPage.schedulesTable.rows.get(0).originHubName.getText());
        Assert.assertEquals("Destination Crossdock Hub", movementSchedule.getDestinationHub(), movementManagementPage.schedulesTable.rows.get(0).destinationHubName.getText());
    }

    @And("Operator opens Add Movement Schedule dialog on Movement Management page")
    public void operatorOpensAddMovementScheduleDialogOnMovementManagementPage()
    {
        movementManagementPage.newCrossdockMovementSchedule.click();
        movementManagementPage.addMovementScheduleDialog.waitUntilVisible();
    }

    @And("Operator click {string} button on Add Movement Schedule dialog")
    public void operatorClickButtonOnAddMovementScheduleDialog(String buttonName)
    {
        switch (StringUtils.normalizeSpace(buttonName.toLowerCase()))
        {
            case "save schedule":
                movementManagementPage.addMovementScheduleDialog.saveSchedule.click();
                break;
            case "cancel":
                movementManagementPage.addMovementScheduleDialog.cancel.click();
                break;
            default:
                throw new IllegalArgumentException(f("Unknown button name [%s] on 'Add Movement Schedule' dialog", buttonName));
        }
    }

    @And("Operator fill Add Movement Schedule form using data below:")
    public void operatorFillAddMovementScheduleFormUsingDataBelow(Map<String, String> data)
    {
        data = resolveKeyValues(data);
        MovementSchedule movementSchedule = new MovementSchedule();
        movementSchedule.setOriginHub(data.get("originHub"));
        movementSchedule.setDestinationHub(data.get("destinationHub"));
        movementSchedule.setApplyToAllDays(Boolean.parseBoolean(data.get("applyToAllDays")));
        if (movementSchedule.isApplyToAllDays())
        {
            addMovementScheduleData(movementSchedule, data, "Monday-Sunday");
        } else
        {
            Map<String, String> finalData = data;
            Arrays.stream(new String[]{"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"})
                    .forEach(day ->
                    {
                        Map<String, String> dayData = TestUtils.extractSubMap(day, finalData);
                        if (MapUtils.isNotEmpty(dayData))
                        {
                            addMovementScheduleData(movementSchedule, dayData, day);
                        }
                    });
        }
        movementManagementPage.addMovementScheduleDialog.fill(movementSchedule);
        put(KEY_CREATED_MOVEMENT_SCHEDULE, movementSchedule);
    }

    @Then("Operator verify Add Movement Schedule form is empty")
    public void operatorVerifyAddMovementScheduleFormIsEmpty()
    {
        Assert.assertNull("Origin Crossdock Hub value", movementManagementPage.addMovementScheduleDialog.originCrossdockHub.getValue());
        Assert.assertNull("Destination Crossdock Hub value", movementManagementPage.addMovementScheduleDialog.destinationCrossdockHub.getValue());
        Assert.assertFalse("Apply to all days value", movementManagementPage.addMovementScheduleDialog.applyToAllDays.isChecked());
    }

    @Then("Operator verifies Add Movement Schedule dialog is closed on Movement Management page")
    public void operatorVerifiesAddMovementScheduleDialogIsClosedOnMovementManagementPage()
    {
        Assert.assertFalse("Add Movement Schedule dialog is opened", movementManagementPage.addMovementScheduleDialog.isDisplayed());
    }

    @Then("Operator verify schedules list is empty on Movement Management page")
    public void operatorVerifySchedulesListIsEmptyOnMovementManagementPage()
    {
        Assert.assertTrue("Schedules list is not empty", movementManagementPage.schedulesTable.rows.isEmpty());
    }

    @And("Operator filters schedules list on Movement Management page using data below:")
    public void operatorFiltersSchedulesListOnMovementManagementPageUsingDataBelow(Map<String, String> data)
    {
        data = resolveKeyValues(data);
        String originHub = data.get("originHub");
        if (StringUtils.isNotBlank(originHub))
        {
            movementManagementPage.originCrossdockHubFilter.setValue(originHub);
        }
        String destinationHub = data.get("destinationHub");
        if (StringUtils.isNotBlank(destinationHub))
        {
            movementManagementPage.destinationCrossdockHubFilter.setValue(destinationHub);
        }
    }

    @Then("Operator verify schedules list on Movement Management page using data below:")
    public void operatorVerifySchedulesListOnMovementManagementPageUsingDataBelow(Map<String, String> data)
    {
        data = resolveKeyValues(data);
        String originHub = data.get("originHub");
        String destinationHub = data.get("destinationHub");

        int schedulesCount = movementManagementPage.schedulesTable.rows.size();
        for (int i = 0; i < schedulesCount; i++)
        {
            if (StringUtils.isNotBlank(originHub))
            {
                String actualOriginHub = movementManagementPage.schedulesTable.rows.get(i).originHubName.getText();
                Assert.assertTrue(f("Row [%d] - Origin Hub name - doesn't contains [%s]", i+1, originHub), StringUtils.containsIgnoreCase(originHub, actualOriginHub));
            }

            if (StringUtils.isNotBlank(destinationHub))
            {
                String actualDestinationHub = movementManagementPage.schedulesTable.rows.get(i).destinationHubName.getText();
                Assert.assertTrue(f("Row [%d] - Destination Hub name - doesn't contains [%s]", i+1, destinationHub), StringUtils.containsIgnoreCase(destinationHub, actualDestinationHub));
            }
        }
    }
}
