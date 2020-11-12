package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.SortAppUser;
import co.nvqa.operator_v2.selenium.page.SortAppUserManagementPage;
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
public class SortAppUserManagementSteps extends AbstractSteps
{
    private SortAppUserManagementPage sortAppUserManagementPage;

    public SortAppUserManagementSteps()
    {
    }

    @Override
    public void init()
    {
        sortAppUserManagementPage = new SortAppUserManagementPage(getWebDriver());
    }

    @When("Operator create new Sort App User with details:")
    public void operatorCreateNewSortAppUser(List<SortAppUser> sortAppUsers)
    {
        LocalDateTime today = LocalDateTime.now();
        DateTimeFormatter calFormatter = DateTimeFormatter.ofPattern("MMMM d, yyyy", Locale.ENGLISH);
        DateTimeFormatter dataFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH);

        for (SortAppUser sortAppUser : sortAppUsers)
        {
            sortAppUserManagementPage.clickAddSortAppUserButton();
            sortAppUserManagementPage.fillFirstName(sortAppUser.getFirstName());
            sortAppUserManagementPage.fillLastName(sortAppUser.getLastName());
            sortAppUserManagementPage.fillContact(sortAppUser.getContact());

            if ("DUPLICATED".equalsIgnoreCase(sortAppUser.getUsername()))
            {
                sortAppUserManagementPage.fillUsername(get(KEY_EXISTED_SORT_APP_USERNAME));
                put(KeyConstants.KEY_IS_INVALID, true);
            } else if ("RANDOM".equalsIgnoreCase(sortAppUser.getUsername())) {
                String username = "AUTO" + generateRequestedTrackingNumber();
                System.out.println(username);
                sortAppUser.setUsername(username);
                sortAppUserManagementPage.fillUsername(username);
                put(KeyConstants.KEY_IS_INVALID, false);
            }

            sortAppUserManagementPage.fillPassword(sortAppUser.getPassword());
            sortAppUserManagementPage.selectEmploymentType(sortAppUser.getEmploymentType());

            sortAppUser.setEmploymentStartDate(dataFormatter.format(today));
            sortAppUserManagementPage.selectEmploymentStartDate(calFormatter.format(today));

            sortAppUserManagementPage.selectPrimaryHubForSortAppUser(sortAppUser.getPrimaryHub());
            if (sortAppUser.getAdditionalHub() != null) {
                sortAppUserManagementPage.selectAdditionalHubForSortAppUser(sortAppUser.getAdditionalHub());
            }
            sortAppUserManagementPage.fillWareHouseTeamFormation(sortAppUser.getWarehouseTeamFormation());
            sortAppUserManagementPage.fillPosition(sortAppUser.getPosition());
            sortAppUserManagementPage.fillComments(sortAppUser.getComments());
            sortAppUserManagementPage.clickCreateEditHubUserButton(get(KeyConstants.KEY_IS_INVALID));
        }
        if (sortAppUsers.size() > 1) {
            for (SortAppUser sortAppUser : sortAppUsers) {
                put(KEY_LIST_OF_CREATED_SORT_APP_DETAILS, sortAppUser);
                put(KEY_LIST_OF_CREATED_SORT_APP_USERNAME, sortAppUser.getUsername());
            }
        } else {
            put(KEY_CREATED_SORT_APP_DETAILS, sortAppUsers);
            put(KEY_CREATED_SORT_APP_USERNAME, sortAppUsers.get(0).getUsername());
        }
    }

    @When("Operator create new Sort App User with negative scenarios using details:")
    public void operatorCreateNewSortAppUserNegativeScenario(List<SortAppUser> sortAppUsers)
    {
        LocalDateTime today = LocalDateTime.now();
        DateTimeFormatter calFormatter = DateTimeFormatter.ofPattern("MMMM d, yyyy", Locale.ENGLISH);
        DateTimeFormatter dataFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH);

        for (SortAppUser sortAppUser : sortAppUsers)
        {
            sortAppUserManagementPage.clickAddSortAppUserButton();
            sortAppUserManagementPage.fillFirstName(sortAppUser.getFirstName());
            sortAppUserManagementPage.fillLastName(sortAppUser.getLastName());
            sortAppUserManagementPage.fillContact(sortAppUser.getContact());

            if ("RANDOM".equalsIgnoreCase(sortAppUser.getUsername())) {
                sortAppUserManagementPage.fillUsername("AUTO" + generateRequestedTrackingNumber());
            }

            sortAppUserManagementPage.fillPassword(sortAppUser.getPassword());
            sortAppUserManagementPage.selectEmploymentType(sortAppUser.getEmploymentType());

            if (!("".equalsIgnoreCase(sortAppUser.getEmploymentStartDate()))) {
                sortAppUser.setEmploymentStartDate(dataFormatter.format(today));
                sortAppUserManagementPage.selectEmploymentStartDate(calFormatter.format(today));
            }

            if (!("".equalsIgnoreCase(sortAppUser.getPrimaryHub()))) {
                sortAppUserManagementPage.selectPrimaryHubForSortAppUser(sortAppUser.getPrimaryHub());
            }

            sortAppUserManagementPage.fillWareHouseTeamFormation(sortAppUser.getWarehouseTeamFormation());
            sortAppUserManagementPage.fillPosition(sortAppUser.getPosition());
            sortAppUserManagementPage.fillComments(sortAppUser.getComments());
            sortAppUserManagementPage.clickCreateEditHubUserButton(true);
        }
    }

    @And("Operator Load all the Sort App User")
    public void operatorLoadAllTheSortAppUser()
    {
        navigateRefresh();
        pause2s();
        sortAppUserManagementPage.clickAllSortAppUser();
    }

    @Then("Operator verifies that the newly created Sort App User will be shown")
    public void operatorVerifiesThatTheNewlyCreatedSortAppUserWillBeShown() {
        pause2s();
        if (get(KEY_LIST_OF_CREATED_SORT_APP_DETAILS) == null) {
            List<SortAppUser> sortAppUser = get(KEY_CREATED_SORT_APP_DETAILS);
            sortAppUserManagementPage.checkTheSortAppUserIsCreated(sortAppUser.get(0));
        } else {
            List<SortAppUser> sortAppUsersToList = get(KEY_LIST_OF_CREATED_SORT_APP_DETAILS);
            for (SortAppUser sortAppUser : sortAppUsersToList) {
                int index = 0;
                sortAppUserManagementPage.checkTheSortAppUserIsCreated(sortAppUser);
                index++;
            }
        }
    }

    @Then("Operator verifies that there will be a duplication error toast shown")
    public void operatorVerifiesThatThereWillBeADuplicationErrorToastShown()
    {
        String existedUsername = get(KEY_EXISTED_SORT_APP_USERNAME);
        sortAppUserManagementPage.verifiesDuplicationErrorToastShown(existedUsername);
    }

    @Then("Operator verifies that there will be UI error of empty field of {string} shown")
    public void operatorVerifiesThatThereWillBeUIErrorOfEmptyFieldOfShown(String errorMessage)
    {
        sortAppUserManagementPage.emptyErrorMessage(errorMessage);
    }

    @When("Operator fills the {string} filter and select the value based on created Sort App User")
    public void operatorFillsTheFilterAndSelectTheValueBasedOnCreatedSortAppUser(String filterName)
    {
        List<SortAppUser> sortAppUser = get(KEY_CREATED_SORT_APP_DETAILS);
        sortAppUserManagementPage.selectFilter(filterName, sortAppUser.get(0));
    }

    @When("Operator fills the filter without creating Sort App User")
    public void operatorFillsTheFilterWithoutCreatingSortAppUser()
    {
        sortAppUserManagementPage.selectFilterWithoutCreatingSortAppUser();
    }

    @And("Operator clicks on the clear filter button on the Sort App User Management Page")
    public void operatorClicksOnTheClearFilterButtonOnTheSortAppUserManagementPage()
    {
        sortAppUserManagementPage.clickClearFilters();
    }

    @Then("Operator verifies that the filter is blank")
    public void operatorVerifiesThatTheFilterIsBlank()
    {
        sortAppUserManagementPage.verifiesUnselectedFilter();
    }

    @And("Operator edits the existed Sort App User with details:")
    public void operatorEditsTheExistedSortAppUserWithDetails(List<SortAppUser> sortAppUsers)
    {
        List<SortAppUser> existedSortAppUser = get(KEY_CREATED_SORT_APP_DETAILS);
        sortAppUsers.get(0).setUsername(existedSortAppUser.get(0).getUsername());
        sortAppUsers.get(0).setEmploymentStartDate(existedSortAppUser.get(0).getEmploymentStartDate());

        for (SortAppUser sortAppUser : sortAppUsers)
        {
            sortAppUserManagementPage.clickEditSortAppUser();

            pause1s();
            sortAppUserManagementPage.fillFirstName(sortAppUser.getFirstName());
            sortAppUserManagementPage.fillLastName(sortAppUser.getLastName());
            if (sortAppUser.getLastName() == null || "".equalsIgnoreCase(sortAppUser.getLastName())) {
                sortAppUser.setLastName(null);
            }
            sortAppUserManagementPage.fillContact(sortAppUser.getContact());
            sortAppUserManagementPage.fillPassword(sortAppUser.getPassword());

            sortAppUserManagementPage.selectEmploymentType(sortAppUser.getEmploymentType());
            sortAppUserManagementPage.selectEmploymentActivity(sortAppUser.getEmploymentStatus());

            sortAppUserManagementPage.selectPrimaryHubForSortAppUser(sortAppUser.getPrimaryHub());
            sortAppUserManagementPage.fillWareHouseTeamFormation(sortAppUser.getWarehouseTeamFormation());
            sortAppUserManagementPage.fillPosition(sortAppUser.getPosition());
            sortAppUserManagementPage.fillComments(sortAppUser.getComments());
            sortAppUserManagementPage.clickCreateEditHubUserButton(true, true);
        }
        if (sortAppUsers.size() > 1) {
            for (SortAppUser sortAppUser : sortAppUsers) {
                put(KEY_LIST_OF_CREATED_SORT_APP_DETAILS, sortAppUser);
            }
        } else {
            put(KEY_CREATED_SORT_APP_DETAILS, sortAppUsers);
        }
    }

    @And("Operator edits the existed Sort App User with negative scenario using details:")
    public void operatorEditsTheExistedSortAppUserWithNegativeScenarioUsingDetails(List<SortAppUser> sortAppUsers)
    {
        for (SortAppUser sortAppUser : sortAppUsers)
        {
            sortAppUserManagementPage.clickEditSortAppUser();

            pause1s();
            sortAppUserManagementPage.fillFirstName(sortAppUser.getFirstName());
            sortAppUserManagementPage.fillPosition(sortAppUser.getPosition());
        }
    }
}
