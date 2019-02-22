package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.DriverTypeParams;
import co.nvqa.operator_v2.selenium.page.DriverTypeManagementPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.List;
import java.util.Map;

/**
 * Modified by Sergey Mishanin
 *
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class DriverTypeManagementSteps extends AbstractSteps
{
    private DriverTypeManagementPage dtmPage;

    public DriverTypeManagementSteps()
    {
    }

    @Override
    public void init()
    {
        dtmPage = new DriverTypeManagementPage(getWebDriver());
    }

    @When("^Operator click on Download CSV File button on Driver Type Management page$")
    public void operatorClickOnDownloadCSVFileButtonOfDriverTypeManagementPage()
    {
        dtmPage.downloadFile();
    }

    @When("^Operator get all Driver Type params on Driver Type Management page$")
    public void operatorGetAllDriverTypeParamsOnDriverTypeManagementPage()
    {
        List<DriverTypeParams> params = dtmPage.driverTypesTable().getAllDriverTypeParams();
        put(KEY_LIST_OF_DRIVER_TYPE_PARAMS, params);
    }

    @Then("^Downloaded CSV file contains correct Driver Types data$")
    public void downloadedCSVFileContainsCorrectDriverTypesData()
    {
        List<DriverTypeParams> params = get(KEY_LIST_OF_DRIVER_TYPE_PARAMS);
        dtmPage.verifyDownloadedFileContent(params);
    }

    @When("^Operator create new Driver Type with the following attributes:$")
    public void operatorCreateNewDriverTypeWithTheFollowingAttributes(Map<String, String> dataMap)
    {
        DriverTypeParams driverTypeParams = new DriverTypeParams();
        driverTypeParams.fromMap(dataMap);
        dtmPage.createDriverType(driverTypeParams);
        put(KEY_DRIVER_TYPE_PARAMS, driverTypeParams);
        putInList(KEY_LIST_OF_DRIVER_TYPE_PARAMS, driverTypeParams);
    }

    @When("^Operator edit new Driver Type with the following attributes:$")
    public void operatorEditNewDriverTypeWithTheFollowingAttributes(Map<String, String> dataMap)
    {
        DriverTypeParams driverTypeParams = get(KEY_DRIVER_TYPE_PARAMS);
        String searchString = driverTypeParams.getDriverTypeName();
        driverTypeParams.fromMap(dataMap);
        dtmPage.editDriverType(driverTypeParams, searchString);
    }

    @Then("^Operator verify new Driver Type params$")
    public void operatorVerifyNewDriverTypeIsCreatedSuccessfully()
    {
        DriverTypeParams driverTypeParams = get(KEY_DRIVER_TYPE_PARAMS);
        dtmPage.verifyDriverType(driverTypeParams);
    }

    @And("^Operator get new Driver Type params on Driver Type Management page$")
    public void operatorGetNewDriverTypeParamsOnDriverTypeManagementPage()
    {
        DriverTypeParams driverTypeParams = get(KEY_DRIVER_TYPE_PARAMS);
        driverTypeParams = dtmPage.getDriverTypeParams(driverTypeParams.getDriverTypeName());
        put(KEY_DRIVER_TYPE_PARAMS, driverTypeParams);
        put(KEY_DRIVER_TYPE_ID, driverTypeParams.getDriverTypeId());
    }

    @When("^Operator delete new Driver Type on on Driver Type Management page$")
    public void operatorDeleteNewDriverTypeOnOnDriverTypeManagementPage()
    {
        DriverTypeParams driverTypeParams = get(KEY_DRIVER_TYPE_PARAMS);
        dtmPage.deleteDriverType(driverTypeParams);
    }

    @Then("^Operator verify new Driver Type is deleted successfully$")
    public void operatorVerifyNewDriverTypeIsDeletedSuccessfully()
    {
        dtmPage.refreshPage();
        DriverTypeParams driverTypeParams = get(KEY_DRIVER_TYPE_PARAMS);
        dtmPage.searchingCreatedDriver(driverTypeParams.getDriverTypeName());
        assertEquals("Created Driver Type was not deleted", 0, dtmPage.driverTypesTable().getRowsCount());
        remove(KEY_DRIVER_TYPE_ID);
    }

    @When("^Operator configure filter on Driver Type Management page with the following attributes:$")
    public void operatorConfigureFilterOnDriverTypeManagementPageWithTheFollowingAttributes(Map<String, String> dataMap)
    {
        DriverTypeParams driverTypeParams = new DriverTypeParams();
        driverTypeParams.fromMap(dataMap);
        dtmPage.searchingCreatedDriver("");
        dtmPage.filtersForm().fillForm(driverTypeParams);
        pause2s();
        put(KEY_DRIVER_TYPE_FILTER_PARAMS, driverTypeParams);
    }

    @When("^Operator verify filter results on Driver Type Management page$")
    public void operatorVerifyFilterResultsOnDriverTypeManagementPage()
    {
        DriverTypeParams driverTypeParams = get(KEY_DRIVER_TYPE_FILTER_PARAMS);
        dtmPage.verifyFilterResults(driverTypeParams);
    }
}
