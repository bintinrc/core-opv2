package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.DriverPerformanceInfo;
import co.nvqa.operator_v2.model.DriverPerformancePreset;
import co.nvqa.operator_v2.selenium.page.DriverPerformancePage;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;

import static co.nvqa.operator_v2.selenium.page.DriverPerformancePage.DriverPerformanceTable.COLUMN_DRIVER_NAME;
import static co.nvqa.operator_v2.selenium.page.DriverPerformancePage.DriverPerformanceTable.COLUMN_HUB;
import static co.nvqa.operator_v2.selenium.page.DriverPerformancePage.DriverPerformanceTable.COLUMN_ROUTE_DATE;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class DriverPerformanceSteps extends AbstractSteps {

  public static final String KEY_CREATED_DRIVER_PERFORMANCE_PRESET = "KEY_CREATED_DRIVER_PERFORMANCE_PRESET";

  private DriverPerformancePage driverPerformancePage;

  public DriverPerformanceSteps() {
  }

  @Override
  public void init() {
    driverPerformancePage = new DriverPerformancePage(getWebDriver());
  }

  @When("Driver Performance page is loaded")
  public void operatorMovementTripPageIsLoaded() {
    driverPerformancePage.switchTo();
    driverPerformancePage.waitUntilLoaded();
  }

  @When("Operator clicks Show\\Hide Filters on Driver Performance page")
  public void clickShowHideFilters() {
    driverPerformancePage.showHideFilters.click();
  }

  @Then("Operator verifies Filters form is hidden on Driver Performance page")
  public void checkFiltersHidden() {
    Assertions.assertThat(driverPerformancePage.filtersForm.waitUntilInvisible(5))
        .as("Filters form is hidden").isTrue();
  }

  @Then("Operator verifies Filters form is displayed on Driver Performance page")
  public void checkFiltersDisplayed() {
    Assertions.assertThat(driverPerformancePage.filtersForm.waitUntilVisible(5))
        .as("Filters form is displayed").isTrue();
  }

  @Then("Operator verifies Route Date range is {int} days on Driver Performance page")
  public void checkRouteRange(long range) {
    String startDateVal = driverPerformancePage.filtersForm.routeDate.fromInput.getValue();
    String endDateVal = driverPerformancePage.filtersForm.routeDate.toInput.getValue();
    Assertions.assertThat(
            ChronoUnit.DAYS.between(LocalDate.parse(startDateVal), LocalDate.parse(endDateVal)))
        .as("Route Date range").isEqualTo(range);
  }

  @Then("Operator verifies Load Selection button is disabled on Driver Performance page")
  public void checkLoadSelectionDisabled() {
    Assertions.assertThat(driverPerformancePage.filtersForm.loadSelection.isEnabled())
        .as("Load Selection button is enabled").isFalse();
  }

  @Then("Operator verifies Load Selection button is enabled on Driver Performance page")
  public void checkLoadSelectionEnabled() {
    Assertions.assertThat(driverPerformancePage.filtersForm.loadSelection.isEnabled())
        .as("Load Selection button is enabled").isTrue();
  }

  @Then("Operator clicks Load Selection button on Driver Performance page")
  public void clickLoadSelection() {
    driverPerformancePage.filtersForm.loadSelection.click();
    if (driverPerformancePage.spinner.waitUntilVisible(5)) {
      driverPerformancePage.spinner.waitUntilInvisible();
    }
  }

  @Then("Operator clicks Clear Selection button on Driver Performance page")
  public void clickClearSelection() {
    driverPerformancePage.filtersForm.clearSelection.click();
  }

  @Then("Operator clicks 'Go back to previous page' button on Driver Performance page")
  public void clickGoToPreviousPageButton() {
    driverPerformancePage.goToPreviousPage.click();
  }

  @Then("Operator select following filters on Driver Performance page:")
  public void selectFilters(Map<String, String> data) {
    data = resolveKeyValues(data);
    String fromDate = data.get("routeDateFrom");
    String toDate = data.get("routeDateTo");
    if (StringUtils.isNotBlank(fromDate) && StringUtils.isNotBlank(toDate)) {
      driverPerformancePage.filtersForm.routeDate.setDateRange(fromDate, toDate);
    } else if (StringUtils.isNotBlank(fromDate)) {
      driverPerformancePage.filtersForm.routeDate.setFromDate(fromDate);
    } else if (StringUtils.isNotBlank(toDate)) {
      driverPerformancePage.filtersForm.routeDate.setToDate(toDate);
    }
    String value = data.get("displayIndividualRows");
    if (StringUtils.isNotBlank(value)) {
      driverPerformancePage.filtersForm.displayIndividualRows.setValue(value);
    }
    value = data.get("hubs");
    if (StringUtils.isNotBlank(value)) {
      driverPerformancePage.filtersForm.hubsFilter.clearAll();
      driverPerformancePage.filtersForm.hubsFilter.selectFilter(value);
    }
    value = data.get("driverNames");
    if (StringUtils.isNotBlank(value)) {
      driverPerformancePage.filtersForm.driverNameFilter.clearAll();
      driverPerformancePage.filtersForm.driverNameFilter.selectFilter(value);
    }
    value = data.get("driverTypes");
    if (StringUtils.isNotBlank(value)) {
      driverPerformancePage.filtersForm.driverTypesFilter.clearAll();
      driverPerformancePage.filtersForm.driverTypesFilter.selectFilter(value);
    }
  }

  @Then("Operator creates new preset on Driver Performance page:")
  public void createPreset(Map<String, String> data) {
    selectFilters(data);
    DriverPerformancePreset preset = new DriverPerformancePreset(resolveKeyValues(data));
    if (StringUtils.equalsIgnoreCase("GENERATED", preset.getName())) {
      preset.setName("TEST-" + TestUtils.generateDateUniqueString());
    }
    driverPerformancePage.filtersForm.createModifyPreset.click();
    driverPerformancePage.filtersForm.saveAsPreset.click();
    driverPerformancePage.saveAsPresetModal.waitUntilVisible();
    driverPerformancePage.saveAsPresetModal.presetName.setValue(preset.getName());
    driverPerformancePage.saveAsPresetModal.save.click();
    put(KEY_CREATED_DRIVER_PERFORMANCE_PRESET, preset);
  }

  @Then("Operator opens Save As Preset modal on Driver Performance page")
  public void openSaveAsPresetModal() {
    driverPerformancePage.filtersForm.createModifyPreset.click();
    driverPerformancePage.filtersForm.saveAsPreset.click();
  }

  @Then("Operator updates preset on Driver Performance page")
  public void updatePreset() {
    driverPerformancePage.filtersForm.createModifyPreset.click();
    driverPerformancePage.filtersForm.updateCurrentPreset.click();
    driverPerformancePage.updatePresetModal.waitUntilVisible();
    driverPerformancePage.updatePresetModal.confirm.click();
  }

  @Then("Operator deletes preset on Driver Performance page")
  public void deletePreset() {
    driverPerformancePage.filtersForm.createModifyPreset.click();
    driverPerformancePage.filtersForm.deletePreset.click();
    driverPerformancePage.deletePresetModal.waitUntilVisible();
    driverPerformancePage.deletePresetModal.confirm.click();
  }

  @Then("Operator verifies {string} preset was deleted on Driver Performance page")
  public void verifyPresetDeleted(String presetName) {
    presetName = resolveValue(presetName);
    Assertions.assertThat(driverPerformancePage.filtersForm.selectPreset.hasItem(presetName))
        .as("List of presets contains value " + presetName).isFalse();
  }

  @Then("Operator enters {string} name in Save As Preset modal")
  public void openSaveAsPresetModal(String name) {
    driverPerformancePage.saveAsPresetModal.waitUntilVisible();
    driverPerformancePage.saveAsPresetModal.presetName.setValue(resolveValue(name));
  }

  @Then("Operator verifies Save button is disabled in Save As Preset modal")
  public void verifySaveButtonIsDisabled() {
    Assertions.assertThat(driverPerformancePage.saveAsPresetModal.save.isEnabled())
        .as("Save button is enabled").isFalse();
  }

  @Then("Operator verifies {string} error message is displayed in Save As Preset modal")
  public void verifyErrorMessage(String message) {
    Assertions.assertThat(driverPerformancePage.saveAsPresetModal.errorMessage.isDisplayed())
        .as("Error message is displayed").isTrue();
    Assertions.assertThat(driverPerformancePage.saveAsPresetModal.errorMessage.getNormalizedText())
        .as("Error message").isEqualTo(resolveValue(message));
  }

  @Then("Operator selects {string} preset on Driver Performance page")
  public void createPreset(String presetName) {
    presetName = resolveValue(presetName);
    driverPerformancePage.filtersForm.selectPreset.selectValue(presetName);
  }

  @Then("Operator verifies selected filters on Driver Performance page:")
  public void verifyFilters(Map<String, String> data) {
    DriverPerformancePreset expected = new DriverPerformancePreset(resolveKeyValues(data));
    DriverPerformancePreset actual = new DriverPerformancePreset();
    actual.setHubs(driverPerformancePage.filtersForm.hubsFilter.getSelectedValues());
    actual.setDriverNames(driverPerformancePage.filtersForm.driverNameFilter.getSelectedValues());
    actual.setDriverTypes(driverPerformancePage.filtersForm.driverTypesFilter.getSelectedValues());
    expected.compareWithActual(actual);
  }

  @Then("Operator verifies Driver Performance record on Driver Performance page:")
  public void verifyTableEntry(Map<String, String> data) {
    DriverPerformanceInfo expected = filterDriverPerformanceTable(data);
    DriverPerformanceInfo actual = driverPerformancePage.driverPerformanceTable.readEntity(1);
    expected.compareWithActual(actual);
  }

  @Then("Operator verifies Driver Performance records on Driver Performance page:")
  public void verifyTableEntries(List<Map<String, String>> data) {
    data.forEach(this::verifyTableEntry);
  }

  private DriverPerformanceInfo filterDriverPerformanceTable(Map<String, String> data) {
    DriverPerformanceInfo expected = new DriverPerformanceInfo(resolveKeyValues(data));
    if (StringUtils.isNotBlank(expected.getDriverName())) {
      driverPerformancePage.driverPerformanceTable
          .filterByColumn(COLUMN_DRIVER_NAME, expected.getDriverName());
    }
    if (StringUtils.isNotBlank(expected.getHub())) {
      driverPerformancePage.driverPerformanceTable.filterByColumn(COLUMN_HUB, expected.getHub());
    }
    if (StringUtils.isNotBlank(expected.getRouteDate())) {
      driverPerformancePage.driverPerformanceTable
          .filterByColumn(COLUMN_ROUTE_DATE, expected.getRouteDate());
    }
    return expected;
  }

  @Then("Operator opens individual route date view on Driver Performance page using data below:")
  public void openIndividualRouteDateView(Map<String, String> data) {
    filterDriverPerformanceTable(data);
    driverPerformancePage.driverPerformanceTable.aggregatedButton.get(0).click();
    if (driverPerformancePage.spinner.waitUntilVisible(5)) {
      driverPerformancePage.spinner.waitUntilInvisible();
    }
  }
}
