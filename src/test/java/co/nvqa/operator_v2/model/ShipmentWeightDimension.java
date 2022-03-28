package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import co.nvqa.commons.model.core.hub.Shipments;

public class ShipmentWeightDimension extends DataEntity<ShipmentWeightDimension> {
  private Long id;
  private Long shipmentId;
  private String shipmentStatus;
  private String endHub;
  private String shipmentCreationDateTime;
  private String mawb;
  private String shipmentWeight;
  private String length;
  private String width;
  private String height;
  private String kgv;
  private Integer noParcels;
  private String comments;
  private String startHub;
  private String shipmentType;

  public ShipmentWeightDimension() {
  }

  public ShipmentWeightDimension(Shipments shipments) {

  }


  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public Long getShipmentId() {
    return shipmentId;
  }

  public void setShipmentId(Long shipmentId) {
    this.shipmentId = shipmentId;
  }

  public String getShipmentStatus() {
    return shipmentStatus;
  }

  public void setShipmentStatus(String shipmentStatus) {
    this.shipmentStatus = shipmentStatus;
  }

  public String getEndHub() {
    return endHub;
  }

  public void setEndHub(String endHub) {
    this.endHub = endHub;
  }

  public String getShipmentCreationDateTime() {
    return shipmentCreationDateTime;
  }

  public void setShipmentCreationDateTime(String shipmentCreationDateTime) {
    this.shipmentCreationDateTime = shipmentCreationDateTime;
  }

  public String getMawb() {
    return mawb;
  }

  public void setMawb(String mawb) {
    this.mawb = mawb;
  }

  public String getShipmentWeight() {
    return shipmentWeight;
  }

  public void setShipmentWeight(String shipmentWeight) {
    this.shipmentWeight = shipmentWeight;
  }

  public String getLength() {
    return length;
  }

  public void setLength(String length) {
    this.length = length;
  }

  public String getWidth() {
    return width;
  }

  public void setWidth(String width) {
    this.width = width;
  }

  public String getHeight() {
    return height;
  }

  public void setHeight(String height) {
    this.height = height;
  }

  public String getKgv() {
    return kgv;
  }

  public void setKgv(String kgv) {
    this.kgv = kgv;
  }

  public Integer getNoParcels() {
    return noParcels;
  }

  public void setNoParcels(Integer noParcels) {
    this.noParcels = noParcels;
  }

  public String getComments() {
    return comments;
  }

  public void setComments(String comments) {
    this.comments = comments;
  }

  public String getStartHub() {
    return startHub;
  }

  public void setStartHub(String startHub) {
    this.startHub = startHub;
  }

  public String getShipmentType() {
    return shipmentType;
  }

  public void setShipmentType(String shipmentType) {
    this.shipmentType = shipmentType;
  }
}
