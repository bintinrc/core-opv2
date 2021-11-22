package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.Map;

/**
 * @author Veera
 */
public class StationSummaryTabInfo extends DataEntity<StationSummaryTabInfo> {

  @JsonProperty("No.")
  private String no;

  @JsonProperty("Driver Name")
  private String driverName;

  @JsonProperty("Hub")
  private String hub;

  @JsonProperty("Route ID")
  private String routeId;

  @JsonProperty("COD Amount")
  private String codAmount;

  public StationSummaryTabInfo() {
  }

  public StationSummaryTabInfo(Map<String, ?> dataMap) {
    fromMap(dataMap);
  }

  public String getNo() {
    return no;
  }

  public void setNo(String no) {
    this.no = no;
  }

  public String getDriverName() {
    return driverName;
  }

  public void setDriverName(String driverName) {
    this.driverName = driverName;
  }

  public String getHub() {
    return hub;
  }

  public void setHub(String hub) {
    this.hub = hub;
  }

  public String getRouteId() {
    return routeId;
  }

  public void setRouteId(String routeId) {
    this.routeId = routeId;
  }

  public String getCodAmount() {
    return codAmount;
  }

  public void setCodAmount(String codAmount) {
    this.codAmount = codAmount;
  }

  @Override
  public void fromCsvLine(String csvLine) {
    String[] values = splitCsvLine(csvLine);
    setNo(getValueIfIndexExists(values, 0));
    setDriverName(getValueIfIndexExists(values, 1));
    setHub(getValueIfIndexExists(values, 2));
    setRouteId(getValueIfIndexExists(values, 3));
    setCodAmount(getValueIfIndexExists(values, 4));
  }

}
