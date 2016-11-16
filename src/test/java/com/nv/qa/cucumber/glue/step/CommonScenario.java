package com.nv.qa.cucumber.glue.step;

import com.google.inject.Singleton;
import com.nv.qa.selenium.page.page.LoginPage;
import com.nv.qa.selenium.page.page.MainPage;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.Scenario;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@Singleton
public class CommonScenario
{
    private WebDriver driver;

    public CommonScenario()
    {
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
     * Save screenshot if scenario failed.
     * You can find screenshot image at './build/report/cucumber-junit/htmloutput/index.html'.
     *
     * @param scenario
     */
    @After
    public void teardown(Scenario scenario)
    {
        if (scenario.isFailed())
        {
            WebDriver driver = SeleniumSharedDriver.getInstance().getDriver();
            final byte[] screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES);
            scenario.embed(screenshot, "image/png");
        }
    }

    @Given("^op login into Operator V2 with username \"([^\"]*)\" and password \"([^\"]*)\"$")
    public void loginToOperatorV2(String username, String password) throws InterruptedException
    {
        LoginPage loginPage = new LoginPage(driver);
        loginPage.get();
        loginPage.clickLoginButton();
        loginPage.enterCredential(username, password);

        MainPage mainPage = new MainPage(driver);
        mainPage.dpAdm();
    }

    public WebDriver getDriver()
    {
        return driver;
    }
}
