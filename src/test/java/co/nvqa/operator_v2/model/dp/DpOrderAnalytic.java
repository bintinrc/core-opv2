package co.nvqa.operator_v2.model.dp;

import java.util.Date;

public class DpOrderAnalytic {

  private Long id;
  private String systemId;
  private Long orderId;
  private DpOrderDetailsContent content;
  private Date createdAt;
  private Date updatedAt;

  public DpOrderAnalytic(Long id, String systemId, Long orderId,
      DpOrderDetailsContent content, Date createdAt, Date updatedAt) {
    this.id = id;
    this.systemId = systemId;
    this.orderId = orderId;
    this.content = content;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }

  public DpOrderAnalytic() {

  }

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

  public DpOrderDetailsContent getContent() {
    return content;
  }

  public void setContent(DpOrderDetailsContent content) {
    this.content = content;
  }

  public Date getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(Date createdAt) {
    this.createdAt = createdAt;
  }

  public Date getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(Date updatedAt) {
    this.updatedAt = updatedAt;
  }
}
