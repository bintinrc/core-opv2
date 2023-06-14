package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class OrderStatusReportEntry extends DataEntity<OrderStatusReportEntry> {

  private String trackingId;
  private String status;
  private String size;
  private String inboundDate;
  private String orderCreationDate;
  private String estimatedDeliveryDate;
  private String firstDeliveryAttempt;
  private String lastDeliveryAttempt;
  private Integer deliveryAttempts;
  private String secondDeliveryAttempt;
  private String thirdDeliveryAttempt;
  private String lastUpdateScan;
  private String failureReason;

  public OrderStatusReportEntry() {
  }

  public OrderStatusReportEntry(Map<String, ?> data) {
    fromMap(data);
  }

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

  public String getSize() {
    return size;
  }

  public void setSize(String size) {
    this.size = size;
  }

  public String getInboundDate() {
    return inboundDate;
  }

  public void setInboundDate(String inboundDate) {
    this.inboundDate = inboundDate;
  }

  public String getOrderCreationDate() {
    return orderCreationDate;
  }

  public void setOrderCreationDate(String orderCreationDate) {
    this.orderCreationDate = orderCreationDate;
  }

  public String getEstimatedDeliveryDate() {
    return estimatedDeliveryDate;
  }

  public void setEstimatedDeliveryDate(String estimatedDeliveryDate) {
    this.estimatedDeliveryDate = estimatedDeliveryDate;
  }

  public String getFirstDeliveryAttempt() {
    return firstDeliveryAttempt;
  }

  public void setFirstDeliveryAttempt(String firstDeliveryAttempt) {
    this.firstDeliveryAttempt = firstDeliveryAttempt;
  }

  public String getLastDeliveryAttempt() {
    return lastDeliveryAttempt;
  }

  public void setLastDeliveryAttempt(String lastDeliveryAttempt) {
    this.lastDeliveryAttempt = lastDeliveryAttempt;
  }

  public Integer getDeliveryAttempts() {
    return deliveryAttempts;
  }

  public void setDeliveryAttempts(Integer deliveryAttempts) {
    this.deliveryAttempts = deliveryAttempts;
  }

  public void setDeliveryAttempts(String deliveryAttempts) {
    setDeliveryAttempts(Integer.valueOf(deliveryAttempts));
  }

  public String getSecondDeliveryAttempt() {
    return secondDeliveryAttempt;
  }

  public void setSecondDeliveryAttempt(String secondDeliveryAttempt) {
    this.secondDeliveryAttempt = secondDeliveryAttempt;
  }

  public String getThirdDeliveryAttempt() {
    return thirdDeliveryAttempt;
  }

  public void setThirdDeliveryAttempt(String thirdDeliveryAttempt) {
    this.thirdDeliveryAttempt = thirdDeliveryAttempt;
  }

  public String getLastUpdateScan() {
    return lastUpdateScan;
  }

  public void setLastUpdateScan(String lastUpdateScan) {
    this.lastUpdateScan = lastUpdateScan;
  }

  public String getFailureReason() {
    return failureReason;
  }

  public void setFailureReason(String failureReason) {
    this.failureReason = failureReason;
  }

  @Override
  public void fromCsvLine(String csvLine) {
    String[] values = splitCsvLine(csvLine);
    setTrackingId(getValueIfIndexExists(values, 0));
    setStatus(getValueIfIndexExists(values, 1));
    setSize(getValueIfIndexExists(values, 2));
    setInboundDate(getValueIfIndexExists(values, 3));
    setOrderCreationDate(getValueIfIndexExists(values, 4));
    setEstimatedDeliveryDate(getValueIfIndexExists(values, 5));
    setFirstDeliveryAttempt(getValueIfIndexExists(values, 6));
    setLastDeliveryAttempt(getValueIfIndexExists(values, 7));
    setDeliveryAttempts(getValueIfIndexExists(values, 8));
    setSecondDeliveryAttempt(getValueIfIndexExists(values, 9));
    setThirdDeliveryAttempt(getValueIfIndexExists(values, 10));
    setLastUpdateScan(getValueIfIndexExists(values, 11));
    setFailureReason(getValueIfIndexExists(values, 12));
  }
}
