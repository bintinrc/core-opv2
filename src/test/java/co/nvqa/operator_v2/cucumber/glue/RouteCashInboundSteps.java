package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Cod;
import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.model.RouteCashInboundCod;
import co.nvqa.operator_v2.selenium.page.RouteCashInboundPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteCashInboundSteps extends AbstractSteps
{
    private RouteCashInboundPage routeCashInboundPage;

    public RouteCashInboundSteps()
    {
    }

    @Override
    public void init()
    {
        routeCashInboundPage = new RouteCashInboundPage(getWebDriver());
    }

    @When("^Operator create new COD on Route Cash Inbound page$")
    public void operatorCreateNewCod()
    {
        Order order = get(KEY_CREATED_ORDER);
        Long routeId = get(KEY_CREATED_ROUTE_ID);

        Cod cod = order.getCod();
        assertNotNull("COD should not be null.", cod);
        Double codGoodsAmount = cod.getGoodsAmount();
        assertNotNull("COD Goods Amount should not be null.", codGoodsAmount);

        Double amountCollected = codGoodsAmount-(codGoodsAmount.intValue()/2);
        String receiptNumber = "#"+routeId+"-"+generateDateUniqueString();

        RouteCashInboundCod routeCashInboundCod = new RouteCashInboundCod();
        routeCashInboundCod.setRouteId(routeId);
        routeCashInboundCod.setAmountCollected(amountCollected);
        routeCashInboundCod.setReceiptNumber(receiptNumber);

        routeCashInboundPage.addCod(routeCashInboundCod);
        put(KEY_ROUTE_CASH_INBOUND_COD, routeCashInboundCod);
        put(KEY_COD_GOODS_AMOUNT, codGoodsAmount);
    }

    @Then("^Operator verify the new COD on Route Cash Inbound page is created successfully$")
    public void operatorVerifyTheNewCodIsCreatedSuccessfully()
    {
        RouteCashInboundCod routeCashInboundCod = get(KEY_ROUTE_CASH_INBOUND_COD);
        routeCashInboundPage.verifyNewCodIsCreatedSuccessfully(routeCashInboundCod);
    }

    @Then("^Operator check filter on Route Cash Inbound page work fine$")
    public void operatorCheckFilterOnRouteCashInboundPageWork()
    {
        RouteCashInboundCod routeCashInboundCod = get(KEY_ROUTE_CASH_INBOUND_COD);
        routeCashInboundPage.verifyFilterWorkFine(routeCashInboundCod);
    }

    @When("^Operator update the new COD on Route Cash Inbound page$")
    public void operatorUpdateTheNewCod()
    {
        RouteCashInboundCod routeCashInboundCod = get(KEY_ROUTE_CASH_INBOUND_COD);

        Double oldAmountCollected = routeCashInboundCod.getAmountCollected();
        Double newAmountCollected = oldAmountCollected+(oldAmountCollected.intValue()/2);

        RouteCashInboundCod routeCashInboundCodEdited = new RouteCashInboundCod();
        routeCashInboundCodEdited.setRouteId(routeCashInboundCod.getRouteId());
        routeCashInboundCodEdited.setAmountCollected(newAmountCollected);
        routeCashInboundCodEdited.setReceiptNumber(routeCashInboundCod.getReceiptNumber()+"-EDITED");


        routeCashInboundPage.editCod(routeCashInboundCod, routeCashInboundCodEdited);
        put(KEY_ROUTE_CASH_INBOUND_COD_EDITED, routeCashInboundCodEdited);
    }

    @Then("^Operator verify the new COD on Route Cash Inbound page is updated successfully$")
    public void operatorVerifyTheNewZoneIsUpdatedSuccessfully()
    {
        RouteCashInboundCod routeCashInboundCodEdited = get(KEY_ROUTE_CASH_INBOUND_COD_EDITED);
        routeCashInboundPage.verifyCodIsUpdatedSuccessfully(routeCashInboundCodEdited);
    }

    @When("^Operator delete the new COD on Route Cash Inbound page$")
    public void operatorDeleteTheNewZone()
    {
        RouteCashInboundCod routeCashInboundCod = containsKey(KEY_ROUTE_CASH_INBOUND_COD_EDITED) ? get(KEY_ROUTE_CASH_INBOUND_COD_EDITED) : get(KEY_ROUTE_CASH_INBOUND_COD);
        routeCashInboundPage.deleteCod(routeCashInboundCod);
    }

    @Then("^Operator verify the new COD on Route Cash Inbound page is deleted successfully$")
    public void operatorVerifyTheNewCodIsDeletedSuccessfully()
    {
        RouteCashInboundCod routeCashInboundCod = containsKey(KEY_ROUTE_CASH_INBOUND_COD_EDITED) ? get(KEY_ROUTE_CASH_INBOUND_COD_EDITED) : get(KEY_ROUTE_CASH_INBOUND_COD);
        routeCashInboundPage.verifyCodIsDeletedSuccessfully(routeCashInboundCod);
    }

    @When("^Operator download COD CSV file on Route Cash Inbound page$")
    public void operatorDownloadCodCsvFile()
    {
        routeCashInboundPage.downloadCsvFile();
    }

    @Then("^Operator verify COD CSV file on Route Cash Inbound page is downloaded successfully$")
    public void operatorVerifyCodCsvFileIsDownloadSuccessfully()
    {
        RouteCashInboundCod routeCashInboundCod = get(KEY_ROUTE_CASH_INBOUND_COD);
        routeCashInboundPage.verifyCsvFileDownloadedSuccessfully(routeCashInboundCod);
    }
}
