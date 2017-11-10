package co.nvqa.operator_v2.cucumber.glue.step;

import com.google.inject.Inject;
import co.nvqa.operator_v2.selenium.page.MainPage;
import co.nvqa.operator_v2.support.CommonUtil;
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
    public MainSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        mainPage = new MainPage(getDriver());
    }

    @Given("^op click navigation ([^\"]*) in ([^\"]*)$")
    public void clickNavigation(String navTitle, String parentTitle)
    {
        mainPage.clickNavigation(parentTitle, navTitle);
        CommonUtil.pause1s();
    }

    @Then("^op is in main page$")
    public void dpAdm()
    {
        mainPage.dpAdm();
    }

    @Given("^op refresh page$")
    public void refreshPage()
    {
        mainPage.refreshPage();
    }
}
