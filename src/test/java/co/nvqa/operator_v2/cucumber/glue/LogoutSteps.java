package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.LogoutPage;
import com.google.inject.Inject;
import com.nv.qa.commons.utils.StandardScenarioStorage;
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
    public LogoutSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        logoutPage = new LogoutPage(getWebDriver());
    }

    @When("^logout button is clicked$")
    public void logout()
    {
        logoutPage.logout();
    }
}
