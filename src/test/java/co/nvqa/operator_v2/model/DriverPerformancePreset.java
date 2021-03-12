package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import java.util.List;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class DriverPerformancePreset extends DataEntity<DriverPerformancePreset> {

  private List<String> hubs;
  private List<String> driverNames;
  private List<String> driverTypes;
  private String name;

  public DriverPerformancePreset() {
  }

  public DriverPerformancePreset(Map<String, ?> data) {
    super(data);
  }

  public List<String> getHubs() {
    return hubs;
  }

  public void setHubs(List<String> hubs) {
    this.hubs = hubs;
  }

  public void setHubs(String hubs) {
    setHubs(splitAndNormalize(hubs));
  }

  public List<String> getDriverNames() {
    return driverNames;
  }

  public void setDriverNames(List<String> driverNames) {
    this.driverNames = driverNames;
  }

  public void setDriverNames(String driverNames) {
    setDriverNames(splitAndNormalize(driverNames));
  }

  public List<String> getDriverTypes() {
    return driverTypes;
  }

  public void setDriverTypes(List<String> driverTypes) {
    this.driverTypes = driverTypes;
  }

  public void setDriverTypes(String driverTypes) {
    setDriverTypes(splitAndNormalize(driverTypes));
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }
}
