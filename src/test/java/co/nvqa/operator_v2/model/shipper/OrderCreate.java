package co.nvqa.operator_v2.model.shipper;

import co.nvqa.commons.model.shipper.v2.ShipperSettings;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import lombok.Getter;
import lombok.Setter;

/**
 * @author Daniel Joi Partogi Hutapea
 * <p>
 * JSON format: snake case
 */
@Getter
@Setter
public class OrderCreate implements ShipperSettings, Serializable {

  public static final String TRACKING_TYPE_FIXED = "fixed";
  public static final String TRACKING_TYPE_DYNAMIC = "dynamic";
  public static final String TRACKING_TYPE_NINJA_FIXED = "ninjafixed";
  public static final String TRACKING_TYPE_MULTI_FIXED = "multifixed";
  public static final String TRACKING_TYPE_MULTI_DYNAMIC = "multidynamic";

  private String version;
  private List<String> servicesAvailable;
  private List<String> availableServiceTypes;
  private List<String> availableServiceLevels;
  private Boolean isPrePaid;
  private String prefix;
  private String trackingType;
  private Boolean allowCodService;
  private Boolean allowCpService;
  private Boolean allowStagedOrders;
  private Boolean isMultiParcelShipper;
  private Boolean isMarketplace;
  private Boolean isCorporate;
  private Boolean isCorporateReturn;
  private Boolean isCorporateManualAWB;
  private Boolean isCorporateDocument;
  private Boolean isMarketplaceSeller;
  private Boolean isCorporateHq;
  private Boolean isCorporateBranch;
  private String bulkyType;
  private String pickupCutoffTime;
  private String sameDayPickupCutoffTime;
  private String sundayPickupCutoffTime;
  private Boolean allowEnforceDeliveryVerification;
  private Integer deliveryOtpLength;
  private List<String> subshipperPrefixes;
  private Boolean allowTopup;
  private Boolean allowUseAccountBalance;
  private Long minAccountBalance;
  private Long creditTerm;
  private String feePayableBy;

  public OrderCreate() {
  }

  public String getVersion() {
    return version;
  }

  public void setVersion(String version) {
    this.version = version;
  }

  public List<String> getServicesAvailable() {
    return servicesAvailable;
  }

  public void setServicesAvailable(List<String> servicesAvailable) {
    this.servicesAvailable = servicesAvailable;
  }

  public List<String> getAvailableServiceTypes() {
    return availableServiceTypes;
  }

  public void setAvailableServiceTypes(List<String> availableServiceTypes) {
    this.availableServiceTypes = availableServiceTypes;
  }

  public List<String> getAvailableServiceLevels() {
    return availableServiceLevels;
  }

  public void setAvailableServiceLevels(List<String> availableServiceLevels) {
    this.availableServiceLevels = availableServiceLevels;
  }

  public Boolean getIsCorporate() {
    return isCorporate;
  }

  public void setIsCorporate(Boolean isCorporate) {
    this.isCorporate = isCorporate;
  }

  public Boolean getIsCorporateManualAWB() {
    return isCorporateManualAWB;
  }

  public void setIsCorporateManualAWB(Boolean isCorporateManualAWB) {
    this.isCorporateManualAWB = isCorporateManualAWB;
  }

  public Boolean getIsPrePaid() {
    return isPrePaid;
  }

  public void setIsPrePaid(Boolean isPrePaid) {
    this.isPrePaid = isPrePaid;
  }

  public String getPrefix() {
    return prefix;
  }

  public void setPrefix(String prefix) {
    this.prefix = prefix;
  }

  public String getTrackingType() {
    return trackingType;
  }

  public void setTrackingType(String trackingType) {
    this.trackingType = trackingType;
  }

  public Boolean getAllowCodService() {
    return allowCodService;
  }

  public void setAllowCodService(Boolean allowCodService) {
    this.allowCodService = allowCodService;
  }

  public Boolean getAllowCpService() {
    return allowCpService;
  }

  public void setAllowCpService(Boolean allowCpService) {
    this.allowCpService = allowCpService;
  }

  public Boolean getAllowStagedOrders() {
    return allowStagedOrders;
  }

  public void setAllowStagedOrders(Boolean allowStagedOrders) {
    this.allowStagedOrders = allowStagedOrders;
  }

  public Boolean getIsMultiParcelShipper() {
    return isMultiParcelShipper;
  }

  public void setIsMultiParcelShipper(Boolean isMultiParcelShipper) {
    this.isMultiParcelShipper = isMultiParcelShipper;
  }

  public Boolean getIsMarketplace() {
    return isMarketplace;
  }

  public void setIsMarketplace(Boolean isMarketplace) {
    this.isMarketplace = isMarketplace;
  }

  public Boolean getIsMarketplaceSeller() {
    return isMarketplaceSeller;
  }

  public void setIsMarketplaceSeller(Boolean isMarketplaceSeller) {
    this.isMarketplaceSeller = isMarketplaceSeller;
  }

  public String getBulkyType() {
    return bulkyType;
  }

  public void setBulkyType(String bulkyType) {
    this.bulkyType = bulkyType;
  }

  public void addServiceLevel(ServiceLevel serviceLevel) {
    if (this.servicesAvailable == null) {
      this.servicesAvailable = new ArrayList<>();
    }
    if (this.availableServiceLevels == null) {
      this.availableServiceLevels = new ArrayList<>();
    }

    this.servicesAvailable.add(serviceLevel.getCode());
    this.availableServiceLevels.add(serviceLevel.name());
  }

  public void setPickupCutoffTime(String pickupCutoffTime) {
    this.pickupCutoffTime = pickupCutoffTime;
  }

  public String getPickupCutoffTime() {
    return pickupCutoffTime;
  }

  public String getSameDayPickupCutoffTime() {
    return sameDayPickupCutoffTime;
  }

  public void setSameDayPickupCutoffTime(String sameDayPickupCutoffTime) {
    this.sameDayPickupCutoffTime = sameDayPickupCutoffTime;
  }

  public enum ServiceLevel {
    STANDARD("3DAY"),
    EXPRESS("2DAY"),
    NEXTDAY("1DAY"),
    SAMEDAY("SAMEDAY");

    private String code;

    ServiceLevel(String code) {
      this.code = code;
    }

    public String getCode() {
      return code;
    }
  }

}
