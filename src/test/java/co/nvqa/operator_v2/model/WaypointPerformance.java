package co.nvqa.operator_v2.model;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class WaypointPerformance {

  private int pending;
  private int partial;
  private int failed;
  private int completed;
  private int total;
  private int c2cReturn;

  public WaypointPerformance() {
  }

  public int getPending() {
    return pending;
  }

  public void setPending(int pending) {
    this.pending = pending;
  }

  public int getPartial() {
    return partial;
  }

  public void setPartial(int partial) {
    this.partial = partial;
  }

  public int getFailed() {
    return failed;
  }

  public void setFailed(int failed) {
    this.failed = failed;
  }

  public int getCompleted() {
    return completed;
  }

  public void setCompleted(int completed) {
    this.completed = completed;
  }

  public int getTotal() {
    return total;
  }

  public void setTotal(int total) {
    this.total = total;
  }

  public int getC2cReturn() {
    return c2cReturn;
  }

  public void setC2cReturn(int c2cReturn) {
    this.c2cReturn = c2cReturn;
  }
}
