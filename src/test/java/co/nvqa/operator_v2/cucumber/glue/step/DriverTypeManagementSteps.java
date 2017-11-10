package co.nvqa.operator_v2.cucumber.glue.step;

import com.google.inject.Inject;
import co.nvqa.operator_v2.selenium.page.DriverTypeManagementPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class DriverTypeManagementSteps extends AbstractSteps
{
    private DriverTypeManagementPage dtmPage;

    @Inject
    public DriverTypeManagementSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        dtmPage = new DriverTypeManagementPage(getDriver());
    }

    @When("^driver type management is filtered by ([^\"]*) of ([^\"]*)$")
    public void filteredBy(String filterValue, String filterType) throws InterruptedException
    {
        dtmPage.filteredBy(filterValue, filterType);
    }

    @When("^download driver type management file$")
    public void downloadFile() throws InterruptedException
    {
        dtmPage.downloadFile();
    }

    @Then("^driver type management file should exist$")
    public void verifyFile() throws InterruptedException
    {
        dtmPage.verifyFile();
    }

    @When("^create driver type button is clicked$")
    public void clickDriverTypeButton() throws InterruptedException
    {
        dtmPage.clickDriverTypeButton();
    }

    @Then("^created driver type should exist$")
    public void verifyDriverType() throws InterruptedException
    {
        dtmPage.verifyDriverType();
    }

    @When("^searching created driver$")
    public void searchingCreatedDriver() throws InterruptedException
    {
        dtmPage.searchingCreatedDriver();
    }

    @When("^searching created driver and edit$")
    public void searchingCreatedDriverAndEdit() throws InterruptedException
    {
        dtmPage.searchingCreatedDriverEdit();
    }

    @Then("^verify changes of created driver type$")
    public void verifyChangesCreatedDriver()
    {
        dtmPage.verifyChangesCreatedDriver();
    }

    @When("^created driver is deleted$")
    public void deletedCreatedDriver() throws InterruptedException
    {
        dtmPage.deletedCreatedDriver();
    }

    @Then("^the created driver should not exist$")
    public void createdDriverShouldNotExist()
    {
        dtmPage.createdDriverShouldNotExist();
    }
}
