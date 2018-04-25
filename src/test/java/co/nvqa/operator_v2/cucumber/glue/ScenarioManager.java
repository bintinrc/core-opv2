package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common_selenium.cucumber.glue.CommonSeleniumScenarioManager;
import co.nvqa.common_selenium.util.SeleniumUtils;
import co.nvqa.commons.cucumber.glue.StandardApiOperatorPortalSteps;
import co.nvqa.commons.utils.NvLogger;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.commons.utils.StandardScenarioStorageKeys;
import co.nvqa.operator_v2.selenium.page.LoginPage;
import co.nvqa.operator_v2.selenium.page.MainPage;
import co.nvqa.operator_v2.selenium.page.OperatorV2SimplePage;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.inject.Inject;
import com.google.inject.Provider;
import com.google.inject.Singleton;
import cucumber.api.Scenario;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import java.util.Collection;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@Singleton
public class ScenarioManager extends CommonSeleniumScenarioManager
{
    @Inject private Provider<StandardScenarioStorage> providerOfScenarioStorage;
    @Inject private Provider<StandardApiOperatorPortalSteps> providerOfStandardApiOperatorPortalSteps;

    public ScenarioManager()
    {
    }

    /**
     * Inject object Scenario each time the scenario is running.
     *
     * @param scenario The current running scenario.
     */
    @Before
    public void before(Scenario scenario)
    {
        setCurrentScenario(scenario);

        providerOfScenarioStorage.get().put(StandardScenarioStorageKeys.KEY_SHIPPER_CLIENT_ID, TestConstants.SHIPPER_V2_CLIENT_ID);
        providerOfScenarioStorage.get().put(StandardScenarioStorageKeys.KEY_SHIPPER_CLIENT_SECRET, TestConstants.SHIPPER_V2_CLIENT_SECRET);

        providerOfScenarioStorage.get().put(StandardScenarioStorageKeys.KEY_NINJA_DRIVER_USERNAME, TestConstants.NINJA_DRIVER_USERNAME);
        providerOfScenarioStorage.get().put(StandardScenarioStorageKeys.KEY_NINJA_DRIVER_PASSWORD, TestConstants.NINJA_DRIVER_PASSWORD);
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
     * @param scenario The current running scenario.
     */
    @After
    @Override
    public void teardown(Scenario scenario)
    {
        super.teardown(scenario);
    }

    @After("@ResetWindow")
    public void resetWindow()
    {
        NvLogger.info("Reset window.");

        try
        {
            TestUtils.acceptAlertDialogIfAppear(getWebDriver());
            getWebDriver().get(TestConstants.OPERATOR_PORTAL_URL);
            TestUtils.acceptAlertDialogIfAppear(getWebDriver());
            OperatorV2SimplePage operatorV2SimplePage = new OperatorV2SimplePage(getWebDriver());
            String leaveBtnXpath = "//md-dialog[@aria-label='Leaving PageYou have ...']//button[@aria-label='Leave']";
            WebElement webElement = operatorV2SimplePage.findElementByFast(By.xpath(leaveBtnXpath));
            webElement.click();
            operatorV2SimplePage.waitUntilInvisibilityOfToast("sidenav-main-menu");
        }
        catch(Throwable th)
        {
            NvLogger.warn("Failed to 'Reset Window'.", th);
        }
    }

    @Given("^op login into Operator V2 with username \"([^\"]*)\" and password \"([^\"]*)\"$")
    public void loginToOperatorV2(String username, String password)
    {
        LoginPage loginPage = new LoginPage(getWebDriver());
        loginPage.loadPage();

        if(TestConstants.OPERATOR_PORTAL_FORCE_LOGIN_BY_INJECTING_COOKIES)
        {
            String operatorAccessToken = providerOfStandardApiOperatorPortalSteps.get().getOperatorAccessToken();
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

    @Given("^Operator login with username = \"([^\"]*)\" and password = \"([^\"]*)\"$")
    public void newLoginToOperatorV2(String username, String password)
    {
        loginToOperatorV2(username, password);
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
