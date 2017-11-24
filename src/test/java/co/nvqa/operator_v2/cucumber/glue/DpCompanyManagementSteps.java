package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.DpCompany;
import co.nvqa.operator_v2.model.DpCompanyAgent;
import co.nvqa.operator_v2.selenium.page.DpCompanyAgentPage;
import co.nvqa.operator_v2.selenium.page.DpCompanyManagementPage;
import co.nvqa.operator_v2.util.ScenarioStorage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class DpCompanyManagementSteps extends AbstractSteps
{
    @Inject ScenarioStorage scenarioStorage;
    private DpCompanyManagementPage dpCompanyManagementPage;
    private DpCompanyAgentPage dpCompanyAgentPage;

    @Inject
    public DpCompanyManagementSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        dpCompanyManagementPage = new DpCompanyManagementPage(getWebDriver());
        dpCompanyAgentPage = new DpCompanyAgentPage(getWebDriver());
    }

    @When("^Operator create new DP Company$")
    public void operatorCreateDpCompany()
    {
        String uniqueCode = String.valueOf(System.currentTimeMillis());
        DpCompany dpCompany = new DpCompany();
        dpCompany.setName(String.format("DP Company #%s", uniqueCode));
        dpCompany.setEmail(String.format("dp.company.%s@test.co", uniqueCode));
        dpCompany.setContact(String.format("65%s", uniqueCode));
        dpCompany.setDropOffWebhookUrl(String.format("https://www.dropoffwebhook-%s.co", uniqueCode));
        dpCompany.setCollectWebhookUrl(String.format("https://www.collectwebhook-%s.co", uniqueCode));
        dpCompany.setIntegrated(Boolean.FALSE);
        dpCompanyManagementPage.addDpCompany(dpCompany);
        scenarioStorage.put("dpCompany", dpCompany);
    }

    @Then("^Operator verify the new DP Company is created successfully$")
    public void operatorVerifyDpCompanyIsCreatedSuccessfully()
    {
        DpCompany dpCompany = scenarioStorage.get("dpCompany");
        dpCompanyManagementPage.verifyDpCompanyIsCreatedSuccessfully(dpCompany);
    }

    @When("^Operator update the new DP Company$")
    public void operatorUpdateDpCompany()
    {
        DpCompany dpCompany = scenarioStorage.get("dpCompany");

        DpCompany dpCompanyEdited = new DpCompany();
        dpCompanyEdited.setName(dpCompany.getName()+" [EDITED]");
        dpCompanyEdited.setEmail(dpCompany.getEmail()+".sg");
        dpCompanyEdited.setContact(dpCompany.getContact()+"1");
        dpCompanyEdited.setDropOffWebhookUrl(dpCompany.getDropOffWebhookUrl()+".sg");
        dpCompanyEdited.setCollectWebhookUrl(dpCompany.getCollectWebhookUrl()+".sg");
        dpCompanyEdited.setIntegrated(Boolean.TRUE);
        dpCompanyManagementPage.editDpCompany(dpCompanyEdited);
        scenarioStorage.put("dpCompanyEdited", dpCompanyEdited);
    }

    @Then("^Operator verify the new DP Company is updated successfully$")
    public void operatorVerifyDpCompanyIsUpdatedSuccessfully()
    {
        DpCompany dpCompanyEdited = scenarioStorage.get("dpCompanyEdited");
        dpCompanyManagementPage.verifyDpCompanyIsUpdatedSuccessfully(dpCompanyEdited);
    }

    @When("^Operator delete the new DP Company$")
    public void operatorDeleteDpCompany()
    {
        DpCompany dpCompany = scenarioStorage.get("dpCompany");
        dpCompanyManagementPage.deleteDpCompany(dpCompany);
    }

    @Then("^Operator verify the new DP Company is deleted successfully$")
    public void operatorVerifyDpCompanyIsDeletedSuccessfully()
    {
        DpCompany dpCompany = scenarioStorage.get("dpCompany");
        dpCompanyManagementPage.verifyDpCompanyIsDeletedSuccessfully(dpCompany);
    }

    @Then("^Operator check all filters on DP Company Management page work fine$")
    public void operatorCheckAllFiltersOnDpCompanyManagementPageWork()
    {
        DpCompany dpCompany = scenarioStorage.get("dpCompany");
        dpCompanyManagementPage.verifyAllFiltersWorkFine(dpCompany);
    }

    @When("^Operator download DP Company CSV file$")
    public void operatorDownloadDpCompanyCsvFile()
    {
        dpCompanyManagementPage.downloadCsvFile();
    }

    @When("^Operator verify DP Company CSV file downloaded successfully$")
    public void operatorVerifyDpCompanyCsvFileDownloadSuccessfully()
    {
        DpCompany dpCompany = scenarioStorage.get("dpCompany");
        dpCompanyManagementPage.verifyCsvFileDownloadedSuccessfully(dpCompany);
    }

    @When("^Operator create new Agent for the new DP Company$")
    public void operatorCreateNewAgentForTheNewDpCompany()
    {
        DpCompany dpCompany = scenarioStorage.get("dpCompany");
        dpCompanyManagementPage.clickSeeVault(dpCompany);

        String uniqueCode = String.valueOf(System.currentTimeMillis());
        DpCompanyAgent dpCompanyAgent = new DpCompanyAgent();
        dpCompanyAgent.setName(String.format("DP Company Agent #%s", uniqueCode));
        dpCompanyAgent.setEmail(String.format("dp.company.agent.%s@test.co", uniqueCode));
        dpCompanyAgent.setContact(String.format("65%s", uniqueCode));
        dpCompanyAgent.setUnlockCode(uniqueCode);
        dpCompanyAgentPage.addDpCompanyAgent(dpCompanyAgent);

        scenarioStorage.put("dpCompanyAgent", dpCompanyAgent);
    }

    @Then("^Operator verify the new Agent for the new DP Company is created successfully$")
    public void operatorVerifyTheNewAgentForTheNewDpCompanyIsCreatedSuccessfully()
    {
        DpCompanyAgent dpCompanyAgent = scenarioStorage.get("dpCompanyAgent");
        dpCompanyAgentPage.verifyDpCompanyAgentIsCreatedSuccessfully(dpCompanyAgent);
    }

    @When("^Operator update the new Agent for the new DP Company$")
    public void operatorUpdateTheNewAgentForTheNewDpCompany()
    {
        DpCompanyAgent dpCompanyAgent = scenarioStorage.get("dpCompanyAgent");

        DpCompanyAgent dpCompanyAgentEdited = new DpCompanyAgent();
        dpCompanyAgentEdited.setName(dpCompanyAgent.getName()+" [EDITED]");
        dpCompanyAgentEdited.setEmail(dpCompanyAgent.getEmail()+".sg");
        dpCompanyAgentEdited.setContact(dpCompanyAgent.getContact()+"1");
        dpCompanyAgentEdited.setUnlockCode(dpCompanyAgent.getUnlockCode()+"1");
        dpCompanyAgentPage.editDpCompanyAgent(dpCompanyAgentEdited);

        scenarioStorage.put("dpCompanyAgentEdited", dpCompanyAgentEdited);
    }

    @Then("^Operator verify the new Agent for the new DP Company is updated successfully$")
    public void operatorVerifyTheNewAgentForTheNewDpCompanyIsUpdatedSuccessfully()
    {
        DpCompanyAgent dpCompanyAgentEdited = scenarioStorage.get("dpCompanyAgentEdited");
        dpCompanyAgentPage.verifyDpCompanyAgentIsUpdatedSuccessfully(dpCompanyAgentEdited);
    }

    @When("^Operator delete the new Agent for the new DP Company$")
    public void operatorDeleteTheNewAgentForTheNewDpCompany()
    {
        DpCompanyAgent dpCompanyAgent = scenarioStorage.get("dpCompanyAgent");
        dpCompanyAgentPage.deleteDpCompanyAgent(dpCompanyAgent);
    }

    @Then("^Operator verify the new Agent for the new DP Company is deleted successfully$")
    public void operatorVerifyTheNewAgentForTheNewDpCompanyIsDeletedSuccessfully()
    {
        DpCompanyAgent dpCompanyAgent = scenarioStorage.get("dpCompanyAgent");
        dpCompanyAgentPage.verifyDpCompanyAgentIsDeletedSuccessfully(dpCompanyAgent);
    }

    @When("^Operator back to DP Company Management page$")
    public void operatorBackToDpCompanyManagementPage()
    {
        DpCompany dpCompany = scenarioStorage.get("dpCompany");
        dpCompanyAgentPage.backToDpCompanyManagementPage(dpCompany);
    }
}
