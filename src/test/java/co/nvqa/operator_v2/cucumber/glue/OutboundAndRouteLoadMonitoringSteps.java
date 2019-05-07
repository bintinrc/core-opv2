package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.OutboundAndRouteLoadMonitoringPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

@ScenarioScoped
public class OutboundAndRouteLoadMonitoringSteps extends AbstractSteps {
    private OutboundAndRouteLoadMonitoringPage outboundAndRouteLoadMonitoringPage;


    @Override
    public void init() {
        outboundAndRouteLoadMonitoringPage = new OutboundAndRouteLoadMonitoringPage(getWebDriver(), getScenarioStorage());
    }

    public OutboundAndRouteLoadMonitoringSteps() {
    }

    @Then("Operator verifies the route is exist")
    public void operatorVerifiesTheRouteIsExist() {
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        outboundAndRouteLoadMonitoringPage.verifyRouteIdExists(routeId.toString());
        outboundAndRouteLoadMonitoringPage.verifyRouteIdExists(routeId.toString());
    }

    @When("Operator enable filter Show only {string}")
    public void operatorEnableFilterShowOnly(String arg0) {
        outboundAndRouteLoadMonitoringPage.selectFilter(arg0);
    }

    @Then("Operator verifies the created route is gone from table")
    public void operatorVerifiesTheCreatedRouteIsGoneFromTable() {
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        outboundAndRouteLoadMonitoringPage.searchTableByRouteId(routeId);
        outboundAndRouteLoadMonitoringPage.verifyRouteIdDoesNotExists(routeId.toString());
    }
}
