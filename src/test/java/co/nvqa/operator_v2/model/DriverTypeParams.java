package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import java.util.Arrays;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import org.apache.commons.lang3.StringUtils;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class DriverTypeParams extends DataEntity<DriverTypeParams> {

  private Long driverTypeId;
  private String driverTypeName;

  private String deliveryType;
  private String priorityLevel;
  private String reservationSize;
  private String parcelSize;
  private String timeslot;

  public DriverTypeParams() {
  }

  public DriverTypeParams(Map<String, ?> data) {
    super(data);
  }

  public Long getDriverTypeId() {
    return driverTypeId;
  }

  public void setDriverTypeId(Long driverTypeId) {
    this.driverTypeId = driverTypeId;
  }

  public String getDriverTypeName() {
    return driverTypeName;
  }

  public void setDriverTypeName(String driverTypeName) {
    this.driverTypeName = driverTypeName;
  }

  public String getDeliveryType() {
    return deliveryType;
  }

  public Set<String> getDeliveryTypes() {
    return stringToSet(getDeliveryType());
  }

  public void setDeliveryType(String deliveryType) {
    this.deliveryType = deliveryType;
  }

  public String getPriorityLevel() {
    return priorityLevel;
  }

  public Set<String> getPriorityLevels() {
    return stringToSet(getPriorityLevel());
  }

  public void setPriorityLevel(String priorityLevel) {
    this.priorityLevel = priorityLevel;
  }

  public String getReservationSize() {
    return reservationSize;
  }

  public Set<String> getReservationSizes() {
    return stringToSet(getReservationSize());
  }

  public void setReservationSize(String reservationSize) {
    this.reservationSize = reservationSize;
  }

  public String getParcelSize() {
    return parcelSize;
  }

  public Set<String> getParcelSizes() {
    return stringToSet(getParcelSize());
  }

  public void setParcelSize(String parcelSize) {
    this.parcelSize = parcelSize;
  }

  public String getTimeslot() {
    return timeslot;
  }

  public Set<String> getTimeslots() {
    return stringToSet(getTimeslot());
  }

  public void setTimeslot(String timeslot) {
    this.timeslot = timeslot;
  }

  public void fromCsvLine(String csvLine) {
    String[] values = csvLine.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)");
    setDriverTypeId(Long.parseLong(Objects.requireNonNull(getValueIfIndexExists(values, 0))));
    setDriverTypeName(getValueIfIndexExists(values, 1));
    setDeliveryType(getValueIfIndexExists(values, 2));
    setPriorityLevel(getValueIfIndexExists(values, 3));
    setReservationSize(getValueIfIndexExists(values, 4));
    setParcelSize(getValueIfIndexExists(values, 5));
  }

  private Set<String> stringToSet(String value) {
    return Arrays.stream(StringUtils.defaultIfBlank(value, "").split(","))
        .map(item -> StringUtils.normalizeSpace(item).trim())
        .collect(LinkedHashSet::new, LinkedHashSet<String>::add, (i, j) -> {
        });
  }

  public static List<DriverTypeParams> fromCsvFile(String fileName, boolean ignoreHeader) {
    return fromCsvFile(DriverTypeParams.class, fileName, ignoreHeader);
  }
}
