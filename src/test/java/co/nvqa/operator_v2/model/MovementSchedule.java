package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;

public class MovementSchedule extends DataEntity<MovementSchedule> {

  private List<Schedule> schedules;

  public List<Schedule> getSchedules() {
    return schedules;
  }

  public void setSchedules(List<Schedule> schedules) {
    this.schedules = schedules;
  }

  public Schedule getSchedule(int index) {
    if (CollectionUtils.isEmpty(schedules) || schedules.size() <= index) {
      return null;
    } else {
      return schedules.get(index);
    }
  }

  public void addSchedules(Schedule schedule) {
    if (schedules == null) {
      schedules = new ArrayList<>();
    }
    schedules.add(schedule);
  }

  public Schedule getSchedules(int index) {
    return getSchedule(index);
  }

  public static class Schedule extends DataEntity<Schedule> {

    private String originHub;
    private String destinationHub;
    private String movementType;
    private Set<String> daysOfWeek;
    private String departureTime;
    private Integer durationDays;
    private String durationTime;
    private String comment;

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

    public Integer getDurationDays() {
      return durationDays;
    }

    public void setDurationDays(Integer durationDays) {
      this.durationDays = durationDays;
    }

    public void setDurationDays(String durationDays) {
      setDurationDays(Integer.parseInt(durationDays));
    }

    public String getDurationTime() {
      return durationTime;
    }

    public void setDurationTime(String durationTime) {
      this.durationTime = durationTime;
    }
  }
}
