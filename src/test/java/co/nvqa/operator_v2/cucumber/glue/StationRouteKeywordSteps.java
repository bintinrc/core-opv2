package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.StationRouteKeywordPage;
import co.nvqa.operator_v2.selenium.page.StationRouteKeywordPage.Coverage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.When;
import java.util.Map;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;

import static co.nvqa.operator_v2.selenium.page.StationRouteKeywordPage.AreasTable.COLUMN_AREA;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class StationRouteKeywordSteps extends AbstractSteps {

  private StationRouteKeywordPage page;

  public StationRouteKeywordSteps() {
  }

  @Override
  public void init() {
    page = new StationRouteKeywordPage(getWebDriver());
  }

  @When("Operator selects {value} hub on Station Route Keyword page")
  public void selectHub(String hubName) {
    retryIfRuntimeExceptionOccurred(() -> page.inFrame(() -> {
      page.waitUntilLoaded(3, 60);
      page.hub.selectValue(hubName);
    }), 2);
  }

  @When("Operator create new coverage on Station Route Keyword page:")
  public void createNewCoverage(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    page.inFrame(() -> {
      page.createNewCoverage.click();
      page.createNewCoverageDialog.waitUntilVisible();
      if (finalData.containsKey("area")) {
        page.createNewCoverageDialog.area.setValue(finalData.get("area"));
      }
      if (finalData.containsKey("areaVariation")) {
        page.createNewCoverageDialog.areaVariation.setValue(finalData.get("areaVariation"));
      }
      if (finalData.containsKey("keyword")) {
        page.createNewCoverageDialog.keyword.setValue(finalData.get("keyword"));
      }
      if (finalData.containsKey("primaryDriver")) {
        page.createNewCoverageDialog.primaryDriver.selectValue(finalData.get("primaryDriver"));
      }
      if (finalData.containsKey("fallbackDriver")) {
        page.createNewCoverageDialog.fallbackDriver.selectValue(finalData.get("fallbackDriver"));
      }
      page.createNewCoverageDialog.add.click();
    });
  }

  @When("Operator verify data on New coverage created dialog:")
  public void verifyNewCoverageCreated(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    SoftAssertions assertions = new SoftAssertions();
    page.inFrame(() -> {
      page.waitUntilLoaded(2);
      page.newCoverageCreatedDialog.waitUntilVisible();
      if (finalData.containsKey("area")) {
        assertions.assertThat(page.newCoverageCreatedDialog.area.getText())
            .as("Area")
            .isEqualTo(finalData.get("area"));
      }
      if (finalData.containsKey("primaryDriver")) {
        assertions.assertThat(page.newCoverageCreatedDialog.primaryDriver.getText())
            .as("Primary Driver")
            .isEqualTo(finalData.get("primaryDriver"));
      }
      if (finalData.containsKey("fallbackDriver")) {
        assertions.assertThat(page.newCoverageCreatedDialog.fallbackDriver.getText())
            .as("Fallback Driver")
            .isEqualTo(finalData.get("fallbackDriver"));
      }
      if (finalData.containsKey("keywords")) {
        assertions.assertThat(
                page.newCoverageCreatedDialog.keywords.stream().map(PageElement::getText).collect(
                    Collectors.toList()))
            .as("Keywords")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(finalData.get("keywords")));
      }
    });
    assertions.assertAll();
  }

  @When("Operator close New coverage created dialog")
  public void closeNewCoverageCreated() {
    page.inFrame(() -> page.newCoverageCreatedDialog.close.click());
  }

  @When("Operator verify coverage displayed on Station Route Keyword page:")
  public void verifyCoverageDisplayed(Map<String, String> data) {
    Coverage expected = new Coverage(resolveKeyValues(data));
    page.inFrame(() -> {
      page.areasTable.filterByColumn(COLUMN_AREA, expected.getArea());
      Assertions.assertThat(page.areasTable.getRowsCount())
          .withFailMessage("Coverage is not displayed: " + expected)
          .isPositive();
      Coverage actual = page.areasTable.readEntity(1);
      expected.compareWithActual(actual);
    });
  }
}
