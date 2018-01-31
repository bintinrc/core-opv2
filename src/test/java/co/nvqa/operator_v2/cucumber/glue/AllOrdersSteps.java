package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.order_create.v2.OrderRequestV2;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.AllOrdersPage;
import com.google.inject.Inject;
import cucumber.api.DataTable;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
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
}
