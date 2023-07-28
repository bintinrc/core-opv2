package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.mm.model.Vehicle;
import co.nvqa.common.mm.utils.MiddleMileUtils;
import co.nvqa.operator_v2.selenium.page.VehicleInformationPage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.stream.Collectors;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class VehicleInformationSteps extends AbstractSteps{

  private static final Logger LOGGER = LoggerFactory.getLogger(VehicleInformationSteps.class);
  private final String GENERATED = "GENERATED";

  private VehicleInformationPage vehicleInformationPage;

  public VehicleInformationSteps() {
  }

  @Override
  public void init() {
    vehicleInformationPage = new VehicleInformationPage(getWebDriver());
  }

  @Then("Operator verifies Vehicle Information page is loaded")
  public void operatorVerifiesVehicleInformationPageIsLoaded() {
    vehicleInformationPage.verifyPageIsLoaded();
  }

  @When("Operator input these vehicle numbers in Search by Vehicle Number textarea:")
  public void operatorSearchesVehiclesByTheseVehicleNumbers(List<String> vehicleNumbers) {
    // Resolve single object values
    List<String> resolvedVehicleNumbers = vehicleNumbers.stream()
        .filter(v -> !MiddleMileUtils.isListOfObjects(v))
        .map(v -> resolveValue(v, String.class))
        .collect(Collectors.toList());

    // Resolve list if given
    vehicleNumbers.stream()
        .filter(MiddleMileUtils::isListOfObjects)
        .collect(Collectors.toList())
        .forEach(v -> {
          List<String> vNums = resolveValueAsList(v, Vehicle.class).stream()
              .map(Vehicle::getVehicleNumber)
              .collect(Collectors.toList());
          resolvedVehicleNumbers.addAll(vNums);
        });

    vehicleInformationPage.inputVehicleNumbers(resolvedVehicleNumbers);
  }

  @When("Operator verifies vehicle number counter is {int}")
  public void operatorVerifiesVehicleNumberCounterIs(int counter) {
    vehicleInformationPage.verifyVehicleCounterIs(counter);
  }

  @When("Operator verifies vehicle number counter with duplicate is {string}")
  public void operatorVerifiesVehicleNumberCounterWithDuplicateIs(String counterStr) {
    vehicleInformationPage.verifyVehicleCounterIs(counterStr);
  }

  @When("Operator clicks Search button when searching vehicles by vehicle number")
  public void operatorClicksSearchButtonWhenSearchingVehiclesByVehicleNumber() {
    vehicleInformationPage.clickSearchVehicleBy("number");
  }

  @Then("Operator searches vehicles by vehicle number from {string}")
  public void operatorSearchesVehicleByVehicleNumberFrom(String storageKey) {
    List<String> vehicleNumbers = resolveValueAsList(storageKey, Vehicle.class).stream()
        .map(Vehicle::getVehicleNumber)
        .collect(Collectors.toList());

    vehicleInformationPage.searchByVehicleNumbers(vehicleNumbers);
  }

  @Then("Operator searches vehicles by invalid vehicle number based on {string}")
  public void operatorSearchesVehiclesByInvalidVehicleNumberBasedOn(String storageKey) {
    List<String> invalidVehicleNumbers = resolveValueAsList(storageKey, Vehicle.class).stream()
        .map(v -> "INVALID-" + v.getVehicleNumber())
        .collect(Collectors.toList());

    vehicleInformationPage.searchByVehicleNumbers(invalidVehicleNumbers);
  }

  @Then("Operator verifies vehicle table is loaded")
  public void operatorVerifiesThatTheVehicleTableIsLoaded() {
    vehicleInformationPage.verifyVehicleResultTableContainerIsLoaded();
  }

  @Then("Operator verifies {string} appear in vehicle result table")
  public void operatorVerifiesAppearInVehicleResultTable(String storageKey) {
    List<Vehicle> vehicles = resolveValue(storageKey);
    vehicleInformationPage.verifyVehiclesAreOnVehicleResultTable(vehicles);
  }

  @Then("Operator verifies maximum vehicle numbers input is exceeded")
  public void operatorVerifiesMaximumVehicleNumbersInputIsExceeded() {
    vehicleInformationPage.verifyErrorNotificationForExceedingVehicleNumberIsDisplayed();
  }

  @Then("Operator verifies invalid vehicle number dialog is displayed")
  public void operatorVerifiesInvalidVehicleNumberDialogIsDisplayed() {
    vehicleInformationPage.verifyInvalidVehicleNumberDialogIsDisplayed();
  }

  @Then("Operator verifies alert is showing {int} vehicle numbers cannot be found")
  public void operatorVerifiesAlertIsShowingVehicleNumbersCannotBeFound(int numberOfInvalidVehicleNumbers) {
    vehicleInformationPage.verifyInvalidVehicleNumberAlertIsDisplayed(numberOfInvalidVehicleNumbers);
  }

  @Then("Operator clicks View on not found vehicle numbers alert")
  public void operatorClicksViewOnNotFoundVehicleNumbersAlert() {
    vehicleInformationPage.clickViewNotFoundVehicleNumbers();
  }

  @Then("Operator verifies these vehicle numbers are displayed as not found vehicle numbers:")
  public void operatorVerifiesTheseVehicleNumbersAreDisplayedAsNotFoundVehicleNumbers(List<String> vehicleNumbers) {
    vehicleInformationPage.verifyListOfInvalidVehicleNumbers(vehicleNumbers);
  }
}
