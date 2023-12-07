package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.Map;

/**
 * @author Kateryna Skakunova
 */
public class ImplantedManifestOrder extends DataEntity<ImplantedManifestOrder> {

  private String trackingId;
  private String scannedAt;
  private String destination;
  private String addressee;
  private String rackSector;
  private String deliveryBy;

  public ImplantedManifestOrder() {
  }

  public ImplantedManifestOrder(Map<String, ?> data) {
    fromMap(data);
  }

  public String getTrackingId() {
    return trackingId;
  }

  public void setTrackingId(String trackingId) {
    this.trackingId = trackingId;
  }

  public String getScannedAt() {
    return scannedAt;
  }

  public void setScannedAt(String scannedAt) {
    this.scannedAt = scannedAt;
  }

  public String getDestination() {
    return destination;
  }

  public void setDestination(String destination) {
    this.destination = destination;
  }

  public String getAddressee() {
    return addressee;
  }

  public void setAddressee(String addressee) {
    this.addressee = addressee;
  }

  public String getRackSector() {
    return rackSector;
  }

  public void setRackSector(String rackSector) {
    this.rackSector = rackSector;
  }

  public String getDeliveryBy() {
    return deliveryBy;
  }

  public void setDeliveryBy(String deliveryBy) {
    this.deliveryBy = deliveryBy;
  }
}
