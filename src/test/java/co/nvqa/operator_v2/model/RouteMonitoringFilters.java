package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.Date;
import java.util.Map;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteMonitoringFilters extends DataEntity<RouteMonitoringFilters> {

  private Date routeDate;
  private String[] routeTags;
  private String[] hubs;
  private String[] zones;

  public RouteMonitoringFilters() {
  }

  public RouteMonitoringFilters(Map<String, ?> data) {
    fromMap(data);
  }

  public Date getRouteDate() {
    return routeDate;
  }

  public void setRouteDate(Date routeDate) {
    this.routeDate = routeDate;
  }

  public String[] getRouteTags() {
    return routeTags;
  }

  public void setRouteTags(String[] routeTags) {
    this.routeTags = routeTags;
  }

  public String[] getHubs() {
    return hubs;
  }

  public void setHubs(String[] hubs) {
    this.hubs = hubs;
  }

  public void setHubs(String hubs) {
    setHubs(hubs.split(";"));
  }

  public String[] getZones() {
    return zones;
  }

  public void setZones(String[] zones) {
    this.zones = zones;
  }

  public void setZones(String zones) {
    setZones(zones.split(";"));
  }
}
