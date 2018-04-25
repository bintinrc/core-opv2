package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.RouteMonitoringFilters;
import co.nvqa.operator_v2.selenium.page.RouteMonitoringPage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.text.ParseException;
import java.util.Date;
import java.util.Map;
import java.util.stream.Stream;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteMonitoringSteps extends AbstractSteps
{
    private RouteMonitoringPage routeMonitoringPage;

    @Inject
    public RouteMonitoringSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        routeMonitoringPage = new RouteMonitoringPage(getWebDriver());
    }

    @When("^Operator filter Route Monitoring using data below and then load selection:$")
    public void operatorFilterRouteMonitoringUsingDataBelowAndThenLoadSelection(Map<String,String> mapOfData)
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
}
