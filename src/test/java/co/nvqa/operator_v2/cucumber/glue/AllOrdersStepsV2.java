package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.model.order.Order;
import co.nvqa.common.core.utils.CoreScenarioStorageKeys;
import co.nvqa.common.lighthouse.cucumber.ControlKeyStorage;
import co.nvqa.common.model.DataEntity;
import co.nvqa.common.utils.DateUtil;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.operator_v2.exception.element.NvTestCoreElementNotFoundError;
import co.nvqa.operator_v2.model.OrderStatusReportEntry;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.AllOrdersPageV2;
import co.nvqa.operator_v2.selenium.page.AllOrdersPageV2.AllOrdersAction;
import co.nvqa.operator_v2.selenium.page.MaskedPage;
import co.nvqa.operator_v2.util.CoreDateUtil;
import com.google.common.collect.ImmutableList;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.openqa.selenium.By;
import org.openqa.selenium.ElementNotInteractableException;
import org.openqa.selenium.WebElement;

import static co.nvqa.operator_v2.selenium.page.AllOrdersPage.MANUALLY_COMPLETE_ERROR_CSV_FILENAME;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class AllOrdersStepsV2 extends AbstractSteps {

  private AllOrdersPageV2 allOrdersPageV2;

  public AllOrdersStepsV2() {
  }

  @Override
  public void init() {
    allOrdersPageV2 = new AllOrdersPageV2(getWebDriver());
  }

  @When("Operator switch to Edit Order's window of {string}")
  public void operatorSwitchToEditOrderWindow(String orderId) {
    String mainWindowHandle = allOrdersPageV2.getWebDriver().getWindowHandle();
    allOrdersPageV2.switchToEditOrderWindow(Long.parseLong(resolveValue(orderId)));
    put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
  }

  @When("Operator find order on All Orders page using this criteria below:")
  public void operatorFindOrderOnAllOrdersPageUsingThisCriteriaBelow(
      Map<String, String> dataTableAsMap) {
    dataTableAsMap = resolveKeyValues(dataTableAsMap);
    AllOrdersPageV2.Category category = AllOrdersPageV2.Category.findByValue(
        dataTableAsMap.get("category"));
    AllOrdersPageV2.SearchLogic searchLogic = AllOrdersPageV2.SearchLogic.findByValue(
        dataTableAsMap.get("searchLogic"));
    String searchTerm = dataTableAsMap.get("searchTerm");

    String mainWindowHandle = allOrdersPageV2.getWebDriver().getWindowHandle();
    allOrdersPageV2.specificSearch(category, searchLogic, searchTerm);
    put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
  }

  @When("Operator can't find order on All Orders page using this criteria below:")
  public void operatorCantFindOrderOnAllOrdersPageUsingThisCriteriaBelow(
      Map<String, String> dataTableAsMap) {
    AllOrdersPageV2.Category category = AllOrdersPageV2.Category.findByValue(
        dataTableAsMap.get("category"));
    AllOrdersPageV2.SearchLogic searchLogic = AllOrdersPageV2.SearchLogic.findByValue(
        dataTableAsMap.get("searchLogic"));
    String searchTerm = dataTableAsMap.get("searchTerm");

    if (containsKey(searchTerm)) {
      searchTerm = get(searchTerm);
    }

    allOrdersPageV2.waitUntilPageLoaded();
    allOrdersPageV2.categorySelect.selectValue(category.getValue());
    allOrdersPageV2.searchLogicSelect.selectValue(searchLogic.getValue());
    try {
      allOrdersPageV2.searchTerm.selectValue(searchTerm);
      Assertions.fail("Order " + searchTerm + " was found on All Orders page");
    } catch (ElementNotInteractableException ex) {
      //passed
    }
  }

  @When("Operator find orders by uploading CSV on All Orders V2 page:")
  public void operatorFindOrdersByUploadingCsvOnAllOrderV2Page(List<String> listOfCreatedTrackingId) {
    if (CollectionUtils.isEmpty(listOfCreatedTrackingId)) {
      throw new IllegalArgumentException(
          "List of created Tracking ID should not be null or empty.");
    }
    allOrdersPageV2.inFrame(page -> {
      page.findOrdersWithCsv(resolveValues(listOfCreatedTrackingId));
    });
  }

  @Then("Operator verify all orders in CSV is found on All Orders V2 page with correct info")
  public void operatorVerifyAllOrdersInCsvIsFoundOnAllOrdersPageWithCorrectInfo() {
    List<Order> listOfCreatedOrder = get(CoreScenarioStorageKeys.KEY_LIST_OF_CREATED_ORDERS);
    allOrdersPageV2.inFrame(page -> {
      page.verifyAllOrdersInCsvIsFoundWithCorrectInfo(listOfCreatedOrder);
    });
  }

  @When("Operator Force Success orders with COD collection on All Orders page:")
  public void operatorForceSuccessSingleOrderOnAllOrdersPageWithCodCollection(
      List<Map<String, String>> data) {
    Map<String, Boolean> resolvedData = data.stream().collect(
        Collectors.toMap(row -> resolveValue(row.get("trackingId")).toString(),
            row -> Boolean.valueOf(row.get("collected"))));
    allOrdersPageV2.findOrdersWithCsv(new ArrayList<>(resolvedData.keySet()));
    allOrdersPageV2.clearFilterTableOrderByTrackingId();
    allOrdersPageV2.selectAllShown();
    allOrdersPageV2.actionsMenu.selectValue(AllOrdersAction.MANUALLY_COMPLETE_SELECTED.getName());
    allOrdersPageV2.manuallyCompleteOrderDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPageV2.manuallyCompleteOrderDialog.trackingIds.size())
        .as("Number of orders with COD").isEqualTo(data.size());
    for (int i = 0; i < allOrdersPageV2.manuallyCompleteOrderDialog.trackingIds.size(); i++) {
      String trackingId = allOrdersPageV2.manuallyCompleteOrderDialog.trackingIds.get(i)
          .getNormalizedText();
      Boolean checked = resolvedData.get(trackingId);
      if (checked != null) {
        allOrdersPageV2.manuallyCompleteOrderDialog.codCheckboxes.get(i).setValue(checked);
      }
    }
    allOrdersPageV2.manuallyCompleteOrderDialog.changeReason.setValue("Others (fill in below)");
    allOrdersPageV2.manuallyCompleteOrderDialog.reasonForChange.setValue(
        "Completed by automated test");
    allOrdersPageV2.manuallyCompleteOrderDialog.completeOrder.clickAndWaitUntilDone();
    pause2s();
  }

  @When("Operator Manually Complete orders on All Orders page:")
  public void operatorForceSuccessOrdersOnAllOrdersPage(List<String> data) {
    data = resolveValues(data);
    allOrdersPageV2.findOrdersWithCsv(data);
    allOrdersPageV2.clearFilterTableOrderByTrackingId();
    allOrdersPageV2.selectAllShown();
    allOrdersPageV2.actionsMenu.selectValue(AllOrdersAction.MANUALLY_COMPLETE_SELECTED.getName());
    allOrdersPageV2.manuallyCompleteOrderDialog.waitUntilVisible();
    allOrdersPageV2.manuallyCompleteOrderDialog.changeReason.setValue("Others (fill in below)");
    allOrdersPageV2.manuallyCompleteOrderDialog.reasonForChange.setValue(
        "Completed by automated test");
    allOrdersPageV2.manuallyCompleteOrderDialog.completeOrder.clickAndWaitUntilDone();
    pause2s();
  }

  @When("Operator verifies error messages in dialog on All Orders page:")
  public void operatorVerifyErrorMessagesDialog(List<String> data) {
    data = resolveValues(data);
    List<String> finalData = data;
    allOrdersPageV2.inFrame(page -> {
      Assertions.assertThat(page.errorsDialogAntModal.waitUntilVisible(5))
          .as("Errors dialog is displayed").isTrue();
      List<String> actual = page.errorsDialogAntModal.errorMessage.stream().map(
          element -> StringUtils.normalizeSpace(element.getNormalizedText())
              .replaceAll("^\\d{1,2}\\.", "").trim()).collect(Collectors.toList());
      Assertions.assertThat(actual).as("List of error messages")
          .containsExactlyInAnyOrderElementsOf(finalData);
    });
  }

  @When("Operator close Errors dialog on All Orders page")
  public void operatorCloseErrorsDialog() {
    allOrdersPageV2.inFrame(page -> {
      page.errorsDialogAntModal.waitUntilVisible();
      page.errorsDialogAntModal.close.click();
    });
  }

  @When("Operator Force Success single order on All Orders page:")
  public void operatorForceSuccessSingleOrderOnAllOrdersPage(Map<String, String> data) {
    data = resolveKeyValues(data);
    String trackingId = data.get("trackingId");
    String reason = data.getOrDefault("reason", "Others (fill in below)");
    String reasonDescription = data.getOrDefault("reasonDescription",
        "Force success from automated test");
    allOrdersPageV2.findOrdersWithCsv(ImmutableList.of(trackingId));
    allOrdersPageV2.forceSuccessOrders(reason, reasonDescription);
  }

  @When("Operator Force Success multiple orders on All Orders page:")
  public void operatorForceSuccessOrders(Map<String, String> data) {
    data = resolveKeyValues(data);
    String trackingIdsString = data.get("trackingIds");
    final List<String> trackingIds = Arrays.stream(trackingIdsString.split(","))
        .map(StringUtils::trim).map(tidKey -> (String) resolveValue(tidKey))
        .collect(Collectors.toList());
    String reason = data.getOrDefault("reason", "Others (fill in below)");
    String reasonDescription = data.getOrDefault("reasonDescription",
        "Force success from automated test");
    allOrdersPageV2.findOrdersWithCsv(trackingIds);
    allOrdersPageV2.forceSuccessOrders(reason, reasonDescription);
  }

  @When("Operator cancel multiple orders below on All Orders page:")
  public void operatorCancelMultipleOrdersOnAllOrdersPage(List<String> listOfOrder) {
    List<String> listOfCreatedTrackingId = resolveValues(listOfOrder);
    allOrdersPageV2.cancelSelected(listOfCreatedTrackingId);
  }

  @When("Operator pull out multiple orders below from route on All Orders page:")
  public void operatorPullOutMultipleOrdersFromRouteOnAllOrdersPage(
      List<String> listOfTrackingIds) {
    allOrdersPageV2.pullOutFromRoute(listOfTrackingIds);
  }

  @When("Operator add multiple orders to route on All Orders V2 page:")
  public void operatorAddMultipleOrdersUsingTagFilterToRouteOnAllOrdersPage(Map<String, String> data) {
    final Map<String, String> datatableAsMap = resolveKeyValues(data);
    String trackingIds = datatableAsMap.get("trackingIds");
    List<String> listOfTrackingIds = splitAndNormalize(trackingIds);
    List<String> routeIds = splitAndNormalize(datatableAsMap.get("routeId"));
    allOrdersPageV2.inFrame(page -> {
      if (routeIds.size() == 1) {
        page.addToRoute(listOfTrackingIds, routeIds.get(0), datatableAsMap.get("tag"));
      } else {
        page.fillAddToRouteForm(listOfTrackingIds, routeIds);
        if (listOfTrackingIds.size() > 1) {
          page.addToRouteAntModal.addSelectedToRoutes.click();
        } else {
          page.addToRouteAntModal.addToRoute.click();
        }
      }
    });
  }

  @When("Operator resume this order {string} on All Orders page")
  public void operatorResumeOrderOnAllOrdersPage(String trackingId) {
    String resolveTrackingId = resolveValue(trackingId);
    resumeOrders(Collections.singletonList(resolveTrackingId));
  }

  @When("Operator resume multiple orders on All Orders page below:")
  public void operatorResumeOrdersOnAllOrdersPage(List<String> trackingIds) {
    List<String> resolveTrackingIds = resolveValues(trackingIds);
    resumeOrders(resolveTrackingIds);
  }

  private void resumeOrders(List<String> trackingIds) {
    allOrdersPageV2.findOrdersWithCsv(trackingIds);
    allOrdersPageV2.resumeSelected(trackingIds);
  }

  @When("Operator apply {} action and expect to see {}")
  public void operatorApplyPullFromRouteActionAndExpectToSeeSelectionError(
      String action, String error, List<String> trackingIds) {
    allOrdersPageV2.pullOutFromRouteWithExpectedSelectionError(resolveValues(trackingIds));
  }

  @Then("Operator verify Selection Error dialog for invalid Pull From Order action")
  public void operatorVerifySelectionErrorDialogForInvalidPullFromOrderAction(
      List<String> trackingIds) {
    List<String> expectedFailureReasons = new ArrayList<>(trackingIds.size());
    Collections.fill(expectedFailureReasons, "No route found to unroute");
    allOrdersPageV2.verifySelectionErrorDialog(trackingIds, AllOrdersAction.PULL_FROM_ROUTE,
        expectedFailureReasons);
  }

  @Then("Operator verifies All Orders Page is displayed")
  public void operatorVerifiesAllOrdersPageIsDispalyed() {
    allOrdersPageV2.verifyItsCurrentPage();
  }

  @When("Operator RTS multiple orders on next day on All Orders Page:")
  public void operatorRtsOrdersOnNextDayOnAllOrdersPage(List<String> listOfTrackingIds) {
    List<String> resolveListOfTrackingIds = resolveValues(listOfTrackingIds);
    if (CollectionUtils.isEmpty(resolveListOfTrackingIds)) {
      throw new IllegalArgumentException(
          "List of created Tracking Id should not be null or empty.");
    }
    allOrdersPageV2.rtsMultipleOrderNextDay(resolveListOfTrackingIds);
  }

  @When("Operator Mass-Revert RTS orders on All Orders Page:")
  public void massRevertRts(List<String> listOfTrackingIds) {
    List<String> resolveListOfTrackingIds = resolveValues(listOfTrackingIds);
    if (CollectionUtils.isEmpty(resolveListOfTrackingIds)) {
      throw new IllegalArgumentException(
          "List of created Tracking Id should not be null or empty.");
    }
    allOrdersPageV2.clearFilterTableOrderByTrackingId();
    allOrdersPageV2.selectAllShown();
    allOrdersPageV2.actionsMenu.selectValue("Mass-Revert RTS Selected");
    if (allOrdersPageV2.bulkActionProgress.waitUntilVisible(5)) {
      allOrdersPageV2.bulkActionProgress.waitUntilInvisible(5);
    }
  }

  @When("Operator select 'Set RTS to Selected' action for found orders on All Orders page")
  public void operatorSelectRtsActionForMultipleOrdersOnAllOrdersPage() {
    allOrdersPageV2.clearFilterTableOrderByTrackingId();
    allOrdersPageV2.selectAllShown();
    allOrdersPageV2.actionsMenu.selectValue("Set RTS to Selected");
  }

  @When("Operator verify {value} process in Selection Error dialog on All Orders page")
  public void verifyProcessInSelectionError(String process) {
    allOrdersPageV2.selectionErrorDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPageV2.selectionErrorDialog.process.getText()).as("Process")
        .isEqualTo(process);
  }

  @When("Operator clicks 'Download the failed updates' in Update Errors dialog on All Orders page")
  public void clickDownloadTheInvalidUpdates() {
    allOrdersPageV2.errorsDialogAntModal.waitUntilVisible();
    // TODO: need to update as download button is currently not visible
    // allOrdersPageV2.errorsDialogAntModal.downloadFailedUpdates.click();
  }

  @When("Operator verifies manually complete errors CSV file on All Orders page:")
  public void verifyManuallyCompleteErrorCsv(List<String> trackingIds) {
    allOrdersPageV2.verifyFileDownloadedSuccessfully(MANUALLY_COMPLETE_ERROR_CSV_FILENAME);
    List<String> actual = allOrdersPageV2.readDownloadedFile(MANUALLY_COMPLETE_ERROR_CSV_FILENAME);
    actual.remove(0);
    Assertions.assertThat(actual).as("List of invalid tracking ids")
        .containsExactlyInAnyOrderElementsOf(resolveValues(trackingIds));
  }

  @When("Operator verify orders info in Selection Error dialog on All Orders page:")
  public void verifyOrdersInfoInSelectionError(List<Map<String, String>> data) {
    data = resolveListOfMaps(data);
    List<Map<String, String>> actual = new ArrayList<>();
    allOrdersPageV2.selectionErrorDialog.waitUntilVisible();
    int count = allOrdersPageV2.selectionErrorDialog.trackingIds.size();
    for (int i = 0; i < count; i++) {
      Map<String, String> row = new HashMap<>();
      row.put("trackingId", allOrdersPageV2.selectionErrorDialog.trackingIds.get(i).getText());
      row.put("reason", allOrdersPageV2.selectionErrorDialog.reasons.get(i).getText());
      actual.add(row);
    }
    Assertions.assertThat(actual).as("List of tracing ids and reasons")
        .containsExactlyInAnyOrderElementsOf(data);
  }

  @When("Operator clicks Continue button in Selection Error dialog on All Orders page")
  public void clickContinueButtonInSelectionErrorDialog() {
    allOrdersPageV2.selectionErrorDialog.waitUntilVisible();
    allOrdersPageV2.selectionErrorDialog.continueBtn.click();
  }

  @When("Operator selects filters on All Orders page:")
  public void operatorSelectsFilters(Map<String, String> data) {
    data = resolveKeyValues(data);
    allOrdersPageV2.waitUntilPageLoaded();
    allOrdersPageV2.clearAllSelections();

    if (data.containsKey("status")) {
      allOrdersPageV2.addFilterV2("Status");
      allOrdersPageV2.statusFilterBox.clearAll.click();
      allOrdersPageV2.statusFilter.moveAndClick();
      allOrdersPageV2.statusFilter.selectValue(data.get("status"));
    }

    if (data.containsKey("granularStatus")) {
      allOrdersPageV2.addFilterV2("Granular");
      allOrdersPageV2.granularStatusBox.clearAll.click();
      allOrdersPageV2.granularStatusFilter.moveAndClick();
      allOrdersPageV2.granularStatusFilter.selectValue(data.get("granularStatus"));
    }

    if (data.containsKey("creationTimeTo")) {
      if (!allOrdersPageV2.creationTimeFilter.isDisplayedFast()) {
        allOrdersPageV2.addFilter("Creation Time");
      }
      allOrdersPageV2.creationTimeFilter.selectToDate(data.get("creationTimeTo"));
      allOrdersPageV2.creationTimeFilter.selectToHours("12");
      allOrdersPageV2.creationTimeFilter.selectToMinutes("00");
    } else {
      if (allOrdersPageV2.creationTimeFilter.isDisplayedFast()) {
        allOrdersPageV2.creationTimeFilter.selectToDate(DateUtil.getTodayDate_YYYY_MM_DD());
        allOrdersPageV2.creationTimeFilter.selectToHours("12");
        allOrdersPageV2.creationTimeFilter.selectToMinutes("00");
      }
    }

    if (data.containsKey("creationTimeFrom")) {
      if (!allOrdersPageV2.creationTimeFilter.isDisplayedFast()) {
        allOrdersPageV2.addFilter("Creation Time");
      }
      allOrdersPageV2.creationTimeFilter.selectFromDate(data.get("creationTimeFrom"));
      allOrdersPageV2.creationTimeFilter.selectFromHours("12");
      allOrdersPageV2.creationTimeFilter.selectFromMinutes("00");
    } else {
      if (allOrdersPageV2.creationTimeFilter.isDisplayedFast()) {
        allOrdersPageV2.creationTimeFilter.selectFromDate(DateUtil.getTodayDate_YYYY_MM_DD());
        allOrdersPageV2.creationTimeFilter.selectFromHours("12");
        allOrdersPageV2.creationTimeFilter.selectFromMinutes("00");
      }
    }

    if (data.containsKey("shipperName")) {
      allOrdersPageV2.addFilter("Shipper");
      allOrdersPageV2.shipperFilter.moveAndClick();
      allOrdersPageV2.shipperFilter.selectFilter(data.get("shipperName"));
    }

    if (data.containsKey("masterShipperName")) {
      allOrdersPageV2.addFilter("Master Shipper");
      allOrdersPageV2.masterShipperFilter.selectValue(data.get("masterShipperName"));
    }
  }

  @When("Operator updates filters on All Orders page:")
  public void operatorUpdatesFilters(Map<String, String> data) {
    data = resolveKeyValues(data);

    allOrdersPageV2.waitUntilPageLoaded();

    if (data.containsKey("status")) {
      if (!allOrdersPageV2.statusFilter.isDisplayedFast()) {
        allOrdersPageV2.addFilterV2("Status");
      }
      allOrdersPageV2.statusFilterBox.clearAll.click();
      allOrdersPageV2.statusFilter.moveAndClick();
      allOrdersPageV2.statusFilterBox.selectFilter(splitAndNormalize(data.get("status")));
    }

    if (data.containsKey("granularStatus")) {
      if (!allOrdersPageV2.granularStatusFilter.isDisplayedFast()) {
        allOrdersPageV2.addFilterV2("Granular");
      }
      allOrdersPageV2.granularStatusBox.clearAll.click();
      allOrdersPageV2.granularStatusFilter.moveAndClick();
      allOrdersPageV2.granularStatusBox.selectFilter(
          splitAndNormalize(data.get("granularStatus")));
    }

    if (data.containsKey("creationTimeFrom")) {
      if (!allOrdersPageV2.creationTimeFilter.isDisplayedFast()) {
        allOrdersPageV2.addFilter("Creation Time");
      }
      allOrdersPageV2.creationTimeFilter.selectFromDate(data.get("creationTimeFrom"));
      allOrdersPageV2.creationTimeFilter.selectFromHours("04");
      allOrdersPageV2.creationTimeFilter.selectFromMinutes("00");
    }

    if (data.containsKey("creationTimeTo")) {
      if (!allOrdersPageV2.creationTimeFilter.isDisplayedFast()) {
        allOrdersPageV2.addFilter("Creation Time");
      }
      allOrdersPageV2.creationTimeFilter.selectToDate(data.get("creationTimeTo"));
      allOrdersPageV2.creationTimeFilter.selectToHours("04");
      allOrdersPageV2.creationTimeFilter.selectToMinutes("00");
    }

    if (data.containsKey("shipperName")) {
      if (!allOrdersPageV2.shipperFilter.isDisplayedFast()) {
        allOrdersPageV2.addFilter("Shipper");
      }
      allOrdersPageV2.shipperFilter.moveAndClick();
      allOrdersPageV2.shipperFilter.clearAll();
      allOrdersPageV2.shipperFilter.selectFilter(data.get("shipperName"));
    }

    if (data.containsKey("masterShipperName")) {
      if (!allOrdersPageV2.masterShipperFilter.isDisplayedFast()) {
        allOrdersPageV2.addFilter("Master Shipper");
      }
      allOrdersPageV2.masterShipperFilter.selectValue(data.get("masterShipperName"));
    }
  }

  @When("Operator verifies selected filters on All Orders page:")
  public void operatorVerifiesSelectedFilters(Map<String, String> data) {
    data = resolveKeyValues(data);
    SoftAssertions assertions = new SoftAssertions();
    pause2s();

    if (data.containsKey("status")) {
      boolean isDisplayed = allOrdersPageV2.statusFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Status filter is not displayed");
      } else {
        assertions.assertThat(allOrdersPageV2.statusFilterBox.getSelectedValues()).as("Status items")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("status")));
      }
    }

    if (data.containsKey("granularStatus")) {
      boolean isDisplayed = allOrdersPageV2.granularStatusFilter.isDisplayed();
      if (!isDisplayed) {
        assertions.fail("Granular Status filter is not displayed");
      } else {
        assertions.assertThat(allOrdersPageV2.granularStatusBox.getSelectedValues())
            .as("Granular Status items")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("granularStatus")));
      }
    }

    if (data.containsKey("creationTimeFrom")) {
      boolean isDisplayed = allOrdersPageV2.creationTimeFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Creation Time filter is not displayed");
      } else {
        assertions.assertThat(allOrdersPageV2.creationTimeFilter.fromDate.getValue())
            .as("Creation Time From Date").isEqualTo(data.get("creationTimeFrom"));
      }
    }

    if (data.containsKey("creationTimeTo")) {
      boolean isDisplayed = allOrdersPageV2.creationTimeFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Creation Time filter is not displayed");
      } else {
        assertions.assertThat(allOrdersPageV2.creationTimeFilter.toDate.getValue())
            .as("Creation Time To Date").isEqualTo(data.get("creationTimeTo"));
      }
    }

    if (data.containsKey("shipperName")) {
      boolean isDisplayed = allOrdersPageV2.shipperFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Shipper filter is not displayed");
      } else {
        assertions.assertThat(allOrdersPageV2.shipperFilter.getSelectedValues()).as("Shipper items")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("shipperName")));
      }
    }

    if (data.containsKey("masterShipperName")) {
      boolean isDisplayed = allOrdersPageV2.masterShipperFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Master Shipper filter is not displayed");
      } else {
        assertions.assertThat(allOrdersPageV2.masterShipperFilterBox.getSelectedValues())
            .as("Master Shipper items")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("masterShipperName")));
      }
    }
    assertions.assertAll();
  }

  @When("Operator selects {string} preset action on All Orders page")
  public void selectPresetAction(String action) {
    allOrdersPageV2.waitUntilPageLoaded();
    allOrdersPageV2.presetActions.selectOption(resolveValue(action));
  }

  @When("Operator verifies Save Preset dialog on All Orders page contains filters:")
  public void verifySelectedFiltersForPreset(List<String> expected) {
    allOrdersPageV2.savePresetDialog.waitUntilVisible();
    List<String> actual = allOrdersPageV2.savePresetDialog.selectedFilters.stream()
        .map(PageElement::getNormalizedText).collect(Collectors.toList());
    Assertions.assertThat(actual).as("List of selected filters")
        .containsExactlyInAnyOrderElementsOf(expected);
  }

  @When("Operator verifies Preset Name field in Save Preset dialog on All Orders page is required")
  public void verifyPresetNameIsRequired() {
    allOrdersPageV2.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPageV2.savePresetDialog.presetName.getAttribute("ng-required"))
        .as("Preset Name field ng-required attribute").isEqualTo("required");
  }

  @When("Operator verifies help text {string} is displayed in Save Preset dialog on All Orders page")
  public void verifyHelpTextInSavePreset(String expected) {
    allOrdersPageV2.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPageV2.savePresetDialog.helpText.getNormalizedText())
        .as("Help Text").isEqualTo(resolveValue(expected));
  }

  @When("Operator verifies Cancel button in Save Preset dialog on All Orders page is enabled")
  public void verifyCancelIsEnabled() {
    allOrdersPageV2.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPageV2.savePresetDialog.cancel.isEnabled())
        .as("Cancel button is enabled").isTrue();
  }

  @When("Operator verifies Save button in Save Preset dialog on All Orders page is enabled")
  public void verifySaveIsEnabled() {
    allOrdersPageV2.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPageV2.savePresetDialog.save.isEnabled())
        .as("Save button is enabled").isTrue();
  }

  @When("Operator clicks Save button in Save Preset dialog on All Orders page")
  public void clickSaveInSavePresetDialog() {
    allOrdersPageV2.savePresetDialog.save.click();
  }

  @When("Operator clicks Update button in Save Preset dialog on All Orders page")
  public void clickUpdateInSavePresetDialog() {
    allOrdersPageV2.savePresetDialog.update.click();
  }

  @When("Operator verifies Save button in Save Preset dialog on All Orders page is disabled")
  public void verifySaveIsDisabled() {
    allOrdersPageV2.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPageV2.savePresetDialog.save.isEnabled())
        .as("Save button is enabled").isFalse();
  }

  @When("Operator verifies Cancel button in Delete Preset dialog on All Orders page is enabled")
  public void verifyCancelIsEnabledInDeletePreset() {
    allOrdersPageV2.deletePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPageV2.deletePresetDialog.cancel.isEnabled())
        .as("Cancel button is enabled").isTrue();
  }

  @When("Operator generates order statuses report on All Orders page:")
  public void generateOrderStatusesReport(List<String> trackingIds) {
    allOrdersPageV2.orderStatusesReport.click();
    allOrdersPageV2.orderStatusesReportDialog.waitUntilVisible();
    String csvContents = resolveValues(trackingIds).stream()
        .collect(Collectors.joining(System.lineSeparator(), "", System.lineSeparator()));
    File csvFile = allOrdersPageV2.createFile(
        String.format("order-statuses-find_%s.csv", allOrdersPageV2.generateDateUniqueString()),
        csvContents);
    allOrdersPageV2.orderStatusesReportDialog.file.setValue(csvFile);
    allOrdersPageV2.orderStatusesReportDialog.generate.click();
  }

  @When("Operator downloads order statuses report sample CSV on All Orders page")
  public void downloadOrderStatusesReportSampleCsv() {
    allOrdersPageV2.orderStatusesReport.click();
    allOrdersPageV2.orderStatusesReportDialog.waitUntilVisible();
    allOrdersPageV2.orderStatusesReportDialog.downloadSample.click();
  }

  @Then("Operator verify order statuses report sample CSV file downloaded successfully")
  public void operatorVerifySampleCsvFileDownloadedSuccessfully() {
    allOrdersPageV2.verifyFileDownloadedSuccessfully("order-statuses-find.csv",
        "NVSGNINJA000000001\n"
            + "NVSGNINJA000000002\n"
            + "NVSGNINJA000000003\n");
  }

  @When("Operator selects {string} preset in Delete Preset dialog on All Orders page")
  public void selectPresetInDeletePresets(String value) {
    String resolvedValue = resolveValue(value);
    doWithRetry(() -> {
      try {
        allOrdersPageV2.deletePresetDialog.waitUntilVisible();
        allOrdersPageV2.deletePresetDialog.preset.searchAndSelectValue(resolvedValue);
      } catch (Exception e) {
        allOrdersPageV2.refreshPage();
        allOrdersPageV2.waitUntilPageLoaded();
        allOrdersPageV2.presetActions.selectOption("Delete Preset");
        throw new NvTestCoreElementNotFoundError("Preset Filter " + resolvedValue
            + " is not found in Delete Preset dialog on All Orders page", e);
      }
    }, "Operator selects " + resolvedValue + " preset in Delete Preset dialog on All Orders page");

  }

  @When("Operator clicks Delete button in Delete Preset dialog on All Orders page")
  public void clickDeleteInDeletePresetDialog() {
    allOrdersPageV2.deletePresetDialog.delete.click();
  }

  @When("Operator verifies Delete button in Delete Preset dialog on All Orders page is disabled")
  public void verifyDeleteIsDisabled() {
    allOrdersPageV2.deletePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPageV2.deletePresetDialog.delete.isEnabled())
        .as("Delete button is enabled").isFalse();
  }

  @When("Operator verifies {string} message is displayed in Delete Preset dialog on All Orders page")
  public void verifyMessageInDeletePreset(String expected) {
    allOrdersPageV2.deletePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPageV2.deletePresetDialog.message.getNormalizedText())
        .as("Delete Preset message").isEqualTo(resolveValue(expected));
  }

  @When("Operator enters {string} Preset Name in Save Preset dialog on All Orders page")
  public void enterPresetNameIsRequired(String presetName) {
    allOrdersPageV2.savePresetDialog.waitUntilVisible();
    presetName = resolveValue(presetName);
    allOrdersPageV2.savePresetDialog.presetName.setValue(presetName);
    put(ControlKeyStorage.KEY_ALL_ORDERS_FILTERS_PRESET, presetName);
  }

  @When("Operator verifies Preset Name field in Save Preset dialog on All Orders page has green checkmark on it")
  public void verifyPresetNameIsValidated() {
    Assertions.assertThat(allOrdersPageV2.savePresetDialog.confirmedIcon.isDisplayed())
        .as("Preset Name checkmark").isTrue();
  }

  @When("Operator verifies selected Filter Preset name is {string} on All Orders page")
  public void verifySelectedPresetName(String expected) {
    expected = resolveValue(expected);
    String actual = StringUtils.trim(allOrdersPageV2.filterPreset.getValue());
    Pattern p = Pattern.compile("(\\d+)\\s-\\s(.+)");
    Matcher m = p.matcher(actual);
    Assertions.assertThat(m.matches()).as("Selected Filter Preset value matches to pattern")
        .isTrue();
    Long presetId = Long.valueOf(m.group(1));
    String presetName = m.group(2);
    Assertions.assertThat(presetName).as("Preset Name").isEqualTo(expected);
    put(KEY_ALL_ORDERS_FILTERS_PRESET_ID, presetId);
  }

  @When("Operator selects {value} Filter Preset on All Orders page")
  public void selectPresetName(String value) {
    doWithRetry(() -> {
      try {
        allOrdersPageV2.waitUntilPageLoaded();
        allOrdersPageV2.selectFilterPreset(value);
      } catch (Exception e) {
        allOrdersPageV2.refreshPage();
        throw new NvTestCoreElementNotFoundError(
            "Filter Preset " + value + " is not found on All Orders page", e);
      }
    }, "Operator selects " + value + " Filter Preset on All Orders page");
  }

  @Then("Operator verify that revert_rts_tracking_ids CSV has correct details:")
  public void verifyRevertRtsFile(List<String> trackingIds) {
    String text = "Tracking ID\n" + StringUtils.join(resolveValues(trackingIds), "\n");
    String fileName = "revert_rts_tracking_ids.csv";
    String downloadedFile = allOrdersPageV2.getLatestDownloadedFilename(fileName);
    allOrdersPageV2.verifyFileDownloadedSuccessfully(downloadedFile, text);
  }

  @When("Operator find multiple orders below by uploading CSV on All Orders V2 page")
  public void operatorFindMultipleOrdersByUploadingCsvOnAllOrderPage(List<String> listOfOrder) {
    List<String> listOfCreatedTrackingId = resolveValues(listOfOrder);
    operatorFindOrdersByUploadingCsvOnAllOrderV2Page(listOfCreatedTrackingId);
  }

  @Then("Operator unmask All Orders V2 page")
  public void unmaskPage() {
    allOrdersPageV2.inFrame(page -> {
      WebElement scrollToElement = getWebDriver().findElement(By.xpath("//div[@role='table']//div[@data-datakey='granular_status']"));
      page.scrollIntoView(scrollToElement);
      while (page.isElementExist(MaskedPage.MASKING_XPATH)) {
        pause1s();
        WebElement element = getWebDriver().findElement(By.xpath(MaskedPage.MASKING_XPATH));
        element.click();
      }
    });
  }

  @When("Operator verifies order statuses report file contains following data:")
  public void operatorVerifyOrderStatusesReportFile(List<Map<String, String>> data) {
    String fileName = allOrdersPageV2.getLatestDownloadedFilename("results.csv");
    allOrdersPageV2.verifyFileDownloadedSuccessfully(fileName);
    String pathName = StandardTestConstants.TEMP_DIR + fileName;
    List<OrderStatusReportEntry> actualData = DataEntity
        .fromCsvFile(OrderStatusReportEntry.class, pathName, true);
    List<OrderStatusReportEntry> expectedData = data.stream()
        .map(entry -> new OrderStatusReportEntry(resolveKeyValues(entry)))
        .peek(o -> {
          final List<Order> createdOrders = get(CoreScenarioStorageKeys.KEY_LIST_OF_CREATED_ORDERS);
          final Optional<Order> orderOpt = createdOrders.stream()
              .filter(co -> co.getTrackingId().equalsIgnoreCase(o.getTrackingId()))
              .findFirst();
          if (orderOpt.isPresent()) {
            final String rawDeliveryDate = orderOpt.get().getTransactions().get(1).getEndTime();
            final String formattedDeliveryDate = LocalDate.parse(rawDeliveryDate,
                CoreDateUtil.ISO8601_LITE_FORMATTER).toString();
            o.setEstimatedDeliveryDate(formattedDeliveryDate);
          }
        })
        .collect(Collectors.toList());
    Assertions.assertThat(actualData).as("Number of records in order status report")
        .hasSameSizeAs(data);
    for (int i = 0; i < expectedData.size(); i++) {
      expectedData.get(i).compareWithActual(actualData.get(i));
    }
  }
}