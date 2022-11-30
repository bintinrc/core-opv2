package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import co.nvqa.operator_v2.util.TestUtils;

/**
 * @author Sergey Mishanin
 */
public class ReservationGroup extends DataEntity<ReservationGroup> {

  private Long id;
  private String name;
  private String driver;
  private String hub;
  private Long numberOfPickupLocations;

  public Long getId() {
    return id;
  }

  public ReservationGroup setId(Long id) {
    this.id = id;
    return this;
  }

  public ReservationGroup setId(String id) {
    return setId(Long.valueOf(id));
  }

  public String getName() {
    return name;
  }

  public ReservationGroup setName(String name) {
    if ("GENERATED".equalsIgnoreCase(name)) {
      name = "TA-" + TestUtils.generateDateUniqueString();
    }
    this.name = name;
    return this;
  }

  public String getDriver() {
    return driver;
  }

  public ReservationGroup setDriver(String driver) {
    this.driver = driver;
    return this;
  }

  public String getHub() {
    return hub;
  }

  public ReservationGroup setHub(String hub) {
    this.hub = hub;
    return this;
  }

  public Long getNumberOfPickupLocations() {
    return numberOfPickupLocations;
  }

  public ReservationGroup setNumberOfPickupLocations(Long numberOfPickupLocations) {
    this.numberOfPickupLocations = numberOfPickupLocations;
    return this;
  }

  public ReservationGroup setNumberOfPickupLocations(String numberOfPickupLocations) {
    return setNumberOfPickupLocations(Long.valueOf(numberOfPickupLocations));
  }
}
