package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.List;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class TaggedOrderParams extends DataEntity<TaggedOrderParams> {

  private String trackingId;
  private List<String> tags;
  private String driver;
  private String route;
  private String destinationZone;
  private String lastAttempt;
  private String daysFromFirstInbound;
  private String granularStatus;

  public TaggedOrderParams() {
  }

  public TaggedOrderParams(Map<String, ?> data) {
    fromMap(data);
  }

  public String getTrackingId() {
    return trackingId;
  }

  public void setTrackingId(String trackingId) {
    this.trackingId = trackingId;
  }

  public List<String> getTags() {
    return tags;
  }

  public void setTags(List<String> tags) {
    this.tags = tags;
  }

  public void setTags(String tags) {
    setTags(splitAndNormalize(tags));
  }

  public String getDriver() {
    return driver;
  }

  public void setDriver(String driver) {
    this.driver = driver;
  }

  public String getRoute() {
    return route;
  }

  public void setRoute(String route) {
    this.route = route;
  }

  public String getDestinationZone() {
    return destinationZone;
  }

  public TaggedOrderParams setDestinationZone(String destinationZone) {
    this.destinationZone = destinationZone;
    return this;
  }

  public String getLastAttempt() {
    return lastAttempt;
  }

  public void setLastAttempt(String lastAttempt) {
    this.lastAttempt = lastAttempt;
  }

  public String getDaysFromFirstInbound() {
    return daysFromFirstInbound;
  }

  public void setDaysFromFirstInbound(String daysFromFirstInbound) {
    this.daysFromFirstInbound = daysFromFirstInbound;
  }

  public String getGranularStatus() {
    return granularStatus;
  }

  public void setGranularStatus(String granularStatus) {
    this.granularStatus = granularStatus;
  }
}
