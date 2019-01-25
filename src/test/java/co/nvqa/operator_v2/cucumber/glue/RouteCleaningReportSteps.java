package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.model.RouteCashInboundCod;
import co.nvqa.operator_v2.model.RouteCleaningReportCodInfo;
import co.nvqa.operator_v2.model.RouteCleaningReportParcelInfo;
import co.nvqa.operator_v2.selenium.page.RouteCleaningReportPage;
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

import static co.nvqa.operator_v2.selenium.page.RouteCleaningReportPage.CodTable.COLUMN_ROUTE_ID;
import static co.nvqa.operator_v2.selenium.page.RouteCleaningReportPage.ParcelTable.COLUMN_TRACKING_ID;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteCleaningReportSteps extends AbstractSteps
{
    private RouteCleaningReportPage routeCleaningReportPage;
    private static final String KEY_LIST_OF_COD_INFO = "KEY_LIST_OF_COD_INFO";
    private static final String KEY_PARCEL_INFO = "KEY_PARCEL_INFO";

    public RouteCleaningReportSteps()
    {
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
        routeCleaningReportPage.codTable().filterByColumn(COLUMN_ROUTE_ID, String.valueOf(routeCashInboundCod.getRouteId()));
        put(KEY_LIST_OF_COD_INFO, routeCleaningReportPage.codTable().readAllEntities());
    }

    @And("^Operator collect Parcel info for the created order on Route Cleaning Report page$")
    public void operatorCollectParcelInfoForTheCreatedOrderOnRouteCleaningReportPage()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        routeCleaningReportPage.parcelTable().filterByColumn(COLUMN_TRACKING_ID, trackingId);
        put(KEY_PARCEL_INFO, routeCleaningReportPage.parcelTable().readEntity(1));
    }

    @And("^Operator Select Parcel on Route Cleaning Report page$")
    public void operatorSelectParcelOnRouteCleaningReportPage()
    {
        routeCleaningReportPage.selectParcel();
    }

    @Then("^Operator download CSV for the created order on Route Cleaning Report page$")
    public void operatorDownloadCSVForTheCreatedOrderOnRouteCleaningReportPage()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        routeCleaningReportPage.downloadCsvForSelectedParcel(Collections.singletonList(trackingId));
    }

    @And("^Operator verify the Parcel info is correct in downloaded CSV file$")
    public void operatorVerifyTheParcelInfoIsCorrectInDownloadedCSVFile()
    {
        RouteCleaningReportParcelInfo parcelInfo = get(KEY_PARCEL_INFO);
        routeCleaningReportPage.verifyDownloadedParcelCsvFileContent(Collections.singletonList(parcelInfo));
    }

    @And("^Operator verify the Parcel info for the created order is correct on Route Cleaning Report page by following parameters:$")
    public void operatorVerifyTheParcelInfoForTheCreatedOrderIsCorrectOnRouteCleaningReportPageByFollowingParameters(Map<String, String> mapOfData)
    {
        Map<String, String> adjustedData = new HashMap<>(mapOfData);
        RouteCleaningReportParcelInfo expectedParcelInfo = new RouteCleaningReportParcelInfo();
        String value = adjustedData.get("trackingId");

        if(StringUtils.isNotBlank(value))
        {
            if("GET_FROM_CREATED_ORDER".equalsIgnoreCase(value))
            {
                adjustedData.put("trackingId", get(KEY_CREATED_ORDER_TRACKING_ID));
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

        expectedParcelInfo.fromMap(adjustedData);
        routeCleaningReportPage.verifyParcelInfo(expectedParcelInfo);
    }

    @Then("^Operator create ticket for the created order on Route Cleaning Report page$")
    public void operatorCreateTicketForTheCreatedOrderOnRouteCleaningReportPage()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        routeCleaningReportPage.createTicketForParcel(trackingId);
    }

    @Then("^Operator verify ticket was created for the created order on Route Cleaning Report page$")
    public void operatorVerifyTicketWasCreatedForTheCreatedOrderOnRouteCleaningReportPage()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        routeCleaningReportPage.verifyTickedForParcelWasCreated(trackingId);
    }
}
