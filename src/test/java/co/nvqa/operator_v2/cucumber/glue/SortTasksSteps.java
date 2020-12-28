package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.SortTasksPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.Map;

/**
 * @author Niko Susanto
 */
@ScenarioScoped
public class SortTasksSteps extends AbstractSteps {

  private SortTasksPage sortTasksPage;

  public SortTasksSteps() {
  }

  @Override
  public void init() {
    sortTasksPage = new SortTasksPage(getWebDriver());
  }

  @When("^Operator select the hub in the Hub dropdown menu$")
  public void operatorSelectTheHubInTheHubDropdownMenu(Map<String, String> data) {
    String hubName = data.get("hubName");
    sortTasksPage.selectHub(hubName);
  }

  @When("^Operator open the sidebar menu$")
  public void operatorOpenTheSidebarMenu() {
    sortTasksPage.openSidebar();
  }

  @When("^Operator open create new middle tier$")
  public void operatorOpenCreateNewMiddleTier(Map<String, String> mapOfData) {
    String name = mapOfData.get("name");
    String uniqueCode = generateDateUniqueString();

    if ("GENERATED".equals(name)) {
      name = "MIDTIERDONOTUSE" + uniqueCode;
    }

    sortTasksPage.createMiddleTier(name);
    put(KEY_CREATED_MIDDLE_TIER, name);
  }

  @Then("^Operator verify success create new mid tier toast is shown$")
  public void operatorVerifySuccessCreateNewMidTierToastIsShown() {
    sortTasksPage.waitUntilInvisibilityOfNotification("New Middle Tier Created", true);
  }

  @Then("^Operator verify new middle tier is created$")
  public void operatorVerifyNewMiddleTierIsCreated(Map<String, String> mapOfData) {
    String sortName = get(KEY_CREATED_MIDDLE_TIER);
    String hubName = mapOfData.get("hubName");
    String sortType = mapOfData.get("sortType");

    sortTasksPage.verifyMidTierIsExistAndDataIsCorrect(sortName, hubName, sortType);
  }

  @Then("^Operator delete the middle tier$")
  public void operatorDeleteTheMiddleTier() {
    sortTasksPage.deleteMidTier();
  }

  @Then("^Operator verify success delete mid tier toast is shown$")
  public void operatorVerifySuccessDeleteMidTierToastIsShown() {
    sortTasksPage.waitUntilInvisibilityOfNotification("Middle Tier Deleted", true);
  }

  @Then("^Operator verify middle tier is deleted$")
  public void operatorVerifyMiddleTierIsDeleted() {
    sortTasksPage.verifyMidTierIsDeleted();
  }

  @Then("^Operator select a sort task$")
  public void operatorSelectASortTask() {
    String sortName = get(KEY_CREATED_MIDDLE_TIER);
    sortTasksPage.selectSortTask(sortName);
  }

  @Then("^Operator verify success modified toast is shown$")
  public void operatorVerifySuccessModifiedToastIsShown() {
    sortTasksPage.waitUntilInvisibilityOfNotification("modified", true);
  }

  @Then("^Operator verify added outputs appears on tree list$")
  public void operatorVerifyAddedOutputsSAppearsOnTreeList() {
    String sortName = get(KEY_CREATED_MIDDLE_TIER);
    sortTasksPage.verifyOutput(sortName);
  }

  @Then("^Operator verify removed outputs removed on tree list$")
  public void operatorVerifyRemovedOutputsRemovedOnTreeList() {
    String sortName = get(KEY_CREATED_MIDDLE_TIER);
    sortTasksPage.verifyOutputDeleted(sortName);
  }
}