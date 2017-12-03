package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.DpPage;
import com.google.inject.Inject;
import com.nv.qa.commons.utils.StandardScenarioStorage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class DpSteps extends AbstractSteps
{
    private DpPage dpPage;

    @Inject
    public DpSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        dpPage = new DpPage(getWebDriver());
    }

    @When("^download button in ([^\"]*) is clicked$")
    public void downloadFile(String type)
    {
        dpPage.downloadFile(type);
    }

    @Then("^file ([^\"]*) should exist$")
    public void verifyDownloadedFile(String type)
    {
        dpPage.verifyDownloadedFile(type);
    }

    @When("^searching for ([^\"]*)$")
    public void search(String type)
    {
        dpPage.search(type);
    }

    @When("^add ([^\"]*) button is clicked$")
    public void clickAddBtn(String type)
    {
        dpPage.clickAddBtn(type);
    }

    @When("^enter default value of ([^\"]*)$")
    public void enterDefaultValue(String type)
    {
        dpPage.enterDefaultValue(type);
    }

    @Then("^verify result ([^\"]*)$")
    public void verifyResult(String type)
    {
        dpPage.verifyResult(type);
    }

    @When("^edit ([^\"]*) button is clicked$")
    public void clickEditBtn(String type)
    {
        dpPage.clickEditBtn(type);
    }

    @When("^view ([^\"]*) button is clicked$")
    public void clickViewBtn(String type)
    {
        dpPage.clickViewBtn(type);
    }

    @Then("^verify page ([^\"]*)$")
    public void verifyPage(String type)
    {
        dpPage.verifyPage(type);
    }
}
