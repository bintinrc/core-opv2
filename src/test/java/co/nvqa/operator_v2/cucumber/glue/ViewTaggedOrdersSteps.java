package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.TaggedOrderParams;
import co.nvqa.operator_v2.selenium.page.ViewTaggedOrdersPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.List;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class ViewTaggedOrdersSteps extends AbstractSteps {

  private ViewTaggedOrdersPage viewTaggedOrdersSteps;

  public ViewTaggedOrdersSteps() {
  }

  @Override
  public void init() {
    viewTaggedOrdersSteps = new ViewTaggedOrdersPage(getWebDriver());
  }

  @When("^Operator selects filter and clicks Load Selection on View Tagged Orders page:$")
  public void operatorSelectsFilterAndClicksLoadSelectionOnViewTaggedOrdersUsingDataBelow(
      Map<String, String> data) {
    data = resolveKeyValues(data);

    viewTaggedOrdersSteps.loadSelection.waitUntilVisible();

    if (data.containsKey("orderTags")) {
      List<String> tags = splitAndNormalize(data.get("orderTags"));
      viewTaggedOrdersSteps.orderTagsFilter.clearAll();
      viewTaggedOrdersSteps.orderTagsFilter.selectFilter(tags);
    }

    if (data.containsKey("granularStatus")) {
      viewTaggedOrdersSteps.granularStatusFilter.clearAll();
      viewTaggedOrdersSteps.granularStatusFilter.selectFilter(data.get("granularStatus"));
    } else {
      if (viewTaggedOrdersSteps.granularStatusFilter.isDisplayedFast()) {
        viewTaggedOrdersSteps.granularStatusFilter.clearAll();
      }
    }

    viewTaggedOrdersSteps.loadSelection.click();
  }


  @And("^Operator verifies tagged order params on View Tagged Orders page:")
  public void operatorVerifyTaggedOrderParams(Map<String, String> data) {
    data = resolveKeyValues(data);
    TaggedOrderParams expected = new TaggedOrderParams(data);
    viewTaggedOrdersSteps.taggedOrdersTable.filterByColumn("trackingId", expected.getTrackingId());
    TaggedOrderParams actual = viewTaggedOrdersSteps.taggedOrdersTable.readEntity(1);
    expected.compareWithActual(actual);
  }

}