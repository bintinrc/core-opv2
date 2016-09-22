package com.nv.qa.cucumber.glue.step;

import com.nv.qa.selenium.page.page.LogoutPage;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.Scenario;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;

/**
 * Created by sw on 6/30/16.
 */
@ScenarioScoped
public class LogoutStep {

    private WebDriver driver;
    private LogoutPage logoutPage;

    @Before
    public void setup() {
        driver = SeleniumSharedDriver.getInstance().getDriver();
        logoutPage = new LogoutPage(driver);
    }

    @After
    public void teardown(Scenario scenario) {
        if (scenario.isFailed()) {
            final byte[] screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES);
            scenario.embed(screenshot, "image/png");
        }
    }

    @When("^logout button is clicked$")
    public void logout() throws InterruptedException {
        logoutPage.logout();
    }

}