package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class TagManagementPage extends OperatorV2SimplePage {

  private static final String MD_VIRTUAL_REPEAT = "tag in getTableData()";

  //public static final String COLUMN_CLASS_DATA_NO = "column-index";
  public static final String COLUMN_CLASS_DATA_TAG_NAME = "name";
  public static final String COLUMN_CLASS_DATA_DESCRIPTION = "description";

  public static final String ACTION_BUTTON_EDIT = "commons.edit";
  public static final String ACTION_BUTTON_DELETE = "commons.delete";

  @FindBy(name = "container.tag-management.create-tag")
  public NvIconTextButton createTag;

  @FindBy(css = "md-dialog")
  public AddTagDialog addTagDialog;

  public TagManagementPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void clickTagNameColumnHeader() {
    WebElement we = findElementByXpath("//th[contains(@class, 'name')]");
    moveAndClick(we);
    pause200ms();
  }

  public void clickDeleteOnConfirmDeleteDialog() {
    click("//md-dialog/md-dialog-actions/button[@aria-label='Delete']");
    waitUntilVisibilityOfElementLocated(
        "//div[@class='toast-bottom'][contains(text(),'1 Tag Deleted')]");
  }

  public String getTextOnTable(int rowNumber, String columnDataClass) {
    return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
  }

  public void clickActionButtonOnTable(int rowNumber, String actionButtonName) {
    clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    pause200ms();
  }

  public static class AddTagDialog extends MdDialog {

    @FindBy(css = "[id^='tag-name']")
    public TextBox tagName;

    @FindBy(id = "description")
    public TextBox description;

    @FindBy(name = "Submit")
    public NvButtonSave submit;

    @FindBy(name = "Submit Changes")
    public NvButtonSave submitChanges;

    public AddTagDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}
