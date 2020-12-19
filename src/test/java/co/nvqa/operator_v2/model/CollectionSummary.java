package co.nvqa.operator_v2.model;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class CollectionSummary {

  private double cash;
  private int failedParcels;
  private int c2cPlusReturn;
  private int reservations;

  public CollectionSummary() {
  }

  public double getCash() {
    return cash;
  }

  public void setCash(double cash) {
    this.cash = cash;
  }

  public int getFailedParcels() {
    return failedParcels;
  }

  public void setFailedParcels(int failedParcels) {
    this.failedParcels = failedParcels;
  }

  public int getC2cPlusReturn() {
    return c2cPlusReturn;
  }

  public void setC2cPlusReturn(int c2cPlusReturn) {
    this.c2cPlusReturn = c2cPlusReturn;
  }

  public int getReservations() {
    return reservations;
  }

  public void setReservations(int reservations) {
    this.reservations = reservations;
  }
}
