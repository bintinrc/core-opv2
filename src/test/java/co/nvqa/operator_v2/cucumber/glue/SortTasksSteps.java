package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.SortTasksPage;
import co.nvqa.operator_v2.selenium.page.ViewSortStructurePage;
import co.nvqa.operator_v2.selenium.page.ViewSortStructurePage.TreeNode.NodeType;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;

/**
 * @author Niko Susanto
 */
@ScenarioScoped
public class SortTasksSteps extends AbstractSteps {

  private SortTasksPage sortTasksPage;
  private ViewSortStructurePage viewSortStructurePage;

  public SortTasksSteps() {
  }

  @Override
  public void init() {
    sortTasksPage = new SortTasksPage(getWebDriver());
    viewSortStructurePage = new ViewSortStructurePage(getWebDriver());
  }

  @When("Sort Belt Tasks page is loaded")
  public void movementManagementPageIsLoaded() {
    sortTasksPage.switchTo();
    if (sortTasksPage.spinner.waitUntilVisible(5)) {
      sortTasksPage.spinner.waitUntilInvisible();
    }
  }

  @When("Operator select hub on Sort Tasks page:")
  public void operatorSelectTheHubInTheHubDropdownMenu(Map<String, String> data) {
    data = resolveKeyValues(data);
    String hubName = data.get("hubName");
    if (StringUtils.isBlank(hubName)) {
      throw new IllegalArgumentException("hubName parameter was not provided");
    }
    if (sortTasksPage.changeSelectedHub.isDisplayedFast()) {
      sortTasksPage.changeSelectedHub.click();
    }
    sortTasksPage.selectHub.selectValue(hubName);
    sortTasksPage.load.clickAndWaitUntilDone();
    String hubId = data.get("hubId");
    if (StringUtils.isNotBlank(hubId)) {
      put(KEY_SORT_HUB_ID, Long.valueOf(hubId));
    }
  }

  @When("Operator click View Sort Structure on Sort Tasks page")
  public void operatorClickViewSortStructure() {
    String mainWindowHandle = getWebDriver().getWindowHandle();
    put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
    sortTasksPage.viewSortStructure.click();
    sortTasksPage.switchToNewWindow();
    viewSortStructurePage.switchTo();
    viewSortStructurePage.waitUntilLoaded();
  }

  @When("Operator refresh table on Sort Tasks page")
  public void operatorRefreshTable() {
    sortTasksPage.refreshTable.clickAndWaitUntilDone();
    sortTasksPage.waitUntilInvisibilityOfNotification("Refresh table successfully", true);
  }

  @When("Operator verifies graph contains following Hub nodes:")
  public void operatorVerifyHubNodes(List<String> expectedNodes) {
    expectedNodes = resolveValues(expectedNodes);
    viewSortStructurePage.adjustCanvasScale();
    List<String> actualNodes = viewSortStructurePage.getNodeLabelsByType(NodeType.HUB);
    assertThat("List of Hub nodes", actualNodes,
        Matchers.hasItems(expectedNodes.toArray(new String[0])));
  }

  @When("Operator verifies graph contains following Middle Tier nodes:")
  public void operatorVerifyMiddleTierNodes(List<String> expectedNodes) {
    expectedNodes = resolveValues(expectedNodes);
    viewSortStructurePage.adjustCanvasScale();
    List<String> actualNodes = viewSortStructurePage.getNodeLabelsByType(NodeType.MIDDLE_TIER);
    assertThat("List of Middle Tier nodes", actualNodes,
        Matchers.hasItems(expectedNodes.toArray(new String[0])));
  }

  @When("Operator verifies graph contains following Zone nodes:")
  public void operatorVerifyZoneNodes(List<String> expectedNodes) {
    expectedNodes = resolveValues(expectedNodes);
    viewSortStructurePage.adjustCanvasScale();
    List<String> actualNodes = viewSortStructurePage.getNodeLabelsByType(NodeType.ZONE);
    assertThat("List of Zone nodes", actualNodes,
        Matchers.hasItems(expectedNodes.toArray(new String[0])));
  }

  @When("Operator verifies graph contains following duplicated nodes:")
  public void operatorVerifyDuplicatedNodes(List<Map<String, String>> expectedNodes) {
    viewSortStructurePage.adjustCanvasScale();
    List<String> actualNodes = viewSortStructurePage.getDuplicatedNodes();
    expectedNodes.forEach(data -> {
      data = resolveKeyValues(data);
      String label = data.get("label");
      long count = Long.parseLong(data.get("count"));
      long actualCount = actualNodes.stream()
          .filter(val -> StringUtils.equalsIgnoreCase(val, label))
          .count();
      assertEquals("Count of " + label + " node duplicates", count, actualCount);
    });
  }

  @When("Operator verifies graph contains exactly following nodes:")
  public void operatorVerifyExactlyNodes(List<String> expectedNodes) {
    expectedNodes = resolveValues(expectedNodes);
    viewSortStructurePage.adjustCanvasScale();
    List<String> actualNodes = viewSortStructurePage.getNodeLabels();
    assertThat("List of displayed nodes", actualNodes,
        Matchers.containsInAnyOrder(expectedNodes.toArray(new String[0])));
  }

  @When("Operator clicks on {string} node")
  public void operatorClicksNode(String nodeLabel) {
    viewSortStructurePage.findNodeByLabel(resolveValue(nodeLabel)).click();
    pause2s();
  }

  @When("Operator search for {string} node on View Sort Structure page")
  public void operatorSearchForNode(String nodeLabel) {
    viewSortStructurePage.search.setValue(resolveValue(nodeLabel));
    pause2s();
  }

  @When("Operator open the sidebar menu on Sort Tasks page")
  public void operatorOpenTheSidebarMenu() {
    sortTasksPage.sideBar.click();
  }

  @When("Operator close the sidebar menu on Sort Tasks page")
  public void operatorCloseTheSidebarMenu() {
    sortTasksPage.cancel.click();
  }

  @When("Operator creates new middle tier on Sort Tasks page")
  public void operatorOpenCreateNewMiddleTier(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String name = mapOfData.get("name");
    sortTasksPage.createNewMidTier.click();
    sortTasksPage.midTierName.setValue(name);
    sortTasksPage.create.click();
    put(KEY_CREATED_MIDDLE_TIER, name);
  }

  @Then("^Operator verify new middle tier is created$")
  public void operatorVerifyNewMiddleTierIsCreated(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String sortName = get(KEY_CREATED_MIDDLE_TIER);
    String hubName = mapOfData.get("hubName");
    String sortType = mapOfData.get("sortType");

    sortTasksPage.find.sendKeys(sortName);
    assertThat("Sort Name", sortTasksPage.actualSortName.getText(), equalToIgnoringCase(sortName));
    assertThat("Hub Name", sortTasksPage.actualHubName.getText(), equalToIgnoringCase(hubName));
    assertThat("Sort Name", sortTasksPage.actualSortType.getText(), equalToIgnoringCase(sortType));
  }

  @Then("^Operator delete the middle tier$")
  public void operatorDeleteTheMiddleTier() {
    sortTasksPage.delete.click();
    sortTasksPage.confirm.click();
  }

  @Then("^Operator verify middle tier is deleted$")
  public void operatorVerifyMiddleTierIsDeleted() {
    assertThat("Result", sortTasksPage.noResult.getText(), equalToIgnoringCase("No Results Found"));
  }

  @Then("^Operator select a sort task$")
  public void operatorSelectASortTask() {
    String sortName = get(KEY_CREATED_MIDDLE_TIER);
    sortTasksPage.find.sendKeys(sortName);
    sortTasksPage.select.get(0).check();
    sortTasksPage.submit.click();
  }

  @Then("^Operator remove selection of a sort task$")
  public void operatorUnselectASortTask() {
    String sortName = get(KEY_CREATED_MIDDLE_TIER);
    sortTasksPage.find.sendKeys(sortName);
    sortTasksPage.select.get(0).uncheck();
    sortTasksPage.submit.click();
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