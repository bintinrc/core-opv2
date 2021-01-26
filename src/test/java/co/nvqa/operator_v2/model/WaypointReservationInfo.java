package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import co.nvqa.commons.model.core.Address;

/**
 * @author Sergey Mishanin
 */
public class WaypointReservationInfo extends DataEntity<WaypointReservationInfo> {

  private Long reservationId;
  private String location;
  private String readyToLatestTime;
  private String approxVolume;
  private String status;
  private Long receivedParcels;

  public Long getReservationId() {
    return reservationId;
  }

  public void setReservationId(Long reservationId) {
    this.reservationId = reservationId;
  }

  public void setReservationId(String reservationId) {
    setReservationId(Long.parseLong(reservationId));
  }

  public String getLocation() {
    return location;
  }

  public void setLocation(String location) {
    this.location = location;
  }

  public void setLocation(Address location) {
    String address =
        location.getAddress1() + " " + location.getAddress2() + " " + location.getPostcode() + " "
            + location.getCountry();
    setLocation(address.trim());
  }

  public String getReadyToLatestTime() {
    return readyToLatestTime;
  }

  public void setReadyToLatestTime(String readyToLatestTime) {
    this.readyToLatestTime = readyToLatestTime;
  }

  public String getApproxVolume() {
    return approxVolume;
  }

  public void setApproxVolume(String approxVolume) {
    this.approxVolume = approxVolume;
  }

  public Long getReceivedParcels() {
    return receivedParcels;
  }

  public void setReceivedParcels(Long receivedParcels) {
    this.receivedParcels = receivedParcels;
  }

  public void setReceivedParcels(String receivedParcels) {
    setReceivedParcels(Long.parseLong(receivedParcels));
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }
}
