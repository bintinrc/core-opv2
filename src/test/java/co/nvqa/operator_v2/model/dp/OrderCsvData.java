package co.nvqa.operator_v2.model.dp;

import co.nvqa.commons.model.DataEntity;

public class OrderCsvData extends DataEntity<OrderCsvData> {

  private String trackingId;
  private String status;

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

  @Override
  public void fromCsvLine(String csvLine) {
    String[] values = splitCsvLine(csvLine);
    setTrackingId(getValueIfIndexExists(values, 0));
    setStatus(getValueIfIndexExists(values, 1));
  }
}
