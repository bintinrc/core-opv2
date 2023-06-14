package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import co.nvqa.common.model.address.Address;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;

public class UpdateDeliveryAddressRecord extends DataEntity<UpdateDeliveryAddressRecord> {

  private String trackingId;
  private String toName;
  private String toEmail;
  private String toPhoneNumber;
  private String toAddressAddress1;
  private String toAddressAddress2;
  private String toAddressPostcode;
  private String toAddressCity;
  private String toAddressCountry;
  private String toAddressState;
  private String toAddressDistrict;
  private String toAddressLatitude;
  private String toAddressLongitude;

  public UpdateDeliveryAddressRecord() {
  }

  public UpdateDeliveryAddressRecord(Map<String, ?> data) {
    super(data);
  }

  public UpdateDeliveryAddressRecord(Address toAddress) {
    if (StringUtils.startsWith(toAddress.getContact(), "+")) {
      toAddress.setContact(StringUtils.stripStart(toAddress.getContact(), "+"));
    }
    if (StringUtils.startsWith(toAddress.getPostcode(), "0")) {
      toAddress.setPostcode(StringUtils.stripStart(toAddress.getPostcode(), "0"));
    }
    setToName(getNonOptionalValue(toAddress.getName()));
    setToEmail(getNonOptionalValue(toAddress.getEmail()));
    setToPhoneNumber(getNonOptionalValue(toAddress.getContact()));
    setToAddressAddress1(getNonOptionalValue(toAddress.getAddress1()));
    setToAddressAddress2(getNonOptionalValue(toAddress.getAddress2()));
    setToAddressPostcode(getNonOptionalValue(toAddress.getPostcode()));
    setToAddressCity(getNonOptionalValue(toAddress.getCity()));
    setToAddressCountry(getNonOptionalValue(toAddress.getCountry()));
    setToAddressState(getNonOptionalValue(toAddress.getState()));
    setToAddressDistrict(getNonOptionalValue(toAddress.getDistrict()));
    setToAddressLatitude(getOptionalValue(
        toAddress.getLatitude() != null ? String.valueOf(toAddress.getLatitude()) : null));
    setToAddressLongitude(getOptionalValue(
        toAddress.getLongitude() != null ? String.valueOf(toAddress.getLongitude()) : null));
  }

  public String getTrackingId() {
    return trackingId;
  }

  public void setTrackingId(String trackingId) {
    this.trackingId = trackingId;
  }

  public String getToName() {
    return toName;
  }

  public void setToName(String toName) {
    this.toName = StringUtils.equalsIgnoreCase(toName, "empty") ?
        "" : toName;
  }

  public String getToEmail() {
    return toEmail;
  }

  public void setToEmail(String toEmail) {
    this.toEmail = StringUtils.equalsIgnoreCase(toEmail, "empty") ?
        "" : toEmail;
  }

  public String getToPhoneNumber() {
    return toPhoneNumber;
  }

  public void setToPhoneNumber(String toPhoneNumber) {
    this.toPhoneNumber = StringUtils.equalsIgnoreCase(toPhoneNumber, "empty") ?
        "" : toPhoneNumber;
  }

  public String getToAddressAddress1() {
    return toAddressAddress1;
  }

  public void setToAddressAddress1(String toAddressAddress1) {
    this.toAddressAddress1 = StringUtils.equalsIgnoreCase(toAddressAddress1, "empty") ?
        "" : toAddressAddress1;
  }

  public String getToAddressAddress2() {
    return toAddressAddress2;
  }

  public void setToAddressAddress2(String toAddressAddress2) {
    this.toAddressAddress2 = StringUtils.equalsIgnoreCase(toAddressAddress2, "empty") ?
        "" : toAddressAddress2;
  }

  public String getToAddressPostcode() {
    return toAddressPostcode;
  }

  public void setToAddressPostcode(String toAddressPostcode) {
    this.toAddressPostcode = StringUtils.equalsIgnoreCase(toAddressPostcode, "empty") ?
        "" : toAddressPostcode;
  }

  public String getToAddressCity() {
    return toAddressCity;
  }

  public void setToAddressCity(String toAddressCity) {
    this.toAddressCity = StringUtils.equalsIgnoreCase(toAddressCity, "empty") ?
        "" : toAddressCity;
  }

  public String getToAddressCountry() {
    return toAddressCountry;
  }

  public void setToAddressCountry(String toAddressCountry) {
    this.toAddressCountry = StringUtils.equalsIgnoreCase(toAddressCountry, "empty") ?
        "" : toAddressCountry;
  }

  public String getToAddressState() {
    return toAddressState;
  }

  public void setToAddressState(String toAddressState) {
    this.toAddressState = StringUtils.equalsIgnoreCase(toAddressState, "empty") ?
        "" : toAddressState;
  }

  public String getToAddressDistrict() {
    return toAddressDistrict;
  }

  public void setToAddressDistrict(String toAddressDistrict) {
    this.toAddressDistrict = StringUtils.equalsIgnoreCase(toAddressDistrict, "empty") ?
        "" : toAddressDistrict;
  }

  public String getToAddressLatitude() {
    return toAddressLatitude;
  }

  public void setToAddressLatitude(String toAddressLatitude) {
    this.toAddressLatitude = StringUtils.equalsIgnoreCase(toAddressLatitude, "empty") ?
        "" : toAddressLatitude;
  }

  public String getToAddressLongitude() {
    return toAddressLongitude;
  }

  public void setToAddressLongitude(String toAddressLongitude) {
    this.toAddressLongitude = StringUtils.equalsIgnoreCase(toAddressLongitude, "empty") ?
        "" : toAddressLongitude;
  }

  private static String getNonOptionalValue(Object value) {
    if (value == null) {
      return "-";
    } else {
      return StringUtils.isBlank(String.valueOf(value)) ?
          "-" :
          StringUtils.normalizeSpace(String.valueOf(value));
    }
  }

  private static String getOptionalValue(Object value) {
    return value == null ? "" : StringUtils.normalizeSpace(String.valueOf(value));
  }

  public String toCsvLine() {
    return "\"" + getTrackingId() + "\","
        + "\"" + getToName() + "\","
        + "\"" + getToEmail() + "\","
        + "\"" + getToPhoneNumber() + "\","
        + "\"" + getToAddressAddress1() + "\","
        + "\"" + getToAddressAddress2() + "\","
        + "\"" + getToAddressPostcode() + "\","
        + "\"" + getToAddressCity() + "\","
        + "\"" + getToAddressCountry() + "\","
        + "\"" + getToAddressState() + "\","
        + "\"" + getToAddressDistrict() + "\","
        + "\"" + getToAddressLatitude() + "\","
        + "\"" + getToAddressLongitude() + "\"";
  }

  public String buildString() {
    String address = toAddressAddress1;
    if (StringUtils.isNotBlank(toAddressAddress2) && !"-".equals(toAddressAddress2.trim())) {
      address += " " + toAddressAddress2;
    }
    address += " " + toAddressPostcode;
    if (StringUtils.isNotBlank(toAddressCity)) {
      address += " " + toAddressCity;
    }
    if (StringUtils.isNotBlank(toAddressDistrict)) {
      address += " " + toAddressDistrict;
    }
    if (StringUtils.isNotBlank(toAddressState)) {
      address += " " + toAddressState;
    }
    if (StringUtils.isNotBlank(toAddressCountry)) {
      address += " " + toAddressCountry;
    }
    return address;
  }
}
