package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Tag;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class ManageOrderTagsPage extends SimpleReactPage<ManageOrderTagsPage> {

  @FindBy(css = "[data-testid='create-new-order-tag-button']")
  public Button createTag;

  @FindBy(css = ".ant-modal")
  public AddTagDialog addTagDialog;

  @FindBy(css = ".ant-modal")
  public ConfirmDeleteModal confirmDeleteDialog;

  public TagsTable tagsTable;

  public ManageOrderTagsPage(WebDriver webDriver) {
    super(webDriver);
    tagsTable = new TagsTable(webDriver);
  }

  @Override
  public void waitUntilLoaded() {
    if (createTag.isDisplayedFast()) {
      waitUntilLoaded(2);
    } else {
      waitUntilLoaded(10);
    }

  }

  public static class AddTagDialog extends AntModal {

    @FindBy(css = "[data-testid='tag-name-input']")
    public ForceClearTextBox tagName;

    @FindBy(css = "[data-testid='description-input']")
    public TextBox description;

    @FindBy(css = "[data-testid='order-tag-dialog-form-submit-button']")
    public Button submit;

    @FindBy(name = "Submit Changes")
    public NvButtonSave submitChanges;

    public AddTagDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class ConfirmDeleteModal extends AntModal {

    @FindBy(css = "[data-testid='confirm-button']")
    public Button delete;

    public ConfirmDeleteModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class TagsTable extends AntTableV2<co.nvqa.common.core.model.order.Tag> {

    public static final String COLUMN_NAME = "name";
    public static final String ACTION_DELETE = "Delete";

    public TagsTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_NAME, "name")
          .put("description", "description")
          .build()
      );
      setActionButtonsLocators(ImmutableMap.of(ACTION_DELETE,
          "//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='id']//button"));
      setEntityClass(co.nvqa.common.core.model.order.Tag.class);
    }
  }
}