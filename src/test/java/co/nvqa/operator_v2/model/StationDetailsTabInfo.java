package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.google.gson.annotations.SerializedName;
import java.util.Map;

/**
 * @author Veera
 */
public class StationDetailsTabInfo extends DataEntity<StationDetailsTabInfo> {

  @JsonProperty("No.")
  private String no;

  @JsonProperty("Route ID")
  private String routeId;

  @JsonProperty("Tracking ID/ Reservation ID")
  private String trackingId;

  @JsonProperty("Hub")
  private String hub;

  @JsonProperty("Route Date")
  private String routeDate;

  @JsonProperty("Transaction End Datetime")
  private String transEndDateTime;

  @JsonProperty("Transaction Status")
  private String transStatus;

  @JsonProperty("Granular Status")
  private String granularStatus;

  @JsonProperty("Collected At")
  private String collectedAt;

  @JsonProperty("COD Amount")
  private String codAmount;

  @JsonProperty("Shipper Name")
  private String shipperName;

  @JsonProperty("Driver Name")
  private String driverName;

  @JsonProperty("Driver ID")
  private String driverId;

  public StationDetailsTabInfo() {
  }

  public String getNo() {
    return no;
  }

  public void setNo(String no) {
    this.no = no;
  }

  public String getRouteId() {
    return routeId;
  }

  public void setRouteId(String routeId) {
    this.routeId = routeId;
  }

  public String getTrackingId() {
    return trackingId;
  }

  public void setTrackingId(String trackingId) {
    this.trackingId = trackingId;
  }

  public String getHub() {
    return hub;
  }

  public void setHub(String hub) {
    this.hub = hub;
  }

  public String getRouteDate() {
    return routeDate;
  }

  public void setRouteDate(String routeDate) {
    this.routeDate = routeDate;
  }

  public String getTransEndDateTime() {
    return transEndDateTime;
  }

  public void setTransEndDateTime(String transEndDateTime) {
    this.transEndDateTime = transEndDateTime;
  }

  public String getTransStatus() {
    return transStatus;
  }

  public void setTransStatus(String transStatus) {
    this.transStatus = transStatus;
  }

  public String getGranularStatus() {
    return granularStatus;
  }

  public void setGranularStatus(String granularStatus) {
    this.granularStatus = granularStatus;
  }

  public String getCollectedAt() {
    return collectedAt;
  }

  public void setCollectedAt(String collectedAt) {
    this.collectedAt = collectedAt;
  }

  public String getCodAmount() {
    return codAmount;
  }

  public void setCodAmount(String codAmount) {
    this.codAmount = codAmount;
  }

  public String getShipperName() {
    return shipperName;
  }

  public void setShipperName(String shipperName) {
    this.shipperName = shipperName;
  }

  public String getDriverName() {
    return driverName;
  }

  public void setDriverName(String driverName) {
    this.driverName = driverName;
  }

  public String getDriverId() {
    return driverId;
  }

  public void setDriverId(String driverId) {
    this.driverId = driverId;
  }

  public StationDetailsTabInfo(Map<String, ?> dataMap) {
    fromMap(dataMap);
  }


  @Override
  public void fromCsvLine(String csvLine) {
    String[] values = splitCsvLine(csvLine);
    setNo(getValueIfIndexExists(values, 0));
    setRouteId(getValueIfIndexExists(values, 1));
    setTrackingId(getValueIfIndexExists(values, 2));
    setHub(getValueIfIndexExists(values, 3));
    setRouteDate(getValueIfIndexExists(values, 4));
    setTransEndDateTime(getValueIfIndexExists(values, 5));
    setTransStatus(getValueIfIndexExists(values, 6));
    setGranularStatus(getValueIfIndexExists(values, 7));
    setCollectedAt(getValueIfIndexExists(values, 8));
    setCodAmount(getValueIfIndexExists(values, 9));
    setShipperName(getValueIfIndexExists(values, 10));
    setDriverName(getValueIfIndexExists(values, 11));
    setDriverId(getValueIfIndexExists(values, 12));
  }

}
