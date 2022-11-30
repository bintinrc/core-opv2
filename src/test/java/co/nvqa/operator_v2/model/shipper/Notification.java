package co.nvqa.operator_v2.model.shipper;

import co.nvqa.commons.model.shipper.v2.ShipperSettings;
import java.io.Serializable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;

/**
 * @author Daniel Joi Partogi Hutapea
 * <p>
 * JSON format: snake case
 */
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Notification implements ShipperSettings, Serializable {

  private Boolean transitShipper;
  private Boolean transitCustomer;
  private Boolean completedShipper;
  private Boolean completedCustomer;
  private Boolean pickupFailShipper;
  private Boolean pickupFailCustomer;
  private Boolean deliveryFailCustomer;
  private Boolean deliveryFailShipper;

  public Boolean getTransitShipper() {
    return transitShipper;
  }

  public void setTransitShipper(Boolean transitShipper) {
    this.transitShipper = transitShipper;
  }

  public Boolean getTransitCustomer() {
    return transitCustomer;
  }

  public void setTransitCustomer(Boolean transitCustomer) {
    this.transitCustomer = transitCustomer;
  }

  public Boolean getCompletedShipper() {
    return completedShipper;
  }

  public void setCompletedShipper(Boolean completedShipper) {
    this.completedShipper = completedShipper;
  }

  public Boolean getCompletedCustomer() {
    return completedCustomer;
  }

  public void setCompletedCustomer(Boolean completedCustomer) {
    this.completedCustomer = completedCustomer;
  }

  public Boolean getPickupFailShipper() {
    return pickupFailShipper;
  }

  public void setPickupFailShipper(Boolean pickupFailShipper) {
    this.pickupFailShipper = pickupFailShipper;
  }

  public Boolean getPickupFailCustomer() {
    return pickupFailCustomer;
  }

  public void setPickupFailCustomer(Boolean pickupFailCustomer) {
    this.pickupFailCustomer = pickupFailCustomer;
  }

  public Boolean getDeliveryFailCustomer() {
    return deliveryFailCustomer;
  }

  public void setDeliveryFailCustomer(Boolean deliveryFailCustomer) {
    this.deliveryFailCustomer = deliveryFailCustomer;
  }

  public Boolean getDeliveryFailShipper() {
    return deliveryFailShipper;
  }

  public void setDeliveryFailShipper(Boolean deliveryFailShipper) {
    this.deliveryFailShipper = deliveryFailShipper;
  }
}
