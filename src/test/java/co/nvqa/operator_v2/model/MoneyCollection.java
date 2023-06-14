package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.Map;
import org.junit.platform.commons.util.StringUtils;

/**
 * @author Sergey Mishanin
 */
public class MoneyCollection extends DataEntity<MoneyCollection> {

  private Double cashCollected;
  private Double creditCollected;
  private String receiptNo;
  private String receiptId;

  public MoneyCollection() {
  }

  public MoneyCollection(Map<String, ?> data) {
    fromMap(data);
  }

  public Double getCashCollected() {
    return cashCollected;
  }

  public void setCashCollected(Double cashCollected) {
    this.cashCollected = cashCollected;
  }

  public void setCashCollected(String cashCollected) {
    if (StringUtils.isNotBlank(cashCollected)) {
      setCashCollected(Double.parseDouble(cashCollected));
    }
  }

  public Double getCreditCollected() {
    return creditCollected;
  }

  public void setCreditCollected(Double creditCollected) {
    this.creditCollected = creditCollected;
  }

  public void setCreditCollected(String creditCollected) {
    if (StringUtils.isNotBlank(creditCollected)) {
      setCreditCollected(Double.parseDouble(creditCollected));
    }
  }

  public String getReceiptNo() {
    return receiptNo;
  }

  public void setReceiptNo(String receiptNo) {
    this.receiptNo = receiptNo;
  }

  public String getReceiptId() {
    return receiptId;
  }

  public void setReceiptId(String receiptId) {
    this.receiptId = receiptId;
  }
}
