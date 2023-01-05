package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class ShipperInfo extends DataEntity<ShipperInfo> {

  private String createdAt;
  private String address;
  private String name;
  private Long legacyId;
  private String isActive;

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

  public String getIsActive() {
    return isActive;
  }

  public void setIsActive(String isActive) {
    this.isActive = isActive;
  }

  @Override
  public void fromCsvLine(String csvLine) {
    String[] values = splitCsvLine(csvLine);
    setCreatedAt(getValueIfIndexExists(values, 1));
    setAddress(getValueIfIndexExists(values, 2));
    setName(getValueIfIndexExists(values, 3));
    setLegacyId(getValueIfIndexExists(values, 4));
    setIsActive(getValueIfIndexExists(values, 5));
  }
}
