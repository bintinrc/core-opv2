package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Tag;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class ManageOrderTagsPage extends OperatorV2SimplePage {

  @FindBy(name = "container.manage-order-tags.create-tag")
  public NvIconTextButton createTag;

  @FindBy(css = "md-dialog")
  public AddTagDialog addTagDialog;

  @FindBy(css = "md-dialog")
  public ConfirmDeleteDialog confirmDeleteDialog;

  public TagsTable tagsTable;

  public ManageOrderTagsPage(WebDriver webDriver) {
    super(webDriver);
    tagsTable = new TagsTable(webDriver);
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

  public static class TagsTable extends MdVirtualRepeatTable<Tag> {

    public static final String COLUMN_NAME = "name";
    public static final String ACTION_DELETE = "Delete";

    public TagsTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_NAME, "name")
          .put("description", "description")
          .build()
      );
      setMdVirtualRepeat("tag in getTableData()");
      setActionButtonsLocators(ImmutableMap.of(ACTION_DELETE, "commons.delete"));
      setEntityClass(Tag.class);
    }
  }
}