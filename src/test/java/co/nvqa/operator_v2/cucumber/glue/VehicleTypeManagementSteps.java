package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.DriverTypeParams;
import co.nvqa.operator_v2.model.VehicleType;
import co.nvqa.operator_v2.selenium.page.AntTableV3;
import co.nvqa.operator_v2.selenium.page.VehicleTypeManagementPage;
import com.google.common.collect.ImmutableMap;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.util.Map;
import java.util.function.Supplier;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Tristania Siagian
 */
@ScenarioScoped
public class VehicleTypeManagementSteps extends AbstractSteps {

  private VehicleTypeManagementPage vtmPage;

  public VehicleTypeManagementSteps() {
  }

  @Override
  public void init() {
    vtmPage = new VehicleTypeManagementPage(getWebDriver());
  }

  @When("^Operator create new Vehicle Type$")
  public void operatorCreateNewVehicleType() {
    VehicleType vehicleType = new VehicleType();
    String vehicleTypeName = "VT-" + StandardTestUtils.generateDateUniqueString();
    vehicleType.setName(vehicleTypeName);
    vtmPage.inFrame(() -> {
      vtmPage.addNewVehicleType(vehicleType);
      put(KEY_CREATED_VEHICLE_TYPE, vehicleType);
    });
  }

  @Then("Operator verify vehicle type")
  public void operatorVerifyNewVehicleIsCreated() {
    VehicleType vehicleType = get(KEY_CREATED_VEHICLE_TYPE);
    vtmPage.refreshPage();
    vtmPage.inFrame(() -> {
      boolean isSearchBarDisplayed = vtmPage.seachBar.isDisplayed();
      while (!isSearchBarDisplayed) {
        pause(500);
        isSearchBarDisplayed = vtmPage.seachBar.isDisplayed();
      }
      vtmPage.seachBar.sendKeys(vehicleType.getName());
      vtmPage.verifyVehicleType(vehicleType);
      takesScreenshot();
    });
  }

  @When("Operator edit the vehicle type name")
  public void operatorEditVehicleType() {
    VehicleType vehicleType = get(KEY_CREATED_VEHICLE_TYPE);
    String oldName = vehicleType.getName();
    String newName = oldName + " [EDITED]";
    vtmPage.inFrame(() -> {
      vtmPage.editVehicleType(oldName, newName);
    });
    VehicleType editedVehicleType = new VehicleType();
    editedVehicleType.setId(vehicleType.getId());
    editedVehicleType.setName(newName);
    put(KEY_CREATED_VEHICLE_TYPE_EDITED, editedVehicleType);
  }

  @Then("Operator verify the edited vehicle type name is existed")
  public void verifyEditedVehicleType() {
    VehicleType vehicleType = get(KEY_CREATED_VEHICLE_TYPE_EDITED);
    vtmPage.inFrame(() -> {
      vtmPage.verifyVehicleType(vehicleType);
      takesScreenshot();
    });
  }

  @When("Operator delete the vehicle type name")
  public void operatorDeleteVehicleTypeName() {
    VehicleType vehicleType =
        containsKey(KEY_CREATED_VEHICLE_TYPE_EDITED) ? get(KEY_CREATED_VEHICLE_TYPE_EDITED)
            : get(KEY_CREATED_VEHICLE_TYPE);
    vtmPage.inFrame(() -> {
      vtmPage.deleteVehicleType(vehicleType.getName());
      takesScreenshot();
    });
  }

  @Then("Operator verify vehicle type name is deleted")
  public void operatorVerifyVehicleTypeNameIsDeleted() {
    VehicleType vehicleType =
        containsKey(KEY_CREATED_VEHICLE_TYPE_EDITED) ? get(KEY_CREATED_VEHICLE_TYPE_EDITED)
            : get(KEY_CREATED_VEHICLE_TYPE);
    vtmPage.inFrame(() -> {
      vtmPage.verifyVehicleTypeNotExist(vehicleType.getName());
      takesScreenshot();
    });
  }

  @When("Operator click on download CSV file button")
  public void downloadCSVFile() {
    vtmPage.inFrame(() -> {
      vtmPage.csvDownload();
    });
  }

  @Then("Operator verify the CSV file")
  public void operatorVerifyCsvFile() {
    vtmPage.inFrame(() -> {
      vtmPage.verifyFileDownloadedSuccessfully(VehicleTypeManagementPage.CSV_FILENAME);
      takesScreenshot();
    });
  }

  @And("^Operator gets new vehicle type on Vehicle type management page")
  public void operatorGetsNewVehicleTypeOnVehicleTypeManagementPage() {
    Runnable getNewVehicleType = () -> {
      vtmPage.refreshPage();
      VehicleType vehicleType = get(KEY_CREATED_VEHICLE_TYPE);
      vtmPage.inFrame(() -> {
        boolean isSearchBarDisplayed = vtmPage.seachBar.isDisplayed();
        while (!isSearchBarDisplayed) {
          pause(500);
          isSearchBarDisplayed = vtmPage.seachBar.isDisplayed();
        }
        vtmPage.seachBar.sendKeys(vehicleType.getName());
        Map<String, String> vehicleTypeData = vtmPage.vehicleTypeTable.readRow(1);
        vehicleType.setId(Long.parseLong(vehicleTypeData.get("vehicleId")));
        put(KEY_CREATED_VEHICLE_TYPE, vehicleType);
      });
    };
    doWithRetry(getNewVehicleType, "Operator get new vehicle type", 5000L, 3);
  }
}
