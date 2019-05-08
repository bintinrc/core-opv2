package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.OutboundAndRouteLoadMonitoringPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.List;

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
    }

    @When("Operator enable filter Show only {string}")
    public void operatorEnableFilterShowOnly(String arg0) {
        outboundAndRouteLoadMonitoringPage.selectFilter(arg0);
    }

    @Then("Operator verifies the created route is gone from table")
    public void operatorVerifiesTheCreatedRouteIsGoneFromTable() {
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        outboundAndRouteLoadMonitoringPage.verifyRouteIdDoesNotExists(routeId.toString());
    }

    @Then("Change tab to {string}")
    public void changeTabTo(String arg0) {
        outboundAndRouteLoadMonitoringPage.clickOnTab(arg0);
    }

    @Then("Operator waits for {int} seconds")
    public void operatorWaitsForSeconds(int arg0) {
        pause(arg0*1000);
    }

    @Then("Operator verifies the created route is still displayed on table")
    public void operatorVerifiesTheCreatedRouteIsStillDisplayedOnTable() {
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        outboundAndRouteLoadMonitoringPage.verifyRouteIdExists(routeId.toString());
    }

    @When("Operator finds the created route")
    public void operatorFindsTheCreatedRoute() {
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        outboundAndRouteLoadMonitoringPage.searchTableByRouteId(routeId);
    }

    @Then("Operator verifies the route is exist and the info in the row is correct.")
    public void operatorVerifiesTheRouteIsExistAndTheInfoInTheRowIsCorrect() {
        outboundAndRouteLoadMonitoringPage.verifyRouteIdAndInfo();
    }

    @When("Operator clicks the number on Parcels Assigned column")
    public void operatorClicksTheNumberOnParcelsAssignedColumn() {
        outboundAndRouteLoadMonitoringPage.clickInTableByClass("total_parcels_count");
    }

    @Then("Operator verifies the Transaction Log contains all created Tracking ID")
    public void operatorVerifiesTheTransactionLogContainsAllCreatedTrackingID() {
        List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
        outboundAndRouteLoadMonitoringPage.verifyTrackingIds(trackingIds);
    }

    @When("Operator clicks the number on Missing Parcels column")
    public void operatorClicksTheNumberOnMissingParcelsColumn() {
        outboundAndRouteLoadMonitoringPage.clickInTableByClass("missing_parcels_count");
    }
}
