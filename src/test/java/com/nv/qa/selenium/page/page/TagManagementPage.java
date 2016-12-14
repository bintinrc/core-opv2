package com.nv.qa.selenium.page.page;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class TagManagementPage extends SimplePage
{
    private static final String MD_VIRTUAL_REPEAT = "tag in getTableData()";

    public static final String COLUMN_CLASS_NO = "column-index";
    public static final String COLUMN_CLASS_TAG_NAME = "name";
    public static final String COLUMN_CLASS_DESCRIPTION = "description";

    public static final String ACTION_BUTTON_EDIT = "commons.edit";
    public static final String ACTION_BUTTON_DELETE = "commons.delete";

    public TagManagementPage(WebDriver driver)
    {
        super(driver);
    }

    public void clickTagNameColumnHeader()
    {
        WebElement we = findElementByXpath("//th[contains(@class, 'name')]");
        moveAndClick(we);
        pause200ms();
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, "tag in getTableData()");
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
        pause200ms();
    }

    public void clickCreateTag()
    {
        click("//button[@aria-label='Create Tag']");
        pause200ms();
    }

    public void setTagNameValue(String value)
    {
        sendKeys("//input[@aria-label='Tag Name']", value);
        pause100ms();
    }

    public void setDescriptionValue(String value)
    {
        sendKeys("//textarea[@aria-label='Description']", value);
        pause100ms();
    }

    public void clickSubmitOnAddTag()
    {
        click("//button[@aria-label='Save Button']");
        pause200ms();
    }

    public void clickSubmitChangesOnEditTag()
    {
        click("//button[@aria-label='Save Button']");
        pause200ms();
    }

    public void clickDeleteOnConfirmDeleteDialog()
    {
        click("//md-dialog/md-dialog-actions/button[@aria-label='Delete']");
        pause200ms();
    }
}
