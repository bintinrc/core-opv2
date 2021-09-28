package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.DataEntity;
import co.nvqa.commons.model.core.RouteGroup;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.RouteGroupJobDetails;
import co.nvqa.operator_v2.selenium.page.RouteGroupManagementPage;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static co.nvqa.operator_v2.selenium.page.RouteGroupManagementPage.ACTION_BUTTON_DELETE;
import static co.nvqa.operator_v2.selenium.page.RouteGroupManagementPage.EditRouteGroupDialog.JobDetailsTable.COLUMN_TRACKING_ID;
import static co.nvqa.operator_v2.selenium.page.RouteGroupManagementPage.EditRouteGroupDialog.JobDetailsTable.COLUMN_TYPE;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteGroupManagementSteps extends AbstractSteps {

  public static final String LIST_OF_ROUTE_GROUP_JOBS = "LIST_OF_ROUTE_GROUP_JOBS";
  public static final String CSV_FILE_NAME = "route-group-jobs.csv";

  private static final int MAX_RETRY = 10;
  private RouteGroupManagementPage routeGroupManagementPage;

  public RouteGroupManagementSteps() {
  }

  @Override
  public void init() {
    routeGroupManagementPage = new RouteGroupManagementPage(getWebDriver());
  }

  @When("^Operator create new 'Route Group' on 'Route Groups Management' using data below:$")
  public void createNewRouteGroup(Map<String, String> dataTableAsMap) {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    boolean generateName = Boolean.valueOf(dataTableAsMap.get("generateName"));
    String hubName = dataTableAsMap.get("hubName");
    String routeGroupName;

    if (generateName || trackingId == null) {
      routeGroupName = "ARG-" + generateDateUniqueString();
    } else {
      routeGroupName = "ARG-" + trackingId;
    }

    routeGroupManagementPage.createRouteGroup(routeGroupName, hubName);
    RouteGroup routeGroup = new RouteGroup();
    routeGroup.setName(routeGroupName);
    put(KEY_CREATED_ROUTE_GROUP, routeGroup);
    putInList(KEY_LIST_OF_CREATED_ROUTE_GROUPS, routeGroup);
  }

  @When("^Operator wait until 'Route Group Management' page is loaded$")
  public void waitUntilRouteGroupIsLoaded() {
    routeGroupManagementPage.waitUntilRouteGroupPageIsLoaded();
  }

  @Then("^Operator verify new 'Route Group' on 'Route Groups Management' created successfully$")
  public void verifyNewRouteGroupCreatedSuccessfully() {
    RouteGroup routeGroup = get(KEY_CREATED_ROUTE_GROUP);
    int counter = 0;
    String actualRouteGroupName;
    boolean retry;

    do {
      takesScreenshot();
      routeGroupManagementPage.searchTable(routeGroup.getName());
      actualRouteGroupName = routeGroupManagementPage
          .getTextOnTable(1, RouteGroupManagementPage.COLUMN_CLASS_DATA_NAME);

      retry = (actualRouteGroupName == null || actualRouteGroupName.isEmpty())
          && counter++ <= MAX_RETRY;

      if (retry) {
        writeToCurrentScenarioLog(
            f("[INFO] Retrying to load and search Route Group. [Route Group Name = '%s'] Retrying %dx ...",
                actualRouteGroupName, counter));
        takesScreenshot();
        reloadPage();
      }
    }
    while (retry);

    assertThat("Route Group name not matched.", actualRouteGroupName,
        startsWith(routeGroup.getName())); //Route Group name is concatenated with description.
  }

  @When("^Operator update 'Route Group' on 'Route Group Management'$")
  public void updateRouteGroup() {
    RouteGroup routeGroup = get(KEY_CREATED_ROUTE_GROUP);
    String oldRouteGroupName = routeGroup.getName();
    routeGroup.setName(routeGroup.getName() + " [EDITED]");
    routeGroupManagementPage.openEditRouteGroupDialog(oldRouteGroupName);
    routeGroupManagementPage.editRouteGroupDialog.groupName.setValue(routeGroup.getName());
    routeGroupManagementPage.editRouteGroupDialog.saveChanges.clickAndWaitUntilDone();
    routeGroupManagementPage.waitUntilInvisibilityOfToast("Route Group Updated");
  }

  @Then("^Operator verify 'Route Group' on 'Route Group Management' updated successfully$")
  public void verifyRouteGroupUpdatedSuccessfully() {
    RouteGroup routeGroup = get(KEY_CREATED_ROUTE_GROUP);
    routeGroupManagementPage.searchTable(routeGroup.getName());
    String actualName = routeGroupManagementPage
        .getTextOnTable(1, RouteGroupManagementPage.COLUMN_CLASS_DATA_NAME);
    assertTrue("Route Group name not matched.",
        actualName
            .startsWith(routeGroup.getName())); //Route Group name is concatenated with description.
  }

  @When("^Operator delete 'Route Group' on 'Route Group Management'$")
  public void deleteRouteGroup() {
    RouteGroup routeGroup = get(KEY_CREATED_ROUTE_GROUP);
    routeGroupManagementPage.searchTable(routeGroup.getName());
    pause100ms();
    routeGroupManagementPage.clickActionButtonOnTable(1, ACTION_BUTTON_DELETE);
    routeGroupManagementPage.confirmDeleteRouteGroupDialog.confirmDelete();
    routeGroupManagementPage.waitUntilInvisibilityOfToast("Route Group Deleted");
  }

  @When("^Operator delete route group from Edit Route Group modal on Route Group Management page$")
  public void deleteRouteGroupFromEditGroup() {
    RouteGroup routeGroup = get(KEY_CREATED_ROUTE_GROUP);
    routeGroupManagementPage.openEditRouteGroupDialog(routeGroup.getName());
    routeGroupManagementPage.editRouteGroupDialog.delete.click();
    routeGroupManagementPage.confirmDeleteRouteGroupDialog.confirmDelete();
    routeGroupManagementPage.waitUntilInvisibilityOfToast("Route Group Deleted");
  }

  @Then("^Operator verify route group was deleted successfully on Route Group Management page$")
  public void verifyRouteGroupDeletedSuccessfully() {
    RouteGroup routeGroup = get(KEY_CREATED_ROUTE_GROUP);
    String actualName = routeGroupManagementPage
        .getTextOnTable(1, RouteGroupManagementPage.COLUMN_CLASS_DATA_NAME);
    assertNotEquals(routeGroup.getName(), actualName);
  }

  private void verifyRouteGroupDeletedSuccessfullyByName(String routeGroupName) {
    routeGroupManagementPage.searchTable(routeGroupName);
    assertTrue(f("Route Group with name = '%s' not deleted successfully.", routeGroupName),
        routeGroupManagementPage.isTableEmpty());
  }

  @Then("^Operator delete created delivery transaction from route group$")
  public void deleteTransactionFromRouteGroup() {
    RouteGroup routeGroup = get(KEY_CREATED_ROUTE_GROUP);
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);

    routeGroupManagementPage.openEditRouteGroupDialog(routeGroup.getName());
    routeGroupManagementPage.editRouteGroupDialog.jobDetailsTable
        .filterByColumn(COLUMN_TRACKING_ID, trackingId)
        .filterByColumn(COLUMN_TYPE, "DDNT")
        .selectRow(1);
    routeGroupManagementPage.editRouteGroupDialog.removeSelected.click();
    assertTrue("Is Jobs table empty",
        routeGroupManagementPage.editRouteGroupDialog.jobDetailsTable.isTableEmpty());
    routeGroupManagementPage.editRouteGroupDialog.saveChanges.clickAndWaitUntilDone();
    routeGroupManagementPage.waitUntilInvisibilityOfToast("Route Group Updated", true);
  }

  @When("^Operator delete created Route Groups on 'Route Group Management' page using password \"(.+)\"$")
  public void operatorDeleteCreatedRouteGroupsOnRouteGroupManagement(String password) {
    List<RouteGroup> routeGroups = get(KEY_LIST_OF_CREATED_ROUTE_GROUPS);
    List<String> routeGroupNames = routeGroups.stream()
        .map(RouteGroup::getName)
        .collect(Collectors.toList());
    routeGroupManagementPage.selectRouteGroups(routeGroupNames);
    routeGroupManagementPage.actionsMenu.selectOption("Delete Selected");
    routeGroupManagementPage.deleteRouteGroupsDialog.waitUntilVisible();
    List<String> groupNames = routeGroupManagementPage.deleteRouteGroupsDialog.getRouteGroupNames();
    assertThat("Route Group Names to delete", groupNames.toArray(new String[0]),
        arrayContainingInAnyOrder(routeGroupNames.toArray(new String[0])));
    routeGroupManagementPage.deleteRouteGroupsDialog.enterPassword(password);
    routeGroupManagementPage.deleteRouteGroupsDialog.deleteRouteGroups.clickAndWaitUntilDone();
  }

  @Then("^Operator verify created Route Groups on 'Route Group Management' deleted successfully$")
  public void operatorVerifyCreatedRouteGroupsOnRouteGroupManagementDeletedSuccessfully() {
    List<RouteGroup> routeGroups = get(KEY_LIST_OF_CREATED_ROUTE_GROUPS);
    List<String> routeGroupNames = routeGroups.stream()
        .map(RouteGroup::getName)
        .collect(Collectors.toList());
    routeGroupNames.forEach(this::verifyRouteGroupDeletedSuccessfullyByName);
  }

  @When("^Operator clear selected route groups on Route Group Management page$")
  public void operatorClearSelectedRouteGroupsOnRouteGroupManagement() {
    List<RouteGroup> routeGroups = get(KEY_LIST_OF_CREATED_ROUTE_GROUPS);
    List<String> routeGroupNames = routeGroups.stream()
        .map(RouteGroup::getName)
        .collect(Collectors.toList());
    routeGroupManagementPage.selectRouteGroups(routeGroupNames);
    routeGroupManagementPage.actionsMenu.selectOption("Clear Selected");
    routeGroupManagementPage.clearRouteGroupsDialog.waitUntilVisible();
    List<String> groupNames = routeGroupManagementPage.clearRouteGroupsDialog.getRouteGroupNames();
    assertThat("Route Group Names to clear", groupNames.toArray(new String[0]),
        arrayContainingInAnyOrder(routeGroupNames.toArray(new String[0])));
    routeGroupManagementPage.clearRouteGroupsDialog.clearRouteGroups.clickAndWaitUntilDone();
  }

  @Then("^Operator verifies route group was cleared on Route Group Management page$")
  public void verifyRouteGroupWasCleared() {
    RouteGroup routeGroup = get(KEY_CREATED_ROUTE_GROUP);

    routeGroupManagementPage.openEditRouteGroupDialog(routeGroup.getName());
    assertTrue("Is Jobs table empty",
        routeGroupManagementPage.editRouteGroupDialog.jobDetailsTable.isTableEmpty());
  }

  @When("^Operator download route group jobs on Edit Route Group modal on Route Group Management page$")
  public void operatorDownloadsTransactions() {
    RouteGroup routeGroup = get(KEY_CREATED_ROUTE_GROUP);
    routeGroupManagementPage.openEditRouteGroupDialog(routeGroup.getName());
    pause2s();
    List<RouteGroupJobDetails> transactions = routeGroupManagementPage.editRouteGroupDialog.jobDetailsTable
        .readAllEntities();
    put(LIST_OF_ROUTE_GROUP_JOBS, transactions);
    for (int i = 1;
        i <= routeGroupManagementPage.editRouteGroupDialog.jobDetailsTable.getRowsCount(); i++) {
      routeGroupManagementPage.editRouteGroupDialog.jobDetailsTable.selectRow(i);
    }
    routeGroupManagementPage.editRouteGroupDialog.downloadSelected.click();
    routeGroupManagementPage.verifyFileDownloadedSuccessfully(CSV_FILE_NAME);
  }

  @Given("^Operator verify route group jobs CSV file on Route Group Management page$")
  public void operatorVerifyCsvFile() {
    List<RouteGroupJobDetails> expected = get(LIST_OF_ROUTE_GROUP_JOBS);
    String fileName = routeGroupManagementPage.getLatestDownloadedFilename(CSV_FILE_NAME);
    String pathName = StandardTestConstants.TEMP_DIR + fileName;
    List<RouteGroupJobDetails> actual = DataEntity
        .fromCsvFile(RouteGroupJobDetails.class, pathName, true);
    assertEquals("Number of records in " + CSV_FILE_NAME, expected.size(), actual.size());

    for (int i = 0; i < expected.size(); i++) {
      expected.get(i).compareWithActual(actual.get(i));
    }
  }
}
