package co.nvqa.operator_v2.model;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class RunCheckParams {

  private String deliveryType;
  private String orderType;
  private String timeslotType;
  private String size;
  private Double weight;
  private Double insuredValue;
  private Double codValue;
  private String fromZone;
  private String toZone;

  public RunCheckParams() {
  }

  public String getDeliveryType() {
    return deliveryType;
  }

  public void setDeliveryType(String deliveryType) {
    this.deliveryType = deliveryType;
  }

  public String getOrderType() {
    return orderType;
  }

  public void setOrderType(String orderType) {
    this.orderType = orderType;
  }

  public String getTimeslotType() {
    return timeslotType;
  }

  public void setTimeslotType(String timeslotType) {
    this.timeslotType = timeslotType;
  }

  public String getSize() {
    return size;
  }

  public void setSize(String size) {
    this.size = size;
  }

  public Double getWeight() {
    return weight;
  }

  public void setWeight(Double weight) {
    this.weight = weight;
  }

  public Double getInsuredValue() {
    return insuredValue;
  }

  public void setInsuredValue(Double insuredValue) {
    this.insuredValue = insuredValue;
  }

  public Double getCodValue() {
    return codValue;
  }

  public void setCodValue(Double codValue) {
    this.codValue = codValue;
  }

  public String getFromZone() {
    return fromZone;
  }

  public void setFromZone(String fromZone) {
    this.fromZone = fromZone;
  }

  public String getToZone() {
    return toZone;
  }

  public void setToZone(String toZone) {
    this.toZone = toZone;
  }
}
