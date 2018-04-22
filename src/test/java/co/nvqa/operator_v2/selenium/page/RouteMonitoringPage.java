package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.commons.utils.StandardTestUtils;
import co.nvqa.operator_v2.model.RouteMonitoringFilters;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteMonitoringPage extends OperatorV2SimplePage
{
    private static final String MD_VIRTUAL_REPEAT = "route in getTableData()";
    public static final String COLUMN_CLASS_DATA_ROUTE_ID = "id";
    public static final String COLUMN_CLASS_DATA_HUB_NAME = "hub-name";
    public static final String ACTION_BUTTON_VIEW_ROUTE_MANIFEST = "container.route-monitoring.view-route-manifest";

    private RouteManifestPage routeManifestPage;

    public RouteMonitoringPage(WebDriver webDriver)
    {
        super(webDriver);
        routeManifestPage = new RouteManifestPage(webDriver);
    }

    public void waitUntilPageLoaded()
    {
        super.waitUntilPageLoaded();
        waitUntilInvisibilityOfElementLocated("//md-progress-circular/following-sibling::div[text()='Loading filters...']");
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

        clickNvApiTextButtonByNameAndWaitUntilDone("commons.load-selection");
        waitUntilInvisibilityOfElementLocated("//md-progress-circular/following-sibling::div[text()='Loading routes...']");
    }

    public void verifyRouteIsExistAndHasCorrectInfo(long routeId, RouteMonitoringFilters routeMonitoringFilters)
    {
        searchTableByRouteIdUntilFound(routeId);
        String actualRouteId = getTextOnTable(1, COLUMN_CLASS_DATA_ROUTE_ID);
        String actualInboundHub = getTextOnTable(1, COLUMN_CLASS_DATA_HUB_NAME);

        Assert.assertEquals("Route ID", String.valueOf(routeId), actualRouteId);
        Assert.assertThat("Hub", actualInboundHub, Matchers.isOneOf(routeMonitoringFilters.getHubs()));
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
            closeAllWindowsAcceptTheMainWindow(mainWindowHandle);
        }
    }

    public void switchToRouteManifestWindow(long routeId)
    {
        switchToOtherWindow("route-manifest/"+routeId);
    }

    public void searchTableByRouteIdUntilFound(long routeId)
    {
        StandardTestUtils.retryIfRuntimeExceptionOccurred(() ->
        {
            searchTableByRouteId(routeId);
            boolean isTableEmpty = isTableEmpty();

            if(isTableEmpty)
            {
                clearCache();
                clickButtonByAriaLabel("Edit Filters");
                pause2s();
                clickNvApiTextButtonByNameAndWaitUntilDone("commons.load-selection");
                pause200ms();
                throw new NvTestRuntimeException("Table is empty. Route not found.");
            }
        }, getCurrentMethodName());
    }

    public void searchTableByRouteId(long routeId)
    {
        searchTableCustom1("id", String.valueOf(routeId));
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    }
}
