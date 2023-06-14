package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class ThirdPartyOrderMapping extends DataEntity<ThirdPartyOrderMapping> {

  private Long shipperId;
  private String shipperName;
  private String trackingId;
  private String thirdPlTrackingId;
  private String status = "Saved";

  public ThirdPartyOrderMapping() {
  }

  public ThirdPartyOrderMapping(Map<String, ?> data) {
    fromMap(data);
  }

  public Long getShipperId() {
    return shipperId;
  }

  public void setShipperId(Long shipperId) {
    this.shipperId = shipperId;
  }

  public void setShipperId(String shipperId) {
    setShipperId(Long.valueOf(shipperId));
  }

  public String getTrackingId() {
    return trackingId;
  }

  public void setTrackingId(String trackingId) {
    this.trackingId = trackingId;
  }

  public String getThirdPlTrackingId() {
    return thirdPlTrackingId;
  }

  public void setThirdPlTrackingId(String thirdPlTrackingId) {
    this.thirdPlTrackingId = thirdPlTrackingId;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public String getShipperName() {
    return shipperName;
  }

  public void setShipperName(String shipperName) {
    this.shipperName = shipperName;
  }

  @Override
  public String toString() {
    return "ThirdPartyOrderMapping{" +
        "shipperId='" + shipperId + '\'' +
        ", shipperName='" + shipperName + '\'' +
        ", trackingId='" + trackingId + '\'' +
        ", thirdPlTrackingId='" + thirdPlTrackingId + '\'' +
        ", status='" + status + '\'' +
        '}';
  }

  public String toCsvLine() {
    return trackingId + "," + shipperId + "," + thirdPlTrackingId;
  }
}
