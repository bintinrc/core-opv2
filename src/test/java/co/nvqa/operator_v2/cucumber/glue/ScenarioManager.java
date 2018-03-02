package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common_selenium.cucumber.glue.CommonSeleniumScenarioManager;
import co.nvqa.common_selenium.util.SeleniumUtils;
import co.nvqa.commons.cucumber.glue.StandardApiOperatorPortalSteps;
import co.nvqa.commons.utils.NvLogger;
import co.nvqa.operator_v2.selenium.page.LoginPage;
import co.nvqa.operator_v2.selenium.page.MainPage;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.inject.Singleton;
import cucumber.api.Scenario;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

import java.util.Collection;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@Singleton
public class ScenarioManager extends CommonSeleniumScenarioManager
{
    public ScenarioManager()
    {
    }

    /**
     * Inject object Scenario each time the scenario is running.
     *
     * @param scenario
     */
    @Before
    public void before(Scenario scenario)
    {
        setCurrentScenario(scenario);
    }

    @Before("@LaunchBrowser")
    public void launchBrowser(Scenario scenario)
    {
        Collection<String> sourceTagNames = scenario.getSourceTagNames();
        boolean enableProxy = sourceTagNames.contains("@EnableProxy");
        boolean enableClearCache = sourceTagNames.contains("@EnableClearCache");
        NvLogger.infof("Launching browser.");
        setWebDriver(SeleniumUtils.createWebDriver(enableProxy, enableClearCache));
    }

    @Before("@LaunchBrowserWithProxyEnabled")
    public void launchBrowserWithProxyEnabled()
    {
        NvLogger.infof("Launching browser.");
        setWebDriver(SeleniumUtils.createWebDriver(true));
    }

    @After("@KillBrowser")
    public void killBrowser()
    {
        NvLogger.infof("Kill browser.");
        SeleniumUtils.closeWebDriver(getWebDriver());
    }

    /**
     * Save screenshot and print "browser console log" if scenario failed.
     * You can find screenshot image at './build/report/cucumber-junit/htmloutput/index.html'.
     *
     * @param scenario
     */
    @After
    @Override
    public void teardown(Scenario scenario)
    {
        super.teardown(scenario);
    }

    @Given("^op login into Operator V2 with username \"([^\"]*)\" and password \"([^\"]*)\"$")
    public void loginToOperatorV2(String username, String password)
    {
        LoginPage loginPage = new LoginPage(getWebDriver());
        loginPage.loadPage();

        if(TestConstants.OPERATOR_PORTAL_FORCE_LOGIN_BY_INJECTING_COOKIES)
        {
            String operatorAccessToken = new StandardApiOperatorPortalSteps<ScenarioManager>(null, null)
            {
                @Override
                public void init()
                {
                }
            }.getOperatorAccessToken();

            loginPage.forceLogin(operatorAccessToken);
        }
        else
        {
            loginPage.clickLoginButton();
            loginPage.enterCredential(username, password);
            //loginPage.checkForGoogleSimpleVerification("Singapore");
        }

        MainPage mainPage = new MainPage(getWebDriver());
        mainPage.verifyTheMainPageIsLoaded();
    }

    @Then("^take screenshot$")
    public void takeScreenShot()
    {
        takesScreenshot();
    }

    @Then("^take screenshot with delay (\\d+)s$")
    public void takeScreenShotWithDelayInSecond(int delayInSecond)
    {
        TestUtils.pause(delayInSecond*1000);
        takesScreenshot();
    }

    @Then("take screenshot with delay (\\d+)ms$")
    public void takeScreenShotWithDelayInMillisecond(int delayInMillisecond)
    {
        TestUtils.pause(delayInMillisecond);
        takesScreenshot();
    }

    @When("browser open \"([^\"]*)\"")
    public void browserOpen(String url)
    {
        getWebDriver().get(url);
    }

    @Then("print browser console log")
    public void printBrowserConsoleLog()
    {
        printBrowserConsoleLog(getWebDriver(), getCurrentScenario());
    }
}
