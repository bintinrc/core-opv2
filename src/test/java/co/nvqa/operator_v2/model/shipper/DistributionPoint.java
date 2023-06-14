package co.nvqa.operator_v2.model.shipper;

import co.nvqa.commons.model.shipper.v2.ShipperSettings;
import java.io.Serializable;
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
public class DistributionPoint implements ShipperSettings, Serializable {

  private Boolean vaultIsIntegrated;
  private Boolean allowReturnsOnDpms;
  private Boolean allowReturnsOnShipperLite;
  private Boolean allowDriverReschedule;
  private Boolean allowReturnsOnVault;
  private Boolean shipperLiteAllowRescheduleFirstAttempt;
  private Boolean vaultCollectCustomerNricCode;
  private String dpmsLogoUrl;
  private String vaultLogoUrl;
  private String shipperLiteLogoUrl;
  private Boolean allowFullyIntegratedNinjaCollect;
  private Boolean allowNoCapacityDoorstepDeliveryAlt;
  private String deadlineFallbackAction;
  private List<String> eligibleServiceLevels;

  public DistributionPoint() {
  }

  public Boolean getVaultIsIntegrated() {
    return vaultIsIntegrated;
  }

  public void setVaultIsIntegrated(Boolean vaultIsIntegrated) {
    this.vaultIsIntegrated = vaultIsIntegrated;
  }

  public Boolean getAllowReturnsOnDpms() {
    return allowReturnsOnDpms;
  }

  public void setAllowReturnsOnDpms(Boolean allowReturnsOnDpms) {
    this.allowReturnsOnDpms = allowReturnsOnDpms;
  }

  public Boolean getAllowReturnsOnShipperLite() {
    return allowReturnsOnShipperLite;
  }

  public void setAllowReturnsOnShipperLite(Boolean allowReturnsOnShipperLite) {
    this.allowReturnsOnShipperLite = allowReturnsOnShipperLite;
  }

  public Boolean getAllowReturnsOnVault() {
    return allowReturnsOnVault;
  }

  public void setAllowReturnsOnVault(Boolean allowReturnsOnVault) {
    this.allowReturnsOnVault = allowReturnsOnVault;
  }

  public Boolean getShipperLiteAllowRescheduleFirstAttempt() {
    return shipperLiteAllowRescheduleFirstAttempt;
  }

  public void setShipperLiteAllowRescheduleFirstAttempt(
      Boolean shipperLiteAllowRescheduleFirstAttempt) {
    this.shipperLiteAllowRescheduleFirstAttempt = shipperLiteAllowRescheduleFirstAttempt;
  }

  public Boolean getVaultCollectCustomerNricCode() {
    return vaultCollectCustomerNricCode;
  }

  public void setVaultCollectCustomerNricCode(Boolean vaultCollectCustomerNricCode) {
    this.vaultCollectCustomerNricCode = vaultCollectCustomerNricCode;
  }

  public String getDpmsLogoUrl() {
    return dpmsLogoUrl;
  }

  public void setDpmsLogoUrl(String dpmsLogoUrl) {
    this.dpmsLogoUrl = dpmsLogoUrl;
  }

  public String getVaultLogoUrl() {
    return vaultLogoUrl;
  }

  public void setVaultLogoUrl(String vaultLogoUrl) {
    this.vaultLogoUrl = vaultLogoUrl;
  }

  public String getShipperLiteLogoUrl() {
    return shipperLiteLogoUrl;
  }

  public void setShipperLiteLogoUrl(String shipperLiteLogoUrl) {
    this.shipperLiteLogoUrl = shipperLiteLogoUrl;
  }

  public Boolean getAllowFullyIntegratedNinjaCollect() {
    return allowFullyIntegratedNinjaCollect;
  }

  public void setAllowFullyIntegratedNinjaCollect(Boolean allowFullyIntegratedNinjaCollect) {
    this.allowFullyIntegratedNinjaCollect = allowFullyIntegratedNinjaCollect;
  }

  public Boolean getAllowNoCapacityDoorstepDeliveryAlt() {
    return allowNoCapacityDoorstepDeliveryAlt;
  }

  public void setAllowNoCapacityDoorstepDeliveryAlt(Boolean allowNoCapacityDoorstepDeliveryAlt) {
    this.allowNoCapacityDoorstepDeliveryAlt = allowNoCapacityDoorstepDeliveryAlt;
  }

  public String getDeadlineFallbackAction() {
    return deadlineFallbackAction;
  }

  public void setDeadlineFallbackAction(String deadlineFallbackAction) {
    this.deadlineFallbackAction = deadlineFallbackAction;
  }

  public List<String> getEligibleServiceLevels() {
    return eligibleServiceLevels;
  }

  public void setEligibleServiceLevels(List<String> eligibleServiceLevels) {
    this.eligibleServiceLevels = eligibleServiceLevels;
  }
}
