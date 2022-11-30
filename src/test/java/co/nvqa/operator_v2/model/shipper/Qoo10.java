package co.nvqa.operator_v2.model.shipper;

import co.nvqa.commons.model.shipper.v2.ShipperSettings;
import java.io.Serializable;

/**
 * @author Daniel Joi Partogi Hutapea
 * <p>
 * JSON format: snake case
 */
public class Qoo10 implements ShipperSettings, Serializable {

  private String username;
  private String password;
  private Boolean delete;

  public Qoo10() {
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

  public Boolean getDelete() {
    return delete;
  }

  public void setDelete(Boolean delete) {
    this.delete = delete;
  }
}
