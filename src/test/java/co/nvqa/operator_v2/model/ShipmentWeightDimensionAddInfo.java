package co.nvqa.operator_v2.model;

import java.util.Map;
import java.util.Optional;

public class ShipmentWeightDimensionAddInfo {
  private String startHub;
  private String endHub;
  private String noOfParcels;
  private String status;
  private String comment;
  private Double weight;
  private Double width;
  private Double length;
  private Double height;

  public ShipmentWeightDimensionAddInfo() {
  }

  public String getStartHub() {
    return startHub;
  }

  public void setStartHub(String startHub) {
    this.startHub = startHub;
  }

  public String getEndHub() {
    return endHub;
  }

  public void setEndHub(String endHub) {
    this.endHub = endHub;
  }

  public String getNoOfParcels() {
    return noOfParcels;
  }

  public void setNoOfParcels(String noOfParcels) {
    this.noOfParcels = noOfParcels;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public String getComment() {
    return comment;
  }

  public void setComment(String comment) {
    this.comment = comment;
  }

  public Double getWeight() {
    return weight;
  }

  public void setWeight(Double weight) {
    this.weight = weight;
  }

  public Double getWidth() {
    return width;
  }

  public void setWidth(Double width) {
    this.width = width;
  }

  public Double getLength() {
    return length;
  }

  public void setLength(Double length) {
    this.length = length;
  }

  public Double getHeight() {
    return height;
  }

  public void setHeight(Double height) {
    this.height = height;
  }

  public void setValueFromMap(Map<String,Object> mapSource) {
    this.startHub = Optional.ofNullable((String)mapSource.get("startHub")).orElse(this.startHub);
    this.endHub = Optional.ofNullable((String)mapSource.get("endHub")).orElse(this.endHub);
    this.noOfParcels = Optional.ofNullable((String)mapSource.get("noOfParcels")).orElse(this.noOfParcels);
    this.status = Optional.ofNullable((String)mapSource.get("status")).orElse(this.status);
    this.comment = Optional.ofNullable((String)mapSource.get("comment")).orElse(this.comment);
    if (mapSource.containsKey("weight")) {
      this.weight = Double.parseDouble((String) mapSource.get("weight"));
    }
    if (mapSource.containsKey("width")) {
      this.width = Double.parseDouble((String) mapSource.get("width"));
    }
    if (mapSource.containsKey("length")) {
      this.length = Double.parseDouble((String) mapSource.get("length"));
    }
    if (mapSource.containsKey("height")) {
      this.height = Double.parseDouble((String) mapSource.get("height"));
    }
  }
}
