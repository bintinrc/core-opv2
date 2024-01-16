package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.Map;

public class PodDetail extends DataEntity<PodDetail> {

  String podId;
  String waypointType;
  String type;
  String status;
  String distance;
  String podTime;
  String driver;
  String recipient;
  String address;
  String verificationMethod;

  public PodDetail(Map<String, ?> dataMap) {
    fromMap(dataMap);
  }

  public PodDetail() {

  }

  public String getPodId() {
    return podId;
  }

  public void setPodId(String podId) {
    this.podId = podId;
  }

  public String getWaypointType() {
    return waypointType;
  }

  public void setWaypointType(String waypointType) {
    this.waypointType = waypointType;
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

  public String getDistance() {
    return distance;
  }

  public void setDistance(String distance) {
    this.distance = distance;
  }

  public String getPodTime() {
    return podTime;
  }

  public void setPodTime(String podTime) {
    this.podTime = podTime;
  }

  public String getDriver() {
    return driver;
  }

  public void setDriver(String driver) {
    this.driver = driver;
  }

  public String getRecipient() {
    return recipient;
  }

  public void setRecipient(String recipient) {
    this.recipient = recipient;
  }

  public String getAddress() {
    return address;
  }

  public void setAddress(String address) {
    this.address = address;
  }

  public String getVerificationMethod() {
    return verificationMethod;
  }

  public void setVerificationMethod(String verificationMethod) {
    this.verificationMethod = verificationMethod;
  }

}
