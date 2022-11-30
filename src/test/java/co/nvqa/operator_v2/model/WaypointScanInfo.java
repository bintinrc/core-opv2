package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class WaypointScanInfo extends DataEntity<WaypointScanInfo> {

  private String trackingId;
  private String status;
  private String reason;
  private String tags;

  public WaypointScanInfo() {
  }

  public WaypointScanInfo(Map<String, String> data) {
    fromMap(data);
  }

  public String getTrackingId() {
    return trackingId;
  }

  public void setTrackingId(String trackingId) {
    this.trackingId = trackingId;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public String getReason() {
    return reason;
  }

  public void setReason(String reason) {
    this.reason = reason;
  }

  public String getTags() {
    return tags;
  }

  public void setTags(String tags) {
    this.tags = tags;
  }
}
