package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class RouteMonitoringParams extends DataEntity<RouteMonitoringParams> {

  private String driverName;
  private Long routeId;
  private Integer totalParcels;
  private Double completionPercentage;
  private Integer totalWaypoint;
  private Integer pendingPriorityParcels;
  private Integer pendingCount;
  private Integer numLateAndPending;
  private Integer successCount;
  private Integer numInvalidFailed;
  private Integer numValidFailed;
  private Integer earlyCount;
  private Integer lateCount;
  private Integer failedCount;
  private Integer cmiCount;

  public RouteMonitoringParams() {
  }

  public RouteMonitoringParams(Map<String, String> data) {
    fromMap(data);
  }

  public String getDriverName() {
    return driverName;
  }

  public void setDriverName(String driverName) {
    this.driverName = driverName;
  }

  public Long getRouteId() {
    return routeId;
  }

  public void setRouteId(Long routeId) {
    this.routeId = routeId;
  }

  public void setRouteId(String routeId) {
    setRouteId(Long.parseLong(routeId));
  }

  public Integer getTotalWaypoint() {
    return totalWaypoint;
  }

  public void setTotalWaypoint(Integer totalWaypoint) {
    this.totalWaypoint = totalWaypoint;
  }

  public void setTotalWaypoint(String totalWaypoint) {
    setTotalWaypoint(Integer.parseInt(totalWaypoint));
  }

  public Double getCompletionPercentage() {
    return completionPercentage;
  }

  public void setCompletionPercentage(Double completionPercentage) {
    this.completionPercentage = completionPercentage;
  }

  public void setCompletionPercentage(String completionPercentage) {
    setCompletionPercentage(Double.valueOf(completionPercentage));
  }

  public Integer getPendingCount() {
    return pendingCount;
  }

  public void setPendingCount(Integer pendingCount) {
    this.pendingCount = pendingCount;
  }

  public void setPendingCount(String pendingCount) {
    setPendingCount(Integer.parseInt(pendingCount));
  }

  public Integer getSuccessCount() {
    return successCount;
  }

  public void setSuccessCount(Integer successCount) {
    this.successCount = successCount;
  }

  public void setSuccessCount(String successCount) {
    setSuccessCount(Integer.parseInt(successCount));
  }

  public Integer getFailedCount() {
    return failedCount;
  }

  public void setFailedCount(Integer failedCount) {
    this.failedCount = failedCount;
  }

  public void setFailedCount(String failedCount) {
    setFailedCount(Integer.parseInt(failedCount));
  }

  public Integer getCmiCount() {
    return cmiCount;
  }

  public void setCmiCount(Integer cmiCount) {
    this.cmiCount = cmiCount;
  }

  public void setCmiCount(String cmiCount) {
    setCmiCount(Integer.parseInt(cmiCount));
  }

  public Integer getEarlyCount() {
    return earlyCount;
  }

  public void setEarlyCount(Integer earlyCount) {
    this.earlyCount = earlyCount;
  }

  public void setEarlyCount(String earlyCount) {
    setEarlyCount(Integer.parseInt(earlyCount));
  }

  public Integer getLateCount() {
    return lateCount;
  }

  public void setLateCount(Integer lateCount) {
    this.lateCount = lateCount;
  }

  public void setLateCount(String lateCount) {
    setLateCount(Integer.parseInt(lateCount));
  }

  @Override
  public void fromCsvLine(String csvLine) {
    throw new UnsupportedOperationException();
  }

  public Integer getTotalParcels() {
    return totalParcels;
  }

  public void setTotalParcels(Integer totalParcelCount) {
    this.totalParcels = totalParcelCount;
  }

  public void setTotalParcels(String totalParcelCount) {
    setTotalParcels(Integer.valueOf(totalParcelCount));
  }

  public Integer getNumLateAndPending() {
    return numLateAndPending;
  }

  public void setNumLateAndPending(Integer numLateAndPending) {
    this.numLateAndPending = numLateAndPending;
  }

  public void setNumLateAndPending(String numLateAndPending) {
    setNumLateAndPending(Integer.valueOf(numLateAndPending));
  }

  public Integer getNumInvalidFailed() {
    return numInvalidFailed;
  }

  public void setNumInvalidFailed(Integer numInvalidFailed) {
    this.numInvalidFailed = numInvalidFailed;
  }

  public void setNumInvalidFailed(String numInvalidFailed) {
    setNumInvalidFailed(Integer.valueOf(numInvalidFailed));
  }

  public Integer getNumValidFailed() {
    return numValidFailed;
  }

  public void setNumValidFailed(Integer numValidFailed) {
    this.numValidFailed = numValidFailed;
  }

  public void setNumValidFailed(String numValidFailed) {
    setNumValidFailed(Integer.valueOf(numValidFailed));
  }

  public Integer getPendingPriorityParcels() {
    return pendingPriorityParcels;
  }

  public void setPendingPriorityParcels(Integer pendingPriorityParcels) {
    this.pendingPriorityParcels = pendingPriorityParcels;
  }

  public void setPendingPriorityParcels(String pendingPriorityParcels) {
    setPendingPriorityParcels(Integer.parseInt(pendingPriorityParcels));
  }
}
