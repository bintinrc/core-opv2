package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.order_create.v2.OrderRequestV2;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.AllOrdersPage;
import co.nvqa.operator_v2.selenium.page.EditOrderPage;
import com.google.inject.Inject;
import cucumber.api.DataTable;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class AllOrdersSteps extends AbstractSteps
{
    private AllOrdersPage allOrdersPage;
    private EditOrderPage editOrderPage;

    @Inject
    public AllOrdersSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        editOrderPage = new EditOrderPage(getWebDriver());
        allOrdersPage = new AllOrdersPage(getWebDriver(), editOrderPage);
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
        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);

        AllOrdersPage.Category category = AllOrdersPage.Category.findByValue(mapOfData.get("category"));
        AllOrdersPage.SearchLogic searchLogic = AllOrdersPage.SearchLogic.findByValue(mapOfData.get("searchLogic"));
        String searchTerm = mapOfData.get("searchTerm");
        allOrdersPage.specificSearch(category, searchLogic, searchTerm);
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

        if(listOfCreatedTrackingId==null || listOfCreatedTrackingId.isEmpty())
        {
            throw new RuntimeException("List of created Tracking ID should not be null or empty.");
        }

        allOrdersPage.findOrdersWithCsv(listOfCreatedTrackingId);
    }

    @Then("^Operator verify all orders in CSV is found on All Orders page with correct info$")
    public void operatorVerifyAllOrdersInCsvIsFoundOnAllOrdersPageWithCorrectInfo()
    {
        List<OrderRequestV2> listOfOrderRequestV2 = get(KEY_LIST_OF_CREATED_ORDER);

        if(listOfOrderRequestV2==null || listOfOrderRequestV2.isEmpty())
        {
            throw new RuntimeException("List of created order should not be null or empty.");
        }

        List<Order> listOfOrderDetails = get(KEY_LIST_OF_ORDER_DETAILS);

        if(listOfOrderDetails==null || listOfOrderDetails.isEmpty())
        {
            throw new RuntimeException("List of order details should not be null or empty.");
        }

        allOrdersPage.verifyAllOrdersInCsvIsFoundWithCorrectInfo(listOfOrderRequestV2, listOfOrderDetails);
    }

    @When("^Operator uploads CSV that contains invalid Tracking ID on All Orders page$")
    public void operatorUploadsCsvThatContainsInvalidTrackingIdOnAllOrdersPage()
    {
        List<String> listOfInvalidTrackingId = new ArrayList<>();
        listOfInvalidTrackingId.add("DUMMY"+generateDateUniqueString()+'N');
        listOfInvalidTrackingId.add("DUMMY"+generateDateUniqueString()+'C');
        listOfInvalidTrackingId.add("DUMMY"+generateDateUniqueString()+'R');

        allOrdersPage.findOrdersWithCsv(listOfInvalidTrackingId);
        put("listOfInvalidTrackingId", listOfInvalidTrackingId);
    }

    @Then("^Operator verify that the page failed to find the orders inside the CSV that contains invalid Tracking IDS on All Orders page$")
    public void operatorVerifyThatThePageFailedToFindTheOrdersInsedeTheCsvThatContainsInvalidTrackingIdsOnAllOrdersPage()
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
    public void operatorVerifyTheOrderIsForceSuccessedSuccessfully()
    {
        OrderRequestV2 orderRequestV2 = get(KEY_CREATED_ORDER);
        allOrdersPage.verifyOrderIsForceSuccessedSuccessfully(orderRequestV2);
    }
}
