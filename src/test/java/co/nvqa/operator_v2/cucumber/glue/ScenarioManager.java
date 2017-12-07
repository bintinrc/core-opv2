package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.LoginPage;
import co.nvqa.operator_v2.selenium.page.MainPage;
import co.nvqa.operator_v2.util.SeleniumUtils;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.inject.Singleton;
import com.nv.qa.commons.cucumber.glue.StandardApiOperatorPortalSteps;
import com.nv.qa.commons.utils.NvLogger;
import com.nv.qa.commons.utils.StandardScenarioManager;
import cucumber.api.Scenario;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.logging.LogEntries;
import org.openqa.selenium.logging.LogEntry;
import org.openqa.selenium.logging.LogType;

import java.util.Date;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@Singleton
public class ScenarioManager extends StandardScenarioManager
{
    private WebDriver webDriver;

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
    public void launchBrowser()
    {
        NvLogger.infof("Launching browser.");
        webDriver = SeleniumUtils.createWebDriver();
    }

    @Before("@LaunchBrowserWithProxyEnabled")
    public void launchBrowserWithProxyEnabled()
    {
        NvLogger.infof("Launching browser.");
        webDriver = SeleniumUtils.createWebDriver(true);
    }

    @After("@KillBrowser")
    public void killBrowser()
    {
        NvLogger.infof("Kill browser.");
        SeleniumUtils.closeWebDriver(webDriver);
    }

    /**
     * Save screenshot and print "browser console log" if scenario failed.
     * You can find screenshot image at './build/report/cucumber-junit/htmloutput/index.html'.
     *
     * @param scenario
     */
    @After
    public void teardown(Scenario scenario)
    {
        if(scenario.isFailed())
        {
            if(getWebDriver()!=null)
            {
                takesScreenshot(getWebDriver(), scenario);
                printBrowserConsoleLog(getWebDriver(), scenario);
                printLastHtmlOrXmlPageSourceToFile(scenario, getWebDriver().getPageSource(), "HTML");
            }
            else
            {
                NvLogger.warnf("WebDriver not run.");
            }
        }
    }

    @Given("^op login into Operator V2 with username \"([^\"]*)\" and password \"([^\"]*)\"$")
    public void loginToOperatorV2(String username, String password)
    {
        String operatorAccessToken = new StandardApiOperatorPortalSteps<ScenarioManager>(null, null)
        {
            @Override
            public void init()
            {
            }
        }.getOperatorAccessToken();

        LoginPage loginPage = new LoginPage(getWebDriver());
        loginPage.get();

        if(TestConstants.OPERATOR_PORTAL_FORCE_LOGIN_BY_INJECTING_COOKIES)
        {
            loginPage.forceLogin(operatorAccessToken);
        }
        else
        {
            loginPage.clickLoginButton();
            loginPage.enterCredential(username, password);
            //loginPage.checkForGoogleSimpleVerification("Singapore");
        }

        MainPage mainPage = new MainPage(getWebDriver());
        mainPage.dpAdm();
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

    public void takesScreenshot()
    {
        takesScreenshot(getWebDriver(), getCurrentScenario());
    }

    private void takesScreenshot(WebDriver currentDriver, Scenario currentScenario)
    {
        final byte[] screenshot = ((TakesScreenshot) currentDriver).getScreenshotAs(OutputType.BYTES);
        currentScenario.embed(screenshot, "image/png");
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

    private void printBrowserConsoleLog(WebDriver currentDriver, Scenario currentScenario)
    {
        try
        {
            LogEntries logEntries = currentDriver.manage().logs().get(LogType.BROWSER);

            for(LogEntry entry : logEntries)
            {
                currentScenario.write(new Date(entry.getTimestamp())+" [" + entry.getLevel() + "] "+entry.getMessage());
            }
        }
        catch(Exception ex)
        {
            NvLogger.warnf("Failed print browser log. Cause: %s", ex.getMessage());
        }
    }

    public WebDriver getWebDriver()
    {
        return webDriver;
    }
}
