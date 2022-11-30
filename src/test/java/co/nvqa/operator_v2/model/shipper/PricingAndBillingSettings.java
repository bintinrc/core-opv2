package co.nvqa.operator_v2.model.shipper;

import co.nvqa.common.model.DataEntity;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class PricingAndBillingSettings extends DataEntity<PricingAndBillingSettings> {

  private String billingName;
  private String billingContact;
  private String billingAddress;
  private String billingPostcode;

  public PricingAndBillingSettings() {
  }

  public PricingAndBillingSettings(Map<String, ?> data) {
    super(data);
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
