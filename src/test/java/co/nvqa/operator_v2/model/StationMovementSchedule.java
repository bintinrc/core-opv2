package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import org.apache.commons.lang3.StringUtils;

import java.util.Arrays;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

public class StationMovementSchedule extends DataEntity<StationMovementSchedule> {

  private String crossdockHub;
  private String originHub;
  private String destinationHub;
  private String movementType;
  private String departureTime;
  private Integer duration;
  private String endTime;
  private Set<String> daysOfWeek;
  private String comment;

  public StationMovementSchedule() {
  }

  public StationMovementSchedule(Map<String, ?> data) {
    fromMap(data);
  }

  public String getCrossdockHub() {
    return crossdockHub;
  }

  public void setCrossdockHub(String crossdockHub) {
    this.crossdockHub = crossdockHub;
  }

  public String getOriginHub() {
    return originHub;
  }

  public void setOriginHub(String originHub) {
    this.originHub = originHub;
  }

  public String getDestinationHub() {
    return destinationHub;
  }

  public void setDestinationHub(String destinationHub) {
    this.destinationHub = destinationHub;
  }

  public String getMovementType() {
    return movementType;
  }

  public void setMovementType(String movementType) {
    this.movementType = movementType;
  }

  public String getDepartureTime() {
    return departureTime;
  }

  public void setDepartureTime(String departureTime) {
    this.departureTime = departureTime;
  }

  public Integer getDuration() {
    return duration;
  }

  public void setDuration(Integer duration) {
    this.duration = duration;
  }

  public void setDuration(String duration) {
    setDuration(Integer.valueOf(duration));
  }

  public String getEndTime() {
    return endTime;
  }

  public void setEndTime(String endTime) {
    this.endTime = endTime;
  }

  public Set<String> getDaysOfWeek() {
    return daysOfWeek;
  }

  public void setDaysOfWeek(Set<String> daysOfWeek) {
    this.daysOfWeek = daysOfWeek;
  }

  public void setDaysOfWeek(String daysOfWeek) {
    if (StringUtils.equalsAnyIgnoreCase(daysOfWeek, "all")) {
      daysOfWeek = "monday,tuesday,wednesday,thursday,friday,saturday,sunday";
    }
    String[] days = daysOfWeek.split(",");
    setDaysOfWeek(
            Arrays.stream(days).map(day -> day.trim().toLowerCase()).collect(Collectors.toSet()));
  }

  public String getComment() {
    return comment;
  }

  public void setComment(String comment) {
    this.comment = comment;
  }
}
