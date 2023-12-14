package co.nvqa.operator_v2.model;

import co.nvqa.common.core.model.order.Order;
import co.nvqa.common.model.DataEntity;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class WaypointOrderInfo extends DataEntity<WaypointOrderInfo> {

  private String trackingId;
  private String stampId;
  private String location;
  private String type;
  private String status;
  private Long cmiCount;
  private String routeInboundStatus;
  private String shipperName;
  private String reservationId;
  private String issue;

  public WaypointOrderInfo() {
  }

  public WaypointOrderInfo(Map<String, String> data) {
    fromMap(data);
  }

  public String getTrackingId() {
    return trackingId;
  }

  public void setTrackingId(String trackingId) {
    this.trackingId = trackingId;
  }

  public String getStampId() {
    return stampId;
  }

  public void setStampId(String stampId) {
    this.stampId = stampId;
  }

  public String getLocation() {
    return location;
  }

  public void setLocation(String location) {
    this.location = location;
  }

  public void setLocation(Order order) {
    String address =
        order.getToAddress1() + " " + order.getToAddress2() + " " + order.getToPostcode() + " "
            + order.getToCountry();
    setLocation(address.trim());
  }

  public String getType() {
    return type;
  }

  public void setType(String type) {
    this.type = type;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public Long getCmiCount() {
    return cmiCount;
  }

  public void setCmiCount(Long cmiCount) {
    this.cmiCount = cmiCount;
  }

  public void setCmiCount(String cmiCount) {
    setCmiCount(Long.parseLong(cmiCount));
  }

  public String getRouteInboundStatus() {
    return routeInboundStatus;
  }

  public void setRouteInboundStatus(String routeInboundStatus) {
    this.routeInboundStatus = routeInboundStatus;
  }

  public String getShipperName() {
    return shipperName;
  }

  public void setShipperName(String shipperName) {
    this.shipperName = shipperName;
  }

  public String getReservationId() {
    return reservationId;
  }

  public void setReservationId(String reservationId) {
    this.reservationId = reservationId;
  }

  public String getIssue() {
    return issue;
  }

  public void setIssue(String issue) {
    this.issue = issue;
  }
}
