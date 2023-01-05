package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class MoneyCollectionCollectedOrderEntry extends
    DataEntity<MoneyCollectionCollectedOrderEntry> {

  private String processedCodAmount;
  private String processedCodCollected;
  private String trackingId;
  private String stampId;
  private String customType;
  private String location;
  private String contact;
  private String addressee;

  public MoneyCollectionCollectedOrderEntry() {
  }

  public MoneyCollectionCollectedOrderEntry(Map<String, ?> data) {
    fromMap(data);
  }

  public String getProcessedCodAmount() {
    return processedCodAmount;
  }

  public void setProcessedCodAmount(String processedCodAmount) {
    this.processedCodAmount = processedCodAmount;
  }

  public String getProcessedCodCollected() {
    return processedCodCollected;
  }

  public void setProcessedCodCollected(String processedCodCollected) {
    this.processedCodCollected = processedCodCollected;
  }

  public String getTrackingId() {
    return trackingId;
  }

  public void setTrackingId(String trackingId) {
    this.trackingId = trackingId;
  }

  public String getStampId() {
    return stampId;
  }

  public void setStampId(String stampId) {
    this.stampId = stampId;
  }

  public String getCustomType() {
    return customType;
  }

  public void setCustomType(String customType) {
    this.customType = customType;
  }

  public String getLocation() {
    return location;
  }

  public void setLocation(String location) {
    this.location = location;
  }

  public String getContact() {
    return contact;
  }

  public void setContact(String contact) {
    this.contact = contact;
  }

  public String getAddressee() {
    return addressee;
  }

  public void setAddressee(String addressee) {
    this.addressee = addressee;
  }
}
