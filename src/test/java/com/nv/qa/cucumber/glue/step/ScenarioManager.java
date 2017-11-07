package com.nv.qa.cucumber.glue.step;

import com.google.inject.Singleton;
import com.nv.qa.model.operator_portal.authentication.AuthResponse;
import com.nv.qa.selenium.page.LoginPage;
import com.nv.qa.selenium.page.MainPage;
import com.nv.qa.support.TestConstants;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.ScenarioStorage;
import com.nv.qa.support.SeleniumSharedDriver;
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

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@Singleton
public class ScenarioManager
{
    private static final SimpleDateFormat HTML_PAGE_SOURCE_DATE_SUFFIX_SDF = new SimpleDateFormat("dd-MMM-yyyy_hh-mm-ss");

    private WebDriver driver;
    private Scenario scenario;
    private ScenarioStorage scenarioStorage;

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
        this.scenario = scenario;
    }

    @Before("@LaunchBrowser")
    public void launchBrowser()
    {
        System.out.println("Launching browser.");
        driver = SeleniumSharedDriver.getInstance().getDriver();
    }

    @After("@KillBrowser")
    public void killBrowser()
    {
        System.out.println("Kill browser.");
        SeleniumSharedDriver.getInstance().closeDriver();
        driver = null;
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
            WebDriver currentDriver = SeleniumSharedDriver.getInstance().getDriver(false); // Don't use getDriver() because some feature files does not use ScenarioManager.

            if(currentDriver!=null)
            {
                takesScreenshot(currentDriver, scenario);
                printBrowserConsoleLog(currentDriver, scenario);
                printLastPageHtmlSourceToFile(currentDriver, scenario);
            }
            else
            {
                System.out.println("[WARN] WebDriver not run.");
            }
        }
    }

    @Given("^op login into Operator V2 with username \"([^\"]*)\" and password \"([^\"]*)\"$")
    public void loginToOperatorV2(String username, String password) throws InterruptedException, IOException
    {
        AuthResponse operatorAuthResponse = new AbstractSteps(null, null)
        {
            @Override
            public void init()
            {
            }
        }.operatorLogin();

        LoginPage loginPage = new LoginPage(getDriver());
        loginPage.get();

        if(TestConstants.OPERATOR_PORTAL_FORCE_LOGIN_BY_INJECTING_COOKIES)
        {
            loginPage.forceLogin(operatorAuthResponse.getAccessToken());
        }
        else
        {
            loginPage.clickLoginButton();
            loginPage.enterCredential(username, password);
            //loginPage.checkForGoogleSimpleVerification("Singapore");
        }

        MainPage mainPage = new MainPage(getDriver());
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
        CommonUtil.pause(delayInSecond*1000);
        takesScreenshot();
    }

    @Then("take screenshot with delay (\\d+)ms$")
    public void takeScreenShotWithDelayInMillisecond(int delayInMillisecond)
    {
        CommonUtil.pause(delayInMillisecond);
        takesScreenshot();
    }

    public void takesScreenshot()
    {
        takesScreenshot(getDriver(), getCurrentScenario());
    }

    private void takesScreenshot(WebDriver currentDriver, Scenario currentScenario)
    {
        final byte[] screenshot = ((TakesScreenshot) currentDriver).getScreenshotAs(OutputType.BYTES);
        currentScenario.embed(screenshot, "image/png");
    }

    @When("browser open \"([^\"]*)\"")
    public void browserOpen(String url)
    {
        getDriver().get(url);
    }

    @Then("print browser console log")
    public void printBrowserConsoleLog()
    {
        printBrowserConsoleLog(getDriver(), getCurrentScenario());
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
            System.out.println("[WARNING] Failed print browser log. Cause:");
            ex.printStackTrace(System.err);
        }
    }

    private void printLastPageHtmlSourceToFile(WebDriver currentDriver, Scenario currentScenario)
    {
        try
        {
            String scenarioName = currentScenario.getName();
            String lastPageHtmlSource = currentDriver.getPageSource();
            String htmlPageSourceName = scenarioName.split("\\(uid:")[0].trim().replaceAll(" ", "_")+'_'+HTML_PAGE_SOURCE_DATE_SUFFIX_SDF.format(new Date())+".html";

            File outputFile = new File(TestConstants.REPORT_HTML_OUTPUT_DIR, htmlPageSourceName);
            System.out.println(String.format("[INFO] Writing last page HTML source to file '%s'...", outputFile.getAbsolutePath()));

            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(outputFile)));
            bw.write(lastPageHtmlSource);
            bw.newLine();
            bw.flush();
            bw.close();

            System.out.println(String.format("[INFO] Writing last page HTML source to file '%s' is done.", outputFile.getAbsolutePath()));
            currentScenario.write(String.format("Last page HTML source file can be seen here: <a href='%s'>%s</a>", htmlPageSourceName, htmlPageSourceName));
        }
        catch(Exception ex)
        {
            System.out.println("[WARN] Cannot write last page html source to last-page.html.");
        }
    }

    public void writeToScenarioLog(String message)
    {
        getCurrentScenario().write(message);
    }

    public ScenarioStorage getCurrentScenarioStorage()
    {
        return scenarioStorage;
    }

    public void setCurrentScenarioStorage(ScenarioStorage scenarioStorage)
    {
        this.scenarioStorage = scenarioStorage;
    }

    public Scenario getCurrentScenario()
    {
        return scenario;
    }

    public WebDriver getDriver()
    {
        return driver;
    }
}
