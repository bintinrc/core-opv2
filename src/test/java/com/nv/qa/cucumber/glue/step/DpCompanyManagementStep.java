package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.model.DpCompany;
import com.nv.qa.selenium.page.DpCompanyManagementPage;
import com.nv.qa.support.ScenarioStorage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class DpCompanyManagementStep extends AbstractSteps
{
    @Inject ScenarioStorage scenarioStorage;
    private DpCompanyManagementPage dpCompanyManagementPage;

    @Inject
    public DpCompanyManagementStep(CommonScenario commonScenario)
    {
        super(commonScenario);
    }

    @Override
    public void init()
    {
        dpCompanyManagementPage = new DpCompanyManagementPage(getDriver());
    }

    @When("^Operator add new DP Company$")
    public void operatorAddDpCompany()
    {
        String uniqueCode = String.valueOf(System.currentTimeMillis());
        DpCompany dpCompany = new DpCompany();
        dpCompany.setName(String.format("DP Company #%s", uniqueCode));
        dpCompany.setEmail(String.format("dp.company.%s@test.com", uniqueCode));
        dpCompany.setContact(String.format("65%s", uniqueCode));
        dpCompany.setDropOffWebhookUrl(String.format("https://www.dropoffwebhook-%s.com", uniqueCode));
        dpCompany.setCollectWebhookUrl(String.format("https://www.collectwebhook-%s.com", uniqueCode));
        dpCompanyManagementPage.addDpCompany(dpCompany);
        scenarioStorage.put("dpCompany", dpCompany);
    }

    @Then("^Operator verify the new DP Company is created successfully$")
    public void operatorVerifyDpCompanyIsCreatedSuccessfully()
    {
        DpCompany dpCompany = scenarioStorage.get("dpCompany");
        dpCompanyManagementPage.verifyDpCompanyIsCreatedSuccessfully(dpCompany);
    }
}
