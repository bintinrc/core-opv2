package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.DriverInfo;
import co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.util.List;
import java.util.Map;
import org.hamcrest.Matchers;

import static co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2.DriversTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2.DriversTable.COLUMN_RESIGNED;
import static co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2.DriversTable.COLUMN_TYPE;
import static co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2.DriversTable.COLUMN_USERNAME;
import static co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2.DriversTable.COLUMN_ZONE;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class DriverStrengthStepsV2 extends AbstractSteps {

  private DriverStrengthPageV2 dsPage;
  private static final String KEY_INITIAL_COMING_VALUE = "KEY_INITIAL_COMING_VALUE";

  public DriverStrengthStepsV2() {
  }

  @Override
  public void init() {
    dsPage = new DriverStrengthPageV2(getWebDriver());
  }

  @When("^Operator create new Driver on Driver Strength page using data below:$")
  public void operatorCreateNewDriverOnDriverStrengthPageUsingDataBelow(
      Map<String, String> data) {
    DriverInfo driverInfo = new DriverInfo(resolveKeyValues(data));
    put(KEY_CREATED_DRIVER_INFO, driverInfo);
    dsPage.addNewDriver(driverInfo);
  }

  @When("^Operator opens Add Driver dialog on Driver Strength$")
  public void operatorOpensAddDriverDialog() {
    dsPage.addNewDriver.click();
    dsPage.addDriverDialog.waitUntilVisible();
  }

  @When("^Operator fill Add Driver form on Driver Strength page using data below:$")
  public void operatorFillAddDriverOnDriverStrengthPageUsingDataBelow(
      Map<String, String> mapOfData) {
    DriverInfo driverInfo = new DriverInfo(resolveKeyValues(mapOfData));
    put(KEY_CREATED_DRIVER_INFO, driverInfo);
    dsPage.addDriverDialog.fillForm(driverInfo);
  }

  @When("Operator verifies Submit button in Add Driver dialog is disabled")
  public void operatorVerifiesSubmitButtonState() {
    assertFalse("Submit button is enabled", dsPage.addDriverDialog.submit.isEnabled());
  }

  @When("Operator verifies hint {string} is displayed in Add Driver dialog")
  public void operatorVerifiesAddDriverHint(String expected) {
    expected = resolveValue(expected);
    assertTrue("Hint is displayed", dsPage.addDriverDialog.hints.isDisplayed());
    assertEquals("Hint text", expected, dsPage.addDriverDialog.hints.getNormalizedText());
  }

  @When("^Operator edit created Driver on Driver Strength page using data below:$")
  public void operatorEditCreatedDriverOnDriverStrengthPageUsingDataBelow(
      Map<String, String> mapOfData) {
    DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
    String username = driverInfo.getUsername();
    driverInfo.fromMap(mapOfData);
    dsPage.editDriver(username, driverInfo);
  }

  @When("Operator removes contact details on Edit Driver dialog on Driver Strength page")
  public void operatorRemoveContactDetails() {
    if (dsPage.editDriverDialog.contactsSettingsForms.size() > 0) {
      dsPage.editDriverDialog.contactsSettingsForms.forEach(form -> form.remove.click());
    }
  }

  @When("Operator removes vehicle details on Edit Driver dialog on Driver Strength page")
  public void operatorRemoveVehicleDetails() {
    if (dsPage.editDriverDialog.vehicleSettingsForm.size() > 0) {
      dsPage.editDriverDialog.vehicleSettingsForm.forEach(form -> form.remove.click());
    }
  }

  @When("Operator removes zone preferences on Edit Driver dialog on Driver Strength page")
  public void operatorRemoveZonePreference() {
    if (dsPage.editDriverDialog.zoneSettingsForms.size() > 0) {
      dsPage.editDriverDialog.zoneSettingsForms.forEach(form -> form.remove.click());
    }
  }

  @When("Operator opens Edit Driver dialog for created driver on Driver Strength page")
  public void operatorOpensEditDriverDialogOnDriverStrengthPage() {
    DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
    String username = driverInfo.getUsername();
    dsPage.filterBy(COLUMN_USERNAME, username);
    dsPage.driversTable.clickActionButton(1, ACTION_EDIT);
    dsPage.editDriverDialog.waitUntilVisible();
  }

  @Then("^Operator verify driver strength params of created driver on Driver Strength page$")
  public void dbOperatorVerifyDriverIsCreatedSuccessfully() {
    DriverInfo expectedDriverInfo = get(KEY_CREATED_DRIVER_INFO);
    dsPage.verifyDriverInfo(expectedDriverInfo);
  }

  @Then("^Operator verify contact details of created driver on Driver Strength page$")
  public void dbOperatorVerifyContactDetailsOfCreatedDriver() {
    DriverInfo expectedDriverInfo = get(KEY_CREATED_DRIVER_INFO);
    dsPage.verifyContactDetails(expectedDriverInfo.getUsername(), expectedDriverInfo);
  }

  @When("^Operator filter driver strength by \"([^\"]*)\" zone$")
  public void operatorFilterDriverStrengthByZone(String zone) {
    if ("GET_FROM_CREATED_DRIVER".equalsIgnoreCase(zone)) {
      DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
      zone = driverInfo.getZoneId();
    }
    dsPage.filterBy(COLUMN_ZONE, zone);
  }

  @When("^Operator filter driver strength by \"([^\"]*)\" driver type")
  public void operatorFilterDriverStrengthByDriverType(String driverType) {
    if ("GET_FROM_CREATED_DRIVER".equalsIgnoreCase(driverType)) {
      DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
      driverType = driverInfo.getType();
    }
    dsPage.filterBy(COLUMN_TYPE, driverType);
  }

  @When("Operator click Load Everything on Driver Strength page")
  public void operatorClickLoadEverything() {
    dsPage.loadEverything();
  }

  @When("Operator filter driver strength using data below:")
  public void operatorFilterDriverStrengthUsingDataBelow(Map<String, String> data) {
    data = resolveKeyValues(data);

    if (dsPage.editSearchFilter.isDisplayedFast()) {
      dsPage.editSearchFilter.click();
    }

    dsPage.addFilter.waitUntilClickable();

    if (data.containsKey("zones")) {
      if (!dsPage.zonesFilter.isDisplayedFast()) {
        dsPage.addFilter("Zones");
      }
      List<String> tags = splitAndNormalize(data.get("zones"));
      dsPage.zonesFilter.clearAll();
      dsPage.zonesFilter.selectFilter(tags);
    }

    if (data.containsKey("driverTypes")) {
      if (!dsPage.driverTypesFilter.isDisplayedFast()) {
        dsPage.addFilter("Driver Types");
      }
      List<String> tags = splitAndNormalize(data.get("driverTypes"));
      dsPage.driverTypesFilter.clearAll();
      dsPage.driverTypesFilter.selectFilter(tags);
    }

    if (data.containsKey("resigned")) {
      if (!dsPage.resignedFilter.isDisplayedFast()) {
        dsPage.addFilter("Resigned");
      }
      dsPage.resignedFilter.setFilter(data.get("resigned").toLowerCase());
    }

    if (dsPage.loadSelection.isDisplayedFast()) {
      dsPage.loadSelection();
    } else {
      dsPage.loadEverything();
    }
  }

  @Then("^Operator verify driver strength is filtered by \"([^\"]*)\" zone$")
  public void operatorVerifyDriverStrengthIsFilteredByZone(String expectedZone) {
    if ("GET_FROM_CREATED_DRIVER".equalsIgnoreCase(expectedZone)) {
      DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
      expectedZone = driverInfo.getZoneId();
    }
    List<String> actualZones = dsPage.driversTable().readFirstRowsInColumn(COLUMN_ZONE, 10);
    assertThat("Driver Strength records list", actualZones, not(empty()));
    assertThat("Zone values", actualZones, Matchers.everyItem(containsString(expectedZone)));
  }

  @Then("^Operator verify driver strength is filtered by \"([^\"]*)\" driver type")
  public void operatorVerifyDriverStrengthIsFilteredByDriverType(String expectedDriverType) {
    if ("GET_FROM_CREATED_DRIVER".equalsIgnoreCase(expectedDriverType)) {
      DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
      expectedDriverType = driverInfo.getType();
    }
    List<String> actualDriverTypes = dsPage.driversTable().readFirstRowsInColumn(COLUMN_TYPE, 10);
    assertThat("Driver Strength records list", actualDriverTypes, not(empty()));
    assertThat("Type values", actualDriverTypes,
        Matchers.everyItem(containsString(expectedDriverType)));
  }

  @Then("^Operator verify driver strength is filtered by \"([^\"]*)\" resigned")
  public void operatorVerifyDriverStrengthIsFilteredByResigned(String expected) {
    List<String> actualDriverTypes = dsPage.driversTable()
        .readFirstRowsInColumn(COLUMN_RESIGNED, 10);
    assertThat("Driver Strength records list", actualDriverTypes, not(empty()));
    assertThat("Resigned", actualDriverTypes,
        Matchers.everyItem(containsString(expected.toUpperCase())));
  }

  @Then("^Operator delete created driver on Driver Strength page$")
  public void operatorDeleteCreatedDriverOnDriverStrengthPage() {
    DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
    dsPage.deleteDriver(driverInfo.getUsername());
  }

  @Then("^Operator verify new driver is deleted successfully on Driver Strength page$")
  public void operatorVerifyNewDriverIsDeletedSuccessfullyOnDriverStrengthPage() throws Throwable {
    DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
    dsPage.filterBy(COLUMN_USERNAME, driverInfo.getUsername());
    assertTrue("Driver has been deleted", dsPage.driversTable().isTableEmpty());
    remove(KEY_CREATED_DRIVER_UUID);
  }

  @When("^Operator change Coming value for created driver on Driver Strength page$")
  public void operatorChangeComingValueForCreatedDriverOnDriverStrengthPage() {
    DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
    dsPage.filterBy(COLUMN_USERNAME, driverInfo.getUsername());
    put(KEY_INITIAL_COMING_VALUE, dsPage.driversTable().getComingStatus(1));
    dsPage.driversTable().toggleComingStatus(1);
  }

  @Then("^Operator verify Coming value for created driver has been changed on Driver Strength page$")
  public void operatorVerifyComingValueForCreatedDriverHasBeenChangedOnDriverStrengthPage() {
    String initialComingValue = get(KEY_INITIAL_COMING_VALUE);
    assertThat("Initial Coming value", initialComingValue, not(isEmptyOrNullString()));
    DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
    dsPage.filterBy(COLUMN_USERNAME, driverInfo.getUsername());
    assertThat("Actual Coming Value", dsPage.driversTable().getComingStatus(1),
        not(equalToIgnoringCase(initialComingValue)));
  }
}
