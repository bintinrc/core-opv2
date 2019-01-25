package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.AllOrdersPage;
import co.nvqa.operator_v2.selenium.page.RouteLogsPage;
import co.nvqa.operator_v2.selenium.page.VanInboundPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Date;
import java.util.Map;

/**
 *
 * @author Tristania Siagian
 */
@ScenarioScoped
public class VanInboundSteps extends AbstractSteps {
    private VanInboundPage vanInboundPage;
    private AllOrdersPage allOrdersPage;
    private RouteLogsPage routeLogsPage;

    public VanInboundSteps() {
    }

    @Override
    public void init() {
        vanInboundPage = new VanInboundPage(getWebDriver());
        allOrdersPage = new AllOrdersPage(getWebDriver());
        routeLogsPage = new RouteLogsPage(getWebDriver());
    }

    @And("^Operator fill the route ID on Van Inbound Page then click enter$")
    public void fillRouteIdOnVanInboundPage() {
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        vanInboundPage.fillRouteIdOnVanInboundPage(String.valueOf(routeId));
    }

    @And("^Operator fill the tracking ID on Van Inbound Page then click enter$")
    public void fillTrackingIdOnVanInboundPage() {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        vanInboundPage.fillTrackingIdOnVanInboundPage(trackingId);
    }

    @Then("^Operator verify the van inbound process is succeed$")
    public void verifyVanInboundSucceed() {
        vanInboundPage.verifyVanInboundSucceed();
    }

    @Then("^Operator verify order scan updated$")
    public void verifyOrderScanUpdated(){
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        allOrdersPage.verifyInboundIsSucceed(trackingId);
    }

    @And("^Operator click on start route after van inbounding$")
    public void startRoute() {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        vanInboundPage.startRoute(trackingId);
    }

    @Then("^Operator verify the route is started after van inbounding using data below:$")
    public void verifyRouteIsStarted(Map<String,String> mapOfData) {
        long routeId = get(KEY_CREATED_ROUTE_ID);
        Date routeDateFrom = getDateByMode(mapOfData.get("routeDateFrom"));
        Date routeDateTo = getDateByMode(mapOfData.get("routeDateTo"));
        String hubName = mapOfData.get("hubName");
        routeLogsPage.loadAndVerifyRoute(routeDateFrom, routeDateTo, hubName, routeId);
    }

    @And("^Operator fill the invalid tracking ID ([^\"]*) on Van Inbound Page$")
    public void fillInvalidTrackingId(String trackingId) {
        vanInboundPage.fillTrackingIdOnVanInboundPage(trackingId);
    }

    @Then("^Operator verify the tracking ID ([^\"]*) that has been input on Van Inbound Page is invalid$")
    public void verifyInvalidTrackingId(String trackingId) {
        vanInboundPage.verifyInvalidTrackingId(trackingId);
    }

    @And("^Operator fill the empty tracking ID on Van Inbound Page$")
    public void emptyTrackingId() {
        String trackingId = "";
        vanInboundPage.fillTrackingIdOnVanInboundPage(trackingId);
    }

    @Then("^Operator verify the tracking ID that has been input on Van Inbound Page is empty$")
    public void verifyTrackingIdEmpty() {
        vanInboundPage.verifyTrackingIdEmpty();
    }
}
