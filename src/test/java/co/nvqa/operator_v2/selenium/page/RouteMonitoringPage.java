package co.nvqa.operator_v2.selenium.page;

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
    public static final String COLUMN_ROUTE_ID = "id";
    public static final String COLUMN_HUB_NAME = "hub-name";

    public RouteMonitoringPage(WebDriver webDriver)
    {
        super(webDriver);
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
        StandardTestUtils.retryIfRuntimeExceptionOccurred(() ->
        {
            searchTableByRouteId(routeId);
            boolean isTableEmpty = isTableEmpty();

            if(isTableEmpty)
            {
                clickButtonByAriaLabel("Edit Filters");
                pause200ms();
                clickNvApiTextButtonByNameAndWaitUntilDone("commons.load-selection");
                pause200ms();
                throw new NvTestRuntimeException("Table is empty. Route not found.");
            }
        }, getCurrentMethodName());

        String actualRouteId = getTextOnTable(1, COLUMN_ROUTE_ID);
        String actualInboundHub = getTextOnTable(1, COLUMN_HUB_NAME);

        Assert.assertEquals("Route ID", String.valueOf(routeId), actualRouteId);
        Assert.assertThat("Hub", actualInboundHub, Matchers.isOneOf(routeMonitoringFilters.getHubs()));
    }

    public void searchTableByRouteId(long routeId)
    {
        searchTableCustom1("id", String.valueOf(routeId));
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }
}
