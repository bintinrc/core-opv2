package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;

import java.util.Map;

public class FailedPickup extends DataEntity<FailedPickup> {
  private String trackingId;
  private String shipperName;
  private String lastAttemptTime;
  private String failureReasonComments;
  private Integer attemptCount;
  private Integer invalidFailureCount;
  private Integer validFailureCount;
  private String failureReasonCodeDescription;
  private Integer daysSinceLastAttempt;
  private Integer priorityLevel;

  public FailedPickup() {
  }

  public FailedPickup(Map<String, ?> data) {
    fromMap(data);
  }

  public String getTrackingId() {
    return trackingId;
  }

  public void setTrackingId(String trackingId) {
    this.trackingId = trackingId;
  }

  public String getShipperName() {
    return shipperName;
  }

  public void setShipperName(String shipperName) {
    this.shipperName = shipperName;
  }

  public String getLastAttemptTime() {
    return lastAttemptTime;
  }

  public void setLastAttemptTime(String lastAttemptTime) {
    this.lastAttemptTime = lastAttemptTime;
  }

  public String getFailureReasonComments() {
    return failureReasonComments;
  }

  public void setFailureReasonComments(String failureReasonComments) {
    this.failureReasonComments = failureReasonComments;
  }

  public Integer getAttemptCount() {
    return attemptCount;
  }

  public void setAttemptCount(Integer attemptCount) {
    this.attemptCount = attemptCount;
  }

  public void setAttemptCount(String attemptCount) {
    setAttemptCount(Integer.valueOf(attemptCount));
  }

  public Integer getInvalidFailureCount() {
    return invalidFailureCount;
  }

  public void setInvalidFailureCount(Integer invalidFailureCount) {
    this.invalidFailureCount = invalidFailureCount;
  }

  public void setInvalidFailureCount(String invalidFailureCount) {
    setInvalidFailureCount(Integer.valueOf(invalidFailureCount));
  }

  public Integer getValidFailureCount() {
    return validFailureCount;
  }

  public void setValidFailureCount(Integer validFailureCount) {
    this.validFailureCount = validFailureCount;
  }

  public void setValidFailureCount(String validFailureCount) {
    setValidFailureCount(Integer.valueOf(validFailureCount));
  }

  public String getFailureReasonCodeDescription() {
    return failureReasonCodeDescription;
  }

  public void setFailureReasonCodeDescription(String failureReasonCodeDescription) {
    this.failureReasonCodeDescription = failureReasonCodeDescription;
  }

  public Integer getDaysSinceLastAttempt() {
    return daysSinceLastAttempt;
  }

  public void setDaysSinceLastAttempt(Integer daysSinceLastAttempt) {
    this.daysSinceLastAttempt = daysSinceLastAttempt;
  }

  public void setDaysSinceLastAttempt(String daysSinceLastAttempt) {
    if ("today".equalsIgnoreCase(daysSinceLastAttempt)) {
      daysSinceLastAttempt = "0";
    }
    setDaysSinceLastAttempt(Integer.valueOf(daysSinceLastAttempt));
  }

  public Integer getPriorityLevel() {
    return priorityLevel;
  }

  public void setPriorityLevel(Integer priorityLevel) {
    this.priorityLevel = priorityLevel;
  }

  public void setPriorityLevel(String priorityLevel) {
    setPriorityLevel(Integer.valueOf(priorityLevel));
  }

  @Override
  public void fromCsvLine(String csvLine) {
    String[] values = splitCsvLine(csvLine);
    setTrackingId(getValueIfIndexExists(values, 1));
    setShipperName(getValueIfIndexExists(values, 2));
    setLastAttemptTime(getValueIfIndexExists(values, 3));
    setFailureReasonComments(getValueIfIndexExists(values, 4));
    setAttemptCount(getValueIfIndexExists(values, 5));
    setInvalidFailureCount(getValueIfIndexExists(values, 6));
    setValidFailureCount(getValueIfIndexExists(values, 7));
    setFailureReasonCodeDescription(getValueIfIndexExists(values, 8));
    setDaysSinceLastAttempt(getValueIfIndexExists(values, 9));
    setPriorityLevel(getValueIfIndexExists(values, 10));
  }
}
