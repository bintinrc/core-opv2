package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.DataEntity;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import java.util.Map;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;


/**
 * @author Sergey Mishanin
 */
public class BatchOrderPage extends OperatorV2SimplePage {

  @FindBy(id = "input-number-batch-id")
  public TextBox batchId;

  @FindBy(name = "commons.search")
  public NvApiTextButton search;

  @FindBy(name = "commons.rollback")
  public NvIconTextButton rollback;

  @FindBy(css = "md-dialog")
  public RollbackDialog rollbackDialog;

  public OrdersTable ordersTable;

  public BatchOrderPage(WebDriver webDriver) {
    super(webDriver);
    ordersTable = new OrdersTable(webDriver);
  }

  public static class BatchOrderInfo extends DataEntity<BatchOrderInfo> {

    private String trackingId;
    private String type;
    private String fromName;
    private String fromAddress;
    private String toName;
    private String toAddress;
    private String status;
    private String granularStatus;
    private String createdAt;

    public BatchOrderInfo() {
    }

    public BatchOrderInfo(Map<String, ?> data) {
      super(data);
    }

    public String getTrackingId() {
      return trackingId;
    }

    public void setTrackingId(String trackingId) {
      this.trackingId = trackingId;
    }

    public String getType() {
      return type;
    }

    public void setType(String type) {
      this.type = type;
    }

    public String getFromName() {
      return fromName;
    }

    public void setFromName(String fromName) {
      this.fromName = fromName;
    }

    public String getFromAddress() {
      return fromAddress;
    }

    public void setFromAddress(String fromAddress) {
      this.fromAddress = fromAddress;
    }

    public String getToName() {
      return toName;
    }

    public void setToName(String toName) {
      this.toName = toName;
    }

    public String getToAddress() {
      return toAddress;
    }

    public void setToAddress(String toAddress) {
      this.toAddress = toAddress;
    }

    public String getStatus() {
      return status;
    }

    public void setStatus(String status) {
      this.status = status;
    }

    public String getGranularStatus() {
      return granularStatus;
    }

    public void setGranularStatus(String granularStatus) {
      this.granularStatus = granularStatus;
    }

    public String getCreatedAt() {
      return createdAt;
    }

    public void setCreatedAt(String createdAt) {
      this.createdAt = createdAt;
    }
  }

  public static class OrdersTable extends MdVirtualRepeatTable<BatchOrderInfo> {

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
      setEntityClass(BatchOrderInfo.class);
      setMdVirtualRepeat("order in getTableData()");
    }
  }

  public static class RollbackDialog extends MdDialog {

    @FindBy(id = "password")
    public TextBox password;

    @FindBy(name = "commons.rollback")
    public NvApiTextButton rollback;

    public RollbackDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}