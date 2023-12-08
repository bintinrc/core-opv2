package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.model.order.Order;
import co.nvqa.common.core.utils.CoreScenarioStorageKeys;
import co.nvqa.common.model.DataEntity;
import co.nvqa.common.utils.DateUtil;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.operator_v2.exception.element.NvTestCoreElementNotFoundError;
import co.nvqa.operator_v2.model.AddToRouteData;
import co.nvqa.operator_v2.model.OrderStatusReportEntry;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.AllOrdersPage;
import co.nvqa.operator_v2.selenium.page.AllOrdersPage.AllOrdersAction;
import co.nvqa.operator_v2.selenium.page.AllOrdersPage.OrdersTable.OrderInfo;
import co.nvqa.operator_v2.selenium.page.MaskedPage;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
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
import java.util.Objects;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.openqa.selenium.By;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebElement;

import static co.nvqa.operator_v2.selenium.page.AllOrdersPage.MANUALLY_COMPLETE_ERROR_CSV_FILENAME;
import static co.nvqa.operator_v2.selenium.page.AllOrdersPage.SELECTION_ERROR_CSV_FILENAME;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class AllOrdersSteps extends AbstractSteps {

  private AllOrdersPage allOrdersPage;

  public AllOrdersSteps() {
  }

  @Override
  public void init() {
    allOrdersPage = new AllOrdersPage(getWebDriver());
  }

  @When("Operator switch to Edit Order's window of {string}")
  public void operatorSwitchToEditOrderWindow(String orderId) {
    String mainWindowHandle = allOrdersPage.getWebDriver().getWindowHandle();
    allOrdersPage.switchToEditOrderWindow(Long.parseLong(resolveValue(orderId)));
    put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
  }

  @When("^Operator download sample CSV file for \"Find Orders with CSV\" on All Orders page$")
  public void operatorDownloadSampleCsvFileForFindOrdersWithCsvOnAllOrdersPage() {
    allOrdersPage.downloadSampleCsvFile();
  }

  @Then("^Operator verify sample CSV file for \"Find Orders with CSV\" on All Orders page is downloaded successfully$")
  public void operatorVerifySampleCsvFileForFindOrdersWithCsvOnAllOrdersPageIsDownloadedSuccessfully() {
    allOrdersPage.verifySampleCsvFileDownloadedSuccessfully();
  }

  @When("^Operator find order on All Orders page using this criteria below:$")
  public void operatorFindOrderOnAllOrdersPageUsingThisCriteriaBelow(
      Map<String, String> dataTableAsMap) {
    dataTableAsMap = resolveKeyValues(dataTableAsMap);
    AllOrdersPage.Category category = AllOrdersPage.Category.findByValue(
        dataTableAsMap.get("category"));
    AllOrdersPage.SearchLogic searchLogic = AllOrdersPage.SearchLogic.findByValue(
        dataTableAsMap.get("searchLogic"));
    String searchTerm = dataTableAsMap.get("searchTerm");
    String searchBy = searchTerm;

        /*
          Replace searchTerm value to value on ScenarioStorage.
         */
    if (containsKey(searchTerm)) {
      searchTerm = get(searchTerm);
    }

    String mainWindowHandle = allOrdersPage.getWebDriver().getWindowHandle();
    if (StringUtils.equalsIgnoreCase(searchBy, "KEY_STAMP_ID")) {
      allOrdersPage.specificSearch(category, searchLogic, searchTerm,
          ((Order) get(KEY_CREATED_ORDER)).getTrackingId());
    } else {
      allOrdersPage.specificSearch(category, searchLogic, searchTerm);
    }
    put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
  }

  @When("^Operator can't find order on All Orders page using this criteria below:$")
  public void operatorCantFindOrderOnAllOrdersPageUsingThisCriteriaBelow(
      Map<String, String> dataTableAsMap) {
    AllOrdersPage.Category category = AllOrdersPage.Category.findByValue(
        dataTableAsMap.get("category"));
    AllOrdersPage.SearchLogic searchLogic = AllOrdersPage.SearchLogic.findByValue(
        dataTableAsMap.get("searchLogic"));
    String searchTerm = dataTableAsMap.get("searchTerm");

    if (containsKey(searchTerm)) {
      searchTerm = get(searchTerm);
    }

    allOrdersPage.waitUntilPageLoaded();
    allOrdersPage.categorySelect.selectValue(category.getValue());
    allOrdersPage.searchLogicSelect.selectValue(searchLogic.getValue());
    try {
      allOrdersPage.searchTerm.selectValue(searchTerm);
      Assertions.fail("Order " + searchTerm + " was found on All Orders page");
    } catch (NoSuchElementException ex) {
      //passed
    }
  }

  @When("^Operator filter the result table by Tracking ID on All Orders page and verify order info is correct$")
  public void operatorFilterTheResultTableByTrackingIdOnAllOrdersPageAndVerifyOrderInfoIsCorrect() {
    Order order = get(KEY_CREATED_ORDER);
    allOrdersPage.verifyOrderInfoOnTableOrderIsCorrect(order);
  }

  @Then("^Operator verify the new pending pickup order is found on All Orders page with correct info$")
  public void operatorVerifyTheNewPendingPickupOrderIsFoundOnAllOrdersPageWithCorrectInfo() {
    Order order = get(KEY_CREATED_ORDER);
    allOrdersPage.verifyOrderInfoIsCorrect(order);
  }

  @When("^Operator find multiple orders by uploading CSV on All Orders page$")
  public void operatorFindMultipleOrdersByUploadingCsvOnAllOrderPage() {
    List<String> listOfCreatedTrackingId = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
    operatorFindOrdersByUploadingCsvOnAllOrderPage(listOfCreatedTrackingId);

    //handle masking
    List<WebElement> elements = getWebDriver().findElements(By.xpath(MaskedPage.MASKING_XPATH));
    allOrdersPage.operatorClickMaskingText(elements);
  }

  @When("^Operator find orders by uploading CSV on All Orders page:$")
  public void operatorFindOrdersByUploadingCsvOnAllOrderPage(List<String> listOfCreatedTrackingId) {
    if (CollectionUtils.isEmpty(listOfCreatedTrackingId)) {
      throw new IllegalArgumentException(
          "List of created Tracking ID should not be null or empty.");
    }
    allOrdersPage.findOrdersWithCsv(resolveValues(listOfCreatedTrackingId));
  }

  @When("^Operator find order by uploading CSV on All Orders page$")
  public void operatorFindOrderByUploadingCsvOnAllOrderPage() {
    String createdTrackingId = get(KEY_CREATED_ORDER_TRACKING_ID);

    if (StringUtils.isBlank(createdTrackingId)) {
      throw new IllegalArgumentException("Created Order Tracking ID should not be null or empty.");
    }

    allOrdersPage.findOrdersWithCsv(Collections.singletonList(createdTrackingId));
  }

  @Then("Operator verify all orders in CSV is found on All Orders page with correct info")
  public void operatorVerifyAllOrdersInCsvIsFoundOnAllOrdersPageWithCorrectInfo() {
    List<Order> listOfCreatedOrder =
        containsKey(KEY_LIST_OF_ORDER_DETAILS) ? get(KEY_LIST_OF_ORDER_DETAILS)
            : get(CoreScenarioStorageKeys.KEY_LIST_OF_CREATED_ORDERS);
    allOrdersPage.verifyAllOrdersInCsvIsFoundWithCorrectInfo(listOfCreatedOrder);
  }

  @When("^Operator uploads CSV that contains invalid Tracking ID on All Orders page$")
  public void operatorUploadsCsvThatContainsInvalidTrackingIdOnAllOrdersPage() {
    List<String> listOfInvalidTrackingId = new ArrayList<>();
    listOfInvalidTrackingId.add("DUMMY" + StandardTestUtils.generateDateUniqueString() + 'N');
    listOfInvalidTrackingId.add("DUMMY" + StandardTestUtils.generateDateUniqueString() + 'C');
    listOfInvalidTrackingId.add("DUMMY" + StandardTestUtils.generateDateUniqueString() + 'R');

    allOrdersPage.findOrdersWithCsv(listOfInvalidTrackingId);
    put("listOfInvalidTrackingId", listOfInvalidTrackingId);
  }

  @Then("^Operator verify that the page failed to find the orders inside the CSV that contains invalid Tracking IDS on All Orders page$")
  public void operatorVerifyThatThePageFailedToFindTheOrdersInsideTheCsvThatContainsInvalidTrackingIdsOnAllOrdersPage() {
    List<String> listOfInvalidTrackingId = get("listOfInvalidTrackingId");
    allOrdersPage.verifyInvalidTrackingIdsIsFailedToFind(listOfInvalidTrackingId);
  }


  @When("^Operator Force Success orders with COD collection on All Orders page:$")
  public void operatorForceSuccessSingleOrderOnAllOrdersPageWithCodCollection(
      List<Map<String, String>> data) {
    Map<String, Boolean> resolvedData = data.stream().collect(
        Collectors.toMap(row -> resolveValue(row.get("trackingId")).toString(),
            row -> Boolean.valueOf(row.get("collected"))));
    allOrdersPage.findOrdersWithCsv(new ArrayList<>(resolvedData.keySet()));
    allOrdersPage.clearFilterTableOrderByTrackingId();
    allOrdersPage.selectAllShown();
    allOrdersPage.actionsMenu.selectOption(AllOrdersAction.MANUALLY_COMPLETE_SELECTED.getName());
    allOrdersPage.manuallyCompleteOrderDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPage.manuallyCompleteOrderDialog.trackingIds.size())
        .as("Number of orders with COD").isEqualTo(data.size());
    for (int i = 0; i < allOrdersPage.manuallyCompleteOrderDialog.trackingIds.size(); i++) {
      String trackingId = allOrdersPage.manuallyCompleteOrderDialog.trackingIds.get(i)
          .getNormalizedText();
      Boolean checked = resolvedData.get(trackingId);
      if (checked != null) {
        allOrdersPage.manuallyCompleteOrderDialog.codCheckboxes.get(i).setValue(checked);
      }
    }
    allOrdersPage.manuallyCompleteOrderDialog.changeReason.setValue("Others (fill in below)");
    allOrdersPage.manuallyCompleteOrderDialog.reasonForChange.setValue(
        "Completed by automated test");
    allOrdersPage.manuallyCompleteOrderDialog.completeOrder.clickAndWaitUntilDone();
    pause2s();
  }

  @When("Operator Manually Complete orders on All Orders page:")
  public void operatorForceSuccessOrdersOnAllOrdersPage(List<String> data) {
    data = resolveValues(data);
    allOrdersPage.findOrdersWithCsv(data);
    allOrdersPage.clearFilterTableOrderByTrackingId();
    allOrdersPage.selectAllShown();
    allOrdersPage.actionsMenu.selectOption(AllOrdersAction.MANUALLY_COMPLETE_SELECTED.getName());
    allOrdersPage.manuallyCompleteOrderDialog.waitUntilVisible();
    allOrdersPage.manuallyCompleteOrderDialog.changeReason.setValue("Others (fill in below)");
    allOrdersPage.manuallyCompleteOrderDialog.reasonForChange.setValue(
        "Completed by automated test");
    allOrdersPage.manuallyCompleteOrderDialog.completeOrder.clickAndWaitUntilDone();
    pause2s();
  }

  @When("^Operator verifies error messages in dialog on All Orders page:$")
  public void operatorVerifyErrorMessagesDialog(List<String> data) {
    data = resolveValues(data);
    Assertions.assertThat(allOrdersPage.errorsDialog.waitUntilVisible(5))
        .as("Errors dialog is displayed").isTrue();
    List<String> actual = allOrdersPage.errorsDialog.errorMessage.stream().map(
        element -> StringUtils.normalizeSpace(element.getNormalizedText())
            .replaceAll("^\\d{1,2}\\.", "")).collect(Collectors.toList());
    Assertions.assertThat(actual).as("List of error messages")
        .containsExactlyInAnyOrderElementsOf(data);
  }

  @When("^Operator close Errors dialog on All Orders page$")
  public void operatorCloseErrorsDialog() {
    allOrdersPage.errorsDialog.waitUntilVisible();
    allOrdersPage.errorsDialog.close.click();
  }

  @When("Operator Force Success single order on All Orders page:")
  public void operatorForceSuccessSingleOrderOnAllOrdersPage(Map<String, String> data) {
    data = resolveKeyValues(data);
    String trackingId = data.get("trackingId");
    String reason = data.getOrDefault("reason", "Others (fill in below)");
    String reasonDescription = data.getOrDefault("reasonDescription",
        "Force success from automated test");
    allOrdersPage.findOrdersWithCsv(ImmutableList.of(trackingId));
    allOrdersPage.forceSuccessOrders(reason, reasonDescription);
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
    allOrdersPage.findOrdersWithCsv(trackingIds);
    allOrdersPage.forceSuccessOrders(reason, reasonDescription);
  }

  @Then("^Operator verify the order is Force Successed successfully$")
  public void operatorVerifyTheOrderIsForceSucceedSuccessfully() {
    Order order = get(KEY_CREATED_ORDER);
    allOrdersPage.verifyOrderIsForceSuccessedSuccessfully(order);
  }

  @When("^Operator RTS single order on next day on All Orders page$")
  public void operatorRtsSingleOrderOnNextDayOnAllOrdersPage() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    allOrdersPage.rtsSingleOrderNextDay(trackingId);
  }

  @When("Operator cancel multiple orders below on All Orders page:")
  public void operatorCancelMultipleOrdersOnAllOrdersPage(List<String> listOfOrder) {
    List<String> listOfCreatedTrackingId = resolveValues(listOfOrder);
    allOrdersPage.cancelSelected(listOfCreatedTrackingId);
  }

  @When("^Operator cancel order on All Orders page$")
  public void operatorCancelOrderOnAllOrdersPage() {
    String trackingID = get(KEY_CREATED_ORDER_TRACKING_ID);
    allOrdersPage.cancelSelected(Collections.singletonList(trackingID));
  }

  @When("Operator pull out multiple orders below from route on All Orders page:")
  public void operatorPullOutMultipleOrdersFromRouteOnAllOrdersPage(
      List<String> listOfTrackingIds) {
    allOrdersPage.pullOutFromRoute(listOfTrackingIds);
  }

  @When("Operator add multiple orders to route on All Orders page:")
  public void operatorAddMultipleOrdersUsingTagFilterToRouteOnAllOrdersPage(
      Map<String, String> data) {
    data = resolveKeyValues(data);
    List<String> listOfTrackingIds;
    String trackingIds = data.get("trackingIds");
    if (StringUtils.isNotBlank(trackingIds)) {
      listOfTrackingIds = splitAndNormalize(trackingIds);
    } else {
      listOfTrackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
    }
    List<String> routeIds = splitAndNormalize(data.get("routeId"));
    if (routeIds.size() == 1) {
      allOrdersPage.addToRoute(listOfTrackingIds, routeIds.get(0), data.get("tag"));
    } else {
      allOrdersPage.fillAddToRouteForm(listOfTrackingIds, routeIds);
      if (listOfTrackingIds.size() > 1) {
        allOrdersPage.addToRouteDialog.addSelectedToRoutes.clickAndWaitUntilDone();
      } else {
        allOrdersPage.addToRouteDialog.addToRoute.clickAndWaitUntilDone();
      }
    }
  }

  @When("Operator fill Add Selected to Route form using Set To All:")
  public void operatorFillAddSelectedToRouteFormOnAllOrdersPage(Map<String, String> data) {
    data = resolveKeyValues(data);
    List<String> listOfTrackingIds = null;
    String trackingIds = data.get("trackingIds");
    if (StringUtils.isNotBlank(trackingIds)) {
      listOfTrackingIds = splitAndNormalize(trackingIds);
    } else {
      listOfTrackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
    }
    allOrdersPage.fillAddToRouteFormUsingSetToAll(listOfTrackingIds, data.get("routeId"),
        data.get("tag"));
  }

  @When("Operator suggest routes on Add Selected to Route form:")
  public void operatorSuggestRoutes(List<Map<String, String>> data) {
    List<AddToRouteData> tagsMap = data.stream()
        .map(val -> new AddToRouteData(resolveKeyValues(val))).collect(Collectors.toList());
    allOrdersPage.fillRouteSuggestion(tagsMap);
  }

  @When("Operator suggest routes on Add Selected to Route form using Set To All:")
  public void operatorSuggestRoutes(Map<String, String> data) {
    data = resolveKeyValues(data);
    String tag = data.get("tag");
    String type = data.getOrDefault("type", "Delivery");
    allOrdersPage.fillRouteSuggestionUsingSetToAll(type, tag);
  }

  @When("Operator verify Route Id values on Add Selected to Route form:")
  public void operatorVerifyRouteIdValues(List<Map<String, String>> data) {
    data.forEach(orderData -> {
      orderData = resolveKeyValues(orderData);
      String trackingId = StringUtils.trimToEmpty(orderData.get("trackingId"));
      String expectedRouteId = StringUtils.trimToEmpty(orderData.get("routeId"));
      Assertions.assertThat(allOrdersPage.addToRouteDialog.getRouteId(trackingId))
          .as(f("Route Id for %s order", trackingId)).isEqualTo(expectedRouteId);
    });
  }

  @When("Operator submit Add Selected to Route form on All Orders page")
  public void operatorSubmitAddSelectedToRouteFormOnAllOrdersPage() {
    allOrdersPage.addToRouteDialog.addSelectedToRoutes.clickAndWaitUntilDone();
  }

  @When("^Operator print Waybill for single order on All Orders page$")
  public void operatorPrintWaybillForSingleOrderOnAllOrdersPage() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    allOrdersPage.printWaybill(trackingId);
  }

  @When("^Operator print Waybill for multiple orders on All Orders page$")
  public void operatorPrintWaybillForMultipleOrdersOnAllOrdersPage() {
    allOrdersPage.selectAllShown();
    allOrdersPage.actionsMenu.selectOption("Print Waybills");
    allOrdersPage.printWaybillsDialog.waitUntilVisible();
    allOrdersPage.printWaybillsDialog.checkbox.check();
    allOrdersPage.printWaybillsDialog.downloadSelected.click();
    allOrdersPage.printWaybillsDialog.forceClose();
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
    allOrdersPage.findOrdersWithCsv(trackingIds);
    allOrdersPage.resumeSelected(trackingIds);
  }

  @Then("^Operator verify order status is \"(.+)\"$")
  public void operatorVerifyOrderStatusIs(String expectedOrderStatus) {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    allOrdersPage.findOrdersWithCsv(Collections.singletonList(trackingId));
    allOrdersPage.verifyOrderStatus(trackingId, expectedOrderStatus);
  }

  @When("^Operator apply \"(.+)\" action to created orders$")
  public void operatorApplyActionToCreatedOrders(String actionName) {
    List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
    AllOrdersAction action = AllOrdersAction.valueOf(
        actionName.toUpperCase().replaceAll("\\s", "_"));
    allOrdersPage.applyActionToOrdersByTrackingId(trackingIds, action);
  }

  @When("^Operator apply \"Pull From Route\" action and expect to see \"Selection Error\"$")
  public void operatorApplyPullFromRouteActionAndExpectToSeeSelectionError(
      List<String> trackingIds) {
    allOrdersPage.pullOutFromRouteWithExpectedSelectionError(resolveValues(trackingIds));
  }

  @Then("^Operator verify Selection Error dialog for invalid Pull From Order action$")
  public void operatorVerifySelectionErrorDialogForInvalidPullFromOrderAction(
      List<String> trackingIds) {
    List<String> expectedFailureReasons = new ArrayList<>(trackingIds.size());
    Collections.fill(expectedFailureReasons, "No route found to unroute");
    allOrdersPage.verifySelectionErrorDialog(trackingIds, AllOrdersAction.PULL_FROM_ROUTE,
        expectedFailureReasons);
  }

  @When("^Operator open page of the created order from All Orders page$")
  public void operatorOpenPageOfTheCreatedOrderFromAllOrdersPage() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    Long orderId = get(KEY_CREATED_ORDER_ID);
    operatorOpenPageOfOrderFromAllOrdersPage(
        ImmutableMap.of("trackingId", trackingId, "orderId", String.valueOf(orderId)));
  }

  @When("^Operator open page of an order from All Orders page using data below:$")
  public void operatorOpenPageOfOrderFromAllOrdersPage(Map<String, String> data) {
    data = resolveKeyValues(data);
    String trackingId = data.get("trackingId");
    Long orderId = Long.parseLong(data.get("orderId"));
    String mainWindowHandle = allOrdersPage.getWebDriver().getWindowHandle();
    put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
    allOrdersPage.waitUntilPageLoaded();
    allOrdersPage.categorySelect.selectValue(
        AllOrdersPage.Category.TRACKING_OR_STAMP_ID.getValue());
    allOrdersPage.searchLogicSelect.selectValue(
        AllOrdersPage.SearchLogic.EXACTLY_MATCHES.getValue());
    retryIfRuntimeExceptionOccurred(() -> {
      allOrdersPage.searchTerm.selectValue(trackingId);
      pause1s();
      allOrdersPage.waitUntilPageLoaded();
      allOrdersPage.switchToEditOrderWindow(orderId);
    }, f("Open Edit Order page for order [%s]", trackingId), 1000, 3);
  }

  @Then("Operator verifies tha searched Tracking ID is the same to the created one")
  public void operatorVerifiesThaSearchedTrackingIDIsTheSameToTheCreatedOne() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    allOrdersPage.verifiesTrackingIdIsCorrect(trackingId);
  }

  @Then("^Operator verifies All Orders Page is displayed$")
  public void operatorVerifiesAllOrdersPageIsDispalyed() {
    allOrdersPage.verifyItsCurrentPage();
  }

  @When("Operator RTS multiple orders on next day on All Orders Page:")
  public void operatorRtsOrdersOnNextDayOnAllOrdersPage(List<String> listOfTrackingIds) {
    List<String> resolveListOfTrackingIds = resolveValues(listOfTrackingIds);
    if (CollectionUtils.isEmpty(resolveListOfTrackingIds)) {
      throw new IllegalArgumentException(
          "List of created Tracking Id should not be null or empty.");
    }
    allOrdersPage.rtsMultipleOrderNextDay(resolveListOfTrackingIds);
  }

  @When("Operator Mass-Revert RTS orders on All Orders Page:")
  public void massRevertRts(List<String> listOfTrackingIds) {
    List<String> resolveListOfTrackingIds = resolveValues(listOfTrackingIds);
    if (CollectionUtils.isEmpty(resolveListOfTrackingIds)) {
      throw new IllegalArgumentException(
          "List of created Tracking Id should not be null or empty.");
    }
    allOrdersPage.clearFilterTableOrderByTrackingId();
    allOrdersPage.selectAllShown();
    allOrdersPage.actionsMenu.selectOption("Mass-Revert RTS Selected");
    if (allOrdersPage.bulkActionProgress.waitUntilVisible(5)) {
      allOrdersPage.bulkActionProgress.waitUntilInvisible(5);
    }
  }

  @When("^Operator select 'Set RTS to Selected' action for found orders on All Orders page$")
  public void operatorSelectRtsActionForMultipleOrdersOnAllOrdersPage() {
    allOrdersPage.clearFilterTableOrderByTrackingId();
    allOrdersPage.selectAllShown();
    allOrdersPage.actionsMenu.selectOption("Set RTS to Selected");
  }

  @When("Operator verify {value} process in Selection Error dialog on All Orders page")
  public void verifyProcessInSelectionError(String process) {
    allOrdersPage.selectionErrorDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPage.selectionErrorDialog.process.getText()).as("Process")
        .isEqualTo(process);
  }

  @When("Operator clicks 'Download the invalid selection' in Selection Error dialog on All Orders page")
  public void clickDownloadTheInvalidSelection() {
    allOrdersPage.selectionErrorDialog.waitUntilVisible();
    allOrdersPage.selectionErrorDialog.downloadInvalidSelection.click();
  }

  @When("Operator clicks 'Download the failed updates' in Update Errors dialog on All Orders page")
  public void clickDownloadTheInvalidUpdates() {
    allOrdersPage.errorsDialog.waitUntilVisible();
    allOrdersPage.errorsDialog.downloadFailedUpdates.click();
  }

  @When("Operator verifies invalid selection CSV file on All Orders page:")
  public void verifyInvalidSelectionCsv(List<String> trackingIds) {
    allOrdersPage.verifyFileDownloadedSuccessfully(SELECTION_ERROR_CSV_FILENAME);
    List<String> actual = allOrdersPage.readDownloadedFile(SELECTION_ERROR_CSV_FILENAME);
    actual.remove(0);
    Assertions.assertThat(actual).as("List of invalid tracking ids")
        .containsExactlyInAnyOrderElementsOf(resolveValues(trackingIds));
  }

  @When("Operator verifies manually complete errors CSV file on All Orders page:")
  public void verifyManuallyCompleteErrorCsv(List<String> trackingIds) {
    allOrdersPage.verifyFileDownloadedSuccessfully(MANUALLY_COMPLETE_ERROR_CSV_FILENAME);
    List<String> actual = allOrdersPage.readDownloadedFile(MANUALLY_COMPLETE_ERROR_CSV_FILENAME);
    actual.remove(0);
    Assertions.assertThat(actual).as("List of invalid tracking ids")
        .containsExactlyInAnyOrderElementsOf(resolveValues(trackingIds));
  }

  @When("Operator verify orders info in Selection Error dialog on All Orders page:")
  public void verifyOrdersInfoInSelectionError(List<Map<String, String>> data) {
    data = resolveListOfMaps(data);
    List<Map<String, String>> actual = new ArrayList<>();
    allOrdersPage.selectionErrorDialog.waitUntilVisible();
    int count = allOrdersPage.selectionErrorDialog.trackingIds.size();
    for (int i = 0; i < count; i++) {
      Map<String, String> row = new HashMap<>();
      row.put("trackingId", allOrdersPage.selectionErrorDialog.trackingIds.get(i).getText());
      row.put("reason", allOrdersPage.selectionErrorDialog.reasons.get(i).getText());
      actual.add(row);
    }
    Assertions.assertThat(actual).as("List of tracing ids and reasons")
        .containsExactlyInAnyOrderElementsOf(data);
  }

  @When("Operator clicks Continue button in Selection Error dialog on All Orders page")
  public void clickContinueButtonInSelectionErrorDialog() {
    allOrdersPage.selectionErrorDialog.waitUntilVisible();
    allOrdersPage.selectionErrorDialog.continueBtn.click();
  }

  @Then("Operator verifies latest event is {string}")
  public void operatorVerifiesLatestEventIs(String latestEvent) {
    Order createdOrder = get(KEY_CREATED_ORDER);
    allOrdersPage.verifyLatestEvent(createdOrder, latestEvent);
  }

  @When("Operator selects filters on All Orders page:")
  public void operatorSelectsFilters(Map<String, String> data) {
    data = resolveKeyValues(data);
    allOrdersPage.waitUntilPageLoaded();
    allOrdersPage.clearAllSelections();

    if (data.containsKey("status")) {
      allOrdersPage.addFilter("Status");
      allOrdersPage.statusFilterBox.clearAll.click();
      allOrdersPage.statusFilter.moveAndClick();
      allOrdersPage.statusFilter.selectValue(data.get("status"));
    }

    if (data.containsKey("granularStatus")) {
      allOrdersPage.addFilter("Granular Status");
      allOrdersPage.granularStatusFilter.moveAndClick();
      allOrdersPage.granularStatusFilter.selectFilter(data.get("granularStatus"));
    }

    if (data.containsKey("creationTimeTo")) {
      if (!allOrdersPage.creationTimeFilter.isDisplayedFast()) {
        allOrdersPage.addFilter("Creation Time");
      }
      allOrdersPage.creationTimeFilter.selectToDate(data.get("creationTimeTo"));
      allOrdersPage.creationTimeFilter.selectToHours("12");
      allOrdersPage.creationTimeFilter.selectToMinutes("00");
    } else {
      if (allOrdersPage.creationTimeFilter.isDisplayedFast()) {
        allOrdersPage.creationTimeFilter.selectToDate(DateUtil.getTodayDate_YYYY_MM_DD());
        allOrdersPage.creationTimeFilter.selectToHours("12");
        allOrdersPage.creationTimeFilter.selectToMinutes("00");
      }
    }

    if (data.containsKey("creationTimeFrom")) {
      if (!allOrdersPage.creationTimeFilter.isDisplayedFast()) {
        allOrdersPage.addFilter("Creation Time");
      }
      allOrdersPage.creationTimeFilter.selectFromDate(data.get("creationTimeFrom"));
      allOrdersPage.creationTimeFilter.selectFromHours("12");
      allOrdersPage.creationTimeFilter.selectFromMinutes("00");
    } else {
      if (allOrdersPage.creationTimeFilter.isDisplayedFast()) {
        allOrdersPage.creationTimeFilter.selectFromDate(DateUtil.getTodayDate_YYYY_MM_DD());
        allOrdersPage.creationTimeFilter.selectFromHours("12");
        allOrdersPage.creationTimeFilter.selectFromMinutes("00");
      }
    }

    if (data.containsKey("shipperName")) {
      allOrdersPage.addFilter("Shipper");
      allOrdersPage.shipperFilter.moveAndClick();
      allOrdersPage.shipperFilter.selectFilter(data.get("shipperName"));
    }

    if (data.containsKey("masterShipperName")) {
      allOrdersPage.addFilter("Master Shipper");
      allOrdersPage.masterShipperFilter.selectValue(data.get("masterShipperName"));
    }
  }

  @When("^Operator updates filters on All Orders page:$")
  public void operatorUpdatesFilters(Map<String, String> data) {
    data = resolveKeyValues(data);

    allOrdersPage.waitUntilPageLoaded();

    if (data.containsKey("status")) {
      if (!allOrdersPage.statusFilter.isDisplayedFast()) {
        allOrdersPage.addFilter("Status");
      }
      allOrdersPage.statusFilter.moveAndClick();
      allOrdersPage.statusFilterBox.clearAll();
      allOrdersPage.statusFilterBox.selectFilter(splitAndNormalize(data.get("status")));
    }

    if (data.containsKey("granularStatus")) {
      if (!allOrdersPage.granularStatusFilter.isDisplayedFast()) {
        allOrdersPage.addFilter("Granular Status");
      }
      allOrdersPage.granularStatusFilter.moveAndClick();
      allOrdersPage.granularStatusFilter.clearAll();
      allOrdersPage.granularStatusFilter.selectFilter(
          splitAndNormalize(data.get("granularStatus")));
    }

    if (data.containsKey("creationTimeFrom")) {
      if (!allOrdersPage.creationTimeFilter.isDisplayedFast()) {
        allOrdersPage.addFilter("Creation Time");
      }
      allOrdersPage.creationTimeFilter.selectFromDate(data.get("creationTimeFrom"));
      allOrdersPage.creationTimeFilter.selectFromHours("04");
      allOrdersPage.creationTimeFilter.selectFromMinutes("00");
    }

    if (data.containsKey("creationTimeTo")) {
      if (!allOrdersPage.creationTimeFilter.isDisplayedFast()) {
        allOrdersPage.addFilter("Creation Time");
      }
      allOrdersPage.creationTimeFilter.selectToDate(data.get("creationTimeTo"));
      allOrdersPage.creationTimeFilter.selectToHours("04");
      allOrdersPage.creationTimeFilter.selectToMinutes("00");
    }

    if (data.containsKey("shipperName")) {
      if (!allOrdersPage.shipperFilter.isDisplayedFast()) {
        allOrdersPage.addFilter("Shipper");
      }
      allOrdersPage.shipperFilter.moveAndClick();
      allOrdersPage.shipperFilter.clearAll();
      allOrdersPage.shipperFilter.selectFilter(data.get("shipperName"));
    }

    if (data.containsKey("masterShipperName")) {
      if (!allOrdersPage.masterShipperFilter.isDisplayedFast()) {
        allOrdersPage.addFilter("Master Shipper");
      }
      allOrdersPage.masterShipperFilter.selectValue(data.get("masterShipperName"));
    }
  }

  @When("^Operator verifies selected filters on All Orders page:$")
  public void operatorVerifiesSelectedFilters(Map<String, String> data) {
    data = resolveKeyValues(data);
    SoftAssertions assertions = new SoftAssertions();
    pause2s();

    if (data.containsKey("status")) {
      boolean isDisplayed = allOrdersPage.statusFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Status filter is not displayed");
      } else {
        assertions.assertThat(allOrdersPage.statusFilterBox.getSelectedValues()).as("Status items")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("status")));
      }
    }

    if (data.containsKey("granularStatus")) {
      boolean isDisplayed = allOrdersPage.granularStatusFilter.isDisplayed();
      if (!isDisplayed) {
        assertions.fail("Granular Status filter is not displayed");
      } else {
        assertions.assertThat(allOrdersPage.granularStatusFilter.getSelectedValues())
            .as("Granular Status items")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("granularStatus")));
      }
    }

    if (data.containsKey("creationTimeFrom")) {
      boolean isDisplayed = allOrdersPage.creationTimeFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Creation Time filter is not displayed");
      } else {
        assertions.assertThat(allOrdersPage.creationTimeFilter.fromDate.getValue())
            .as("Creation Time From Date").isEqualTo(data.get("creationTimeFrom"));
      }
    }

    if (data.containsKey("creationTimeTo")) {
      boolean isDisplayed = allOrdersPage.creationTimeFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Creation Time filter is not displayed");
      } else {
        assertions.assertThat(allOrdersPage.creationTimeFilter.toDate.getValue())
            .as("Creation Time To Date").isEqualTo(data.get("creationTimeTo"));
      }
    }

    if (data.containsKey("shipperName")) {
      boolean isDisplayed = allOrdersPage.shipperFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Shipper filter is not displayed");
      } else {
        assertions.assertThat(allOrdersPage.shipperFilter.getSelectedValues()).as("Shipper items")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("shipperName")));
      }
    }

    if (data.containsKey("masterShipperName")) {
      boolean isDisplayed = allOrdersPage.masterShipperFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Master Shipper filter is not displayed");
      } else {
        assertions.assertThat(allOrdersPage.masterShipperFilterBox.getSelectedValues())
            .as("Master Shipper items")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("masterShipperName")));
      }
    }
    assertions.assertAll();
  }

  @When("Operator selects {string} preset action on All Orders page")
  public void selectPresetAction(String action) {
    allOrdersPage.waitUntilPageLoaded();
    allOrdersPage.presetActions.selectOption(resolveValue(action));
  }

  @When("Operator verifies Save Preset dialog on All Orders page contains filters:")
  public void verifySelectedFiltersForPreset(List<String> expected) {
    allOrdersPage.savePresetDialog.waitUntilVisible();
    List<String> actual = allOrdersPage.savePresetDialog.selectedFilters.stream()
        .map(PageElement::getNormalizedText).collect(Collectors.toList());
    Assertions.assertThat(actual).as("List of selected filters")
        .containsExactlyInAnyOrderElementsOf(expected);
  }

  @When("Operator verifies Preset Name field in Save Preset dialog on All Orders page is required")
  public void verifyPresetNameIsRequired() {
    allOrdersPage.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPage.savePresetDialog.presetName.getAttribute("ng-required"))
        .as("Preset Name field ng-required attribute").isEqualTo("required");
  }

  @When("Operator verifies help text {string} is displayed in Save Preset dialog on All Orders page")
  public void verifyHelpTextInSavePreset(String expected) {
    allOrdersPage.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPage.savePresetDialog.helpText.getNormalizedText())
        .as("Help Text").isEqualTo(resolveValue(expected));
  }

  @When("Operator verifies Cancel button in Save Preset dialog on All Orders page is enabled")
  public void verifyCancelIsEnabled() {
    allOrdersPage.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPage.savePresetDialog.cancel.isEnabled())
        .as("Cancel button is enabled").isTrue();
  }

  @When("Operator verifies Save button in Save Preset dialog on All Orders page is enabled")
  public void verifySaveIsEnabled() {
    allOrdersPage.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPage.savePresetDialog.save.isEnabled())
        .as("Save button is enabled").isTrue();
  }

  @When("Operator clicks Save button in Save Preset dialog on All Orders page")
  public void clickSaveInSavePresetDialog() {
    allOrdersPage.savePresetDialog.save.click();
  }

  @When("Operator clicks Update button in Save Preset dialog on All Orders page")
  public void clickUpdateInSavePresetDialog() {
    allOrdersPage.savePresetDialog.update.click();
  }

  @When("Operator verifies Save button in Save Preset dialog on All Orders page is disabled")
  public void verifySaveIsDisabled() {
    allOrdersPage.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPage.savePresetDialog.save.isEnabled())
        .as("Save button is enabled").isFalse();
  }

  @When("Operator disable granular status filter for {string}")
  public void disableGranularStatus(String granStatus) {
    Objects.requireNonNull(allOrdersPage.disableGranStatusElement.get(granStatus)).click();
  }

  @When("Operator disable status filter for {string}")
  public void disableStatus(String status) {
    Objects.requireNonNull(allOrdersPage.disableStatusElement.get(status)).click();
  }

  @When("Operator press load selection button")
  public void pressLoadSelectionButton() {
    allOrdersPage.loadSelection.waitUntilVisible();
    allOrdersPage.loadSelection.click();
  }

  @When("Operator fill the tracking id filter with {string}")
  public void pressLoadSelectionButton(String trackingId) {
    allOrdersPage.trackingIdFilter.waitUntilVisible();
    allOrdersPage.trackingIdFilter.setValue(resolveValue(trackingId));
  }

  @When("Operator check the checkbox from created order")
  public void checkCheckbox() {
    allOrdersPage.buttonCheckboxOrder.waitUntilVisible();
    allOrdersPage.buttonCheckboxOrder.click();
  }

  @When("Operator press Apply Action button")
  public void pressApplyActionButton() {
    allOrdersPage.buttonApplyAction.waitUntilVisible();
    allOrdersPage.buttonApplyAction.click();
  }

  @When("Operator apply action for {string}")
  public void pressChooseApplyAction(String action) {
    allOrdersPage.applyActionOrder(action);
  }

  @When("Operator set the pickup date for regular pickup at {string}")
  public void setPickupDate(String date) {
    allOrdersPage.datePickerInput.forceClear();
    allOrdersPage.datePickerInput.setValue(resolveValue(date));
  }

  @When("Operator press submit regular pickup button")
  public void pressSubmitRegulatPickupButton() {
    allOrdersPage.submit.click();
  }

  @When("Operator verifies Cancel button in Delete Preset dialog on All Orders page is enabled")
  public void verifyCancelIsEnabledInDeletePreset() {
    allOrdersPage.deletePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPage.deletePresetDialog.cancel.isEnabled())
        .as("Cancel button is enabled").isTrue();
  }

  @When("Operator generates order statuses report on All Orders page:")
  public void generateOrderStatusesReport(List<String> trackingIds) {
    allOrdersPage.orderStatusesReport.click();
    allOrdersPage.orderStatusesReportDialog.waitUntilVisible();
    String csvContents = resolveValues(trackingIds).stream()
        .collect(Collectors.joining(System.lineSeparator(), "", System.lineSeparator()));
    File csvFile = allOrdersPage.createFile(
        String.format("order-statuses-find_%s.csv", allOrdersPage.generateDateUniqueString()),
        csvContents);
    allOrdersPage.orderStatusesReportDialog.file.setValue(csvFile);
    allOrdersPage.orderStatusesReportDialog.generate.click();
  }

  @When("Operator downloads order statuses report sample CSV on All Orders page")
  public void downloadOrderStatusesReportSampleCsv() {
    allOrdersPage.orderStatusesReport.click();
    allOrdersPage.orderStatusesReportDialog.waitUntilVisible();
    allOrdersPage.orderStatusesReportDialog.downloadSample.click();
  }

  @Then("Operator verify order statuses report sample CSV file downloaded successfully")
  public void operatorVerifySampleCsvFileDownloadedSuccessfully() {
    allOrdersPage.verifyFileDownloadedSuccessfully("order-statuses-find.csv",
        "NVSGNINJA000000001\n"
            + "NVSGNINJA000000002\n"
            + "NVSGNINJA000000003\n");
  }

  @When("Operator verifies Delete button in Delete Preset dialog on All Orders page is enabled")
  public void verifyDeleteIsEnabled() {
    allOrdersPage.deletePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPage.deletePresetDialog.delete.isEnabled())
        .as("Delete button is enabled").isTrue();
  }

  @When("Operator selects {string} preset in Delete Preset dialog on All Orders page")
  public void selectPresetInDeletePresets(String value) {
    allOrdersPage.deletePresetDialog.waitUntilVisible();
    allOrdersPage.deletePresetDialog.preset.searchAndSelectValue(resolveValue(value));
  }

  @When("Operator clicks Delete button in Delete Preset dialog on All Orders page")
  public void clickDeleteInDeletePresetDialog() {
    allOrdersPage.deletePresetDialog.delete.click();
  }

  @When("Operator verifies Delete button in Delete Preset dialog on All Orders page is disabled")
  public void verifyDeleteIsDisabled() {
    allOrdersPage.deletePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPage.deletePresetDialog.delete.isEnabled())
        .as("Delete button is enabled").isFalse();
  }

  @When("Operator verifies {string} message is displayed in Delete Preset dialog on All Orders page")
  public void verifyMessageInDeletePreset(String expected) {
    allOrdersPage.deletePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPage.deletePresetDialog.message.getNormalizedText())
        .as("Delete Preset message").isEqualTo(resolveValue(expected));
  }

  @When("Operator enters {string} Preset Name in Save Preset dialog on All Orders page")
  public void enterPresetNameIsRequired(String presetName) {
    allOrdersPage.savePresetDialog.waitUntilVisible();
    presetName = resolveValue(presetName);
    allOrdersPage.savePresetDialog.presetName.setValue(presetName);
    put(KEY_ALL_ORDERS_FILTERS_PRESET_NAME, presetName);
  }

  @When("Operator verifies Preset Name field in Save Preset dialog on All Orders page has green checkmark on it")
  public void verifyPresetNameIsValidated() {
    Assertions.assertThat(allOrdersPage.savePresetDialog.confirmedIcon.isDisplayed())
        .as("Preset Name checkmark").isTrue();
  }

  @When("Operator verifies selected Filter Preset name is {string} on All Orders page")
  public void verifySelectedPresetName(String expected) {
    expected = resolveValue(expected);
    String actual = StringUtils.trim(allOrdersPage.filterPreset.getValue());
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
        allOrdersPage.waitUntilPageLoaded();
        allOrdersPage.selectFilterPreset(value);
      } catch (Exception e) {
        allOrdersPage.refreshPage();
        throw new NvTestCoreElementNotFoundError(
            "Filter Preset " + value + " is not found on All Orders page", e);
      }
    }, "Operator selects " + value + " Filter Preset on All Orders page");
  }

  @When("Operator clicks Clear All Selections and Load Selection button on All Orders Page")
  public void operatorClicksClearAllSelectionsAndLoadSelectionOnAllOrdersPage() {
    allOrdersPage.clearAllSelectionsAndLoadSelection();
  }

  @When("Operator clicks Clear All Selections on All Orders Page")
  public void operatorClicksClearAllSelections() {
    allOrdersPage.clearAllSelections();
  }

  @And("Operator apply Regular pickup action")
  public void operatorApplyRegularPickupAction() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    allOrdersPage.applyAction(trackingId);
  }

  @Then("Downloaded csv file contains correct orders and message {string}")
  public void downloadedCsvFileContainsCorrectOrdersAndMessage(String message) {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    allOrdersPage.verifyDownloadedCsv(trackingId, message);
  }

  @Then("Operator verify that revert_rts_tracking_ids CSV has correct details:")
  public void verifyRevertRtsFile(List<String> trackingIds) {
    String text = "Tracking ID\n" + StringUtils.join(resolveValues(trackingIds), "\n");
    String fileName = "revert_rts_tracking_ids.csv";
    String downloadedFile = allOrdersPage.getLatestDownloadedFilename(fileName);
    allOrdersPage.verifyFileDownloadedSuccessfully(downloadedFile, text);
  }

  @Then("Operator apply Early pickup action and chooses {string} with {string}")
  public void operatorChoosesAndClicksSubmit(String action, String date) {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    allOrdersPage.choosePickupActionAndClickSubmit(trackingId, action, date);
  }

  @And("Operator verifies the delivery address is doorstep address {string} and {string}")
  public void operatorVerifiesTheDeliveryAddressIsDoorstepAddressAnd(String address1,
      String address2) {
    pause3s();
    Order order = get(KEY_CREATED_ORDER);
    allOrdersPage.verifyCustomerDeliveryAddress(order, address1, address2);
  }

  @Then("Operator verifies the delivery address is rts")
  public void operatorVerifiesTheDeliveryAddressIsRts() {
    Order order = get(KEY_CREATED_ORDER);
    allOrdersPage.verifyDeliveryAddressIsRts(order);
  }

  @Then("Operator verifies the order status is {string} and granular status is {string}")
  public void operatorVerifiesTheOrderStatusIsAndGranularStatusIs(String status,
      String granularStatus) {
    Order order = get(KEY_CREATED_ORDER);
    allOrdersPage.verifyOrderStatus(order, status, granularStatus);
  }

  @When("Operator print Waybill for order {string} on All Orders page")
  public void operatorPrintWaybillForOrderOnAllOrdersPage(String trackingIdAsString) {
    String trackingId = resolveValue(trackingIdAsString);
    allOrdersPage.printWaybill(trackingId);
  }

  @When("Operator print Waybill for multiple orders with size {string} on All Orders page")
  public void operatorPrintWaybillOrdersOnAllOrdersPage(String size) {
    allOrdersPage.selectAllShown();
    allOrdersPage.actionsMenu.selectOption("Print Waybills");
    allOrdersPage.printWaybillsDialog.waitUntilVisible();
    allOrdersPage.printWaybillsDialog.checkbox.check();
    allOrdersPage.printWaybillsDialog.PrintingSizeBox.click();
    allOrdersPage.printWaybillsDialog.SelectPrintSize(size);
    allOrdersPage.printWaybillsDialog.downloadSelected.click();
    allOrdersPage.printWaybillsDialog.forceClose();
  }

  @When("Operator find multiple orders below by uploading CSV on All Orders page")
  public void operatorFindMultipleOrdersByUploadingCsvOnAllOrderPage(List<String> listOfOrder) {
    List<String> listOfCreatedTrackingId = resolveValues(listOfOrder);
    operatorFindOrdersByUploadingCsvOnAllOrderPage(listOfCreatedTrackingId);
  }

  @When("Operator verify order record on All Orders page:")
  public void verifyOrderRecord(Map<String, String> data) {
    var expected = new OrderInfo(resolveKeyValues(data));
    allOrdersPage.ordersTable.filterByColumn("trackingId", expected.getTrackingId());
    var actual = allOrdersPage.ordersTable.readEntity(1);
    expected.compareWithActual(actual);
  }

  @Then("Operator unmask All Orders page")
  public void unmaskPage() {
    List<WebElement> elements = getWebDriver().findElements(By.xpath(MaskedPage.MASKING_XPATH));
    allOrdersPage.operatorClickMaskingText(elements);
  }

  @When("Operator verifies order statuses report file contains following data:")
  public void operatorVerifyOrderStatusesReportFile(List<Map<String, String>> data) {
    String fileName = allOrdersPage.getLatestDownloadedFilename("results.csv");
    allOrdersPage.verifyFileDownloadedSuccessfully(fileName);
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
//            TODO common-v2: use equivalent of this in new common
            final String formattedDeliveryDate = LocalDate.parse(rawDeliveryDate,
                co.nvqa.commons.support.DateUtil.ISO8601_LITE_FORMATTER).toString();
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