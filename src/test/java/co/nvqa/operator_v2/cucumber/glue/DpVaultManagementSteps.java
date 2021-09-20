package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.DpVault;
import co.nvqa.operator_v2.selenium.page.DpVaultManagementPage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class DpVaultManagementSteps extends AbstractSteps {

  private DpVaultManagementPage dpVaultManagementPage;

  public DpVaultManagementSteps() {
  }

  @Override
  public void init() {
    dpVaultManagementPage = new DpVaultManagementPage(getWebDriver());
  }

  @When("^Operator create new DP Vault using DP \"([^\"]*)\"$")
  public void operatorCreateDpVault(String dpName) {
    String uniqueCode = generateDateUniqueString();
    long uniqueCoordinate = System.currentTimeMillis();

    DpVault dpVault = new DpVault();
    dpVault.setName(f("DP Station #%s", uniqueCode));
    dpVault.setAppVersion(1L);
    dpVault.setDpName(dpName);
    dpVault.setAddress1(f("123 Orchard Road %s", uniqueCode));
    dpVault.setAddress2(f("OG Orchard #%s", uniqueCode));
    dpVault.setCity("SG");
    dpVault.setCountry("SG");
    dpVault.setLatitude(Double.parseDouble("1." + uniqueCoordinate));
    dpVault.setLongitude(Double.parseDouble("103." + uniqueCoordinate));

    dpVaultManagementPage.addDpVault(dpVault);
    put("dpVault", dpVault);
  }

  @Then("^Operator verify the new DP Vault is created successfully$")
  public void operatorVerifyDpVaultIsCreatedSuccessfully() {
    DpVault dpVault = get("dpVault");
    dpVaultManagementPage.verifyDpCompanyIsCreatedSuccessfully(dpVault);
  }

  @When("^Operator delete the new DP Vault$")
  public void operatorDeleteDpVault() {
    DpVault dpVault = get("dpVault");
    dpVaultManagementPage.deleteDpVault(dpVault);
  }

  @Then("^Operator verify the new DP Vault is deleted successfully$")
  public void operatorVerifyDpVaultIsDeletedSuccessfully() {
    DpVault dpVault = get("dpVault");
    dpVaultManagementPage.verifyDpVaultIsDeletedSuccessfully(dpVault);
  }

  @Then("^Operator check all filters on DP Vault Management page work fine$")
  public void operatorCheckAllFiltersOnDpVaultManagementPageWork() {
    DpVault dpVault = get("dpVault");
    dpVaultManagementPage.verifyAllFiltersWorkFine(dpVault);
  }

  @When("^Operator download DP Vault CSV file$")
  public void operatorDownloadDpVaultCsvFile() {
    dpVaultManagementPage.downloadCsvFile();
  }

  @When("^Operator verify DP Vault CSV file downloaded successfully$")
  public void operatorVerifyDpVaultCsvFileDownloadSuccessfully() {
    DpVault dpVault = get("dpVault");
    dpVaultManagementPage.verifyCsvFileDownloadedSuccessfully(dpVault);
  }
}
