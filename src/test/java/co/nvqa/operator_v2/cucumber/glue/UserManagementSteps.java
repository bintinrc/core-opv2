package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.UserManagement;
import co.nvqa.operator_v2.selenium.page.UserManagementPage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.SerializationUtils;

/**
 *
 * @author Tristania Siagian
 */
@ScenarioScoped
public class UserManagementSteps extends AbstractSteps {
    private UserManagementPage userManagementPage;

    @Inject
    public UserManagementSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage) {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init() {
        userManagementPage = new UserManagementPage(getWebDriver());
    }

    @When("^Operator create new user on User Management page$")
    public void createUserManagementPage() {
        String uniqueCode = generateDateUniqueString();

        UserManagement userManagement = new UserManagement();
        userManagement.setEmail(String.format("automation.%s@gmail.com", uniqueCode));
        userManagement.setGrantType("GOOGLE_SSO");
        userManagement.setFirstName("Automation");
        userManagement.setLastName(uniqueCode);
        userManagement.setRoles("SUPER_USERS");
        userManagementPage.createUser(userManagement);
        put(KEY_CREATED_USER_MANAGEMENT, userManagement);
    }

    @Then("^Operator verify the new user on User Management page$")
    public void verifyUserOnUserManagement() {
        UserManagement userManagement = get(KEY_CREATED_USER_MANAGEMENT);
        userManagementPage.verifyUserOnUserManagement(userManagement);
    }

    @When("^Operator edit a user on User Management page$")
    public void editUser() {
        UserManagement userManagement = get(KEY_CREATED_USER_MANAGEMENT);

        UserManagement userManagementEdited = SerializationUtils.clone(userManagement);
        userManagementEdited.setRoles("OPERATOR_ADMINS");

        put(KEY_UPDATED_USER_MANAGEMENT, userManagementEdited);
        userManagementPage.editUser(userManagement, userManagementEdited);
    }

    @Then("^Operator verify the edited user on User Management page is existed$")
    public void verifyEditedUserOnUserManagement() {
        UserManagement userManagementEdited = get(KEY_UPDATED_USER_MANAGEMENT);
        userManagementPage.verifyEditedUserOnUserManagement(userManagementEdited);
    }

    @When("^Operator filling the Grant Type Field on User Management page and load the data$")
    public void clickGrantTypeFilter() {
        userManagementPage.clickGrantTypeFilter();
    }

    @Then("^Operator verify the result on the table has the same Grant Type that has been input$")
    public void verifyGrantType() {
        UserManagement userManagement = new UserManagement();
        userManagement.setGrantType("GOOGLE_SSO");
        userManagementPage.verifyGrantType(userManagement);
        put(KEY_CREATED_USER_MANAGEMENT, userManagement);
    }
}
