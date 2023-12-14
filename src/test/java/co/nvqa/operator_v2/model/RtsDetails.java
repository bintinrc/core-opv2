package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import co.nvqa.operator_v2.util.CoreDateUtil;
import java.text.ParseException;
import java.util.Date;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("unused")
public class RtsDetails extends DataEntity<RtsDetails> {

  private String reason;
  private String internalNotes;
  private Date deliveryDate;
  private String timeSlot;
  private RtsAddress address;

  public RtsDetails() {
  }

  public RtsDetails(Map<String, ?> data) {
    super(data);
  }

  public String getReason() {
    return reason;
  }

  public void setReason(String reason) {
    this.reason = reason;
  }

  public String getInternalNotes() {
    return internalNotes;
  }

  public void setInternalNotes(String internalNotes) {
    this.internalNotes = internalNotes;
  }

  public Date getDeliveryDate() {
    return deliveryDate;
  }

  public void setDeliveryDate(Date deliveryDate) {
    this.deliveryDate = deliveryDate;
  }

  public void setDeliveryDate(String deliveryDate) throws ParseException {
    setDeliveryDate(CoreDateUtil.SDF_YYYY_MM_DD.parse(deliveryDate));
  }

  public RtsAddress getAddress() {
    return address;
  }

  public void setAddress(RtsAddress address) {
    this.address = address;
  }

  public String getTimeSlot() {
    return timeSlot;
  }

  public void setTimeSlot(String timeSlot) {
    this.timeSlot = timeSlot;
  }

  public static class RtsAddress extends DataEntity<RtsAddress> {

    private String country;
    private String city;
    private String address1;
    private String address2;
    private String postcode;
    private String latitude;
    private String longitude;
    private String name;

    public String getCountry() {
      return country;
    }

    public void setCountry(String country) {
      this.country = country;
    }

    public String getCity() {
      return city;
    }

    public void setCity(String city) {
      this.city = city;
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

    public String getPostcode() {
      return postcode;
    }

    public void setPostcode(String postcode) {
      this.postcode = postcode;
    }

    public String getLatitude() {
      return latitude;
    }

    public void setLatitude(String latitude) {
      this.latitude = latitude;
    }

    public String getLongitude() {
      return longitude;
    }

    public void setLongitude(String longitude) {
      this.longitude = longitude;
    }

    public String getName() {
      return name;
    }

    public void setName(String name) {
      this.name = name;
    }
  }
}
