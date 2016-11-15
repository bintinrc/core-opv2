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
    public static final String COLUMN_CLASS_NO = "column-index ng-binding";
    public static final String COLUMN_CLASS_TAG_NAME = "name  ng-binding";
    public static final String COLUMN_CLASS_DESCRIPTION = "description  ng-binding";

    public static final String ACTION_BUTTON_EDIT = "commons.edit";
    public static final String ACTION_BUTTON_DELETE = "commons.delete";

    public TagManagementPage(WebDriver driver)
    {
        super(driver);
        PageFactory.initElements(driver, this);
    }

    public void clickTagNameColumnHeader()
    {
        WebElement we = getElementByXpath("//th[contains(@class, 'name')]");
        moveAndClick(we);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        String text = null;

        try
        {
            WebElement we = getElementByXpath(String.format("//tr[@md-virtual-repeat='tag in getTableData()'][%d]/td[@class='%s']", rowNumber, columnDataClass));
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
            WebElement we = getElementByXpath(String.format("//tr[@md-virtual-repeat='tag in getTableData()'][%d]/td[@class='actions column-locked-right ng-isolate-scope']/div/*[@name='%s']", rowNumber, actionButtonName));
            moveAndClick(we);
        }
        catch(NoSuchElementException ex)
        {
            throw new RuntimeException("Cannot find action button.", ex);
        }
    }

    public void clickCreateTag()
    {
        clickButton("//button[@aria-label='Create Tag']");
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
        clickButton("//button[@aria-label='Save Button']");
    }

    public void clickSubmitChangesOnEditTag()
    {
        clickButton("//button[@aria-label='Save Button']");
    }

    public void clickDeleteOnConfirmDeleteDialog()
    {
        clickButton("//md-dialog/md-dialog-actions/button[@aria-label='Delete']");
    }
}
