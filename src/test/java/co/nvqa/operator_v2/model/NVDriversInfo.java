package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.Map;

/**
 * @author Veera
 */

public class NVDriversInfo extends DataEntity<NVDriversInfo> {

  @JsonProperty("ID")
  private String id;

  @JsonProperty("Name")
  private String name;

  @JsonProperty("Hub")
  private String hub;

  @JsonProperty("Type")
  private String type;

  @JsonProperty("Vehicle")
  private String vehicle;

  @JsonProperty("Own")
  private String own;

  @JsonProperty("Zone")
  private String zone;

  @JsonProperty("Min Capacity")
  private String minCapacity;

  @JsonProperty("Max Capacity")
  private String maxCapacity;

  @JsonProperty("Driver License Number")
  private String licenseNumber;

  @JsonProperty("Comments")
  private String comments;

  @JsonProperty("Attendance")
  private String attendance;

  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getType() {
    return type;
  }

  public void setType(String type) {
    this.type = type;
  }

  public String getVehicle() {
    return vehicle;
  }

  public void setVehicle(String vehicle) {
    this.vehicle = vehicle;
  }

  public String getOwn() {
    return own;
  }

  public void setOwn(String own) {
    this.own = own;
  }

  public String getZone() {
    return zone;
  }

  public void setZone(String zone) {
    this.zone = zone;
  }

  public String getMinCapacity() {
    return minCapacity;
  }

  public void setMinCapacity(String minCapacity) {
    this.minCapacity = minCapacity;
  }

  public String getMaxCapacity() {
    return maxCapacity;
  }

  public void setMaxCapacity(String maxCapacity) {
    this.maxCapacity = maxCapacity;
  }

  public String getLicenseNumber() {
    return licenseNumber;
  }

  public void setLicenseNumber(String licenseNumber) {
    this.licenseNumber = licenseNumber;
  }

  public String getComments() {
    return comments;
  }

  public void setComments(String comments) {
    this.comments = comments;
  }

  public String getAttendance() {
    return attendance;
  }

  public void setAttendance(String attendance) {
    this.attendance = attendance;
  }

  public String getHub() {
    return hub;
  }

  public void setHub(String hub) {
    this.hub = hub;
  }

  public NVDriversInfo() {
  }

  public NVDriversInfo(Map<String, ?> dataMap) {
    fromMap(dataMap);
  }

  @Override
  public void fromCsvLine(String csvLine) {
    String[] values = splitCsvLine(csvLine);
    setId(getValueIfIndexExists(values, 0));
    setName(getValueIfIndexExists(values, 1));
    setHub(getValueIfIndexExists(values, 2));
    setType(getValueIfIndexExists(values, 3));
    setVehicle(getValueIfIndexExists(values, 4));
    setOwn(getValueIfIndexExists(values, 5));
    setZone(getValueIfIndexExists(values, 6));
    setMinCapacity(getValueIfIndexExists(values, 7));
    setMaxCapacity(getValueIfIndexExists(values, 8));
    setLicenseNumber(getValueIfIndexExists(values, 9));
    setComments(getValueIfIndexExists(values, 10));
    setAttendance(getValueIfIndexExists(values, 11));
  }

}
