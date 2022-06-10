package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.model.TaggedOrderParams;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.md.MdAutocomplete;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdMenu;
import co.nvqa.operator_v2.selenium.elements.nv.NvAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonFilePicker;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterBooleanBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import java.util.List;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Niko Susanto
 */
public class OrderTagManagementPage extends OperatorV2SimplePage {

  @FindBy(css = "button[aria-label='View Tagged Orders']")
  public Button viewTaggedOrders;

  @FindBy(xpath = "//nv-filter-autocomplete[@main-title='Shipper']")
  public NvFilterAutocomplete shipperFilter;

  @FindBy(css = "nv-filter-box[item-types='Order Tag(s)']")
  public NvFilterBox orderTagsFilter;

  @FindBy(xpath = "//nv-filter-box[@item-types='Status']")
  public NvFilterBox statusFilter;

  @FindBy(xpath = "//nv-filter-box[@item-types='Granular Status']")
  public NvFilterBox granularStatusFilter;

  @FindBy(xpath = "//nv-filter-box[@item-types='Order Type']")
  public NvFilterBox orderTypeFilter;

  @FindBy(xpath = "//nv-filter-box[@item-types='Master Shipper']")
  public NvFilterBox masterShipperFilter;

  @FindBy(css = "nv-filter-boolean-box[main-title='RTS']")
  public NvFilterBooleanBox rtsFilter;

  @FindBy(name = "container.order-tag-management.find-orders-with-csv")
  public NvIconTextButton findOrdersWithCsv;

  @FindBy(xpath = "//*[@on-click='ctrl.loadResult()' or @on-click='ctrl.goToResult()']")
  public NvIconTextButton loadSelection;

  @FindBy(name = "Clear All Selections")
  public NvIconTextButton clearAllSelection;

  @FindBy(css = "md-autocomplete[placeholder='Select Filter']")
  public MdAutocomplete addFilter;

  @FindBy(css = "md-dialog")
  public AddTagsDialog addTagsDialog;

  @FindBy(css = "md-dialog")
  public RemoveTagsDialog removeTagsDialog;

  @FindBy(css = "div.actions-container md-menu")
  public MdMenu actionsMenu;

  @FindBy(css = "md-dialog")
  public FindOrdersWithCsvDialog findOrdersWithCsvDialog;

  @FindBy(css = "md-dialog")
  public ClearAllTagsDialog clearAllTagsDialog;

  @FindBy(css = "md-progress-linear")
  public PageElement loadingBar;

  public OrdersTable ordersTable;
  public TaggedOrdersTable taggedOrdersTable;

  public void addFilter(String value) {
    addFilter.selectValue(value);
    addFilter.closeSuggestions();
  }

  public OrderTagManagementPage(WebDriver webDriver) {
    super(webDriver);
    ordersTable = new OrdersTable(webDriver);
    taggedOrdersTable = new TaggedOrdersTable(webDriver);
  }

  public void addTag(List<String> orderTags) {
    actionsMenu.selectOption("Add Tags");
    addTagsDialog.waitUntilVisible();
    addTagsDialog.selectTag.selectValues(orderTags);
    addTagsDialog.save.click();
    addTagsDialog.waitUntilInvisible();
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

  public static class TaggedOrdersTable extends MdVirtualRepeatTable<TaggedOrderParams> {

    public static final String COLUMN_DRIVER = "driver";
    public static final String COLUMN_ROUTE = "route";
    public static final String COLUMN_TAGS = "tags";

    public TaggedOrdersTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("trackingId", "tracking-id")
          .put(COLUMN_TAGS, "order-tags")
          .put(COLUMN_DRIVER, "driver-and-route")
          .put(COLUMN_ROUTE, "driver-and-route")
          .put("destinationHub", "destination-hub")
          .put("lastAttempt", "last-attempt")
          .put("daysFromFirstInbound", "days-from-first-inbound")
          .put("granularStatus", "granular-status")
          .build()
      );
      setMdVirtualRepeat("data in getTableData()");
      setColumnValueProcessors(ImmutableMap.of(
          COLUMN_DRIVER, value -> StringUtils.normalizeSpace(value.split(" - ")[0]),
          COLUMN_ROUTE, value -> StringUtils.normalizeSpace(value.split(" - ")[1]),
          COLUMN_TAGS, value -> StringUtils.replace(StringUtils.normalizeSpace(value), " ", ",")
      ));
      setEntityClass(TaggedOrderParams.class);
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

  public static class ClearAllTagsDialog extends MdDialog {

    @FindBy(css = "md-dialog-content > div")
    public PageElement message;

    @FindBy(name = "commons.remove-all")
    public NvIconTextButton removeAll;

    public ClearAllTagsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class FindOrdersWithCsvDialog extends MdDialog {

    @FindBy(css = "[label='Select File']")
    public NvButtonFilePicker selectFile;

    @FindBy(xpath = ".//a[text()='here']")
    public Button downloadSample;

    @FindBy(name = "commons.upload")
    public NvButtonSave upload;

    @FindBy(name = "commons.cancel")
    public NvIconTextButton cancel;

    public FindOrdersWithCsvDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

}