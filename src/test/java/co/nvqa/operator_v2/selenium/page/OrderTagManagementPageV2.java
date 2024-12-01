package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.core.model.order.Order;
import co.nvqa.common.utils.NvTestWaitTimeoutException;
import co.nvqa.operator_v2.exception.element.NvTestCoreElementNotFoundError;
import co.nvqa.operator_v2.model.TaggedOrderParams;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.FileInput;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntMenu;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.selenium.elements.ant.AntSwitch;
import co.nvqa.operator_v2.selenium.elements.ant.AntTableV2;
import com.google.common.collect.ImmutableMap;
import java.io.File;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class OrderTagManagementPageV2 extends SimpleReactPage<OrderTagManagementPageV2>{

  @FindBy(css = "button[aria-label='View Tagged Orders']")
  public Button viewTaggedOrders;

  @FindBy(css = "[data-testid='order-tag-management-filters.shipper']")
  public AntSelect3 shipperFilter;

  @FindBy(css = "[data-testid='order-tag-management-filters.status']")
  public AntSelect3 statusFilter;

  @FindBy(css = "[data-testid='order-tag-management-filters.granularStatus']")
  public AntSelect3 granularStatusFilter;

  @FindBy(css = "[data-testid='order-tag-management-filters.orderType']")
  public AntSelect3 orderTypeFilter;

  @FindBy(css = "[data-testid='order-tag-management-filters.masterShipper']")
  public AntSelect3 masterShipperFilter;

  @FindBy(css = "button[role='switch']")
  public AntSwitch rtsFilter;

  @FindBy(xpath = "//label/following-sibling::div")
  public PageElement rtsValue;

  @FindBy(css = "[data-testid='upload-csv-button']")
  public Button findOrdersWithCsv;

  @FindBy(css = "[data-pa-action='Load OTM Selection By Filters']")
  public Button loadSelection;

  @FindBy(css = "[data-testid='order-tag-management-filters.clear-all-filters']")
  public Button clearAllSelection;

  @FindBy(css = "[data-testid='order-tag-management-filters.add-filter']")
  public AntSelect3 addFilter;

  @FindBy(xpath = "//div[contains(@class,'add-tags-dialog')]")
  public AddTagsModal addTagsModal;

  @FindBy(xpath = "//div[contains(@class,'remove-tags-dialog')]")
  public RemoveTagsModal removeTagsModal;

  @FindBy(css = "[data-testid='apply-action']")
  public AntMenu actionsMenu;

  @FindBy(css = ".ant-modal")
  public FindOrdersWithCsvModal findOrdersWithCsvModal;

  @FindBy(xpath = "//div[contains(@class,'clear-all-tags-dialog')]")
  public ClearAllTagsModal clearAllTagsModal;

  @FindBy(css = "md-progress-linear")
  public PageElement loadingBar;

  public OrdersTable ordersTable;
  public TaggedOrdersTable taggedOrdersTable;

  private static final String TABLE_DATA = "data in getTableData()";
  private static final String TABLE_DATA_ORDER_ID_COLUMN_CLASS = "order-id";
  private static final String FILTER_STATUS_MAIN_TITLE = "Status";
  private static final String FILTER_GRANULAR_STATUS_MAIN_TITLE = "Granular Status";
  private static final String FILTER_SHIPPER_ITEM_TYPES = "Shipper";
  private static final String FILTER_MASTER_SHIPPER_ITEM_TYPES = "Master Shipper";


  public void addFilter(String value) {
    addFilter.selectValue(value);
    addFilter.closeMenu();
  }

  public OrderTagManagementPageV2(WebDriver webDriver) {
    super(webDriver);
    ordersTable = new OrdersTable(webDriver);
    taggedOrdersTable = new TaggedOrdersTable(webDriver);
  }

  public void addTag(List<String> orderTags) {
    actionsMenu.selectOption("Add Tags");
    addTagsModal.waitUntilVisible();
    addTagsModal.selectTag.selectValues(orderTags);
    addTagsModal.save.click();
    addTagsModal.waitUntilInvisible();
  }

  public static class OrdersTable extends AntTableV2<Order> {

    public OrdersTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("id", "order_id")
          .put("trackingId", "tracking_id")
          .put("granularStatus", "granular_status")
          .build()
      );
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

  public static class AddTagsModal extends AntModal {

    @FindBy(css = ".ant-select")
    public AntSelect3 selectTag;

    @FindBy(css = "[data-testid='save-button']")
    public Button save;

    public AddTagsModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class RemoveTagsModal extends AntModal {

    @FindBy(css = ".ant-select")
    public AntSelect3 selectTag;

    @FindBy(css = "[data-testid='remove-tags-dialog.save-button']")
    public Button save;

    @FindBy(css = "span[aria-label='close']")
    public Button removeTag;

    public RemoveTagsModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class ClearAllTagsModal extends AntModal {

    @FindBy(css = ".ant-spin-container")
    public PageElement message;

    @FindBy(css = "[data-testid='remove-all-button']")
    public Button removeAll;

    public ClearAllTagsModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class FindOrdersWithCsvModal extends AntModal {

    @FindBy(css = "[data-testid='upload-dragger']")
    public FileInput selectFile;

    @FindBy(css = "[data-testid='download-sample-file-button']")
    public Button downloadSample;

    @FindBy(css = "[data-testid='upload-button']")
    public Button upload;

    @FindBy(css = "[data-testid='cancel-button']")
    public Button cancel;

    public FindOrdersWithCsvModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public void selectShipperValue(String value) {
    selectValueFromNvAutocompleteByItemTypes(FILTER_SHIPPER_ITEM_TYPES, value);
  }

  public void selectMasterShipperValue(String value) {
    selectValueFromNvAutocompleteByItemTypes(FILTER_MASTER_SHIPPER_ITEM_TYPES, value);
  }

  public void selectUniqueStatusValue(String value) {
    List<String> valuesSelected = getSelectedValuesFromNvFilterBox(FILTER_STATUS_MAIN_TITLE);

    if ((Objects.nonNull(valuesSelected) && !valuesSelected.contains(value)) || valuesSelected
        .isEmpty()) {
      selectValueFromNvAutocompleteByItemTypesAndDismiss(FILTER_STATUS_MAIN_TITLE, value);
    }

    valuesSelected = getSelectedValuesFromNvFilterBox(FILTER_STATUS_MAIN_TITLE);

    if (Objects.nonNull(valuesSelected) && !valuesSelected.isEmpty()) {
      valuesSelected.stream()
          .filter(valueSelected -> !valueSelected.equals(value))
          .forEach(valueSelected -> removeSelectedValueFromNvFilterBoxByAriaLabel(
              FILTER_STATUS_MAIN_TITLE, valueSelected));
    }
  }

  public void selectUniqueGranularStatusValue(String value) {
    List<String> valuesSelected = getSelectedValuesFromNvFilterBox(
        FILTER_GRANULAR_STATUS_MAIN_TITLE);

    if ((Objects.nonNull(valuesSelected) && !valuesSelected.contains(value)) || valuesSelected
        .isEmpty()) {
      selectValueFromNvAutocompleteByItemTypesAndDismiss(FILTER_GRANULAR_STATUS_MAIN_TITLE, value);
    }

    valuesSelected = getSelectedValuesFromNvFilterBox(FILTER_GRANULAR_STATUS_MAIN_TITLE);

    if (Objects.nonNull(valuesSelected) && !valuesSelected.isEmpty()) {
      valuesSelected.stream()
          .filter(valueSelected -> !valueSelected.equals(value))
          .forEach(valueSelected -> removeSelectedValueFromNvFilterBoxByAriaLabel(
              FILTER_GRANULAR_STATUS_MAIN_TITLE, valueSelected));
    }
  }

  public void clickLoadSelectionButton() {
    clickNvIconTextButtonByNameAndWaitUntilDone("Load Selection");
  }

  public void searchAndSelectOrderInTable(String keyword) {
    searchTableCustom1(TABLE_DATA_ORDER_ID_COLUMN_CLASS, keyword);
    try {
      waitUntil(() -> getRowsCountOfTableWithMdVirtualRepeat(TABLE_DATA) == 1, 10_000);
    } catch (NvTestWaitTimeoutException e) {
      throw new NvTestCoreElementNotFoundError("Unable to find order in table", e);
    }
    checkRowWithMdVirtualRepeat(1, TABLE_DATA);
    clearSearchTableCustom1(TABLE_DATA_ORDER_ID_COLUMN_CLASS);
  }

  public void selectOrdersInTable() {
    int numberOfRows = getRowsCountOfTableWithMdVirtualRepeat(TABLE_DATA);
    for (int rowIndex = 1; rowIndex <= numberOfRows; rowIndex++) {
      checkRowWithMdVirtualRepeat(rowIndex, TABLE_DATA);
    }
  }

  public void clickTagSelectedOrdersButton() {
    clickButtonByAriaLabel("Tag Selected Orders");
  }

  public void tagSelectedOrdersAndSave(String tagLabel) {
    sendKeysByAriaLabel("tag-0", tagLabel);
    clickButtonOnMdDialogByAriaLabel("Save");
    waitUntilInvisibilityOfMdDialog();
  }

  public void uploadFindOrdersCsvWithOrderInfo(List<String> trackingIds) {
    clickNvIconTextButtonByNameAndWaitUntilDone(
        "container.order-level-tag-management.find-orders-with-csv");
    waitUntilVisibilityOfElementLocated("//md-dialog//h2[text()='Find Orders with CSV']");

    String csvContents = trackingIds.stream().collect(Collectors.joining(System.lineSeparator()));
    File csvFile = createFile(f("find-orders-with-csv-%s.csv", generateDateUniqueString()),
        csvContents);

    sendKeysByAriaLabel("Choose", csvFile.getAbsolutePath());
    waitUntilVisibilityOfElementLocated(
        f("//div[@class='upload-button-holder']/span[contains(text(), '%s')]", csvFile.getName()));
    clickNvApiTextButtonByNameAndWaitUntilDone("commons.upload");
    waitUntilInvisibilityOfToast(f("Matches with file shown in table"));
  }
}
