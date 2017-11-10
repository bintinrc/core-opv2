package co.nvqa.operator_v2.cucumber.glue.step;

import com.google.inject.Inject;
import co.nvqa.operator_v2.model.DpVault;
import co.nvqa.operator_v2.selenium.page.DpVaultManagementPage;
import co.nvqa.operator_v2.support.ScenarioStorage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class DpVaultManagementSteps extends AbstractSteps
{
    @Inject ScenarioStorage scenarioStorage;
    private DpVaultManagementPage dpVaultManagementPage;

    @Inject
    public DpVaultManagementSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        dpVaultManagementPage = new DpVaultManagementPage(getDriver());
    }

    @When("^Operator create new DP Vault using DP \"([^\"]*)\"$")
    public void operatorCreateDpVault(String dpName)
    {
        String uniqueCode = String.valueOf(System.currentTimeMillis());

        DpVault dpVault = new DpVault();
        dpVault.setName(String.format("DP Station #%s", uniqueCode));
        dpVault.setAppVersion(1L);
        dpVault.setDpName(dpName);
        dpVault.setAddress1(String.format("123 Orchard Road %s", uniqueCode));
        dpVault.setAddress2(String.format("OG Orchard #%s", uniqueCode));
        dpVault.setCity("SG");
        dpVault.setCountry("SG");
        dpVault.setLatitude(Double.parseDouble("1."+uniqueCode));
        dpVault.setLongitude(Double.parseDouble("103."+uniqueCode));

        dpVaultManagementPage.addDpVault(dpVault);
        scenarioStorage.put("dpVault", dpVault);
    }

    @Then("^Operator verify the new DP Vault is created successfully$")
    public void operatorVerifyDpVaultIsCreatedSuccessfully()
    {
        DpVault dpVault = scenarioStorage.get("dpVault");
        dpVaultManagementPage.verifyDpCompanyIsCreatedSuccessfully(dpVault);
    }

    @When("^Operator delete the new DP Vault")
    public void operatorDeleteDpVault()
    {
        DpVault dpVault = scenarioStorage.get("dpVault");
        dpVaultManagementPage.deleteDpVault(dpVault);
    }

    @Then("^Operator verify the new DP Vault is deleted successfully$")
    public void operatorVerifyDpVaultIsDeletedSuccessfully()
    {
        DpVault dpVault = scenarioStorage.get("dpVault");
        dpVaultManagementPage.verifyDpVaultIsDeletedSuccessfully(dpVault);
    }

    @Then("^Operator check all filters on DP Vault Management page work fine")
    public void operatorCheckAllFiltersOnDpVaultManagementPageWork()
    {
        DpVault dpVault = scenarioStorage.get("dpVault");
        dpVaultManagementPage.verifyAllFiltersWorkFine(dpVault);
    }

    @When("^Operator download DP Vault CSV file$")
    public void operatorDownloadDpVaultCsvFile()
    {
        dpVaultManagementPage.downloadCsvFile();
    }

    @When("^Operator verify DP Vault CSV file downloaded successfully$")
    public void operatorVerifyDpVaultCsvFileDownloadSuccessfully()
    {
        DpVault dpVault = scenarioStorage.get("dpVault");
        dpVaultManagementPage.verifyCsvFileDownloadedSuccessfully(dpVault);
    }
}
