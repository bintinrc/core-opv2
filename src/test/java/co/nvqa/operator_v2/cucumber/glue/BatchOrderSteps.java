package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.BatchOrderInfo;
import co.nvqa.operator_v2.selenium.page.BatchOrderPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;


/**
 * @author Niko Susanto
 */
@SuppressWarnings("unused")
@ScenarioScoped
public class BatchOrderSteps extends AbstractSteps {

  private BatchOrderPage batchOrdersPage;

  public BatchOrderSteps() {
  }

  @Override
  public void init() {
    batchOrdersPage = new BatchOrderPage(getWebDriver());
  }

  @When("^Operator search for created Batch Order on Batch Orders page$")
  public void operatorSearchForCreatedBatchId() {
    batchOrdersPage.searchBatchId(get(KEY_CREATED_BATCH_ORDER_ID));
  }

  @When("^Operator verify the list of orders are correct$")
  public void operatorVerifyListOfOrders() {
    BatchOrderInfo expectedBatchOrderInfo = get(KEY_CREATED_BATCH_ORDER_INFO);

    batchOrdersPage.verifyOrderInfoOnTableOrderIsCorrect(expectedBatchOrderInfo.getOrders().get(0));
  }

  @When("^Operator search invalid batch ID on Batch Orders page$")
  public void operatorSearchInvalidBatchId() {
    batchOrdersPage.searchBatchId("1234567890");
  }

  @Then("^Operator verify the invalid batch ID error toast is shown$")
  public void operatorVerifyTheInvalidBatchIdToast() {
    batchOrdersPage.verifyTheInvalidBatchIdToast("1234567890");
  }

  @When("^Operator rollback the batch order$")
  public void operatorRollbackTheBatchOrder() {
    batchOrdersPage.rollbackBatchOrder();
  }

  @When("^Get created batch order$")
  public void getCreatedBatchOrder() {
    BatchOrderInfo expectedBatchOrderInfo = get(KEY_CREATED_BATCH_ORDER_INFO);

    Long orderId = expectedBatchOrderInfo.getOrders().get(0).getId();
    put(KEY_CREATED_ORDER_ID, orderId);
  }

  @Then("^Operator verify the invalid order status error toast is shown$")
  public void operatorVerifyTheInvalidOrderStatus() {
    BatchOrderInfo expectedBatchOrderInfo = get(KEY_CREATED_BATCH_ORDER_INFO);

    String trackingId = expectedBatchOrderInfo.getOrders().get(0).getTrackingId();
    batchOrdersPage.verifyTheInvalidStatusToast(trackingId);
  }
}
