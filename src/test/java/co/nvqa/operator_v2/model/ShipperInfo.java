package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class ShipperInfo extends DataEntity<ShipperInfo> {

  private String createdAt;
  private String address;
  private String name;
  private Long legacyId;

  public ShipperInfo() {
  }

  public ShipperInfo(Map<String, ?> dataMap) {
    fromMap(dataMap);
  }

  public String getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(String createdAt) {
    this.createdAt = createdAt;
  }

  public String getAddress() {
    return address;
  }

  public void setAddress(String address) {
    this.address = address;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public Long getLegacyId() {
    return legacyId;
  }

  public void setLegacyId(Long legacyId) {
    this.legacyId = legacyId;
  }

  public void setLegacyId(String legacyId) {
    setLegacyId(Long.parseLong(legacyId));
  }
}
