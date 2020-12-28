package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class ShipmentEvent extends DataEntity<ShipmentEvent> {

  private String source;
  private String userId;
  private String result;
  private String hub;
  private String createdAt;

  public ShipmentEvent() {
  }

  public ShipmentEvent(Map<String, ?> dataMap) {
    fromMap(dataMap);
  }

  public String getSource() {
    return source;
  }

  public void setSource(String source) {
    this.source = source;
  }

  public String getUserId() {
    return userId;
  }

  public void setUserId(String userId) {
    this.userId = userId;
  }

  public String getResult() {
    return result;
  }

  public void setResult(String result) {
    this.result = result;
  }

  public String getHub() {
    return hub;
  }

  public void setHub(String hub) {
    this.hub = hub;
  }

  public String getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(String createdAt) {
    this.createdAt = createdAt;
  }
}
