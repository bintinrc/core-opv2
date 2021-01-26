package co.nvqa.operator_v2.model;

/**
 * @author Tristania Siagian
 */
public class ChangeDeliveryTiming {

  private String trackingId;
  private String startDate;
  private String endDate;
  private Integer timewindow;

  public ChangeDeliveryTiming() {
  }

  public String getTrackingId() {
    return trackingId;
  }

  public void setTrackingId(String trackingId) {
    this.trackingId = trackingId;
  }

  public String getStartDate() {
    return startDate;
  }

  public void setStartDate(String startDate) {
    this.startDate = startDate;
  }

  public String getEndDate() {
    return endDate;
  }

  public void setEndDate(String endDate) {
    this.endDate = endDate;
  }

  public Integer getTimewindow() {
    return timewindow;
  }

  public void setTimewindow(Integer timewindow) {
    this.timewindow = timewindow;
  }
}
