package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdMenu;
import co.nvqa.operator_v2.selenium.elements.nv.NvAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import java.util.List;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Niko Susanto
 */
public class OrderTagManagementPage extends OperatorV2SimplePage {

  @FindBy(xpath = "//nv-filter-autocomplete[@main-title='Shipper']")
  public NvFilterAutocomplete shipperFilter;

  @FindBy(xpath = "//nv-filter-box[@item-types='Status']")
  public NvFilterBox statusFilter;

  @FindBy(xpath = "//nv-filter-box[@item-types='Granular Status']")
  public NvFilterBox granularStatusFilter;

  @FindBy(name = "Load Selection")
  public NvIconTextButton loadSelection;

  @FindBy(css = "md-dialog")
  public AddTagsDialog addTagsDialog;

  @FindBy(css = "md-dialog")
  public RemoveTagsDialog removeTagsDialog;

  @FindBy(css = "div.actions-container md-menu")
  public MdMenu actionsMenu;

  public OrdersTable ordersTable;

  public OrderTagManagementPage(WebDriver webDriver) {
    super(webDriver);
    ordersTable = new OrdersTable(webDriver);
  }

  public void addTag(List<String> orderTags) {
    actionsMenu.selectOption("Add Tags");
    addTagsDialog.waitUntilVisible();
    for (String tag : orderTags) {
      addTagsDialog.selectTag.selectValue(tag);
    }
    addTagsDialog.save.click();
    addTagsDialog.waitUntilInvisible();
  }

  public void removeTag(List<String> orderTags) {
    actionsMenu.selectOption("Remove Tags");
    removeTagsDialog.removeTag.waitUntilClickable();
    while (removeTagsDialog.removeTag.isDisplayedFast()) {
      removeTagsDialog.removeTag.click();
    }
    for (String tag : orderTags) {
      removeTagsDialog.selectTag.selectValue(tag);
    }
    removeTagsDialog.remove.click();
    removeTagsDialog.waitUntilInvisible();
  }

  public static class OrdersTable extends MdVirtualRepeatTable<Order> {

    public OrdersTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("id", "order-id")
          .put("trackingId", "tracking-id")
          .put("granularStatus", "granular-status")
          .build()
      );
      setMdVirtualRepeat("data in getTableData()");
      setEntityClass(Order.class);
    }

    public void selectFirstRowCheckBox() {
      click(".//tr[1]//td//md-checkbox");
    }
  }

  public static class AddTagsDialog extends MdDialog {

    @FindBy(xpath = ".//nv-autocomplete[@selected-item='ctrl.selectedTag']")
    public NvAutocomplete selectTag;

    @FindBy(name = "commons.save")
    public NvIconTextButton save;

    public AddTagsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class RemoveTagsDialog extends MdDialog {

    @FindBy(xpath = ".//nv-autocomplete[@selected-item='ctrl.selectedTag']")
    public NvAutocomplete selectTag;

    @FindBy(name = "commons.remove")
    public NvIconTextButton remove;

    @FindBy(css = "button[aria-label='remove']")
    public Button removeTag;

    public RemoveTagsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

}