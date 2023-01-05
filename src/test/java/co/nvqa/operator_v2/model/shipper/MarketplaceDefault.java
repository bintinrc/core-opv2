package co.nvqa.operator_v2.model.shipper;

import co.nvqa.commons.model.shipper.v2.ServiceTypeLevel;
import co.nvqa.commons.model.shipper.v2.ShipperSettings;
import java.io.Serializable;
import java.util.List;

/**
 * @author Daniel Joi Partogi Hutapea
 * <p>
 * JSON format: snake case
 */
public class MarketplaceDefault implements ShipperSettings, Serializable {

  private List<Long> reservationDays;
  private Boolean autoReservationEnabled;
  private String autoReservationReadyTime;
  private String autoReservationLatestTime;
  private String autoReservationCutoffTime;
  private Long autoReservationAddressId;
  private String autoReservationApproxVolume;
  private List<String> reservationAllowedTypes;
  private Long pricingScriptId;
  private Long pricingTemplateId;
  private String orderCreateVersion;
  private List<String> orderCreateServicesAvailable;
  private Boolean orderCreateIsPrePaid;
  private String orderCreateTrackingType;
  private String orderCreatePrefix;
  private Boolean orderCreateAllowCodService;
  private Boolean orderCreateAllowCpService;
  private Boolean orderCreateAllowStagedOrders;
  private Boolean orderCreateIsMultiParcelShipper;
  private Boolean pickupAllowPremiumPickupOnSunday;
  private Integer pickupPremiumPickupDailyLimit;
  private List<ServiceTypeLevel> pickupServices;
  private String pickupDefaultStartTime;
  private String pickupDefaultEndTime;
  private Boolean reservationEnforceParcelPickupTracking;
  private List<String> orderCreateAvailableServiceLevels;
  private Boolean orderCreateAllowEnforceDeliveryVerification;

  public MarketplaceDefault() {
  }

  public List<Long> getReservationDays() {
    return reservationDays;
  }

  public void setReservationDays(List<Long> reservationDays) {
    this.reservationDays = reservationDays;
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

  public List<String> getReservationAllowedTypes() {
    return reservationAllowedTypes;
  }

  public void setReservationAllowedTypes(List<String> reservationAllowedTypes) {
    this.reservationAllowedTypes = reservationAllowedTypes;
  }

  public Long getPricingScriptId() {
    return pricingScriptId;
  }

  public void setPricingScriptId(Long pricingScriptId) {
    this.pricingScriptId = pricingScriptId;
  }

  public Long getPricingTemplateId() {
    return pricingTemplateId;
  }

  public void setPricingTemplateId(Long pricingTemplateId) {
    this.pricingTemplateId = pricingTemplateId;
  }

  public String getOrderCreateVersion() {
    return orderCreateVersion;
  }

  public void setOrderCreateVersion(String orderCreateVersion) {
    this.orderCreateVersion = orderCreateVersion;
  }

  public List<String> getOrderCreateServicesAvailable() {
    return orderCreateServicesAvailable;
  }

  public void setOrderCreateServicesAvailable(List<String> orderCreateServicesAvailable) {
    this.orderCreateServicesAvailable = orderCreateServicesAvailable;
  }

  public Boolean getOrderCreateIsPrePaid() {
    return orderCreateIsPrePaid;
  }

  public void setOrderCreateIsPrePaid(Boolean orderCreateIsPrePaid) {
    this.orderCreateIsPrePaid = orderCreateIsPrePaid;
  }

  public String getOrderCreateTrackingType() {
    return orderCreateTrackingType;
  }

  public void setOrderCreateTrackingType(String orderCreateTrackingType) {
    this.orderCreateTrackingType = orderCreateTrackingType;
  }

  public String getOrderCreatePrefix() {
    return orderCreatePrefix;
  }

  public void setOrderCreatePrefix(String orderCreatePrefix) {
    this.orderCreatePrefix = orderCreatePrefix;
  }

  public Boolean getOrderCreateAllowCodService() {
    return orderCreateAllowCodService;
  }

  public void setOrderCreateAllowCodService(Boolean orderCreateAllowCodService) {
    this.orderCreateAllowCodService = orderCreateAllowCodService;
  }

  public Boolean getOrderCreateAllowCpService() {
    return orderCreateAllowCpService;
  }

  public void setOrderCreateAllowCpService(Boolean orderCreateAllowCpService) {
    this.orderCreateAllowCpService = orderCreateAllowCpService;
  }

  public Boolean getOrderCreateAllowStagedOrders() {
    return orderCreateAllowStagedOrders;
  }

  public void setOrderCreateAllowStagedOrders(Boolean orderCreateAllowStagedOrders) {
    this.orderCreateAllowStagedOrders = orderCreateAllowStagedOrders;
  }

  public Boolean getOrderCreateIsMultiParcelShipper() {
    return orderCreateIsMultiParcelShipper;
  }

  public void setOrderCreateIsMultiParcelShipper(Boolean orderCreateIsMultiParcelShipper) {
    this.orderCreateIsMultiParcelShipper = orderCreateIsMultiParcelShipper;
  }

  public Boolean getPickupAllowPremiumPickupOnSunday() {
    return pickupAllowPremiumPickupOnSunday;
  }

  public void setPickupAllowPremiumPickupOnSunday(Boolean pickupAllowPremiumPickupOnSunday) {
    this.pickupAllowPremiumPickupOnSunday = pickupAllowPremiumPickupOnSunday;
  }

  public Integer getPickupPremiumPickupDailyLimit() {
    return pickupPremiumPickupDailyLimit;
  }

  public void setPickupPremiumPickupDailyLimit(Integer pickupPremiumPickupDailyLimit) {
    this.pickupPremiumPickupDailyLimit = pickupPremiumPickupDailyLimit;
  }

  public List<ServiceTypeLevel> getPickupServices() {
    return pickupServices;
  }

  public void setPickupServices(List<ServiceTypeLevel> pickupServices) {
    this.pickupServices = pickupServices;
  }

  public String getPickupDefaultStartTime() {
    return pickupDefaultStartTime;
  }

  public void setPickupDefaultStartTime(String pickupDefaultStartTime) {
    this.pickupDefaultStartTime = pickupDefaultStartTime;
  }

  public String getPickupDefaultEndTime() {
    return pickupDefaultEndTime;
  }

  public void setPickupDefaultEndTime(String pickupDefaultEndTime) {
    this.pickupDefaultEndTime = pickupDefaultEndTime;
  }

  public Boolean getReservationEnforceParcelPickupTracking() {
    return reservationEnforceParcelPickupTracking;
  }

  public void setReservationEnforceParcelPickupTracking(
      Boolean reservationEnforceParcelPickupTracking) {
    this.reservationEnforceParcelPickupTracking = reservationEnforceParcelPickupTracking;
  }

  public List<String> getOrderCreateAvailableServiceLevels() {
    return orderCreateAvailableServiceLevels;
  }

  public void setOrderCreateAvailableServiceLevels(List<String> orderCreateAvailableServiceLevels) {
    this.orderCreateAvailableServiceLevels = orderCreateAvailableServiceLevels;
  }

  public Boolean getOrderCreateAllowEnforceDeliveryVerification() {
    return orderCreateAllowEnforceDeliveryVerification;
  }

  public void setOrderCreateAllowEnforceDeliveryVerification(
      Boolean orderCreateAllowEnforceDeliveryVerification) {
    this.orderCreateAllowEnforceDeliveryVerification = orderCreateAllowEnforceDeliveryVerification;
  }
}
