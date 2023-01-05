package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class PendingPriorityOrder extends DataEntity<PendingPriorityOrder> {

  private String trackingId;
  private String customerName;
  private List<String> tags;
  private String address;

  public PendingPriorityOrder() {
  }

  public PendingPriorityOrder(Map<String, String> data) {
    fromMap(data);
  }

  public String getTrackingId() {
    return trackingId;
  }

  public void setTrackingId(String trackingId) {
    this.trackingId = trackingId;
  }

  public String getCustomerName() {
    return customerName;
  }

  public void setCustomerName(String customerName) {
    this.customerName = customerName;
  }

  public List<String> getTags() {
    return tags;
  }

  public void setTags(List<String> tags) {
    this.tags = tags;
  }

  public void clearTags() {
    this.tags = null;
  }

  public void setTags(String tags) {
    setTags(Arrays.asList(tags.split(",")));
  }

  public String getAddress() {
    return address;
  }

  public void setAddress(String address) {
    this.address = address;
  }
}
