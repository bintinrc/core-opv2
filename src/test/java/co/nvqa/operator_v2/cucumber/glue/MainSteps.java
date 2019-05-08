package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.MainPage;
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

    public MainSteps()
    {
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

    @Given("^Operator go to this URL \"([^\"]*)\"$")
    public void operatorGoToThisUrl(String url)
    {
        mainPage.goToUrl(url);
    }

    @Then("^Operator verify he is in main page$")
    public void operatorVerifyHeIsInMainPage()
    {
        mainPage.verifyTheMainPageIsLoaded();
    }

    @Given("^Operator refresh page v1$")
    public void operatorRefreshPage_v1()
    {
        mainPage.refreshPage_v1();
    }

    @Given("^Operator refresh page$")
    public void operatorRefreshPage()
    {
        mainPage.refreshPage();
    }
}
