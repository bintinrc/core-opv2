package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class CodInfo extends DataEntity<CodInfo> {

  private String trackingId;
  private String granularStatus;
  private String shipperName;
  private String collectedAt;
  private String codAmount;
  private String shippingAmount;
  private String collectedSum;
  private String collected;

  public CodInfo() {
  }

  public CodInfo(Map<String, ?> data) {
    fromMap(data);
  }

  public String getTrackingId() {
    return trackingId;
  }

  public void setTrackingId(String trackingId) {
    this.trackingId = trackingId;
  }

  public String getGranularStatus() {
    return granularStatus;
  }

  public void setGranularStatus(String granularStatus) {
    this.granularStatus = granularStatus;
  }

  public String getShipperName() {
    return shipperName;
  }

  public void setShipperName(String shipperName) {
    this.shipperName = shipperName;
  }

  public String getCollectedAt() {
    return collectedAt;
  }

  public void setCollectedAt(String collectedAt) {
    this.collectedAt = collectedAt;
  }

  public String getCodAmount() {
    return codAmount;
  }

  public void setCodAmount(String codAmount) {
    this.codAmount = codAmount;
  }

  public String getShippingAmount() {
    return shippingAmount;
  }

  public void setShippingAmount(String shippingAmount) {
    this.shippingAmount = shippingAmount;
  }

  public String getCollectedSum() {
    return collectedSum;
  }

  public void setCollectedSum(String collectedSum) {
    this.collectedSum = collectedSum;
  }

  public String getCollected() {
    return collected;
  }

  public void setCollected(String collected) {
    this.collected = collected;
  }
}
