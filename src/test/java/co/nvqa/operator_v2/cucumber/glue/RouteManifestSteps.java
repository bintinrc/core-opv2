package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.RouteMonitoringPage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteManifestSteps extends AbstractSteps
{
    private RouteMonitoringPage routeMonitoringPage;

    @Inject
    public RouteManifestSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        routeMonitoringPage = new RouteMonitoringPage(getWebDriver());
    }

    @Then("^Operator verify 1 delivery success at Route Manifest$")
    public void operatorVerify1DeliverySuccessAtRouteManifest()
    {
        Route route = get(KEY_CREATED_ROUTE);
        Order order = get(KEY_ORDER_DETAILS);
        routeMonitoringPage.verify1DeliverySuccessAtRouteManifest(route, order);
    }

    @Then("^Operator verify 1 delivery fail at Route Manifest$")
    public void operatorVerify1DeliveryFailAtRouteManifest()
    {
        Route route = get(KEY_CREATED_ROUTE);
        Order order = get(KEY_ORDER_DETAILS);
        routeMonitoringPage.verify1DeliveryFailAtRouteManifest(route, order);
    }
}
