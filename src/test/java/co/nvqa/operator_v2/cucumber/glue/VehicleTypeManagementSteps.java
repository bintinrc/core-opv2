package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.VehicleType;
import co.nvqa.operator_v2.selenium.page.VehicleTypeManagementPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 * @author Tristania Siagian
 */
@ScenarioScoped
public class VehicleTypeManagementSteps extends AbstractSteps {

  private VehicleTypeManagementPage vehicleTypeManagementPage;

  public VehicleTypeManagementSteps() {
  }

  @Override
  public void init() {
    vehicleTypeManagementPage = new VehicleTypeManagementPage(getWebDriver());
  }

  @When("^Operator create new Vehicle Type$")
  public void operatorCreateNewVehicleType() {
    String vehicleTypeName = "VT-" + generateDateUniqueString();
    VehicleType vehicleType = new VehicleType();
    vehicleType.setName(vehicleTypeName);
    vehicleTypeManagementPage.addNewVehicleType(vehicleType);
    put(KEY_CREATED_VEHICLE_TYPE, vehicleType);
  }

  @Then("^Operator verify vehicle type$")
  public void operatorVerifyNewVehicleIsCreated() {
    VehicleType vehicleType = get(KEY_CREATED_VEHICLE_TYPE);
    vehicleTypeManagementPage.verifyVehicleType(vehicleType);
  }

  @When("^Operator edit the vehicle type name$")
  public void operatorEditVehicleType() {
    VehicleType vehicleType = get(KEY_CREATED_VEHICLE_TYPE);
    String oldName = vehicleType.getName();
    String newName = oldName + " [EDITED]";
    vehicleTypeManagementPage.editVehicleType(oldName, newName);
    VehicleType editedVehicleType = new VehicleType(vehicleType);
    editedVehicleType.setName(newName);
    put(KEY_CREATED_VEHICLE_TYPE_EDITED, editedVehicleType);
  }

  @Then("^Operator verify the edited vehicle type name is existed$")
  public void verifyEditedVehicleType() {
    VehicleType vehicleType = get(KEY_CREATED_VEHICLE_TYPE_EDITED);
    vehicleTypeManagementPage.verifyVehicleType(vehicleType);
  }

  @When("^Operator delete the vehicle type name$")
  public void operatorDeleteVehicleTypeName() {
    VehicleType vehicleType =
        containsKey(KEY_CREATED_VEHICLE_TYPE_EDITED) ? get(KEY_CREATED_VEHICLE_TYPE_EDITED)
            : get(KEY_CREATED_VEHICLE_TYPE);
    vehicleTypeManagementPage.deleteVehicleType(vehicleType.getName());
  }

  @Then("^Operator verify vehicle type name is deleted$")
  public void operatorVerifyVehicleTypeNameIsDeleted() {
    VehicleType vehicleType =
        containsKey(KEY_CREATED_VEHICLE_TYPE_EDITED) ? get(KEY_CREATED_VEHICLE_TYPE_EDITED)
            : get(KEY_CREATED_VEHICLE_TYPE);
    vehicleTypeManagementPage.verifyVehicleTypeNotExist(vehicleType.getName());
  }

  @When("^Operator click on download CSV file button$")
  public void downloadCSVFile() {
    vehicleTypeManagementPage.csvDownload();
  }

  @Then("^Operator verify the CSV file$")
  public void operatorVerifyCsvFile() {
    VehicleType vehicleType =
        containsKey(KEY_CREATED_VEHICLE_TYPE_EDITED) ? get(KEY_CREATED_VEHICLE_TYPE_EDITED)
            : get(KEY_CREATED_VEHICLE_TYPE);
    vehicleTypeManagementPage.csvDownloadSuccessful(vehicleType.getName());
  }
}
