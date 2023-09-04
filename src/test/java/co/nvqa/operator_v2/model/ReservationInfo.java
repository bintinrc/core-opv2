package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import co.nvqa.commons.support.DateUtil;
import com.fasterxml.jackson.annotation.JsonIgnore;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.text.translate.CsvTranslators;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings({"WeakerAccess"})
public class ReservationInfo extends DataEntity<ReservationInfo> {

  private static final CsvTranslators.CsvEscaper CSV_ESCAPER = new CsvTranslators.CsvEscaper();

  private String id;
  private String shipperId;
  private String shipperName;
  private String pickupAddress;
  private String routeId;
  private String driverName;
  private String priorityLevel;
  private String readyBy;
  private String latestBy;
  private String reservationType;
  private String reservationStatus;
  private String reservationCreatedTime;
  private String serviceTime;
  private String approxVolume;
  private String failureReason;
  private String comments;

  public ReservationInfo() {
  }

  public ReservationInfo(Map<String, ?> data) {
    super(data);
  }

  public ReservationInfo(ReservationInfo reservationInfo) {
    setId(reservationInfo.getId());
    setShipperId(reservationInfo.getShipperId());
    setShipperName(reservationInfo.getShipperName());
    setPickupAddress(reservationInfo.getPickupAddress());
    setRouteId(reservationInfo.getRouteId());
    setDriverName(reservationInfo.getDriverName());
    setPriorityLevel(reservationInfo.getPriorityLevel());
    setReadyBy(reservationInfo.getReadyBy());
    setLatestBy(reservationInfo.getLatestBy());
    setReservationType(reservationInfo.getReservationType());
    setReservationStatus(reservationInfo.getReservationStatus());
    setReservationCreatedTime(reservationInfo.getReservationCreatedTime());
    setServiceTime(reservationInfo.getServiceTime());
    setApproxVolume(reservationInfo.getApproxVolume());
    setFailureReason(reservationInfo.getFailureReason());
    setComments(reservationInfo.getComments());
  }

  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
  }

  public String getShipperId() {
    return shipperId;
  }

  public void setShipperId(String shipperId) {
    this.shipperId = shipperId;
  }

  public String getShipperName() {
    return shipperName;
  }

  public void setShipperName(String shipperName) {
    this.shipperName = shipperName;
  }

  public String getPickupAddress() {
    return pickupAddress;
  }

  public void setPickupAddress(String pickupAddress) {
    this.pickupAddress = pickupAddress;
  }

  public String getRouteId() {
    return routeId;
  }

  public void setRouteId(String routeId) {
    this.routeId = routeId;
  }

  public String getDriverName() {
    return driverName;
  }

  public void setDriverName(String driverName) {
    this.driverName = driverName;
  }

  public String getPriorityLevel() {
    return priorityLevel;
  }

  public void setPriorityLevel(String priorityLevel) {
    this.priorityLevel = priorityLevel;
  }

  public String getReadyBy() {
    return readyBy;
  }

  public Date getReadyByDate() {
    if (readyBy == null) {
      return null;
    }
    return Date.from(getReadyByDateTime().toInstant());
  }

  @JsonIgnore
  public ZonedDateTime getReadyByDateTime() {
    if (readyBy == null) {
      return null;
    }
    return DateUtil.getDate(getReadyBy().replace(" ", "T") + "Z");
  }

  public void setReadyBy(String readyBy) {
    this.readyBy = readyBy;
  }

  public String getLatestBy() {
    return latestBy;
  }

  public Date getLatestByDate() {
    if (latestBy == null) {
      return null;
    }
    return Date.from(getLatestByDateTime().toInstant());
  }

  @JsonIgnore
  public ZonedDateTime getLatestByDateTime() {
    if (latestBy == null) {
      return null;
    }
    return DateUtil.getDate(getLatestBy().replace(" ", "T") + "Z");
  }

  public void setLatestBy(String latestBy) {
    this.latestBy = latestBy;
  }

  public String getReservationType() {
    return reservationType;
  }

  public void setReservationType(String reservationType) {
    this.reservationType = reservationType;
  }

  public String getReservationCreatedTime() {
    return reservationCreatedTime;
  }

  public void setReservationCreatedTime(String reservationCreatedTime) {
    this.reservationCreatedTime = reservationCreatedTime;
  }

  public String getServiceTime() {
    return serviceTime;
  }

  public void setServiceTime(String serviceTime) {
    this.serviceTime = serviceTime;
  }

  public String getApproxVolume() {
    return approxVolume;
  }

  public void setApproxVolume(String approxVolume) {
    this.approxVolume = approxVolume;
  }

  public String getFailureReason() {
    return failureReason;
  }

  public void setFailureReason(String failureReason) {
    this.failureReason = failureReason;
  }

  public String getComments() {
    return comments;
  }

  public void setComments(String comments) {
    this.comments = comments;
  }

  public String getReservationStatus() {
    return reservationStatus;
  }

  public void setReservationStatus(String reservationStatus) {
    this.reservationStatus = reservationStatus;
  }

  public String toCsvLine() {
    List<String> line = new ArrayList<>();
    line.add(escapeCsv(shipperName));
    line.add(escapeCsv(pickupAddress));
    line.add(escapeCsv(routeId));
    line.add(escapeCsv(driverName));
    line.add(escapeCsv(priorityLevel));
    line.add(escapeCsv(readyBy));
    line.add(escapeCsv(latestBy));
    line.add(escapeCsv(reservationType));
    line.add(escapeCsv(reservationStatus));
    line.add(escapeCsv(reservationCreatedTime));
    line.add(escapeCsv(serviceTime));
    line.add(escapeCsv(approxVolume));
    line.add(escapeCsv(failureReason));
    line.add(escapeCsv(comments));
    return StringUtils.join(line, ",");
  }

  private String escapeCsv(String text) {
    return text == null ? "-" : CSV_ESCAPER.translate(text);
  }
}
