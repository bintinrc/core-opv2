package co.nvqa.operator_v2.model.dp;

public class DpOrderDetailsContent {

  private Long id;
  private String systemId;
  private Long orderId;
  private String rtsAt;
  private String completedAt;
  private String orderCreatedAt;
  private String status;
  private String granularStatus;

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getSystemId() {
    return systemId;
  }

  public void setSystemId(String systemId) {
    this.systemId = systemId;
  }

  public Long getOrderId() {
    return orderId;
  }

  public void setOrderId(Long orderId) {
    this.orderId = orderId;
  }

  public String getRtsAt() {
    return rtsAt;
  }

  public void setRtsAt(String rtsAt) {
    this.rtsAt = rtsAt;
  }

  public String getCompletedAt() {
    return completedAt;
  }

  public void setCompletedAt(String completedAt) {
    this.completedAt = completedAt;
  }

  public String getOrderCreatedAt() {
    return orderCreatedAt;
  }

  public void setOrderCreatedAt(String orderCreatedAt) {
    this.orderCreatedAt = orderCreatedAt;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public String getGranularStatus() {
    return granularStatus;
  }

  public void setGranularStatus(String granularStatus) {
    this.granularStatus = granularStatus;
  }

  public DpOrderDetailsContent(Long id, String systemId, Long orderId, String rtsAt,
      String completedAt, String orderCreatedAt, String status, String granularStatus) {
    this.id = id;
    this.systemId = systemId;
    this.orderId = orderId;
    this.rtsAt = rtsAt;
    this.completedAt = completedAt;
    this.orderCreatedAt = orderCreatedAt;
    this.status = status;
    this.granularStatus = granularStatus;
  }

  public DpOrderDetailsContent() {
  }
}
