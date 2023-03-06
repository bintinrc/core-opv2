package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Tag;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntTextBox;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class TagManagementPage extends SimpleReactPage<TagManagementPage> {

  @FindBy(xpath = "//button[.='Create tag']")
  public Button createTag;

  @FindBy(css = ".ant-modal")
  public AddTagDialog addTagDialog;

  public TagsTable tagsTable;

  public TagManagementPage(WebDriver webDriver) {
    super(webDriver);
    tagsTable = new TagsTable(webDriver);
  }

  public static class AddTagDialog extends AntModal {

    @FindBy(xpath = ".//span[./input[@placeholder='Tag Name']]")
    public AntTextBox tagName;

    @FindBy(xpath = ".//span[./input[@placeholder='Description']]")
    public AntTextBox description;

    @FindBy(xpath = ".//button[.='Create tag']")
    public Button submit;

    @FindBy(xpath = ".//button[.='Submit Changes']")
    public Button submitChanges;

    public AddTagDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class TagsTable extends AntTableV2<Tag> {

    public static final String COLUMN_NAME = "name";
    public static final String COLUMN_DESCRIPTION = "description";
    public static final String ACTION_EDIT = "Edit";

    public TagsTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_NAME, "name")
          .put(COLUMN_DESCRIPTION, "description")
          .build()
      );
      setActionButtonsLocators(ImmutableMap.of(ACTION_EDIT, "Edit Tag"));
      setEntityClass(Tag.class);
    }
  }
}