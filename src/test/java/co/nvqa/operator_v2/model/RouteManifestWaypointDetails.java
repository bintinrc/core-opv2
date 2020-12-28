package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;

/**
 * @author Sergey Mishanin
 */
public class RouteManifestWaypointDetails extends DataEntity<RouteManifestWaypointDetails> {

  private Long id;
  private String address;
  private String status;
  private String priority;
  private String timeslot;
  private Long deliveriesCount;
  private Long pickupsCount;
  private String comments;
  private String trackingIds;

  private Reservation reservation;
  private Pickup pickup;
  private Delivery delivery;

  public RouteManifestWaypointDetails() {
  }

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public void setId(String id) {
    setId(Long.parseLong(id));
  }

  public String getAddress() {
    return address;
  }

  public void setAddress(String address) {
    this.address = address;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public String getPriority() {
    return priority;
  }

  public void setPriority(String priority) {
    this.priority = priority;
  }

  public String getTimeslot() {
    return timeslot;
  }

  public void setTimeslot(String timeslot) {
    this.timeslot = timeslot;
  }

  public Long getDeliveriesCount() {
    return deliveriesCount;
  }

  public void setDeliveriesCount(Long deliveriesCount) {
    this.deliveriesCount = deliveriesCount;
  }

  public void setDeliveriesCount(String deliveriesCount) {
    setDeliveriesCount(Long.parseLong(deliveriesCount));
  }

  public Long getPickupsCount() {
    return pickupsCount;
  }

  public void setPickupsCount(Long pickupsCount) {
    this.pickupsCount = pickupsCount;
  }

  public void setPickupsCount(String pickupsCount) {
    setPickupsCount(Long.parseLong(pickupsCount));
  }

  public String getComments() {
    return comments;
  }

  public void setComments(String comments) {
    this.comments = comments;
  }

  public String getTrackingIds() {
    return trackingIds;
  }

  public void setTrackingIds(String trackingIds) {
    this.trackingIds = trackingIds;
  }

  public Reservation getReservation() {
    return reservation;
  }

  public void setReservation(Reservation reservation) {
    this.reservation = reservation;
  }

  public Pickup getPickup() {
    return pickup;
  }

  public void setPickup(Pickup pickup) {
    this.pickup = pickup;
  }

  public Delivery getDelivery() {
    return delivery;
  }

  public void setDelivery(Delivery delivery) {
    this.delivery = delivery;
  }

  public static class Reservation extends DataEntity<Reservation> {

    private Long id;
    private String status;
    private String failureReason;

    public Long getId() {
      return id;
    }

    public void setId(Long id) {
      this.id = id;
    }

    public void setId(String id) {
      setId(Long.parseLong(id));
    }

    public String getStatus() {
      return status;
    }

    public void setStatus(String status) {
      this.status = status;
    }

    public String getFailureReason() {
      return failureReason;
    }

    public void setFailureReason(String failureReason) {
      this.failureReason = failureReason;
    }
  }

  public static class Pickup extends DataEntity<Pickup> {

    private String trackingId;
    private String status;
    private String failureReason;

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

    public String getFailureReason() {
      return failureReason;
    }

    public void setFailureReason(String failureReason) {
      this.failureReason = failureReason;
    }
  }

  public static class Delivery extends DataEntity<Delivery> {

    private String trackingId;
    private String status;
    private String failureReason;

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

    public String getFailureReason() {
      return failureReason;
    }

    public void setFailureReason(String failureReason) {
      this.failureReason = failureReason;
    }
  }
}
