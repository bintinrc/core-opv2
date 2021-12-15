package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.BatchOrderPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.Map;
import org.assertj.core.api.Assertions;


/**
 * @author Sergey Mishanin
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

  @When("Operator search for {value} batch on Batch Orders page")
  public void operatorSearchForCreatedBatchId(String batchId) {
    batchOrdersPage.batchId.setValue(batchId);
    batchOrdersPage.search.clickAndWaitUntilDone();
  }

  @When("Operator click rollback button on Batch Orders page")
  public void operatorClickRollback() {
    batchOrdersPage.rollback.click();
  }

  @When("Operator rollback orders on Batch Orders page")
  public void rollbackOrders() {
    batchOrdersPage.rollback.click();
    batchOrdersPage.rollbackDialog.waitUntilVisible();
    batchOrdersPage.rollbackDialog.password.setValue("1234567890");
    batchOrdersPage.rollbackDialog.rollback.clickAndWaitUntilDone();
  }

  @When("Operator verifies orders info on Batch Orders page:")
  public void operatorVerifiesBatchOrders(List<Map<String, String>> data) {
    data.forEach(map -> {
      BatchOrderPage.BatchOrderInfo expected = new BatchOrderPage.BatchOrderInfo(
          resolveKeyValues(map));
      batchOrdersPage.ordersTable.filterByColumn("trackingId", expected.getTrackingId());
      Assertions.assertThat(batchOrdersPage.ordersTable.isEmpty())
          .as("Orders table is empty")
          .isFalse();
      BatchOrderPage.BatchOrderInfo actual = batchOrdersPage.ordersTable.readEntity(1);
      expected.compareWithActual(actual);
    });
  }

}