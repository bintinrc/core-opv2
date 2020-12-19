package co.nvqa.operator_v2.model;

/**
 * @author Sergey Mishanin
 */
public class ExpectedScans {

  private Integer parcelProcessedTotal;
  private Integer parcelProcessedScans;
  private Integer pendingDeliveriesTotal;
  private Integer pendingDeliveriesScans;
  private Integer failedDeliveriesValidTotal;
  private Integer failedDeliveriesValidScans;
  private Integer failedDeliveriesInvalidTotal;
  private Integer failedDeliveriesInvalidScans;
  private Integer c2cReturnPickupsTotal;
  private Integer c2cReturnPickupsScans;
  private Integer reservationPickupsTotal;
  private Integer reservationPickupsScans;
  private Integer reservationPickupsExtraOrders;

  public ExpectedScans() {
  }

  public Integer getPendingDeliveriesTotal() {
    return pendingDeliveriesTotal;
  }

  public void setPendingDeliveriesTotal(Integer pendingDeliveriesTotal) {
    this.pendingDeliveriesTotal = pendingDeliveriesTotal;
  }

  public Integer getParcelProcessedTotal() {
    return parcelProcessedTotal;
  }

  public void setParcelProcessedTotal(Integer parcelProcessedTotal) {
    this.parcelProcessedTotal = parcelProcessedTotal;
  }

  public Integer getParcelProcessedScans() {
    return parcelProcessedScans;
  }

  public void setParcelProcessedScans(Integer parcelProcessedScans) {
    this.parcelProcessedScans = parcelProcessedScans;
  }

  public Integer getPendingDeliveriesScans() {
    return pendingDeliveriesScans;
  }

  public void setPendingDeliveriesScans(Integer pendingDeliveriesScans) {
    this.pendingDeliveriesScans = pendingDeliveriesScans;
  }

  public Integer getFailedDeliveriesValidTotal() {
    return failedDeliveriesValidTotal;
  }

  public void setFailedDeliveriesValidTotal(Integer failedDeliveriesValidTotal) {
    this.failedDeliveriesValidTotal = failedDeliveriesValidTotal;
  }

  public Integer getFailedDeliveriesValidScans() {
    return failedDeliveriesValidScans;
  }

  public void setFailedDeliveriesValidScans(Integer failedDeliveriesValidScans) {
    this.failedDeliveriesValidScans = failedDeliveriesValidScans;
  }

  public Integer getFailedDeliveriesInvalidTotal() {
    return failedDeliveriesInvalidTotal;
  }

  public void setFailedDeliveriesInvalidTotal(Integer failedDeliveriesInvalidTotal) {
    this.failedDeliveriesInvalidTotal = failedDeliveriesInvalidTotal;
  }

  public Integer getFailedDeliveriesInvalidScans() {
    return failedDeliveriesInvalidScans;
  }

  public void setFailedDeliveriesInvalidScans(Integer failedDeliveriesInvalidScans) {
    this.failedDeliveriesInvalidScans = failedDeliveriesInvalidScans;
  }

  public Integer getC2cReturnPickupsTotal() {
    return c2cReturnPickupsTotal;
  }

  public void setC2cReturnPickupsTotal(Integer c2cReturnPickupsTotal) {
    this.c2cReturnPickupsTotal = c2cReturnPickupsTotal;
  }

  public Integer getC2cReturnPickupsScans() {
    return c2cReturnPickupsScans;
  }

  public void setC2cReturnPickupsScans(Integer c2cReturnPickupsScans) {
    this.c2cReturnPickupsScans = c2cReturnPickupsScans;
  }

  public Integer getReservationPickupsTotal() {
    return reservationPickupsTotal;
  }

  public void setReservationPickupsTotal(Integer reservationPickupsTotal) {
    this.reservationPickupsTotal = reservationPickupsTotal;
  }

  public Integer getReservationPickupsScans() {
    return reservationPickupsScans;
  }

  public void setReservationPickupsScans(Integer reservationPickupsScans) {
    this.reservationPickupsScans = reservationPickupsScans;
  }

  public Integer getReservationPickupsExtraOrders() {
    return reservationPickupsExtraOrders;
  }

  public void setReservationPickupsExtraOrders(Integer reservationPickupsExtraOrders) {
    this.reservationPickupsExtraOrders = reservationPickupsExtraOrders;
  }
}
