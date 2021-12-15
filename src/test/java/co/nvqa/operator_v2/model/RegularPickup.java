package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;

public class RegularPickup extends DataEntity<RegularPickup> {

  private String trackingId;
  private String errorMessage;

  public String getTrackingId() {
    return trackingId;
  }

  public void setTrackingId(String trackingId) {
    this.trackingId = trackingId;
  }

  public String getErrorMessage() {
    return errorMessage;
  }

  public void setErrorMessage(String errorMessage) {
    this.errorMessage = errorMessage;
  }

  @Override
  public void fromCsvLine(String csvLine) {
    String[] values = splitCsvLine(csvLine);
    setTrackingId(getValueIfIndexExists(values, 0));
    setErrorMessage(getValueIfIndexExists(values, 1));
  }
}
