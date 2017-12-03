package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.MainPage;
import com.google.inject.Inject;
import com.nv.qa.commons.utils.StandardScenarioStorage;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class MainSteps extends AbstractSteps
{
    private MainPage mainPage;

    @Inject
    public MainSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        mainPage = new MainPage(getWebDriver());
    }

    @Given("^op click navigation ([^\"]*) in ([^\"]*)$")
    public void opClickNavigation(String childMenuName, String parentMenuName)
    {
        mainPage.clickNavigation(parentMenuName, childMenuName);
        pause1s();
    }

    @Given("^Operator go to menu \"([^\"]*)\" -> \"([^\"]*)\"$")
    public void operatorGoToMenu(String parentMenuName, String childMenuName)
    {
        opClickNavigation(childMenuName, parentMenuName);
    }

    @Given("^Operator go to menu ([^\"]*) -> ([^\"]*)$")
    public void operatorGoToMenuWithoutQuote(String parentMenuName, String childMenuName)
    {
        opClickNavigation(childMenuName, parentMenuName);
    }

    @Then("^op is in main page$")
    public void opIsInMainPage()
    {
        mainPage.dpAdm();
    }

    @Given("^op refresh page$")
    public void opRefreshPage()
    {
        mainPage.refreshPage();
    }

    @Given("^Operator refresh page$")
    public void operatorRefreshPage()
    {
        opRefreshPage();
    }
}
