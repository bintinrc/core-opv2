package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.RouteCleaningReportPage;
import com.google.inject.Inject;
import com.nv.qa.commons.utils.StandardScenarioStorage;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

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
}
