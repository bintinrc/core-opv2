package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.DriverSeedingPage;
import co.nvqa.operator_v2.selenium.page.DriverSeedingPage.DriverMark;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.List;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class DriverSeedingSteps extends AbstractSteps {

  private DriverSeedingPage driverSeedingPage;

  public DriverSeedingSteps() {
  }

  @Override
  public void init() {
    driverSeedingPage = new DriverSeedingPage(getWebDriver());
  }

  @When("^Operator selects zones on Driver Seeding page:$")
  public void selectZones(List<String> zones) {
    zones = resolveValues(zones);
    driverSeedingPage.zones.selectValues(zones);
    pause2s();
  }

  @When("Operator check 'Inactive Drivers' checkbox on Driver Seeding page")
  public void checkInactiveDrivers() {
    driverSeedingPage.inactiveDrivers.check();
    pause2s();
  }

  @When("Operator check 'All Preferred Zones' checkbox on Driver Seeding page")
  public void checkAllPreferredZones() {
    driverSeedingPage.allPreferredZones.check();
    pause2s();
  }

  @When("Operator check 'Reserve Fleet Drivers' checkbox on Driver Seeding page")
  public void checkReserveFleetDrivers() {
    driverSeedingPage.reserveFleetDrivers.check();
    pause2s();
  }

  @When("Operator move {string} driver on the map on Driver Seeding page")
  public void moveDriver(String driverName) {
    String resolvedDriverName = resolveValue(driverName);
    DriverMark driverMark = driverSeedingPage.driverMarks.stream()
        .filter(mark -> StringUtils
            .equalsIgnoreCase(resolvedDriverName, mark.label.getNormalizedText()))
        .findFirst()
        .orElseThrow(() -> new IllegalArgumentException(
            "Mark for " + resolvedDriverName + " was not found on the map"));
    driverMark.mark.dragAndDropBy(-10, -10);
  }

  @Then("Following drivers are listed on Driver Seeding page:")
  public void checkListedDrivers(List<String> expected) {
    expected = resolveValues(expected);
    List<String> actual = driverSeedingPage.drivers.stream()
        .map(PageElement::getNormalizedText)
        .collect(Collectors.toList());
    assertThat("Listed Drivers", actual,
        Matchers.containsInAnyOrder(expected.toArray(new String[0])));
  }

  @Then("Following drivers are displayed on the map on Driver Seeding page:")
  public void checkDriversOnTheMap(List<String> expected) {
    expected = resolveValues(expected);
    List<String> actual = driverSeedingPage.driverMarks.stream()
        .map(mark -> mark.label.getNormalizedText())
        .collect(Collectors.toList());
    assertThat("Drivers on the map", actual,
        Matchers.containsInAnyOrder(expected.toArray(new String[0])));
  }
}