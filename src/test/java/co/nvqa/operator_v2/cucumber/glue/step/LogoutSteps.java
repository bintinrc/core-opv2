package co.nvqa.operator_v2.cucumber.glue.step;

import com.google.inject.Inject;
import co.nvqa.operator_v2.selenium.page.LogoutPage;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class LogoutSteps extends AbstractSteps
{
    private LogoutPage logoutPage;

    @Inject
    public LogoutSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        logoutPage = new LogoutPage(getDriver());
    }

    @When("^logout button is clicked$")
    public void logout()
    {
        logoutPage.logout();
    }
}
