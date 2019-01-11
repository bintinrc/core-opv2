package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.commons.utils.StandardTestUtils;
import co.nvqa.operator_v2.model.RouteMonitoringFilters;
import co.nvqa.operator_v2.model.RouteMonitoringParams;
import com.google.common.collect.ImmutableList;
import org.apache.commons.lang3.StringUtils;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.util.List;

import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;
import static org.hamcrest.Matchers.hasItem;
import static org.hamcrest.Matchers.isOneOf;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings({"WeakerAccess", "unused"})
public class RouteMonitoringPage extends OperatorV2SimplePage
{
    private static final String MD_VIRTUAL_REPEAT = "route in getTableData()";
    public static final String COLUMN_CLASS_DATA_ROUTE_ID = "id";
    public static final String COLUMN_CLASS_DATA_HUB_NAME = "hub-name";
    public static final String ACTION_BUTTON_VIEW_ROUTE_MANIFEST = "container.route-monitoring.view-route-manifest";
    public static final String LOCATOR_BUTTON_LOAD_SELECTION = "commons.load-selection";
    public static final String LOCATOR_SPINNER_LOADING_ROUTES = "//md-progress-circular/following-sibling::div[text()='Loading routes...']";
    public static final String LOCATOR_SPINNER_LOADING_FILTERS = "//md-progress-circular/following-sibling::div[text()='Loading filters...']";

    private final RouteManifestPage routeManifestPage;
    private final RouteMonitoringTable routeMonitoringTable;

    public RouteMonitoringPage(WebDriver webDriver)
    {
        super(webDriver);
        routeManifestPage = new RouteManifestPage(webDriver);
        routeMonitoringTable = new RouteMonitoringTable(webDriver);
    }

    public void waitUntilPageLoaded()
    {
        super.waitUntilPageLoaded();
        waitUntilInvisibilityOfElementLocated(LOCATOR_SPINNER_LOADING_FILTERS);
    }

    public void clickLoadSelectionButtonAndWaitUntilDone()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone(LOCATOR_BUTTON_LOAD_SELECTION);
        waitUntilInvisibilityOfElementLocated(LOCATOR_SPINNER_LOADING_ROUTES);
    }

    public void filterAndLoadSelection(RouteMonitoringFilters routeMonitoringFilters)
    {
        waitUntilPageLoaded();
        setMdDatepicker("fromModel", routeMonitoringFilters.getRouteDate());

        for(String hub : routeMonitoringFilters.getHubs())
        {
            selectValueFromNvAutocompleteByItemTypes("Hubs", hub);
            click("//p[text()='Hubs']");
        }

        for(String tag : routeMonitoringFilters.getRouteTags())
        {
            selectValueFromNvAutocompleteByItemTypes("Route Tags", tag);
            click("//p[text()='Route Tags']");
        }

        clickLoadSelectionButtonAndWaitUntilDone();
    }

    public void verifyRouteIsExistAndHasCorrectInfo(long routeId, RouteMonitoringFilters routeMonitoringFilters)
    {
        searchTableByRouteIdUntilFound(routeId);
        String actualRouteId = getTextOnTable(1, COLUMN_CLASS_DATA_ROUTE_ID);
        String actualInboundHub = getTextOnTable(1, COLUMN_CLASS_DATA_HUB_NAME);

        Assert.assertEquals("Route ID", String.valueOf(routeId), actualRouteId);
        Assert.assertThat("Hub", actualInboundHub, isOneOf(routeMonitoringFilters.getHubs()));
    }

    public void verify1DeliverySuccessAtRouteManifest(Route route, Order order)
    {
        verify1DeliverySuccessOrFailAtRouteManifest(route, order, true);
    }

    public void verify1DeliveryFailAtRouteManifest(Route route, Order order)
    {
        verify1DeliverySuccessOrFailAtRouteManifest(route, order, false);
    }

    private void verify1DeliverySuccessOrFailAtRouteManifest(Route route, Order order, boolean verifyDeliverySuccess)
    {
        searchTableByRouteIdUntilFound(route.getId());
        clickActionButtonOnTable(1, ACTION_BUTTON_VIEW_ROUTE_MANIFEST);
        String mainWindowHandle = getWebDriver().getWindowHandle();
        getWebDriver().switchTo().window(mainWindowHandle); // Force selenium to go back to the last active tab/window if new tab/window is opened.

        try
        {
            switchToRouteManifestWindow(route.getId());
            routeManifestPage.waitUntilPageLoaded();

            if(verifyDeliverySuccess)
            {
                routeManifestPage.verify1DeliveryIsSuccess(route, order);
            }
            else
            {
                routeManifestPage.verify1DeliveryIsFailed(route, order);
            }
        }
        finally
        {
            closeAllWindows(mainWindowHandle);
        }
    }

    public void switchToRouteManifestWindow(long routeId)
    {
        switchToOtherWindow("route-manifest/" + routeId);
    }

    public void searchTableByRouteIdUntilFound(long routeId)
    {
        StandardTestUtils.retryIfRuntimeExceptionOccurred(() ->
        {
            routeMonitoringTable.filterByRouteId(routeId);
            boolean isTableEmpty = isTableEmpty();

            if(isTableEmpty)
            {
                refreshFilterResults();
                throw new NvTestRuntimeException("Table is empty. Route not found.");
            }
        }, getCurrentMethodName());
    }

    private void refreshFilterResults()
    {
        clearCache();
        clickButtonByAriaLabel("Edit Filters");
        pause2s();
        clickLoadSelectionButtonAndWaitUntilDone();
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    }

    public void verifyRouteMonitoringParams(RouteMonitoringParams expectedRouteMonitoringParams)
    {
        searchTableByRouteIdUntilFound(expectedRouteMonitoringParams.getRouteId());
        RouteMonitoringParams actualRouteMonitoringParams = routeMonitoringTable.getRouteMonitoringParams(1);

        if(expectedRouteMonitoringParams.getRouteId()!=null)
        {
            Assert.assertThat("Route ID", actualRouteMonitoringParams.getRouteId(), equalTo(expectedRouteMonitoringParams.getRouteId()));
        }

        if(expectedRouteMonitoringParams.getTotalWaypoint()!=null)
        {
            Assert.assertThat("Total WP", actualRouteMonitoringParams.getTotalWaypoint(), equalTo(expectedRouteMonitoringParams.getTotalWaypoint()));
        }

        if(expectedRouteMonitoringParams.getCompletionPercentage()!=null)
        {
            Assert.assertThat("Completion %", actualRouteMonitoringParams.getCompletionPercentage(), equalTo(expectedRouteMonitoringParams.getCompletionPercentage()));
        }

        if(expectedRouteMonitoringParams.getPendingCount()!=null)
        {
            Assert.assertThat("Pending Count", actualRouteMonitoringParams.getPendingCount(), equalTo(expectedRouteMonitoringParams.getPendingCount()));
        }

        if(expectedRouteMonitoringParams.getSuccessCount()!=null)
        {
            List<Integer> actualValues = ImmutableList.of(
                    actualRouteMonitoringParams.getSuccessCount(),
                    actualRouteMonitoringParams.getEarlyCount(),
                    actualRouteMonitoringParams.getLateCount());
            Assert.assertThat("Success Count or Early WP or Late WP", actualValues, hasItem(expectedRouteMonitoringParams.getSuccessCount()));
        }

        if(expectedRouteMonitoringParams.getFailedCount()!=null)
        {
            Assert.assertThat("Valid Failed", actualRouteMonitoringParams.getFailedCount(), equalTo(expectedRouteMonitoringParams.getFailedCount()));
        }

        if(expectedRouteMonitoringParams.getCmiCount()!=null)
        {
            Assert.assertThat("Invalid Failed", actualRouteMonitoringParams.getCmiCount(), equalTo(expectedRouteMonitoringParams.getCmiCount()));
        }
    }

    /**
     * Accessor for Reservations table
     */
    @SuppressWarnings("UnusedReturnValue")
    public static class RouteMonitoringTable extends OperatorV2SimplePage
    {
        private static final String MD_VIRTUAL_REPEAT = "route in getTableData()";
        private static final String COLUMN_CLASS_ID = "id";
        private static final String COLUMN_CLASS_TOTAL_WAYPOINT = "total-waypoint";
        private static final String COLUMN_CLASS_COMPLETION_PERCENTAGE = "completion-percentage";
        private static final String COLUMN_CLASS_PENDING_COUNT = "pending-count";
        private static final String COLUMN_CLASS_SUCCESS_COUNT = "success-count";
        private static final String COLUMN_CLASS_VALID_FAILED = "failed-count";
        private static final String COLUMN_CLASS_INVALID_FAILED = "cmi-count";
        private static final String COLUMN_CLASS_EARLY_WP = "early-count";
        private static final String COLUMN_CLASS_LATE_WP = "late-count";


        public RouteMonitoringTable(WebDriver webDriver)
        {
            super(webDriver);
        }

        public RouteMonitoringParams getRouteMonitoringParams(int rowIndex)
        {
            Assert.assertThat("Number of rows", getRowsCount(), greaterThanOrEqualTo(rowIndex));
            moveToElementWithXpath(String.format("//tr[@md-virtual-repeat='%s'][not(contains(@class, 'last-row'))][%d]/td[starts-with(@class, '%s')]", MD_VIRTUAL_REPEAT, rowIndex, COLUMN_CLASS_LATE_WP));

            RouteMonitoringParams routeMonitoringParams = new RouteMonitoringParams();
            routeMonitoringParams.setRouteId(getId(rowIndex));
            routeMonitoringParams.setTotalWaypoint(getTotalWp(rowIndex));
            routeMonitoringParams.setCompletionPercentage(getCompletionPercentage(rowIndex));
            routeMonitoringParams.setPendingCount(getPendingCount(rowIndex));
            routeMonitoringParams.setSuccessCount(getSuccessCount(rowIndex));
            routeMonitoringParams.setFailedCount(getValidFailed(rowIndex));
            routeMonitoringParams.setCmiCount(getInvalidFailed(rowIndex));
            routeMonitoringParams.setEarlyCount(getEarlyWp(rowIndex));
            routeMonitoringParams.setLateCount(getLateWp(rowIndex));
            return routeMonitoringParams;
        }

        public String getId(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_ID);
        }

        public String getTotalWp(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_TOTAL_WAYPOINT);
        }

        public String getCompletionPercentage(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_COMPLETION_PERCENTAGE);
        }

        public String getPendingCount(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_PENDING_COUNT);
        }

        public String getSuccessCount(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_SUCCESS_COUNT);
        }

        public String getValidFailed(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_VALID_FAILED);
        }

        public String getInvalidFailed(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_INVALID_FAILED);
        }

        public String getEarlyWp(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_EARLY_WP);
        }

        public String getLateWp(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_LATE_WP);
        }

        private String getTextOnTable(int rowNumber, String columnDataClass)
        {
            String text = getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
            return StringUtils.normalizeSpace(text);
        }

        public int getRowsCount()
        {
            return getRowsCountOfTableWithMdVirtualRepeat(MD_VIRTUAL_REPEAT);
        }

        public RouteMonitoringTable filterByRouteId(Long routeId)
        {
            searchTableCustom1(COLUMN_CLASS_ID, String.valueOf(routeId));
            return this;
        }
    }
}
