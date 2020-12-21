package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;

/**
 * @author Tristania Siagian
 */
public class RoleManagement extends DataEntity<RoleManagement> {

  private String roleName;
  private String desc;
  private String scope;

  public String getRoleName() {
    return roleName;
  }

  public void setRoleName(String roleName) {
    this.roleName = roleName;
  }

  public String getDesc() {
    return desc;
  }

  public void setDesc(String desc) {
    this.desc = desc;
  }

  public String getScope() {
    return scope;
  }

  public void setScope(String scope) {
    this.scope = scope;
  }
}
