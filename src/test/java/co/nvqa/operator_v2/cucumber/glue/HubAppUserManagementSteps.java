package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.HubAppUser;
import co.nvqa.operator_v2.selenium.page.HubAppUserManagementPage;
import co.nvqa.operator_v2.util.KeyConstants;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;

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
        LocalDateTime today = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH);

        for (HubAppUser hubAppUser : hubAppUsers)
        {
            hubAppUserManagementPage.clickAddHubUserButton();
            hubAppUserManagementPage.fillFirstName(hubAppUser.getFirstName());
            hubAppUserManagementPage.fillLastName(hubAppUser.getLastName());
            hubAppUserManagementPage.fillContact(hubAppUser.getContact());

            if ("DUPLICATED".equalsIgnoreCase(hubAppUser.getUsername()))
            {
                hubAppUserManagementPage.fillUsername(get(KEY_EXISTED_HUB_APP_USERNAME));
                put(KeyConstants.KEY_IS_INVALID, true);
            } else if ("RANDOM".equalsIgnoreCase(hubAppUser.getUsername())) {
                String username = "AUTO" + generateRequestedTrackingNumber();
                System.out.println(username);
                hubAppUser.setUsername(username);
                hubAppUserManagementPage.fillUsername(username);
                put(KeyConstants.KEY_IS_INVALID, false);
            }

            hubAppUserManagementPage.fillPassword(hubAppUser.getPassword());
            hubAppUserManagementPage.selectEmploymentType(hubAppUser.getEmploymentType());

            hubAppUser.setEmploymentStartDate(formatter.format(today));
            hubAppUserManagementPage.selectEmploymentStartDate(hubAppUser.getEmploymentStartDate());

            hubAppUserManagementPage.selectHubForHubAppUser(hubAppUser.getHub());
            hubAppUserManagementPage.fillWareHouseTeamFormation(hubAppUser.getWarehouseTeamFormation());
            hubAppUserManagementPage.fillPosition(hubAppUser.getPosition());
            hubAppUserManagementPage.fillComments(hubAppUser.getComments());
            hubAppUserManagementPage.clickCreateEditHubUserButton(get(KeyConstants.KEY_IS_INVALID));
        }
        if (hubAppUsers.size() > 1) {
            for (HubAppUser hubAppUser : hubAppUsers) {
                put(KEY_LIST_OF_CREATED_HUB_APP_DETAILS, hubAppUser);
                put(KEY_LIST_OF_CREATED_HUB_APP_USERNAME, hubAppUser.getUsername());
            }
        } else {
            put(KEY_CREATED_HUB_APP_DETAILS, hubAppUsers);
            put(KEY_CREATED_HUB_APP_USERNAME, hubAppUsers.get(0).getUsername());
        }
    }

    @When("Operator create new Hub App User with negative scenarios using details:")
    public void operatorCreateNewHubAppUserNegativeScenario(List<HubAppUser> hubAppUsers)
    {
        LocalDateTime today = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH);

        for (HubAppUser hubAppUser : hubAppUsers)
        {
            hubAppUserManagementPage.clickAddHubUserButton();
            hubAppUserManagementPage.fillFirstName(hubAppUser.getFirstName());
            hubAppUserManagementPage.fillLastName(hubAppUser.getLastName());
            hubAppUserManagementPage.fillContact(hubAppUser.getContact());

            if ("RANDOM".equalsIgnoreCase(hubAppUser.getUsername())) {
                hubAppUserManagementPage.fillUsername("AUTO" + generateRequestedTrackingNumber());
            }

            hubAppUserManagementPage.fillPassword(hubAppUser.getPassword());
            hubAppUserManagementPage.selectEmploymentType(hubAppUser.getEmploymentType());

            if (!("".equalsIgnoreCase(hubAppUser.getEmploymentStartDate()))) {
                hubAppUser.setEmploymentStartDate(formatter.format(today));
                hubAppUserManagementPage.selectEmploymentStartDate(hubAppUser.getEmploymentStartDate());
            }

            if (!("".equalsIgnoreCase(hubAppUser.getHub()))) {
                hubAppUserManagementPage.selectHubForHubAppUser(hubAppUser.getHub());
            }

            hubAppUserManagementPage.fillWareHouseTeamFormation(hubAppUser.getWarehouseTeamFormation());
            hubAppUserManagementPage.fillPosition(hubAppUser.getPosition());
            hubAppUserManagementPage.fillComments(hubAppUser.getComments());
            hubAppUserManagementPage.clickCreateEditHubUserButton(true);
        }
    }

    @And("Operator Load all the Hub App User")
    public void operatorLoadAllTheHubAppUser()
    {
        hubAppUserManagementPage.clickAllHubAppUser();
    }

    @Then("Operator verifies that the newly created Hub App User will be shown")
    public void operatorVerifiesThatTheNewlyCreatedHubAppUserWillBeShown() {
        if (get(KEY_LIST_OF_CREATED_HUB_APP_DETAILS) == null) {
            List<HubAppUser> hubAppUser = get(KEY_CREATED_HUB_APP_DETAILS);
            hubAppUserManagementPage.checkTheHubAppUserIsCreated(hubAppUser.get(0));
        } else {
            List<HubAppUser> hubAppUsersToList = get(KEY_LIST_OF_CREATED_HUB_APP_DETAILS);
            for (HubAppUser hubAppUser : hubAppUsersToList) {
                int index = 0;
                hubAppUserManagementPage.checkTheHubAppUserIsCreated(hubAppUser);
                index++;
            }
        }
    }

    @Then("Operator verifies that there will be a duplication error toast shown")
    public void operatorVerifiesThatThereWillBeADuplicationErrorToastShown()
    {
        String existedUsername = get(KEY_EXISTED_HUB_APP_USERNAME);
        hubAppUserManagementPage.verifiesDuplicationErrorToastShown(existedUsername);
    }

    @Then("Operator verifies that there will be UI error of empty field of {string} shown")
    public void operatorVerifiesThatThereWillBeUIErrorOfEmptyFieldOfShown(String errorMessage)
    {
        hubAppUserManagementPage.emptyErrorMessage(errorMessage);
    }

    @When("Operator fills the {string} filter and select the value based on created Hub App User")
    public void operatorFillsTheFilterAndSelectTheValueBasedOnCreatedHubAppUser(String filterName)
    {
        List<HubAppUser> hubAppUser = get(KEY_CREATED_HUB_APP_DETAILS);
        hubAppUserManagementPage.selectFilter(filterName, hubAppUser.get(0));
    }

    @When("Operator fills the filter without creating Hub App User")
    public void operatorFillsTheFilterWithoutCreatingHubAppUser()
    {
        hubAppUserManagementPage.selectFilterWithoutCreatingHubAppUser();
    }

    @And("Operator clicks on the clear filter button on the Hub App User Management Page")
    public void operatorClicksOnTheClearFilterButtonOnTheHubAppUserManagementPage()
    {
        hubAppUserManagementPage.clickClearFilters();
    }

    @Then("Operator verifies that the filter is blank")
    public void operatorVerifiesThatTheFilterIsBlank()
    {
        hubAppUserManagementPage.verifiesUnselectedFilter();
    }

    @And("Operator edits the existed Hub App User with details:")
    public void operatorEditsTheExistedHubAppUserWithDetails(List<HubAppUser> hubAppUsers)
    {
        List<HubAppUser> existedHubAppUser = get(KEY_CREATED_HUB_APP_DETAILS);
        hubAppUsers.get(0).setUsername(existedHubAppUser.get(0).getUsername());
        hubAppUsers.get(0).setEmploymentStartDate(existedHubAppUser.get(0).getEmploymentStartDate());

        for (HubAppUser hubAppUser : hubAppUsers)
        {
            hubAppUserManagementPage.clickEditHubAppUser();

            pause1s();
            hubAppUserManagementPage.fillFirstName(hubAppUser.getFirstName());
            hubAppUserManagementPage.fillLastName(hubAppUser.getLastName());
            if (hubAppUser.getLastName() == null || "".equalsIgnoreCase(hubAppUser.getLastName())) {
                hubAppUser.setLastName(null);
            }
            hubAppUserManagementPage.fillContact(hubAppUser.getContact());
            hubAppUserManagementPage.fillPassword(hubAppUser.getPassword());

            hubAppUserManagementPage.selectEmploymentType(hubAppUser.getEmploymentType());
            hubAppUserManagementPage.selectEmploymentActivity(hubAppUser.getEmploymentStatus());

            hubAppUserManagementPage.selectHubForHubAppUser(hubAppUser.getHub());
            hubAppUserManagementPage.fillWareHouseTeamFormation(hubAppUser.getWarehouseTeamFormation());
            hubAppUserManagementPage.fillPosition(hubAppUser.getPosition());
            hubAppUserManagementPage.fillComments(hubAppUser.getComments());
            hubAppUserManagementPage.clickCreateEditHubUserButton(true, true);
        }
        if (hubAppUsers.size() > 1) {
            for (HubAppUser hubAppUser : hubAppUsers) {
                put(KEY_LIST_OF_CREATED_HUB_APP_DETAILS, hubAppUser);
            }
        } else {
            put(KEY_CREATED_HUB_APP_DETAILS, hubAppUsers);
        }
    }

    @And("Operator edits the existed Hub App User with negative scenario using details:")
    public void operatorEditsTheExistedHubAppUserWithNegativeScenarioUsingDetails(List<HubAppUser> hubAppUsers)
    {
        for (HubAppUser hubAppUser : hubAppUsers)
        {
            hubAppUserManagementPage.clickEditHubAppUser();

            pause1s();
            hubAppUserManagementPage.fillFirstName(hubAppUser.getFirstName());
            hubAppUserManagementPage.fillPosition(hubAppUser.getPosition());
        }
    }
}
