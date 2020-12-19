package co.nvqa.operator_v2.model;

import co.nvqa.commons.util.NvTestRuntimeException;
import java.util.Arrays;

/**
 * @author Tristania Siagian
 */

public enum TripManagementFilteringType {
  DESTINATION_HUB("destination_hub"),
  ORIGIN_HUB("origin_hub"),
  TRIP_ID("trip_id"),
  MOVEMENT_TYPE("movement_type"),
  EXPECTED_DEPARTURE_TIME("expected_departure_time"),
  ACTUAL_DEPARTURE_TIME("actual_departure_time"),
  EXPECTED_ARRIVAL_TIME("expected_arrival_time"),
  ACTUAL_ARRIVAL_TIME("actual_arrival_time"),
  DRIVER("driver"),
  STATUS("status"),
  LAST_STATUS("last_status");

  final String val;

  TripManagementFilteringType(String val) {
    this.val = val;
  }

  public static TripManagementFilteringType fromString(String tripManagementFilterType) {
    return Arrays.stream(values())
        .filter(nvCountry -> tripManagementFilterType.equalsIgnoreCase(nvCountry.toString()))
        .findFirst()
        .orElseThrow(() -> new NvTestRuntimeException("bad input for TripManagementFilterType"));
  }

  public String getVal() {
    return val;
  }
}
