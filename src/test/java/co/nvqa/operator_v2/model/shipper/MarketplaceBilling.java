package co.nvqa.operator_v2.model.shipper;

import co.nvqa.commons.model.shipper.v2.ShipperSettings;
import java.io.Serializable;

/**
 * @author Daniel Joi Partogi Hutapea
 * <p>
 * JSON format: snake case
 */
public class MarketplaceBilling implements ShipperSettings, Serializable {

  private String billingAddress;
  private String billingContact;
  private String billingName;
  private String billingPostcode;

  public MarketplaceBilling() {
  }

  public String getBillingName() {
    return billingName;
  }

  public void setBillingName(String billingName) {
    this.billingName = billingName;
  }

  public String getBillingContact() {
    return billingContact;
  }

  public void setBillingContact(String billingContact) {
    this.billingContact = billingContact;
  }

  public String getBillingAddress() {
    return billingAddress;
  }

  public void setBillingAddress(String billingAddress) {
    this.billingAddress = billingAddress;
  }

  public String getBillingPostcode() {
    return billingPostcode;
  }

  public void setBillingPostcode(String billingPostcode) {
    this.billingPostcode = billingPostcode;
  }
}
