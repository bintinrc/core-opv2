package co.nvqa.operator_v2.model.shipper;

import co.nvqa.commons.model.shipper.v2.ShipperSettings;
import java.io.Serializable;

/**
 * @author Daniel Joi Partogi Hutapea
 * <p>
 * JSON format: snake case
 */
public class Magento implements ShipperSettings, Serializable {

  private Boolean delete;
  private String password;
  private String soapApiUrl;
  private String username;

  public Magento() {
  }

  public String getUsername() {
    return username;
  }

  public void setUsername(String username) {
    this.username = username;
  }

  public String getPassword() {
    return password;
  }

  public void setPassword(String password) {
    this.password = password;
  }

  public String getSoapApiUrl() {
    return soapApiUrl;
  }

  public void setSoapApiUrl(String soapApiUrl) {
    this.soapApiUrl = soapApiUrl;
  }

  public Boolean getDelete() {
    return delete;
  }

  public void setDelete(Boolean delete) {
    this.delete = delete;
  }
}
