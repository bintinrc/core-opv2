package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.selenium.page.OutboundMonitoringPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.Map;
import org.assertj.core.api.Assertions;

/**
 * @author Tristania Siagian
 */
@ScenarioScoped
public class OutboundMonitoringSteps extends AbstractSteps {

  private OutboundMonitoringPage outboundMonitoringPage;

  public OutboundMonitoringSteps() {
  }

  @Override
  public void init() {
    outboundMonitoringPage = new OutboundMonitoringPage(getWebDriver(), getScenarioStorage());
  }

  @When("^Operator click on 'Load Selection' Button on Outbound Monitoring Page$")
  public void clickLoadSelection() {
    outboundMonitoringPage.loadSelection.clickAndWaitUntilDone();
  }

  @When("Operator verifies Date is {string} on Outbound Monitoring Page")
  public void verifyDate(String expected) {
    Assertions.assertThat(outboundMonitoringPage.dateFilter.fromDate.getValue())
        .as("Date")
        .isEqualTo(expected);
  }

  @And("^Operator search on Route ID Header Table on Outbound Monitoring Page$")
  public void searchRouteId() {
    long routeId = get(KEY_CREATED_ROUTE_ID);
    outboundMonitoringPage.searchTableByRouteId(routeId);
  }

  @Then("^Operator verify the route ID is exist on Outbound Monitoring Page$")
  public void verifyRouteIdExists() {
    long routeId = get(KEY_CREATED_ROUTE_ID);
    outboundMonitoringPage.searchTableByRouteId(routeId);
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
    retryIfAssertionErrorOccurred(outboundMonitoringPage::verifyStatusMarked,
        "Verify Status is Marked");
  }

  @And("^Operator click on comment icon on chosen route ID on Outbound Monitoring Page$")
  public void clickCommentButtonAndSubmit() {
    outboundMonitoringPage.clickCommentButtonAndSubmit();
  }

  @Then("^Operator verifies the comment table on the chosen route ID is changed$")
  public void verifyCommentIsRight() {
    outboundMonitoringPage.verifyCommentIsRight();
  }

  @When("^Operator select filter and click Load Selection on Outbound Monitoring page using data below:$")
  public void selectFiltersAndClickLoadSelection(Map<String, String> data) {
    data = resolveKeyValues(data);
    if (data.containsKey("zoneName")) {
      outboundMonitoringPage.zonesSelect.selectFilter(splitAndNormalize(data.get("zoneName")));
    }
    if (data.containsKey("hubName")) {
      outboundMonitoringPage.hubsSelect.selectFilter(splitAndNormalize(data.get("hubName")));
    }
    outboundMonitoringPage.loadSelection.clickAndWaitUntilDone();
  }

  @When("^Operator pull out order from route on Outbound Monitoring page$")
  public void pullOutOrderFromRoute() {
    Order order = get(KEY_CREATED_ORDER);
    long routeId = get(KEY_CREATED_ROUTE_ID);

    outboundMonitoringPage.pullOutOrderFromRoute(order, routeId);
  }
}
