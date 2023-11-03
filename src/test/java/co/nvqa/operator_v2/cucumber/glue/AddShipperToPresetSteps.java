package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.operator_v2.model.ShipperInfo;
import co.nvqa.operator_v2.selenium.page.AddShipperToPresetPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.Keys;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class AddShipperToPresetSteps extends AbstractSteps {

  private AddShipperToPresetPage addShipperToPresetPage;
  private static final String KEY_SELECTED_SHIPPER_INFO = "KEY_SELECTED_SHIPPER_INFO";
  private static final String KEY_LIST_OF_SHIPPER_INFO = "KEY_LIST_OF_SHIPPER_INFO";

  public AddShipperToPresetSteps() {
  }

  @Override
  public void init() {
    addShipperToPresetPage = new AddShipperToPresetPage(getWebDriver());
  }

  @When("Add Shipper To Preset page is loaded")
  public void movementManagementPageIsLoaded() {
    addShipperToPresetPage.switchTo();
    addShipperToPresetPage.waitUntilLoaded();
  }

  @When("Operator validates filter values on Add Shipper To Preset page using data below:")
  public void operatorValidatesFilterValues(Map<String, String> data) {
    data = resolveKeyValues(data);
    String value = data.get("shipperCreationDateFrom");
    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(addShipperToPresetPage.shipperCreationDateFilter.getValueFrom())
          .as("Shipper Creation Date from").isEqualTo(value);
    }
    value = data.get("shipperCreationDateTo");
    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(addShipperToPresetPage.shipperCreationDateFilter.getValueTo())
          .as("Shipper Creation Date to").isEqualTo(value);
    }
  }

  @When("Operator clicks Load Selection on Add Shipper To Preset page")
  public void operatorAppliesFiltersValues() {
    addShipperToPresetPage.loadSelection.clickAndWaitUntilDone();
    addShipperToPresetPage.waitUntilUpdated();
  }

  @When("Operator applies filters on Add Shipper To Preset page using data below:")
  public void operatorAppliesFiltersValues(Map<String, String> data) {
    data = resolveKeyValues(data);
    String shipperCreationDateFrom = data.get("shipperCreationDateFrom");
    String shipperCreationDateTo = data.get("shipperCreationDateTo");
    if (StringUtils.isNotBlank(shipperCreationDateFrom) && StringUtils
        .isNotBlank(shipperCreationDateTo)) {
      addShipperToPresetPage.shipperCreationDateFilter
          .setInterval(shipperCreationDateFrom, shipperCreationDateTo);
    } else if (StringUtils.isNotBlank(shipperCreationDateFrom)) {
      addShipperToPresetPage.shipperCreationDateFilter.setFrom(shipperCreationDateFrom);
    } else if (StringUtils.isNotBlank(shipperCreationDateTo)) {
      addShipperToPresetPage.shipperCreationDateFilter.setTo(shipperCreationDateTo);
    }
    addShipperToPresetPage.loadSelection.click();
  }

  @When("^Operator applies \"(.+)\" sorting to \"(.+)\" column on Add Shipper To Preset page$")
  public void operatorAppliesSorting(String direction, String columnName) {
    addShipperToPresetPage.shippersTable.sortColumn(columnName, direction);
  }

  @When("^Operator applies \"(.+)\" filter to \"(.+)\" column on Add Shipper To Preset page$")
  public void operatorAppliesFilter(String filter, String columnName) {
    filter = resolveValue(filter);
    String columnId = AddShipperToPresetPage.ShippersTable.COLUMN_IDS_BY_NAME
        .get(columnName.trim().toLowerCase());
    addShipperToPresetPage.shippersTable.filterByColumn(columnId, filter);
    addShipperToPresetPage.waitUntilUpdated();
  }

  @When("^Operator clear column filters on Add Shipper To Preset page$")
  public void operatorResetFilter() {
    addShipperToPresetPage.shippersTable.clearColumnFilters();
  }

  @When("Operator verify records on Add Shipper To Preset page using data below:")
  public void operatorVerifyRecords(List<Map<String, String>> listOfData) {
    List<ShipperInfo> actual = addShipperToPresetPage.shippersTable.readAllEntities();
    Assertions.assertThat(actual.size()).as("Number of records").isEqualTo(listOfData.size());
    for (Map<String, String> listOfDatum : listOfData) {
      Map<String, String> data = resolveKeyValues(listOfDatum);
      ShipperInfo expected = new ShipperInfo(data);
      if (StringUtils.startsWith(expected.getAddress(), "{")) {
        expected.setAddress(null);
      }
      actual.stream().filter(item ->
      {
        try {
          expected.compareWithActual(item);
          return true;
        } catch (Throwable ex) {
          return false;
        }
      }).findFirst().orElseThrow(
          () -> new AssertionError("Could not find a row with data " + expected.toMap()));
    }
  }

  @When("^Operator verify \"(.+)\" sorting is applied to \"(.+)\" column on Add Shipper To Preset page$")
  public void operatorVerifySorting(String direction, String columnName) {
    String columnId = AddShipperToPresetPage.ShippersTable.COLUMN_IDS_BY_NAME
        .get(columnName.trim().toLowerCase());
    List<String> actualValues = addShipperToPresetPage.shippersTable.readColumn(columnId);
    List<String> expectedValues = actualValues;
    if (direction.equalsIgnoreCase("up")) {
      Collections.sort(actualValues);
    } else {
      actualValues.sort(Collections.reverseOrder());
    }
    Assertions.assertThat(actualValues).as(f("values of %s column", columnName))
        .isEqualTo(expectedValues);
  }

  @When("Operator adds shipper to preset on Add Shipper To Preset page using data below:")
  public void operatorAddsShipperToPreset(Map<String, String> data) {
    data = resolveKeyValues(data);
    String shipperName = data.get("shipperName");
    if (StringUtils.isNotBlank(shipperName)) {
      addShipperToPresetPage.shippersTable
          .filterByColumn(AddShipperToPresetPage.ShippersTable.COLUMN_SHIPPER_NAME, shipperName);
    }
    operatorClicksSelectAllShown();
    addShipperToPresetPage.addToPreset.click();
    String presetName = data.get("presetName");
    addShipperToPresetPage.presetSelector.sendKeys(presetName + Keys.ENTER);
    pause3s();
  }

  @Then("Operator verifies wrong dates toast is shown on Add Shipper To Preset page")
  public void operatorVerifiesWrongDatesToast() {
    addShipperToPresetPage
        .verifyNotificationWithMessage("Date range cannot be greater than 7 days");
  }

  @Then("Operator clicks Select All Shown on Add Shipper To Preset page")
  public void operatorClicksSelectAllShown() {
    if (!addShipperToPresetPage.selectAllShown.isDisplayedFast()) {
      addShipperToPresetPage.dropdownTrigger.click();
    }
    addShipperToPresetPage.selectAllShown.click();
    addShipperToPresetPage.dropdownTrigger.click();
    pause500ms();
  }

  @Then("Operator clicks Deselect All Shown on Add Shipper To Preset page")
  public void operatorClicksDeselectAllShown() {
    if (!addShipperToPresetPage.deselectAllShown.isDisplayedFast()) {
      addShipperToPresetPage.dropdownTrigger.click();
    }
    addShipperToPresetPage.deselectAllShown.click();
    addShipperToPresetPage.dropdownTrigger.click();
    pause500ms();
  }

  @Then("Operator clicks Clear Current Selection on Add Shipper To Preset page")
  public void operatorClicksClearCurrentSelection() {
    if (!addShipperToPresetPage.clearCurrentSelection.isDisplayedFast()) {
      addShipperToPresetPage.dropdownTrigger.click();
    }
    addShipperToPresetPage.clearCurrentSelection.click();
  }

  @Then("Operator checks Show Only Selected on Add Shipper To Preset page")
  public void operatorChecksShowOnlySelected() {
    if (!addShipperToPresetPage.showOnlySelected.isDisplayedFast()) {
      addShipperToPresetPage.dropdownTrigger.click();
    }
    addShipperToPresetPage.showOnlySelected.check();
    addShipperToPresetPage.dropdownTrigger.click();
  }

  @Then("Operator unchecks Show Only Selected on Add Shipper To Preset page")
  public void operatorUnchecksShowOnlySelected() {
    addShipperToPresetPage.dropdownTrigger.click();
    addShipperToPresetPage.showOnlySelected.uncheck();
  }

  @Then("Operator verify all rows are selected on Add Shipper To Preset page")
  public void operatorVerifyAllRowsAreChecked() {
    int rowsCount = addShipperToPresetPage.shippersTable.getRowsCount();
    for (int i = 1; i <= rowsCount; i++) {
      Assertions.assertThat(addShipperToPresetPage.shippersTable.isRowSelected(i))
          .as("Is row" + i + " selected").isTrue();
    }
  }

  @Then("Operator verify all rows are unselected on Add Shipper To Preset page")
  public void operatorVerifyAllRowsAreUnselected() {
    int rowsCount = addShipperToPresetPage.shippersTable.getRowsCount();
    for (int i = 1; i <= rowsCount; i++) {
      Assertions.assertThat(addShipperToPresetPage.shippersTable.isRowSelected(i))
          .as("Is row" + i + " selected").isFalse();
    }
  }

  @Then("Operator selects row {int} on Add Shipper To Preset page")
  public void operatorSelectsRow(int rowIndex) {
    addShipperToPresetPage.shippersTable.selectRow(rowIndex);
    ShipperInfo shipperInfo = addShipperToPresetPage.shippersTable.readEntity(1);
    put(KEY_SELECTED_SHIPPER_INFO, shipperInfo);
  }

  @Then("Operator saves displayed shipper results")
  public void operatorSaveDisplayedShipperResult() {
    List<ShipperInfo> shipperResults = addShipperToPresetPage.shippersTable.readAllEntities();
    put(KEY_LIST_OF_SHIPPER_INFO, shipperResults);
  }

  @When("Operator clicks Download CSV button on Add Shipper To Preset page")
  public void operatorClicksDownloadCsv() {
    addShipperToPresetPage.downloadCsv.click();
  }

  @When("Operator verify that CSV file contains all Shippers currently being shown on Add Shipper To Preset page")
  public void operatorVerifyCsvFile() {
    List<ShipperInfo> expected = get(KEY_LIST_OF_SHIPPER_INFO);
    String fileName = addShipperToPresetPage
        .getLatestDownloadedFilename("add-shipper-to-preset.csv");
    addShipperToPresetPage.verifyFileDownloadedSuccessfully(fileName);
    String pathName = StandardTestConstants.TEMP_DIR + fileName;
    List<ShipperInfo> actual = ShipperInfo
        .fromCsvFile(ShipperInfo.class, pathName, true);
    FileUtils.deleteQuietly(new File(pathName));

    Assertions.assertThat(actual.size())
        .as("number of lines in CSV")
        .isGreaterThanOrEqualTo(expected.size());

    for (int i = 0; i < expected.size(); i++) {
      expected.get(i).compareWithActual("Shipper Result " + (i + 1), actual.get(i));
    }
  }

  @When("Operator verify that CSV file have same line count as shown rows on Add Shipper To Preset page")
  public void operatorVerifyCsvFileLenghth() {
    String tableStatsText = addShipperToPresetPage.tableStats.getText();
    Pattern pattern = Pattern.compile("(Showing )(.*?)( of )(.*?)( results)");
    Matcher matcher = pattern.matcher(tableStatsText);
    int showing = 0;
    if (matcher.find()) {
      showing = Integer.parseInt(matcher.group(2));
    }

    String fileName = addShipperToPresetPage
        .getLatestDownloadedFilename("add-shipper-to-preset.csv");
    addShipperToPresetPage.verifyFileDownloadedSuccessfully(fileName);
    String pathName = StandardTestConstants.TEMP_DIR + fileName;
    List<ShipperInfo> actual = ShipperInfo
        .fromCsvFile(ShipperInfo.class, pathName, true);
    FileUtils.deleteQuietly(new File(pathName));

    Assertions.assertThat(actual).as("Number of lines in CSV match displayed rows")
        .hasSizeGreaterThanOrEqualTo(showing);
  }
}
