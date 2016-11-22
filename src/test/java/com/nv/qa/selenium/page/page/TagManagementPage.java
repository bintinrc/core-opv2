package com.nv.qa.selenium.page.page;

import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class TagManagementPage extends SimplePage
{
    public static final String COLUMN_CLASS_NO = "column-index";
    public static final String COLUMN_CLASS_TAG_NAME = "name";
    public static final String COLUMN_CLASS_DESCRIPTION = "description";

    public static final String ACTION_BUTTON_EDIT = "commons.edit";
    public static final String ACTION_BUTTON_DELETE = "commons.delete";

    public TagManagementPage(WebDriver driver)
    {
        super(driver);
        PageFactory.initElements(driver, this);
    }

    public void clickTagNameColumnHeader()
    {
        WebElement we = findElementByXpath("//th[contains(@class, 'name')]");
        moveAndClick(we);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, "tag in getTableData()");
    }

    public void clickActionButton(int rowNumber, String actionButtonName)
    {
        try
        {
            WebElement we = findElementByXpath(String.format("//tr[@md-virtual-repeat='tag in getTableData()'][%d]/td[@class='actions column-locked-right ng-isolate-scope']/div/*[@name='%s']", rowNumber, actionButtonName));
            moveAndClick(we);
        }
        catch(NoSuchElementException ex)
        {
            throw new RuntimeException("Cannot find action button.", ex);
        }
    }

    public void clickCreateTag()
    {
        click("//button[@aria-label='Create Tag']");
    }

    public void setTagNameValue(String value)
    {
        sendKeys("//input[@aria-label='Tag Name']", value);
    }

    public void setDescriptionValue(String value)
    {
        sendKeys("//textarea[@aria-label='Description']", value);
    }

    public void clickSubmitOnAddTag()
    {
        click("//button[@aria-label='Save Button']");
    }

    public void clickSubmitChangesOnEditTag()
    {
        click("//button[@aria-label='Save Button']");
    }

    public void clickDeleteOnConfirmDeleteDialog()
    {
        click("//md-dialog/md-dialog-actions/button[@aria-label='Delete']");
    }
}
