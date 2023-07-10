package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.List;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("unused")
public class RouteGroupJobDetails extends DataEntity<RouteGroupJobDetails> {

  private String sn;
  private String id;
  private String orderId;
  private String trackingId;
  private String type;
  private String shipper;
  private String address;
  private String routeId;
  private String status;
  private List<String> jobTags;
  private String startDateTime;
  private String endDateTime;
  private String dp;
  private String pickupSize;
  private String comments;
  private String priorityLevel;

  public RouteGroupJobDetails() {
  }

  public RouteGroupJobDetails(Map<String, ?> data) {
    super(data);
  }

  public String getSn() {
    return sn;
  }

  public void setSn(String sn) {
    this.sn = sn;
  }

  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
  }

  public String getOrderId() {
    return orderId;
  }

  public void setOrderId(String orderId) {
    this.orderId = orderId;
  }

  public String getTrackingId() {
    return trackingId;
  }

  public void setTrackingId(String trackingId) {
    this.trackingId = trackingId;
  }

  public String getType() {
    return type;
  }

  public void setType(String type) {
    this.type = type;
  }

  public String getShipper() {
    return shipper;
  }

  public void setShipper(String shipper) {
    this.shipper = shipper;
  }

  public String getAddress() {
    return address;
  }

  public void setAddress(String address) {
    this.address = address;
  }

  public String getRouteId() {
    return routeId;
  }

  public void setRouteId(String routeId) {
    this.routeId = routeId;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public String getStartDateTime() {
    return startDateTime;
  }

  public void setStartDateTime(String startDateTime) {
    this.startDateTime = startDateTime;
  }

  public String getEndDateTime() {
    return endDateTime;
  }

  public void setEndDateTime(String endDateTime) {
    this.endDateTime = endDateTime;
  }

  public String getDp() {
    return dp;
  }

  public void setDp(String dp) {
    this.dp = dp;
  }

  public String getPickupSize() {
    return pickupSize;
  }

  public void setPickupSize(String pickupSize) {
    this.pickupSize = pickupSize;
  }

  public String getComments() {
    return comments;
  }

  public void setComments(String comments) {
    this.comments = comments;
  }

  public String getPriorityLevel() {
    return priorityLevel;
  }

  public void setPriorityLevel(String priorityLevel) {
    this.priorityLevel = priorityLevel;
  }

  public List<String> getJobTags() {
    return jobTags;
  }

  public void setJobTags(List<String> jobTags) {
    this.jobTags = jobTags;
  }

  public void setJobTags(String jobTags) {
    setJobTags(splitAndNormalize(jobTags));
  }

  @Override
  public void fromCsvLine(String csvLine) {
    String[] values = splitCsvLine(csvLine);
    setSn(getValueIfIndexExists(values, 0));
    setId(getValueIfIndexExists(values, 1));
    setOrderId(getValueIfIndexExists(values, 2));
    setTrackingId(getValueIfIndexExists(values, 3));
    setType(getValueIfIndexExists(values, 4));
    setShipper(getValueIfIndexExists(values, 5));
    setAddress(getValueIfIndexExists(values, 6));
    setRouteId(getValueIfIndexExists(values, 7));
    setStatus(getValueIfIndexExists(values, 8));
    setPriorityLevel(getValueIfIndexExists(values, 9));
    setStartDateTime(getValueIfIndexExists(values, 10));
    setEndDateTime(getValueIfIndexExists(values, 11));
    setDp(getValueIfIndexExists(values, 12));
    setPickupSize(getValueIfIndexExists(values, 13));
    setComments(getValueIfIndexExists(values, 14));
  }

}
