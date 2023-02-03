package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.Map;

public class PoaInfo extends DataEntity<PoaInfo> {
  private String arrivalDateTime;
  private String verifiedByGps;
  private String distanceFromSortHub;

  public PoaInfo() {
  }

  public PoaInfo(Map<String, ?> data) {super(data);}

  public String getArrivalDateTime() {
    return arrivalDateTime;
  }

  public void setArrivalDateTime(String arrivalDateTime) {
    this.arrivalDateTime = arrivalDateTime;
  }

  public String getVerifiedByGps() {
    return verifiedByGps;
  }

  public void setVerifiedByGps(String verifiedByGps) {
    this.verifiedByGps = verifiedByGps;
  }

  public String getDistanceFromSortHub() {
    return distanceFromSortHub;
  }

  public void setDistanceFromSortHub(String distanceFromSortHub) {
    this.distanceFromSortHub = distanceFromSortHub;
  }
}
