package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.selenium.page.DpPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 * Created by sw on 7/4/16.
 */
@ScenarioScoped
public class DpStep extends AbstractSteps
{
    private DpPage dpPage;

    @Inject
    public DpStep(CommonScenario commonScenario)
    {
        super(commonScenario);
    }

    @Override
    public void init()
    {
        dpPage = new DpPage(getDriver());
    }

    @When("^download button in ([^\"]*) is clicked$")
    public void downloadFile(String type) throws InterruptedException
    {
        dpPage.downloadFile(type);
    }

    @Then("^file ([^\"]*) should exist$")
    public void verifyDownloadedFile(String type)
    {
        dpPage.verifyDownloadedFile(type);
    }

    @When("^searching for ([^\"]*)$")
    public void search(String type) throws InterruptedException
    {
        dpPage.search(type);
    }

    @When("^add ([^\"]*) button is clicked$")
    public void clickAddBtn(String type) throws InterruptedException
    {
        dpPage.clickAddBtn(type);
    }

    @When("^enter default value of ([^\"]*)$")
    public void enterDefaultValue(String type) throws InterruptedException
    {
        dpPage.enterDefaultValue(type);
    }

    @Then("^verify result ([^\"]*)$")
    public void verifyResult(String type)
    {
        dpPage.verifyResult(type);
    }

    @When("^edit ([^\"]*) button is clicked$")
    public void clickEditBtn(String type) throws InterruptedException
    {
        dpPage.clickEditBtn(type);
    }

    @When("^view ([^\"]*) button is clicked$")
    public void clickViewBtn(String type) throws InterruptedException
    {
        dpPage.clickViewBtn(type);
    }

    @Then("^verify page ([^\"]*)$")
    public void verifyPage(String type) throws InterruptedException
    {
        dpPage.verifyPage(type);
    }
}
