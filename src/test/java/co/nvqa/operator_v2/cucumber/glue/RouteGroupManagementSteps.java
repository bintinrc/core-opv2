package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.model.DataEntity;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.commons.model.core.RouteGroup;
import co.nvqa.operator_v2.model.RouteGroupInfo;
import co.nvqa.operator_v2.model.RouteGroupJobDetails;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.RouteGroupManagementPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;
import org.junit.platform.commons.util.StringUtils;

import static co.nvqa.operator_v2.selenium.page.RouteGroupManagementPage.EditRouteGroupDialog.JobDetailsTable.COLUMN_ID;
import static co.nvqa.operator_v2.selenium.page.RouteGroupManagementPage.EditRouteGroupDialog.JobDetailsTable.COLUMN_TRACKING_ID;
import static co.nvqa.operator_v2.selenium.page.RouteGroupManagementPage.EditRouteGroupDialog.JobDetailsTable.COLUMN_TYPE;
import static co.nvqa.operator_v2.selenium.page.RouteGroupManagementPage.RouteGroupsTable.ACTION_DELETE;
import static co.nvqa.operator_v2.selenium.page.RouteGroupManagementPage.RouteGroupsTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.RouteGroupManagementPage.RouteGroupsTable.COLUMN_CREATION_DATE_TIME;
import static co.nvqa.operator_v2.selenium.page.RouteGroupManagementPage.RouteGroupsTable.COLUMN_NAME;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class RouteGroupManagementSteps extends AbstractSteps {

  public static final String CSV_FILE_NAME = "route-group-jobs.csv.csv";
  public static final String LIST_OF_ROUTE_GROUP_JOBS = "LIST_OF_ROUTE_GROUP_JOBS";

  private RouteGroupManagementPage routeGroupManagementPage;

  public RouteGroupManagementSteps() {
  }

  @Override
  public void init() {
    routeGroupManagementPage = new RouteGroupManagementPage(getWebDriver());
  }

  @When("Operator create new route group on Route Groups Management page:")
  public void createNewRouteGroup(Map<String, String> data) {
    routeGroupManagementPage.inFrame(page -> {
      page.waitUntilLoaded();
      Map<String, String> resolvedData = resolveKeyValues(data);
      page.createRouteGroup.click();
      page.createRouteGroupsDialog.waitUntilVisible();
      String name = resolvedData.get("name");
      page.createRouteGroupsDialog.groupName.setValue(name);
      if (resolvedData.containsKey("description")) {
        page.createRouteGroupsDialog.description.setValue(resolvedData.get("description"));
      }
      page.createRouteGroupsDialog.hub.selectValue(resolvedData.get("hub"));
      page.createRouteGroupsDialog.create.click();
      pause2s();

      RouteGroup routeGroup = new RouteGroup();
      routeGroup.setName(name);
      put(KEY_CREATED_ROUTE_GROUP, routeGroup);
      putInList(KEY_LIST_OF_CREATED_ROUTE_GROUPS, routeGroup);
    });
  }

  @Then("Operator verify route group on Route Groups Management page:")
  public void verifyNewRouteGroupCreatedSuccessfully(Map<String, String> data) {
    RouteGroupInfo expected = new RouteGroupInfo(resolveKeyValues(data));
    routeGroupManagementPage.inFrame(page -> {
      page.waitUntilLoaded(1);
      page.routeGroupsTable.filterByColumn(COLUMN_NAME, expected.getName());
      Assertions.assertThat(page.routeGroupsTable.isEmpty())
          .as("Route Groups table is empty")
          .isFalse();
      RouteGroupInfo actual = page.routeGroupsTable.readEntity(1);
      expected.compareWithActual(actual);
    });
  }

  @When("Operator filter route groups table on Route Group Management page:")
  public void filterRouteGroups(Map<String, String> data) {
    var finalData = resolveKeyValues(data);
    routeGroupManagementPage.inFrame(page -> {
      page.routeGroupsTable.clearColumnFilters();
      finalData.forEach((key, value) -> {
        page.routeGroupsTable.filterByColumn(key, value);
      });
    });
  }

  @When("Operator verify only route groups records presented on Route Group Management page:")
  public void verifyOnlyRouteGroupsRecords(List<Map<String, String>> data) {
    var expected = data.stream()
        .map(r -> new RouteGroupInfo(resolveKeyValues(r)))
        .collect(Collectors.toList());
    routeGroupManagementPage.inFrame(page -> {
      var actual = page.routeGroupsTable.readAllEntities();
      expected.forEach(e -> DataEntity.assertListContains(actual, e, "Route groups records"));
    });
  }

  @Then("^Route Groups Management page is loaded$")
  public void routeGroupManagementPageIsLoaded() {
    routeGroupManagementPage.inFrame(page -> page.waitUntilLoaded(10));
  }

  @When("^Operator update created route group on Route Group Management page:$")
  public void updateRouteGroup(Map<String, String> data) {
    RouteGroup routeGroup = get(KEY_CREATED_ROUTE_GROUP);
    RouteGroupInfo newData = new RouteGroupInfo(resolveKeyValues(data));
    String oldRouteGroupName = routeGroup.getName();
    routeGroupManagementPage.inFrame(page -> {
      routeGroupManagementPage.waitUntilLoaded();
      page.routeGroupsTable.filterByColumn(COLUMN_NAME, oldRouteGroupName);
      Assertions.assertThat(page.routeGroupsTable.isEmpty())
          .as("Route Groups table is empty")
          .isFalse();
      page.routeGroupsTable.clickActionButton(1, ACTION_EDIT);
      page.editRouteGroupDialog.waitUntilVisible();
      if (StringUtils.isNotBlank(newData.getName())) {
        page.editRouteGroupDialog.groupName.setValue(newData.getName());
        routeGroup.setName(newData.getName());
      }
      if (StringUtils.isNotBlank(newData.getDescription())) {
        page.editRouteGroupDialog.description.setValue(newData.getDescription());
      }
      if (StringUtils.isNotBlank(newData.getHubName())) {
        page.editRouteGroupDialog.hub.selectValue(newData.getHubName());
      }
      page.editRouteGroupDialog.saveChanges.click();
    });
  }

  @When("Operator delete {string} route group on Route Group Management page")
  public void deleteRouteGroup(String name) {
    routeGroupManagementPage.inFrame(page -> {
      routeGroupManagementPage.waitUntilLoaded();
      page.routeGroupsTable.filterByColumn(COLUMN_NAME, resolveValue(name));
      Assertions.assertThat(page.routeGroupsTable.isEmpty())
          .as("Route Groups table is empty")
          .isFalse();
      page.routeGroupsTable.clickActionButton(1, ACTION_DELETE);
      page.confirmDeleteRouteGroupDialog.delete.click();
    });
  }

  @When("Operator delete {string} route group from Edit Route Group modal on Route Group Management page")
  public void deleteRouteGroupFromEditRouteGroup(String name) {
    routeGroupManagementPage.inFrame(page -> {
      routeGroupManagementPage.waitUntilLoaded();
      page.routeGroupsTable.filterByColumn(COLUMN_NAME, resolveValue(name));
      Assertions.assertThat(page.routeGroupsTable.isEmpty())
          .as("Route Groups table is empty")
          .isFalse();
      page.routeGroupsTable.clickActionButton(1, ACTION_EDIT);
      page.editRouteGroupDialog.waitUntilVisible();
      page.editRouteGroupDialog.delete.click();
      page.confirmDeleteRouteGroupDialog.delete.click();
    });
  }

  @Then("Operator verify {string} route group was deleted on Route Group Management page")
  public void verifyRouteGroupDeletedSuccessfully(String name) {
    routeGroupManagementPage.inFrame(page -> {
      page.routeGroupsTable.filterByColumn(COLUMN_NAME, resolveValue(name));
      Assertions.assertThat(page.routeGroupsTable.isEmpty())
          .as("Route Groups table is empty")
          .isTrue();
    });
  }

  @Then("Operator verify route groups were deleted on Route Group Management page:")
  public void verifyRouteGroupsDeletedSuccessfully(List<String> names) {
    names.forEach(this::verifyRouteGroupDeletedSuccessfully);
  }

  @Then("Operator delete delivery transaction from route group:")
  public void deleteDeliveryTransactionFromRouteGroup(Map<String, String> data) {
    data = resolveKeyValues(data);
    String name = data.get("name");
    String trackingId = data.get("trackingId");
    routeGroupManagementPage.inFrame(page -> {
      page.waitUntilLoaded();
      page.routeGroupsTable.filterByColumn(COLUMN_NAME, name);
      Assertions.assertThat(page.routeGroupsTable.isEmpty())
          .as("Route Groups table is empty")
          .isFalse();
      page.routeGroupsTable.clickActionButton(1, ACTION_EDIT);
      page.editRouteGroupDialog.waitUntilVisible();
      page.editRouteGroupDialog.jobDetailsTable
          .filterByColumn(COLUMN_TRACKING_ID, trackingId)
          .filterByColumn(COLUMN_TYPE, "DDNT")
          .selectRow(1);
      page.editRouteGroupDialog.removeSelected.click();
      Assertions.assertThat(page.editRouteGroupDialog.jobDetailsTable.isEmpty())
          .as("Jobs table is empty")
          .isTrue();
      page.editRouteGroupDialog.saveChanges.click();
    });
  }

  @Then("Operator delete transaction from route group:")
  public void deleteTransactionFromRouteGroup(Map<String, String> data) {
    data = resolveKeyValues(data);
    String name = data.get("name");
    String id = data.get("id");
    routeGroupManagementPage.inFrame(page -> {
      page.waitUntilLoaded();
      page.routeGroupsTable.filterByColumn(COLUMN_NAME, name);
      Assertions.assertThat(page.routeGroupsTable.isEmpty())
          .as("Route Groups table is empty")
          .isFalse();
      page.routeGroupsTable.clickActionButton(1, ACTION_EDIT);
      page.editRouteGroupDialog.waitUntilVisible();
      page.editRouteGroupDialog.jobDetailsTable
          .filterByColumn(COLUMN_ID, id)
          .selectRow(1);
      page.editRouteGroupDialog.removeSelected.click();
      Assertions.assertThat(page.editRouteGroupDialog.jobDetailsTable.isEmpty())
          .as("Jobs table is empty")
          .isTrue();
      page.editRouteGroupDialog.saveChanges.click();
    });
  }

  @Then("Operator open Edit Rout Group dialog for {value} route group")
  public void deleteTransactionFromRouteGroup(String name) {
    routeGroupManagementPage.inFrame(page -> {
      page.waitUntilLoaded();
      page.routeGroupsTable.filterByColumn(COLUMN_NAME, name);
      Assertions.assertThat(page.routeGroupsTable.isEmpty())
          .as("Route Groups table is empty")
          .isFalse();
      page.routeGroupsTable.clickActionButton(1, ACTION_EDIT);
      page.editRouteGroupDialog.waitUntilVisible();
    });
  }

  @Then("Operator verify there is no {value} transaction in Edit Rout Group dialog")
  public void verifyNoTransaction(String id) {
    routeGroupManagementPage.inFrame(page -> {
      page.editRouteGroupDialog.waitUntilVisible();
      page.editRouteGroupDialog.jobDetailsTable.filterByColumn(COLUMN_ID, id);
      Assertions.assertThat(page.editRouteGroupDialog.jobDetailsTable.isEmpty())
          .withFailMessage("Transaction %s is displayed in Edit Rout Group dialog", id)
          .isTrue();
    });
  }

  @When("Operator delete route groups on Route Group Management page using password {string}:")
  public void operatorDeleteCreatedRouteGroupsOnRouteGroupManagement(String password,
      List<String> names) {
    List<String> resolvedNames = resolveValues(names);
    routeGroupManagementPage.inFrame(page -> {
      page.waitUntilLoaded();
      resolvedNames.forEach(name -> {
        page.routeGroupsTable.filterByColumn(COLUMN_NAME, resolveValue(name));
        Assertions.assertThat(page.routeGroupsTable.isEmpty())
            .as("Route Groups table is empty")
            .isFalse();
        page.routeGroupsTable.selectRow(1);
      });
      page.actionsMenu.selectOption("Delete selected");
      page.deleteRouteGroupsDialog.waitUntilVisible();
      List<String> groupNames = page.deleteRouteGroupsDialog.groupNames.stream()
          .map(PageElement::getNormalizedText).collect(Collectors.toList());
      Assertions.assertThat(groupNames)
          .as("List of groups to delete")
          .containsExactlyInAnyOrderElementsOf(resolvedNames);
      page.deleteRouteGroupsDialog.password.setValue(resolveValue(password));
      page.deleteRouteGroupsDialog.delete.click();
    });
  }

  @When("Operator clear selected route groups on Route Group Management page:")
  public void operatorClearSelectedRouteGroupsOnRouteGroupManagement(List<String> names) {
    List<String> resolvedNames = resolveValues(names);
    routeGroupManagementPage.inFrame(page -> {
      page.waitUntilLoaded();
      resolvedNames.forEach(name -> {
        page.routeGroupsTable.filterByColumn(COLUMN_NAME, resolveValue(name));
        Assertions.assertThat(page.routeGroupsTable.isEmpty())
            .as("Route Groups table is empty")
            .isFalse();
        page.routeGroupsTable.selectRow(1);
      });
      page.actionsMenu.selectOption("Clear selected");
      page.clearRouteGroupsDialog.waitUntilVisible();
      List<String> groupNames = page.clearRouteGroupsDialog.groupNames.stream()
          .map(PageElement::getNormalizedText).collect(Collectors.toList());
      Assertions.assertThat(groupNames)
          .as("List of groups to clear")
          .containsExactlyInAnyOrderElementsOf(resolvedNames);
      page.clearRouteGroupsDialog.clear.click();
    });
  }

  @Then("Operator verifies {string} route group was cleared on Route Group Management page")
  public void verifyRouteGroupWasCleared(String name) {
    routeGroupManagementPage.inFrame(page -> {
      page.routeGroupsTable.filterByColumn(COLUMN_NAME, resolveValue(name));
      Assertions.assertThat(page.routeGroupsTable.isEmpty())
          .as("Route Groups table is empty")
          .isFalse();
      page.routeGroupsTable.clickActionButton(1, ACTION_EDIT);
      page.editRouteGroupDialog.waitUntilVisible();
      pause2s();
      Assertions.assertThat(page.editRouteGroupDialog.jobDetailsTable.isEmpty())
          .as("Jobs table is empty")
          .isTrue();
    });
  }

  @Then("Operator apply filters on Route Group Management page:")
  public void applyFilters(Map<String, String> data) {
    routeGroupManagementPage.inFrame(page -> {
      page.waitUntilLoaded();
      Map<String, String> resolvedData = resolveKeyValues(data);
      page.creationDate.fairSetInterval(resolvedData.get("fromDate"), resolvedData.get("toDate"));
    });
  }

  @Then("Operator verifies route groups table is filtered by {string} date on Route Group Management page")
  public void checkSortByDate(String date) {
    routeGroupManagementPage.inFrame(page -> {
      List<String> actualDates = page.routeGroupsTable.readColumn(COLUMN_CREATION_DATE_TIME);
      Assertions.assertThat(actualDates)
          .as("List of Created Date values")
          .isNotEmpty()
          .allMatch(val -> val.matches(date));
    });
  }

  @When("Operator download jobs of {string} route group on Edit Route Group modal on Route Group Management page")
  public void operatorDownloadsTransactions(String name) {
    routeGroupManagementPage.inFrame(page -> {
      page.waitUntilLoaded();
      page.routeGroupsTable.filterByColumn(COLUMN_NAME, resolveValue(name));
      Assertions.assertThat(page.routeGroupsTable.isEmpty())
          .as("Route Groups table is empty")
          .isFalse();
      page.routeGroupsTable.clickActionButton(1, ACTION_EDIT);
      page.editRouteGroupDialog.waitUntilVisible();
      pause2s();
      List<RouteGroupJobDetails> transactions = routeGroupManagementPage.editRouteGroupDialog.jobDetailsTable
          .readAllEntities();
      put(LIST_OF_ROUTE_GROUP_JOBS, transactions);
      for (int i = 1; i <= transactions.size(); i++) {
        routeGroupManagementPage.editRouteGroupDialog.jobDetailsTable.selectRow(i);
      }
      routeGroupManagementPage.editRouteGroupDialog.downloadSelected.click();
      routeGroupManagementPage.verifyFileDownloadedSuccessfully(CSV_FILE_NAME);
    });
  }

  @When("Operator verify job record in Edit Route Group modal on Route Group Management page:")
  public void verifyJobRecord(Map<String, String> data) {
    var expected = new RouteGroupJobDetails(resolveKeyValues(data));
    routeGroupManagementPage.inFrame(page -> {
      page.editRouteGroupDialog.waitUntilVisible();
      page.editRouteGroupDialog.jobDetailsTable.clearColumnFilters();
      page.editRouteGroupDialog.jobDetailsTable.filterByColumn(COLUMN_ID, expected.getId());
      Assertions.assertThat(page.editRouteGroupDialog.jobDetailsTable.isEmpty())
          .withFailMessage("Job with id [" + expected.getId() + "] was not found")
          .isFalse();
      var actual = page.editRouteGroupDialog.jobDetailsTable.readEntity(1);
      expected.compareWithActual(actual);
    });
  }

  @When("Operator clear jobs table filters in Edit Route Group modal on Route Group Management page")
  public void clearJobsTableFilters() {
    routeGroupManagementPage.inFrame(page -> {
      page.editRouteGroupDialog.waitUntilVisible();
      page.editRouteGroupDialog.jobDetailsTable.clearColumnFilters();
    });
  }

  @When("Operator verify only job records presented in Edit Route Group modal on Route Group Management page:")
  public void verifyOnlyJobRecords(List<Map<String, String>> data) {
    var expected = data.stream()
        .map(r -> new RouteGroupJobDetails(resolveKeyValues(r)))
        .collect(Collectors.toList());
    routeGroupManagementPage.inFrame(page -> {
      page.editRouteGroupDialog.waitUntilVisible();
      var actual = page.editRouteGroupDialog.jobDetailsTable.readAllEntities();
      expected.forEach(e -> DataEntity.assertListContains(actual, e, "Job records"));
    });
  }

  @When("Operator filter job records in Edit Route Group modal on Route Group Management page:")
  public void filterJobRecords(Map<String, String> data) {
    var finalData = resolveKeyValues(data);
    routeGroupManagementPage.inFrame(page -> {
      page.editRouteGroupDialog.waitUntilVisible();
      page.editRouteGroupDialog.jobDetailsTable.clearColumnFilters();
      finalData.forEach((key, value) -> {
        page.editRouteGroupDialog.jobDetailsTable.filterByColumn(key, value);
      });
    });
  }

  @Given("^Operator verify route group jobs CSV file on Route Group Management page$")
  public void operatorVerifyCsvFile() {
    List<RouteGroupJobDetails> expected = get(LIST_OF_ROUTE_GROUP_JOBS);
    String fileName = routeGroupManagementPage.getLatestDownloadedFilename(CSV_FILE_NAME);
    String pathName = StandardTestConstants.TEMP_DIR + fileName;
    List<RouteGroupJobDetails> actual = DataEntity
        .fromCsvFile(RouteGroupJobDetails.class, pathName, true);
    Assertions.assertThat(actual.size()).as("Number of records in " + CSV_FILE_NAME)
        .isEqualTo(expected.size());

    for (int i = 0; i < expected.size(); i++) {
      expected.get(i).compareWithActual(actual.get(i));
    }
  }
}
