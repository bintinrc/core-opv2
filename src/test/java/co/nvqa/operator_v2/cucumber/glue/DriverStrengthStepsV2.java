package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.DriverInfo;
import co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

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
    dsPage.inFrame(() -> {
      dsPage.addNewDriver(driverInfo);
    });
  }

  @When("^Operator opens Add Driver dialog on Driver Strength$")
  public void operatorOpensAddDriverDialog() {
    dsPage.inFrame(() -> {
      dsPage.addNewDriver.click();
      pause3s();
    });
  }

  @When("^Operator fill Add Driver form on Driver Strength page using data below:$")
  public void operatorFillAddDriverOnDriverStrengthPageUsingDataBelow(
      Map<String, String> mapOfData) {
    DriverInfo driverInfo = new DriverInfo(resolveKeyValues(mapOfData));
    put(KEY_CREATED_DRIVER_INFO, driverInfo);
    dsPage.inFrame(() -> dsPage.addDriverDialog.fillForm(driverInfo));
  }

  @When("Operator verifies Submit button in Add Driver dialog is disabled")
  public void operatorVerifiesSubmitButtonState() {
    assertFalse("Submit button is enabled", dsPage.addDriverDialog.submit.isEnabled());
  }

  @When("Operator verifies hint {string} is displayed in Add Driver dialog")
  public void operatorVerifiesAddDriverHint(String expected) {
    final String exp = resolveValue(expected);
    dsPage.inFrame(() -> {
      switch (exp) {
        case "At least one contacts required.":
          assertTrue("Hint is displayed", dsPage.addDriverDialog.contactHints.isDisplayed());
          assertEquals("Hint text", expected,
              dsPage.addDriverDialog.contactHints.getNormalizedText());
          break;
        case "At least one vehicle required.":
          assertTrue("Hint is displayed", dsPage.addDriverDialog.vehicleHints.isDisplayed());
          assertEquals("Hint text", expected,
              dsPage.addDriverDialog.vehicleHints.getNormalizedText());
          break;
        case "At least one zone preference required.":
          assertTrue("Hint is displayed", dsPage.addDriverDialog.zoneHints.isDisplayed());
          assertEquals("Hint text", expected, dsPage.addDriverDialog.zoneHints.getNormalizedText());
          break;
        default:
          break;
      }
    });
  }

  @When("^Operator edit created Driver on Driver Strength page using data below:$")
  public void operatorEditCreatedDriver(Map<String, String> mapOfData) {
    DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
    String username = driverInfo.getUsername();
    driverInfo.fromMap(mapOfData);
    dsPage.inFrame(() -> {
      dsPage.driversTable.filterByColumn(COLUMN_USERNAME, username);
      dsPage.driversTable.clickActionButton(1, ACTION_EDIT);
      dsPage.editDriverDialog.fillForm(driverInfo);
      dsPage.editDriverDialog.submitForm();
    });
  }

  @When("Operator updates driver details with the following info:")
  public void operator_updates_driver_details_with_the_following_info(Map<String, String> mapOfData) {
    DriverInfo driverInfo = new DriverInfo();
    driverInfo.fromMap(mapOfData);
    put(KEY_CREATED_DRIVER_INFO, driverInfo);
    put(KEY_UPDATED_DRIVER_FIRST_NAME,driverInfo.getFirstName());
    dsPage.inFrame(() -> {
      dsPage.driversTable.clickActionButton(1, ACTION_EDIT);
      dsPage.editDriverDialog.fillForm(driverInfo);
      dsPage.editDriverDialog.submitForm();
    });
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
    dsPage.inFrame(() -> {
      dsPage.waitUntilTableLoaded();
      dsPage.driversTable.filterByColumn(COLUMN_USERNAME, expectedDriverInfo.getUsername());
      DriverInfo actualDriverInfo = dsPage.driversTable.readEntity(1);
      if (expectedDriverInfo.getId() != null) {
        assertThat("Id", actualDriverInfo.getId(), equalTo(expectedDriverInfo.getId()));
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.getUsername())) {
        assertThat("Username", actualDriverInfo.getUsername(),
            equalTo(expectedDriverInfo.getUsername()));
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.getFirstName())) {
        assertThat("First Name", actualDriverInfo.getFirstName(),
            equalTo(expectedDriverInfo.getFirstName()));
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.getLastName())) {
        assertThat("Last Name", actualDriverInfo.getLastName(),
            equalTo(expectedDriverInfo.getLastName()));
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.getType())) {
        assertThat("Type", actualDriverInfo.getType(), equalTo(expectedDriverInfo.getType()));
      }
      if (expectedDriverInfo.getZoneMin() != null) {
        assertThat("Min", actualDriverInfo.getZoneMin(), equalTo(expectedDriverInfo.getZoneMin()));
      }
      if (expectedDriverInfo.getZoneMax() != null) {
        assertThat("Max", actualDriverInfo.getZoneMax(), equalTo(expectedDriverInfo.getZoneMax()));
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.getComments())) {
        assertThat("Comments", actualDriverInfo.getComments(),
            equalTo(expectedDriverInfo.getComments()));
      }
    });
  }

  @Then("^Operator verify contact details of created driver on Driver Strength page$")
  public void dbOperatorVerifyContactDetailsOfCreatedDriver() {
    DriverInfo expectedDriverInfo = get(KEY_CREATED_DRIVER_INFO);
    dsPage.inFrame(() -> {
      dsPage.verifyContactDetails(expectedDriverInfo.getUsername(), expectedDriverInfo);
    });
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
    dsPage.inFrame(() -> dsPage.loadEverything());
  }

  @When("Operator filter driver strength using data below:")
  public void operatorFilterDriverStrengthUsingDataBelow(Map<String, String> map) {
    Map<String, String> data = resolveKeyValues(map);
    dsPage.inFrame(() -> {
      dsPage.loadSelection.waitUntilClickable();
      dsPage.clearSelection.click();

      if (data.containsKey("zones")) {
        List<String> zones = splitAndNormalize(data.get("zones"));
        dsPage.zonesFilter.selectValues(zones);
      }

      if (data.containsKey("driverTypes")) {
        List<String> driverTypes = splitAndNormalize(data.get("driverTypes"));
        dsPage.driverTypesFilter.selectValues(driverTypes);
      }

      if (data.containsKey("resigned")) {
        dsPage.resignedFilter.click();
      }

      dsPage.loadSelection();
    });
  }

  @Then("^Operator verify driver strength is filtered by \"([^\"]*)\" zone$")
  public void operatorVerifyDriverStrengthIsFilteredByZone(String expectedZone) {
    if ("GET_FROM_CREATED_DRIVER".equalsIgnoreCase(expectedZone)) {
      DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
      expectedZone = driverInfo.getZoneId();
    }
    final String exp = expectedZone;
    dsPage.inFrame(() -> {
      List<String> actualZones = dsPage.driversTable().readFirstRowsInColumn(COLUMN_ZONE, 10);
      assertThat("Driver Strength records list", actualZones, not(empty()));
      assertThat("Zone values", actualZones, Matchers.everyItem(containsString(exp)));
    });
  }

  @Then("^Operator verify driver strength is filtered by \"([^\"]*)\" driver type")
  public void operatorVerifyDriverStrengthIsFilteredByDriverType(String expectedDriverType) {
    if ("GET_FROM_CREATED_DRIVER".equalsIgnoreCase(expectedDriverType)) {
      DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
      expectedDriverType = driverInfo.getType();
    }
    final String exp = expectedDriverType;
    dsPage.inFrame(() -> {
      List<String> actualDriverTypes = dsPage.driversTable().readFirstRowsInColumn(COLUMN_TYPE, 10);
      assertThat("Driver Strength records list", actualDriverTypes, not(empty()));
      assertThat("Type values", actualDriverTypes,
          Matchers.everyItem(containsString(exp)));
    });
  }

  @Then("^Operator verify driver strength is filtered by \"([^\"]*)\" resigned")
  public void operatorVerifyDriverStrengthIsFilteredByResigned(String expected) {
    List<String> actualDriverTypes = dsPage.driversTable()
        .readFirstRowsInColumn(COLUMN_RESIGNED, 10);
    dsPage.inFrame(() -> {
      assertThat("Driver Strength records list", actualDriverTypes, not(empty()));
      assertThat("Resigned", actualDriverTypes,
          Matchers.everyItem(containsString(expected.toUpperCase())));
    });
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

  @Then("^Operator load all data for driver on Driver Strength Page$")
  public void operatorLoadAllData() {
    final String loadSelectionXpath = "//button[span[text()='Load Selection']]";
    dsPage.inFrame(() -> {
      dsPage.waitUntilVisibilityOfElementLocated(loadSelectionXpath);
      dsPage.click(loadSelectionXpath);
    });
  }

  @When("Operator click Submit button in Add Driver dialog")
  public void clickSubmitButton() {
    dsPage.inFrame(() -> {
      dsPage.addDriverDialog.submit.click();
    });
  }

}
