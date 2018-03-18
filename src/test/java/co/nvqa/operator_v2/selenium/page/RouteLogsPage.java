package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.utils.NvLogger;
import org.junit.Assert;
import org.openqa.selenium.StaleElementReferenceException;
import org.openqa.selenium.WebDriver;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteLogsPage extends OperatorV2SimplePage
{
    private static final int MAX_RETRY = 10;
    private static final String MD_VIRTUAL_REPEAT = "route in getTableData()";

    public static final String COLUMN_CLASS_FILTER_ROUTE_ID = "id";
    public static final String COLUMN_CLASS_DATA_ROUTE_ID = "id";
    public static final String COLUMN_CLASS_DATA_DRIVER_NAME = "_driver-name ";
    public static final String COLUMN_CLASS_STATUS = "status";

    public static final String ACTION_BUTTON_EDIT_ROUTE = "container.route-logs.edit-route";
    public static final String ACTION_BUTTON_EDIT_DETAILS = "container.route-logs.edit-details";

    public static final String SELECT_TAG_XPATH = "//md-select[contains(@aria-label, 'Select Tag:')]";

    public static final SimpleDateFormat DATE_PICKER_ID_SDF = new SimpleDateFormat("EEEE MMMM d yyyy");

    public RouteLogsPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void selectRouteDateFilter(Date fromDate, Date toDate)
    {
        click("//md-datepicker[@name='fromDateField']/button");
        pause100ms();
        click(String.format("//td[contains(@aria-label, '%s')]", DATE_PICKER_ID_SDF.format(fromDate)));
        pause50ms();
        click("//md-datepicker[@name='toDateField']/button");
        pause100ms();
        click(String.format("//td[contains(@aria-label, '%s')]", DATE_PICKER_ID_SDF.format(toDate)));
        pause50ms();
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

    public void deleteRoute(String routeId)
    {
        searchAndVerifyRouteExist(routeId);
        clickActionButtonOnTable(1, RouteLogsPage.ACTION_BUTTON_EDIT_DETAILS);
        pause200ms();
        click("//button[@ng-class='ngClazz'][@aria-label='Delete']");
        pause200ms();

        boolean clicked = false;
        int counter = 0;

        while(!clicked && counter<MAX_RETRY)
        {
            try
            {
                clickButtonByAriaLabel("Delete");
                pause200ms();
                clicked = true;
            }
            catch(StaleElementReferenceException ex)
            {
                NvLogger.warn("Trying to recover from a stale element: "+ex.getMessage(), ex);
                counter++;
            }
        }
    }

    public void searchTableByRouteId(String routeId)
    {
        searchTableCustom1(COLUMN_CLASS_FILTER_ROUTE_ID, routeId);
    }

    public void searchAndVerifyRouteExist(String routeId)
    {
        searchTableByRouteId(routeId);
        String actualRouteId = getTextOnTable(1, COLUMN_CLASS_DATA_ROUTE_ID, XpathTextMode.EXACT);
        Assert.assertEquals("Route ID nof found in table.", routeId, actualRouteId);
        pause200ms();
    }

    public void selectTag(String routeId, String newTag)
    {
        searchAndVerifyRouteExist(routeId);
        click(SELECT_TAG_XPATH);
        pause100ms();
        click(String.format("//div[contains(@class,'md-select-menu-container') and @aria-hidden='false']/md-select-menu/md-content/md-option/div[@class='md-text' and contains(text(), '%s')]", newTag));
        pause100ms();
        click("//nv-table-description/div/div/span[text()='Showing']"); //Click on random element to close 'Select Tag' dialog.
        pause200ms();
    }

    public String getRouteTag(String routeId)
    {
        searchAndVerifyRouteExist(routeId);
        return getText(SELECT_TAG_XPATH);
    }

    public void loadAndVerifyRoute(String routeId)
    {
        clickLoadSelection();
        searchTableByRouteId(routeId);
        String actualRouteStatus = getTextOnTable(1, COLUMN_CLASS_STATUS);
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
