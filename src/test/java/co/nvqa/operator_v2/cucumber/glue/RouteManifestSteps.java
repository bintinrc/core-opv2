package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.factory.FailureReasonFactory;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.RouteManifestPage;
import co.nvqa.operator_v2.selenium.page.RouteMonitoringPage;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteManifestSteps extends AbstractSteps
{
    private RouteMonitoringPage routeMonitoringPage;
    private RouteManifestPage routeManifestPage;

    @Inject
    public RouteManifestSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        routeMonitoringPage = new RouteMonitoringPage(getWebDriver());
        routeManifestPage = new RouteManifestPage(getWebDriver());
    }

    @When("^Operator go to created Route Manifest$")
    public void operatorGoToCreatedRouteManifest()
    {
        Route route = get(KEY_CREATED_ROUTE);
        getWebDriver().navigate().to(String.format("%s/%s/route-manifest/%d", TestConstants.OPERATOR_PORTAL_BASE_URL, TestConstants.COUNTRY_CODE, route.getId()).toLowerCase());
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

    @When("Operator fail delivery waypoint from Route Manifest page")
    public void operatorFailDeliveryWaypointFromRouteManifestPage()
    {
        routeManifestPage.failDeliveryWaypoint(FailureReasonFactory.getFailureReason());
    }
}
