package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.route.Route;
import co.nvqa.operator_v2.model.RouteLogsParams;
import co.nvqa.operator_v2.selenium.page.RouteLogsPage;
import co.nvqa.operator_v2.selenium.page.RouteLogsPage.CreateRouteDialog.RouteDetailsForm;
import co.nvqa.operator_v2.selenium.page.RouteLogsPage.RoutesTable;
import co.nvqa.operator_v2.selenium.page.ToastInfo;
import co.nvqa.operator_v2.util.TestUtils;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.Alert;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import static co.nvqa.operator_v2.selenium.page.RouteLogsPage.ACTION_ARCHIVE_SELECTED;
import static co.nvqa.operator_v2.selenium.page.RouteLogsPage.ACTION_BULK_EDIT_DETAILS;
import static co.nvqa.operator_v2.selenium.page.RouteLogsPage.ACTION_DELETE_SELECTED;
import static co.nvqa.operator_v2.selenium.page.RouteLogsPage.ACTION_MERGE_TRANSACTIONS_OF_SELECTED;
import static co.nvqa.operator_v2.selenium.page.RouteLogsPage.ACTION_OPTIMISE_SELECTED;
import static co.nvqa.operator_v2.selenium.page.RouteLogsPage.ACTION_PRINT_PASSWORDS_OF_SELECTED;
import static co.nvqa.operator_v2.selenium.page.RouteLogsPage.ACTION_PRINT_SELECTED;
import static co.nvqa.operator_v2.selenium.page.RouteLogsPage.ACTION_UNARCHIVE_SELECTED;
import static co.nvqa.operator_v2.selenium.page.RouteLogsPage.RoutesTable.ACTION_EDIT_DETAILS;
import static co.nvqa.operator_v2.selenium.page.RouteLogsPage.RoutesTable.ACTION_EDIT_ROUTE;
import static co.nvqa.operator_v2.selenium.page.RouteLogsPage.RoutesTable.COLUMN_ROUTE_ID;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteLogsSteps extends AbstractSteps {

  private static final int ALERT_WAIT_TIMEOUT_IN_SECONDS = 15;

  private RouteLogsPage routeLogsPage;

  public RouteLogsSteps() {
  }

  @Override
  public void init() {
    routeLogsPage = new RouteLogsPage(getWebDriver());
  }

  @When("^Operator create new route using data below:$")
  public void operatorCreateNewRouteUsingDataBelow(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String scenarioName = getScenarioManager().getCurrentScenario().getName();
    String createdDate = CREATED_DATE_SDF.format(new Date());
    String comments = f(
        "This route is created from OpV2 for testing purpose only. Ignore this route. Created at %s by scenario \"%s\".",
        createdDate, scenarioName);

    RouteLogsParams newParams = new RouteLogsParams(mapOfData);
    newParams.setComments(comments);

    routeLogsPage.createRoute.click();
    routeLogsPage.createRouteDialog.waitUntilVisible();

    RouteDetailsForm routeDetailsForm = routeLogsPage.createRouteDialog.routeDetailsForms.get(0);

    if (StringUtils.isNotBlank(newParams.getDate())) {
      routeDetailsForm.routeDate.simpleSetValue(newParams.getDate());
    }
    if (CollectionUtils.isNotEmpty(newParams.getTags())) {
      routeDetailsForm.routeTags.selectValues(newParams.getTags());
    }
    if (StringUtils.isNotBlank(newParams.getZone())) {
      routeDetailsForm.zone.selectValue(newParams.getZone());
    }
    if (StringUtils.isNotBlank(newParams.getHub())) {
      routeDetailsForm.hub.selectValue(newParams.getHub());
    }
    if (StringUtils.isNotBlank(newParams.getDriverName())) {
      routeDetailsForm.assignedDriver.selectValue(newParams.getDriverName());
    }
    if (StringUtils.isNotBlank(newParams.getVehicle())) {
      routeDetailsForm.vehicle.selectValue(newParams.getVehicle());
    }
    if (StringUtils.isNotBlank(newParams.getComments())) {
      routeDetailsForm.comments.setValue(newParams.getComments());
    }

    routeLogsPage.createRouteDialog.createRoutes.clickAndWaitUntilDone();
    routeLogsPage.waitUntilVisibilityOfToast("1 Route(s) Created");
    String toastBottom = routeLogsPage.toastSuccess.get(0).toastBottom.getText();

    newParams.setId(toastBottom.replaceAll("\\d+.+Route", "").trim());
    Route createdRoute = new Route();
    createdRoute.setId(Long.valueOf(newParams.getId()));
    createdRoute.setComments(newParams.getComments());
    Long createdRouteId = createdRoute.getId();

    put(KEY_CREATE_ROUTE_PARAMS, newParams);
    put(KEY_CREATED_ROUTE, createdRoute);
    put(KEY_CREATED_ROUTE_ID, createdRouteId);
    putInList(KEY_LIST_OF_CREATED_ROUTES, createdRoute);
    putInList(KEY_LIST_OF_CREATED_ROUTE_ID, createdRouteId);
    putInList(KEY_LIST_OF_ARCHIVED_ROUTE_IDS, createdRouteId);
    writeToCurrentScenarioLogf("Created Route %d", createdRouteId);
  }

  @When("^Operator create multiple routes using data below:$")
  public void operatorCreateMultipleRoutesUsingDataBelow(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String scenarioName = getScenarioManager().getCurrentScenario().getName();
    String createdDate = CREATED_DATE_SDF.format(new Date());

    int numberOfRoute = Integer.parseInt(mapOfData.get("numberOfRoute"));
    List<RouteLogsParams> routeParamsList = new ArrayList<>();

    for (int i = 0; i < numberOfRoute; i++) {
      String comments = f(
          "This route (#%d) is created from OpV2 for testing purpose only. Ignore this route. Created at %s by scenario \"%s\".",
          (i + 1), createdDate, scenarioName);

      RouteLogsParams routeLogsParams = new RouteLogsParams(mapOfData);
      routeLogsParams.setComments(comments);
      routeParamsList.add(routeLogsParams);
    }

    routeLogsPage.createRoute.click();
    routeLogsPage.createRouteDialog.waitUntilVisible();

    RouteLogsParams newParams = routeParamsList.get(0);
    RouteDetailsForm routeDetailsForm = routeLogsPage.createRouteDialog.routeDetailsForms.get(0);

    if (StringUtils.isNotBlank(newParams.getDate())) {
      routeDetailsForm.routeDate.simpleSetValue(newParams.getDate());
    }
    if (CollectionUtils.isNotEmpty(newParams.getTags())) {
      routeDetailsForm.routeTags.selectValues(newParams.getTags());
    }
    if (StringUtils.isNotBlank(newParams.getZone())) {
      routeDetailsForm.zone.selectValue(newParams.getZone());
    }
    if (StringUtils.isNotBlank(newParams.getHub())) {
      routeDetailsForm.hub.selectValue(newParams.getHub());
    }
    if (StringUtils.isNotBlank(newParams.getDriverName())) {
      routeDetailsForm.assignedDriver.selectValue(newParams.getDriverName());
    }
    if (StringUtils.isNotBlank(newParams.getVehicle())) {
      routeDetailsForm.vehicle.selectValue(newParams.getVehicle());
    }
    if (StringUtils.isNotBlank(newParams.getComments())) {
      routeDetailsForm.comments.setValue(newParams.getComments());
    }

    for (int i = 1; i < routeParamsList.size(); i++) {
      routeLogsPage.createRouteDialog.duplicateAbove.click();
      String comments = routeParamsList.get(i).getComments();
      if (StringUtils.isNotBlank(comments)) {
        routeLogsPage.createRouteDialog.routeDetailsForms.get(i).comments.setValue(comments);
      }
    }

    routeLogsPage.createRouteDialog.createRoutes.clickAndWaitUntilDone();
    routeLogsPage.waitUntilVisibilityOfToast(routeParamsList.size() + " Route(s) Created");
    String toastBottom = routeLogsPage.toastSuccess.get(0).toastBottom.getText();
    String[] routeIds = toastBottom.split("\n");

    for (int i = 0; i < routeParamsList.size(); i++) {
      RouteLogsParams createRouteParams = routeParamsList.get(i);
      createRouteParams.setId(routeIds[i].replaceAll("\\d+.+Route", "").trim());
      Route createdRoute = new Route();
      createdRoute.setId(Long.valueOf(createRouteParams.getId()));
      createdRoute.setComments(createRouteParams.getComments());
      Long createdRouteId = createdRoute.getId();

      put(KEY_CREATE_ROUTE_PARAMS, createRouteParams);
      put(KEY_CREATED_ROUTE, createdRoute);
      put(KEY_CREATED_ROUTE_ID, createdRouteId);
      putInList(KEY_LIST_OF_CREATED_ROUTES, createdRoute);
      putInList(KEY_LIST_OF_CREATED_ROUTE_ID, createdRouteId);
      putInList(KEY_LIST_OF_ARCHIVED_ROUTE_IDS, createdRouteId);
      writeToCurrentScenarioLogf("Created Route %d", createdRouteId);
    }
  }

  @When("^Operator bulk edits details of created routes using data below:$")
  public void operatorBulkEditDetailsMultipleRoutesUsingDataBelow(Map<String, String> data) {
    data = resolveKeyValues(data);
    RouteLogsParams newParams = new RouteLogsParams(data);

    List<Long> routeIds = get(KEY_LIST_OF_CREATED_ROUTE_ID);
    routeIds.forEach(routeId -> {
      routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      routeLogsPage.routesTable.selectRow(1);
    });
    routeLogsPage.actionsMenu.selectOption(ACTION_BULK_EDIT_DETAILS);
    routeLogsPage.bulkEditDetailsDialog.waitUntilVisible();
    if (StringUtils.isNotBlank(newParams.getDate())) {
      routeLogsPage.bulkEditDetailsDialog.routeDate.simpleSetValue(newParams.getDate());
    }
    if (CollectionUtils.isNotEmpty(newParams.getTags())) {
      routeLogsPage.bulkEditDetailsDialog.routeTags.selectValues(newParams.getTags());
    }
    if (StringUtils.isNotBlank(newParams.getHub())) {
      routeLogsPage.bulkEditDetailsDialog.hub.selectValue(newParams.getHub());
    }
    if (StringUtils.isNotBlank(newParams.getDriverName())) {
      routeLogsPage.bulkEditDetailsDialog.assignedDriver.selectValue(newParams.getDriverName());
    }
    if (StringUtils.isNotBlank(newParams.getVehicle())) {
      routeLogsPage.bulkEditDetailsDialog.vehicle.selectValue(newParams.getVehicle());
    }
    if (StringUtils.isNotBlank(newParams.getComments())) {
      routeLogsPage.bulkEditDetailsDialog.comments.setValue(newParams.getComments());
    }
    routeLogsPage.bulkEditDetailsDialog.saveChanges.clickAndWaitUntilDone();
    routeLogsPage.bulkEditDetailsDialog.waitUntilInvisible();
    routeLogsPage.waitUntilInvisibilityOfToast(routeIds.size() + " Route(s) Edited");
  }

  @When("^Operator edits details of created route using data below:$")
  public void operatorEditDetailsMultipleRouteUsingDataBelow(Map<String, String> data) {
    data = resolveKeyValues(data);
    RouteLogsParams newParams = new RouteLogsParams(data);

    Long routeId = get(KEY_CREATED_ROUTE_ID);
    routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
    routeLogsPage.routesTable.clickActionButton(1, ACTION_EDIT_DETAILS);
    routeLogsPage.editDetailsDialog.waitUntilVisible();

    if (StringUtils.isNotBlank(newParams.getDate())) {
      routeLogsPage.editDetailsDialog.routeDate.simpleSetValue(newParams.getDate());
    }
    if (CollectionUtils.isNotEmpty(newParams.getTags())) {
      routeLogsPage.editDetailsDialog.routeTags.selectValues(newParams.getTags());
    }
    if (StringUtils.isNotBlank(newParams.getHub())) {
      routeLogsPage.editDetailsDialog.hub.selectValue(newParams.getHub());
    }
    if (StringUtils.isNotBlank(newParams.getDriverName())) {
      routeLogsPage.editDetailsDialog.assignedDriver.selectValue(newParams.getDriverName());
    }
    if (StringUtils.isNotBlank(newParams.getVehicle())) {
      routeLogsPage.editDetailsDialog.vehicle.selectValue(newParams.getVehicle());
    }
    if (StringUtils.isNotBlank(newParams.getComments())) {
      routeLogsPage.editDetailsDialog.comments.setValue(newParams.getComments());
    }
    routeLogsPage.editDetailsDialog.saveChanges.clickAndWaitUntilDone();
    routeLogsPage.editDetailsDialog.waitUntilInvisible();
    routeLogsPage.waitUntilInvisibilityOfToast("1 Route(s) Edited");
  }

  @When("^Operator merge transactions of created routes$")
  public void operatorMergeTransactionsOfMultipleRoutes() {
    List<Long> routeIds = get(KEY_LIST_OF_CREATED_ROUTE_ID);
    routeIds.forEach(routeId -> {
      routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      routeLogsPage.routesTable.selectRow(1);
    });
    routeLogsPage.actionsMenu.selectOption(ACTION_MERGE_TRANSACTIONS_OF_SELECTED);
    routeLogsPage.mergeTransactionsWithinSelectedRoutesDialog.waitUntilVisible();
    routeLogsPage.mergeTransactionsWithinSelectedRoutesDialog.mergeTransactions.click();
    routeLogsPage.mergeTransactionsWithinSelectedRoutesDialog.waitUntilInvisible();
  }

  @When("^Operator optimise created routes$")
  public void operatorOptimiseMultipleRoutes() {
    List<Long> routeIds = get(KEY_LIST_OF_CREATED_ROUTE_ID);
    routeIds.forEach(routeId -> {
      routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      routeLogsPage.routesTable.selectRow(1);
    });
    routeLogsPage.actionsMenu.selectOption(ACTION_OPTIMISE_SELECTED);
  }

  @Then("^Operator verifies created routes are optimised successfully$")
  public void operatorVerifyMultipleRoutesIsOptimisedSuccessfully() {
    List<Long> listOfCreateRouteParams = get(KEY_LIST_OF_CREATED_ROUTE_ID);
    routeLogsPage.verifyMultipleRoutesIsOptimisedSuccessfully(listOfCreateRouteParams);
  }

  @When("^Operator print passwords of created routes$")
  public void operatorPrintPasswordsOfMultipleRoutes() {
    List<Long> routeIds = get(KEY_LIST_OF_CREATED_ROUTE_ID);
    routeIds.forEach(routeId -> {
      routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      routeLogsPage.routesTable.selectRow(1);
    });
    routeLogsPage.actionsMenu.selectOption(ACTION_PRINT_PASSWORDS_OF_SELECTED);
    routeLogsPage.waitUntilInvisibilityOfToast("Downloading routes_password");
  }

  @Then("^Operator verify printed passwords of selected routes info is correct$")
  public void operatorVerifyPrintedPasswordsOfSelectedRoutesInfoIsCorrect() {
    List<RouteLogsParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);
    routeLogsPage.verifyPrintedPasswordsOfSelectedRoutesInfoIsCorrect(listOfCreateRouteParams);
  }

  @When("^Operator print created routes$")
  public void operatorPrintMultipleRoutes() {
    List<Long> routeIds = get(KEY_LIST_OF_CREATED_ROUTE_ID);
    routeIds.forEach(routeId -> {
      routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      routeLogsPage.routesTable.selectRow(1);
    });
    routeLogsPage.actionsMenu.selectOption(ACTION_PRINT_SELECTED);
    routeLogsPage.waitUntilInvisibilityOfToast("Downloading route_printout");
  }

  @When("^Operator verifies created routes are printed successfully$")
  public void operatorVerifyMultipleRoutesIsPrintedSuccessfully() {
    routeLogsPage.verifyMultipleRoutesIsPrintedSuccessfully();
  }

  @When("^Operator archive routes on Route Logs page:$")
  public void operatorArchiveMultipleRoutes(List<String> routeIds) {
    routeIds = resolveValues(routeIds);
    routeIds.forEach(routeId -> {
      routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      routeLogsPage.routesTable.selectRow(1);
    });
    routeLogsPage.actionsMenu.selectOption(ACTION_ARCHIVE_SELECTED);
    routeLogsPage.archiveSelectedRoutesDialog.waitUntilVisible();
    routeLogsPage.archiveSelectedRoutesDialog.archiveRoutes.click();
    routeLogsPage.archiveSelectedRoutesDialog.waitUntilInvisible();
    routeLogsPage.waitUntilInvisibilityOfToast(routeIds.size() + " Route(s) Archived");
  }

  @When("^Operator delete routes on Route Logs page:$")
  public void operatorDeleteMultipleRoutes(List<String> routeIds) {
    routeIds = resolveValues(routeIds);
    routeIds.forEach(routeId -> {
      routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      routeLogsPage.routesTable.selectRow(1);
    });
    routeLogsPage.actionsMenu.selectOption(ACTION_DELETE_SELECTED);
    routeLogsPage.deleteRoutesDialog.waitUntilVisible();
    routeLogsPage.deleteRoutesDialog.delete.click();
    routeLogsPage.deleteRoutesDialog.waitUntilInvisible();
    routeLogsPage.waitUntilInvisibilityOfToast(routeIds.size() + " Route(s) Deleted");
  }

  @When("^Operator unarchive routes on Route Logs page:$")
  public void operatorUnarchiveMultipleRoutes(List<String> routeIds) {
    routeIds = resolveValues(routeIds);
    routeIds.forEach(routeId -> {
      routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      routeLogsPage.routesTable.selectRow(1);
    });
    routeLogsPage.actionsMenu.selectOption(ACTION_UNARCHIVE_SELECTED);
    routeLogsPage.unarchiveSelectedRoutesDialog.waitUntilVisible();
    routeLogsPage.unarchiveSelectedRoutesDialog.unarchiveRoutes.click();
    routeLogsPage.unarchiveSelectedRoutesDialog.waitUntilInvisible();
    routeLogsPage.waitUntilInvisibilityOfToast(routeIds.size() + " Route(s) Unarchived");
  }

  @When("^Operator save data of created routes on Route Logs page$")
  public void operatorSaveRouteData() {
    List<Long> routeIds = get(KEY_LIST_OF_CREATED_ROUTE_ID);
    List<RouteLogsParams> params = routeIds.stream().map(routeId -> {
      routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      return routeLogsPage.routesTable.readEntity(1);
    }).collect(Collectors.toList());
    put(KEY_LIST_OF_CREATE_ROUTE_PARAMS, params);
  }

  @Then("^Operator verify routes are deleted successfully:$")
  public void operatorVerifyMultipleRoutesIsDeletedSuccessfully(List<String> routeIds) {
    routeIds = resolveValues(routeIds);
    routeIds.forEach(routeId -> {
      routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      assertTrue("Route " + routeId + " was deleted", routeLogsPage.routesTable.isTableEmpty());
    });
  }

  @When("^Operator set filter using data below and click 'Load Selection'$")
  public void loadSelection(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    Date routeDateFrom = getDateByMode(mapOfData.get("routeDateFrom"));
    Date routeDateTo = getDateByMode(mapOfData.get("routeDateTo"));
    routeLogsPage.routeDateFilter.selectDates(routeDateFrom, routeDateTo);
    String hubName = mapOfData.get("hubName");
    if (StringUtils.isNotBlank(hubName)) {
      routeLogsPage.hubFilter.selectFilter(hubName);
    }
    routeLogsPage.loadSelection.clickAndWaitUntilDone();
  }

  @When("^Operator click 'Edit Route' and then click 'Load Waypoints of Selected Route\\(s\\) Only'$")
  public void loadWaypointsOfSelectedRoute() {
    Long routeId = get(KEY_CREATED_ROUTE_ID);
    routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
    routeLogsPage.routesTable.clickActionButton(1, ACTION_EDIT_ROUTE);
    routeLogsPage.editRoutesDialog.waitUntilVisible();
    routeLogsPage.editRoutesDialog.loadWpsOfSelectedRoutes.click();
  }

  @Then("Operator is redirected to this page {string}")
  public void verifyLoadWaypointsOfSelectedRoute(String redirectUrl) {
    redirectUrl = resolveValue(redirectUrl);

    String primaryWindowHandle = getWebDriver().getWindowHandle();
    Set<String> windowHandles = getWebDriver().getWindowHandles();

    String actualCurrentUrl = null;

    for (String windowName : windowHandles) {
      if (!primaryWindowHandle.equals(windowName)) {
        getWebDriver().switchTo().window(windowName);
        pause3s();

        try {
          WebDriverWait webDriverWait = new WebDriverWait(getWebDriver(),
              ALERT_WAIT_TIMEOUT_IN_SECONDS);
          Alert alert = webDriverWait.until(ExpectedConditions.alertIsPresent());
          pause200ms();
          alert.accept();
        } catch (Exception ex) {
          getScenarioManager().writeToCurrentScenarioLog(
              f("Alert is not present after %ds.", ALERT_WAIT_TIMEOUT_IN_SECONDS));
          getScenarioManager()
              .writeToCurrentScenarioLog(TestUtils.convertExceptionStackTraceToString(ex));
        }

        pause100ms();
        actualCurrentUrl = getCurrentUrl();
        getWebDriver().close();
        pause100ms();
        getWebDriver().switchTo().window(primaryWindowHandle);
        pause500ms();
        break;
      }
    }

    assertEquals(f("Operator does not redirect to page %s.", redirectUrl), redirectUrl,
        actualCurrentUrl);
  }

  @When("Operator opens Edit Details dialog for route {string}")
  public void operatorOpensEditDetails(String routeId) {
    routeId = resolveValue(routeId);
    routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
    routeLogsPage.routesTable.clickActionButton(1, ACTION_EDIT_DETAILS);
    routeLogsPage.editDetailsDialog.waitUntilVisible();
  }

  @When("Operator adds tag {string} to created route")
  public void opAddNewTagToRoute(String newTag) {
    newTag = resolveValue(newTag);
    Long routeId = get(KEY_CREATED_ROUTE_ID);
    routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
    routeLogsPage.selectTag.selectValue(newTag);
    routeLogsPage.click("//nv-table-description"); //to close tag selection popup
    routeLogsPage.waitUntilInvisibilityOfToast("1 Route(s) Tagged");
  }

  @When("^Operator deletes created route on Route Logs page$")
  public void opDeleteDeleteRoute() {
    Long routeId = get(KEY_CREATED_ROUTE_ID);
    routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
    routeLogsPage.routesTable.clickActionButton(1, ACTION_EDIT_DETAILS);
    routeLogsPage.editDetailsDialog.waitUntilVisible();
    routeLogsPage.editDetailsDialog.delete.click();
    routeLogsPage.deleteRoutesDialog.waitUntilVisible();
    pause500ms();
    routeLogsPage.deleteRoutesDialog.delete.click();
    routeLogsPage.deleteRoutesDialog.waitUntilInvisible();
    routeLogsPage.waitUntilInvisibilityOfToast("1 Route(s) Deleted");
  }

  @And("Operator open Route Manifest of created route from Route Logs page")
  public void operatorOpenRouteManifestOfCreatedRouteFromRouteLogsPage() {
    Long routeId = get(KEY_CREATED_ROUTE_ID);
    put(KEY_MAIN_WINDOW_HANDLE, routeLogsPage.getWebDriver().getWindowHandle());
    routeLogsPage.routesTable.filterByColumn(RoutesTable.COLUMN_ROUTE_ID, routeId);
    routeLogsPage.routesTable.clickColumn(1, RoutesTable.COLUMN_ROUTE_ID);
    routeLogsPage.switchToOtherWindowAndWaitWhileLoading("route-manifest/" + routeId);
    routeLogsPage.waitUntilPageLoaded();
  }

  @And("Operator filters route by {string} Route ID on Route Logs page")
  public void operatorFilterByRouteId(String routeId) {
    routeId = resolveValue(routeId);
    routeLogsPage.routeIdInput.setValue(routeId);
    routeLogsPage.search.clickAndWaitUntilDone();
  }

  @And("Operator verify route details on Route Logs page using data below:")
  public void operatorVerifyRouteDetails(Map<String, String> data) {
    data = resolveKeyValues(data);
    RouteLogsParams expected = new RouteLogsParams(data);
    routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, expected.getId());
    RouteLogsParams actual = routeLogsPage.routesTable.readEntity(1);
    expected.compareWithActual(actual);
  }

  @And("Operator verify routes details on Route Logs page using data below:")
  public void operatorVerifyRoutesDetails(List<Map<String, String>> data) {
    data.forEach(entity -> operatorVerifyRouteDetails(resolveKeyValues(entity)));
  }

  @And("Operator verifies that info toast displayed:")
  public void operatorVerifyInfoToast(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    long start = new Date().getTime();
    boolean found;
    do {
      found = routeLogsPage.toastInfo.stream().anyMatch(toast -> {
        String value = finalData.get("top");
        if (StringUtils.isNotBlank(value)) {
          if (!StringUtils.equalsIgnoreCase(value, toast.toastTop.getNormalizedText())) {
            return false;
          }
        }
        value = finalData.get("bottom");
        if (StringUtils.isNotBlank(value)) {
          return StringUtils.equalsIgnoreCase(value, toast.toastBottom.getNormalizedText());
        }
        return true;
      });
    } while (!found && new Date().getTime() - start < 20000);
    assertTrue("Toast " + finalData.toString() + " is displayed", found);
  }

  @And("Operator verifies that success toast displayed:")
  public void operatorVerifySuccessToast(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    boolean waitUntilInvisible = Boolean
        .parseBoolean(finalData.getOrDefault("waitUntilInvisible", "false"));
    long start = new Date().getTime();
    ToastInfo toastInfo;
    do {
      toastInfo = routeLogsPage.toastSuccess.stream()
          .filter(toast -> {
            String value = finalData.get("top");
            if (StringUtils.isNotBlank(value)) {
              if (!StringUtils.equalsIgnoreCase(value, toast.toastTop.getNormalizedText())) {
                return false;
              }
            }
            value = finalData.get("bottom");
            if (StringUtils.isNotBlank(value)) {
              return StringUtils.equalsIgnoreCase(value, toast.toastBottom.getNormalizedText());
            }
            return true;
          })
          .findFirst()
          .orElse(null);
    } while (toastInfo == null && new Date().getTime() - start < 20000);
    assertTrue("Toast " + finalData.toString() + " is displayed", toastInfo != null);
    if (waitUntilInvisible) {
      toastInfo.waitUntilInvisible();
    }
  }

  @And("Operator verifies that error toast displayed:")
  public void operatorVerifyErrorToast(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    long start = new Date().getTime();
    boolean found;
    do {
      found = routeLogsPage.toastErrors.stream().anyMatch(toast -> {
        String value = finalData.get("top");
        if (StringUtils.isNotBlank(value)) {
          if (!StringUtils.equalsIgnoreCase(value, toast.toastTop.getNormalizedText())) {
            return false;
          }
        }
        value = finalData.get("bottom");
        if (StringUtils.isNotBlank(value)) {
          if (value.startsWith("^")) {
            return value.matches(value);
          } else {
            return StringUtils.equalsIgnoreCase(value, toast.toastBottom.getNormalizedText());
          }
        }
        return true;
      });
    } while (!found && new Date().getTime() - start < 20000);
    assertTrue("Toast " + finalData.toString() + " is displayed", found);
  }

  @Then("^Operator verify the route is started after van inbounding using data below:$")
  public void verifyRouteIsStarted(Map<String, String> mapOfData) {
    long routeId = get(KEY_CREATED_ROUTE_ID);
    Date routeDateFrom = getDateByMode(mapOfData.get("routeDateFrom"));
    Date routeDateTo = getDateByMode(mapOfData.get("routeDateTo"));
    String hubName = mapOfData.get("hubName");

    routeLogsPage.setFilterAndLoadSelection(routeDateFrom, routeDateTo, hubName);
    routeLogsPage.routesTable.filterByColumn(RoutesTable.COLUMN_ROUTE_ID, routeId);
    String actualRouteStatus = routeLogsPage.routesTable
        .getColumnText(1, RoutesTable.COLUMN_STATUS);
    assertEquals("Track is not routed.", "IN_PROGRESS", actualRouteStatus);
  }

  @Then("Operator verify {string} process data in Selection Error dialog on Route Logs page:")
  public void verifySelectionErrors(String process, List<Map<String, String>> data) {
    process = resolveValue(process);

    routeLogsPage.selectionErrorDialog.waitUntilVisible();
    assertEquals("Process", process, routeLogsPage.selectionErrorDialog.process.getText());

    assertEquals("Number Of routes", data.size(),
        routeLogsPage.selectionErrorDialog.routeIds.size());

    for (int i = 0; i < data.size(); i++) {
      Map<String, String> expected = resolveKeyValues(data.get(i));
      String routeId = expected.get("routeId");
      String reason = expected.get("reason");
      int routeIndex = -1;
      for (int j = 0; j < data.size(); j++) {
        if (StringUtils
            .equals(routeId, routeLogsPage.selectionErrorDialog.routeIds.get(i).getText())) {
          routeIndex = i;
          break;
        }
      }
      assertTrue(f("Route %s found", routeId), routeIndex >= 0);
      assertEquals(f("Reason for route %s", routeId), reason,
          routeLogsPage.selectionErrorDialog.reasons.get(i).getText());
    }
  }

  @When("Operator select {string} for given routes on Route Logs page:")
  public void operatorSelectAction(String action, List<String> routeIds) {
    action = resolveValue(action);
    routeIds = resolveValues(routeIds);
    routeIds.forEach(routeId -> {
      routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      routeLogsPage.routesTable.selectRow(1);
    });
    routeLogsPage.actionsMenu.selectOption(action);
  }

  @Then("Operator clicks 'Continue' button in Selection Error dialog on Route Logs page")
  public void clickContinue() {
    routeLogsPage.selectionErrorDialog.continueBtn.click();
  }
}