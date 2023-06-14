package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;

/**
 * @author Sergey Mishanin
 */
public class RouteLogsParams extends DataEntity<RouteLogsParams> {

  private String date;
  private String id;
  private String status;
  private String driverName;
  private String routePassword;
  private String hub;
  private String zone;
  private String driverTypeName;
  private List<String> tags;
  private String comments;
  private String vehicle;

  public RouteLogsParams() {
  }

  public RouteLogsParams(Map<String, ?> data) {
    fromMap(data);
  }

  public String getDate() {
    return date;
  }

  public void setDate(String date) {
    this.date = date;
  }

  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public String getDriverName() {
    return driverName;
  }

  public void setDriverName(String driverName) {
    this.driverName = driverName;
  }

  public String getRoutePassword() {
    return routePassword;
  }

  public void setRoutePassword(String routePassword) {
    this.routePassword = routePassword;
  }

  public String getHub() {
    return hub;
  }

  public void setHub(String hub) {
    this.hub = hub;
  }

  public String getZone() {
    return zone;
  }

  public void setZone(String zone) {
    this.zone = zone;
  }

  public String getDriverTypeName() {
    return driverTypeName;
  }

  public void setDriverTypeName(String driverTypeName) {
    this.driverTypeName = driverTypeName;
  }

  public List<String> getTags() {
    return tags;
  }

  public void setTags(List<String> tags) {
    this.tags = tags;
  }

  public void setTags(String tags) {
    if (StringUtils.isNotBlank(tags)) {
      setTags(splitAndNormalize(tags));
    }
  }

  public String getComments() {
    return comments;
  }

  public void setComments(String comments) {
    this.comments = comments;
  }

  public String getVehicle() {
    return vehicle;
  }

  public void setVehicle(String vehicle) {
    this.vehicle = vehicle;
  }
}
