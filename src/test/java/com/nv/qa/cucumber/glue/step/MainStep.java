package com.nv.qa.cucumber.glue.step;

import com.nv.qa.selenium.page.page.MainPage;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.Scenario;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;

/**
 * Created by sw on 6/30/16.
 */
@ScenarioScoped
public class MainStep {

    private WebDriver driver;
    private MainPage mainPage;

    @Before
    public void setup() {
        driver = SeleniumSharedDriver.getInstance().getDriver();
        mainPage = new MainPage(driver);
    }

    @After
    public void teardown(Scenario scenario) {
        if (scenario.isFailed()) {
            final byte[] screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES);
            scenario.embed(screenshot, "image/png");
        }
    }

    @Given("^op click navigation ([^\"]*)$")
    public void clickNavigation(String navTitle) throws InterruptedException {
        mainPage.clickNavigation(navTitle);
    }

    @Then("^op is in dp administration$")
    public void dpAdm() throws InterruptedException {
        mainPage.dpAdm();
    }

}