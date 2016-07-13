package com.nv.qa.cucumber.glue.step;

import com.nv.qa.selenium.page.page.DriverStrengthPage;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.openqa.selenium.WebDriver;

/**
 * Created by sw on 7/12/16.
 */
@ScenarioScoped
public class DriverStrengthStep {

    private WebDriver driver;
    private DriverStrengthPage dsPage;

    @Before
    public void setup() {
        driver = SeleniumSharedDriver.getInstance().getDriver();
        dsPage = new DriverStrengthPage(driver);
    }

    @After
    public void teardown() {

    }

    @When("^download driver csv list$")
    public void downloadFile() throws InterruptedException {
        dsPage.downloadFile();
    }

    @Then("^driver list should exist$")
    public void verifyDownloadedFile() {
        dsPage.verifyDownloadedFile();
    }

    @When("^driver strength is filtered by ([^\"]*)$")
    public void filteredBy(String type) throws InterruptedException {
        dsPage.filteredBy(type);
    }

    @When("^searching driver ([^\"]*)$")
    public void searchDriver(String value) throws InterruptedException {
        dsPage.searchDriver(value);
    }

    @Then("^verifying driver ([^\"]*)$")
    public void verifyDriver(String value) throws InterruptedException {
        dsPage.verifyDriver(value);
    }

    @When("^driver coming status is changed$")
    public void changeComingStatus() throws InterruptedException {
        dsPage.changeComingStatus();
    }
}
