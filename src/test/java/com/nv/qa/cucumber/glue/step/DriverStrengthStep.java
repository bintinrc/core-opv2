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

    @When("^in driver strength driver strength is filtered by ([^\"]*)$")
    public void filteredBy(String type) throws InterruptedException {
        dsPage.filteredBy(type);
    }

    @When("^in driver strength searching driver$")
    public void searchDriver() throws InterruptedException {
        dsPage.searchDriver();
    }

    @Then("^in driver strength verifying driver$")
    public void verifyDriver() throws InterruptedException {
        dsPage.verifyDriver();
    }

    @When("^in driver strength driver coming status is changed$")
    public void changeComingStatus() throws InterruptedException {
        dsPage.changeComingStatus();
    }


    @When("^in driver strength clicking on view contact button$")
    public void clickViewContactButton() throws InterruptedException {
        dsPage.clickViewContactButton();
    }

    @When("^in driver strength add new driver button is clicked$")
    public void clickAddNewDriver() {
        dsPage.clickAddNewDriver();
    }

    @When("^in driver strength enter default value of new driver$")
    public void enterDefaultValue() {
        dsPage.enterDefaultValue();
    }

    @Then("^in driver strength new driver should get created$")
    public void verifyNewDriver() {
        dsPage.verifyNewDriver();
    }

    @When("^in driver strength searching new created driver$")
    public void searchingNewDriver() {
        dsPage.searchingNewDriver();
    }

    @When("^in driver strength edit new driver button is clicked$")
    public void editNewDriver() {
        dsPage.editNewDriver();
    }

    @When("^in driver strength delete new driver button is clicked$")
    public void deleteNewDriver() {
        dsPage.deleteNewDriver();
    }

    @Then("^in driver strength the created driver should not exist$")
    public void createdDriverShouldNotExist() {
        dsPage.createdDriverShouldNotExist();
    }
}
