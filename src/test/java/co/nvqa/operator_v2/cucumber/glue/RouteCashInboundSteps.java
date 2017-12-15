package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.order_create.v2.OrderRequestV2;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.RouteCashInboundCod;
import co.nvqa.operator_v2.selenium.page.RouteCashInboundPage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteCashInboundSteps extends AbstractSteps
{
    private RouteCashInboundPage routeCashInboundPage;

    @Inject
    public RouteCashInboundSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        routeCashInboundPage = new RouteCashInboundPage(getWebDriver());
    }

    @When("^Operator create new COD on Route Cash Inbound page$")
    public void operatorCreateNewCod()
    {
        OrderRequestV2 orderV2 = get(KEY_CREATED_ORDER);
        int routeId = get(KEY_CREATED_ROUTE_ID);

        Double codGoods = orderV2.getCodGoods();
        Assert.assertNotNull("COD Goods should not be null.", codGoods);
        Double amountCollected = codGoods-(codGoods.intValue()/2);
        String receiptNumber = "#"+routeId+"-"+generateDateUniqueString();

        RouteCashInboundCod routeCashInboundCod = new RouteCashInboundCod();
        routeCashInboundCod.setRouteId(routeId);
        routeCashInboundCod.setAmountCollected(amountCollected);
        routeCashInboundCod.setReceiptNumber(receiptNumber);

        routeCashInboundPage.addCod(routeCashInboundCod);
        put("routeCashInboundCod", routeCashInboundCod);
    }

    @Then("^Operator verify the new COD on Route Cash Inbound page is created successfully$")
    public void operatorVerifyTheNewCodIsCreatedSuccessfully()
    {
        RouteCashInboundCod routeCashInboundCod = get("routeCashInboundCod");
        routeCashInboundPage.verifyNewCodIsCreatedSuccessfully(routeCashInboundCod);
    }

    @Then("^Operator check filter on Route Cash Inbound page work fine$")
    public void operatorCheckFilterOnRouteCashInboundPageWork()
    {
        RouteCashInboundCod routeCashInboundCod = get("routeCashInboundCod");
        routeCashInboundPage.verifyFilterWorkFine(routeCashInboundCod);
    }

    @When("^Operator update the new COD on Route Cash Inbound page$")
    public void operatorUpdateTheNewCod()
    {
        RouteCashInboundCod routeCashInboundCod = get("routeCashInboundCod");

        Double oldAmountCollected = routeCashInboundCod.getAmountCollected();
        Double newAmountCollected = oldAmountCollected+(oldAmountCollected.intValue()/2);

        RouteCashInboundCod routeCashInboundCodEdited = new RouteCashInboundCod();
        routeCashInboundCodEdited.setRouteId(routeCashInboundCod.getRouteId());
        routeCashInboundCodEdited.setAmountCollected(newAmountCollected);
        routeCashInboundCodEdited.setReceiptNumber(routeCashInboundCod.getReceiptNumber()+"-EDITED");


        routeCashInboundPage.editCod(routeCashInboundCod, routeCashInboundCodEdited);
        put("routeCashInboundCodEdited", routeCashInboundCodEdited);
    }

    @Then("^Operator verify the new COD on Route Cash Inbound page is updated successfully$")
    public void operatorVerifyTheNewZoneIsUpdatedSuccessfully()
    {
        RouteCashInboundCod routeCashInboundCodEdited = get("routeCashInboundCodEdited");
        routeCashInboundPage.verifyCodIsUpdatedSuccessfully(routeCashInboundCodEdited);
    }

    @When("^Operator delete the new COD on Route Cash Inbound page$")
    public void operatorDeleteTheNewZone()
    {
        RouteCashInboundCod routeCashInboundCod = containsKey("routeCashInboundCodEdited") ? get("routeCashInboundCodEdited") : get("routeCashInboundCod");
        routeCashInboundPage.deleteCod(routeCashInboundCod);
    }

    @Then("^Operator verify the new COD on Route Cash Inbound page is deleted successfully$")
    public void operatorVerifyTheNewCodIsDeletedSuccessfully()
    {
        RouteCashInboundCod routeCashInboundCod = containsKey("routeCashInboundCodEdited") ? get("routeCashInboundCodEdited") : get("routeCashInboundCod");
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
        RouteCashInboundCod routeCashInboundCod = get("routeCashInboundCod");
        routeCashInboundPage.verifyCsvFileDownloadedSuccessfully(routeCashInboundCod);
    }
}
