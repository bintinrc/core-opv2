package co.nvqa.operator_v2.selenium.page;


import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect2;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class StationRouteMonitoringPage extends OperatorV2SimplePage {


  private static final Logger LOGGER = LoggerFactory.getLogger(StationManagementHomePage.class);

  public StationRouteMonitoringPage(WebDriver webDriver) {
    super(webDriver);
  }

  public enum StationRouteMonitoring {
    DRIVER_NAME("driver_name"),
    ROUTE("route_id"),
    INBOUND_HUB("hub_name"),
    ZONE("zone_name"),
    TOTAL_PARCEL_COUNT("total_parcels"),
    COMPLETION_RATE("completion_percentage"),
    TOTAL_WAYPOINTS("total_waypoints"),
    PENDING_PRIORITY_PARCELS("pending_priority_parcels"),
    PENDING_WAYPOINTS("num_pending"),
    PENDING_AND_LATE_WAYPOINTS("num_late_and_pending"),
    SUCCESSFUL_WAYPOINTS("num_success"),
    INVALID_FAILED_WAYPOINTS("num_invalid_failed"),
    VALID_FAILED_WAYPOINTS("num_valid_failed"),
    EARLY_WAYPOINTS("num_early_wp"),
    LATE_WAYPOINTS("num_late_wp"),
    LASTSEEN("last_seen");

    private String optionValue;

    StationRouteMonitoring(String optionValue) {
      this.optionValue = optionValue;
    }

    public String getOptionValue() {
      return optionValue;
    }

    public String getXpath() {
      return String.format(
          "(//div[@role='row' and @class='BaseTable__row base-row']//div[@data-datakey='%s']"
              + "/child::*//*[name()='a' or (name()='span')])[last()]", this.optionValue);
    }
  }

  public enum InvalidFailedWP {
    TRACKING_ID("tracking_id"),
    CUSTOMER_NAME("name"),
    ORDER_TAGS("tags"),
    ADDRESS("address"),
    RESERVATION_ID("id"),
    PICKUP_NAME("name"),
    TIME_SLOT("time_window"),
    CONTACT("contact");

    private String optionValue;

    InvalidFailedWP(String optionValue) {
      this.optionValue = optionValue;
    }

    public String getOptionValue() {
      return optionValue;
    }

    public String getXpath(String tableName) {
      return String.format(
          "(//div[contains(text(),'%s')]/ancestor::div[contains(@class,'ant-card-bordered')]"
              + "//div[@class='BaseTable__row-cell' and @data-datakey='%s']//div[@class='cell-wrapper']"
              + "//*[name()='a' or (name()='span')])[last()]", tableName, this.optionValue);
    }
  }

  private static final String MODAL_TABLE_FILTER_XPATH = "//div[contains(text(),'%s')]/ancestor::div[contains(@class,'ant-card')]//div[text()='%s']/parent::div//input";
  private static final String PARCELS_COUNT_XPATH = ".//div[@class='ant-card-head-title']//div[text()='%s (%s)']";
  private static final String TABLE_COLUMN_NAME_XPATH = "//div[contains(text(),'%s')]/ancestor::div[contains(@class,'ant-card-bordered')]//div[starts-with(@class,'th')]/*[1]";
  private static final String TABLE_COLUMN_VALUE_XPATH = "//div[contains(text(),'%s')]/ancestor::div[contains(@class,' ant-card-bordered')]//div[@class='cell-wrapper']//span/span";
  private static final String NO_RESULTS_FOUND_XPATH = "//div[contains(text(),'')]/ancestor::div[contains(@class,'ant-card-bordered')]//div[contains(text(),'No Results Found')]";
  private static final String TRACKINGID_XPATH = "//div[contains(text(),'%s')]/ancestor::div[contains(@class,'ant-card-bordered')]//a[@data-testid='tracking_id-link']";
  private static final String RESERVATIONID_XPATH = "//div[contains(text(),'%s')]/ancestor::div[contains(@class,'ant-card-bordered')]//a[@data-testid='reservation-link' and text()='%s']";
  private static final String TAG_COLUMN_VALUE_XPATH = "//div[contains(text(),'%s')]/ancestor::div[contains(@class,'ant-card-bordered')]//div[@class='BaseTable__row-cell' and @data-datakey='tags']//div[@class='cell-wrapper']//span[1]";

  @FindBy(css = "iframe")
  private List<PageElement> pageFrame;

  @FindBy(xpath = "//div[text()='Hubs']//parent::div/following-sibling::div//ancestor::div[@role='combobox']")
  public AntSelect2 hubs;

  @FindBy(xpath = "//div[text()='Zones']//parent::div/following-sibling::div//ancestor::div[@role='combobox']")
  public AntSelect2 zones;

  @FindBy(xpath = "//div[@class='ant-modal-body']//div[text()='Search or Select']")
  public List<PageElement> modalHubSelection;

  @FindBy(xpath = "//div[contains(@class,'row-cell-text')]")
  public PageElement hubDropdownValues;

  @FindBy(xpath = "//div[@data-headerkey='route_id']//input")
  public PageElement routeFilter;

  @FindBy(xpath = "//span[text()='Load Selection']")
  public PageElement loadSelection;

  @FindBy(xpath = "//div[contains(text(),'Invalid Failed Reservations')]/ancestor::div[contains(@class,'ant-card-bordered')]//div[@role='combobox']")
  public AntSelect2 timeslot;

  @FindBy(xpath = "//a[@data-testid='reservation-link']")
  public PageElement ReservationIDLink;

  @FindBy(xpath = "//a[@data-testid='reservation-link']")
  public PageElement trackingIDLink;

  @FindBy(xpath = "//div[text()='Edit Order']")
  public PageElement editOrderText;


  public void switchToStationRouteMonitoringFrame() {
    if (pageFrame.size() > 0) {
      waitUntilVisibilityOfElementLocated(pageFrame.get(0).getWebElement(), 15);
      getWebDriver().switchTo().frame(pageFrame.get(0).getWebElement());
    }
  }

  // This method can be removed once redirection to Route Monitoring is fixed in station Management
  public void loadStationRouteMonitoringPage() {
    getWebDriver().get("https://operatorv2-qa.ninjavan.co/#/sg/station-route-monitoring");
  }

  public void selectHubAndZone(String hubName) {
    if (pageFrame.size() > 0) {
      waitUntilVisibilityOfElementLocated(pageFrame.get(0).getWebElement(), 15);
      switchToStationRouteMonitoringFrame();
    }
    hubs.clearAndSendKeys(hubName);
    pause5s();
    hubDropdownValues.click();
  }

  public void clickLoadSelection() {
    waitUntilVisibilityOfElementLocated(loadSelection.getWebElement());
    loadSelection.click();
  }

  public void selectHub(String hubName) {
    switchToStationRouteMonitoringFrame();
    waitUntilVisibilityOfElementLocated(hubs.getWebElement());
    hubs.enterSearchTerm(hubName);
    pause3s();
    hubDropdownValues.click();
    clickLoadSelection();
  }

  public String getColumnValue(StationRouteMonitoring columnValue) {
    scrollIntoView(columnValue.getXpath());
    return getText(columnValue.getXpath());
  }

  public void filterRoute(String routeID) {
    pause8s();
    waitUntilVisibilityOfElementLocated(routeFilter.getWebElement());
    routeFilter.clearAndSendKeys(routeID);
  }

  public void validateTotalParcelsCounts(Map<String, String> mapOfData) {
    String invalidFailedDeliveriesCount = mapOfData.get("INVALID_FAILED_DELIVERIES");
    String invalidFailedPickupsCount = mapOfData.get("INVALID_FAILED_PICKUPS");
    String invalidFailedReservationCount = mapOfData.get("INVALID_FAILED_RESERVATIONS");
    pause5s();

    if (StringUtils.isNotBlank(invalidFailedDeliveriesCount)) {
      Assertions.assertThat(
              getWebDriver().findElement(By.xpath(f(PARCELS_COUNT_XPATH, "Invalid Failed Deliveries",
                  invalidFailedDeliveriesCount))).isDisplayed())
          .as("Validation of Invalid Failed Deliveries count").isTrue();
    }
    if (StringUtils.isNotBlank(invalidFailedDeliveriesCount)) {
      Assertions.assertThat(
              getWebDriver().findElement(By.xpath(f(PARCELS_COUNT_XPATH, "Invalid Failed Pickups",
                  invalidFailedPickupsCount))).isDisplayed())
          .as("Validation of Invalid Failed Pickups count").isTrue();
    }
    if (StringUtils.isNotBlank(invalidFailedDeliveriesCount)) {
      Assertions.assertThat(getWebDriver().findElement(By.xpath(
              f(PARCELS_COUNT_XPATH, "Invalid Failed Reservations", invalidFailedReservationCount)))
          .isDisplayed()).as("Validation of Invalid Failed Reservations count").isTrue();
    }
  }

  public void validateNoResultsFoundText(Map<String, String> mapOfData) {
    String invalidFailedDeliveriesCount = mapOfData.get("INVALID_FAILED_DELIVERIES");
    String invalidFailedPickupsCount = mapOfData.get("INVALID_FAILED_PICKUPS");
    String invalidFailedReservationCount = mapOfData.get("INVALID_FAILED_RESERVATIONS");
    pause5s();

    if (invalidFailedDeliveriesCount.equalsIgnoreCase("YES")) {
      Assertions.assertThat(getWebDriver().findElement(
                  By.xpath(f(NO_RESULTS_FOUND_XPATH, "Invalid Failed Deliveries")))
              .isDisplayed()).as("Validation of Invalid Failed Deliveries No Results Found text")
          .isTrue();
    }
    if (invalidFailedPickupsCount.equalsIgnoreCase("YES")) {
      Assertions.assertThat(
              getWebDriver().findElement(By.xpath(f(NO_RESULTS_FOUND_XPATH, "Invalid Failed Pickups")))
                  .isDisplayed()).as("Validation of Invalid Failed Pickups No Results Found text")
          .isTrue();
    }
    if (invalidFailedReservationCount.equalsIgnoreCase("YES")) {
      Assertions.assertThat(getWebDriver().findElement(
                  By.xpath(f(NO_RESULTS_FOUND_XPATH, "Invalid Failed Reservations")))
              .isDisplayed()).as("Validation of Invalid Failed Reservations No Results Found text")
          .isTrue();
    }
  }

  public void applyFilters(String table, Map<String, String> filters) {
    waitWhilePageIsLoading();
    for (Map.Entry<String, String> filter : filters.entrySet()) {
      String filterXpath = f(MODAL_TABLE_FILTER_XPATH, table, filter.getKey());
      if (StringUtils.isNotBlank(filterXpath)) {
        List<WebElement> filterFields = getWebDriver().findElements(By.xpath(filterXpath));
        if (filterFields.size() > 0) {
          waitWhilePageIsLoading();
          filterFields.get(0).click();
          filterFields.get(0).sendKeys(filter.getValue());
        }
      }
    }
  }

  public String getColumnValueFromTable(String tableName, InvalidFailedWP columnName) {
    scrollIntoView(columnName.getXpath(tableName));
    return getText(columnName.getXpath(tableName));
  }

  public String getColumnValueFromTagColumn(String tableName) {
    return getText(f(TAG_COLUMN_VALUE_XPATH, tableName));
  }

  public Map<String, String> getResultGridContent(String tableName) {
    Map<String, String> gridContent = new HashMap<String, String>();
    String columnName, columnValue;
    pause3s();

    List<WebElement> columnNames = getWebDriver().findElements(
        By.xpath(f(TABLE_COLUMN_NAME_XPATH, tableName)));
    List<WebElement> columnValues = getWebDriver().findElements(
        By.xpath(f(TABLE_COLUMN_VALUE_XPATH, tableName)));
    for (int row = 0; row < columnNames.size(); row++) {
      scrollIntoView(columnNames.get(row));
      columnName = columnNames.get(row).getText();
      columnValue = columnValues.get(row).getText();
      gridContent.put(columnName, columnValue);
    }
    return gridContent;
  }

  public void validateNavigationOfReservationLink(String tableName, String reservationID) {
    String windowHandle = getWebDriver().getWindowHandle();
    getWebDriver().findElement(By.xpath(f(RESERVATIONID_XPATH, tableName, reservationID)))
        .click();
    switchToNewWindow();
    waitWhilePageIsLoading();
    pause3s();
    Assertions.assertThat(getWebDriver().getCurrentUrl()).endsWith("/shipper-pickups");
    closeAllWindows(windowHandle);
  }

  public void validateNavigationOfTrackingIDLink(String table) {
    String windowHandle = getWebDriver().getWindowHandle();
    getWebDriver().findElement(By.xpath(f(TRACKINGID_XPATH, table))).click();
    switchToNewWindow();
    waitWhilePageIsLoading();
    pause3s();
    Assertions.assertThat(getWebDriver().getCurrentUrl()).endsWith("/trackingID");
    closeAllWindows(windowHandle);
  }


}
