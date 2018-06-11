package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.DpPartner;
import co.nvqa.operator_v2.selenium.page.DpAdministrationPage;
import com.google.inject.Inject;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

import java.util.List;
import java.util.Map;

public class DpAdministrationSteps extends AbstractSteps
{
    private DpAdministrationPage dpAdminPage;

    @Inject
    public DpAdministrationSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        dpAdminPage = new DpAdministrationPage(getWebDriver());
    }

    @Given("^Operator add new DP Partner on DP Administration page with the following attributes:$")
    public void operatorAddNewDPPartnerOnDPAdministrationPageWithTheFollowingAttributes(Map<String, String> data)
    {
        DpPartner dpPartner = new DpPartner(data);
        dpAdminPage.addParner(dpPartner);
        put(KEY_DP_PARTNER, dpPartner);
    }

    @Then("^Operator verify new DP Partner params$")
    public void operatorVerifyNewDPPartnerParams()
    {
        DpPartner dpPartner = get(KEY_DP_PARTNER);
        dpAdminPage.verifyDpPartnerParams(dpPartner);
    }

    @When("^Operator get all DP Partners params on DP Administration page$")
    public void operatorGetAllDPPartnersParamsOnDriverTypeManagementPage()
    {
        List<DpPartner> dpPartnersParams = dpAdminPage.dpPartnersTable().getAllDpPartnersParams();
        put(KEY_LIST_OF_DP_PARTNERS, dpPartnersParams);
    }

    @When("^Operator click on Download CSV File button on DP Administration page$")
    public void operatorClickOnDownloadCSVFileButtonOnDPAdministrationPage()
    {
        dpAdminPage.downloadCsvFile();
    }

    @Then("^Downloaded CSV file contains correct PD Partners data$")
    public void downloadedCSVFileContainsCorrectPDPartnersData()
    {
        List<DpPartner> dpPartnersParams = get(KEY_LIST_OF_DP_PARTNERS);
        dpAdminPage.verifyDownloadedFileContent(dpPartnersParams);
    }

    @When("^Operator get first (\\d+) DP Partners params on DP Administration page$")
    public void operatorGetFirstDPPartnersParamsOnDPAdministrationPage(int count)
    {
        List<DpPartner> dpPartnersParams = dpAdminPage.dpPartnersTable().getFirstDpPartnersParams(count);
        put(KEY_LIST_OF_DP_PARTNERS, dpPartnersParams);
    }
}
