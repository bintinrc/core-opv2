package co.nvqa.operator_v2.model.shipper;

import co.nvqa.commons.model.shipper.v2.ShipperSettings;
import java.io.Serializable;
import java.util.List;

/**
 * @author Daniel Joi Partogi Hutapea
 * <p>
 * JSON format: snake case
 */
public class Reservation implements ShipperSettings, Serializable {

  private List<Long> days = null;
  private List<String> allowedTypes;
  private Boolean allowShipperCustomerReservation;
  private Boolean autoReservationEnabled; //If auto_reservation_enabled is true, all the settings auto_reservation_* are required.
  private String autoReservationReadyTime;
  private String autoReservationLatestTime;
  private String autoReservationCutoffTime;
  private String autoReservationOrderCreateCutoffTime;
  private Long autoReservationAddressId;
  private String autoReservationApproxVolume;
  private Boolean enforceParcelPickupTracking;

  public Reservation() {
  }

  public List<Long> getDays() {
    return days;
  }

  public void setDays(List<Long> days) {
    this.days = days;
  }

  public List<String> getAllowedTypes() {
    return allowedTypes;
  }

  public void setAllowedTypes(List<String> allowedTypes) {
    this.allowedTypes = allowedTypes;
  }

  public Boolean getAllowShipperCustomerReservation() {
    return allowShipperCustomerReservation;
  }

  public void setAllowShipperCustomerReservation(Boolean allowShipperCustomerReservation) {
    this.allowShipperCustomerReservation = allowShipperCustomerReservation;
  }

  public Boolean getAutoReservationEnabled() {
    return autoReservationEnabled;
  }

  public void setAutoReservationEnabled(Boolean autoReservationEnabled) {
    this.autoReservationEnabled = autoReservationEnabled;
  }

  public String getAutoReservationReadyTime() {
    return autoReservationReadyTime;
  }

  public void setAutoReservationReadyTime(String autoReservationReadyTime) {
    this.autoReservationReadyTime = autoReservationReadyTime;
  }

  public String getAutoReservationLatestTime() {
    return autoReservationLatestTime;
  }

  public void setAutoReservationLatestTime(String autoReservationLatestTime) {
    this.autoReservationLatestTime = autoReservationLatestTime;
  }

  public String getAutoReservationCutoffTime() {
    return autoReservationCutoffTime;
  }

  public void setAutoReservationCutoffTime(String autoReservationCutoffTime) {
    this.autoReservationCutoffTime = autoReservationCutoffTime;
  }

  public String getAutoReservationOrderCreateCutoffTime() {
    return autoReservationOrderCreateCutoffTime;
  }

  public void setAutoReservationOrderCreateCutoffTime(String autoReservationOrderCreateCutoffTime) {
    this.autoReservationOrderCreateCutoffTime = autoReservationOrderCreateCutoffTime;
  }

  public Long getAutoReservationAddressId() {
    return autoReservationAddressId;
  }

  public void setAutoReservationAddressId(Long autoReservationAddressId) {
    this.autoReservationAddressId = autoReservationAddressId;
  }

  public String getAutoReservationApproxVolume() {
    return autoReservationApproxVolume;
  }

  public void setAutoReservationApproxVolume(String autoReservationApproxVolume) {
    this.autoReservationApproxVolume = autoReservationApproxVolume;
  }

  public Boolean getEnforceParcelPickupTracking() {
    return enforceParcelPickupTracking;
  }

  public void setEnforceParcelPickupTracking(Boolean enforcePickupParcelTracking) {
    this.enforceParcelPickupTracking = enforcePickupParcelTracking;
  }
}
