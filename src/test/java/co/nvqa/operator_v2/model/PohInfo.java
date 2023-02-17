package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.Map;

public class PohInfo extends DataEntity<PohInfo> {
  private String handoverDatetime;
  private int estQty;
  private int cntQty;
  private String handover;
  private String sortHubName;
  private String staffUsername;

  public PohInfo() {
  }

  public PohInfo(Map<String, ?> data) {
    super(data);
  }

  public String getHandoverDatetime() {
    return handoverDatetime;
  }

  public void setHandoverDatetime(String handoverDatetime) {
    this.handoverDatetime = handoverDatetime;
  }

  public int getEstQty() {
    return estQty;
  }

  public void setEstQty(int estQty) {
    this.estQty = estQty;
  }

  public int getCntQty() {
    return cntQty;
  }

  public void setCntQty(int cntQty) {
    this.cntQty = cntQty;
  }

  public String getHandover() {
    return handover;
  }

  public void setHandover(String handover) {
    this.handover = handover;
  }

  public String getSortHubName() {
    return sortHubName;
  }

  public void setSortHubName(String sortHubName) {
    this.sortHubName = sortHubName;
  }

  public String getStaffUsername() {
    return staffUsername;
  }

  public void setStaffUsername(String staffUsername) {
    this.staffUsername = staffUsername;
  }
}
