package co.nvqa.operator_v2.selenium.page.pickupAppointment.emums;

public enum ItemsDeleteJobModalWindow {
  SHIPPER_NAME("Shipper name:"),
  SHIPPER_ADDRESS("Shipper address:"),
  READY_BY("Ready by:"),
  LATEST_BY("Latest by:"),
  PRIORITY("Priority:");

  private final String name;

  public String getName() {
    return name;
  }

  ItemsDeleteJobModalWindow(String name) {
    this.name = name;
  }
}
