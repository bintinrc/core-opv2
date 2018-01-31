package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.OutboundMonitoringPage;
import com.google.inject.Inject;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Tristania Siagian
 */
@ScenarioScoped
public class OutboundMonitoringSteps extends AbstractSteps {
    private OutboundMonitoringPage outboundMonitoringPage;

    @Inject
    public OutboundMonitoringSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage) {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init() {
        outboundMonitoringPage = new OutboundMonitoringPage(getWebDriver());
    }

    @When("^Operator click on 'Load Selection' Button on Outbound Monitoring Page$")
    public void clickLoadSelection() {
        outboundMonitoringPage.clickLoadSelection();
    }

    @And("^Operator search on Route ID Header Table on Outbound Monitoring Page$")
    public void searchRouteId() {
        long routeId = get(KEY_CREATED_ROUTE_ID);
        outboundMonitoringPage.searchRouteId(String.valueOf(routeId));
    }

    @Then("^Operator verify the route ID is exist on Outbound Monitoring Page$")
    public void verifyRouteIdExists() {
        long routeId = get(KEY_CREATED_ROUTE_ID);
        outboundMonitoringPage.verifyRouteIdExists(String.valueOf(routeId));
    }

    @Then("^Operator verify the In Progress Outbound Status on Outbound Monitoring Page$")
    public void verifyStatusInProgress() {
        outboundMonitoringPage.verifyStatusInProgress();
    }

    @Then("^Operator verify the Complete Outbound Status on Outbound Monitoring Page$")
    public void verifyStatusComplete() {
        outboundMonitoringPage.verifyStatusComplete();
    }

    @And("^Operator click on flag icon on chosen route ID on Outbound Monitoring Page$")
    public void clickFlagButton() {
        outboundMonitoringPage.clickFlagButton();
    }

    @Then("^Operator verifies the Outbound status on the chosen route ID is changed$")
    public void verifyStatusMarked() {
        outboundMonitoringPage.verifyStatusMarked();
    }

    @And("^Operator click on comment icon on chosen route ID on Outbound Monitoring Page$")
    public void clickCommentButtonAndSubmit() {
        outboundMonitoringPage.clickCommentButtonAndSubmit();
    }

    @Then("^Operator verifies the comment table on the chosen route ID is changed$")
    public void verifyCommentIsRight() {
        outboundMonitoringPage.verifyCommentIsRight();
    }
}
