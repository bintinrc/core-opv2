package com.nv.qa.selenium.page.page;

import org.junit.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteLogsPage extends SimplePage
{
    private static final String MD_VIRTUAL_REPEAT = "route in getTableData()";

    public static final String COLUMN_CLASS_FILTER_ROUTE_ID = "id";
    public static final String COLUMN_CLASS_DATA_ROUTE_ID = "id ";
    public static final String COLUMN_CLASS_DATA_DRIVER_NAME = "_driver-name ";

    public static final String ACTION_BUTTON_EDIT_ROUTE = "container.route-logs.edit-route";
    public static final String ACTION_BUTTON_EDIT_DETAILS = "container.route-logs.edit-details";
    public static final String ACTION_BUTTON_DELETE_ROUTE = "container.route-logs.delete-route";

    public static final String SELECT_TAG_XPATH = "//md-select[contains(@aria-label, 'Select Tag:')]";

    public RouteLogsPage(WebDriver driver)
    {
        super(driver);
        PageFactory.initElements(driver, this);
    }

    public void clickLoadSelection()
    {
        click("//button[@aria-label='Load Selection']");
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
        click("//button[@aria-label='Cancel']");
    }

    public void editAssignedDriver(String newDriverName)
    {
        sendKeys("//input[@aria-label='Assigned Driver']", newDriverName);
        pause1s();
        click(String.format("//li[@md-virtual-repeat='item in $mdAutocompleteCtrl.matches']/md-autocomplete-parent-scope/span/span[text()='%s']", newDriverName));
        pause100ms();
    }

    public void clickSaveButtonOnEditDetailsDialog()
    {
        click("//button[@aria-label='Save Button']");
        pause100ms();
    }

    public void deleteRoute(String routeId)
    {
        searchAndVerifyRouteExist(routeId);
        click("//button[@aria-label='Delete Route']");
        pause200ms();
        click("//button[@aria-label='Delete']");
        pause200ms();
    }

    public boolean isTableEmpty()
    {
        WebElement we = findElementByXpath("//h5[text()='No Results Found']");
        return we!=null;
    }

    public void searchTableByRouteId(String routeId)
    {
        searchTable(COLUMN_CLASS_FILTER_ROUTE_ID, routeId);
        pause200ms();
    }

    public void searchAndVerifyRouteExist(String routeId)
    {
        searchTableByRouteId(routeId);
        String actualRouteId = getTextOnTable(1, COLUMN_CLASS_DATA_ROUTE_ID, true);
        Assert.assertEquals("Route ID nof found in table.", routeId, actualRouteId);
        pause200ms();
    }

    public void selectTag(String routeId, String newTag)
    {
        searchAndVerifyRouteExist(routeId);
        click(SELECT_TAG_XPATH);
        pause100ms();
        click(String.format("//div[@class='md-select-menu-container md-active md-clickable']/md-select-menu/md-content/md-option/div[@class='md-text ng-binding' and contains(text(), '%s')]", newTag));
        pause100ms();
        click("//span[text()='Route Date']"); //Click on random element to close 'Select Tag' dialog.
        pause200ms();
    }

    public String getRouteTag(String routeId)
    {
        searchAndVerifyRouteExist(routeId);
        return findElementByXpath(SELECT_TAG_XPATH).getText();
    }

    public void searchTable(String columnClass, String keywords)
    {
        sendKeys(String.format("//th[contains(@class, '%s')]/nv-search-input-filter/md-input-container/div/input", columnClass), keywords);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass, boolean classMustExact)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT, classMustExact);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    }
}
