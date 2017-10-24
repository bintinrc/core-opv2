package com.nv.qa.cucumber.glue.step;

import com.nv.qa.selenium.page.LogoutPage;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.java.Before;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.openqa.selenium.WebDriver;

/**
 * Created by sw on 6/30/16.
 */
@ScenarioScoped
public class LogoutSteps
{

    private WebDriver driver;
    private LogoutPage logoutPage;

    @Before
    public void setup() {
        driver = SeleniumSharedDriver.getInstance().getDriver();
        logoutPage = new LogoutPage(driver);
    }

    @When("^logout button is clicked$")
    public void logout() throws InterruptedException {
        logoutPage.logout();
    }

}