package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.PendingPriorityOrder;
import co.nvqa.operator_v2.model.RouteMonitoringParams;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntFilterSelect;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import java.util.List;
import java.util.stream.Collectors;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings({"WeakerAccess", "unused"})
public class RouteMonitoringV2Page extends OperatorV2SimplePage
{
    @FindBy(css = ".ant-spin")
    public PageElement spinner;

    @FindBy(css = ".anticon-loading")
    public PageElement smallSpinner;

    @FindBy(css = "div.ant-collapse-header i.ant-collapse-arrow")
    public Button openFilters;

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

    public final RouteMonitoringTable routeMonitoringTable;

    public RouteMonitoringV2Page(WebDriver webDriver)
    {
        super(webDriver);
        routeMonitoringTable = new RouteMonitoringTable(webDriver);
    }

    public void switchTo()
    {
        getWebDriver().switchTo().frame(pageFrame.getWebElement());
    }

    public static class RouteMonitoringTable extends AntTable<RouteMonitoringParams>
    {
        public static final String COLUMN_ROUTE_ID = "routeId";
        public static final String COLUMN_PENDING_PRIORITY_PARCELS = "pendingPriorityParcels";

        public RouteMonitoringTable(WebDriver webDriver)
        {
            super(webDriver);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put(COLUMN_ROUTE_ID, "routeId")
                    .put("totalParcels", "totalParcels")
                    .put("completionPercentage", "completionRate")
                    .put("totalWaypoint", "totalWaypoints")
                    .put(COLUMN_PENDING_PRIORITY_PARCELS, "pendingPriorityParcels")
                    .put("pendingCount", "numPending")
                    .put("numLateAndPending", "numLateAndPending")
                    .put("successCount", "numSuccess")
                    .put("numInvalidFailed", "numInvalidFailed")
                    .put("numValidFailed", "numValidFailed")
                    .put("earlyCount", "numEarlyWp")
                    .put("lateCount", "numLateWp")
                    .build()
            );
            setEntityClass(RouteMonitoringParams.class);
        }
    }

    public static class PendingPriorityModal extends AntModal
    {
        @FindBy(xpath = ".//div[@class='ant-card-head-title'][contains(.,'Deliveries')]")
        public PageElement pendingPriorityDeliveriesTitle;
        @FindBy(xpath = ".//div[@class='ant-card-head-title'][contains(.,'Pickups')]")
        public PageElement pendingPriorityPickupsTitle;

        public PendingPriorityTable pendingPriorityPickupsTable;
        public PendingPriorityTable pendingPriorityDeliveriesTable;

        public PendingPriorityModal(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
            pendingPriorityPickupsTable = new PendingPriorityTable(webDriver);
            pendingPriorityPickupsTable.setTableLocator("(//div[contains(@class,'ant-card-body')])[3]");
            pendingPriorityDeliveriesTable = new PendingPriorityTable(webDriver);
            pendingPriorityDeliveriesTable.setTableLocator("(//div[contains(@class,'ant-card-body')])[2]");
        }

        public static class PendingPriorityTable extends AntTable<PendingPriorityOrder>
        {
            private static final String DAY_OF_WEEK_LOCATOR = "//tbody/tr[%d]/td[contains(@class,'tags')]//div[contains(@class,'ant-tag')]";
            public static final String COLUMN_TRACKING_ID = "trackingId";
            public static final String COLUMN_TAGS = "tags";

            public PendingPriorityTable(WebDriver webDriver)
            {
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

            public String getTags(int rowNumber)
            {
                List<WebElement> elements = findElementsByXpath(tableLocator + f(DAY_OF_WEEK_LOCATOR, rowNumber));
                return elements.stream().map(WebElement::getText).collect(Collectors.joining(","));
            }
        }
    }
}
