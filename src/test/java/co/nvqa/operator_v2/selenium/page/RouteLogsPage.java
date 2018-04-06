package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.commons.utils.StandardTestUtils;
import co.nvqa.operator_v2.model.CreateRouteParams;
import co.nvqa.operator_v2.util.TestUtils;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.util.Date;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteLogsPage extends OperatorV2SimplePage
{
    private static final String MD_VIRTUAL_REPEAT = "route in getTableData()";

    public static final String COLUMN_CLASS_FILTER_ROUTE_ID = "id";
    public static final String COLUMN_CLASS_DATA_ROUTE_DATE = "_date";
    public static final String COLUMN_CLASS_DATA_ROUTE_ID = "id";
    public static final String COLUMN_CLASS_DATA_DRIVER_NAME = "_driver-name";
    public static final String COLUMN_CLASS_DATA_STATUS = "status";
    public static final String COLUMN_CLASS_DATA_ROUTE_PASSWORD = "route-password";
    public static final String COLUMN_CLASS_DATA_HUB_NAME = "_hub-name";
    public static final String COLUMN_CLASS_DATA_ZONE_NAME = "_zone-name";
    public static final String COLUMN_CLASS_DATA_COMMENTS = "comments";


    public static final String ACTION_BUTTON_EDIT_ROUTE = "container.route-logs.edit-route";
    public static final String ACTION_BUTTON_EDIT_DETAILS = "container.route-logs.edit-details";

    public static final String SELECT_TAG_XPATH = "//md-select[contains(@aria-label, 'Select Tag:')]";

    public RouteLogsPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void waitUntilPageLoaded()
    {
        super.waitUntilPageLoaded();
        waitUntilInvisibilityOfElementLocated("//md-progress-circular/following-sibling::div[text()='Loading data...']");
    }

    public long createNewRoute(CreateRouteParams createRouteParams)
    {
        waitUntilPageLoaded();
        selectRouteDateFilter(createRouteParams.getRouteDate(), createRouteParams.getRouteDate());
        clickLoadSelection();
        clickNvIconTextButtonByName("Create Route");
        setMdDatepickerById("commons.model.route-date", createRouteParams.getRouteDate());
        selectMultipleValuesFromMdSelectById("commons.model.route-tags", createRouteParams.getRouteTags());
        selectValueFromNvAutocompleteByPossibleOptions("zonesSelectionOptions", createRouteParams.getZoneName());
        selectValueFromNvAutocompleteByPossibleOptions("hubsSelectionOptions", createRouteParams.getHubName());
        selectValueFromNvAutocompleteByPossibleOptions("driversSelectionOptions", createRouteParams.getNinjaDriverName().replaceAll(" ", ""));
        selectValueFromNvAutocompleteByPossibleOptions("vehiclesSelectionOptions", createRouteParams.getVehicleName());
        sendKeysById("comments", createRouteParams.getComments());
        clickNvButtonSaveByNameAndWaitUntilDone("Create Route(s)");

        String toastBottomText = getToastBottomText();
        long routeId;

        if(toastBottomText==null)
        {
            throw new NvTestRuntimeException("Failed to create new Route.");
        }
        else
        {
            String routeIdAsString = toastBottomText.split("Route")[1].trim();
            routeId = Long.parseLong(routeIdAsString);
        }

        waitUntilInvisibilityOfToast("1 Route(s) Created");
        return routeId;
    }

    public void verifyNewRouteIsCreatedSuccessfully(CreateRouteParams createRouteParams, Route route)
    {
        searchTableByRouteIdUntilFoundAndPasswordIsNotEmpty(route.getId());

        String actualRouteDate = getTextOnTable(1, COLUMN_CLASS_DATA_ROUTE_DATE);
        String actualRouteId = getTextOnTable(1, COLUMN_CLASS_DATA_ROUTE_ID, XpathTextMode.EXACT);
        String actualDriverName = getTextOnTable(1, COLUMN_CLASS_DATA_DRIVER_NAME);
        String actualRoutePassword = getTextOnTable(1, COLUMN_CLASS_DATA_ROUTE_PASSWORD);
        String actualHubName = getTextOnTable(1, COLUMN_CLASS_DATA_HUB_NAME);
        String actualZoneName = getTextOnTable(1, COLUMN_CLASS_DATA_ZONE_NAME);
        String actualComments = getTextOnTable(1, COLUMN_CLASS_DATA_COMMENTS);

        route.setRoutePassword(actualRoutePassword);

        Assert.assertEquals("Route Date", YYYY_MM_DD_SDF.format(createRouteParams.getRouteDate()), actualRouteDate);
        Assert.assertEquals("Route ID", String.valueOf(route.getId()), actualRouteId);
        Assert.assertEquals("Driver Name", createRouteParams.getNinjaDriverName(), actualDriverName);
        Assert.assertEquals("Hub Name", createRouteParams.getHubName(), actualHubName);
        Assert.assertEquals("Zone Name", createRouteParams.getZoneName(), actualZoneName);
        Assert.assertEquals("Comments", createRouteParams.getComments(), actualComments);
    }

    public void selectRouteDateFilter(Date fromDate, Date toDate)
    {
        setMdDatepicker("fromModel", fromDate);
        setMdDatepicker("toModel", toDate);
    }

    public boolean isLoadSelectionVisible()
    {
        return isElementExist("//button[@aria-label='Load Selection']");
    }

    public void clickLoadSelection()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.load-selection");
    }

    public void clickEditFilter()
    {
        clickNvIconTextButtonByNameAndWaitUntilDone("container.route-logs.edit-filters");
    }

    public void clickLoadWaypointsOfSelectedRoutesOnly()
    {
        click("//div[text()='Load Waypoints of Selected Route(s) Only']");
    }

    public void clickLoadSelectedRoutesAndUnroutedWaypoints()
    {
        click("//div[text()='Load Selected Route(s) and Unrouted Waypoints']");
    }

    public void clickCancelOnEditRoutesDialog()
    {
        clickButtonByAriaLabel("Cancel");
    }

    public void editAssignedDriver(String newDriverName)
    {
        sendKeys("//div/label[text()='Assigned Driver']/following-sibling::nv-autocomplete//input", newDriverName);
        pause1s();
        click(String.format("//li[@md-virtual-repeat='item in $mdAutocompleteCtrl.matches']/md-autocomplete-parent-scope/span/span[text()='%s']", newDriverName));
        pause100ms();
    }

    public void clickSaveButtonOnEditDetailsDialog()
    {
        clickNvButtonSaveByNameAndWaitUntilDone("commons.save-changes");
    }

    public void deleteRoute(long routeId)
    {
        searchAndVerifyRouteExist(routeId);
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT_DETAILS);
        pause200ms();
        click("//button[@ng-class='ngClazz'][@aria-label='Delete']");
        pause200ms();

        TestUtils.retryIfStaleElementReferenceExceptionOccurred(()->
        {
            clickButtonByAriaLabel("Delete");
            pause200ms();
        }, getCurrentMethodName());
    }

    public void searchTableByRouteIdUntilFoundAndPasswordIsNotEmpty(long routeId)
    {
        StandardTestUtils.retryIfRuntimeExceptionOccurred(() ->
        {
            searchTableByRouteId(routeId);
            boolean isTableEmpty = isTableEmpty();

            boolean isReloadNeeded = false;
            String message = null;

            if(isTableEmpty)
            {
                isReloadNeeded = true;
                message = "Table is empty. Route not found.";
            }
            else
            {
                String actualRoutePassword = getTextOnTable(1, COLUMN_CLASS_DATA_ROUTE_PASSWORD);

                if(actualRoutePassword==null || actualRoutePassword.isEmpty())
                {
                    isReloadNeeded = true;
                    message = "Route is found but the password is empty.";
                }
            }

            if(isReloadNeeded)
            {
                clickButtonByAriaLabel("Edit Filters");
                pause1s();
                clickLoadSelection();
                pause200ms();
                throw new NvTestRuntimeException(message);
            }
        }, getCurrentMethodName());
    }

    public void searchTableByRouteId(long routeId)
    {
        searchTableCustom1(COLUMN_CLASS_FILTER_ROUTE_ID, String.valueOf(routeId));
    }

    public void searchAndVerifyRouteExist(long routeId)
    {
        searchTableByRouteId(routeId);
        String actualRouteId = getTextOnTable(1, COLUMN_CLASS_DATA_ROUTE_ID, XpathTextMode.EXACT);
        Assert.assertEquals("Route ID not found in table.", String.valueOf(routeId), actualRouteId);
        pause200ms();
    }

    public void selectTag(long routeId, String newTag)
    {
        searchAndVerifyRouteExist(routeId);
        click(SELECT_TAG_XPATH);
        pause100ms();
        click(String.format("//div[contains(@class,'md-select-menu-container') and @aria-hidden='false']/md-select-menu/md-content/md-option/div[@class='md-text' and contains(text(), '%s')]", newTag));
        pause100ms();
        click("//nv-table-description/div/div/span[text()='Showing']"); //Click on random element to close 'Select Tag' dialog.
        pause200ms();
    }

    public String getRouteTag(long routeId)
    {
        searchAndVerifyRouteExist(routeId);
        return getText(SELECT_TAG_XPATH);
    }

    public void loadAndVerifyRoute(long routeId)
    {
        clickLoadSelection();
        searchTableByRouteId(routeId);
        String actualRouteStatus = getTextOnTable(1, COLUMN_CLASS_DATA_STATUS);
        Assert.assertEquals("Track is not routed.","IN_PROGRESS", actualRouteStatus);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass, XpathTextMode xpathTextMode)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT, xpathTextMode);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    }
}
