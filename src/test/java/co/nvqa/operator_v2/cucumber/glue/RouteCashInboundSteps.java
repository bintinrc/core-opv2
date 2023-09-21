package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.utils.CoreScenarioStorageKeys;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.common.core.model.order.Order.Cod;
import co.nvqa.common.core.model.order.Order;
import co.nvqa.operator_v2.model.RouteCashInboundCod;
import co.nvqa.operator_v2.selenium.page.RouteCashInboundPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.assertj.core.api.Assertions;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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

  @When("Operator create new COD on Route Cash Inbound page")
  public void operatorCreateNewCod(Map<String, String> dataTableRaw) {
    Map<String, String> dataTable = resolveKeyValues(dataTableRaw);
    Long orderId = Long.valueOf(dataTable.get("orderId"));
    Long routeId = Long.valueOf(dataTable.get("routeId"));

    List<Order> orders = get(CoreScenarioStorageKeys.KEY_LIST_OF_CREATED_ORDERS,
        Collections.emptyList());
    Order order = orders.stream().filter(o -> o.getId().equals(orderId))
        .collect(Collectors.toList()).get(0);

    Cod cod = order.getCod();
    Assertions.assertThat(cod).as("COD should not be null.").isNotNull();
    Double codGoodsAmount = cod.getGoodsAmount();
    Assertions.assertThat(codGoodsAmount).as("COD Goods Amount should not be null.").isNotNull();

    Double amountCollected = codGoodsAmount;
    String receiptNumber = "#" + routeId + "-" + StandardTestUtils.generateDateUniqueString();

    RouteCashInboundCod routeCashInboundCod = new RouteCashInboundCod();
    routeCashInboundCod.setRouteId(routeId);
    routeCashInboundCod.setTotalCollected(amountCollected);
    routeCashInboundCod.setAmountCollected(amountCollected);
    routeCashInboundCod.setReceiptNumber(receiptNumber);

    routeCashInboundPage.inFrame(() -> {
      routeCashInboundPage.waitUntilLoaded(60);
      routeCashInboundPage.addCod.click();
      routeCashInboundPage.addCodDialog.waitUntilVisible();
      routeCashInboundPage.addCodDialog.routeId.setValue(routeCashInboundCod.getRouteId());
      routeCashInboundPage.addCodDialog.amountCollected.setValue(
          routeCashInboundCod.getAmountCollected().replace("S$", "").trim());
      routeCashInboundPage.addCodDialog.receiptNumber.setValue(
          routeCashInboundCod.getReceiptNumber());
      routeCashInboundPage.addCodDialog.submit.clickAndWaitUntilDone();
    });
    put(CoreScenarioStorageKeys.KEY_CORE_ROUTE_CASH_INBOUND_COD, routeCashInboundCod);
    put(CoreScenarioStorageKeys.KEY_CORE_COD_GOODS_AMOUNT, codGoodsAmount);
  }

  @Then("Operator verify the new COD on Route Cash Inbound page is created successfully")
  public void operatorVerifyTheNewCodIsCreatedSuccessfully() {
    RouteCashInboundCod routeCashInboundCod = get(
        CoreScenarioStorageKeys.KEY_CORE_ROUTE_CASH_INBOUND_COD);
    RouteCashInboundCod clone = new RouteCashInboundCod(routeCashInboundCod);
    clone.setAmountCollected(String.valueOf(clone.getDoubleAmountCollected()));
    routeCashInboundPage.inFrame(() -> {
      routeCashInboundPage.searchAndVerifyTableIsNotEmpty(clone);
      routeCashInboundPage.verifyCodInfoIsCorrect(clone);
    });
  }

  @Then("Operator check filter on Route Cash Inbound page work fine")
  public void operatorCheckFilterOnRouteCashInboundPageWork() {
    RouteCashInboundCod routeCashInboundCod = get(
        CoreScenarioStorageKeys.KEY_CORE_ROUTE_CASH_INBOUND_COD);
    RouteCashInboundCod clone = new RouteCashInboundCod(routeCashInboundCod);
    clone.setAmountCollected(String.valueOf(clone.getDoubleAmountCollected()));
    routeCashInboundPage.inFrame(() -> routeCashInboundPage.verifyFilterWorkFine(clone));
  }

  @When("Operator update the new COD on Route Cash Inbound page")
  public void operatorUpdateTheNewCod() {
    RouteCashInboundCod routeCashInboundCod = get(
        CoreScenarioStorageKeys.KEY_CORE_ROUTE_CASH_INBOUND_COD);

    Double oldTotalCollected = routeCashInboundCod.getTotalCollected();
    Double newTotalCollected = oldTotalCollected + (oldTotalCollected.intValue() / 2);

    RouteCashInboundCod routeCashInboundCodEdited = new RouteCashInboundCod();
    routeCashInboundCodEdited.setRouteId(routeCashInboundCod.getRouteId());
    routeCashInboundCodEdited.setTotalCollected(newTotalCollected);
    routeCashInboundCodEdited.setAmountCollected(newTotalCollected);
    routeCashInboundCodEdited.setReceiptNumber(routeCashInboundCod.getReceiptNumber() + "-EDITED");

    routeCashInboundPage.inFrame(() -> {
      routeCashInboundPage.waitUntilLoaded(5);
      routeCashInboundPage.searchAndVerifyTableIsNotEmpty(routeCashInboundCod);
      routeCashInboundPage.routeCashInboundTable.clickActionButton(1, ACTION_EDIT);
      routeCashInboundPage.editCodDialog.waitUntilVisible();
      routeCashInboundPage.editCodDialog.routeId.setValue(routeCashInboundCodEdited.getRouteId());
      routeCashInboundPage.editCodDialog.amountCollected.setValue(
          routeCashInboundCodEdited.getAmountCollected().replace("S$", ""));
      routeCashInboundPage.editCodDialog.receiptNumber.setValue(
          routeCashInboundCodEdited.getReceiptNumber());
      routeCashInboundPage.editCodDialog.submit.click();
      routeCashInboundPage.editCodDialog.waitUntilInvisible();
    });
    put(CoreScenarioStorageKeys.KEY_CORE_ROUTE_CASH_INBOUND_COD_EDITED, routeCashInboundCodEdited);
  }

  @Then("Operator verify the new COD on Route Cash Inbound page is updated successfully")
  public void operatorVerifyTheNewZoneIsUpdatedSuccessfully() {
    RouteCashInboundCod routeCashInboundCodEdited = get(
        CoreScenarioStorageKeys.KEY_CORE_ROUTE_CASH_INBOUND_COD_EDITED);
    RouteCashInboundCod clone = new RouteCashInboundCod(routeCashInboundCodEdited);
    clone.setAmountCollected(String.valueOf(clone.getDoubleAmountCollected()));
    routeCashInboundPage.inFrame(() -> routeCashInboundPage.verifyCodIsUpdatedSuccessfully(clone));
  }

  @When("Operator delete the new COD on Route Cash Inbound page")
  public void operatorDeleteTheNewZone() {
    RouteCashInboundCod routeCashInboundCod =
        containsKey(CoreScenarioStorageKeys.KEY_CORE_ROUTE_CASH_INBOUND_COD_EDITED) ? get(
            CoreScenarioStorageKeys.KEY_CORE_ROUTE_CASH_INBOUND_COD_EDITED)
            : get(CoreScenarioStorageKeys.KEY_CORE_ROUTE_CASH_INBOUND_COD);
    routeCashInboundPage.inFrame(() -> {
      routeCashInboundPage.waitUntilLoaded(3);
      routeCashInboundPage.deleteCod(routeCashInboundCod);
    });
  }

  @Then("Operator verify the new COD on Route Cash Inbound page is deleted successfully")
  public void operatorVerifyTheNewCodIsDeletedSuccessfully() {
    RouteCashInboundCod routeCashInboundCod =
        containsKey(CoreScenarioStorageKeys.KEY_CORE_ROUTE_CASH_INBOUND_COD_EDITED) ? get(
            CoreScenarioStorageKeys.KEY_CORE_ROUTE_CASH_INBOUND_COD_EDITED)
            : get(CoreScenarioStorageKeys.KEY_CORE_ROUTE_CASH_INBOUND_COD);
    routeCashInboundPage.inFrame(
        () -> routeCashInboundPage.verifyCodIsDeletedSuccessfully(routeCashInboundCod));
  }

  @When("Operator download COD CSV file on Route Cash Inbound page")
  public void operatorDownloadCodCsvFile() {
    routeCashInboundPage.inFrame(() -> routeCashInboundPage.downloadCsv.click());
  }

  @Then("Operator verify COD CSV file on Route Cash Inbound page is downloaded successfully")
  public void operatorVerifyCodCsvFileIsDownloadSuccessfully() {
    RouteCashInboundCod routeCashInboundCod = get(
        CoreScenarioStorageKeys.KEY_CORE_ROUTE_CASH_INBOUND_COD);
    routeCashInboundPage.verifyCsvFileDownloadedSuccessfully(routeCashInboundCod);
  }
}
