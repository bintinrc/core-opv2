package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.model.driver.FailureReason;
import co.nvqa.commons.util.factory.FailureReasonFactory;
import co.nvqa.operator_v2.model.RouteManifestWaypointDetails;
import co.nvqa.operator_v2.selenium.page.RouteManifestPage;
import co.nvqa.operator_v2.util.TestConstants;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Map;

import static co.nvqa.commons.util.factory.FailureReasonFactory.*;

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
        FailureReason selectedFailureReason = get(KEY_SELECTED_FAILURE_REASON);
        routeManifestPage.verify1DeliveryFailAtRouteManifest(route, order, selectedFailureReason);
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
        String mode = FAILURE_REASON_PICKUP.equalsIgnoreCase(waypointType) ? FAILURE_REASON_PICKUP : FAILURE_REASON_DELIVERY;
        FailureReason failureReason = FailureReasonFactory.findAdvance(FAILURE_REASON_TYPE_NORMAL, mode, FAILURE_REASON_CODE_ID_ALL, FAILURE_REASON_INDEX_MODE_FIRST);
        routeManifestPage.failDeliveryWaypoint(failureReason);
        put(KEY_SELECTED_FAILURE_REASON, failureReason);
    }

    @When("^Operator success (delivery|pickup|reservation) waypoint from Route Manifest page$")
    public void operatorSuccessDeliveryWaypointFromRouteManifestPage(String waypointType)
    {
        routeManifestPage.successDeliveryWaypoint();
    }
}
