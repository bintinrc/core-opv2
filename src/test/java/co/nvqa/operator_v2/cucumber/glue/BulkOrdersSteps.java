package co.nvqa.operator_v2.cucumber.glue;

import static co.nvqa.operator_v2.selenium.page.BulkOrdersPage.BulkOrdersTable.ACTION_DETAILS;
import static co.nvqa.operator_v2.selenium.page.BulkOrdersPage.BulkOrdersTable.ACTION_PRINT;

import co.nvqa.commons.model.core.BulkOrderInfo;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.selenium.page.BulkOrdersPage;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.List;
import org.junit.Assert;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class BulkOrdersSteps extends AbstractSteps {

  private BulkOrdersPage bulkOrdersPage;

  public BulkOrdersSteps() {
  }

  @Override
  public void init() {
    bulkOrdersPage = new BulkOrdersPage(getWebDriver());
  }

  @When("^Operator search for created Bulk Order on Bulk Orders page$")
  public void operatorSearchForCreatedBulkOrder() {
    BulkOrderInfo bulkOrderInfo = get(KEY_CREATED_BULK_ORDER_INFO);
    bulkOrdersPage.bulkIdInput.setValue(bulkOrderInfo.getId());
    bulkOrdersPage.searchButton.clickAndWaitUntilDone();
    pause1s();
  }

  @When("^Operator verify created Bulk Order on Bulk Orders page$")
  public void operatorVerifyCreatedBulkOrder()
      throws InstantiationException, IllegalAccessException {
    BulkOrderInfo expectedBulkOrderInfo = get(KEY_CREATED_BULK_ORDER_INFO);
    expectedBulkOrderInfo = expectedBulkOrderInfo.copy();
    expectedBulkOrderInfo.setOrders(null);
    Assert.assertFalse("Bulk Orders table is empty", bulkOrdersPage.bulkOrdersTable.isEmpty());

    BulkOrderInfo actualBulkOrderInfo = bulkOrdersPage.bulkOrdersTable.readEntity(1);
    String createdAt = DateUtil.DATE_FORMATTER
        .format(DateUtil.DATE_TIME_FORMATTER.parse(actualBulkOrderInfo.getCreatedAt()));
    actualBulkOrderInfo.setCreatedAt(createdAt);
    expectedBulkOrderInfo.compareWithActual(actualBulkOrderInfo);
  }

  @When("^Operator verify details of created Bulk Order on Bulk Orders page$")
  public void operatorVerifyDetailsOfCreatedBulkOrder() {
    BulkOrderInfo expectedBulkOrderInfo = get(KEY_CREATED_BULK_ORDER_INFO);
    Assert.assertFalse("Bulk Orders table is empty", bulkOrdersPage.bulkOrdersTable.isEmpty());

    bulkOrdersPage.bulkOrdersTable.clickActionButton(1, ACTION_DETAILS);
    bulkOrdersPage.bulkDetailsDialog.waitUntilVisible();
    List<Order> actualOrders = bulkOrdersPage.bulkDetailsDialog.ordersTable.readAllEntities();

    Assert.assertEquals("Number of orders in Bulk", expectedBulkOrderInfo.getOrders().size(),
        actualOrders.size());

    for (int i = 0; i < actualOrders.size(); i++) {
      actualOrders.get(i).compareWithActual(expectedBulkOrderInfo.getOrders().get(i));
    }
  }

  @When("^Operator print created Bulk Order on Bulk Orders page$")
  public void operatorPrintCreatedBulkOrder() {
    Assert.assertFalse("Bulk Orders table is empty", bulkOrdersPage.bulkOrdersTable.isEmpty());

    bulkOrdersPage.bulkOrdersTable.clickActionButton(1, ACTION_PRINT);
    bulkOrdersPage.printConfirmationDialog.waitUntilVisible();
    Assert.assertEquals("Confirmation text", "Are you sure to print all label for orders?",
        bulkOrdersPage.printConfirmationDialog.message.getText());
    Assert.assertTrue("Print button enable state",
        bulkOrdersPage.printConfirmationDialog.printButton.isEnabled());
  }
}
