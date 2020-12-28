package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import java.io.Serializable;

/**
 * @author Tristania Siagian
 */
public class UserManagement extends DataEntity<UserManagement> implements Serializable {

  private String email;
  private String grantType;
  private String firstName;
  private String lastName;
  private String roles;

  public UserManagement() {

  }

  public String getEmail() {
    return email;
  }

  public void setEmail(String email) {
    this.email = email;
  }

  public String getGrantType() {
    return grantType;
  }

  public void setGrantType(String grantType) {
    this.grantType = grantType;
  }

  public String getFirstName() {
    return firstName;
  }

  public void setFirstName(String firstName) {
    this.firstName = firstName;
  }

  public String getLastName() {
    return lastName;
  }

  public void setLastName(String lastName) {
    this.lastName = lastName;
  }

  public String getRoles() {
    return roles;
  }

  public void setRoles(String roles) {
    this.roles = roles;
  }
}
