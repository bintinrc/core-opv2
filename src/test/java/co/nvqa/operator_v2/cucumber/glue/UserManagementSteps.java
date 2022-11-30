package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.operator_v2.model.UserManagement;
import co.nvqa.operator_v2.selenium.page.UserManagementPage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import org.apache.commons.lang3.SerializationUtils;
import org.junit.Assert;

/**
 * @author Tristania Siagian
 */
@ScenarioScoped
public class UserManagementSteps extends AbstractSteps {

  private UserManagementPage userManagementPage;

  public UserManagementSteps() {
  }

  @Override
  public void init() {
    userManagementPage = new UserManagementPage(getWebDriver());
  }

  @When("^Operator create new user on User Management page$")
  public void createUserManagementPage() {
    String uniqueCode = StandardTestUtils.generateDateUniqueString();

    UserManagement userManagement = new UserManagement();
    userManagement.setEmail(f("automation.%s@gmail.com", uniqueCode));
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
    userManagementPage.verifyUserOnUserManagement(userManagementEdited);
  }

  @When("^Operator filling the Grant Type Field with value \"(.+)\" on User Management page and load the data$")
  public void clickGrantTypeFilter(String value) {
    userManagementPage.selectGrantTypeFilter(value);
    switch (value.toLowerCase()) {
      case "google":
        put(KEY_SELECTED_GRANT_TYPE, "GOOGLE_SSO");
        break;
    }
  }

  @Then("^Operator verify the result on the table has the same Grant Type that has been input$")
  public void verifyGrantType() {
    String grantType = get(KEY_SELECTED_GRANT_TYPE);
    Assert.assertNotNull("Selected Grant Type", grantType);
    UserManagement userManagement = new UserManagement();
    userManagement.setGrantType(grantType);
    userManagementPage.verifyGrantType(userManagement);
    put(KEY_CREATED_USER_MANAGEMENT, userManagement);
  }
}
