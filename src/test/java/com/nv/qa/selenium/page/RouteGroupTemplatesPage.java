package com.nv.qa.selenium.page;

import org.junit.Assert;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteGroupTemplatesPage extends SimplePage
{
    public static final String NG_REPEAT = "routeGroupTemplate in $data";
    public static final String COLUMN_CLASS_NAME = "name";
    public static final String COLUMN_CLASS_FILTER = "filter";

    public static final String ACTION_BUTTON_EDIT = "Edit";
    public static final String ACTION_BUTTON_DELETE = "Delete";

    public RouteGroupTemplatesPage(WebDriver driver)
    {
        super(driver);
    }

    public void createRouteGroupTemplate(String routeGroupTemplateName, String filterQuery)
    {
        click("//button[@aria-label='Add Template']");
        setRouteGroupTemplateNameValue(routeGroupTemplateName);
        setFilterQuery(filterQuery);
        clickSubmitOnAddDialog();
    }

    public void editRouteGroupTemplate(String filterRouteGroupTemplateName, String newRouteGroupTemplateName, String newFilterQuery)
    {
        searchTable(filterRouteGroupTemplateName);
        pause100ms();
        String actualName = getTextOnTable(1, RouteGroupTemplatesPage.COLUMN_CLASS_NAME);
        Assert.assertEquals(filterRouteGroupTemplateName, actualName);

        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        setRouteGroupTemplateNameValue(newRouteGroupTemplateName);
        setFilterQuery(newFilterQuery);
        clickSubmitOnEditDialog();
    }

    public void deleteRouteGroupTemplate(String filterRouteGroupTemplateName)
    {
        searchTable(filterRouteGroupTemplateName);
        pause100ms();
        clickActionButtonOnTable(1, ACTION_BUTTON_DELETE);
        pause100ms();
        click("//md-dialog/md-dialog-actions/button[@aria-label='Delete']");
    }

    public void setRouteGroupTemplateNameValue(String value)
    {
        sendKeys("//input[@aria-label='Route Group Template Name']", value);
    }

    public void setFilterQuery(String value)
    {
        sendKeys("//textarea[@aria-label='Filter Query']", value);
    }

    public void clickSubmitOnAddDialog()
    {
        click("//button[@aria-label='Save Button']");
    }

    public void clickSubmitOnEditDialog()
    {
        clickSubmitOnAddDialog();
    }

    public void searchTable(String keyword)
    {
        sendKeys("//input[@type='text'][@ng-model='searchText']", keyword);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithNgRepeat(rowNumber, actionButtonName, NG_REPEAT);
    }
}
