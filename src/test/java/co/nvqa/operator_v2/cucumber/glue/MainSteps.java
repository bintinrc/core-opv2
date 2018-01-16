package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.MainPage;
import com.google.inject.Inject;
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

    @Given("^Operator go to menu \"([^\"]*)\" -> \"([^\"]*)\"$")
    public void operatorGoToMenu(String parentMenuName, String childMenuName)
    {
        mainPage.clickNavigation(parentMenuName, childMenuName);
    }

    @Given("^Operator go to menu ([^\"]*) -> ([^\"]*)$")
    public void operatorGoToMenuWithoutQuote(String parentMenuName, String childMenuName)
    {
        operatorGoToMenu(parentMenuName, childMenuName);
    }

    @Then("^Operator verify he is in main page$")
    public void operatorVerifyHeIsInMainPage()
    {
        mainPage.verifyTheMainPageIsLoaded();
    }

    @Given("^Operator refresh page$")
    public void operatorRefreshPage()
    {
        mainPage.refreshPage();
    }
}
