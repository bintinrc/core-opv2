package com.nv.qa.cucumber.glue.step;

import com.nv.qa.selenium.page.page.DpPage;
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
 * Created by sw on 7/4/16.
 */
@ScenarioScoped
public class DpStep {

    private WebDriver driver;
    private DpPage dpPage;

    @Before
    public void setup() {
        driver = SeleniumSharedDriver.getInstance().getDriver();
        dpPage = new DpPage(driver);
    }

    @After
    public void teardown(Scenario scenario) {
        if (scenario.isFailed()) {
            final byte[] screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES);
            scenario.embed(screenshot, "image/png");
        }
    }

    @When("^download button in ([^\"]*) is clicked$")
    public void downloadFile(String type) throws InterruptedException {
        dpPage.downloadFile(type);
    }

    @Then("^file ([^\"]*) should exist$")
    public void verifyDownloadedFile(String type) {
        dpPage.verifyDownloadedFile(type);
    }

    @When("^searching for ([^\"]*)$")
    public void search(String type) throws InterruptedException {
        dpPage.search(type);
    }

    @When("^add ([^\"]*) button is clicked$")
    public void clickAddBtn(String type) throws InterruptedException {
        dpPage.clickAddBtn(type);
    }

    @When("^enter default value of ([^\"]*)$")
    public void enterDefaultValue(String type) throws InterruptedException {
        dpPage.enterDefaultValue(type);
    }

    @Then("^verify result ([^\"]*)$")
    public void verifyResult(String type) {
        dpPage.verifyResult(type);
    }


    @When("^edit ([^\"]*) button is clicked$")
    public void clickEditBtn(String type) throws InterruptedException {
        dpPage.clickEditBtn(type);
    }

    @When("^view ([^\"]*) button is clicked$")
    public void clickViewBtn(String type) throws InterruptedException {
        dpPage.clickViewBtn(type);
    }

    @Then("^verify page ([^\"]*)$")
    public void verifyPage(String type) throws InterruptedException {
        dpPage.verifyPage(type);
    }

}
