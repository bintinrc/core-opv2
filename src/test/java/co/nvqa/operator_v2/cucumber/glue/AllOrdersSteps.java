package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.model.AddToRouteData;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.AllOrdersPage;
import co.nvqa.operator_v2.selenium.page.AllOrdersPage.AllOrdersAction;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
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

  @When("^Operator switch to Edit Order's window$")
  public void operatorSwitchToEditOrderWindow() {
    Long orderId = get(KEY_CREATED_ORDER_ID);
    String mainWindowHandle = allOrdersPage.getWebDriver().getWindowHandle();
    allOrdersPage.switchToEditOrderWindow(orderId);
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
    AllOrdersPage.Category category = AllOrdersPage.Category
        .findByValue(dataTableAsMap.get("category"));
    AllOrdersPage.SearchLogic searchLogic = AllOrdersPage.SearchLogic
        .findByValue(dataTableAsMap.get("searchLogic"));
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
    AllOrdersPage.Category category = AllOrdersPage.Category
        .findByValue(dataTableAsMap.get("category"));
    AllOrdersPage.SearchLogic searchLogic = AllOrdersPage.SearchLogic
        .findByValue(dataTableAsMap.get("searchLogic"));
    String searchTerm = dataTableAsMap.get("searchTerm");

    if (containsKey(searchTerm)) {
      searchTerm = get(searchTerm);
    }

    allOrdersPage.waitUntilPageLoaded();
    allOrdersPage.categorySelect.selectValue(category.getValue());
    allOrdersPage.searchLogicSelect.selectValue(searchLogic.getValue());
    try {
      allOrdersPage.searchTerm.selectValue(searchTerm);
      fail("Order " + searchTerm + " was found on All Orders page");
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

  @Then("^Operator verify all orders in CSV is found on All Orders page with correct info$")
  public void operatorVerifyAllOrdersInCsvIsFoundOnAllOrdersPageWithCorrectInfo() {
    List<Order> listOfCreatedOrder =
        containsKey(KEY_LIST_OF_ORDER_DETAILS) ? get(KEY_LIST_OF_ORDER_DETAILS)
            : get(KEY_LIST_OF_CREATED_ORDER);
    allOrdersPage.verifyAllOrdersInCsvIsFoundWithCorrectInfo(listOfCreatedOrder);
  }

  @When("^Operator uploads CSV that contains invalid Tracking ID on All Orders page$")
  public void operatorUploadsCsvThatContainsInvalidTrackingIdOnAllOrdersPage() {
    List<String> listOfInvalidTrackingId = new ArrayList<>();
    listOfInvalidTrackingId.add("DUMMY" + generateDateUniqueString() + 'N');
    listOfInvalidTrackingId.add("DUMMY" + generateDateUniqueString() + 'C');
    listOfInvalidTrackingId.add("DUMMY" + generateDateUniqueString() + 'R');

    allOrdersPage.findOrdersWithCsv(listOfInvalidTrackingId);
    put("listOfInvalidTrackingId", listOfInvalidTrackingId);
  }

  @Then("^Operator verify that the page failed to find the orders inside the CSV that contains invalid Tracking IDS on All Orders page$")
  public void operatorVerifyThatThePageFailedToFindTheOrdersInsideTheCsvThatContainsInvalidTrackingIdsOnAllOrdersPage() {
    List<String> listOfInvalidTrackingId = get("listOfInvalidTrackingId");
    allOrdersPage.verifyInvalidTrackingIdsIsFailedToFind(listOfInvalidTrackingId);
  }

  @When("^Operator Force Success single order on All Orders page$")
  public void operatorForceSuccessSingleOrderOnAllOrdersPage() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    allOrdersPage.findOrdersWithCsv(ImmutableList.of(trackingId));
    String reason = allOrdersPage.forceSuccessOrders();
    put(KEY_ORDER_CHANGE_REASON, reason);
  }

  @When("^Operator Force Success orders with COD collection on All Orders page:$")
  public void operatorForceSuccessSingleOrderOnAllOrdersPageWithCodCollection(
      List<Map<String, String>> data) {
    Map<String, Boolean> resolvedData = data.stream()
        .collect(Collectors.toMap(
            row -> resolveValue(row.get("trackingId")).toString(),
            row -> Boolean.valueOf(row.get("collected"))
        ));
    allOrdersPage.findOrdersWithCsv(new ArrayList<>(resolvedData.keySet()));
    allOrdersPage.clearFilterTableOrderByTrackingId();
    allOrdersPage.selectAllShown();
    allOrdersPage.actionsMenu.selectOption(AllOrdersAction.MANUALLY_COMPLETE_SELECTED.getName());
    allOrdersPage.manuallyCompleteOrderDialog.waitUntilVisible();
    assertEquals("Number of orders with COD", data.size(),
        allOrdersPage.manuallyCompleteOrderDialog.trackingIds.size());
    for (int i = 0; i < allOrdersPage.manuallyCompleteOrderDialog.trackingIds.size(); i++) {
      String trackingId = allOrdersPage.manuallyCompleteOrderDialog.trackingIds.get(i)
          .getNormalizedText();
      Boolean checked = resolvedData.get(trackingId);
      if (checked != null) {
        allOrdersPage.manuallyCompleteOrderDialog.codCheckboxes.get(i).setValue(checked);
      }
    }
    allOrdersPage.manuallyCompleteOrderDialog.changeReason.setValue("Completed by automated test");
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
    allOrdersPage.manuallyCompleteOrderDialog.changeReason.setValue("Completed by automated test");
    allOrdersPage.manuallyCompleteOrderDialog.completeOrder.clickAndWaitUntilDone();
    pause2s();
  }

  @When("^Operator verifies error messages in dialog on All Orders page:$")
  public void operatorVerifyErrorMessagesDialog(List<String> data) {
    data = resolveValues(data);
    assertTrue("Errors dialog is displayed", allOrdersPage.errorsDialog.waitUntilVisible(5));
    List<String> actual = allOrdersPage.errorsDialog.errorMessage.stream()
        .map(element -> StringUtils.normalizeSpace(element.getNormalizedText())
            .replaceAll("^\\d{1,2}\\.", ""))
        .collect(Collectors.toList());
    Assertions.assertThat(actual)
        .as("List of error messages")
        .containsExactlyInAnyOrderElementsOf(data);
  }

  @When("^Operator close Errors dialog on All Orders page$")
  public void operatorCloseErrorsDialog() {
    allOrdersPage.errorsDialog.waitUntilVisible();
    allOrdersPage.errorsDialog.close.click();
  }

  @When("Operator Force Success multiple orders on All Orders page")
  public void operatorForceSuccessOrders() {
    List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
    allOrdersPage.findOrdersWithCsv(trackingIds);
    allOrdersPage.forceSuccessOrders();
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

  @When("^Operator cancel multiple orders on All Orders page$")
  public void operatorCancelMultipleOrdersOnAllOrdersPage() {
    List<Order> listOfCreatedOrder = get(KEY_LIST_OF_CREATED_ORDER);
    List<String> listOfTrackingIds = listOfCreatedOrder.stream().map(Order::getTrackingId)
        .collect(Collectors.toList());
    allOrdersPage.cancelSelected(listOfTrackingIds);
  }

  @When("^Operator cancel order on All Orders page$")
  public void operatorCancelOrderOnAllOrdersPage() {
    String trackingID = get(KEY_CREATED_ORDER_TRACKING_ID);
    allOrdersPage.cancelSelected(Collections.singletonList(trackingID));
  }

  @When("^Operator pull out multiple orders from route on All Orders page$")
  public void operatorPullOutMultipleOrdersFromRouteOnAllOrdersPage() {
    List<Order> listOfCreatedOrder = get(KEY_LIST_OF_CREATED_ORDER);
    List<String> listOfTrackingIds = listOfCreatedOrder.stream().map(Order::getTrackingId)
        .collect(Collectors.toList());
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
    allOrdersPage.addToRoute(listOfTrackingIds, data.get("routeId"), data.get("tag"));
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
    allOrdersPage
        .fillAddToRouteFormUsingSetToAll(listOfTrackingIds, data.get("routeId"), data.get("tag"));
  }

  @When("Operator suggest routes on Add Selected to Route form:")
  public void operatorSuggestRoutes(List<Map<String, String>> data) {
    List<AddToRouteData> tagsMap = data.stream()
        .map(val -> new AddToRouteData(resolveKeyValues(val)))
        .collect(Collectors.toList());
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
      assertEquals(f("Route Id for %s order", trackingId), expectedRouteId,
          allOrdersPage.addToRouteDialog.getRouteId(trackingId));
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

  @Then("^Operator verify the printed waybill for single order on All Orders page contains correct info$")
  public void operatorVerifyThePrintedWaybillForSingleOrderOnAllOrdersPageContainsCorrectInfo() {
    Order order = get(KEY_CREATED_ORDER);
    allOrdersPage.verifyWaybillContentsIsCorrect(order);
  }

  @When("^Operator resume order on All Orders page$")
  public void operatorResumeOrderOnAllOrdersPage() {
    List<String> trackingIds = Collections.singletonList(get(KEY_CREATED_ORDER_TRACKING_ID));
    resumeOrders(trackingIds);
  }

  @When("^Operator resume multiple orders on All Orders page$")
  public void operatorResumeOrdersOnAllOrdersPage() {
    List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
    resumeOrders(trackingIds);
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
    AllOrdersAction action = AllOrdersAction
        .valueOf(actionName.toUpperCase().replaceAll("\\s", "_"));
    allOrdersPage.applyActionToOrdersByTrackingId(trackingIds, action);
  }

  @When("^Operator apply \"Pull From Route\" action and expect to see \"Selection Error\"$")
  public void operatorApplyPullFromRouteActionAndExpectToSeeSelectionError() {
    List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
    allOrdersPage.pullOutFromRouteWithExpectedSelectionError(trackingIds);
  }

  @Then("^Operator verify Selection Error dialog for invalid Pull From Order action$")
  public void operatorVerifySelectionErrorDialogForInvalidPullFromOrderAction() {
    List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
    List<String> expectedFailureReasons = new ArrayList<>(trackingIds.size());
    Collections.fill(expectedFailureReasons, "No route found to unroute");
    allOrdersPage.verifySelectionErrorDialog(trackingIds, AllOrdersAction.PULL_FROM_ROUTE,
        expectedFailureReasons);
  }

  @When("^Operator open page of the created order from All Orders page$")
  public void operatorOpenPageOfTheCreatedOrderFromAllOrdersPage() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    Long orderId = get(KEY_CREATED_ORDER_ID);
    operatorOpenPageOfOrderFromAllOrdersPage(ImmutableMap.of(
        "trackingId", trackingId,
        "orderId", String.valueOf(orderId)
    ));
  }

  @When("^Operator open page of an order from All Orders page using data below:$")
  public void operatorOpenPageOfOrderFromAllOrdersPage(Map<String, String> data) {
    data = resolveKeyValues(data);
    String trackingId = data.get("trackingId");
    Long orderId = Long.parseLong(data.get("orderId"));
    String mainWindowHandle = allOrdersPage.getWebDriver().getWindowHandle();
    put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
    allOrdersPage.waitUntilPageLoaded();
    allOrdersPage.categorySelect
        .selectValue(AllOrdersPage.Category.TRACKING_OR_STAMP_ID.getValue());
    allOrdersPage.searchLogicSelect
        .selectValue(AllOrdersPage.SearchLogic.EXACTLY_MATCHES.getValue());
    retryIfRuntimeExceptionOccurred(() ->
    {
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

  @When("^Operator RTS multiple orders on next day on All Orders page$")
  public void operatorRtsMultipleOrdersOnNextDayOnAllOrdersPage() {
    List<Order> listOfCreatedOrder = get(KEY_LIST_OF_CREATED_ORDER);
    List<String> listOfTrackingIds = listOfCreatedOrder.stream().map(Order::getTrackingId)
        .collect(Collectors.toList());
    allOrdersPage.rtsMultipleOrderNextDay(listOfTrackingIds);
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
    Assertions.assertThat(allOrdersPage.selectionErrorDialog.process.getText())
        .as("Process")
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
    Assertions.assertThat(actual)
        .as("List of invalid tracking ids")
        .containsExactlyInAnyOrderElementsOf(resolveValues(trackingIds));
  }

  @When("Operator verifies manually complete errors CSV file on All Orders page:")
  public void verifyManuallyCompleteErrorCsv(List<String> trackingIds) {
    allOrdersPage.verifyFileDownloadedSuccessfully(MANUALLY_COMPLETE_ERROR_CSV_FILENAME);
    List<String> actual = allOrdersPage.readDownloadedFile(MANUALLY_COMPLETE_ERROR_CSV_FILENAME);
    actual.remove(0);
    Assertions.assertThat(actual)
        .as("List of invalid tracking ids")
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
    Assertions.assertThat(actual)
        .as("List of tracing ids and reasons")
        .containsExactlyInAnyOrderElementsOf(data);
  }

  @Then("Operator verifies latest event is {string}")
  public void operatorVerifiesLatestEventIs(String latestEvent) {
    Order createdOrder = get(KEY_CREATED_ORDER);
    allOrdersPage.verifyLatestEvent(createdOrder, latestEvent);
  }

  @When("^Operator selects filters on All Orders page:$")
  public void operatorSelectsFilters(Map<String, String> data) {
    data = resolveKeyValues(data);

    allOrdersPage.waitUntilPageLoaded();

    if (data.containsKey("status")) {
      if (!allOrdersPage.statusFilter.isDisplayedFast()) {
        allOrdersPage.addFilter("Status");
      }
      allOrdersPage.statusFilter.clearAll();
      allOrdersPage.statusFilter.selectFilter(data.get("status"));
    } else {
      if (allOrdersPage.statusFilter.isDisplayedFast()) {
        allOrdersPage.statusFilter.clearAll();
      }
    }

    if (data.containsKey("granularStatus")) {
      if (!allOrdersPage.granularStatusFilter.isDisplayedFast()) {
        allOrdersPage.addFilter("Granular Status");
      }
      allOrdersPage.granularStatusFilter.clearAll();
      allOrdersPage.granularStatusFilter.selectFilter(data.get("granularStatus"));
    } else {
      if (allOrdersPage.granularStatusFilter.isDisplayedFast()) {
        allOrdersPage.granularStatusFilter.clearAll();
      }
    }

    if (data.containsKey("creationTimeTo")) {
      if (!allOrdersPage.creationTimeFilter.isDisplayedFast()) {
        allOrdersPage.addFilter("Creation Time");
      }
      allOrdersPage.creationTimeFilter.selectToDate(data.get("creationTimeTo"));
      allOrdersPage.creationTimeFilter.selectToHours("04");
      allOrdersPage.creationTimeFilter.selectToMinutes("00");
    } else {
      if (allOrdersPage.creationTimeFilter.isDisplayedFast()) {
        allOrdersPage.creationTimeFilter.selectToDate(DateUtil.getTodayDate_YYYY_MM_DD());
        allOrdersPage.creationTimeFilter.selectToHours("04");
        allOrdersPage.creationTimeFilter.selectToMinutes("00");
      }
    }

    if (data.containsKey("creationTimeFrom")) {
      if (!allOrdersPage.creationTimeFilter.isDisplayedFast()) {
        allOrdersPage.addFilter("Creation Time");
      }
      allOrdersPage.creationTimeFilter.selectFromDate(data.get("creationTimeFrom"));
      allOrdersPage.creationTimeFilter.selectFromHours("04");
      allOrdersPage.creationTimeFilter.selectFromMinutes("00");
    } else {
      if (allOrdersPage.creationTimeFilter.isDisplayedFast()) {
        allOrdersPage.creationTimeFilter.selectFromDate(DateUtil.getTodayDate_YYYY_MM_DD());
        allOrdersPage.creationTimeFilter.selectFromHours("04");
        allOrdersPage.creationTimeFilter.selectFromMinutes("00");
      }
    }

    if (data.containsKey("shipperName")) {
      if (!allOrdersPage.shipperFilter.isDisplayedFast()) {
        allOrdersPage.addFilter("Shipper");
      }
      allOrdersPage.shipperFilter.clearAll();
      allOrdersPage.shipperFilter.selectFilter(data.get("shipperName"));
    } else {
      if (allOrdersPage.shipperFilter.isDisplayedFast()) {
        allOrdersPage.shipperFilter.clearAll();
      }
    }

    if (data.containsKey("masterShipperName")) {
      if (!allOrdersPage.masterShipperFilter.isDisplayedFast()) {
        allOrdersPage.addFilter("Master Shipper");
      }
      allOrdersPage.masterShipperFilter.clearAll();
      allOrdersPage.masterShipperFilter.selectFilter(data.get("masterShipperName"));
    } else {
      if (allOrdersPage.masterShipperFilter.isDisplayedFast()) {
        allOrdersPage.masterShipperFilter.clearAll();
      }
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
      allOrdersPage.statusFilter.clearAll();
      allOrdersPage.statusFilter.selectFilter(splitAndNormalize(data.get("status")));
    }

    if (data.containsKey("granularStatus")) {
      if (!allOrdersPage.granularStatusFilter.isDisplayedFast()) {
        allOrdersPage.addFilter("Granular Status");
      }
      allOrdersPage.granularStatusFilter.clearAll();
      allOrdersPage.granularStatusFilter
          .selectFilter(splitAndNormalize(data.get("granularStatus")));
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
      allOrdersPage.shipperFilter.clearAll();
      allOrdersPage.shipperFilter.selectFilter(data.get("shipperName"));
    }

    if (data.containsKey("masterShipperName")) {
      if (!allOrdersPage.masterShipperFilter.isDisplayedFast()) {
        allOrdersPage.addFilter("Master Shipper");
      }
      allOrdersPage.masterShipperFilter.clearAll();
      allOrdersPage.masterShipperFilter.selectFilter(data.get("masterShipperName"));
    }
  }

  @When("^Operator verifies selected filters on All Orders page:$")
  public void operatorVerifiesSelectedFilters(Map<String, String> data) {
    data = resolveKeyValues(data);

    SoftAssertions assertions = new SoftAssertions();

    if (data.containsKey("status")) {
      boolean isDisplayed = allOrdersPage.statusFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Status filter is not displayed");
      } else {
        assertions.assertThat(allOrdersPage.statusFilter.getSelectedValues())
            .as("Status items")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("status")));
      }
    }

    if (data.containsKey("granularStatus")) {
      boolean isDisplayed = allOrdersPage.granularStatusFilter.isDisplayedFast();
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
            .as("Creation Time From Date")
            .isEqualTo(data.get("creationTimeFrom"));
      }
    }

    if (data.containsKey("creationTimeTo")) {
      boolean isDisplayed = allOrdersPage.creationTimeFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Creation Time filter is not displayed");
      } else {
        assertions.assertThat(allOrdersPage.creationTimeFilter.toDate.getValue())
            .as("Creation Time To Date")
            .isEqualTo(data.get("creationTimeTo"));
      }
    }

    if (data.containsKey("shipperName")) {
      boolean isDisplayed = allOrdersPage.shipperFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Shipper filter is not displayed");
      } else {
        assertions.assertThat(allOrdersPage.shipperFilter.getSelectedValues())
            .as("Shipper items")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("shipperName")));
      }
    }

    if (data.containsKey("masterShipperName")) {
      boolean isDisplayed = allOrdersPage.masterShipperFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Master Shipper filter is not displayed");
      } else {
        assertions.assertThat(allOrdersPage.masterShipperFilter.getSelectedValues())
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
        .map(PageElement::getNormalizedText)
        .collect(Collectors.toList());
    Assertions.assertThat(actual)
        .as("List of selected filters")
        .containsExactlyInAnyOrderElementsOf(expected);
  }

  @When("Operator verifies Preset Name field in Save Preset dialog on All Orders page is required")
  public void verifyPresetNameIsRequired() {
    allOrdersPage.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPage.savePresetDialog.presetName.getAttribute("ng-required"))
        .as("Preset Name field ng-required attribute")
        .isEqualTo("required");
  }

  @When("Operator verifies help text {string} is displayed in Save Preset dialog on All Orders page")
  public void verifyHelpTextInSavePreset(String expected) {
    allOrdersPage.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPage.savePresetDialog.helpText.getNormalizedText())
        .as("Help Text")
        .isEqualTo(resolveValue(expected));
  }

  @When("Operator verifies Cancel button in Save Preset dialog on All Orders page is enabled")
  public void verifyCancelIsEnabled() {
    allOrdersPage.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPage.savePresetDialog.cancel.isEnabled())
        .as("Cancel button is enabled")
        .isTrue();
  }

  @When("Operator verifies Save button in Save Preset dialog on All Orders page is enabled")
  public void verifySaveIsEnabled() {
    allOrdersPage.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPage.savePresetDialog.save.isEnabled())
        .as("Save button is enabled")
        .isTrue();
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
        .as("Save button is enabled")
        .isFalse();
  }

  @When("Operator verifies Cancel button in Delete Preset dialog on All Orders page is enabled")
  public void verifyCancelIsEnabledInDeletePreset() {
    allOrdersPage.deletePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPage.deletePresetDialog.cancel.isEnabled())
        .as("Cancel button is enabled")
        .isTrue();
  }

  @When("Operator verifies Delete button in Delete Preset dialog on All Orders page is enabled")
  public void verifyDeleteIsEnabled() {
    allOrdersPage.deletePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPage.deletePresetDialog.delete.isEnabled())
        .as("Delete button is enabled")
        .isTrue();
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
        .as("Delete button is enabled")
        .isFalse();
  }

  @When("Operator verifies {string} message is displayed in Delete Preset dialog on All Orders page")
  public void verifyMessageInDeletePreset(String expected) {
    allOrdersPage.deletePresetDialog.waitUntilVisible();
    Assertions.assertThat(allOrdersPage.deletePresetDialog.message.getNormalizedText())
        .as("Delete Preset message")
        .isEqualTo(resolveValue(expected));
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
        .as("Preset Name checkmark")
        .isTrue();
  }

  @When("Operator verifies selected Filter Preset name is {string} on All Orders page")
  public void verifySelectedPresetName(String expected) {
    expected = resolveValue(expected);
    String actual = StringUtils.trim(allOrdersPage.filterPreset.getValue());
    Pattern p = Pattern.compile("(\\d+)\\s-\\s(.+)");
    Matcher m = p.matcher(actual);
    Assertions.assertThat(m.matches())
        .as("Selected Filter Preset value matches to pattern")
        .isTrue();
    Long presetId = Long.valueOf(m.group(1));
    String presetName = m.group(2);
    Assertions.assertThat(presetName)
        .as("Preset Name")
        .isEqualTo(expected);
    put(KEY_ALL_ORDERS_FILTERS_PRESET_ID, presetId);
  }

  @When("Operator selects {string} Filter Preset on All Orders page")
  public void selectPresetName(String value) {
    allOrdersPage.waitUntilPageLoaded();
    allOrdersPage.filterPreset.searchAndSelectValue(resolveValue(value));
    if (allOrdersPage.halfCircleSpinner.waitUntilVisible(3)) {
      allOrdersPage.halfCircleSpinner.waitUntilInvisible();
    }
    pause1s();
  }

  @When("Operator clicks Clear All Selections and Load Selection button on All Orders Page")
  public void operatorClicksClearAllSelectionsOnAllOrdersPage() {
    allOrdersPage.clearAllSelectionsAndLoadSelection();
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
}
