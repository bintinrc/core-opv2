package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.model.RouteMonitoringFilters;
import co.nvqa.operator_v2.model.RouteMonitoringParams;
import co.nvqa.operator_v2.selenium.page.RouteMonitoringPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.text.ParseException;
import java.util.Date;
import java.util.Map;
import java.util.stream.Stream;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteMonitoringSteps extends AbstractSteps
{
    private RouteMonitoringPage routeMonitoringPage;

    public RouteMonitoringSteps()
    {
    }

    @Override
    public void init()
    {
        routeMonitoringPage = new RouteMonitoringPage(getWebDriver());
    }

    @When("^Operator filter Route Monitoring using data below and then load selection:$")
    public void operatorFilterRouteMonitoringUsingDataBelowAndThenLoadSelection(Map<String, String> mapOfData)
    {
        try
        {
            Date routeDate = YYYY_MM_DD_SDF.parse(mapOfData.get("routeDate"));

            String routeTags = mapOfData.get("routeTags").replaceAll("\\[", "").replaceAll("]", "");
            String[] tags = Stream.of(routeTags.split(",")).map(String::trim).toArray(String[]::new);

            String hubsRaw = mapOfData.get("hubs").replaceAll("\\[", "").replaceAll("]", "");
            String[] hubs = Stream.of(hubsRaw.split(",")).map(String::trim).toArray(String[]::new);

            RouteMonitoringFilters routeMonitoringFilters = new RouteMonitoringFilters();
            routeMonitoringFilters.setRouteDate(routeDate);
            routeMonitoringFilters.setRouteTags(tags);
            routeMonitoringFilters.setHubs(hubs);

            routeMonitoringPage.filterAndLoadSelection(routeMonitoringFilters);
            put("routeMonitoringFilters", routeMonitoringFilters);
        }
        catch(ParseException ex)
        {
            throw new NvTestRuntimeException("Failed to parse date.", ex);
        }
    }

    @Then("^Operator verify the created route is exist and has correct info$")
    public void operatorVerifyTheCreatedRouteIsExistAndHasCorrectInfo()
    {
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        RouteMonitoringFilters routeMonitoringFilters = get("routeMonitoringFilters");
        routeMonitoringPage.verifyRouteIsExistAndHasCorrectInfo(routeId, routeMonitoringFilters);
    }

    @When("^Operator click on 'Load Selection' Button on Route Monitoring Page$")
    public void operatorClickOnLoadSelectionButtonOnRouteMonitoringPage()
    {
        routeMonitoringPage.waitUntilPageLoaded();
        routeMonitoringPage.clickLoadSelectionButtonAndWaitUntilDone();
    }

    @Then("^Operator verify the created route monitoring params:$")
    public void operatorVerifyTheCreatedRouteMonitoringParams(Map<String, String> dataMap)
    {
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        RouteMonitoringParams routeMonitoringParams = new RouteMonitoringParams(dataMap);
        routeMonitoringParams.setRouteId(routeId);
        routeMonitoringPage.verifyRouteMonitoringParams(routeMonitoringParams);
    }
}
