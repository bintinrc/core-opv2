package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.VehicleTypeManagementPage;
import com.google.inject.Inject;
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

    @Inject
    public VehicleTypeManagementSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
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

    @Then("^verify vehicle type$")
    public void verifyNewVehicleIsCreated()
    {
        String Name = get("vehicleTypeName");
        vehicleTypeManagementPage.verifyVehicleType(Name);
    }

    @When("^operator edit the vehicle type name$")
    public void editVehicleType()
    {
        String oldName = get("vehicleTypeName");
        String newName = oldName+" [EDITED]";
        vehicleTypeManagementPage.editVehicleType(oldName, newName);
        put("vehicleTypeNameEdited", newName);
    }

    @Then("^verify the edited vehicle type name is existed$")
    public void verifEditedVehicleType()
    {
        String Name = get("vehicleTypeNameEdited");
        vehicleTypeManagementPage.verifyVehicleType(Name);
    }

    @When("^operator delete the vehicle type name$")
    public void deleteVehicleTypeName()
    {
        String vehicleTypeName = containsKey("vehicleTypeNameEdited") ? get("vehicleTypeNameEdited") : get("vehicleTypeName");
        vehicleTypeManagementPage.deleteVehicleType(vehicleTypeName);
    }

    @Then("^operator verify vehicle type name is deleted$")
    public void operatorVerifyVehicleTypeNameIsDeleted()
    {
        String vehicleTypeName = containsKey("vehicleTypeNameEdited") ? get("vehicleTypeNameEdited") : get("vehicleTypeName");
        vehicleTypeManagementPage.verifyVehicleTypeNotExist(vehicleTypeName);
    }

    @When("^operator click on download CSV file button$")
    public void downloadCSVFile()
    {
        vehicleTypeManagementPage.csvDownload();
    }

    @Then("^verify the csv file$")
    public void verifCSVFile()
    {
        String vehicleTypeName = containsKey("vehicleTypeNameEdited") ? get("vehicleTypeNameEdited") : get("vehicleTypeName");
        vehicleTypeManagementPage.csvDownloadSuccessful(vehicleTypeName);
    }

    @After("@DeleteAfterDone")
    public void deleteAfterDone()
    {
        deleteVehicleTypeName();
    }
}
