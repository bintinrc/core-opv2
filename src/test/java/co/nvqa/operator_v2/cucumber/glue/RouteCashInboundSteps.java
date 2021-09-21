package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Cod;
import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.model.RouteCashInboundCod;
import co.nvqa.operator_v2.selenium.page.RouteCashInboundPage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;

import static co.nvqa.operator_v2.selenium.page.RouteCashInboundPage.RouteCashInboundTable.ACTION_EDIT;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteCashInboundSteps extends AbstractSteps {

  private RouteCashInboundPage routeCashInboundPage;

  public RouteCashInboundSteps() {
  }

  @Override
  public void init() {
    routeCashInboundPage = new RouteCashInboundPage(getWebDriver());
  }

  @When("^Operator create new COD on Route Cash Inbound page$")
  public void operatorCreateNewCod() {
    Order order = get(KEY_CREATED_ORDER);
    Long routeId = get(KEY_CREATED_ROUTE_ID);

    Cod cod = order.getCod();
    assertNotNull("COD should not be null.", cod);
    Double codGoodsAmount = cod.getGoodsAmount();
    assertNotNull("COD Goods Amount should not be null.", codGoodsAmount);

    Double amountCollected = codGoodsAmount - (codGoodsAmount.intValue() / 2);
    String receiptNumber = "#" + routeId + "-" + generateDateUniqueString();

    RouteCashInboundCod routeCashInboundCod = new RouteCashInboundCod();
    routeCashInboundCod.setRouteId(routeId);
    routeCashInboundCod.setTotalCollected(amountCollected);
    routeCashInboundCod.setAmountCollected(amountCollected);
    routeCashInboundCod.setReceiptNumber(receiptNumber);

    routeCashInboundPage.inFrame(() -> {
      routeCashInboundPage.waitUntilLoaded(2);
      routeCashInboundPage.addCod.click();
      routeCashInboundPage.addCodDialog.waitUntilVisible();
      routeCashInboundPage.addCodDialog.routeId.setValue(routeCashInboundCod.getRouteId());
      routeCashInboundPage.addCodDialog.amountCollected.setValue(
          routeCashInboundCod.getAmountCollected());
      routeCashInboundPage.addCodDialog.receiptNumber.setValue(
          routeCashInboundCod.getReceiptNumber());
      routeCashInboundPage.addCodDialog.submit.clickAndWaitUntilDone();
    });
    put(KEY_ROUTE_CASH_INBOUND_COD, routeCashInboundCod);
    put(KEY_COD_GOODS_AMOUNT, codGoodsAmount);
  }

  @Then("^Operator verify the new COD on Route Cash Inbound page is created successfully$")
  public void operatorVerifyTheNewCodIsCreatedSuccessfully() {
    RouteCashInboundCod routeCashInboundCod = get(KEY_ROUTE_CASH_INBOUND_COD);
    RouteCashInboundCod clone = new RouteCashInboundCod(routeCashInboundCod);
    clone.setAmountCollected(String.valueOf(clone.getDoubleAmountCollected()));
    routeCashInboundPage.inFrame(() -> {
      routeCashInboundPage.searchAndVerifyTableIsNotEmpty(clone);
      routeCashInboundPage.verifyCodInfoIsCorrect(clone);
    });
  }

  @Then("^Operator check filter on Route Cash Inbound page work fine$")
  public void operatorCheckFilterOnRouteCashInboundPageWork() {
    RouteCashInboundCod routeCashInboundCod = get(KEY_ROUTE_CASH_INBOUND_COD);
    RouteCashInboundCod clone = new RouteCashInboundCod(routeCashInboundCod);
    clone.setAmountCollected(String.valueOf(clone.getDoubleAmountCollected()));
    routeCashInboundPage.inFrame(() ->
        routeCashInboundPage.verifyFilterWorkFine(clone)
    );
  }

  @When("^Operator update the new COD on Route Cash Inbound page$")
  public void operatorUpdateTheNewCod() {
    RouteCashInboundCod routeCashInboundCod = get(KEY_ROUTE_CASH_INBOUND_COD);

    Double oldTotalCollected = routeCashInboundCod.getTotalCollected();
    Double newTotalCollected = oldTotalCollected + (oldTotalCollected.intValue() / 2);

    RouteCashInboundCod routeCashInboundCodEdited = new RouteCashInboundCod();
    routeCashInboundCodEdited.setRouteId(routeCashInboundCod.getRouteId());
    routeCashInboundCodEdited.setTotalCollected(newTotalCollected);
    routeCashInboundCodEdited.setAmountCollected(newTotalCollected);
    routeCashInboundCodEdited.setReceiptNumber(routeCashInboundCod.getReceiptNumber() + "-EDITED");

    routeCashInboundPage.inFrame(() ->
        retryIfRuntimeExceptionOccurred(() ->
        {
          routeCashInboundPage.searchAndVerifyTableIsNotEmpty(routeCashInboundCod);
          routeCashInboundPage.routeCashInboundTable.clickActionButton(1, ACTION_EDIT);
          routeCashInboundPage.editCodDialog.waitUntilVisible();
          routeCashInboundPage.editCodDialog.routeId.setValue(
              routeCashInboundCodEdited.getRouteId());
          routeCashInboundPage.editCodDialog.amountCollected.setValue(
              routeCashInboundCodEdited.getAmountCollected());
          routeCashInboundPage.editCodDialog.receiptNumber.setValue(
              routeCashInboundCodEdited.getReceiptNumber());
          routeCashInboundPage.editCodDialog.submit.click();
        })
    );
    put(KEY_ROUTE_CASH_INBOUND_COD_EDITED, routeCashInboundCodEdited);
  }

  @Then("^Operator verify the new COD on Route Cash Inbound page is updated successfully$")
  public void operatorVerifyTheNewZoneIsUpdatedSuccessfully() {
    RouteCashInboundCod routeCashInboundCodEdited = get(KEY_ROUTE_CASH_INBOUND_COD_EDITED);
    RouteCashInboundCod clone = new RouteCashInboundCod(routeCashInboundCodEdited);
    clone.setAmountCollected(String.valueOf(clone.getDoubleAmountCollected()));
    routeCashInboundPage.inFrame(() ->
        routeCashInboundPage.verifyCodIsUpdatedSuccessfully(clone));
  }

  @When("^Operator delete the new COD on Route Cash Inbound page$")
  public void operatorDeleteTheNewZone() {
    RouteCashInboundCod routeCashInboundCod =
        containsKey(KEY_ROUTE_CASH_INBOUND_COD_EDITED) ? get(KEY_ROUTE_CASH_INBOUND_COD_EDITED)
            : get(KEY_ROUTE_CASH_INBOUND_COD);
    routeCashInboundPage.inFrame(() -> {
      routeCashInboundPage.waitUntilLoaded(3);
      routeCashInboundPage.deleteCod(routeCashInboundCod);
    });
  }

  @Then("^Operator verify the new COD on Route Cash Inbound page is deleted successfully$")
  public void operatorVerifyTheNewCodIsDeletedSuccessfully() {
    RouteCashInboundCod routeCashInboundCod =
        containsKey(KEY_ROUTE_CASH_INBOUND_COD_EDITED) ? get(KEY_ROUTE_CASH_INBOUND_COD_EDITED)
            : get(KEY_ROUTE_CASH_INBOUND_COD);
    routeCashInboundPage.inFrame(() ->
        routeCashInboundPage.verifyCodIsDeletedSuccessfully(routeCashInboundCod));
  }

  @When("^Operator download COD CSV file on Route Cash Inbound page$")
  public void operatorDownloadCodCsvFile() {
    routeCashInboundPage.inFrame(() -> routeCashInboundPage.downloadCsv.click());
  }

  @Then("^Operator verify COD CSV file on Route Cash Inbound page is downloaded successfully$")
  public void operatorVerifyCodCsvFileIsDownloadSuccessfully() {
    RouteCashInboundCod routeCashInboundCod = get(KEY_ROUTE_CASH_INBOUND_COD);
    routeCashInboundPage.verifyCsvFileDownloadedSuccessfully(routeCashInboundCod);
  }
}
