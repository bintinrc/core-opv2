package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.model.RouteLogsParams;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.page.RouteLogsPage;
import co.nvqa.operator_v2.selenium.page.RouteLogsPage.CreateRouteDialog;
import co.nvqa.operator_v2.selenium.page.RouteLogsPage.CreateRouteDialog.RouteDetailsForm;
import co.nvqa.operator_v2.selenium.page.RouteLogsPage.RoutesTable;
import co.nvqa.operator_v2.selenium.page.ToastInfo;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.text.ParseException;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.openqa.selenium.NoSuchElementException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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
import static co.nvqa.operator_v2.selenium.page.RouteLogsPage.RoutesTable.ACTION_OPTIMIZE_ROUTE;
import static co.nvqa.operator_v2.selenium.page.RouteLogsPage.RoutesTable.ACTION_VERIFY_ADDRESS;
import static co.nvqa.operator_v2.selenium.page.RouteLogsPage.RoutesTable.COLUMN_ROUTE_ID;
import static co.nvqa.operator_v2.selenium.page.RouteLogsPage.RoutesTable.COLUMN_TAGS;
import static org.assertj.core.api.Assertions.assertThat;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteLogsSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(RouteLogsSteps.class);

  private RouteLogsPage routeLogsPage;

  public RouteLogsSteps() {
  }

  @Override
  public void init() {
    routeLogsPage = new RouteLogsPage(getWebDriver());
  }

  @When("Operator create new route using data below:")
  public void operatorCreateNewRouteUsingDataBelow(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String scenarioName = getScenarioManager().getCurrentScenario().getName();
    String createdDate = DTF_CREATED_DATE.format(ZonedDateTime.now());
    String comments = f(
        "This route is created from OpV2 for testing purpose only. Ignore this route. Created at %s by scenario \"%s\".",
        createdDate, scenarioName);

    RouteLogsParams newParams = new RouteLogsParams(mapOfData);
    newParams.setComments(comments);

    routeLogsPage.inFrame(() -> {
      routeLogsPage.waitUntilLoaded();
      routeLogsPage.createRoute.click();
      routeLogsPage.createRouteDialog.waitUntilVisible();
      pause1s();

      CreateRouteDialog.RouteDetailsForm routeDetailsForm = routeLogsPage.createRouteDialog.routeDetailsForms
          .get(
              0);

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

  @When("Operator verifies {value} Driver is not shown in Create Route modal on Route Logs page")
  public void verifyInvalidDriver(String value) {
    routeLogsPage.inFrame(page -> {
      page.createRouteDialog.waitUntilVisible();
      CreateRouteDialog.RouteDetailsForm routeDetailsForm = routeLogsPage.createRouteDialog.routeDetailsForms
          .get(
              0);
      routeDetailsForm.assignedDriver.waitUntilEnabled();
      Assertions.assertThatExceptionOfType(NoSuchElementException.class)
          .as("Error expected for %s Driver value", value)
          .isThrownBy(() -> routeDetailsForm.assignedDriver.selectValue(value));
    });
  }

  @When("Operator verifies {value} Driver is not shown in Edit Route Details modal on Route Logs page")
  public void verifyInvalidDriverEditRote(String value) {
    routeLogsPage.inFrame(page -> {
      page.editRoutesDialog.waitUntilVisible();
      Assertions.assertThatExceptionOfType(NoSuchElementException.class)
          .as("Error expected for %s Driver value", value)
          .isThrownBy(() -> page.editDetailsDialog.assignedDriver.selectValue(value));
    });
  }

  @When("Operator verifies {value} Driver is shown in Create Route modal on Route Logs page")
  public void verifyValidDriver(String value) {
    routeLogsPage.inFrame(page -> {
      page.createRouteDialog.waitUntilVisible();
      CreateRouteDialog.RouteDetailsForm routeDetailsForm = routeLogsPage.createRouteDialog.routeDetailsForms
          .get(
              0);
      routeDetailsForm.assignedDriver.waitUntilEnabled();
      retryIfRuntimeExceptionOccurred(() -> routeDetailsForm.assignedDriver.selectValue(value), 5);
    });
  }

  @When("Operator verifies {value} Driver is shown in Edit Route Details modal on Route Logs page")
  public void verifyValidDriverEditRoute(String value) {
    routeLogsPage.inFrame(page -> {
      page.editDetailsDialog.waitUntilVisible();
      routeLogsPage.editDetailsDialog.assignedDriver.waitUntilEnabled();
      routeLogsPage.editDetailsDialog.assignedDriver.selectValue(value);
    });
  }

  @When("Operator clicks Create Route on Route Logs page")
  public void clickCreateRoute() {
    routeLogsPage.inFrame(page -> {
      page.waitUntilLoaded();
      page.createRoute.click();
    });
  }

  @When("^Operator create multiple routes using data below:$")
  public void operatorCreateMultipleRoutesUsingDataBelow(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String scenarioName = getScenarioManager().getCurrentScenario().getName();
    String createdDate = DTF_CREATED_DATE.format(ZonedDateTime.now());

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
      routeLogsPage.createRoute.click();
      routeLogsPage.createRouteDialog.waitUntilVisible();

      RouteLogsParams newParams = routeParamsList.get(0);
      RouteDetailsForm routeDetailsForm = routeLogsPage.createRouteDialog.routeDetailsForms.get(0);

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

  @When("Operator bulk edits details of created routes using data below:")
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
      if (StringUtils.isNotBlank(newParams.getZone())) {
        routeLogsPage.bulkEditDetailsDialog.zone.selectValue(newParams.getZone());
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

  @When("Operator verifies errors in Bulk Edit Details dialog on Route Logs page:")
  public void verifyBulkEditErrors(List<String> data) {
    routeLogsPage.inFrame(() -> {
      List<String> expected = resolveValues(data);
      routeLogsPage.bulkEditDetailsDialog.waitUntilVisible();
      pause5s();
      List<String> actual = routeLogsPage.bulkEditDetailsDialog.errors.stream()
          .map(PageElement::getNormalizedText)
          .collect(Collectors.toList());
      Assertions.assertThat(actual)
          .as("List of errors")
          .containsExactlyInAnyOrderElementsOf(expected);
    });
  }

  @When("Operator click Cancel in Bulk Edit Details dialog on Route Logs page")
  public void clickBulkEditCancel() {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.bulkEditDetailsDialog.waitUntilVisible();
      routeLogsPage.bulkEditDetailsDialog.cancel.click();
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
      if (StringUtils.isNotBlank(newParams.getZone())) {
        routeLogsPage.editDetailsDialog.zone.selectValue(newParams.getZone());
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

  @When("Operator verify Edit Details button is disabled on Route Logs page")
  public void clickCheckAssignmentIsDisabled() {
    routeLogsPage.inFrame(() -> {
          Long routeId = get(KEY_CREATED_ROUTE_ID);
          routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
          assertThat(routeLogsPage.routesTable.isButtonEnabled(1, ACTION_EDIT_DETAILS))
              .withFailMessage("Edit Details button is enabled")
              .isFalse();
        }
    );
  }

  @When("Operator verifies address of {string} route on Route Logs page")
  public void operatorVerifiesRouteAddress(String routeIdVal) {
    routeLogsPage.inFrame(() -> {
      Long routeId = Long.valueOf(resolveValue(routeIdVal));
      routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      routeLogsPage.routesTable.clickActionButton(1, ACTION_VERIFY_ADDRESS);
      routeLogsPage.addressVerifyRouteDialog.waitUntilVisible();
      routeLogsPage.addressVerifyRouteDialog.addressVerifyRoute.click();
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

  @When("Operator optimise created routes")
  public void operatorOptimiseMultipleRoutes() {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.waitUntilLoaded(3);
      List<Long> routeIds = get(KEY_LIST_OF_CREATED_ROUTE_ID);
      routeIds.forEach(routeId -> {
        routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
        routeLogsPage.routesTable.selectRow(1);
      });
      routeLogsPage.actionsMenu.selectOption(ACTION_OPTIMISE_SELECTED);
    });
  }

  @When("Operator opens Optimize Selected Route dialog for {string} route on Route Logs page")
  public void operatorOptimiseRoute(String routeId) {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.waitUntilLoaded(3);
      routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, resolveValue(routeId));
      routeLogsPage.routesTable.clickActionButton(1, ACTION_OPTIMIZE_ROUTE);
      routeLogsPage.optimizeSelectedRouteDialog.waitUntilVisible();
    });
  }

  @When("Optimize Selected Route dialog contains message on Route Logs page:")
  public void operatorOptimiseRoute(List<String> lines) {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.waitUntilLoaded(3);
      List<String> actual = routeLogsPage.optimizeSelectedRouteDialog.message.stream()
          .map(PageElement::getText).collect(Collectors.toList());
      Assertions.assertThat(actual).as("Optimize Selected Route dialog message")
          .containsExactlyElementsOf(lines);
    });
  }

  @When("Operator clicks Optimize Route button in Optimize Selected Route dialog on Route Logs page")
  public void operatorClickOptimizeRouteButton() {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.optimizeSelectedRouteDialog.optimizeRoute.click();
    });
  }

  @Then("^Operator verifies created routes are optimised successfully$")
  public void operatorVerifyMultipleRoutesIsOptimisedSuccessfully() {
    routeLogsPage.inFrame(() -> {
      List<Long> listOfCreateRouteParams = get(KEY_LIST_OF_CREATED_ROUTE_ID);
      routeLogsPage.verifyMultipleRoutesIsOptimisedSuccessfully(listOfCreateRouteParams);
    });
  }

  @When("Operator print passwords of created routes")
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

  @Then("Operator verify printed passwords of selected routes info is correct")
  public void operatorVerifyPrintedPasswordsOfSelectedRoutesInfoIsCorrect() {
    List<RouteLogsParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);
    routeLogsPage.verifyPrintedPasswordsOfSelectedRoutesInfoIsCorrect(listOfCreateRouteParams);
    takesScreenshot();
  }

  @When("Operator print created routes")
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

  @When("Operator verifies created routes are printed successfully")
  public void operatorVerifyMultipleRoutesIsPrintedSuccessfully() {
    String latestFilenameOfDownloadedPdf = routeLogsPage.getLatestDownloadedFilename(
        "route_printout");
    routeLogsPage.verifyFileDownloadedSuccessfully(latestFilenameOfDownloadedPdf);
    takesScreenshot();
  }

  @When("Operator archive routes on Route Logs page:")
  public void operatorArchiveMultipleRoutes(List<String> routeIds) {
    routeLogsPage.inFrame(() -> {
      resolveValues(routeIds).forEach(routeId -> {
        routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
        routeLogsPage.routesTable.selectRow(1);
      });
      routeLogsPage.actionsMenu.selectOption(ACTION_ARCHIVE_SELECTED);
      routeLogsPage.archiveSelectedRoutesDialog.waitUntilVisible();
      if (routeLogsPage.archiveSelectedRoutesDialog.archiveRoutes.waitUntilVisible(1)) {
        routeLogsPage.archiveSelectedRoutesDialog.archiveRoutes.click();
      } else {
        routeLogsPage.archiveSelectedRoutesDialog.continueBtn.click();
      }
    });
    takesScreenshot();
  }

  @When("Operator delete routes on Route Logs page:")
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

  @When("Operator unarchive routes on Route Logs page:")
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

  @When("Operator save data of created routes on Route Logs page")
  public void operatorSaveRouteData() {
    routeLogsPage.inFrame(() -> {
      List<Long> routeIds = get(KEY_LIST_OF_CREATED_ROUTE_ID);
      routeLogsPage.routesTable.waitIsNotEmpty(10);
      List<RouteLogsParams> params = routeIds.stream().map(routeId -> {
        routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
        return routeLogsPage.routesTable.readEntity(1);
      }).collect(Collectors.toList());
      put(KEY_LIST_OF_CREATE_ROUTE_PARAMS, params);
    });
  }

  @Then("Operator verify routes are deleted successfully:")
  public void operatorVerifyMultipleRoutesIsDeletedSuccessfully(List<String> routeIds) {
    routeLogsPage.inFrame(() -> {
      resolveValues(routeIds).forEach(routeId -> {
        routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
        pause2s();
        Assertions.assertThat(routeLogsPage.routesTable.isEmpty())
            .as("Route " + routeId + " was deleted").isTrue();
      });
    });
    takesScreenshot();
  }

  @When("Operator set filter using data below and click 'Load Selection'")
  public void loadSelection(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    routeLogsPage.inFrame(page -> {
      page.waitUntilLoaded(60);
      if (finalData.containsKey("routeDateFrom")) {
        page.routeDateFilter.setInterval(finalData.get("routeDateFrom"),
            finalData.get("routeDateTo"));
      }
      page.hubFilter.clearAll();
      if (finalData.containsKey("hubName")) {
        page.hubFilter.selectFilter(finalData.get("hubName"));
      }
      if (finalData.containsKey("archiveRoutes")) {
        page.archivedRoutesFilter.selectFilter(
            StringUtils.equalsAnyIgnoreCase(finalData.get("archiveRoutes"), "show", "true"));
      }
      page.loadSelection.clickAndWaitUntilDone();
      page.waitUntilLoaded();
    });
  }

  @When("Operator set filters on Route Logs page:")
  public void setFilters(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);

    routeLogsPage.inFrame(() -> {
      routeLogsPage.waitUntilLoaded();
      if (finalData.containsKey("routeDateFrom")) {
        pause1s();
        routeLogsPage.routeDateFilter.setFrom(finalData.get("routeDateFrom"));
      }
      if (finalData.containsKey("routeDateTo")) {
        pause1s();
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
          routeLogsPage.archivedRoutesFilter.removeFilter();
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
          .map(PageElement::getNormalizedText).collect(Collectors.toList());
      Assertions.assertThat(actual).as("List of selected filters")
          .containsExactlyInAnyOrderElementsOf(expected);
    });
    takesScreenshot();
  }

  @When("Operator verifies Preset Name field in Save Preset dialog on Route Logs page is required")
  public void verifyPresetNameIsRequired() {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.savePresetDialog.waitUntilVisible();
      Assertions.assertThat(routeLogsPage.savePresetDialog.helpText.getText())
          .as("Preset Name error text").isEqualTo("Field is required");
    });
    takesScreenshot();
  }

  @When("Operator verifies Cancel button in Save Preset dialog on Route Logs page is enabled")
  public void verifyCancelIsEnabled() {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.savePresetDialog.waitUntilVisible();
      Assertions.assertThat(routeLogsPage.savePresetDialog.cancel.isEnabled())
          .as("Cancel button is enabled").isTrue();
    });
    takesScreenshot();
  }

  @When("Operator verifies Save button in Save Preset dialog on Route Logs page is enabled")
  public void verifySaveIsEnabled() {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.savePresetDialog.waitUntilVisible();
      Assertions.assertThat(routeLogsPage.savePresetDialog.save.isEnabled())
          .as("Save button is enabled").isTrue();
    });
    takesScreenshot();
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
          .as("Cancel button is enabled").isTrue();
    });
    takesScreenshot();
  }

  @When("Operator verifies Delete button in Delete Preset dialog on Route Logs page is enabled")
  public void verifyDeleteIsEnabled() {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.deletePresetDialog.waitUntilVisible();
      Assertions.assertThat(routeLogsPage.deletePresetDialog.delete.isEnabled())
          .as("Delete button is enabled").isTrue();
    });
    takesScreenshot();
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
          .as("Selected preset").isEqualTo(resolveValue(value));
    });
    takesScreenshot();
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
          .as("Delete button is enabled").isFalse();
    });
  }

  @When("Operator verifies {string} message is displayed in Delete Preset dialog on Route Logs page")
  public void verifyMessageInDeletePreset(String expected) {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.deletePresetDialog.waitUntilVisible();
      Assertions.assertThat(routeLogsPage.deletePresetDialog.message.getNormalizedText())
          .as("Delete Preset message").isEqualTo(resolveValue(expected));
    });
  }

  @And("Operator verifies that success toast displayed:")
  public void operatorVerifySuccessToast(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    boolean waitUntilInvisible = Boolean.parseBoolean(
        finalData.getOrDefault("waitUntilInvisible", "false"));
    long start = new Date().getTime();
    ToastInfo toastInfo;
    do {
      toastInfo = routeLogsPage.toastSuccess.stream().filter(toast -> {
        String value = finalData.get("top");
        if (StringUtils.isNotBlank(value)) {
          String actual = toast.toastTop.getNormalizedText();
          if (value.startsWith("^")) {
            if (!actual.matches(value)) {
              return false;
            }
          } else {
            if (!StringUtils.equalsIgnoreCase(value, actual)) {
              return false;
            }
          }
        }
        value = finalData.get("bottom");
        if (StringUtils.isNotBlank(value)) {
          return StringUtils.equalsIgnoreCase(value, toast.toastBottom.getNormalizedText());
        }
        return true;
      }).findFirst().orElse(null);
    } while (toastInfo == null && new Date().getTime() - start < 20000);
    Assertions.assertThat(toastInfo != null).as("Toast " + finalData + " is displayed")
        .isTrue();
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
      Assertions.assertThat(m.matches()).as("Selected Filter Preset value matches to pattern")
          .isTrue();
      Long presetId = Long.valueOf(m.group(1));
      String presetName = m.group(2);
      Assertions.assertThat(presetName).as("Preset Name").isEqualTo(finalExpected);
      put(KEY_ROUTES_FILTERS_PRESET_ID, presetId);
    });
    takesScreenshot();
  }

  @When("Operator selects {string} Filter Preset on Route Logs page")
  public void selectPresetName(String value) {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.waitUntilLoaded(2, 60);
      routeLogsPage.filterPreset.selectValue(resolveValue(value));
      routeLogsPage.waitUntilLoaded(2, 60);
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
          assertions.assertThat(routeLogsPage.routeDateFilter.getValueFrom()).as("Route Date from")
              .isEqualTo(data.get("routeDateFrom"));
        }
      }
      if (finalData.containsKey("routeDateTo")) {
        boolean isDisplayed = routeLogsPage.routeDateFilter.isDisplayedFast();
        if (!isDisplayed) {
          assertions.fail("Route Date filter is not displayed");
        } else {
          assertions.assertThat(routeLogsPage.routeDateFilter.getValueTo()).as("Route Date to")
              .isEqualTo(data.get("routeDateTo"));
        }
      }
      if (finalData.containsKey("hub")) {
        boolean isDisplayed = routeLogsPage.hubFilter.isDisplayedFast();
        if (!isDisplayed) {
          assertions.fail("Hub filter is not displayed");
        } else {
          assertions.assertThat(routeLogsPage.hubFilter.getSelectedValues()).as("Hub items")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("hub")));
        }
      }
      if (finalData.containsKey("driver")) {
        boolean isDisplayed = routeLogsPage.driverFilter.isDisplayedFast();
        if (!isDisplayed) {
          assertions.fail("Driver filter is not displayed");
        } else {
          assertions.assertThat(routeLogsPage.driverFilter.getSelectedValues()).as("Driver items")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("driver")));
        }
      }
      if (finalData.containsKey("zone")) {
        boolean isDisplayed = routeLogsPage.zoneFilter.isDisplayedFast();
        if (!isDisplayed) {
          assertions.fail("Zone filter is not displayed");
        } else {
          assertions.assertThat(routeLogsPage.zoneFilter.getSelectedValues()).as("Zone items")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("zone")));
        }
      }
      if (finalData.containsKey("archivedRoutes")) {
        boolean isDisplayed = routeLogsPage.archivedRoutesFilter.isDisplayedFast();
        if (!isDisplayed) {
          assertions.fail("Archived Routes filter is not displayed");
        } else {
          assertions.assertThat(routeLogsPage.archivedRoutesFilter.getSelectedValue())
              .as("Archived Routes state")
              .isEqualTo(Boolean.parseBoolean(data.get("archivedRoutes")));
        }
      }
    });
    assertions.assertAll();
    takesScreenshot();
  }

  @When("Operator verifies Save button in Save Preset dialog on Route Logs page is disabled")
  public void verifySaveIsDisabled() {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.savePresetDialog.waitUntilVisible();
      Assertions.assertThat(routeLogsPage.savePresetDialog.save.isEnabled())
          .as("Save button is enabled").isFalse();
    });
    takesScreenshot();
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
    routeLogsPage.inFrame(
        () -> Assertions.assertThat(routeLogsPage.savePresetDialog.confirmedIcon.isDisplayed())
            .as("Preset Name checkmark").isTrue());
  }

  @When("Operator verifies help text {string} is displayed in Save Preset dialog on Route Logs page")
  public void verifyHelpTextInSavePreset(String expected) {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.savePresetDialog.waitUntilVisible();
      Assertions.assertThat(routeLogsPage.savePresetDialog.helpText.getNormalizedText())
          .as("Help Text").isEqualTo(resolveValue(expected));
    });
  }

  @When("Operator clicks Update button in Save Preset dialog on Rout Logs page")
  public void clickUpdateInSavePresetDialog() {
    routeLogsPage.inFrame(() -> routeLogsPage.savePresetDialog.update.click());
  }

  @When("^Operator click 'Edit Route' and then click 'Load Waypoints of Selected Route\\(s\\) Only'$")
  public void loadWaypointsOfSelectedRoute() {
    routeLogsPage.inFrame(() -> {
      put(KEY_MAIN_WINDOW_HANDLE, routeLogsPage.getWebDriver().getWindowHandle());
      Long routeId = get(KEY_CREATED_ROUTE_ID);
      routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      routeLogsPage.routesTable.clickActionButton(1, ACTION_EDIT_ROUTE);
      routeLogsPage.editRoutesDialog.waitUntilVisible();
      routeLogsPage.editRoutesDialog.loadWpsOfSelectedRoutes.click();
    });
  }

  @Then("Operator is redirected to this page {value}")
  public void verifyLoadWaypointsOfSelectedRoute(String redirectUrl) {
    routeLogsPage.switchToOtherWindowAndWaitWhileLoading(redirectUrl);
  }

  @When("Operator opens Edit Details dialog for route {value} on Route Logs page")
  public void operatorOpensEditDetails(String routeId) {
    routeLogsPage.inFrame(page -> {
      routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      routeLogsPage.routesTable.clickActionButton(1, ACTION_EDIT_DETAILS);
      routeLogsPage.editDetailsDialog.waitUntilVisible();
    });
  }

  @When("Operator adds tag {string} to created route")
  public void opAddNewTagToRoute(String newTag) {
    Long routeId = get(KEY_CREATED_ROUTE_ID);
    routeLogsPage.inFrame(() -> {
      routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      routeLogsPage.routesTable.clickColumn(1, COLUMN_TAGS);
      routeLogsPage.editTagsDialog.waitUntilVisible();
      routeLogsPage.editTagsDialog.tags.selectValue(newTag);
      routeLogsPage.editTagsDialog.updateTags.click();
      routeLogsPage.waitUntilLoaded(3);
    });
  }

  @When("Operator removes tag {string} from created route")
  public void removeNewTagToRoute(String tag) {
    Long routeId = get(KEY_CREATED_ROUTE_ID);
    routeLogsPage.inFrame(() -> {
      routeLogsPage.routesTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      routeLogsPage.routesTable.clickColumn(1, COLUMN_TAGS);
      routeLogsPage.editTagsDialog.waitUntilVisible();
      routeLogsPage.editTagsDialog.tags.removeSelected(tag);
      routeLogsPage.editTagsDialog.updateTags.click();
      routeLogsPage.waitUntilLoaded(3);
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
    routeLogsPage.inFrame(() -> {
      put(KEY_MAIN_WINDOW_HANDLE, routeLogsPage.getWebDriver().getWindowHandle());
      routeLogsPage.routesTable.filterByColumn(RoutesTable.COLUMN_ROUTE_ID, routeId);
      routeLogsPage.routesTable.clickColumn(1, RoutesTable.COLUMN_ROUTE_ID);
    });
    routeLogsPage.switchToOtherWindowAndWaitWhileLoading("route-manifest/" + routeId);
    pause2s();
    routeLogsPage.waitUntilPageLoaded();
    pause2s();
  }

  @And("Operator filters route by {string} Route ID on Route Logs page")
  public void operatorFilterByRouteId(String routeId) {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.waitUntilLoaded(60);
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
      pause2s();
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
    boolean waitUntilInvisible = Boolean.parseBoolean(
        finalData.getOrDefault("waitUntilInvisible", "false"));
    long start = new Date().getTime();
    ToastInfo toastInfo;
    do {
      toastInfo = routeLogsPage.toastInfo.stream().filter(toast -> {
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
      }).findFirst().orElse(null);
    } while (toastInfo == null && new Date().getTime() - start < 20000);
    Assertions.assertThat(toastInfo).as("Toast " + finalData + " is displayed").isNotNull();
    if (waitUntilInvisible) {
      toastInfo.waitUntilInvisible();
    }
  }

  @Then("Operator verifies that success react notification displayed:")
  @And("Operator verifies that error react notification displayed:")
  public void operatorVerifySuccessReactToast(Map<String, String> data) {
    routeLogsPage.inFrame(() -> {
      Map<String, String> finalData = resolveKeyValues(data);
      boolean waitUntilInvisible = Boolean.parseBoolean(
          finalData.getOrDefault("waitUntilInvisible", "false"));
      long start = new Date().getTime();
      AntNotification toastInfo;
      do {
        try {
          toastInfo = routeLogsPage.noticeNotifications.stream().filter(toast -> {
            String actualTop = toast.message.getNormalizedText();
            toast.moveToElement();
            LOGGER.info("Found notification: " + actualTop);
            String value = finalData.get("top");
            if (StringUtils.isNotBlank(value)) {
              if (value.startsWith("^")) {
                if (!actualTop.matches(value)) {
                  return false;
                }
              } else {
                if (!StringUtils.equalsIgnoreCase(value, actualTop)) {
                  return false;
                }
              }
            }
            value = finalData.get("bottom");
            if (StringUtils.isNotBlank(value)) {
              String actual = toast.description.getNormalizedText();
              toast.moveToElement();
              LOGGER.info("Found description: " + actual);
              if (value.startsWith("^")) {
                return actual.matches(value);
              } else {
                return StringUtils.equalsIgnoreCase(value, actual);
              }
            }
            return true;
          }).findFirst().orElse(null);
        } catch (Exception ex) {
          toastInfo = null;
          LOGGER.warn("Could not read notification", ex);
        }
      } while (toastInfo == null && new Date().getTime() - start < 30000);
      Assertions.assertThat(toastInfo)
          .withFailMessage("Toast is not displayed: " + finalData)
          .isNotNull();
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
        String actualTop = toast.toastTop.getNormalizedText();
        String actualBottom = toast.toastBottom.getNormalizedText();
        String expTop = finalData.get("top");
        if (StringUtils.isNotBlank(expTop)) {
          if (expTop.startsWith("^")) {
            if (!actualTop.matches(expTop)) {
              return false;
            }
          } else {
            if (!StringUtils.equalsIgnoreCase(expTop, actualTop)) {
              return false;
            }
          }
        }

        String expBottom = finalData.get("bottom");
        if (StringUtils.isNotBlank(expBottom)) {
          LOGGER.info("Found description: " + actualBottom);
          if (expBottom.startsWith("^")) {
            return actualBottom.matches(expBottom);
          } else {
            return StringUtils.equalsIgnoreCase(expBottom, actualBottom);
          }
        }
        return true;
      });
    } while (!found && new Date().getTime() - start < 30000);
    Assertions.assertThat(found).as("Toast " + finalData.toString() + " is displayed").isTrue();
    Assertions.assertThat(finalData.toString())
        .withFailMessage("Toast is not displayed: " + finalData)
        .isNotNull();
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
    Assertions.assertThat(found).as("Toast " + finalData + " is displayed").isTrue();
  }

  @Then("^Operator verify the route is started after van inbounding using data below:$")
  public void verifyRouteIsStarted(Map<String, String> mapOfData) throws ParseException {
    long routeId = get(KEY_CREATED_ROUTE_ID);
    Date routeDateFrom = DateUtil.SDF_YYYY_MM_DD.parse(mapOfData.get("routeDateFrom"));
    Date routeDateTo = DateUtil.SDF_YYYY_MM_DD.parse(mapOfData.get("routeDateTo"));
    String hubName = mapOfData.get("hubName");

    routeLogsPage.inFrame(() -> {
      routeLogsPage.waitUntilLoaded(30);
      routeLogsPage.setFilterAndLoadSelection(routeDateFrom, routeDateTo, hubName);
      routeLogsPage.routesTable.filterByColumn(RoutesTable.COLUMN_ROUTE_ID, routeId);
      String actualRouteStatus = routeLogsPage.routesTable.getColumnText(1,
          RoutesTable.COLUMN_STATUS);
      Assertions.assertThat(actualRouteStatus).as("Track is not routed.").isEqualTo("IN_PROGRESS");
    });
  }

  @Then("Operator verify {string} process data in Selection Error dialog on Route Logs page:")
  public void verifySelectionErrors(String process, List<Map<String, String>> data) {
    routeLogsPage.inFrame(() -> {
      routeLogsPage.selectionErrorDialog.waitUntilVisible();
      Assertions.assertThat(routeLogsPage.selectionErrorDialog.process.getText()).as("Process")
          .isEqualTo(resolveValue(process));

      Assertions.assertThat(routeLogsPage.selectionErrorDialog.routeIds.size())
          .as("Number Of routes").isEqualTo(data.size());

      for (int i = 0; i < data.size(); i++) {
        Map<String, String> expected = resolveKeyValues(data.get(i));
        String routeId = expected.get("routeId");
        String reason = expected.get("reason");
        int routeIndex = -1;
        for (int j = 0; j < data.size(); j++) {
          if (StringUtils.equals(routeId,
              routeLogsPage.selectionErrorDialog.routeIds.get(i).getText())) {
            routeIndex = i;
            break;
          }
        }
        Assertions.assertThat(routeIndex >= 0).as(f("Route %s found", routeId)).isTrue();
        Assertions.assertThat(routeLogsPage.selectionErrorDialog.reasons.get(i).getText())
            .as(f("Reason for route %s", routeId)).isEqualTo(reason);
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