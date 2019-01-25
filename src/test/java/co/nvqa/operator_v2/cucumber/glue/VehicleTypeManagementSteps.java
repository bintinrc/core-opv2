package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.VehicleTypeManagementPage;
import cucumber.api.java.After;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Tristania Siagian
 */
@ScenarioScoped
public class VehicleTypeManagementSteps extends AbstractSteps
{
    private VehicleTypeManagementPage vehicleTypeManagementPage;

    public VehicleTypeManagementSteps()
    {
    }

    @Override
    public void init()
    {
        vehicleTypeManagementPage = new VehicleTypeManagementPage(getWebDriver());
    }

    @When("^Operator create new Vehicle Type$")
    public void operatorCreateNewVehicleType()
    {
        String vehicleTypeName = "VT-"+generateDateUniqueString();
        vehicleTypeManagementPage.addNewVehicleType(vehicleTypeName);
        put("vehicleTypeName", vehicleTypeName);

    }

    @Then("^Operator verify vehicle type$")
    public void operatorVerifyNewVehicleIsCreated()
    {
        String Name = get("vehicleTypeName");
        vehicleTypeManagementPage.verifyVehicleType(Name);
    }

    @When("^Operator edit the vehicle type name$")
    public void operatorEditVehicleType()
    {
        String oldName = get("vehicleTypeName");
        String newName = oldName+" [EDITED]";
        vehicleTypeManagementPage.editVehicleType(oldName, newName);
        put("vehicleTypeNameEdited", newName);
    }

    @Then("^Operator verify the edited vehicle type name is existed$")
    public void verifyEditedVehicleType()
    {
        String Name = get("vehicleTypeNameEdited");
        vehicleTypeManagementPage.verifyVehicleType(Name);
    }

    @When("^Operator delete the vehicle type name$")
    public void operatorDeleteVehicleTypeName()
    {
        String vehicleTypeName = containsKey("vehicleTypeNameEdited") ? get("vehicleTypeNameEdited") : get("vehicleTypeName");
        vehicleTypeManagementPage.deleteVehicleType(vehicleTypeName);
    }

    @Then("^Operator verify vehicle type name is deleted$")
    public void operatorVerifyVehicleTypeNameIsDeleted()
    {
        String vehicleTypeName = containsKey("vehicleTypeNameEdited") ? get("vehicleTypeNameEdited") : get("vehicleTypeName");
        vehicleTypeManagementPage.verifyVehicleTypeNotExist(vehicleTypeName);
    }

    @When("^Operator click on download CSV file button$")
    public void downloadCSVFile()
    {
        vehicleTypeManagementPage.csvDownload();
    }

    @Then("^Operator verify the CSV file$")
    public void operatorVerifyCsvFile()
    {
        String vehicleTypeName = containsKey("vehicleTypeNameEdited") ? get("vehicleTypeNameEdited") : get("vehicleTypeName");
        vehicleTypeManagementPage.csvDownloadSuccessful(vehicleTypeName);
    }

    @After("@DeleteAfterDone")
    public void deleteAfterDone()
    {
        operatorDeleteVehicleTypeName();
    }
}
