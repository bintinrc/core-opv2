package com.nv.qa.cucumber.glue.step;

import com.nv.qa.selenium.page.page.DriverTypeManagementPage;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.Scenario;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;

/**
 * Created by sw on 7/13/16.
 */
@ScenarioScoped
public class DriverTypeManagementStep {

    private WebDriver driver;
    private DriverTypeManagementPage dtmPage;

    @Before
    public void setup() {
        driver = SeleniumSharedDriver.getInstance().getDriver();
        dtmPage = new DriverTypeManagementPage(driver);
    }

    @After
    public void teardown(Scenario scenario) {
        if (scenario.isFailed()) {
            final byte[] screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES);
            scenario.embed(screenshot, "image/png");
        }
    }

    @When("^driver type management is filtered by ([^\"]*) of ([^\"]*)$")
    public void filteredBy(String filterValue, String filterType) throws InterruptedException {
        dtmPage.filteredBy(filterValue, filterType);
    }

    @When("^download driver type management file$")
    public void downloadFile() throws InterruptedException {
        dtmPage.downloadFile();
    }

    @Then("^driver type management file should exist$")
    public void verifyFile() throws InterruptedException {
        dtmPage.verifyFile();
    }

    @When("^create driver type button is clicked$")
    public void clickDriverTypeButton() throws InterruptedException {
        dtmPage.clickDriverTypeButton();
    }

    @Then("^created driver type should exist$")
    public void verifyDriverType() throws InterruptedException {
        dtmPage.verifyDriverType();
    }

    @When("^searching created driver$")
    public void searchingCreatedDriver() throws InterruptedException {
        dtmPage.searchingCreatedDriver();
    }

    @When("^searching created driver and edit$")
    public void searchingCreatedDriverAndEdit() throws InterruptedException {
        dtmPage.searchingCreatedDriverEdit();
    }

    @Then("^verify changes of created driver type$")
    public void verifyChangesCreatedDriver() {
        dtmPage.verifyChangesCreatedDriver();
    }

    @When("^created driver is deleted$")
    public void deletedCreatedDriver() throws InterruptedException {
        dtmPage.deletedCreatedDriver();
    }

    @Then("^the created driver should not exist$")
    public void createdDriverShouldNotExist() {
        dtmPage.createdDriverShouldNotExist();
    }
}
