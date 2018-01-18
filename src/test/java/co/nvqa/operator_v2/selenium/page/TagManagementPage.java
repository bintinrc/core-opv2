package co.nvqa.operator_v2.selenium.page;

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

    public TagManagementPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void clickTagNameColumnHeader()
    {
        WebElement we = findElementByXpath("//th[contains(@class, 'name')]");
        moveAndClick(we);
        pause200ms();
    }

    public void clickCreateTag()
    {
        clickNvIconTextButtonByName("container.tag-management.create-tag");
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'tag-management-add')]");
    }

    public void setTagNameValue(String value)
    {
        sendKeysById("tag-name", value);
        pause100ms();
    }

    public void setDescriptionValue(String value)
    {
        sendKeysById("description", value);
        pause100ms();
    }

    public void clickSubmitOnAddTag()
    {
        clickNvButtonSaveByNameAndWaitUntilDone("Submit");
        waitUntilInvisibilityOfToast("1 Tag Created");
    }

    public void clickSubmitChangesOnEditTag()
    {
        clickNvButtonSaveByNameAndWaitUntilDone("Submit Changes");
        waitUntilInvisibilityOfToast("1 Tag Updated");
    }

    public void clickDeleteOnConfirmDeleteDialog()
    {
        click("//md-dialog/md-dialog-actions/button[@aria-label='Delete']");
        waitUntilVisibilityOfElementLocated("//div[@class='toast-bottom'][contains(text(),'1 Tag Deleted')]");
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
        pause200ms();
    }
}
