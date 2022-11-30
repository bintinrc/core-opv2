package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class OrderEvent extends DataEntity<OrderEvent> {

  private String eventTime;
  private String tags;
  private String name;
  private String userType;
  private String user;
  private String scanId;
  private String routeId;
  private String hubName;
  private String description;

  public String getEventTime() {
    return eventTime;
  }

  public void setEventTime(String eventTime) {
    this.eventTime = eventTime;
  }

  public String getTags() {
    return tags;
  }

  public void setTags(String tags) {
    this.tags = tags;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getUserType() {
    return userType;
  }

  public void setUserType(String userType) {
    this.userType = userType;
  }

  public String getUser() {
    return user;
  }

  public void setUser(String user) {
    this.user = user;
  }

  public String getScanId() {
    return scanId;
  }

  public void setScanId(String scanId) {
    this.scanId = scanId;
  }

  public String getRouteId() {
    return routeId;
  }

  public void setRouteId(String routeId) {
    this.routeId = routeId;
  }

  public String getHubName() {
    return hubName;
  }

  public void setHubName(String hubName) {
    this.hubName = hubName;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public OrderEvent() {
  }

  public OrderEvent(Map<String, ?> dataMap) {
    fromMap(dataMap);
  }

}
