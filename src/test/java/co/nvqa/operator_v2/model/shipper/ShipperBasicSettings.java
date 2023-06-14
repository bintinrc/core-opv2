package co.nvqa.operator_v2.model.shipper;

import co.nvqa.common.model.DataEntity;
import java.util.List;
import java.util.Map;
import lombok.Getter;
import lombok.Setter;

/**
 * @author Sergey Mishanin
 */
@Getter
@Setter
public class ShipperBasicSettings extends DataEntity<ShipperBasicSettings> {

  private String shipperName;
  private String shortName;
  private String shipperPhoneNumber;
  private String shipperEmail;
  private String dashUsername;
  private String shipperDashboardPassword;
  private String version;
  private List<String> availableServiceLevels;
  private String trackingType;
  private Boolean prePaid;
  private Boolean allowCodService;
  private Boolean allowCpService;
  private Boolean allowStagedOrders;
  private Boolean multiParcelShipper;
  private Boolean marketplace;
  private Boolean bulky;
  private Boolean corporate;
  private Boolean corporateReturn;
  private Boolean corporateManualAWB;
  private Boolean corporateDocument;
  private Boolean marketplaceSeller;
  private Boolean allowEnforceDeliveryVerification;
  private String bulkyType;
  private String pickupCutoffTime;
  private String sameDayPickupCutoffTime;

  public ShipperBasicSettings() {
  }

  public ShipperBasicSettings(Map<String, ?> data) {
    super(data);
  }

  public String getVersion() {
    return version;
  }

  public void setVersion(String version) {
    this.version = version;
  }

  public List<String> getAvailableServiceLevels() {
    return availableServiceLevels;
  }

  public void setAvailableServiceLevels(List<String> availableServiceLevels) {
    this.availableServiceLevels = availableServiceLevels;
  }

  public void setAvailableServiceLevels(String availableServiceLevels) {
    setAvailableServiceLevels(splitAndNormalize(availableServiceLevels));
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

  public String getBulkyType() {
    return bulkyType;
  }

  public void setBulkyType(String bulkyType) {
    this.bulkyType = bulkyType;
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

  public Boolean getPrePaid() {
    return prePaid;
  }

  public void setPrePaid(Boolean prePaid) {
    this.prePaid = prePaid;
  }

  public Boolean getMultiParcelShipper() {
    return multiParcelShipper;
  }

  public void setMultiParcelShipper(Boolean multiParcelShipper) {
    this.multiParcelShipper = multiParcelShipper;
  }

  public Boolean getMarketplace() {
    return marketplace;
  }

  public void setMarketplace(Boolean marketplace) {
    this.marketplace = marketplace;
  }

  public Boolean getBulky() {
    return bulky;
  }

  public void setBulky(Boolean bulky) {
    this.bulky = bulky;
  }

  public void setBulky(String bulky) {
    setBulky(Boolean.parseBoolean(bulky));
  }

  public Boolean getCorporate() {
    return corporate;
  }

  public void setCorporate(Boolean corporate) {
    this.corporate = corporate;
  }

  public void setCorporate(String corporate) {
    setCorporate(Boolean.parseBoolean(corporate));
  }

  public Boolean getCorporateReturn() {
    return corporateReturn;
  }

  public void setCorporateReturn(Boolean corporateReturn) {
    this.corporateReturn = corporateReturn;
  }

  public void setCorporateReturn(String corporateReturn) {
    setCorporateReturn(Boolean.parseBoolean(corporateReturn));
  }

  public Boolean getCorporateManualAWB() {
    return corporateManualAWB;
  }

  public void setCorporateManualAWB(Boolean corporateManualAWB) {
    this.corporateManualAWB = corporateManualAWB;
  }

  public void setCorporateManualAWB(String corporateManualAWB) {
    setCorporateManualAWB(Boolean.parseBoolean(corporateManualAWB));
  }

  public Boolean getMarketplaceSeller() {
    return marketplaceSeller;
  }

  public void setMarketplaceSeller(Boolean marketplaceSeller) {
    this.marketplaceSeller = marketplaceSeller;
  }

  public Boolean getAllowEnforceDeliveryVerification() {
    return allowEnforceDeliveryVerification;
  }

  public void setAllowEnforceDeliveryVerification(Boolean allowEnforceDeliveryVerification) {
    this.allowEnforceDeliveryVerification = allowEnforceDeliveryVerification;
  }

  public String getShipperName() {
    return shipperName;
  }

  public void setShipperName(String shipperName) {
    this.shipperName = shipperName;
  }

  public String getShortName() {
    return shortName;
  }

  public void setShortName(String shortName) {
    this.shortName = shortName;
  }

  public String getShipperPhoneNumber() {
    return shipperPhoneNumber;
  }

  public void setShipperPhoneNumber(String shipperPhoneNumber) {
    this.shipperPhoneNumber = shipperPhoneNumber;
  }

  public String getShipperEmail() {
    return shipperEmail;
  }

  public void setShipperEmail(String shipperEmail) {
    this.shipperEmail = shipperEmail;
  }

  public String getShipperDashboardPassword() {
    return shipperDashboardPassword;
  }

  public void setShipperDashboardPassword(String shipperDashboardPassword) {
    this.shipperDashboardPassword = shipperDashboardPassword;
  }

  public String getDashUsername() {
    return dashUsername;
  }

  public void setDashUsername(String dashUsername) {
    this.dashUsername = dashUsername;
  }
}
