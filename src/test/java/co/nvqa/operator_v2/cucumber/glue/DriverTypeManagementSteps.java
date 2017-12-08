package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.DriverTypeManagementPage;
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
public class DriverTypeManagementSteps extends AbstractSteps
{
    private DriverTypeManagementPage dtmPage;

    @Inject
    public DriverTypeManagementSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        dtmPage = new DriverTypeManagementPage(getWebDriver());
    }

    @When("^driver type management is filtered by ([^\"]*) of ([^\"]*)$")
    public void filteredBy(String filterValue, String filterType)
    {
        dtmPage.filteredBy(filterValue, filterType);
    }

    @When("^download driver type management file$")
    public void downloadFile()
    {
        dtmPage.downloadFile();
    }

    @Then("^driver type management file should exist$")
    public void verifyFile()
    {
        dtmPage.verifyFile();
    }

    @When("^create driver type button is clicked$")
    public void createDriverType()
    {
        String uniqueCode = generateDateUniqueString();
        String driverTypeName = "DT-"+uniqueCode;
        put("driverTypeName", driverTypeName);
        dtmPage.createDriverType(driverTypeName);
    }

    @Then("^created driver type should exist$")
    public void verifyDriverType()
    {
        String driverTypeName = get("driverTypeName");
        dtmPage.verifyDriverType(driverTypeName);
    }

    @When("^searching created driver$")
    public void searchingCreatedDriver()
    {
        String driverTypeName = get("driverTypeName");
        dtmPage.searchingCreatedDriver(driverTypeName);
    }

    @When("^searching created driver and edit$")
    public void searchingCreatedDriverAndEdit()
    {
        String driverTypeName = get("driverTypeName");
        dtmPage.searchingCreatedDriverEdit(driverTypeName);
    }

    @Then("^verify changes of created driver type$")
    public void verifyChangesCreatedDriver()
    {
        dtmPage.verifyChangesCreatedDriver();
    }

    @When("^created driver is deleted$")
    public void deletedCreatedDriver()
    {
        dtmPage.deletedCreatedDriver();
    }

    @Then("^the created driver should not exist$")
    public void createdDriverShouldNotExist()
    {
        dtmPage.createdDriverShouldNotExist();
    }
}
