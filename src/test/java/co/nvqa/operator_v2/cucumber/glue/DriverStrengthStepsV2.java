package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.DriverInfo;
import co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.List;
import java.util.Map;
import org.hamcrest.Matchers;

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
      Map<String, String> mapOfData) {
    DriverInfo driverInfo = new DriverInfo();
    driverInfo.fromMap(mapOfData);
    put(KEY_CREATED_DRIVER_INFO, driverInfo);
    dsPage.addNewDriver(driverInfo);
  }

  @When("^Operator edit created Driver on Driver Strength page using data below:$")
  public void operatorEditCreatedDriverOnDriverStrengthPageUsingDataBelow(
      Map<String, String> mapOfData) {
    DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
    String username = driverInfo.getUsername();
    driverInfo.fromMap(mapOfData);
    dsPage.editDriver(username, driverInfo);
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
