package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.RouteLogsParams;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.page.RouteLogsPage;
import co.nvqa.operator_v2.selenium.page.RouteLogsPage.CreateRouteDialog;
import co.nvqa.operator_v2.selenium.page.RouteLogsPage.CreateRouteDialog.RouteDetailsForm;
import co.nvqa.operator_v2.selenium.page.RouteLogsPage.RoutesTable;
import co.nvqa.operator_v2.selenium.page.ToastInfo;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
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

    routeLogsPage.inFrame(() -> {
      routeLogsPage.waitUntilLoaded();
      routeLogsPage.createRouteReact.click();
      routeLogsPage.createRouteDialog.waitUntilVisible();

      CreateRouteDialog.RouteDetailsForm routeDetailsForm = routeLogsPage.createRouteDialog.routeDetailsForms
          .get(0);

      if (StringUtils.isNotBlank(newParams.getDate())) {
        routeDetailsForm.routeDate.setValue(newParams.getDate());
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

      routeLogsPage.createRouteDialog.createRoutes.click();
      routeLogsPage.waitUntilVisibilityOfNotification("1 Route(s) created");
      String toastBottom = routeLogsPage.noticeNotifications.get(0).description.getText();
      newParams.setId(toastBottom.replaceAll("\\d+.+Route", "").trim());
    });

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

    routeLogsPage.inFrame(() -> {
      routeLogsPage.waitUntilLoaded();
      routeLogsPage.createRouteReact.click();
      routeLogsPage.createRouteDialog.waitUntilVisible();

      RouteLogsParams newParams = routeParamsList.get(0);
      RouteDetailsForm routeDetailsForm = routeLogsPage.createRouteDialog.routeDetailsForms
          .get(0);

      if (StringUtils.isNotBlank(newParams.getDate())) {
        routeDetailsForm.routeDate.setValue(newParams.getDate());
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

      routeLogsPage.createRouteDialog.createRoutes.click();
      routeLogsPage.waitUntilVisibilityOfNotification(routeParamsList.size() + " Route(s) Created");
      String toastBottom = routeLogsPage.noticeNotifications.get(0).description.getText();
      newParams.setId(toastBottom.replaceAll("\\d+.+Route", "").trim());
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
    });
  }

  @When("^Operator bulk edits details of created routes using data below:$")
  public void operatorBulkEditDetailsMultipleRoutesUsingDataBelow(Map<String, String> data) {
    routeLogsPage.inFrame(() -> {
      RouteLogsParams newParams = new RouteLogsParams(resolveKeyValues(data));

      List<Long> routeIds = get(KEY_LIST_OF_CREATED_ROUTE_ID);
      routeIds.forEach(routeId -> {
        routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
        routeLogsPage.routesTable.selectRow(1);
      });
      routeLogsPage.actionsMenu.selectOption(ACTION_BULK_EDIT_DETAILS);
      routeLogsPage.bulkEditDetailsDialog.waitUntilVisible();
      if (StringUtils.isNotBlank(newParams.getDate())) {
        routeLogsPage.bulkEditDetailsDialog.routeDate.setValue(newParams.getDate());
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
      routeLogsPage.bulkEditDetailsDialog.saveChanges.click();
    });
  }

  @When("^Operator edits details of created route using data below:$")
  public void operatorEditDetailsMultipleRouteUsingDataBelow(Map<String, String> data) {
    routeLogsPage.inFrame(() -> {
      RouteLogsParams newParams = new RouteLogsParams(resolveKeyValues(data));

      Long routeId = get(KEY_CREATED_ROUTE_ID);
      routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      routeLogsPage.routesTable.clickActionButton(1, ACTION_EDIT_DETAILS);
      routeLogsPage.editDetailsDialog.waitUntilVisible();

      if (StringUtils.isNotBlank(newParams.getDate())) {
        routeLogsPage.editDetailsDialog.routeDate.setValue(newParams.getDate());
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
      routeLogsPage.editDetailsDialog.saveChanges.click();
    });
  }

  @When("^Operator merge transactions of created routes$")
  public void operatorMergeTransactionsOfMultipleRoutes() {
    routeLogsPage.inFrame(() -> {
      List<Long> routeIds = get(KEY_LIST_OF_CREATED_ROUTE_ID);
      routeIds.forEach(routeId -> {
        routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
        routeLogsPage.routesTable.selectRow(1);
      });
      routeLogsPage.actionsMenu.selectOption(ACTION_MERGE_TRANSACTIONS_OF_SELECTED);
      routeLogsPage.mergeTransactionsWithinSelectedRoutesDialog.waitUntilVisible();
      routeLogsPage.mergeTransactionsWithinSelectedRoutesDialog.mergeTransactions.click();
      routeLogsPage.mergeTransactionsWithinSelectedRoutesDialog.waitUntilInvisible();
    });
  }

  @When("^Operator optimise created routes$")
  public void operatorOptimiseMultipleRoutes() {
    routeLogsPage.inFrame(() -> {
      List<Long> routeIds = get(KEY_LIST_OF_CREATED_ROUTE_ID);
      routeIds.forEach(routeId -> {
        routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
        routeLogsPage.routesTable.selectRow(1);
      });
      routeLogsPage.actionsMenu.selectOption(ACTION_OPTIMISE_SELECTED);
    });
  }

  @Then("^Operator verifies created routes are optimised successfully$")
  public void operatorVerifyMultipleRoutesIsOptimisedSuccessfully() {
    routeLogsPage.inFrame(() -> {
      List<Long> listOfCreateRouteParams = get(KEY_LIST_OF_CREATED_ROUTE_ID);
      routeLogsPage.verifyMultipleRoutesIsOptimisedSuccessfully(listOfCreateRouteParams);
    });
  }

  @When("^Operator print passwords of created routes$")
  public void operatorPrintPasswordsOfMultipleRoutes() {
    routeLogsPage.inFrame(() -> {
      List<Long> routeIds = get(KEY_LIST_OF_CREATED_ROUTE_ID);
      routeIds.forEach(routeId -> {
        routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
        routeLogsPage.routesTable.selectRow(1);
      });
      routeLogsPage.actionsMenu.selectOption(ACTION_PRINT_PASSWORDS_OF_SELECTED);
    });
  }

  @Then("^Operator verify printed passwords of selected routes info is correct$")
  public void operatorVerifyPrintedPasswordsOfSelectedRoutesInfoIsCorrect() {
    List<RouteLogsParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);
    routeLogsPage.verifyPrintedPasswordsOfSelectedRoutesInfoIsCorrect(listOfCreateRouteParams);
  }

  @When("^Operator print created routes$")
  public void operatorPrintMultipleRoutes() {
    routeLogsPage.inFrame(() -> {
      List<Long> routeIds = get(KEY_LIST_OF_CREATED_ROUTE_ID);
      routeIds.forEach(routeId -> {
        routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
        routeLogsPage.routesTable.selectRow(1);
      });
      routeLogsPage.actionsMenu.selectOption(ACTION_PRINT_SELECTED);
    });
  }

  @When("^Operator verifies created routes are printed successfully$")
  public void operatorVerifyMultipleRoutesIsPrintedSuccessfully() {
    String latestFilenameOfDownloadedPdf = routeLogsPage.getLatestDownloadedFilename(
        "route_printout");
    routeLogsPage.verifyFileDownloadedSuccessfully(latestFilenameOfDownloadedPdf);
  }

  @When("^Operator archive routes on Route Logs page:$")
  public void operatorArchiveMultipleRoutes(List<String> routeIds) {
    routeLogsPage.inFrame(() -> {
      resolveValues(routeIds).forEach(routeId -> {
        routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
        routeLogsPage.routesTable.selectRow(1);
      });
      routeLogsPage.actionsMenu.selectOption(ACTION_ARCHIVE_SELECTED);
      routeLogsPage.archiveSelectedRoutesDialog.waitUntilVisible();
      routeLogsPage.archiveSelectedRoutesDialog.archiveRoutes.click();
    });
  }

  @When("^Operator delete routes on Route Logs page:$")
  public void operatorDeleteMultipleRoutes(List<String> routeIds) {
    routeLogsPage.inFrame(() -> {
      resolveValues(routeIds).forEach(routeId -> {
        routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
        routeLogsPage.routesTable.selectRow(1);
      });
      routeLogsPage.actionsMenu.selectOption(ACTION_DELETE_SELECTED);
      routeLogsPage.deleteRoutesDialog.waitUntilVisible();
      routeLogsPage.deleteRoutesDialog.delete.click();
    });
  }

  @When("^Operator unarchive routes on Route Logs page:$")
  public void operatorUnarchiveMultipleRoutes(List<String> routeIds) {
    routeLogsPage.inFrame(() -> {
      resolveValues(routeIds).forEach(routeId -> {
        routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
        routeLogsPage.routesTable.selectRow(1);
      });
      routeLogsPage.actionsMenu.selectOption(ACTION_UNARCHIVE_SELECTED);
      routeLogsPage.unarchiveSelectedRoutesDialog.waitUntilVisible();
      routeLogsPage.unarchiveSelectedRoutesDialog.unarchiveRoutes.click();
    });
  }

  @When("^Operator save data of created routes on Route Logs page$")
  public void operatorSaveRouteData() {
    routeLogsPage.inFrame(() -> {
      List<Long> routeIds = get(KEY_LIST_OF_CREATED_ROUTE_ID);
      List<RouteLogsParams> params = routeIds.stream().map(routeId -> {
        routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
        return routeLogsPage.routesTable.readEntity(1);
      }).collect(Collectors.toList());
      put(KEY_LIST_OF_CREATE_ROUTE_PARAMS, params);
    });
  }

  @Then("^Operator verify routes are deleted successfully:$")
  public void operatorVerifyMultipleRoutesIsDeletedSuccessfully(List<String> routeIds) {
    routeLogsPage.inFrame(() -> {
      resolveValues(routeIds).forEach(routeId -> {
        routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
        assertTrue("Route " + routeId + " was deleted", routeLogsPage.routesTable.isEmpty());
      });
    });
  }

  @When("^Operator set filter using data below and click 'Load Selection'$")
  public void loadSelection(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    Date routeDateFrom = getDateByMode(mapOfData.get("routeDateFrom"));
    Date routeDateTo = getDateByMode(mapOfData.get("routeDateTo"));
    String hubName = mapOfData.get("hubName");
    routeLogsPage.setFilterAndLoadSelection(routeDateFrom, routeDateTo, hubName);
  }

  @When("^Operator set filters on Route Logs page:")
  public void setFilters(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);

    routeLogsPage.inFrame(() -> {
      routeLogsPage.waitUntilLoaded();
      if (finalData.containsKey("routeDateFrom")) {
        routeLogsPage.routeDateFilter.setFrom(finalData.get("routeDateFrom"));
      }
      if (finalData.containsKey("routeDateTo")) {
        routeLogsPage.routeDateFilter.setTo(finalData.get("routeDateTo"));
      }
      if (finalData.containsKey("hub")) {
        routeLogsPage.hubFilter.clearAll();
        routeLogsPage.hubFilter.selectFilter(splitAndNormalize(finalData.get("hub")));
      }
      if (finalData.containsKey("driver")) {
        if (!routeLogsPage.driverFilter.isDisplayedFast()) {
          routeLogsPage.addFilter("Driver");
        }
        routeLogsPage.driverFilter.clearAll();
        routeLogsPage.driverFilter.selectFilter(splitAndNormalize(finalData.get("driver")));
      } else {
        if (routeLogsPage.driverFilter.isDisplayedFast()) {
          routeLogsPage.driverFilter.removeFilter();
        }
      }
      if (finalData.containsKey("zone")) {
        if (!routeLogsPage.zoneFilter.isDisplayedFast()) {
          routeLogsPage.addFilter("Zone");
        }
        routeLogsPage.zoneFilter.clearAll();
        routeLogsPage.zoneFilter.selectFilter(splitAndNormalize(finalData.get("zone")));
      } else {
        if (routeLogsPage.zoneFilter.isDisplayedFast()) {
          routeLogsPage.zoneFilter.removeFilter();
        }
      }
      if (finalData.containsKey("zone")) {
        if (!routeLogsPage.zoneFilter.isDisplayedFast()) {
          routeLogsPage.addFilter("Zone");
        }
        routeLogsPage.zoneFilter.clearAll();
        routeLogsPage.zoneFilter.selectFilter(splitAndNormalize(finalData.get("zone")));
      } else {
        if (routeLogsPage.zoneFilter.isDisplayedFast()) {
          routeLogsPage.zoneFilter.removeFilter();
        }
      }
      if (finalData.containsKey("archivedRoutes")) {
        if (!routeLogsPage.archivedRoutesFilter.isDisplayedFast()) {
          routeLogsPage.addFilter("Archived Routes");
        }
        routeLogsPage.archivedRoutesFilter.selectFilter(finalData.get("archivedRoutes"));
      } else {
        if (routeLogsPage.archivedRoutesFilter.isDisplayedFast()) {
          routeLogsPage.archivedRoutesFilter.deleteFilter();
        }
      }
    });
  }

  @When("Operator selects {string} preset action on Route Logs page")
  public void selectPresetAction(String action) {
    routeLogsPage.inFrame(() -> routeLogsPage.presetActions.selectOption(resolveValue(action)));
  }

  @When("Operator verifies Save Preset dialog on Route Logs page contains filters:")
  public void verifySelectedFiltersForPreset(List<String> expected) {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.savePresetDialog.waitUntilVisible();
      List<String> actual = routeLogsPage.savePresetDialog.selectedFilters.stream()
          .map(PageElement::getNormalizedText)
          .collect(Collectors.toList());
      Assertions.assertThat(actual)
          .as("List of selected filters")
          .containsExactlyInAnyOrderElementsOf(expected);
    });
  }

  @When("Operator verifies Preset Name field in Save Preset dialog on Route Logs page is required")
  public void verifyPresetNameIsRequired() {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.savePresetDialog.waitUntilVisible();
      Assertions.assertThat(routeLogsPage.savePresetDialog.helpText.getText())
          .as("Preset Name error text")
          .isEqualTo("This field is required");
    });
  }

  @When("Operator verifies Cancel button in Save Preset dialog on Route Logs page is enabled")
  public void verifyCancelIsEnabled() {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.savePresetDialog.waitUntilVisible();
      Assertions.assertThat(routeLogsPage.savePresetDialog.cancel.isEnabled())
          .as("Cancel button is enabled")
          .isTrue();
    });
  }

  @When("Operator verifies Save button in Save Preset dialog on Route Logs page is enabled")
  public void verifySaveIsEnabled() {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.savePresetDialog.waitUntilVisible();
      Assertions.assertThat(routeLogsPage.savePresetDialog.save.isEnabled())
          .as("Save button is enabled")
          .isTrue();
    });
  }

  @When("Operator clicks Save button in Save Preset dialog on Route Logs page")
  public void clickSaveInSavePresetDialog() {
    routeLogsPage.inFrame(() -> routeLogsPage.savePresetDialog.save.click());
  }

  @When("Operator verifies Cancel button in Delete Preset dialog on Route Logs page is enabled")
  public void verifyCancelIsEnabledInDeletePreset() {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.deletePresetDialog.waitUntilVisible();
      Assertions.assertThat(routeLogsPage.deletePresetDialog.cancel.isEnabled())
          .as("Cancel button is enabled")
          .isTrue();
    });
  }

  @When("Operator verifies Delete button in Delete Preset dialog on Route Logs page is enabled")
  public void verifyDeleteIsEnabled() {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.deletePresetDialog.waitUntilVisible();
      Assertions.assertThat(routeLogsPage.deletePresetDialog.delete.isEnabled())
          .as("Delete button is enabled")
          .isTrue();
    });
  }

  @When("Operator selects {string} preset in Delete Preset dialog on Route Logs page")
  public void selectPresetInDeletePresets(String value) {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.deletePresetDialog.waitUntilVisible();
      routeLogsPage.deletePresetDialog.preset.selectValue(resolveValue(value));
    });
  }

  @When("Operator verifies {string} preset is selected in Delete Preset dialog on Route Logs page")
  public void verifySelectedPresetInDeletePresets(String value) {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.deletePresetDialog.waitUntilVisible();
      Assertions.assertThat(routeLogsPage.deletePresetDialog.preset.getValue())
          .as("Selected preset")
          .isEqualTo(resolveValue(value));
    });
  }

  @When("Operator clicks Delete button in Delete Preset dialog on Route Logs page")
  public void clickDeleteInDeletePresetDialog() {
    routeLogsPage.inFrame(() -> routeLogsPage.deletePresetDialog.delete.click());
  }

  @When("Operator verifies Delete button in Delete Preset dialog on Route Logs page is disabled")
  public void verifyDeleteIsDisabled() {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.deletePresetDialog.waitUntilVisible();
      Assertions.assertThat(routeLogsPage.deletePresetDialog.delete.isEnabled())
          .as("Delete button is enabled")
          .isFalse();
    });
  }

  @When("Operator verifies {string} message is displayed in Delete Preset dialog on Route Logs page")
  public void verifyMessageInDeletePreset(String expected) {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.deletePresetDialog.waitUntilVisible();
      Assertions.assertThat(routeLogsPage.deletePresetDialog.message.getNormalizedText())
          .as("Delete Preset message")
          .isEqualTo(resolveValue(expected));
    });
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

  @When("Operator verifies selected Filter Preset name is {string} on Route Logs page")
  public void verifySelectedPresetName(String expected) {
    String finalExpected = resolveValue(expected);
    routeLogsPage.inFrame(() -> {
      String actual = StringUtils.trim(routeLogsPage.filterPreset.getValue());
      Pattern p = Pattern.compile("(\\d+)\\s-\\s(.+)");
      Matcher m = p.matcher(actual);
      Assertions.assertThat(m.matches())
          .as("Selected Filter Preset value matches to pattern")
          .isTrue();
      Long presetId = Long.valueOf(m.group(1));
      String presetName = m.group(2);
      Assertions.assertThat(presetName)
          .as("Preset Name")
          .isEqualTo(finalExpected);
      put(KEY_ROUTES_FILTERS_PRESET_ID, presetId);
    });
  }

  @When("Operator selects {string} Filter Preset on Route Logs page")
  public void selectPresetName(String value) {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.waitUntilLoaded(2);
      routeLogsPage.filterPreset.selectValue(resolveValue(value));
      routeLogsPage.waitUntilLoaded(2);
    });
  }

  @When("^Operator verifies selected filters on Route Logs page:$")
  public void operatorVerifiesSelectedFilters(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);

    SoftAssertions assertions = new SoftAssertions();

    routeLogsPage.inFrame(() -> {
      if (finalData.containsKey("routeDateFrom")) {
        boolean isDisplayed = routeLogsPage.routeDateFilter.isDisplayedFast();
        if (!isDisplayed) {
          assertions.fail("Route Date filter is not displayed");
        } else {
          assertions.assertThat(routeLogsPage.routeDateFilter.getValueFrom())
              .as("Route Date from")
              .isEqualTo(data.get("routeDateFrom"));
        }
      }
      if (finalData.containsKey("routeDateTo")) {
        boolean isDisplayed = routeLogsPage.routeDateFilter.isDisplayedFast();
        if (!isDisplayed) {
          assertions.fail("Route Date filter is not displayed");
        } else {
          assertions.assertThat(routeLogsPage.routeDateFilter.getValueTo())
              .as("Route Date to")
              .isEqualTo(data.get("routeDateTo"));
        }
      }
      if (finalData.containsKey("hub")) {
        boolean isDisplayed = routeLogsPage.hubFilter.isDisplayedFast();
        if (!isDisplayed) {
          assertions.fail("Hub filter is not displayed");
        } else {
          assertions.assertThat(routeLogsPage.hubFilter.getSelectedValues())
              .as("Hub items")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("hub")));
        }
      }
      if (finalData.containsKey("driver")) {
        boolean isDisplayed = routeLogsPage.driverFilter.isDisplayedFast();
        if (!isDisplayed) {
          assertions.fail("Driver filter is not displayed");
        } else {
          assertions.assertThat(routeLogsPage.driverFilter.getSelectedValues())
              .as("Driver items")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("driver")));
        }
      }
      if (finalData.containsKey("zone")) {
        boolean isDisplayed = routeLogsPage.zoneFilter.isDisplayedFast();
        if (!isDisplayed) {
          assertions.fail("Driver filter is not displayed");
        } else {
          assertions.assertThat(routeLogsPage.zoneFilter.getSelectedValues())
              .as("Zone items")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("zone")));
        }
      }
      if (finalData.containsKey("archivedRoutes")) {
        boolean isDisplayed = routeLogsPage.archivedRoutesFilter.isDisplayedFast();
        if (!isDisplayed) {
          assertions.fail("Driver filter is not displayed");
        } else {
          assertions.assertThat(routeLogsPage.archivedRoutesFilter.getSelectedValue())
              .as("Zone items")
              .isEqualTo(Boolean.parseBoolean(data.get("archivedRoutes")));
        }
      }
    });
    assertions.assertAll();
  }

  @When("Operator verifies Save button in Save Preset dialog on Route Logs page is disabled")
  public void verifySaveIsDisabled() {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.savePresetDialog.waitUntilVisible();
      Assertions.assertThat(routeLogsPage.savePresetDialog.save.isEnabled())
          .as("Save button is enabled")
          .isFalse();
    });
  }

  @When("Operator enters {string} Preset Name in Save Preset dialog on Route Logs page")
  public void enterPresetNameIsRequired(String presetName) {
    String finalPresetName = resolveValue(presetName);
    routeLogsPage.inFrame(() -> {
      routeLogsPage.savePresetDialog.waitUntilVisible();
      routeLogsPage.savePresetDialog.presetName.setValue(finalPresetName);
      put(KEY_ROUTES_FILTERS_PRESET_NAME, finalPresetName);
    });
  }

  @When("Operator verifies Preset Name field in Save Preset dialog on Route Logs page has green checkmark on it")
  public void verifyPresetNameIsValidated() {
    routeLogsPage.inFrame(() ->
        Assertions.assertThat(routeLogsPage.savePresetDialog.confirmedIcon.isDisplayed())
            .as("Preset Name checkmark")
            .isTrue()
    );
  }

  @When("Operator verifies help text {string} is displayed in Save Preset dialog on Route Logs page")
  public void verifyHelpTextInSavePreset(String expected) {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.savePresetDialog.waitUntilVisible();
      Assertions.assertThat(routeLogsPage.savePresetDialog.helpText.getNormalizedText())
          .as("Help Text")
          .isEqualTo(resolveValue(expected));
    });
  }

  @When("Operator clicks Update button in Save Preset dialog on Rout Logs page")
  public void clickUpdateInSavePresetDialog() {
    routeLogsPage.inFrame(() -> routeLogsPage.savePresetDialog.update.click());
  }

  @When("^Operator click 'Edit Route' and then click 'Load Waypoints of Selected Route\\(s\\) Only'$")
  public void loadWaypointsOfSelectedRoute() {
    routeLogsPage.inFrame(() -> {
      Long routeId = get(KEY_CREATED_ROUTE_ID);
      routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      routeLogsPage.routesTable.clickActionButton(1, ACTION_EDIT_ROUTE);
      routeLogsPage.editRoutesDialog.waitUntilVisible();
      routeLogsPage.editRoutesDialog.loadWpsOfSelectedRoutes.click();
    });
  }

  @Then("Operator is redirected to this page {string}")
  public void verifyLoadWaypointsOfSelectedRoute(String redirectUrl) {
    redirectUrl = resolveValue(TestConstants.OPERATOR_PORTAL_BASE_URL + redirectUrl);

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
    Long routeId = get(KEY_CREATED_ROUTE_ID);
    routeLogsPage.inFrame(() -> {
      routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      routeLogsPage.selectTag.selectValue(resolveValue(newTag));
      routeLogsPage.click("//div[contains(@class,'DisplayStats')]"); //to close tag selection popup
    });
  }

  @When("^Operator deletes created route on Route Logs page$")
  public void opDeleteDeleteRoute() {
    routeLogsPage.inFrame(() -> {
      Long routeId = get(KEY_CREATED_ROUTE_ID);
      routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      routeLogsPage.routesTable.clickActionButton(1, ACTION_EDIT_DETAILS);
      routeLogsPage.editDetailsDialog.waitUntilVisible();
      routeLogsPage.editDetailsDialog.delete.click();
      routeLogsPage.deleteRoutesDialog.waitUntilVisible();
      pause500ms();
      routeLogsPage.deleteRoutesDialog.delete.click();
      routeLogsPage.deleteRoutesDialog.waitUntilInvisible();
    });
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
    routeLogsPage.inFrame(() -> {
      routeLogsPage.waitUntilLoaded();
      routeLogsPage.routeIdInput.setValue(resolveValue(routeId));
      routeLogsPage.search.click();
      routeLogsPage.waitUntilLoaded(5);
    });
  }

  @And("Operator verify route details on Route Logs page using data below:")
  public void operatorVerifyRouteDetails(Map<String, String> data) {
    routeLogsPage.inFrame(() -> {
      RouteLogsParams expected = new RouteLogsParams(resolveKeyValues(data));
      routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, expected.getId());
      RouteLogsParams actual = routeLogsPage.routesTable.readEntity(1);
      expected.compareWithActual(actual);
    });
  }

  @And("Operator verify routes details on Route Logs page using data below:")
  public void operatorVerifyRoutesDetails(List<Map<String, String>> data) {
    data.forEach(entity -> operatorVerifyRouteDetails(resolveKeyValues(entity)));
  }

  @And("Operator verifies that info toast displayed:")
  public void operatorVerifyInfoToast(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    boolean waitUntilInvisible = Boolean
        .parseBoolean(finalData.getOrDefault("waitUntilInvisible", "false"));
    long start = new Date().getTime();
    ToastInfo toastInfo;
    do {
      toastInfo = routeLogsPage.toastInfo.stream()
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
    if (toastInfo != null && waitUntilInvisible) {
      toastInfo.waitUntilInvisible();
    }
  }

  @Then("Operator verifies that success react notification displayed:")
  @And("Operator verifies that error react notification displayed:")
  public void operatorVerifySuccessReactToast(Map<String, String> data) {
    routeLogsPage.inFrame(() -> {
      Map<String, String> finalData = resolveKeyValues(data);
      boolean waitUntilInvisible = Boolean
          .parseBoolean(finalData.getOrDefault("waitUntilInvisible", "false"));
      long start = new Date().getTime();
      AntNotification toastInfo;
      do {
        toastInfo = routeLogsPage.noticeNotifications.stream()
            .filter(toast -> {
              String actualTop = toast.message.getNormalizedText();
              NvLogger.info("Found notification: " + actualTop);
              String value = finalData.get("top");
              if (StringUtils.isNotBlank(value)) {
                if (!StringUtils.equalsIgnoreCase(value, actualTop)) {
                  return false;
                }
              }
              value = finalData.get("bottom");
              if (StringUtils.isNotBlank(value)) {
                return StringUtils.equalsIgnoreCase(value, toast.description.getNormalizedText());
              }
              return true;
            })
            .findFirst()
            .orElse(null);
      } while (toastInfo == null && new Date().getTime() - start < 20000);
      assertTrue("Toast " + finalData.toString() + " is displayed", toastInfo != null);
      if (toastInfo != null && waitUntilInvisible) {
        toastInfo.waitUntilInvisible();
      }
    });
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
          String actual = toast.toastBottom.getNormalizedText();
          if (value.startsWith("^")) {
            return actual.matches(value);
          } else {
            return StringUtils.equalsIgnoreCase(value, actual);
          }
        }
        return true;
      });
    } while (!found && new Date().getTime() - start < 20000);
    assertTrue("Toast " + finalData.toString() + " is displayed", found);
  }

  @And("Operator verifies that warning toast displayed:")
  public void operatorVerifyWarningToast(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    long start = new Date().getTime();
    boolean found;
    do {
      found = routeLogsPage.toastWarnings.stream().anyMatch(toast -> {
        String value = finalData.get("top");
        if (StringUtils.isNotBlank(value)) {
          if (!StringUtils.equalsIgnoreCase(value, toast.toastTop.getNormalizedText())) {
            return false;
          }
        }
        value = finalData.get("bottom");
        if (StringUtils.isNotBlank(value)) {
          String actual = toast.toastBottom.getNormalizedText();
          if (value.startsWith("^")) {
            return actual.matches(value);
          } else {
            return StringUtils.equalsIgnoreCase(value, actual);
          }
        }
        return true;
      });
    } while (!found && new Date().getTime() - start < 20000);
    assertTrue("Toast " + finalData.toString() + " is displayed", found);
  }

  @Then("^Operator verify the route is started after van inbounding using data below:$")
  public void verifyRouteIsStarted(Map<String, String> mapOfData) throws ParseException {
    long routeId = get(KEY_CREATED_ROUTE_ID);
    Date routeDateFrom = DateUtil.SDF_YYYY_MM_DD.parse(mapOfData.get("routeDateFrom"));
    Date routeDateTo = DateUtil.SDF_YYYY_MM_DD.parse(mapOfData.get("routeDateTo"));
    String hubName = mapOfData.get("hubName");

    routeLogsPage.setFilterAndLoadSelection(routeDateFrom, routeDateTo, hubName);
    routeLogsPage.routesTable.filterByColumn(RoutesTable.COLUMN_ROUTE_ID, routeId);
    String actualRouteStatus = routeLogsPage.routesTable
        .getColumnText(1, RoutesTable.COLUMN_STATUS);
    assertEquals("Track is not routed.", "IN_PROGRESS", actualRouteStatus);
  }

  @Then("Operator verify {string} process data in Selection Error dialog on Route Logs page:")
  public void verifySelectionErrors(String process, List<Map<String, String>> data) {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.selectionErrorDialog.waitUntilVisible();
      assertEquals("Process", resolveValue(process),
          routeLogsPage.selectionErrorDialog.process.getText().replace("Process", "").trim());

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
    });
  }

  @When("Operator select {string} for given routes on Route Logs page:")
  public void operatorSelectAction(String action, List<String> routeIds) {
    routeLogsPage.inFrame(() -> {
      resolveValues(routeIds).forEach(routeId -> {
        routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
        routeLogsPage.routesTable.selectRow(1);
      });
      routeLogsPage.actionsMenu.selectOption(resolveValue(action));
    });
  }

  @Then("Operator clicks 'Continue' button in Selection Error dialog on Route Logs page")
  public void clickContinue() {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.selectionErrorDialog.continueBtn.click();
    });
  }
}