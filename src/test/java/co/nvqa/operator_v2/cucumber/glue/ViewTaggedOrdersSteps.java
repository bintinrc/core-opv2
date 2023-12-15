package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.TaggedOrderParams;
import co.nvqa.operator_v2.selenium.page.ViewTaggedOrdersPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.When;
import java.util.Map;
import org.assertj.core.api.Assertions;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class ViewTaggedOrdersSteps extends AbstractSteps {

  private ViewTaggedOrdersPage page;

  public ViewTaggedOrdersSteps() {
  }

  @Override
  public void init() {
    page = new ViewTaggedOrdersPage(getWebDriver());
  }

  @When("Operator selects filter and clicks Load Selection on View Tagged Orders page:")
  public void selectFilterAndClicksLoadSelectionOnViewTaggedOrders(Map<String, String> data) {
    var finalData = resolveKeyValues(data);
    page.inFrame(() -> {
      page.loadSelection.waitUntilVisible(120);
      page.clearSelection.click();
      if (finalData.containsKey("orderTags")) {
        page.orderTagsFilter.selectValues(splitAndNormalize(finalData.get("orderTags")));
      }

      if (finalData.containsKey("granularStatus")) {
        page.granularStatusFilter.selectValues(splitAndNormalize(finalData.get("granularStatus")));
      }

      page.loadSelection.click();
      page.waitUntilLoaded();
    });
  }


  @And("Operator verifies tagged order params on View Tagged Orders page:")
  public void operatorVerifyTaggedOrderParams(Map<String, String> data) {
    data = resolveKeyValues(data);
    TaggedOrderParams expected = new TaggedOrderParams(data);
    page.inFrame(() -> {
      page.taggedOrdersTable.filterByColumn("trackingId", expected.getTrackingId());
      Assertions.assertThat(page.taggedOrdersTable.isEmpty())
          .as("Tagged orders table is empty")
          .isFalse();
      TaggedOrderParams actual = page.taggedOrdersTable.readEntity(1);
      expected.compareWithActual(actual);
    });
  }

}