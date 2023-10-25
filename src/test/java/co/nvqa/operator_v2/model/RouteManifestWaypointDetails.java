package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.List;
import java.util.Map;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * @author Sergey Mishanin
 */

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RouteManifestWaypointDetails extends DataEntity<RouteManifestWaypointDetails> {

  private Long id;
  private String address;
  private List<String> orderTags;
  private String status;
  private String priority;
  private String timeslot;
  private Long deliveriesCount;
  private Long pickupsCount;
  private String comments;
  private String contact;
  private String trackingIds;

  private Reservation reservation;
  private Pickup pickup;
  private Delivery delivery;

  public RouteManifestWaypointDetails(Map<String, ?> data) {
    super(data);
  }

  public void setId(Long id) {
    this.id = id;
  }

  public void setId(String id) {
    setId(Long.parseLong(id));
  }


  public List<String> getOrderTags() {
    return orderTags;
  }

  public void setOrderTags(List<String> orderTags) {
    this.orderTags = orderTags;
  }

  public void setOrderTags(String tags) {
    setOrderTags(splitAndNormalize(tags));
  }


  public void setDeliveriesCount(Long deliveriesCount) {
    this.deliveriesCount = deliveriesCount;
  }

  public void setDeliveriesCount(String deliveriesCount) {
    setDeliveriesCount(Long.parseLong(deliveriesCount));
  }


  public void setPickupsCount(Long pickupsCount) {
    this.pickupsCount = pickupsCount;
  }

  public void setPickupsCount(String pickupsCount) {
    setPickupsCount(Long.parseLong(pickupsCount));
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

  @Getter
  @Setter
  @NoArgsConstructor
  @AllArgsConstructor
  public static class Reservation extends DataEntity<Reservation> {

    private Long id;
    private String status;
    private String failureReason;


    public void setId(Long id) {
      this.id = id;
    }

    public void setId(String id) {
      setId(Long.parseLong(id));
    }


  }

  @Getter
  @Setter
  @NoArgsConstructor
  @AllArgsConstructor
  public static class Pickup extends DataEntity<Pickup> {

    private String trackingId;
    private String status;
    private String failureReason;

  }

  @Getter
  @Setter
  @NoArgsConstructor
  @AllArgsConstructor
  public static class Delivery extends DataEntity<Delivery> {

    private String trackingId;
    private String status;
    private String failureReason;

  }
}
