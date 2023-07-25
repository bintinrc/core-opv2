package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.mm.model.Vehicle;
import co.nvqa.operator_v2.selenium.page.VehicleInformationPage;
import io.cucumber.java.en.Then;
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

  @Then("Operator searches vehicle by vehicle number from {string}")
  public void operatorSearchesVehicleByVehicleNumberFrom(String storageKey) {
    List<String> vehicleNumbers = resolveValueAsList(storageKey, Vehicle.class).stream().map(Vehicle::getVehicleNumber).collect(
        Collectors.toList());

    vehicleInformationPage.searchByVehicleNumbers(vehicleNumbers);
  }
}
