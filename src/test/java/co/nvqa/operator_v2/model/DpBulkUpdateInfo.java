package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;

public class DpBulkUpdateInfo extends DataEntity<DpBulkUpdateInfo> {

  private String dpId;
  private String status;
  private String failureReason;

  public void setDpId(String dpId) {
    this.dpId=dpId;
  }

  public String getDpId() {
    return dpId;
  }

  public void setStatus(String status) {
    this.status=status;
  }

  public String getStatus() {
    return status;
  }

  public void setFailureReason(String failureReason) {
    this.failureReason=failureReason;
  }

  public String getFailureReason() {
    return failureReason;
  }

  @Override
  public void fromCsvLine(String csvLine) {
    String[] values = splitCsvLine(csvLine);
    setDpId(getValueIfIndexExists(values, 0));
    setStatus(getValueIfIndexExists(values, 1));
    setFailureReason(getValueIfIndexExists(values, 2));
  }
}
