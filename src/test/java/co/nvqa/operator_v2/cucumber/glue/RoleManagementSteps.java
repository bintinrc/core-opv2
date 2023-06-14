package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.operator_v2.model.RoleManagement;
import co.nvqa.operator_v2.selenium.page.RoleManagementPage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.time.ZonedDateTime;

/**
 * @author Tristania Siagian
 */
@ScenarioScoped
public class RoleManagementSteps extends AbstractSteps {

  private RoleManagementPage roleManagementPage;

  public RoleManagementSteps() {
  }

  @Override
  public void init() {
    roleManagementPage = new RoleManagementPage(getWebDriver());
  }

  @When("^Operator creates new role on Role Management page$")
  public void createNewRole() {
    String scenarioName = getScenarioManager().getCurrentScenario().getName();
    String uniqueCode = StandardTestUtils.generateDateUniqueString();

    RoleManagement roleManagement = new RoleManagement();
    roleManagement.setRoleName("QA_" + uniqueCode);
    roleManagement.setDesc(
        f("This role is created for testing purpose only. Ignore this role. Created at %s by scenario \"%s\".",
            DTF_CREATED_DATE.format(ZonedDateTime.now()), scenarioName));
    roleManagement.setScope("ALL_ACCESS");

    roleManagementPage.createNewRole(roleManagement);
    put("roleManagement", roleManagement);
  }

  @Then("^Operator verifies the role on Role Management page$")
  public void verifyNewRole() {
    RoleManagement roleManagement = get("roleManagement");
    roleManagementPage.verifyRoleDetails(roleManagement);
  }

  @When("^Operator deletes the role on Role Management page$")
  public void deleteRole() {
    roleManagementPage.deleteRole();
  }

  @Then("^Operator verifies the role is deleted$")
  public void verifyRoleIsDeleted() {
    RoleManagement roleManagement = get("roleManagement");
    roleManagementPage.verifyRoleIsDeleted(roleManagement);
  }

  @When("^Operator edits the role on Role Management page$")
  public void editRole() {
    RoleManagement roleManagement = get("roleManagement");

    RoleManagement roleManagementEdited = new RoleManagement();
    roleManagementEdited.setRoleName(roleManagement.getRoleName() + "_EDITED");
    roleManagementEdited.setDesc(
        f(roleManagement.getDesc() + " Modified at %s.",
            DTF_CREATED_DATE.format(ZonedDateTime.now())));
    roleManagementEdited.setScope("AUTH_ADMIN");

    put("roleManagementEdited", roleManagementEdited);
    roleManagementPage.editRole(roleManagement, roleManagementEdited);
  }

  @Then("^Operator verifies the role is edited on Role Management Page$")
  public void verifyRoleIsEdited() {
    RoleManagement roleManagementEdited = get("roleManagementEdited");
    roleManagementPage.verifyRoleDetails(roleManagementEdited);
  }

  @Then("^Operator verifies the edited role is deleted$")
  public void verifyEditedRoleIsDeleted() {
    RoleManagement roleManagementEdited = get("roleManagementEdited");
    roleManagementPage.verifyRoleIsDeleted(roleManagementEdited);
  }
}
