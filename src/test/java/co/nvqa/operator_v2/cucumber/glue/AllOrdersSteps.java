package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.model.GlobalInboundParams;
import co.nvqa.operator_v2.selenium.page.AllOrdersPage;
import co.nvqa.operator_v2.selenium.page.AllOrdersPage.ApplyActionsMenu.AllOrdersAction;
import com.google.common.collect.ImmutableMap;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class AllOrdersSteps extends AbstractSteps
{
    private AllOrdersPage allOrdersPage;

    public AllOrdersSteps()
    {
    }

    @Override
    public void init()
    {
        allOrdersPage = new AllOrdersPage(getWebDriver());
    }

    @When("^Operator switch to Edit Order's window$")
    public void operatorSwitchToEditOrderWindow()
    {
        Long orderId = get(KEY_CREATED_ORDER_ID);
        String mainWindowHandle = allOrdersPage.getWebDriver().getWindowHandle();
        allOrdersPage.switchToEditOrderWindow(orderId);
        put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
    }

    @When("^Operator download sample CSV file for \"Find Orders with CSV\" on All Orders page$")
    public void operatorDownloadSampleCsvFileForFindOrdersWithCsvOnAllOrdersPage()
    {
        allOrdersPage.downloadSampleCsvFile();
    }

    @Then("^Operator verify sample CSV file for \"Find Orders with CSV\" on All Orders page is downloaded successfully$")
    public void operatorVerifySampleCsvFileForFindOrdersWithCsvOnAllOrdersPageIsDownloadedSuccessfully()
    {
        allOrdersPage.verifySampleCsvFileDownloadedSuccessfully();
    }

    @When("^Operator find order on All Orders page using this criteria below:$")
    public void operatorFindOrderOnAllOrdersPageUsingThisCriteriaBelow(Map<String, String> dataTableAsMap)
    {
        AllOrdersPage.Category category = AllOrdersPage.Category.findByValue(dataTableAsMap.get("category"));
        AllOrdersPage.SearchLogic searchLogic = AllOrdersPage.SearchLogic.findByValue(dataTableAsMap.get("searchLogic"));
        String searchTerm = dataTableAsMap.get("searchTerm");
        String searchBy = searchTerm;

        /*
          Replace searchTerm value to value on ScenarioStorage.
         */
        if (containsKey(searchTerm))
        {
            searchTerm = get(searchTerm);
        }

        String mainWindowHandle = allOrdersPage.getWebDriver().getWindowHandle();
        if (StringUtils.equalsIgnoreCase(searchBy, "KEY_STAMP_ID"))
        {
            allOrdersPage.specificSearch(category, searchLogic, searchTerm, ((Order) get(KEY_CREATED_ORDER)).getTrackingId());
        } else
        {
            allOrdersPage.specificSearch(category, searchLogic, searchTerm);
        }
        put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
    }

    @When("^Operator can't find order on All Orders page using this criteria below:$")
    public void operatorCantFindOrderOnAllOrdersPageUsingThisCriteriaBelow(Map<String, String> dataTableAsMap)
    {
        AllOrdersPage.Category category = AllOrdersPage.Category.findByValue(dataTableAsMap.get("category"));
        AllOrdersPage.SearchLogic searchLogic = AllOrdersPage.SearchLogic.findByValue(dataTableAsMap.get("searchLogic"));
        String searchTerm = dataTableAsMap.get("searchTerm");

        if (containsKey(searchTerm))
        {
            searchTerm = get(searchTerm);
        }

        allOrdersPage.searchWithoutResult(category, searchLogic, searchTerm);
    }

    @When("^Operator filter the result table by Tracking ID on All Orders page and verify order info is correct$")
    public void operatorFilterTheResultTableByTrackingIdOnAllOrdersPageAndVerifyOrderInfoIsCorrect()
    {
        Order order = get(KEY_CREATED_ORDER);
        allOrdersPage.verifyOrderInfoOnTableOrderIsCorrect(order);
    }

    @Then("^Operator verify the new pending pickup order is found on All Orders page with correct info$")
    public void operatorVerifyTheNewPendingPickupOrderIsFoundOnAllOrdersPageWithCorrectInfo()
    {
        Order order = get(KEY_CREATED_ORDER);
        allOrdersPage.verifyOrderInfoIsCorrect(order);
    }

    @When("^Operator find multiple orders by uploading CSV on All Orders page$")
    public void operatorFindMultipleOrdersByUploadingCsvOnAllOrderPage()
    {
        List<String> listOfCreatedTrackingId = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);

        if (listOfCreatedTrackingId == null || listOfCreatedTrackingId.isEmpty())
        {
            throw new RuntimeException("List of created Tracking ID should not be null or empty.");
        }

        allOrdersPage.findOrdersWithCsv(listOfCreatedTrackingId);
    }

    @When("^Operator find order by uploading CSV on All Orders page$")
    public void operatorFindOrderByUploadingCsvOnAllOrderPage()
    {
        String createdTrackingId = get(KEY_CREATED_ORDER_TRACKING_ID);

        if (StringUtils.isBlank(createdTrackingId))
        {
            throw new RuntimeException("Created Order Tracking ID should not be null or empty.");
        }

        allOrdersPage.findOrdersWithCsv(Collections.singletonList(createdTrackingId));
    }

    @Then("^Operator verify all orders in CSV is found on All Orders page with correct info$")
    public void operatorVerifyAllOrdersInCsvIsFoundOnAllOrdersPageWithCorrectInfo()
    {
        List<Order> listOfCreatedOrder = containsKey(KEY_LIST_OF_ORDER_DETAILS) ? get(KEY_LIST_OF_ORDER_DETAILS) : get(KEY_LIST_OF_CREATED_ORDER);
        allOrdersPage.verifyAllOrdersInCsvIsFoundWithCorrectInfo(listOfCreatedOrder);
    }

    @When("^Operator uploads CSV that contains invalid Tracking ID on All Orders page$")
    public void operatorUploadsCsvThatContainsInvalidTrackingIdOnAllOrdersPage()
    {
        List<String> listOfInvalidTrackingId = new ArrayList<>();
        listOfInvalidTrackingId.add("DUMMY" + generateDateUniqueString() + 'N');
        listOfInvalidTrackingId.add("DUMMY" + generateDateUniqueString() + 'C');
        listOfInvalidTrackingId.add("DUMMY" + generateDateUniqueString() + 'R');

        allOrdersPage.findOrdersWithCsv(listOfInvalidTrackingId);
        put("listOfInvalidTrackingId", listOfInvalidTrackingId);
    }

    @Then("^Operator verify that the page failed to find the orders inside the CSV that contains invalid Tracking IDS on All Orders page$")
    public void operatorVerifyThatThePageFailedToFindTheOrdersInsideTheCsvThatContainsInvalidTrackingIdsOnAllOrdersPage()
    {
        List<String> listOfInvalidTrackingId = get("listOfInvalidTrackingId");
        allOrdersPage.verifyInvalidTrackingIdsIsFailedToFind(listOfInvalidTrackingId);
    }

    @When("^Operator Force Success single order on All Orders page$")
    public void operatorForceSuccessSingleOrderOnAllOrdersPage()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        allOrdersPage.forceSuccessSingleOrder(trackingId);
    }

    @Then("^Operator verify the order is Force Successed successfully$")
    public void operatorVerifyTheOrderIsForceSucceedSuccessfully()
    {
        Order order = get(KEY_CREATED_ORDER);
        allOrdersPage.verifyOrderIsForceSuccessedSuccessfully(order);
    }

    @When("^Operator RTS single order on next day on All Orders page$")
    public void operatorRtsSingleOrderOnNextDayOnAllOrdersPage()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        allOrdersPage.rtsSingleOrderNextDay(trackingId);
    }

    @When("^Operator cancel multiple orders on All Orders page$")
    public void operatorCancelMultipleOrdersOnAllOrdersPage()
    {
        List<Order> listOfCreatedOrder = get(KEY_LIST_OF_CREATED_ORDER);
        List<String> listOfTrackingIds = listOfCreatedOrder.stream().map(Order::getTrackingId).collect(Collectors.toList());
        allOrdersPage.cancelSelected(listOfTrackingIds);
    }

    @When("^Operator cancel order on All Orders page$")
    public void operatorCancelOrderOnAllOrdersPage()
    {
        String trackingID = get(KEY_CREATED_ORDER_TRACKING_ID);
        allOrdersPage.cancelSelected(Collections.singletonList(trackingID));
    }

    @When("^Operator pull out multiple orders from route on All Orders page$")
    public void operatorPullOutMultipleOrdersFromRouteOnAllOrdersPage()
    {
        List<Order> listOfCreatedOrder = get(KEY_LIST_OF_CREATED_ORDER);
        List<String> listOfTrackingIds = listOfCreatedOrder.stream().map(Order::getTrackingId).collect(Collectors.toList());
        allOrdersPage.pullOutFromRoute(listOfTrackingIds);
    }

    @When("^Operator add multiple orders to route on All Orders page$")
    public void operatorAddMultipleOrdersToRouteOnAllOrdersPage()
    {
        List<Order> listOfCreatedOrder = get(KEY_LIST_OF_CREATED_ORDER);
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        List<String> listOfTrackingIds = listOfCreatedOrder.stream().map(Order::getTrackingId).collect(Collectors.toList());
        allOrdersPage.addToRoute(listOfTrackingIds, routeId);
    }

    @When("^Operator print Waybill for single order on All Orders page$")
    public void operatorPrintWaybillForSingleOrderOnAllOrdersPage()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        allOrdersPage.printWaybill(trackingId);
    }

    @Then("^Operator verify the printed waybill for single order on All Orders page contains correct info$")
    public void operatorVerifyThePrintedWaybillForSingleOrderOnAllOrdersPageContainsCorrectInfo()
    {
        Order order = get(KEY_CREATED_ORDER);
        allOrdersPage.verifyWaybillContentsIsCorrect(order);
    }

    @Then("^Operator verify order info after Global Inbound$")
    public void operatorVerifyOrderInfoAfterGlobalInbound()
    {
        operatorVerifyFollowingOrderInfoParametersAfterGlobalInbound(ImmutableMap.of(
                "orderStatus", "TRANSIT",
                "granularStatus", "Arrived at Sorting Hub; Arrived at Origin Hub",
                "deliveryStatus", "PENDING"));
    }

    @Then("^Operator verify following order info parameters after Global Inbound$")
    public void operatorVerifyFollowingOrderInfoParametersAfterGlobalInbound(Map<String, String> mapOfData)
    {
        Order createdOrder = get(KEY_CREATED_ORDER);
        GlobalInboundParams globalInboundParams = get(KEY_GLOBAL_INBOUND_PARAMS);
        Double currentOrderCost = get(KEY_CURRENT_ORDER_COST);
        String expectedStatus = mapOfData.get("orderStatus");
        String expectedGranularStatusStr = mapOfData.get("granularStatus");
        List<String> expectedGranularStatus = null;
        if (StringUtils.isNotBlank(expectedGranularStatusStr))
        {
            expectedGranularStatus = Arrays.stream(expectedGranularStatusStr.split(";")).map(String::trim).collect(Collectors.toList());
        }
        String expectedDeliveryStatus = mapOfData.get("deliveryStatus");
        allOrdersPage.verifyOrderInfoAfterGlobalInbound(createdOrder, globalInboundParams, currentOrderCost, expectedStatus, expectedGranularStatus, expectedDeliveryStatus);
    }

    @When("^Operator resume order on All Orders page$")
    public void operatorResumeOrderOnAllOrdersPage()
    {
        List<String> trackingIds = Collections.singletonList(get(KEY_CREATED_ORDER_TRACKING_ID));
        allOrdersPage.openFiltersForm();
        allOrdersPage.findOrdersWithCsv(trackingIds);
        allOrdersPage.resumeSelected(trackingIds);
    }

    @Then("^Operator verify order status is \"(.+)\"$")
    public void operatorVerifyOrderStatusIs(String expectedOrderStatus)
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        allOrdersPage.openFiltersForm();
        allOrdersPage.findOrdersWithCsv(Collections.singletonList(trackingId));
        allOrdersPage.verifyOrderStatus(trackingId, expectedOrderStatus);
    }

    @When("^Operator apply \"(.+)\" action to created orders$")
    public void operatorApplyActionToCreatedOrders(String actionName)
    {
        List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
        AllOrdersAction action = AllOrdersAction.valueOf(actionName.toUpperCase().replaceAll("\\s", "_"));
        allOrdersPage.applyActionToOrdersByTrackingId(trackingIds, action);
    }

    @When("^Operator apply \"Pull From Route\" action and expect to see \"Selection Error\"$")
    public void operatorApplyPullFromRouteActionAndExpectToSeeSelectionError()
    {
        List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
        allOrdersPage.pullOutFromRouteWithExpectedSelectionError(trackingIds);
    }

    @Then("^Operator verify Selection Error dialog for invalid Pull From Order action$")
    public void operatorVerifySelectionErrorDialogForInvalidPullFromOrderAction()
    {
        List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
        List<String> expectedFailureReasons = new ArrayList<>(trackingIds.size());
        Collections.fill(expectedFailureReasons, "No route found to unroute");
        allOrdersPage.verifySelectionErrorDialog(trackingIds, AllOrdersAction.PULL_FROM_ROUTE, expectedFailureReasons);
    }

    @When("^Operator open page of the created order from All Orders page$")
    public void operatorOpenPageOfTheCreatedOrderFromAllOrdersPage()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        Long orderId = get(KEY_CREATED_ORDER_ID);
        operatorOpenPageOfOrderFromAllOrdersPage(ImmutableMap.of(
                "trackingId", trackingId,
                "orderId", String.valueOf(orderId)
        ));
    }

    @When("^Operator open page of an order from All Orders page using data below:$")
    public void operatorOpenPageOfOrderFromAllOrdersPage(Map<String, String> data)
    {
        data = resolveKeyValues(data);
        String trackingId = data.get("trackingId");
        Long orderId = Long.parseLong(data.get("orderId"));
        String mainWindowHandle = allOrdersPage.getWebDriver().getWindowHandle();
        put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
        allOrdersPage.waitUntilPageLoaded();
        allOrdersPage.categorySelect.selectValue(AllOrdersPage.Category.TRACKING_OR_STAMP_ID.getValue());
        allOrdersPage.searchLogicSelect.selectValue(AllOrdersPage.SearchLogic.EXACTLY_MATCHES.getValue());
        retryIfRuntimeExceptionOccurred(() ->
        {
            allOrdersPage.searchTerm.selectValue(trackingId);
            pause1s();
            allOrdersPage.waitUntilPageLoaded();
            allOrdersPage.switchToEditOrderWindow(orderId);
        }, f("Open Edit Order page for order [%s]", trackingId), 1000, 3);
    }

    @Then("Operator verifies tha searched Tracking ID is the same to the created one")
    public void operatorVerifiesThaSearchedTrackingIDIsTheSameToTheCreatedOne()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        allOrdersPage.verifiesTrackingIdIsCorrect(trackingId);
    }

    @Then("^Operator verifies All Orders Page is displayed$")
    public void operatorVerifiesAllOrdersPageIsDispalyed()
    {
        allOrdersPage.verifyItsCurrentPage();
    }

    @When("^Operator RTS multiple orders on next day on All Orders page$")
    public void operatorRtsMultipleOrdersOnNextDayOnAllOrdersPage()
    {
        List<Order> listOfCreatedOrder = get(KEY_LIST_OF_CREATED_ORDER);
        List<String> listOfTrackingIds = listOfCreatedOrder.stream().map(Order::getTrackingId).collect(Collectors.toList());
        allOrdersPage.rtsMultipleOrderNextDay(listOfTrackingIds);
    }

    @Then("Operator verifies latest event is {string}")
    public void operatorVerifiesLatestEventIs(String latestEvent)
    {
        Order createdOrder = get(KEY_CREATED_ORDER);
        allOrdersPage.verifyLatestEvent(createdOrder, latestEvent);
    }
}
