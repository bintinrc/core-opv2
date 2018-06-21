package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.Dp;
import co.nvqa.operator_v2.model.DpPartner;
import co.nvqa.operator_v2.model.DpUser;
import co.nvqa.operator_v2.selenium.page.DpAdministrationPage;
import com.google.inject.Inject;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

import java.util.List;
import java.util.Map;

/**
 *
 * @author Sergey Mishanin
 */
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
        dpAdminPage.addPartner(dpPartner);
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
        List<DpPartner> dpPartnersParams = dpAdminPage.dpPartnersTable().readAllEntities();
        put(KEY_LIST_OF_DP_PARTNERS, dpPartnersParams);
    }

    @When("^Operator click on Download CSV File button on DP Administration page$")
    public void operatorClickOnDownloadCSVFileButtonOnDPAdministrationPage()
    {
        dpAdminPage.downloadCsvFile();
    }

    @Then("^Downloaded CSV file contains correct DP Partners data$")
    public void downloadedCSVFileContainsCorrectDpPartnersData()
    {
        List<DpPartner> dpPartnersParams = get(KEY_LIST_OF_DP_PARTNERS);
        dpAdminPage.verifyDownloadedFileContent(dpPartnersParams);
    }

    @When("^Operator get first (\\d+) DP Partners params on DP Administration page$")
    public void operatorGetFirstDPPartnersParamsOnDPAdministrationPage(int count)
    {
        List<DpPartner> dpPartnersParams = dpAdminPage.dpPartnersTable().readFirstEntities(count);
        put(KEY_LIST_OF_DP_PARTNERS, dpPartnersParams);
    }

    @When("^Operator update created DP Partner on DP Administration page with the following attributes:$")
    public void operatorUpdateCreatedDPPartnerOnDPAdministrationPageWithTheFollowingAttributes(Map<String, String> data)
    {
        DpPartner dpPartner = get(KEY_DP_PARTNER);
        String partnerName = dpPartner.getName();
        dpPartner.fromMap(data);
        dpAdminPage.editPartner(partnerName, dpPartner);
    }

    @When("^Operator add new DP for the DP Partner on DP Administration page with the following attributes:$")
    public void operatorAddNewDPForTheDPPartnerOnDPAdministrationPageWithTheFollowingAttributes(Map<String, String> data)
    {
        DpPartner dpPartner = get(KEY_DP_PARTNER);
        Dp dp = new Dp(data);
        dpAdminPage.addDistributionPoint(dpPartner.getName(), dp);
        put(KEY_DISTRIBUTION_POINT, dp);
    }

    @Then("^Operator verify new DP params$")
    public void operatorVerifyNewDPParams()
    {
        Dp expectedDpParams = get(KEY_DISTRIBUTION_POINT);
        dpAdminPage.verifyDpParams(expectedDpParams);
    }

    @When("^Operator update created DP for the DP Partner on DP Administration page with the following attributes:$")
    public void operatorUpdateCreatedDPForTheDPPartnerOnDPAdministrationPageWithTheFollowingAttributes(Map<String, String> data)
    {
        Dp dpParams = get(KEY_DISTRIBUTION_POINT);
        String currentDpName = dpParams.getName();
        dpParams.fromMap(data);
        dpAdminPage.editDistributionPoint(currentDpName, dpParams);
    }

    @When("^Operator get all DP params on DP Administration page$")
    public void operatorGetAllDPParamsOnDPAdministrationPage()
    {
        List<Dp> dpParams = dpAdminPage.dpTable().readAllEntities();
        put(KEY_LIST_OF_DISTRIBUTION_POINTS, dpParams);
    }

    @Then("^Downloaded CSV file contains correct DP data$")
    public void downloadedCSVFileContainsCorrectDpData()
    {
        List<Dp> dpParams = get(KEY_LIST_OF_DISTRIBUTION_POINTS);
        dpAdminPage.verifyDownloadedDpFileContent(dpParams);
    }

    @When("^Operator add DP User for the created DP on DP Administration page with the following attributes:$")
    public void operatorAddDPUserForTheCreatedDPOnDPAdministrationPageWithTheFollowingAttributes(Map<String, String> data)
    {
        Dp dpParams = get(KEY_DISTRIBUTION_POINT);
        DpUser dpUser = new DpUser();
        dpUser.fromMap(data);
        dpAdminPage.addDpUser(dpParams.getName(), dpUser);
        put(KEY_DP_USER, dpUser);
    }

    @When("^Operator update created DP User for the created DP on DP Administration page with the following attributes:$")
    public void operatorUpdateDPUserForTheCreatedDPOnDPAdministrationPageWithTheFollowingAttributes(Map<String, String> data)
    {
        DpUser dpUser = get(KEY_DP_USER);
        String username = dpUser.getClientId();
        DpUser newPdUserParams = new DpUser(data);
        dpUser.merge(newPdUserParams);
        dpAdminPage.editDpUser(username, newPdUserParams);
    }

    @Then("^Operator verify new DP User params$")
    public void operatorVerifyNewDPUserParams()
    {
        DpUser dpUser = get(KEY_DP_USER);
        dpAdminPage.verifyDpUserParams(dpUser);
    }

    @When("^Operator get all DP Users params on DP Administration page$")
    public void operatorGetAllDPUsersParamsOnDPAdministrationPage()
    {
        List<DpUser> dpUsers = dpAdminPage.dpUsersTable().readAllEntities();
        put(KEY_LIST_OF_DP_USERS, dpUsers);
    }

    @Then("^Downloaded CSV file contains correct DP Users data$")
    public void downloadedCSVFileContainsCorrectDpUsersData()
    {
        List<DpUser> dpUsers = get(KEY_LIST_OF_DP_USERS);
        dpAdminPage.verifyDownloadedDpUsersFileContent(dpUsers);
    }

    @And("^Operator select View DPs action for created DP partner on DP Administration page$")
    public void operatorSelectViewDPsForCreatedDPPartnerOnDPAdministrationPage()
    {
        DpPartner dpPartner = get(KEY_DP_PARTNER);
        dpAdminPage.openViewDPsScreen(dpPartner.getName());
    }

    @And("^Operator select View Users action for created DP on DP Administration page$")
    public void operatorSelectViewUsersForCreatedDPOnDPAdministrationPage()
    {
        Dp dp = get(KEY_DISTRIBUTION_POINT);
        dpAdminPage.openViewUsersScreen(dp.getName());
    }
}
