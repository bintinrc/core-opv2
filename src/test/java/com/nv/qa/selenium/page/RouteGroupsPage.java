package com.nv.qa.selenium.page;

import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteGroupsPage extends SimplePage
{
    private static final String MD_VIRTUAL_REPEAT = "routeGroup in ctrl.routeGroupsTableData";
    public static final String COLUMN_CLASS_NAME = "name";

    public static final String ACTION_BUTTON_EDIT = "commons.edit";
    public static final String ACTION_BUTTON_DELETE = "commons.delete";

    public RouteGroupsPage(WebDriver driver)
    {
        super(driver);
    }

    public void createRouteGroup(String routeGroupName)
    {
        click("//button[@aria-label='Create Route Group']");
        setRouteGroupNameValue(routeGroupName);
        clickCreateRouteGroupAndAddTransactionsOnCreateDialog();
    }

    public void editRouteGroup(String filterRouteGroupName, String newRouteGroupName)
    {
        searchTable(filterRouteGroupName);
        pause100ms();
        String actualName = getTextOnTable(1, RouteGroupsPage.COLUMN_CLASS_NAME);
        Assert.assertEquals(filterRouteGroupName, actualName);

        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        setRouteGroupNameValue(newRouteGroupName);
        clickCreateRouteGroupAndAddTransactionsOnEditDialog();
    }

    public void deleteRouteGroup(String filterRouteGroupName)
    {
        searchTable(filterRouteGroupName);
        pause100ms();
        clickActionButtonOnTable(1, ACTION_BUTTON_DELETE);
        pause100ms();
        click("//md-dialog/md-dialog-actions/button[@aria-label='Delete']");
        pause1s();
    }

    public void setRouteGroupNameValue(String value)
    {
        sendKeys("//input[@aria-label='Name']", value);
    }

    public void clickCreateRouteGroupAndAddTransactionsOnCreateDialog()
    {
        click("//button[@aria-label='Save Button']");
    }

    public void clickCreateRouteGroupAndAddTransactionsOnEditDialog()
    {
        clickCreateRouteGroupAndAddTransactionsOnCreateDialog();
        pause1s();
    }

    public void searchTable(String keyword)
    {
        Format formatter = new SimpleDateFormat("EEEE MMMM dd yyyy");
        String s = formatter.format(new Date());

        click("//md-datepicker[@ng-model='ctrl.filter.toDate']/button");
        pause1s();
        click("//td[@aria-label='" + s + "']");
        pause1s();
        sendKeys("//input[@type='text'][@ng-model='searchText']", keyword);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    }
}
