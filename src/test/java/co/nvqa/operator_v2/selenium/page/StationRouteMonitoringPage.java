package co.nvqa.operator_v2.selenium.page;


import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect2;
import java.util.List;
import org.openqa.selenium.WebDriver;
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
      return String.format("//div[@role='row' and @class='BaseTable__row base-row']"
          + "//div[@data-datakey='%s']//span/span", this.optionValue);
    }
  }

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
    hubs.enterSearchTerm(hubName);
    pause3s();
    hubDropdownValues.click();
    clickLoadSelection();
  }

  public String getColumnValue(StationRouteMonitoring columnValue) {
    String actualColumnValue = getText(columnValue.getXpath());
    return actualColumnValue;
  }

  public void filterRoute(String routeID) {
    pause8s();
    waitUntilVisibilityOfElementLocated(routeFilter.getWebElement());
    routeFilter.clearAndSendKeys(routeID);
  }

}
