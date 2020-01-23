package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.HubAppUser;
import co.nvqa.operator_v2.selenium.page.HubAppUserManagementPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

import java.util.List;

/**
 * @author Tristania Siagian
 */
public class HubAppUserManagementSteps extends AbstractSteps
{
    private HubAppUserManagementPage hubAppUserManagementPage;

    public HubAppUserManagementSteps()
    {
    }

    @Override
    public void init()
    {
        hubAppUserManagementPage = new HubAppUserManagementPage(getWebDriver());
    }

    @When("Operator create new Hub App User with details:")
    public void operatorCreateNewHubAppUser(List<HubAppUser> hubAppUsers)
    {
        for (HubAppUser hubAppUser : hubAppUsers)
        {
            hubAppUserManagementPage.clickAddHubUserButton();
            hubAppUserManagementPage.fillFirstName(hubAppUser.getFirstName());
            hubAppUserManagementPage.fillLastName(hubAppUser.getLastName());
            hubAppUserManagementPage.fillContact(hubAppUser.getContact());

            if ("DUPLICATED".equalsIgnoreCase(hubAppUser.getUsername()))
            {
                hubAppUserManagementPage.fillUsername(get(KEY_EXISTED_HUB_APP_USERNAME));
            } else if ("RANDOM".equalsIgnoreCase(hubAppUser.getUsername())) {
                hubAppUserManagementPage.fillUsername("AUTO" + generateRequestedTrackingNumber());
            }

            hubAppUserManagementPage.fillPassword(hubAppUser.getPassword());
            hubAppUserManagementPage.selectEmploymentType(hubAppUser.getEmploymentType());
            hubAppUserManagementPage.selectEmploymentStartDate(hubAppUser.getEmploymentStartDate());
            hubAppUserManagementPage.selectHubForHubAppUser(hubAppUser.getHub());
            hubAppUserManagementPage.fillWareHouseTeamFormation(hubAppUser.getWarehouseTeamFormation());
            hubAppUserManagementPage.fillPosition(hubAppUser.getPosition());
            hubAppUserManagementPage.fillComments(hubAppUser.getComments());
            hubAppUserManagementPage.clickCreateHubUserButton();
        }
        put(KEY_CREATED_HUB_APP_DETAILS, hubAppUsers);
    }

    @And("Operator Load all the Hub App User")
    public void operatorLoadAllTheHubAppUser()
    {
        hubAppUserManagementPage.clickAllHubAppUser();
    }

    @Then("Operator verifies that the newly created Hub App User will be shown")
    public void operatorVerifiesThatTheNewlyCreatedHubAppUserWillBeShown()
    {
        HubAppUser hubAppUser = get(KEY_CREATED_HUB_APP_DETAILS);
        hubAppUserManagementPage.checkTheHubAppUserIsCreated(hubAppUser);
    }

    @Then("Operator verifies that there will be a duplication error toast shown")
    public void operatorVerifiesThatThereWillBeADuplicationErrorToastShown()
    {
        hubAppUserManagementPage.verifiesDuplicationErrorToastShown();
    }

    @Then("Operator verifies that there will be UI error of empty field of {string} shown")
    public void operatorVerifiesThatThereWillBeUIErrorOfEmptyFieldOfShown(String errorMessage)
    {
        hubAppUserManagementPage.emptyErrorMessage(errorMessage);
    }
}
