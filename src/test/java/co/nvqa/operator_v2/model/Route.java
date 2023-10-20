package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.core.Driver;
import co.nvqa.commons.model.core.Vehicle;
import co.nvqa.commons.model.core.Waypoint;
import com.fasterxml.jackson.annotation.JsonIgnore;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Route {

  private Boolean archived;
  private String comments;
  private String createdAt;
  @JsonIgnore
  private Date createdAtAsDate;
  private String deletedAt;
  private String date;
  private String dateTime;
  private Long driverId;
  private String driverName;
  private Integer flags;
  private Long hubId;
  private Long id;
  private String largestParcelSize;
  private String routePassword;
  private List<Integer> tags = new ArrayList<>();
  private Integer type;
  private Vehicle vehicle;
  private Long vehicleId;
  private List<Waypoint> waypoints = new ArrayList<>();
  private Long zoneId;
  private Driver driver;
}