package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.WaypointPerformance;
import co.nvqa.operator_v2.selenium.page.RouteInboundPage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

import java.text.ParseException;
import java.util.Date;
import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteInboundSteps extends AbstractSteps
{
    private static final String FETCH_BY_ROUTE_ID = "FETCH_BY_ROUTE_ID";
    private static final String FETCH_BY_TRACKING_ID = "FETCH_BY_TRACKING_ID";

    private RouteInboundPage routeInboundPage;

    @Inject
    public RouteInboundSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        routeInboundPage = new RouteInboundPage(getWebDriver());
    }

    @When("^Operator get Route Summary Details on Route Inbound page using data below:$")
    public void operatorGetRouteDetailsOnRouteInboundPageUsingDataBelow(Map<String,String> mapOfData)
    {
        String hubName = mapOfData.get("hubName");
        String fetchBy = mapOfData.get("fetchBy");
        String fetchByValue = mapOfData.get("fetchByValue");

        if(FETCH_BY_ROUTE_ID.equals(fetchBy))
        {
            Long routeId;

            if("GET_FROM_CREATED_ROUTE".equals(fetchByValue))
            {
                routeId = get(KEY_CREATED_ROUTE_ID);
            }
            else
            {
                routeId = Long.parseLong(fetchByValue);
            }

            routeInboundPage.fetchRouteByRouteId(hubName, routeId);
        }
    }

    @Then("^Operator verify the Route Summary Details is correct using data below:$")
    public void operatorVerifyTheRouteSummaryDetailsIsCorrectUsingDataBelow(Map<String,String> mapOfData)
    {
        String routeIdAsString = mapOfData.get("routeId");
        String driverName = mapOfData.get("driverName");
        String hubName = mapOfData.get("hubName");
        String routeDateAsString = mapOfData.get("routeDate");

        Long routeId;

        if("GET_FROM_CREATED_ROUTE".equals(routeIdAsString))
        {
            routeId = get(KEY_CREATED_ROUTE_ID);
        }
        else
        {
            routeId = Long.parseLong(routeIdAsString);
        }

        Date routeDate;

        try
        {
            if("GET_FROM_CREATED_ROUTE".equals(routeDateAsString))
            {
                Route route = get(KEY_CREATED_ROUTE);
                routeDate = ISO_8601_WITHOUT_MILLISECONDS.parse(route.getCreatedAt());
            }
            else
            {
                routeDate = ISO_8601_WITHOUT_MILLISECONDS.parse(routeDateAsString);
            }
        }
        catch(ParseException ex)
        {
            throw new NvTestRuntimeException("Failed to parse route date.", ex);
        }

        WaypointPerformance waypointPerformance = new WaypointPerformance();
        waypointPerformance.setPending(Integer.parseInt(mapOfData.get("wpPending")));
        waypointPerformance.setPartial(Integer.parseInt(mapOfData.get("wpPartial")));
        waypointPerformance.setFailed(Integer.parseInt(mapOfData.get("wpFailed")));
        waypointPerformance.setCompleted(Integer.parseInt(mapOfData.get("wpCompleted")));
        waypointPerformance.setTotal(Integer.parseInt(mapOfData.get("wpTotal")));

        routeInboundPage.verifyRouteSummaryInfoIsCorrect(routeId, driverName, hubName, routeDate, waypointPerformance, null);
    }
}
