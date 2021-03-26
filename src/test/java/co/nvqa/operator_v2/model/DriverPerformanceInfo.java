package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class DriverPerformanceInfo extends DataEntity<DriverPerformanceInfo> {

  private String driverName;
  private String hub;
  private String routeDate;
  private String driverType;
  private String deliverySuccessRate;
  private String totalNumberOfParcelsDelivered;
  private String numberOfXsParcelsDelivered;
  private String numberOfSParcelsDelivered;
  private String numberOfMParcelsDelivered;
  private String numberOfLParcelsDelivered;
  private String numberOfXLParcelsDelivered;
  private String numberOfXXLParcelsDelivered;
  private String totalNumberOfParcelsFailed;
  private String totalNumberOfReservations;
  private String totalNumberOfSuccessfulPickupScans;

  public DriverPerformanceInfo() {
  }

  public DriverPerformanceInfo(Map<String, ?> data) {
    super(data);
  }

  public String getDriverName() {
    return driverName;
  }

  public void setDriverName(String driverName) {
    this.driverName = driverName;
  }

  public String getHub() {
    return hub;
  }

  public void setHub(String hub) {
    this.hub = hub;
  }

  public String getRouteDate() {
    return routeDate;
  }

  public void setRouteDate(String routeDate) {
    this.routeDate = routeDate;
  }

  public String getDriverType() {
    return driverType;
  }

  public void setDriverType(String driverType) {
    this.driverType = driverType;
  }

  public String getDeliverySuccessRate() {
    return deliverySuccessRate;
  }

  public void setDeliverySuccessRate(String deliverySuccessRate) {
    this.deliverySuccessRate = deliverySuccessRate;
  }

  public String getTotalNumberOfParcelsDelivered() {
    return totalNumberOfParcelsDelivered;
  }

  public void setTotalNumberOfParcelsDelivered(String totalNumberOfParcelsDelivered) {
    this.totalNumberOfParcelsDelivered = totalNumberOfParcelsDelivered;
  }

  public String getNumberOfXsParcelsDelivered() {
    return numberOfXsParcelsDelivered;
  }

  public void setNumberOfXsParcelsDelivered(String numberOfXsParcelsDelivered) {
    this.numberOfXsParcelsDelivered = numberOfXsParcelsDelivered;
  }

  public String getNumberOfSParcelsDelivered() {
    return numberOfSParcelsDelivered;
  }

  public void setNumberOfSParcelsDelivered(String numberOfSParcelsDelivered) {
    this.numberOfSParcelsDelivered = numberOfSParcelsDelivered;
  }

  public String getNumberOfMParcelsDelivered() {
    return numberOfMParcelsDelivered;
  }

  public void setNumberOfMParcelsDelivered(String numberOfMParcelsDelivered) {
    this.numberOfMParcelsDelivered = numberOfMParcelsDelivered;
  }

  public String getNumberOfLParcelsDelivered() {
    return numberOfLParcelsDelivered;
  }

  public void setNumberOfLParcelsDelivered(String numberOfLParcelsDelivered) {
    this.numberOfLParcelsDelivered = numberOfLParcelsDelivered;
  }

  public String getNumberOfXLParcelsDelivered() {
    return numberOfXLParcelsDelivered;
  }

  public void setNumberOfXLParcelsDelivered(String numberOfXLParcelsDelivered) {
    this.numberOfXLParcelsDelivered = numberOfXLParcelsDelivered;
  }

  public String getNumberOfXXLParcelsDelivered() {
    return numberOfXXLParcelsDelivered;
  }

  public void setNumberOfXXLParcelsDelivered(String numberOfXXLParcelsDelivered) {
    this.numberOfXXLParcelsDelivered = numberOfXXLParcelsDelivered;
  }

  public String getTotalNumberOfParcelsFailed() {
    return totalNumberOfParcelsFailed;
  }

  public void setTotalNumberOfParcelsFailed(String totalNumberOfParcelsFailed) {
    this.totalNumberOfParcelsFailed = totalNumberOfParcelsFailed;
  }

  public String getTotalNumberOfReservations() {
    return totalNumberOfReservations;
  }

  public void setTotalNumberOfReservations(String totalNumberOfReservations) {
    this.totalNumberOfReservations = totalNumberOfReservations;
  }

  public String getTotalNumberOfSuccessfulPickupScans() {
    return totalNumberOfSuccessfulPickupScans;
  }

  public void setTotalNumberOfSuccessfulPickupScans(String totalNumberOfSuccessfulPickupScans) {
    this.totalNumberOfSuccessfulPickupScans = totalNumberOfSuccessfulPickupScans;
  }
}
