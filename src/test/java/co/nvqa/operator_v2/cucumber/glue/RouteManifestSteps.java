package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.factory.FailureReason;
import co.nvqa.commons.factory.FailureReasonFactory;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.operator_v2.model.RouteManifestWaypointDetails;
import co.nvqa.operator_v2.selenium.page.RouteManifestPage;
import co.nvqa.operator_v2.util.TestConstants;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.StringUtils;

import java.util.Map;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteManifestSteps extends AbstractSteps
{
    private RouteManifestPage routeManifestPage;

    public RouteManifestSteps()
    {
    }

    @Override
    public void init()
    {
        routeManifestPage = new RouteManifestPage(getWebDriver());
    }

    @When("^Operator go to created Route Manifest$")
    public void operatorGoToCreatedRouteManifest()
    {
        Route route = get(KEY_CREATED_ROUTE);
        getWebDriver().navigate().to(f("%s/%s/route-manifest/%d", TestConstants.OPERATOR_PORTAL_BASE_URL, TestConstants.COUNTRY_CODE, route.getId()).toLowerCase());
    }

    @Then("^Operator verify 1 delivery success at Route Manifest$")
    public void operatorVerify1DeliverySuccessAtRouteManifest()
    {
        Route route = get(KEY_CREATED_ROUTE);
        Order order = get(KEY_ORDER_DETAILS);
        routeManifestPage.verify1DeliverySuccessAtRouteManifest(route, order);
    }

    @Then("^Operator verify 1 delivery fail at Route Manifest$")
    public void operatorVerify1DeliveryFailAtRouteManifest()
    {
        Route route = get(KEY_CREATED_ROUTE);
        Order order = get(KEY_ORDER_DETAILS);
        routeManifestPage.verify1DeliveryFailAtRouteManifest(route, order);
    }

    @Then("^Operator verify waypoint at Route Manifest using data below:$")
    public void operatorVerifyWaypointAtRouteManifest(Map<String, String> mapOfData)
    {
        mapOfData = resolveKeyValues(mapOfData);

        RouteManifestWaypointDetails waypointDetails = new RouteManifestWaypointDetails();
        waypointDetails.fromMap(mapOfData);

        routeManifestPage.verifyWaypointDetails(waypointDetails);
    }

    @When("^Operator fail (delivery|pickup|reservation) waypoint from Route Manifest page$")
    public void operatorFailDeliveryWaypointFromRouteManifestPage(String waypointType)
    {
        FailureReason failureReason = StringUtils.equalsIgnoreCase(waypointType, "pickup") ?
                FailureReasonFactory.getPickupFailureReason() :
                FailureReasonFactory.getDeliveryFailureReason();
        routeManifestPage.failDeliveryWaypoint(failureReason);
        put(KEY_FAILURE_REASON, failureReason.getName().replace(" - Normal", "").trim());
    }

    @When("^Operator success (delivery|pickup|reservation) waypoint from Route Manifest page$")
    public void operatorSuccessDeliveryWaypointFromRouteManifestPage(String waypointType)
    {
        routeManifestPage.successDeliveryWaypoint();
    }
}
