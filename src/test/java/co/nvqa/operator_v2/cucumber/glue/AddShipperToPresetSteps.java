package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.ShipperInfo;
import co.nvqa.operator_v2.selenium.page.AddShipperToPresetPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.Keys;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class AddShipperToPresetSteps extends AbstractSteps {

  private AddShipperToPresetPage addShipperToPresetPage;
  private static final String KEY_SELECTED_SHIPPER_INFO = "KEY_SELECTED_SHIPPER_INFO";

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
      assertEquals("Shipper Creation Date from", value,
          addShipperToPresetPage.shipperCreationDateFilter.getValueFrom());
    }
    value = data.get("shipperCreationDateTo");
    if (StringUtils.isNotBlank(value)) {
      assertEquals("Shipper Creation Date to", value,
          addShipperToPresetPage.shipperCreationDateFilter.getValueTo());
    }
  }

  @When("Operator clicks Load Selection on Add Shipper To Preset page")
  public void operatorAppliesFiltersValues() {
    addShipperToPresetPage.loadSelection.click();
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

  @When("Operator applies \"(.+)\" sorting to \"(.+)\" column on Add Shipper To Preset page")
  public void operatorAppliesSorting(String direction, String columnName) {
    addShipperToPresetPage.shippersTable.sortColumn(columnName, direction);
  }

  @When("Operator applies \"(.+)\" filter to \"(.+)\" column on Add Shipper To Preset page")
  public void operatorAppliesFilter(String filter, String columnName) {
    filter = resolveValue(filter);
    String columnId = AddShipperToPresetPage.ShippersTable.COLUMN_IDS_BY_NAME
        .get(columnName.trim().toLowerCase());
    addShipperToPresetPage.shippersTable.filterByColumn(columnId, filter);
  }

  @When("Operator verify records on Add Shipper To Preset page using data below:")
  public void operatorVerifyRecords(List<Map<String, String>> listOfData) {
    List<ShipperInfo> actual = addShipperToPresetPage.shippersTable.readAllEntities();
    assertEquals("Number of records", listOfData.size(), actual.size());
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

  @When("Operator verify \"(.+)\" sorting is applied to \"(.+)\" column on Add Shipper To Preset page")
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
    assertEquals(f("values of %s column", columnName), expectedValues, actualValues);
  }

  @When("Operator adds shipper to preset on Add Shipper To Preset page using data below:")
  public void operatorAddsShipperToPreset(Map<String, String> data) {
    data = resolveKeyValues(data);
    String shipperName = data.get("shipperName");
    if (StringUtils.isNotBlank(shipperName)) {
      addShipperToPresetPage.shippersTable
          .filterByColumn(AddShipperToPresetPage.ShippersTable.COLUMN_SHIPPER_NAME, shipperName);
    }
    int rowsCount = addShipperToPresetPage.shippersTable.getRowsCount();
    for (int i = 1; i <= rowsCount; i++) {
      addShipperToPresetPage.shippersTable.selectRow(i);
    }
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
    addShipperToPresetPage.dropdownTrigger.click();
    addShipperToPresetPage.selectAllShown.click();
  }

  @Then("Operator clicks Deselect All Shown on Add Shipper To Preset page")
  public void operatorClicksDeselectAllShown() {
    addShipperToPresetPage.dropdownTrigger.click();
    addShipperToPresetPage.deselectAllShown.click();
  }

  @Then("Operator clicks Clear Current Selection on Add Shipper To Preset page")
  public void operatorClicksClearCurrentSelection() {
    addShipperToPresetPage.dropdownTrigger.click();
    addShipperToPresetPage.clearCurrentSelection.click();
  }

  @Then("Operator checks Show Only Selected on Add Shipper To Preset page")
  public void operatorChecksShowOnlySelected() {
    addShipperToPresetPage.dropdownTrigger.click();
    addShipperToPresetPage.showOnlySelected.check();
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
      assertTrue("Is row" + i + " selected", addShipperToPresetPage.shippersTable.isRowSelected(i));
    }
  }

  @Then("Operator verify all rows are unselected on Add Shipper To Preset page")
  public void operatorVerifyAllRowsAreUnselected() {
    int rowsCount = addShipperToPresetPage.shippersTable.getRowsCount();
    for (int i = 1; i <= rowsCount; i++) {
      assertFalse("Is row" + i + " selected",
          addShipperToPresetPage.shippersTable.isRowSelected(i));
    }
  }

  @Then("Operator selects row {int} on Add Shipper To Preset page")
  public void operatorSelectsRow(int rowIndex) {
    addShipperToPresetPage.shippersTable.selectRow(rowIndex);
    ShipperInfo shipperInfo = addShipperToPresetPage.shippersTable.readEntity(1);
    put(KEY_SELECTED_SHIPPER_INFO, shipperInfo);
  }
}
