package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.RoleManagement;
import co.nvqa.operator_v2.selenium.page.RoleManagementV2Page;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.util.Date;


@ScenarioScoped
public class RoleManagementV2Steps extends AbstractSteps {

  private RoleManagementV2Page roleManagementV2Page;

  public RoleManagementV2Steps() {
  }

  @Override
  public void init() {
    roleManagementV2Page = new RoleManagementV2Page(getWebDriver());
  }

  @When("^Operator creates new role on Role Management v2 page$")
  public void createNewRole() {
    String scenarioName = getScenarioManager().getCurrentScenario().getName();
    String uniqueCode = generateDateUniqueString();

    RoleManagement roleManagement = new RoleManagement();
    roleManagement.setRoleName("QA_" + uniqueCode);
    roleManagement.setDesc(
        f("This role is created for testing purpose only. Ignore this role. Created at %s by scenario \"%s\".",
            CREATED_DATE_SDF.format(new Date()), scenarioName));

    roleManagementV2Page.createNewRole(roleManagement);
    put("roleManagement", roleManagement);
  }

  @Then("^Operator verifies the role on Role Management V2 page$")
  public void verifyNewRole() {
    RoleManagement roleManagement = get("roleManagement");
    roleManagementV2Page.verifyRoleDetails(roleManagement);
  }

  @When("^Operator deletes the role on Role Management V2 page$")
  public void deleteRole() {
    roleManagementV2Page.deleteRole();
  }

  @Then("^Operator verifies the role is deleted on Role Management V2 page$")
  public void verifyRoleIsDeleted() {
    RoleManagement roleManagement = get("roleManagement");
    roleManagementV2Page.verifyRoleIsDeleted(roleManagement);
  }

  @When("^Operator edits the role on Role Management V2 page$")
  public void editRole() {
    RoleManagement roleManagement = get("roleManagement");

    RoleManagement roleManagementEdited = new RoleManagement();
    roleManagementEdited.setRoleName(roleManagement.getRoleName() + "_EDITED");
    roleManagementEdited.setDesc(
        f(roleManagement.getDesc() + " Modified at %s.", CREATED_DATE_SDF.format(new Date())));
    roleManagementEdited.setScope("AUTH_ADMIN");

    put("roleManagementEdited", roleManagementEdited);
    roleManagementV2Page.editRole(roleManagementEdited);
  }

  @Then("^Operator verifies the role is edited on Role Management V2 Page$")
  public void verifyRoleIsEdited() {
    RoleManagement roleManagementEdited = get("roleManagementEdited");
    roleManagementV2Page.verifyEditedRoleDetails(roleManagementEdited);
  }
}
