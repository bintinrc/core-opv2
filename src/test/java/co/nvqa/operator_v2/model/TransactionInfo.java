package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class TransactionInfo extends DataEntity<TransactionInfo> {

  private String serviceEndTime;
  private String type;
  private String status;
  private String driver;
  private String routeId;
  private String routeDate;
  private String dpId;
  private String failureReason;
  private String priorityLevel;
  private String dnr;
  private String name;
  private String contact;
  private String email;
  private String destinationAddress;

  public TransactionInfo() {
  }

  public TransactionInfo(Map<String, ?> dataMap) {
    fromMap(dataMap);
  }

  public String getServiceEndTime() {
    return serviceEndTime;
  }

  public void setServiceEndTime(String serviceEndTime) {
    this.serviceEndTime = serviceEndTime;
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

  public String getDriver() {
    return driver;
  }

  public void setDriver(String driver) {
    this.driver = driver;
  }

  public String getRouteId() {
    return routeId;
  }

  public void setRouteId(String routeId) {
    this.routeId = routeId;
  }

  public String getDpId() {
    return dpId;
  }

  public void setDpId(String dpId) {
    this.dpId = dpId;
  }

  public String getFailureReason() {
    return failureReason;
  }

  public void setFailureReason(String failureReason) {
    this.failureReason = failureReason;
  }

  public String getPriorityLevel() {
    return priorityLevel;
  }

  public void setPriorityLevel(String priorityLevel) {
    this.priorityLevel = priorityLevel;
  }

  public String getDnr() {
    return dnr;
  }

  public void setDnr(String dnr) {
    this.dnr = dnr;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getContact() {
    return contact;
  }

  public void setContact(String contact) {
    this.contact = contact;
  }

  public String getEmail() {
    return email;
  }

  public void setEmail(String email) {
    this.email = email;
  }

  public String getDestinationAddress() {
    return destinationAddress;
  }

  public void setDestinationAddress(String destinationAddress) {
    this.destinationAddress = destinationAddress;
  }

  public String getRouteDate() {
    return routeDate;
  }

  public void setRouteDate(String routeDate) {
    this.routeDate = routeDate;
  }
}
