package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.DpVault;
import co.nvqa.operator_v2.selenium.page.DpVaultManagementPage;
import com.google.inject.Inject;
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
    private DpVaultManagementPage dpVaultManagementPage;

    @Inject
    public DpVaultManagementSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        dpVaultManagementPage = new DpVaultManagementPage(getWebDriver());
    }

    @When("^Operator create new DP Vault using DP \"([^\"]*)\"$")
    public void operatorCreateDpVault(String dpName)
    {
        String uniqueCode = generateDateUniqueString();
        long uniqueCoordinate = System.currentTimeMillis();

        DpVault dpVault = new DpVault();
        dpVault.setName(String.format("DP Station #%s", uniqueCode));
        dpVault.setAppVersion(1L);
        dpVault.setDpName(dpName);
        dpVault.setAddress1(String.format("123 Orchard Road %s", uniqueCode));
        dpVault.setAddress2(String.format("OG Orchard #%s", uniqueCode));
        dpVault.setCity("SG");
        dpVault.setCountry("SG");
        dpVault.setLatitude(Double.parseDouble("1."+uniqueCoordinate));
        dpVault.setLongitude(Double.parseDouble("103."+uniqueCoordinate));

        dpVaultManagementPage.addDpVault(dpVault);
        getScenarioStorage().put("dpVault", dpVault);
    }

    @Then("^Operator verify the new DP Vault is created successfully$")
    public void operatorVerifyDpVaultIsCreatedSuccessfully()
    {
        DpVault dpVault = getScenarioStorage().get("dpVault");
        dpVaultManagementPage.verifyDpCompanyIsCreatedSuccessfully(dpVault);
    }

    @When("^Operator delete the new DP Vault$")
    public void operatorDeleteDpVault()
    {
        DpVault dpVault = getScenarioStorage().get("dpVault");
        dpVaultManagementPage.deleteDpVault(dpVault);
    }

    @Then("^Operator verify the new DP Vault is deleted successfully$")
    public void operatorVerifyDpVaultIsDeletedSuccessfully()
    {
        DpVault dpVault = getScenarioStorage().get("dpVault");
        dpVaultManagementPage.verifyDpVaultIsDeletedSuccessfully(dpVault);
    }

    @Then("^Operator check all filters on DP Vault Management page work fine$")
    public void operatorCheckAllFiltersOnDpVaultManagementPageWork()
    {
        DpVault dpVault = getScenarioStorage().get("dpVault");
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
        DpVault dpVault = getScenarioStorage().get("dpVault");
        dpVaultManagementPage.verifyCsvFileDownloadedSuccessfully(dpVault);
    }
}
