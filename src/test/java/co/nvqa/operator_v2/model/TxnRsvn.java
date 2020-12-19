package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import org.apache.commons.lang3.StringUtils;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings({"unused", "WeakerAccess"})
public class TxnRsvn extends DataEntity<TxnRsvn> {

  private Long sequence;
  private Long id;
  private Long orderId;
  private String waypointId;
  private String trackingId;
  private String type;
  private String shipper;
  private String address;
  private String routeId;
  private String status;
  private String startDateTime;
  private String endDateTime;
  private String dp;
  private String pickupSize;
  private String comments;

  public TxnRsvn() {
  }

  public Long getSequence() {
    return sequence;
  }

  public void setSequence(Long sequence) {
    this.sequence = sequence;
  }

  public void setSequence(String sequence) {
    setSequence(Long.valueOf(sequence));
  }

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public void setId(String id) {
    setId(Long.valueOf(id));
  }

  public Long getOrderId() {
    return orderId;
  }

  public void setOrderId(Long orderId) {
    this.orderId = orderId;
  }

  public void setOrderId(String orderId) {
    setOrderId(Long.valueOf(orderId));
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
    if (!StringUtils.equalsIgnoreCase(routeId, "-")) {
      this.routeId = routeId;
    }
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

  public String getWaypointId() {
    return waypointId;
  }

  public void setWaypointId(String waypointId) {
    this.waypointId = waypointId;
  }
}
