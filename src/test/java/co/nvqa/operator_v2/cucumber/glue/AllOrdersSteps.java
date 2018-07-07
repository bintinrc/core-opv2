package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.order_create.v2.OrderRequestV2;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.GlobalInboundParams;
import co.nvqa.operator_v2.selenium.page.AllOrdersPage;
import co.nvqa.operator_v2.selenium.page.AllOrdersPage.ApplyActionsMenu.AllOrdersAction;
import com.google.common.collect.ImmutableMap;
import com.google.inject.Inject;
import cucumber.api.DataTable;
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

    @Inject
    public AllOrdersSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
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
    public void operatorFindOrderOnAllOrdersPageUsingThisCriteriaBelow(DataTable dataTable)
    {
        Map<String, String> mapOfData = dataTable.asMap(String.class, String.class);

        AllOrdersPage.Category category = AllOrdersPage.Category.findByValue(mapOfData.get("category"));
        AllOrdersPage.SearchLogic searchLogic = AllOrdersPage.SearchLogic.findByValue(mapOfData.get("searchLogic"));
        String searchTerm = mapOfData.get("searchTerm");

        /*
          Replace searchTerm value to value on ScenarioStorage.
         */
        if (containsKey(searchTerm))
        {
            searchTerm = get(searchTerm);
        }

        String mainWindowHandle = allOrdersPage.getWebDriver().getWindowHandle();
        allOrdersPage.specificSearch(category, searchLogic, searchTerm);
        put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
    }

    @When("^Operator filter the result table by Tracking ID on All Orders page and verify order info is correct$")
    public void operatorFilterTheResultTableByTrackingIdOnAllOrdersPageAndVerifyOrderInfoIsCorrect()
    {
        OrderRequestV2 orderRequestV2 = get(KEY_CREATED_ORDER);
        Order order = get(KEY_ORDER_DETAILS);
        allOrdersPage.verifyOrderInfoOnTableOrderIsCorrect(orderRequestV2, order);
    }

    @Then("^Operator verify the new pending pickup order is found on All Orders page with correct info$")
    public void operatorVerifyTheNewPendingPickupOrderIsFoundOnAllOrdersPageWithCorrectInfo()
    {
        OrderRequestV2 orderRequestV2 = get(KEY_CREATED_ORDER);
        Order order = get(KEY_ORDER_DETAILS);
        allOrdersPage.verifyOrderInfoIsCorrect(orderRequestV2, order);
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

        allOrdersPage.findOrdersWithCsvAndWaitUntilToastDisappear(Collections.singletonList(createdTrackingId));
    }

    @Then("^Operator verify all orders in CSV is found on All Orders page with correct info$")
    public void operatorVerifyAllOrdersInCsvIsFoundOnAllOrdersPageWithCorrectInfo()
    {
        List<OrderRequestV2> listOfOrderRequestV2 = get(KEY_LIST_OF_CREATED_ORDER);

        if (listOfOrderRequestV2 == null || listOfOrderRequestV2.isEmpty())
        {
            throw new RuntimeException("List of created order should not be null or empty.");
        }

        List<Order> listOfOrderDetails = get(KEY_LIST_OF_ORDER_DETAILS);

        if (listOfOrderDetails == null || listOfOrderDetails.isEmpty())
        {
            throw new RuntimeException("List of order details should not be null or empty.");
        }

        allOrdersPage.verifyAllOrdersInCsvIsFoundWithCorrectInfo(listOfOrderRequestV2, listOfOrderDetails);
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
        OrderRequestV2 orderRequestV2 = get(KEY_CREATED_ORDER);
        allOrdersPage.verifyOrderIsForceSuccessedSuccessfully(orderRequestV2);
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
        List<OrderRequestV2> orders = get(KEY_LIST_OF_CREATED_ORDER);
        List<String> listOfTrackingIds = orders.stream().map(OrderRequestV2::getTrackingId).collect(Collectors.toList());
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
        List<OrderRequestV2> orders = get(KEY_LIST_OF_CREATED_ORDER);
        List<String> listOfTrackingIds = orders.stream().map(OrderRequestV2::getTrackingId).collect(Collectors.toList());
        allOrdersPage.pullOutFromRoute(listOfTrackingIds);
    }

    @When("^Operator add multiple orders to route on All Orders page$")
    public void operatorAddMultipleOrdersToRouteOnAllOrdersPage()
    {
        List<OrderRequestV2> orders = get(KEY_LIST_OF_CREATED_ORDER);
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        List<String> listOfTrackingIds = orders.stream().map(OrderRequestV2::getTrackingId).collect(Collectors.toList());
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
        OrderRequestV2 orderRequestV2 = get(KEY_CREATED_ORDER);
        allOrdersPage.verifyWaybillContentsIsCorrect(orderRequestV2);
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
        OrderRequestV2 orderRequestV2 = get(KEY_CREATED_ORDER);
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
        allOrdersPage.verifyOrderInfoAfterGlobalInbound(orderRequestV2, globalInboundParams, currentOrderCost, expectedStatus, expectedGranularStatus, expectedDeliveryStatus);
    }

    @When("^Operator resume order on All Orders page$")
    public void operatorResumeOrderOnAllOrdersPage()
    {
        List<String> trackingIds = Collections.singletonList(get(KEY_CREATED_ORDER_TRACKING_ID));
        allOrdersPage.openFiltersForm();
        allOrdersPage.findOrdersWithCsvAndWaitUntilToastDisappear(trackingIds);
        allOrdersPage.resumeSelected(trackingIds);
    }

    @Then("^Operator verify order status is \"(.+)\"$")
    public void operatorVerifyOrderStatusIs(String expectedOrderStatus)
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        allOrdersPage.openFiltersForm();
        allOrdersPage.findOrdersWithCsvAndWaitUntilToastDisappear(Collections.singletonList(trackingId));
        allOrdersPage.verifyOrderStatus(trackingId, expectedOrderStatus);
    }

    @When("^Operator apply \"(.+)\" action to created orders$")
    public void operatorApplyActionToCreatedOrders(String actionName)
    {
        List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
        AllOrdersAction action = AllOrdersAction.valueOf(actionName.toUpperCase().replaceAll("\\s", "_"));
        allOrdersPage.applyActionToOrdersByTrackingId(trackingIds, action);
    }

    @Then("^Operator verify Selection Error dialog for invalid Pull From Order action$")
    public void operatorVerifySelectionErrorDialogForInvalidPullFromOrderAction()
    {
        List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
        List<String> expectedFailureReasons = new ArrayList<>(trackingIds.size());
        Collections.fill(expectedFailureReasons, "No route to pull from");
        allOrdersPage.verifySelectionErrorDialog(trackingIds, AllOrdersAction.PULL_FROM_ROUTE, expectedFailureReasons);
    }
}
