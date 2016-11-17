package com.nv.qa.selenium.page.page;

import org.junit.Assert;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteGroupTemplatesPage extends SimplePage
{
    public static final String COLUMN_CLASS_NAME = "name";
    public static final String COLUMN_CLASS_FILTER = "filter";

    public static final String ACTION_BUTTON_EDIT = "Edit";
    public static final String ACTION_BUTTON_DELETE = "Delete";

    public RouteGroupTemplatesPage(WebDriver driver)
    {
        super(driver);
        PageFactory.initElements(driver, this);
    }

    public void createRouteGroupTemplate(String routeGroupTemplateName, String filterQuery)
    {
        click("//button[@aria-label='Add Template']");
        setRouteGroupNameValue(routeGroupTemplateName);
        setFilterQuery(filterQuery);
        clickSubmitOnAddDialog();
    }

    public void editRouteGroupTemplate(String filterRouteGroupTemplateName, String newRouteGroupTemplateName, String newFilterQuery)
    {
        searchTemplates(filterRouteGroupTemplateName);
        pause100ms();
        String actualName = getTextOnTable(1, RouteGroupTemplatesPage.COLUMN_CLASS_NAME);
        Assert.assertEquals(filterRouteGroupTemplateName, actualName);

        clickActionButton(1, ACTION_BUTTON_EDIT);
        setRouteGroupNameValue(newRouteGroupTemplateName);
        setFilterQuery(newFilterQuery);
        clickSubmitOnEditDialog();
    }

    public void deleteRouteGroupTemplate(String filterRouteGroupTemplateName)
    {
        searchTemplates(filterRouteGroupTemplateName);
        pause100ms();
        clickActionButton(1, ACTION_BUTTON_DELETE);
        pause100ms();
        click("//md-dialog/md-dialog-actions/button[@aria-label='Delete']");
    }

    public void setRouteGroupNameValue(String value)
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

    public void searchTemplates(String keyword)
    {
        sendKeys("//input[@type='text'][@ng-model='searchText']", keyword);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        String text = null;

        try
        {
            WebElement we = findElementByXpath(String.format("//tr[@ng-repeat='routeGroupTemplate in $data'][%d]/td[contains(@class, '%s')]", rowNumber, columnDataClass));
            text = we.getText().trim();
        }
        catch(NoSuchElementException ex)
        {
        }

        return text;
    }

    public void clickActionButton(int rowNumber, String actionButtonName)
    {
        try
        {
            WebElement we = findElementByXpath(String.format("//tr[@ng-repeat='routeGroupTemplate in $data'][%d]/td[contains(@class, 'actions')]/div/*[@name='%s']", rowNumber, actionButtonName));
            moveAndClick(we);
        }
        catch(NoSuchElementException ex)
        {
            throw new RuntimeException("Cannot find action button.", ex);
        }
    }
}
