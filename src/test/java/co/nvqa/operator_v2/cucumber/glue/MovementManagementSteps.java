package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.MovementManagementPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;

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

        movementManagementPage.newCrossdockMovementSchedule.click();
        try
        {
            movementManagementPage.addMovementScheduleDialog.waitUntilVisible();
            movementManagementPage.addMovementScheduleDialog.originCrossdockHub.selectValue(hubName);
        } catch (Throwable ex)
        {
            ex.printStackTrace();
            Assert.fail(f("Cannot select [%s] value in Origin Crossdock Hub field on the New Crossdock Movement Schedule dialog", hubName));
        }
    }

    @When("Movement Management page is loaded")
    public void movementManagementPageIsLoaded()
    {
        movementManagementPage.switchTo();
        movementManagementPage.newCrossdockMovementSchedule.waitUntilClickable(60);
    }
}
