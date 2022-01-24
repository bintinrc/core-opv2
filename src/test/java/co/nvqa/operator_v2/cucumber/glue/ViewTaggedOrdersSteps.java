package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.TaggedOrderParams;
import co.nvqa.operator_v2.selenium.page.ViewTaggedOrdersPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.Map;
import org.assertj.core.api.Assertions;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class ViewTaggedOrdersSteps extends AbstractSteps {

  private ViewTaggedOrdersPage viewTaggedOrdersPage;

  public ViewTaggedOrdersSteps() {
  }

  @Override
  public void init() {
    viewTaggedOrdersPage = new ViewTaggedOrdersPage(getWebDriver());
  }

  @When("^Operator selects filter and clicks Load Selection on View Tagged Orders page:$")
  public void operatorSelectsFilterAndClicksLoadSelectionOnViewTaggedOrdersUsingDataBelow(
      Map<String, String> data) {
    data = resolveKeyValues(data);

    viewTaggedOrdersPage.loadSelection.waitUntilVisible();

    if (data.containsKey("orderTags")) {
      List<String> tags = splitAndNormalize(data.get("orderTags"));
      viewTaggedOrdersPage.orderTagsFilter.clearAll();
      viewTaggedOrdersPage.orderTagsFilter.selectFilter(tags);
    }

    if (data.containsKey("granularStatus")) {
      viewTaggedOrdersPage.granularStatusFilter.clearAll();
      viewTaggedOrdersPage.granularStatusFilter.selectFilter(data.get("granularStatus"));
    } else {
      if (viewTaggedOrdersPage.granularStatusFilter.isDisplayedFast()) {
        viewTaggedOrdersPage.granularStatusFilter.clearAll();
      }
    }

    viewTaggedOrdersPage.loadSelection.click();
  }


  @And("Operator verifies tagged order params on View Tagged Orders page:")
  public void operatorVerifyTaggedOrderParams(Map<String, String> data) {
    data = resolveKeyValues(data);
    TaggedOrderParams expected = new TaggedOrderParams(data);
    viewTaggedOrdersPage.taggedOrdersTable.filterByColumn("trackingId", expected.getTrackingId());
    Assertions.assertThat(viewTaggedOrdersPage.taggedOrdersTable.isEmpty())
        .as("Tagged orders table is empty")
        .isFalse();
    TaggedOrderParams actual = viewTaggedOrdersPage.taggedOrdersTable.readEntity(1);
    expected.compareWithActual(actual);
    takesScreenshot();
  }

}