package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.RouteMonitoringFilters;
import co.nvqa.operator_v2.model.RouteMonitoringParams;
import co.nvqa.operator_v2.selenium.page.RouteMonitoringV2Page;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.ArrayUtils;
import org.junit.Assert;

import java.util.Map;

import static co.nvqa.operator_v2.selenium.page.RouteMonitoringV2Page.RouteMonitoringTable.COLUMN_ROUTE_ID;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class RouteMonitoringV2PageSteps extends AbstractSteps
{
    private RouteMonitoringV2Page routeMonitoringV2Page;

    public RouteMonitoringV2PageSteps()
    {
    }

    @Override
    public void init()
    {
        routeMonitoringV2Page = new RouteMonitoringV2Page(getWebDriver());
    }

    @When("Route Monitoring V2 page is loaded")
    public void movementManagementPageIsLoaded()
    {
        routeMonitoringV2Page.switchTo();
        routeMonitoringV2Page.spinner.waitUntilInvisible();
    }

    @When("^Operator filter Route Monitoring V2 using data below and then load selection:$")
    public void operatorFilterRouteMonitoringV2UsingDataBelowAndThenLoadSelection(Map<String, String> data)
    {
        data = resolveKeyValues(data);
        RouteMonitoringFilters filters = new RouteMonitoringFilters(data);
        if (ArrayUtils.isNotEmpty(filters.getHubs()))
        {
            routeMonitoringV2Page.hubsFilter.clearAll();
            for (String hub : filters.getHubs())
            {
                routeMonitoringV2Page.hubsFilter.selectFilter(hub);
            }
        }
        if (ArrayUtils.isNotEmpty(filters.getZones()))
        {
            routeMonitoringV2Page.zonesFilter.clearAll();
            for (String zone : filters.getZones())
            {
                routeMonitoringV2Page.zonesFilter.selectFilter(zone);
            }
        }
        routeMonitoringV2Page.loadSelection.click();
        routeMonitoringV2Page.spinner.waitUntilInvisible();
    }

    @When("^Operator verify parameters of a route on Route Monitoring V2 page using data below:$")
    public void operatorVerifyRouteParameters(Map<String, String> data)
    {
        data = resolveKeyValues(data);
        RouteMonitoringParams expected = new RouteMonitoringParams(data);
        Long routeId = expected.getRouteId();
        Assert.assertNotNull("Route ID was not defined", routeId);
        routeMonitoringV2Page.routeMonitoringTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
        pause1s();
        Assert.assertFalse(f("Route [%d] was not found", routeId), routeMonitoringV2Page.routeMonitoringTable.isEmpty());
        RouteMonitoringParams actual = routeMonitoringV2Page.routeMonitoringTable.readEntity(1);
        expected.compareWithActual(actual);
    }
}
