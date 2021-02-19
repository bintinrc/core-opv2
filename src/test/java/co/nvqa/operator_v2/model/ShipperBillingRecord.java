package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import java.util.Map;
import org.apache.commons.text.WordUtils;

/**
 * @author Sergey Mishanin
 */
public class ShipperBillingRecord extends DataEntity<ShipperBillingRecord> {

  private Long shipperId;
  private String shipperName;
  private String currency;
  private String type;
  private Double amount;
  private String reason;
  private String comment;
  private String referenceNo;

  public ShipperBillingRecord() {
  }

  public ShipperBillingRecord(Map<String, ?> dataMap) {
    fromMap(dataMap);
  }

  public String getShipperName() {
    return shipperName;
  }

  public void setShipperName(String shipperName) {
    this.shipperName = shipperName;
  }

  public Double getAmount() {
    return amount;
  }

  public void setAmount(Double amount) {
    this.amount = amount;
  }

  public void setAmount(String amount) {
    setAmount(Double.parseDouble(amount));
  }

  public String getReason() {
    return reason;
  }

  public void setReason(String reason) {
    this.reason = reason;
  }

  public String getComment() {
    return comment;
  }

  public void setComment(String comment) {
    this.comment = comment;
  }

  public String getType() {
    return type;
  }

  public void setType(String type) {
    this.type = WordUtils.capitalizeFully(type);
  }

  public Long getShipperId() {
    return shipperId;
  }

  public void setShipperId(Long shipperId) {
    this.shipperId = shipperId;
  }

  public void setShipperId(String shipperId) {
    setShipperId(Long.parseLong(shipperId));
  }

  public String getReferenceNo() {
    return referenceNo;
  }

  public void setReferenceNo(String referenceNo) {
    this.referenceNo = referenceNo;
  }

  public String getCurrency() {
    return currency;
  }

  public void setCurrency(String currency) {
    this.currency = currency;
  }
}
