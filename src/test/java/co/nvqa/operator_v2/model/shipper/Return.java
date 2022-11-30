package co.nvqa.operator_v2.model.shipper;

import co.nvqa.commons.model.shipper.v2.ShipperSettings;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.io.Serializable;

/**
 * @author Daniel Joi Partogi Hutapea
 * <p>
 * JSON format: snake case
 */
public class Return implements ShipperSettings, Serializable {

  @JsonProperty("address_1")
  private String address1;
  @JsonProperty("address_2")
  private String address2;
  private String city;
  private String postcode;
  private String name;
  private String email;
  private String contact;
  private Long lastReturnNumber;
  private Boolean delete;

  public Return() {
  }

  public String getAddress1() {
    return address1;
  }

  public void setAddress1(String address1) {
    this.address1 = address1;
  }

  public String getAddress2() {
    return address2;
  }

  public void setAddress2(String address2) {
    this.address2 = address2;
  }

  public String getCity() {
    return city;
  }

  public void setCity(String city) {
    this.city = city;
  }

  public String getPostcode() {
    return postcode;
  }

  public void setPostcode(String postcode) {
    this.postcode = postcode;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getEmail() {
    return email;
  }

  public void setEmail(String email) {
    this.email = email;
  }

  public String getContact() {
    return contact;
  }

  public void setContact(String contact) {
    this.contact = contact;
  }

  public Long getLastReturnNumber() {
    return lastReturnNumber;
  }

  public void setLastReturnNumber(Long lastReturnNumber) {
    this.lastReturnNumber = lastReturnNumber;
  }

  public Boolean getDelete() {
    return delete;
  }

  public void setDelete(Boolean delete) {
    this.delete = delete;
  }
}
