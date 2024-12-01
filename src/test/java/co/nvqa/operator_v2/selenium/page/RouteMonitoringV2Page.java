package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.PendingPriorityOrder;
import co.nvqa.operator_v2.model.RouteMonitoringParams;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntFilterSelect;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntTableV2;
import com.google.common.collect.ImmutableMap;
import java.util.List;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings({"WeakerAccess", "unused"})
public class RouteMonitoringV2Page extends SimpleReactPage<RouteMonitoringV2Page> {

  @FindBy(css = ".ant-spin-dot")
  public PageElement spinner;

  @FindBy(css = ".ant-collapse-header")
  public PageElement collapseHeader;

  @FindBy(css = "i.ant-collapse-arrow")
  public PageElement collapseArrow;

  @FindBy(css = ".anticon-loading")
  public PageElement smallSpinner;

  @FindBy(tagName = "iframe")
  private PageElement pageFrame;

  @FindBy(xpath = "//div[@class='filter-container'][contains(.,'Hubs')]")
  public AntFilterSelect hubsFilter;

  @FindBy(xpath = "//div[@class='filter-container'][contains(.,'Zones')]")
  public AntFilterSelect zonesFilter;

  @FindBy(xpath = "//button[.='Load Selection']")
  public Button loadSelection;

  @FindBy(className = "ant-modal-wrap")
  public PendingPriorityModal pendingPriorityModal;

  @FindBy(className = "ant-modal-wrap")
  public InvalidFailedWpModal invalidFailedWpModal;

  public final RouteMonitoringTable routeMonitoringTable;

  public RouteMonitoringV2Page(WebDriver webDriver) {
    super(webDriver);
    routeMonitoringTable = new RouteMonitoringTable(webDriver);
  }

  public void switchTo() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void expandFilters() {
    if (StringUtils.equalsIgnoreCase(collapseHeader.getAttribute("aria-expanded"), "false")) {
      collapseArrow.click();
    }
  }

  public static class RouteMonitoringTable extends AntTableV2<RouteMonitoringParams> {

    public static final String COLUMN_ROUTE_ID = "routeId";
    public static final String COLUMN_PENDING_PRIORITY_PARCELS = "pendingPriorityParcels";
    public static final String COLUMN_INVALID_FAILED_WP = "numInvalidFailed";

    public RouteMonitoringTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("driverName", "driverName")
          .put(COLUMN_ROUTE_ID, "routeId")
          .put("totalParcels", "totalParcels")
          .put("completionPercentage", "completionRate")
          .put("totalWaypoint", "totalWaypoints")
          .put(COLUMN_PENDING_PRIORITY_PARCELS, "pendingPriorityParcels")
          .put("pendingCount", "numPending")
          .put("numLateAndPending", "numLateAndPending")
          .put("successCount", "numSuccess")
          .put(COLUMN_INVALID_FAILED_WP, "numInvalidFailed")
          .put("numValidFailed", "numValidFailed")
          .put("earlyCount", "numEarlyWp")
          .put("lateCount", "numLateWp")
          .build()
      );
      setEntityClass(RouteMonitoringParams.class);
    }
  }

  public static class PendingPriorityModal extends AntModal {

    @FindBy(xpath = ".//div[@class='ant-card-head-title'][contains(.,'Deliveries')]")
    public PageElement pendingPriorityDeliveriesTitle;
    @FindBy(xpath = ".//div[@class='ant-card-head-title'][contains(.,'Pickups')]")
    public PageElement pendingPriorityPickupsTitle;

    public PendingPriorityTable pendingPriorityPickupsTable;
    public PendingPriorityTable pendingPriorityDeliveriesTable;

    public PendingPriorityModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
      pendingPriorityPickupsTable = new PendingPriorityTable(webDriver);
      pendingPriorityPickupsTable.setTableLocator("(//div[contains(@class,'ant-card-body')])[2]");
      pendingPriorityDeliveriesTable = new PendingPriorityTable(webDriver);
      pendingPriorityDeliveriesTable
          .setTableLocator("(//div[contains(@class,'ant-card-body')])[1]");
    }

    public static class PendingPriorityTable extends AntTableV2<PendingPriorityOrder> {

      private static final String TAG_LOCATOR = "//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='tags']//div[contains(@class,'ant-tag')]";
      public static final String COLUMN_TRACKING_ID = "trackingId";
      public static final String COLUMN_TAGS = "tags";

      public PendingPriorityTable(WebDriver webDriver) {
        super(webDriver);
        setColumnLocators(ImmutableMap.<String, String>builder()
            .put(COLUMN_TRACKING_ID, "trackingId")
            .put("customerName", "name")
            .put(COLUMN_TAGS, "tags")
            .put("address", "address")
            .build()
        );
        setColumnReaders(ImmutableMap.of(COLUMN_TAGS, this::getTags));
        setEntityClass(PendingPriorityOrder.class);
      }

      public String getTags(int rowNumber) {
        List<WebElement> elements = findElementsByXpath(tableLocator + f(TAG_LOCATOR, rowNumber));
        return elements.stream().map(WebElement::getText).collect(Collectors.joining(","));
      }
    }
  }

  public static class InvalidFailedWpModal extends AntModal {

    @FindBy(xpath = ".//div[@class='ant-card-head-title'][contains(.,'Deliveries')]")
    public PageElement invalidFailedDeliveriesTitle;
    @FindBy(xpath = ".//div[@class='ant-card-head-title'][contains(.,'Pickups')]")
    public PageElement invalidFailedPickupsTitle;
    @FindBy(xpath = ".//div[@class='ant-card-head-title'][contains(.,'Reservations')]")
    public PageElement invalidFailedReservationsTitle;

    public InvalidFailedOrdersTable invalidFailedPickupsTable;
    public InvalidFailedOrdersTable invalidFailedDeliveriesTable;
    public InvalidFailedOrdersTable invalidFailedReservationsTable;

    public InvalidFailedWpModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
      invalidFailedDeliveriesTable = new InvalidFailedOrdersTable(webDriver);
      invalidFailedDeliveriesTable.setTableLocator("(//div[contains(@class,'ant-card-body')])[1]");
      invalidFailedPickupsTable = new InvalidFailedOrdersTable(webDriver);
      invalidFailedPickupsTable.setTableLocator("(//div[contains(@class,'ant-card-body')])[2]");
      invalidFailedReservationsTable = new InvalidFailedOrdersTable(webDriver);
      invalidFailedReservationsTable
          .setTableLocator("(//div[contains(@class,'ant-card-body')])[3]");
    }

    public static class InvalidFailedOrdersTable extends AntTableV2<PendingPriorityOrder> {

      private static final String TAG_LOCATOR = "//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='tags']//div[contains(@class,'ant-tag')]";
      public static final String COLUMN_TRACKING_ID = "trackingId";
      public static final String COLUMN_TAGS = "tags";

      public InvalidFailedOrdersTable(WebDriver webDriver) {
        super(webDriver);
        setColumnLocators(ImmutableMap.<String, String>builder()
            .put(COLUMN_TRACKING_ID, "trackingId")
            .put("customerName", "name")
            .put(COLUMN_TAGS, "tags")
            .put("address", "address")
            .build()
        );
        setColumnReaders(ImmutableMap.of(COLUMN_TAGS, this::getTags));
        setEntityClass(PendingPriorityOrder.class);
      }

      public String getTags(int rowNumber) {
        List<WebElement> elements = findElementsByXpath(tableLocator + f(TAG_LOCATOR, rowNumber));
        return elements.stream().map(WebElement::getText).collect(Collectors.joining(","));
      }
    }
  }
}
