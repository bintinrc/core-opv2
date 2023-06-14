package co.nvqa.operator_v2.model.shipper;

import co.nvqa.common.model.address.Address;
import java.io.Serializable;
import java.util.List;
import lombok.Getter;
import lombok.Setter;

/**
 * @author Tristania Siagian
 */
@Getter
@Setter
public class Pickup implements ShipperSettings, Serializable {

  private Integer addressLimit;
  private Boolean allowPremiumPickupOnSunday;
  private Boolean allowStandardPickupOnSunday;
  private Integer premiumPickupDailyLimit;
  private Integer milkRunPickupLimit;

  private String defaultStartTime;
  private String defaultEndTime;

  private List<ServiceTypeLevel> serviceTypeLevel;
  private List<Address> reservationPickupAddresses;

  public Pickup() {
  }

  public Pickup(List<ServiceTypeLevel> serviceTypeLevel) {
    this.serviceTypeLevel = serviceTypeLevel;
  }

  public Integer getAddressLimit() {
    return addressLimit;
  }

  public void setAddressLimit(Integer addressLimit) {
    this.addressLimit = addressLimit;
  }

  public Boolean getAllowPremiumPickupOnSunday() {
    return allowPremiumPickupOnSunday;
  }

  public void setAllowPremiumPickupOnSunday(Boolean allowPremiumPickupOnSunday) {
    this.allowPremiumPickupOnSunday = allowPremiumPickupOnSunday;
  }

  public Integer getPremiumPickupDailyLimit() {
    return premiumPickupDailyLimit;
  }

  public void setPremiumPickupDailyLimit(Integer premiumPickupDailyLimit) {
    this.premiumPickupDailyLimit = premiumPickupDailyLimit;
  }

  public String getDefaultStartTime() {
    return defaultStartTime;
  }

  public void setDefaultStartTime(String defaultStartTime) {
    this.defaultStartTime = defaultStartTime;
  }

  public String getDefaultEndTime() {
    return defaultEndTime;
  }

  public void setDefaultEndTime(String defaultEndTime) {
    this.defaultEndTime = defaultEndTime;
  }

  public List<ServiceTypeLevel> getServiceTypeLevel() {
    return serviceTypeLevel;
  }

  public void setServiceTypeLevel(List<ServiceTypeLevel> serviceTypeLevel) {
    this.serviceTypeLevel = serviceTypeLevel;
  }

  public List<Address> getReservationPickupAddresses() {
    return reservationPickupAddresses;
  }

  public Pickup setReservationPickupAddresses(List<Address> reservationPickupAddresses) {
    this.reservationPickupAddresses = reservationPickupAddresses;
    return this;
  }

  public Boolean getAllowStandardPickupOnSunday() {
    return allowStandardPickupOnSunday;
  }

  public void setAllowStandardPickupOnSunday(Boolean allowStandardPickupOnSunday) {
    this.allowStandardPickupOnSunday = allowStandardPickupOnSunday;
  }
}
