package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class MoneyCollectionHistoryEntry extends DataEntity<MoneyCollectionHistoryEntry> {

  private String processedAmount;
  private String processedType;
  private String inboundedBy;
  private String receiptNo;

  public MoneyCollectionHistoryEntry() {
  }

  public MoneyCollectionHistoryEntry(Map<String, ?> data) {
    fromMap(data);
  }

  public String getProcessedAmount() {
    return processedAmount;
  }

  public void setProcessedAmount(String processedAmount) {
    this.processedAmount = processedAmount;
  }

  public String getProcessedType() {
    return processedType;
  }

  public void setProcessedType(String processedType) {
    this.processedType = processedType;
  }

  public String getInboundedBy() {
    return inboundedBy;
  }

  public void setInboundedBy(String inboundedBy) {
    this.inboundedBy = inboundedBy;
  }

  public String getReceiptNo() {
    return receiptNo;
  }

  public void setReceiptNo(String receiptNo) {
    this.receiptNo = receiptNo;
  }
}
