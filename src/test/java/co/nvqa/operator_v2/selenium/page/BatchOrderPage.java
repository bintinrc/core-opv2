package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.BatchOrder;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;


/**
 * @author Sergey Mishanin
 */
public class BatchOrderPage extends SimpleReactPage<BatchOrderPage> {

  @FindBy(xpath = "//input[@data-testid='batchId-input']")
  public ForceClearTextBox batchId;

  @FindBy(xpath = "//button[@data-testid='search-batch-id-button']")
  public Button search;

  @FindBy(xpath = "//button[@data-testid='rollback-button']")
  public Button rollback;

  @FindBy(xpath = "//input[@data-testid='password-input']")
  public ForceClearTextBox password;

  @FindBy(xpath = "//button[@data-testid='modal-rollback-button']")
  public Button rollbackDialogButton;

  public OrdersTable ordersTable;

  public BatchOrderPage(WebDriver webDriver) {
    super(webDriver);
    ordersTable = new OrdersTable(webDriver);
  }

  public static class OrdersTable extends MdVirtualRepeatTable<BatchOrder> {

    private OrdersTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("trackingId", "tracking_id")
          .put("type", "type")
          .put("fromName", "//tr[%d]/td[@class='c_from']/div[@class='name']")
          .put("fromAddress", "//tr[%d]/td[@class='c_from']/div[@class='address']")
          .put("toName", "//tr[%d]/td[@class='c_to']/div[@class='name']")
          .put("toAddress", "//tr[%d]/td[@class='c_to']/div[@class='address']")
          .put("status", "//tr[%d]/td[@class='status']/div[1]")
          .put("granularStatus", "//tr[%d]/td[@class='status']/div[2]")
          .put("createdAt", "c_created-at")
          .build()
      );
      setEntityClass(BatchOrder.class);
      setMdVirtualRepeat("order in getTableData()");
    }
  }
}