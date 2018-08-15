package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.RouteCashInboundCod;
import co.nvqa.operator_v2.model.RouteCleaningReportCodInfo;
import co.nvqa.operator_v2.selenium.page.RouteCleaningReportPage;
import com.google.inject.Inject;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.StringUtils;

import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteCleaningReportSteps extends AbstractSteps
{
    private RouteCleaningReportPage routeCleaningReportPage;
    private static final String KEY_LIST_OF_COD_INFO = "KEY_LIST_OF_COD_INFO";

    @Inject
    public RouteCleaningReportSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        routeCleaningReportPage = new RouteCleaningReportPage(getWebDriver());
    }

    @When("^Operator download Excel report on Route Cleaning Report page$")
    public void operatorDownloadExcelReportOnRouteCleaningReportPage()
    {
        routeCleaningReportPage.clickButtonDownloadCSVReport();
    }

    @When("^Operator download Excel report on Route Cleaning Report page successfully$")
    public void operatorDownloadExcelReportOnRouteCleaningReportPageSuccessfully()
    {
        routeCleaningReportPage.verifyCSVFileIsDownloadedSuccessfully();
    }

    @And("^Operator Select COD on Route Cleaning Report page$")
    public void operatorSelectCODOnRouteCleaningReportPage()
    {
        routeCleaningReportPage.selectCOD();
    }

    @And("^Operator fetch by current date on Route Cleaning Report page$")
    public void operatorFetchByCurrentDateOnRouteCleaningReportPage()
    {
        routeCleaningReportPage.fetchByDate(new Date());
    }

    @Then("^Operator verify the COD information on Route Cleaning Report page by following parameters:$")
    public void operatorVerifyTheCODInformationOnRouteCleaningReportPageByFollowingParameters(Map<String, String> mapOfData)
    {
        Map<String, String> adjustedData = new HashMap<>(mapOfData);
        RouteCleaningReportCodInfo expectedCodInfo = new RouteCleaningReportCodInfo();
        String value = adjustedData.get("codInbound");

        if(StringUtils.isNotBlank(value))
        {
            if("GET_FROM_CREATED_COD".equalsIgnoreCase(value))
            {
                RouteCashInboundCod routeCashInboundCod = get(KEY_ROUTE_CASH_INBOUND_COD);
                adjustedData.put("codInbound", String.valueOf(routeCashInboundCod.getAmountCollected()));
            }
        }

        value = adjustedData.get("codExpected");

        if(StringUtils.isNotBlank(value))
        {
            if("GET_FROM_CREATED_ORDER".equalsIgnoreCase(value))
            {
                Order order = get(KEY_CREATED_ORDER);
                adjustedData.put("codExpected", String.valueOf(order.getCod().getGoodsAmount()));
            }
        }

        value = adjustedData.get("routeId");

        if(StringUtils.isNotBlank(value))
        {
            if("GET_FROM_CREATED_ROUTE".equalsIgnoreCase(value))
            {
                adjustedData.put("routeId", String.valueOf((Long) get(KEY_CREATED_ROUTE_ID)));
            }
        }

        expectedCodInfo.fromMap(adjustedData);
        routeCleaningReportPage.verifyCodInfo(expectedCodInfo);
    }

    @Then("^Operator download CSV for the new COD on Route Cleaning Report page$")
    public void operatorDownloadCSVForTheNewCODOnRouteCleaningReportPage()
    {
        RouteCashInboundCod routeCashInboundCod = get(KEY_ROUTE_CASH_INBOUND_COD);
        routeCleaningReportPage.downloadCsvForSelectedCOD(Collections.singletonList(String.valueOf(routeCashInboundCod.getRouteId())));
    }

    @And("^Operator verify the COD info is correct in downloaded CSV file$")
    public void operatorVerifyTheCODInfoIsCorrectInDownloadedCSVFile()
    {
        List<RouteCleaningReportCodInfo> expectedCODInfo = get(KEY_LIST_OF_COD_INFO);
        routeCleaningReportPage.verifyDownloadedCodCsvFileContent(expectedCODInfo);
    }

    @And("^Operator collect COD info for the route$")
    public void operatorCollectCODInfoForTheRoute()
    {
        RouteCashInboundCod routeCashInboundCod = get(KEY_ROUTE_CASH_INBOUND_COD);
        routeCleaningReportPage.codTable().filterByColumn(RouteCleaningReportPage.CodTable.COLUMN_ROUTE_ID, String.valueOf(routeCashInboundCod.getRouteId()));
        put(KEY_LIST_OF_COD_INFO, routeCleaningReportPage.codTable().readAllEntities());
    }
}
