package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.RouteCleaningReportCodInfo;
import co.nvqa.operator_v2.selenium.page.RouteCleaningReportPage;
import com.google.inject.Inject;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Collections;
import java.util.Date;
import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteCleaningReportSteps extends AbstractSteps
{
    private RouteCleaningReportPage routeCleaningReportPage;

    @Inject
    public RouteCleaningReportSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        routeCleaningReportPage = new RouteCleaningReportPage(getWebDriver());
    }

    @When("^Operator download Excel report on Route Cleaning Report page$")
    public void operatorDownloadExcelReportOnRouteCleaningReportPage()
    {
        routeCleaningReportPage.clickButtonDownloadExcelReport();
    }

    @When("^Operator download Excel report on Route Cleaning Report page successfully$")
    public void operatorDownloadExcelReportOnRouteCleaningReportPageSuccessfully()
    {
        routeCleaningReportPage.verifyExcelFileIsDownloadedSuccessfully();
    }

    @And("^Operator Select COD on Route Cleaning Report page$")
    public void operatorSelectCODOnRouteCleaningReportPage()
    {
        routeCleaningReportPage.selectCOD();
    }

    @And("^Operator fetch by current date on Route Cleaning Report page$")
    public void operatorFetchByCurrentDateOnRouteCleaningReportPage()
    {
        routeCleaningReportPage.fetchByDate(new Date());
    }

    @Then("^Operator verify the COD information on Route Cleaning Report page by following parameters:$")
    public void operatorVerifyTheCODInformationOnRouteCleaningReportPageByFollowingParameters(Map<String, String> mapOfData)
    {
        RouteCleaningReportCodInfo expectedCodInfo = new RouteCleaningReportCodInfo();
        expectedCodInfo.fromMap(mapOfData);
        routeCleaningReportPage.verifyCodInfo(expectedCodInfo);
    }

    @Then("^Operator download CSV for the new COD on Route Cleaning Report page$")
    public void operatorDownloadCSVForTheNewCODOnRouteCleaningReportPage()
    {
    }
}
