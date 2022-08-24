package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import java.util.Map;

/**
 * @author Tristania Siagian
 */
public class Addressing extends DataEntity<Addressing> {

  private String postcode;
  private String streetName;
  private String buildingName;
  private String buildingNo;
  private Double latitude;
  private Double longitude;
  private String addressType;
  private String province;
  private String city;
  private String district;
  private String community;
  private String subdistrict;
  private String ward;
  private String state;
  private String area;
  private String subdivision;

  public Addressing() {
  }

  public Addressing(Map<String, ?> data) {
    super(data);
  }

  public String getPostcode() {
    return postcode;
  }

  public void setPostcode(String postcode) {
    this.postcode = postcode;
  }

  public String getStreetName() {
    return streetName;
  }

  public void setStreetName(String streetName) {
    this.streetName = streetName;
  }

  public String getBuildingName() {
    return buildingName;
  }

  public void setBuildingName(String buildingName) {
    this.buildingName = buildingName;
  }

  public String getBuildingNo() {
    return buildingNo;
  }

  public void setBuildingNo(String buildingNo) {
    this.buildingNo = buildingNo;
  }

  public Double getLatitude() {
    return latitude;
  }

  public void setLatitude(Double latitude) {
    this.latitude = latitude;
  }

  public Double getLongitude() {
    return longitude;
  }

  public void setLongitude(Double longitude) {
    this.longitude = longitude;
  }

  public String getAddressType() {
    return addressType;
  }

  public void setAddressType(String addressType) {
    this.addressType = addressType;
  }

  public String getProvince() {
    return province;
  }

  public void setProvince(String province) {
    this.province = province;
  }

  public String getCity() {
    return city;
  }

  public void setCity(String city) {
    this.city = city;
  }

  public String getDistrict() {
    return district;
  }

  public void setDistrict(String district) {
    this.district = district;
  }

  public String getCommunity() {
    return community;
  }

  public void setCommunity(String community) {
    this.community = community;
  }

  public String getSubdistrict() {
    return subdistrict;
  }

  public void setSubdistrict(String subdistrict) {
    this.subdistrict = subdistrict;
  }

  public String getWard() {
    return ward;
  }

  public void setWard(String ward) {
    this.ward = ward;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public String getArea() {
    return area;
  }

  public void setArea(String area) {
    this.area = area;
  }

  public String getSubdivision() {
    return subdivision;
  }

  public void setSubdivision(String subdivision) {
    this.subdivision = subdivision;
  }
}
