package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.model.DataEntity;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.dp.dp_database_checking.DatabaseCheckingCustomerCollectOrder;
import co.nvqa.commons.model.dp.dp_database_checking.DatabaseCheckingDriverCollectOrder;
import co.nvqa.operator_v2.model.AddToRouteData;
import co.nvqa.operator_v2.model.RegularPickup;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdAutocomplete;
import co.nvqa.operator_v2.selenium.elements.md.MdCheckbox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdMenu;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonFilePicker;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterTimeBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.selenium.page.AllOrdersPage.OrdersTable.OrderInfo;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import java.io.File;
import java.time.LocalDateTime;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.Condition;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static co.nvqa.operator_v2.selenium.page.AllOrdersPage.AllOrdersAction.CANCEL_SELECTED;
import static co.nvqa.operator_v2.selenium.page.AllOrdersPage.AllOrdersAction.PULL_FROM_ROUTE;

/**
 * @author Tristania Siagian
 */
@SuppressWarnings("WeakerAccess")
public class AllOrdersPage extends OperatorV2SimplePage implements MaskedPage {

  private static final String SAMPLE_CSV_FILENAME = "find-orders-with-csv.csv";
  public static final String SELECTION_ERROR_CSV_FILENAME = "selection-error.csv";
  public static final String MANUALLY_COMPLETE_ERROR_CSV_FILENAME = "manually-complete-error.csv";
  private static final String MD_VIRTUAL_REPEAT_TABLE_ORDER = "order in getTableData()";

  public static final String COLUMN_CLASS_DATA_TRACKING_ID_ON_TABLE_ORDER = "tracking-id";
  public static final String COLUMN_CLASS_DATA_FROM_NAME_ON_TABLE_ORDER = "from-name";
  public static final String COLUMN_CLASS_DATA_FROM_CONTACT_ON_TABLE_ORDER = "from-contact";
  public static final String COLUMN_CLASS_DATA_FROM_ADDRESS_ON_TABLE_ORDER = "_from-address";
  public static final String COLUMN_CLASS_DATA_FROM_POSTCODE_ON_TABLE_ORDER = "from-postcode";
  public static final String COLUMN_CLASS_DATA_TO_NAME_ON_TABLE_ORDER = "to-name";
  public static final String COLUMN_CLASS_DATA_TO_CONTACT_ON_TABLE_ORDER = "to-contact";
  public static final String COLUMN_CLASS_DATA_TO_ADDRESS_ON_TABLE_ORDER = "_to-address";
  public static final String COLUMN_CLASS_DATA_TO_POSTCODE_ON_TABLE_ORDER = "to-postcode";
  public static final String COLUMN_CLASS_DATA_GRANULAR_STATUS_ON_TABLE_ORDER = "_granular-status";

  public static final String ACTION_BUTTON_PRINT_WAYBILL_ON_TABLE_ORDER = "container.order.list.print-waybill";

  @FindBy(css = "span[ng-click='onMaskClick()']")
  public PageElement mask;
  @FindBy(css = "nv-filter-box[main-title='Status']")
  public NvFilterBox statusFilter;

  @FindBy(xpath = "//button[@aria-label='Pending Pickup']/i")
  public Button disablePendingPickup;

  @FindBy(xpath = "//button[@aria-label='Pending']/i")
  public Button disablePending;

  @FindBy(xpath = "//input[@class='md-datepicker-input']")
  public TextBox datePickerInput;

  @FindBy(css = "[aria-label='Submit']")
  public PageElement submit;

  @FindBy(xpath = "//button//span[text()='Apply Action']")
  public Button buttonApplyAction;

  @FindBy(name = "commons.load-selection")
  public NvApiTextButton loadSelection;

  @FindBy(xpath = "//nv-search-input-filter[@search-text='filter.trackingId']//input")
  public TextBox trackingIdFilter;

  @FindBy(xpath = "//td[@class='column-checkbox']//md-checkbox")
  public PageElement buttonCheckboxOrder;

  @FindBy(css = "nv-filter-box[main-title='Granular Status']")
  public NvFilterBox granularStatusFilter;

  @FindBy(css = "nv-filter-time-box")
  public NvFilterTimeBox creationTimeFilter;

  @FindBy(css = "nv-filter-box[main-title='Master Shipper']")
  public NvFilterBox masterShipperFilter;

  @FindBy(css = "nv-filter-autocomplete[main-title='Shipper']")
  public NvFilterAutocomplete shipperFilter;

  @FindBy(css = "md-autocomplete[md-input-name='searchTerm']")
  public MdAutocomplete searchTerm;

  @FindBy(name = "commons.search")
  public NvApiTextButton search;

  @FindBy(css = "th.column-checkbox md-menu")
  public MdMenu selectionMenu;

  @FindBy(xpath = "//md-menu[contains(.,'Preset Actions')]")
  public MdMenu presetActions;

  @FindBy(name = "container.order.list.find-orders-with-csv")
  public NvIconTextButton findOrdersWithCsv;

  @FindBy(css = "[id^='category']")
  public MdSelect categorySelect;

  @FindBy(css = "[id^='search-logic']")
  public MdSelect searchLogicSelect;

  @FindBy(css = "md-dialog")
  public FindOrdersWithCsvDialog findOrdersWithCsvDialog;

  @FindBy(css = "md-dialog")
  public ManuallyCompleteOrderDialog manuallyCompleteOrderDialog;

  @FindBy(xpath = "//md-dialog[.//div[@class='error-box']]")
  public ErrorsDialog errorsDialog;

  @FindBy(css = "md-dialog")
  public PullSelectedFromRouteDialog pullSelectedFromRouteDialog;

  @FindBy(css = "md-dialog")
  public PrintWaybillsDialog printWaybillsDialog;

  @FindBy(css = "md-dialog")
  public ResumeSelectedDialog resumeSelectedDialog;

  @FindBy(css = "md-dialog")
  public CancelSelectedDialog cancelSelectedDialog;

  @FindBy(css = "md-dialog")
  public AddToRouteDialog addToRouteDialog;

  @FindBy(css = "md-dialog")
  public SavePresetDialog savePresetDialog;

  @FindBy(css = "md-dialog")
  public DeletePresetDialog deletePresetDialog;

  @FindBy(css = "md-dialog")
  public SelectionErrorDialog selectionErrorDialog;

  @FindBy(css = "div.navigation md-menu")
  public MdMenu actionsMenu;

  @FindBy(css = "md-autocomplete[placeholder='Select Filter']")
  public MdAutocomplete addFilter;

  @FindBy(css = "[id^='commons.preset.load-filter-preset']")
  public MdSelect filterPreset;

  public void addFilter(String value) {
    addFilter.simpleSelectValue(value);
  }

  public ImmutableMap<String, Button> disableGranStatusElement = ImmutableMap.<String, Button>builder()
      .put("Pending Pickup", disablePendingPickup).build();

  public ImmutableMap<String, Button> disableStatusElement = ImmutableMap.<String, Button>builder()
      .put("Pending", disablePending).build();


  public enum Category {
    TRACKING_OR_STAMP_ID("Tracking / Stamp ID"), NAME("Name"), CONTACT_NUMBER(
        "Contact Number"), RECIPIENT_ADDRESS_LINE_1("Recipient Address (Line 1)");

    private final String value;

    Category(String value) {
      this.value = value;
    }

    public static Category findByValue(String value) {
      Category result = TRACKING_OR_STAMP_ID;

      for (Category enumTemp : values()) {
        if (enumTemp.getValue().equalsIgnoreCase(value)) {
          result = enumTemp;
          break;
        }
      }

      return result;
    }

    public String getValue() {
      return value;
    }
  }

  public enum SearchLogic {
    EXACTLY_MATCHES("exactly matches"), CONTAINS("contains");

    private final String value;

    SearchLogic(String value) {
      this.value = value;
    }

    public static SearchLogic findByValue(String value) {
      SearchLogic result = EXACTLY_MATCHES;

      for (SearchLogic enumTemp : values()) {
        if (enumTemp.getValue().equalsIgnoreCase(value)) {
          result = enumTemp;
          break;
        }
      }

      return result;
    }

    public String getValue() {
      return value;
    }
  }

  public void selectFilterPreset(String preset) {
    filterPreset.searchAndSelectValue(preset);
    filterPreset.waitUntilEnabled(60);
  }

  public final EditOrderPage editOrderPage;

  public OrdersTable ordersTable;

  public AllOrdersPage(WebDriver webDriver) {
    this(webDriver, new EditOrderPage(webDriver));
  }

  public AllOrdersPage(WebDriver webDriver, EditOrderPage editOrderPage) {
    super(webDriver);
    this.editOrderPage = editOrderPage;
    ordersTable = new OrdersTable(webDriver);
  }

  public void waitUntilPageLoaded() {
    super.waitUntilPageLoaded();
    if (halfCircleSpinner.waitUntilVisible(2)) {
      halfCircleSpinner.waitUntilInvisible(60);
    }
  }

  public void verifyItsCurrentPage() {
    super.waitUntilPageLoaded();
    Assertions.assertThat(getWebDriver().getCurrentUrl())
        .withFailMessage("All Orders page is not opened").endsWith("/order");
  }

  public void downloadSampleCsvFile() {
    findOrdersWithCsv.click();
    findOrdersWithCsvDialog.waitUntilVisible();
    findOrdersWithCsvDialog.downloadSample.click();
    findOrdersWithCsvDialog.cancel.click();
  }

  public void verifySampleCsvFileDownloadedSuccessfully() {
    verifyFileDownloadedSuccessfully(SAMPLE_CSV_FILENAME,
        "NVSGNINJA000000001\nNVSGNINJA000000002\nNVSGNINJA000000003");
  }

  public void findOrdersWithCsv(List<String> listOfTrackingId) {
    String csvContents = listOfTrackingId.stream()
        .collect(Collectors.joining(System.lineSeparator(), "", System.lineSeparator()));
    File csvFile = createFile(
        String.format("find-orders-with-csv_%s.csv", generateDateUniqueString()), csvContents);

    waitUntilPageLoaded();
    findOrdersWithCsv.click();
    findOrdersWithCsvDialog.waitUntilVisible();
    findOrdersWithCsvDialog.selectFile.setValue(csvFile);
    findOrdersWithCsvDialog.upload.clickAndWaitUntilDone();
  }

  public void verifyAllOrdersInCsvIsFoundWithCorrectInfo(List<Order> listOfCreatedOrder) {
    listOfCreatedOrder.forEach(this::verifyOrderInfoOnTableOrderIsCorrect);
  }

  public void verifyInvalidTrackingIdsIsFailedToFind(List<String> listOfInvalidTrackingId) {
    pause1s();
    List<WebElement> listOfWe = findElementsByXpath(
        "//div[@ng-repeat='error in ctrl.payload.errors track by $index']");
    List<String> listOfActualInvalidTrackingId = listOfWe.stream()
        .map(we -> we.getText().split("\\.")[1].trim()).collect(Collectors.toList());
    Assertions.assertThat(listOfActualInvalidTrackingId).as("Expected Tracking ID not found.")
        .has(new Condition<>(l -> l.containsAll(listOfInvalidTrackingId), ""));
  }

  public void applyActionOrder(String action) {
    selectAllShown();
    ((JavascriptExecutor) getWebDriver()).executeScript("document.body.style.zoom='70%'");
    ((JavascriptExecutor) getWebDriver()).executeScript("arguments[0].click();",
        findElementByXpath(f("//button[@aria-label = '%s']", action)));
    pause2s();

  }

  public void verifyOrderStatus(String trackingId, String expectedOrderStatus) {
    filterTableOrderByTrackingId(trackingId);
    String actualGranularStatus = getTextOnTableOrder(1,
        COLUMN_CLASS_DATA_GRANULAR_STATUS_ON_TABLE_ORDER);
    Assertions.assertThat(actualGranularStatus).as("Granular Status")
        .isEqualToIgnoringCase(expectedOrderStatus);
  }

  public void verifyOrderInfoOnTableOrderIsCorrect(Order order) {
    String trackingId = order.getTrackingId();
    filterTableOrderByTrackingId(trackingId);

    String actualTrackingId = getTextOnTableOrder(1, COLUMN_CLASS_DATA_TRACKING_ID_ON_TABLE_ORDER);
    String actualFromName = getTextOnTableOrder(1, COLUMN_CLASS_DATA_FROM_NAME_ON_TABLE_ORDER);
    String actualFromContact = getTextOnTableOrder(1,
        COLUMN_CLASS_DATA_FROM_CONTACT_ON_TABLE_ORDER);
    String actualFromAddress = getTextOnTableOrder(1,
        COLUMN_CLASS_DATA_FROM_ADDRESS_ON_TABLE_ORDER);
    String actualFromPostcode = getTextOnTableOrder(1,
        COLUMN_CLASS_DATA_FROM_POSTCODE_ON_TABLE_ORDER);
    String actualToName = getTextOnTableOrder(1, COLUMN_CLASS_DATA_TO_NAME_ON_TABLE_ORDER);
    String actualToContact = getTextOnTableOrder(1, COLUMN_CLASS_DATA_TO_CONTACT_ON_TABLE_ORDER);
    String actualToAddress = getTextOnTableOrder(1, COLUMN_CLASS_DATA_TO_ADDRESS_ON_TABLE_ORDER);
    String actualToPostcode = getTextOnTableOrder(1, COLUMN_CLASS_DATA_TO_POSTCODE_ON_TABLE_ORDER);
    String actualGranularStatus = getTextOnTableOrder(1,
        COLUMN_CLASS_DATA_GRANULAR_STATUS_ON_TABLE_ORDER);

    Assertions.assertThat(actualTrackingId).as("Tracking ID").isEqualTo(trackingId);

    Assertions.assertThat(actualFromName).as("From Name").isEqualTo(order.getFromName());
    Assertions.assertThat(actualFromContact).as("From Contact").isEqualTo(order.getFromContact());
    Assertions.assertThat(actualFromAddress).as("From Address").contains(order.getFromAddress1());
    Assertions.assertThat(actualFromAddress).as("From Address").contains(order.getFromAddress2());
    Assertions.assertThat(actualFromPostcode).as("From Postcode")
        .isEqualTo(order.getFromPostcode());

    Assertions.assertThat(actualToName).as("To Name").isEqualTo(order.getToName());
    Assertions.assertThat(actualToContact).as("To Contact").isEqualTo(order.getToContact());
    Assertions.assertThat(actualToAddress).as("To Address").contains(order.getToAddress1());
    Assertions.assertThat(actualToAddress).as("To Address").contains(order.getToAddress2());
    Assertions.assertThat(actualToPostcode).as("To Postcode").isEqualTo(order.getToPostcode());

    Assertions.assertThat(actualGranularStatus).as("Granular Status")
        .isEqualToIgnoringCase(order.getGranularStatus().replaceAll("_", " "));
  }

  public void verifyOrderInfoIsCorrect(Order order) {
    String mainWindowHandle = getWebDriver().getWindowHandle();
    Long orderId = order.getId();
    String expectedTrackingId = order.getTrackingId();
    specificSearch(Category.TRACKING_OR_STAMP_ID, SearchLogic.EXACTLY_MATCHES, expectedTrackingId);

    try {
      switchToEditOrderWindow(orderId);
      editOrderPage.verifyOrderInfoIsCorrect(order);
    } finally {
      closeAllWindows(mainWindowHandle);
    }
  }

  public void selectAllShown() {
    selectionMenu.selectOption("Select All Shown");
  }

  public String forceSuccessOrders() {
    clearFilterTableOrderByTrackingId();
    selectAllShown();
    actionsMenu.selectOption(AllOrdersAction.MANUALLY_COMPLETE_SELECTED.getName());
    manuallyCompleteOrderDialog.waitUntilVisible();
    String reason = "Force success from automated test";
    manuallyCompleteOrderDialog.changeReason.setValue("Others (fill in below)");
    manuallyCompleteOrderDialog.reasonForChange.setValue(reason);
    manuallyCompleteOrderDialog.completeOrder.clickAndWaitUntilDone();
    manuallyCompleteOrderDialog.waitUntilInvisible();
    waitUntilInvisibilityOfToast("Complete Order");
    return reason;
  }

  public void forceSuccessOrders(String reason, String reasonDescr) {
    clearFilterTableOrderByTrackingId();
    selectAllShown();
    actionsMenu.selectOption(AllOrdersAction.MANUALLY_COMPLETE_SELECTED.getName());
    manuallyCompleteOrderDialog.waitUntilVisible();
    manuallyCompleteOrderDialog.changeReason.setValue(reason);
    if (StringUtils.isNotBlank(reasonDescr)) {
      manuallyCompleteOrderDialog.reasonForChange.setValue(reasonDescr);
    }
    manuallyCompleteOrderDialog.completeOrder.clickAndWaitUntilDone();
    manuallyCompleteOrderDialog.waitUntilInvisible();
    waitUntilInvisibilityOfToast("Complete Order");
  }

  public void verifyOrderIsForceSuccessedSuccessfully(Order order) {
    String mainWindowHandle = getWebDriver().getWindowHandle();
    Long orderId = order.getId();
    String trackingId = order.getTrackingId();
    specificSearch(Category.TRACKING_OR_STAMP_ID, SearchLogic.EXACTLY_MATCHES, trackingId);

    try {
      switchToEditOrderWindow(orderId);
      editOrderPage.verifyOrderIsForceSuccessedSuccessfully(order);
    } finally {
      closeAllWindows(mainWindowHandle);
    }
  }

  public void rtsSingleOrderNextDay(String trackingId) {
    filterTableOrderByTrackingId(trackingId);
    selectAllShown();
    actionsMenu.selectOption("Set RTS to Selected");
    setMdDatepickerById("commons.model.delivery-date", TestUtils.getNextDate(1));
    selectValueFromMdSelectById("commons.timeslot", "3PM - 6PM");
    clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.set-order-to-rts");
    waitUntilInvisibilityOfToast("updated");
  }

  public void rtsMultipleOrderNextDay(List<String> listOfExpectedTrackingId) {
    clearFilterTableOrderByTrackingId();
    selectAllShown();
    actionsMenu.selectOption("Set RTS to Selected");
    List<WebElement> listOfWe = findElementsByXpath(
        "//tr[@ng-repeat='order in ctrl.orders']/td[1]");
    List<String> listOfActualTrackingIds = listOfWe.stream().map(WebElement::getText)
        .collect(Collectors.toList());
    Assertions.assertThat(listOfActualTrackingIds).as("Expected Tracking ID not found.").has(
        new Condition<>(l -> l.containsAll(listOfExpectedTrackingId), "Has Expected tracking id"));

    setMdDatepickerById("commons.model.delivery-date", TestUtils.getNextDate(1));
    selectValueFromMdSelectById("commons.timeslot", "3PM - 6PM");

    if (listOfActualTrackingIds.size() == 1) {
      clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.set-order-to-rts");
    } else {
      clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.set-orders-to-rts");
    }

    waitUntilInvisibilityOfToast("updated");
  }

  public void cancelSelected(List<String> listOfExpectedTrackingId) {
    clearFilterTableOrderByTrackingId();
    selectAllShown();
    actionsMenu.selectOption(CANCEL_SELECTED.getName());

    cancelSelectedDialog.waitUntilVisible();

    List<String> listOfActualTrackingIds = cancelSelectedDialog.trackingIds.stream()
        .map(PageElement::getText).collect(Collectors.toList());
    Assertions.assertThat(listOfActualTrackingIds).as("Expected Tracking ID not found.").has(
        new Condition<>(l -> l.containsAll(listOfExpectedTrackingId), "Has Expected tracking id"));

    cancelSelectedDialog.cancellationReason.setValue(String.format(
        "This order is canceled by automation to test 'Cancel Selected' feature on All Orders page. Canceled at %s.",
        DTF_CREATED_DATE.format(ZonedDateTime.now())));

    if (listOfActualTrackingIds.size() == 1) {
      cancelSelectedDialog.cancelOrder.clickAndWaitUntilDone();
    } else {
      cancelSelectedDialog.cancelOrders.clickAndWaitUntilDone();
    }
    cancelSelectedDialog.waitUntilInvisible();

    waitUntilInvisibilityOfToast(f("%d order(s) updated", listOfExpectedTrackingId.size()));
  }

  public void resumeSelected(List<String> listOfExpectedTrackingId) {
    clearFilterTableOrderByTrackingId();
    selectAllShown();
    actionsMenu.selectOption("Resume Selected");

    resumeSelectedDialog.waitUntilVisible();
    List<String> listOfActualTrackingIds = resumeSelectedDialog.trackingIds.stream()
        .map(PageElement::getText).collect(Collectors.toList());
    Assertions.assertThat(listOfActualTrackingIds).as("Expected Tracking ID not found.").has(
        new Condition<>(l -> l.containsAll(listOfExpectedTrackingId), "Has Expected tracking id"));

    if (listOfActualTrackingIds.size() == 1) {
      resumeSelectedDialog.resumeOrder.clickAndWaitUntilDone();
    } else {
      resumeSelectedDialog.resumeOrders.clickAndWaitUntilDone();
    }
    resumeSelectedDialog.waitUntilInvisible();
    waitUntilInvisibilityOfToast("updated");
  }

  public void pullOutFromRoute(List<String> listOfExpectedTrackingId) {
    applyActionToOrdersByTrackingId(listOfExpectedTrackingId, PULL_FROM_ROUTE);
    pullSelectedFromRouteDialog.waitUntilVisible();
    pullSelectedFromRouteDialog.pullOrdersFromRoutes.clickAndWaitUntilDone();
    pullSelectedFromRouteDialog.waitUntilInvisible();
    waitUntilInvisibilityOfToast("updated");
  }

  public void pullOutFromRouteWithExpectedSelectionError(List<String> listOfExpectedTrackingId) {
    applyActionToOrdersByTrackingId(listOfExpectedTrackingId, PULL_FROM_ROUTE);
    pullSelectedFromRouteDialog.waitUntilVisible();
    selectTypeFromPullSelectedFromRouteDialog(listOfExpectedTrackingId);
    pullSelectedFromRouteDialog.pullOrdersFromRoutes.clickAndWaitUntilDone();
  }

  public void selectTypeFromPullSelectedFromRouteDialog(List<String> listOfExpectedTrackingId) {
    List<WebElement> listOfWe = findElementsByXpath(
        "//tr[@ng-repeat='processedTransactionData in ctrl.processedTransactionsData']/td[@ng-if='ctrl.settings.showTrackingId']");
    List<String> listOfActualTrackingIds = listOfWe.stream().map(WebElement::getText)
        .collect(Collectors.toList());
    Assertions.assertThat(listOfActualTrackingIds).as("Expected Tracking ID not found.").has(
        new Condition<>(l -> l.containsAll(listOfExpectedTrackingId), "Has Expected tracking id"));
  }

  public void applyActionToOrdersByTrackingId(
      @SuppressWarnings("unused") List<String> listOfExpectedTrackingId, AllOrdersAction action) {
    clearFilterTableOrderByTrackingId();
    selectAllShown();
    actionsMenu.selectOption(action.getName());
  }

  public void verifySelectionErrorDialog(List<String> listOfExpectedTrackingId,
      AllOrdersAction action, List<String> expectedReasons) {
    WebElement failedToUpdateWe = findElementByXpath("//div[contains(text(), 'Failed to update')]");
    Assertions.assertThat(failedToUpdateWe).as("Failed to update n item(s) dialog not found.")
        .isNotNull();
    pause3s();

    //To-Do: Enable this codes below when they fix the UI.
//        Pattern p = Pattern.compile("([^\\s]+)\\s?.*Message:(.+)].*");
//        List<String> errors = pullSelectedFromRouteDialog.errors.stream().map(PageElement::getText).collect(Collectors.toList());
//       Assertions.assertThat(errors.size()).as("Unexpected number of Orders").isEqualTo(listOfExpectedTrackingId.size());
//        assertThat("Expected Tracking ID not found", errors, hasItems(errors.stream().map(error ->
//        {
//            Matcher m = p.matcher(error);
//            if (m.find())
//            {
//                return m.group(1);
//            } else
//            {
//                return null;
//            }
//        }).toArray(String[]::new)));
//
//        assertThat("Expected Error Message not found", errors, hasItems(errors.stream().map(error ->
//        {
//            Matcher m = p.matcher(error);
//            if (m.find())
//            {
//                return m.group(2);
//            } else
//            {
//                return null;
//            }
//        }).toArray(String[]::new)));

    pullSelectedFromRouteDialog.close.click();
    pullSelectedFromRouteDialog.waitUntilInvisible();
  }

  public void addToRoute(List<String> listOfExpectedTrackingId, String routeId, String tag) {
    fillAddToRouteFormUsingSetToAll(listOfExpectedTrackingId, routeId, tag);
    addToRouteDialog.addSelectedToRoutes.clickAndWaitUntilDone();
  }

  public void fillAddToRouteFormUsingSetToAll(List<String> listOfExpectedTrackingId, String routeId,
      String tag) {
    clearFilterTableOrderByTrackingId();
    selectAllShown();
    actionsMenu.selectOption(AllOrdersAction.ADD_TO_ROUTE.getName());
    addToRouteDialog.waitUntilVisible();
    List<String> actualTrackingId = addToRouteDialog.trackingIds.stream().map(PageElement::getText)
        .collect(Collectors.toList());

    Assertions.assertThat(actualTrackingId).as("Expected Tracking ID not found.").has(
        new Condition<>(l -> l.containsAll(listOfExpectedTrackingId), "Has Expected tracking id"));

    addToRouteDialog.setToAll.click();
    if (StringUtils.isNotBlank(routeId)) {
      addToRouteDialog.routeInputs.get(0).setValue(routeId);
    } else if (StringUtils.isNotBlank(tag)) {
      addToRouteDialog.routeFinder.click();
      addToRouteDialog.routeTags.get(0).selectValues(ImmutableList.of(tag));
      addToRouteDialog.suggestRoutes.clickAndWaitUntilDone();
    }
  }

  public void fillRouteSuggestionUsingSetToAll(String type, String tag) {
    clearFilterTableOrderByTrackingId();
    selectAllShown();
    actionsMenu.selectOption(AllOrdersAction.ADD_TO_ROUTE.getName());
    addToRouteDialog.waitUntilVisible();
    addToRouteDialog.setToAll.click();
    addToRouteDialog.types.get(0).selectValue(type);
    addToRouteDialog.routeFinder.click();
    addToRouteDialog.routeTags.get(0).selectValues(ImmutableList.of(tag));
    addToRouteDialog.suggestRoutes.clickAndWaitUntilDone();
  }

  public void fillRouteSuggestion(List<AddToRouteData> data) {
    clearFilterTableOrderByTrackingId();
    selectAllShown();
    actionsMenu.selectOption(AllOrdersAction.ADD_TO_ROUTE.getName());
    addToRouteDialog.waitUntilVisible();
    Map<String, AddToRouteData> dataAsMap = data.stream()
        .collect(Collectors.toMap(AddToRouteData::getTrackingId, val -> val));
    for (int i = 0; i < data.size(); i++) {
      String trackingId = addToRouteDialog.trackingIds.get(i).getText();
      String type = dataAsMap.get(trackingId).getType();
      if (StringUtils.isNotBlank(type)) {
        addToRouteDialog.types.get(i).selectValue(dataAsMap.get(trackingId).getType());
      }
    }
    addToRouteDialog.routeFinder.click();
    for (int i = 0; i < data.size(); i++) {
      String trackingId = addToRouteDialog.trackingIds.get(i).getText();
      addToRouteDialog.routeTags.get(i)
          .selectValues(ImmutableList.of(dataAsMap.get(trackingId).getTag()));
    }
    addToRouteDialog.suggestRoutes.clickAndWaitUntilDone();
  }

  public void printWaybill(String trackingId) {
    filterTableOrderByTrackingId(trackingId);
    clickActionButtonOnTable(1, ACTION_BUTTON_PRINT_WAYBILL_ON_TABLE_ORDER);
    waitUntilVisibilityOfToast("Attempting to print waybill(s)");
//    waitUntilInvisibilityOfToast("Downloading", true);
  }

  public void verifyWaybillContentsIsCorrect(Order order) {
    editOrderPage.verifyAirwayBillContentsIsCorrect(order);
  }

  public void verifiesTrackingIdIsCorrect(String trackingId) {
    String actualTrackingId = getText(
        "//div[@id='header']//label[text()='Tracking ID']/following-sibling::h3");
    Assertions.assertThat(trackingId).as("Tracking ID is Not the same: ")
        .isEqualTo(actualTrackingId);
  }

  public void specificSearch(Category category, SearchLogic searchLogic, String searchTerm) {
    String mainWindowHandle = getWebDriver().getWindowHandle();
    waitUntilPageLoaded();

    categorySelect.selectValue(category.getValue());
    searchLogicSelect.selectValue(searchLogic.getValue());
    try {
      this.searchTerm.selectValue(searchTerm);
      waitUntilNewWindowOrTabOpened();
    } catch (NoSuchElementException ex) {
      search.click();
    }

    pause100ms();
    getWebDriver().switchTo().window(
        mainWindowHandle); // Force selenium to go back to the last active tab/window if new tab/window is opened.
  }

  public void specificSearch(Category category, SearchLogic searchLogic, String searchTerm,
      String trackingId) {
    String mainWindowHandle = getWebDriver().getWindowHandle();
    waitUntilPageLoaded();

    selectValueFromMdSelectByIdContains("category", category.getValue());
    selectValueFromMdSelectByIdContains("search-logic", searchLogic.getValue());
    sendKeys("//input[starts-with(@id, 'fl-input') or starts-with(@id, 'searchTerm')]", searchTerm);
    pause3s(); // Wait until the page finished matching the tracking ID.
    String matchedTrackingIdXpathExpression = String.format(
        "//li[@md-virtual-repeat='item in $mdAutocompleteCtrl.matches']/md-autocomplete-parent-scope//span[text()='%s']",
        trackingId);
    String searchButtonXpathExpression = "//nv-api-text-button[@name='commons.search']";

    if (isElementExistFast(matchedTrackingIdXpathExpression)) {
      click(matchedTrackingIdXpathExpression);
      waitUntilNewWindowOrTabOpened();
    } else {
      click(searchButtonXpathExpression);
    }

    pause100ms();
    getWebDriver().switchTo().window(
        mainWindowHandle); // Force selenium to go back to the last active tab/window if new tab/window is opened.
    waitUntilInvisibilityOfElementLocated(
        searchButtonXpathExpression + "/button/div[contains(@class,'show')]/md-progress-circular");
  }

  public void filterTableOrderByTrackingId(String trackingId) {
    searchTableCustom1("tracking-id", trackingId);
  }

  public void clearFilterTableOrderByTrackingId() {
    clearSearchTableCustom1("tracking-id");
  }

  public void switchToEditOrderWindow(Long orderId) {
    switchToOtherWindow("order/" + orderId);
    editOrderPage.waitWhilePageIsLoading(120);
  }

  public String getTextOnTableOrder(int rowNumber, String columnDataClass) {
    return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass,
        MD_VIRTUAL_REPEAT_TABLE_ORDER);
  }

  public void clickActionButtonOnTable(int rowNumber, String actionButtonName) {
    clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName,
        MD_VIRTUAL_REPEAT_TABLE_ORDER);
  }

  public enum AllOrdersAction {
    SET_RTS_TO_SELECTED("Set RTS to Selected"), CANCEL_SELECTED("Cancel Selected"), RESUME_SELECTED(
        "Resume Selected"), MANUALLY_COMPLETE_SELECTED(
        "Manually Complete Selected"), PULL_FROM_ROUTE("Pull Selected from Route"), ADD_TO_ROUTE(
        "Add Selected to Route"), REGULAR_PICKUP("Regular Pickup");

    private final String name;

    public String getName() {
      return name;
    }

    AllOrdersAction(String name) {
      this.name = name;
    }
  }

  public void verifyLatestEvent(Order order, String latestEvent) {
    String mainWindowHandle = getWebDriver().getWindowHandle();
    Long orderId = order.getId();
    String trackingId = order.getTrackingId();
    specificSearch(Category.TRACKING_OR_STAMP_ID, SearchLogic.EXACTLY_MATCHES, trackingId);

    try {
      switchToEditOrderWindow(orderId);
      String xpath = "//label[text()='Latest Event']/following-sibling::h3";
      String actualLatestEvent = getText(xpath);
      Assertions.assertThat(actualLatestEvent.toLowerCase()).as("Latest Event is not the same")
          .isEqualTo(latestEvent.toLowerCase());
    } finally {
      closeAllWindows(mainWindowHandle);
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

  public static class ManuallyCompleteOrderDialog extends MdDialog {

    @FindBy(name = "container.order.edit.complete-order")
    public NvApiTextButton completeOrder;

    @FindBy(name = "commons.mark-all")
    public NvIconTextButton markAll;

    @FindBy(name = "commons.unmark-all")
    public NvIconTextButton unmarkAll;

    @FindBy(xpath = ".//tr[@ng-repeat='order in ctrl.ordersWithCod']/td[1]")
    public List<PageElement> trackingIds;

    @FindBy(xpath = ".//tr[@ng-repeat='order in ctrl.ordersWithCod']/td[2]//md-checkbox")
    public List<MdCheckbox> codCheckboxes;

    @FindBy(css = "[id^='container.order.edit.reasons']")
    public MdSelect changeReason;

    @FindBy(css = "[id^='container.order.edit.input-reason-for-change']")
    public TextBox reasonForChange;

    public ManuallyCompleteOrderDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class ErrorsDialog extends MdDialog {

    @FindBy(name = "Close")
    public NvIconTextButton close;

    @FindBy(xpath = ".//div[@ng-repeat='error in ctrl.payload.errors track by $index']")
    public List<PageElement> errorMessage;

    @FindBy(css = "[ng-click='ctrl.payload.errorDescription.onClick()']")
    public PageElement downloadFailedUpdates;

    public ErrorsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class PullSelectedFromRouteDialog extends MdDialog {

    @FindBy(name = "container.order.edit.pull-orders-from-routes")
    public NvApiTextButton pullOrdersFromRoutes;

    @FindBy(xpath = "//nv-icon-text-button[@name='Close']")
    public NvIconTextButton close;

    @FindBy(xpath = "//div[@ng-repeat='error in ctrl.payload.errors track by $index']")
    public List<PageElement> errors;

    public PullSelectedFromRouteDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class ResumeSelectedDialog extends MdDialog {

    @FindBy(xpath = ".//tr[@ng-repeat='order in ctrl.orders']/td")
    public List<PageElement> trackingIds;

    @FindBy(name = "container.order.edit.resume-order")
    public NvApiTextButton resumeOrder;

    @FindBy(name = "container.order.edit.resume-orders")
    public NvApiTextButton resumeOrders;

    public ResumeSelectedDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class CancelSelectedDialog extends MdDialog {

    @FindBy(xpath = ".//tr[@ng-repeat='order in ctrl.orders']/td[1]")
    public List<PageElement> trackingIds;

    @FindBy(css = "[id^='container.order.edit.cancellation-reason']")
    public TextBox cancellationReason;

    @FindBy(name = "container.order.edit.cancel-order")
    public NvApiTextButton cancelOrder;

    @FindBy(name = "container.order.edit.cancel-orders")
    public NvApiTextButton cancelOrders;

    public CancelSelectedDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class AddToRouteDialog extends MdDialog {

    @FindBy(name = "container.order.edit.set-to-all")
    public NvIconTextButton setToAll;

    @FindBy(name = "container.order.edit.route-finder")
    public NvIconTextButton routeFinder;

    @FindBy(name = "commons.close")
    public NvIconTextButton close;

    @FindBy(name = "container.order.edit.suggest-routes")
    public NvApiTextButton suggestRoutes;

    @FindBy(css = "div[md-virtual-repeat='order in ctrl.formData.orders'] > div.table-tracking-id")
    public List<PageElement> trackingIds;

    @FindBy(css = "div[md-virtual-repeat='order in ctrl.formData.orders']  md-select[name^='commons.type']")
    public List<MdSelect> types;

    @FindBy(css = "div[md-virtual-repeat='order in ctrl.formData.orders']  input[name^='container.order.edit.route']")
    public List<TextBox> routeInputs;

    @FindBy(css = "div[md-virtual-repeat='order in ctrl.formData.orders']  div.table-edit-route>span")
    public List<PageElement> routeTexts;

    @FindBy(css = "div[md-virtual-repeat='order in ctrl.formData.orders']  md-select[name^='container.order.edit.route-tags']")
    public List<MdSelect> routeTags;

    @FindBy(name = "container.order.edit.add-selected-to-routes")
    public NvApiTextButton addSelectedToRoutes;

    public AddToRouteDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public List<String> getRouteIds() {
      List<String> routeIds = routeInputs.stream().map(TextBox::getValue)
          .collect(Collectors.toList());
      routeIds.addAll(
          routeTexts.stream().map(PageElement::getNormalizedText).collect(Collectors.toList()));
      return routeIds;
    }

    public String getRouteId(String trackingId) {
      int size = trackingIds.size();
      List<String> routeIds = getRouteIds();
      for (int i = 0; i < size; i++) {
        String nextTrackingId = trackingIds.get(i).getText();
        if (StringUtils.equals(trackingId, nextTrackingId)) {
          return routeIds.get(i);
        }
      }
      throw new AssertionError(f("Tracking Id [%s] was not found", trackingId));
    }

  }

  public static class SavePresetDialog extends MdDialog {

    @FindBy(css = "div[ng-repeat='filter in selectedFilters']")
    public List<PageElement> selectedFilters;

    @FindBy(css = "[id^='container.route-logs.preset-name']")
    public TextBox presetName;

    @FindBy(css = "div.help-text")
    public PageElement helpText;

    @FindBy(css = "i.input-confirmed")
    public PageElement confirmedIcon;

    @FindBy(name = "commons.cancel")
    public NvIconTextButton cancel;

    @FindBy(name = "commons.save")
    public NvIconTextButton save;

    @FindBy(name = "commons.update")
    public NvIconTextButton update;

    public SavePresetDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class DeletePresetDialog extends MdDialog {

    @FindBy(css = "[id^='container.route-logs.select-preset']")
    public MdSelect preset;

    @FindBy(css = "[translate='commons.preset.confirm-delete-x']")
    public PageElement message;

    @FindBy(name = "commons.cancel")
    public NvIconTextButton cancel;

    @FindBy(name = "commons.delete")
    public NvIconTextButton delete;

    public DeletePresetDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  @FindBy(css = "button[aria-label*='Profile']")
  public PageElement profile;

  @FindBy(css = "button[aria-label='Settings']")
  public PageElement settings;

  @FindBy(xpath = "//div[contains(@class,'nv-h4')]")
  public List<PageElement> settingsHeader;

  public void navigateToSettingsPage() {
    getWebDriver().get(TestConstants.OPERATOR_PORTAL_BASE_URL);
    waitUntilElementIsClickable(profile.getWebElement());
    profile.click();
    settings.click();
    Assert.assertTrue("Assert that the settings page has loaded", settingsHeader.size() > 0);
  }

  public void clearAllSelectionsAndLoadSelection() {
    pause3s();
    String xpathClearAllSelection = "//div[contains(text(),'Clear All Selections')]/parent::button";
    moveToElementWithXpath(xpathClearAllSelection);
    click(xpathClearAllSelection);
    pause2s();
    click("//div[contains(text(),'Load Selection')]/parent::button");
  }

  public void applyAction(String trackingId) {
    filterTableOrderByTrackingId(trackingId);
    selectAllShown();
    ((JavascriptExecutor) getWebDriver()).executeScript("document.body.style.zoom='70%'");
    ((JavascriptExecutor) getWebDriver()).executeScript("arguments[0].click();",
        findElementByXpath("//button[@aria-label = 'Action']"));
    pause2s();
    ((JavascriptExecutor) getWebDriver()).executeScript("arguments[0].click();",
        findElementByXpath("//button[@aria-label = 'Regular Pickup']"));
    pause2s();
    ((JavascriptExecutor) getWebDriver()).executeScript("arguments[0].click();",
        findElementByXpath("//button[@aria-label = 'Submit']"));
    ((JavascriptExecutor) getWebDriver()).executeScript("document.body.style.zoom='100%'");
  }

  public void verifyDownloadedCsv(String trackingId, String message) {
    String downloadedFile = getLatestDownloadedFilename("pickup_reservations");
    verifyFileDownloadedSuccessfully(downloadedFile);
    String pathName = StandardTestConstants.TEMP_DIR + downloadedFile;
    List<RegularPickup> reg = DataEntity.fromCsvFile(RegularPickup.class, pathName, true);
    Assertions.assertThat(reg.get(0).getTrackingId().equalsIgnoreCase(trackingId)).isTrue();
    Assertions.assertThat(reg.get(0).getErrorMessage().contains(message)).isTrue();
  }

  public static class SelectionErrorDialog extends MdDialog {

    @FindBy(xpath = ".//tr[@ng-repeat='row in ctrl.ordersValidationErrorData.errors']/td[1]")
    public List<PageElement> trackingIds;

    @FindBy(xpath = ".//tr[@ng-repeat='row in ctrl.ordersValidationErrorData.errors']/td[2]")
    public List<PageElement> reasons;

    @FindBy(xpath = ".//div[./label[.='Process']]/p")
    public PageElement process;

    @FindBy(css = "[ng-click='ctrl.downloadTrackingIds()']")
    public PageElement downloadInvalidSelection;

    @FindBy(name = "commons.continue")
    public NvIconTextButton continueBtn;

    public SelectionErrorDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public void choosePickupActionAndClickSubmit(String trackingId, String action, String date) {
    LocalDateTime today = LocalDateTime.now();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH);
    filterTableOrderByTrackingId(trackingId);
    selectAllShown();
    ((JavascriptExecutor) getWebDriver()).executeScript("document.body.style.zoom='70%'");
    ((JavascriptExecutor) getWebDriver()).executeScript("arguments[0].click();",
        findElementByXpath("//button[@aria-label = 'Action']"));
    pause2s();
    ((JavascriptExecutor) getWebDriver()).executeScript("arguments[0].click();",
        findElementByXpath("//button[@aria-label = 'Early Pickup']"));
    pause2s();
    if ("Return To Sender".equalsIgnoreCase(action)) {
      ((JavascriptExecutor) getWebDriver()).executeScript("arguments[0].click();",
          findElementByXpath("//md-radio-button[@aria-label='Return To Sender']"));
      pause2s();
    }
    ((JavascriptExecutor) getWebDriver()).executeScript("arguments[0].click();",
        findElementByXpath("//button[@aria-label = 'Submit']"));
    pause2s();
    if ("date".equalsIgnoreCase(date)) {
      getWebDriver().findElement(By.xpath("//input[contains(@class,'datepicker-input')]")).clear();
      pause1s();
      getWebDriver().findElement(By.xpath("//input[contains(@class,'datepicker-input')]"))
          .sendKeys(formatter.format(today.plusDays(5)));
      pause2s();
    }
    ((JavascriptExecutor) getWebDriver()).executeScript("arguments[0].click();",
        findElementByXpath("//button[@aria-label = 'Submit']"));
    ((JavascriptExecutor) getWebDriver()).executeScript("document.body.style.zoom='100%'");
  }

  public void verifyCustomerDeliveryAddress(Order order, String address1, String address2) {
    Assertions.assertThat(address1).as("Delivery Address1 is correct: ")
        .isEqualTo(order.getToAddress1().trim());
    Assertions.assertThat(address2).as("Delivery Address2 is correct: ")
        .isEqualTo(order.getToAddress2().trim());
  }

  public void verifyDeliveryAddressIsRts(Order order) {
    Assertions.assertThat(order.getToAddress1()).as("Delivery Address1 is correct: ")
        .isEqualTo(order.getFromAddress1());
    Assertions.assertThat(order.getToAddress2()).as("Delivery Address2 is correct: ")
        .isEqualTo(order.getFromAddress2());
  }

  public void verifyDriverCollect(DatabaseCheckingDriverCollectOrder dbCheckingDriverCollectOrder,
      String trackingId) {
    LocalDateTime today = LocalDateTime.now();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH);

    Assertions.assertThat(trackingId).as("Barcode is different : ")
        .isEqualTo(dbCheckingDriverCollectOrder.getBarcode());
    Assertions.assertThat("RELEASED").as("DP Reservation Status is not the same : ")
        .isEqualTo(dbCheckingDriverCollectOrder.getRsvnStatus());
    Assertions.assertThat("DRIVER_COLLECTED").as("DP Reservation Event Name is not the same : ")
        .isEqualTo(dbCheckingDriverCollectOrder.getRsvnEventName());
    Assertions.assertThat("COMPLETED").as("DP Job Status is not the same : ")
        .isEqualTo(dbCheckingDriverCollectOrder.getJobStatus());
    Assertions.assertThat("SUCCESS").as("DP Job Order Status is not the same : ")
        .isEqualTo(dbCheckingDriverCollectOrder.getJobOrderStatus());
    Assertions.assertThat("DRIVER").as("Released To is not the same : ")
        .isEqualTo(dbCheckingDriverCollectOrder.getReleasedTo());
    assertTrue("Released At is not the same : ",
        dbCheckingDriverCollectOrder.getReleasedAt().toString()
            .startsWith(formatter.format(today)));
  }

  public void verifyOrderStatus(Order order, String status, String granularStatus) {
    assertTrue("Status is not correct", order.getStatus().equalsIgnoreCase(status));
    assertTrue("Granular Status is not correct: ",
        order.getGranularStatus().equalsIgnoreCase(granularStatus));
  }

  public void databaseVerifyCustomerCollect(
      DatabaseCheckingCustomerCollectOrder dbCheckingCustomerCollectOrder, String trackingId) {
    LocalDateTime today = LocalDateTime.now();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH);

    Assertions.assertThat(trackingId).as("Barcode is different : ")
        .isEqualTo(dbCheckingCustomerCollectOrder.getBarcode());
    Assertions.assertThat("CUSTOMER").as("Released To is not the same : ")
        .isEqualTo(dbCheckingCustomerCollectOrder.getReleasedTo());
    Assertions.assertThat("DP_RELEASED_TO_CUSTOMER").as("Reservation Event Name is not correct: ")
        .isEqualTo(dbCheckingCustomerCollectOrder.getRsvnEventName());
    assertTrue("Released At is not the same : ",
        dbCheckingCustomerCollectOrder.getReleasedAt().toString()
            .startsWith(formatter.format(today)));
    assertTrue("Collected At is not the same : ",
        dbCheckingCustomerCollectOrder.getCollectedAt().toString()
            .startsWith(formatter.format(today)));
    Assertions.assertThat("RELEASED").as("Status is not the same : ")
        .isEqualTo(dbCheckingCustomerCollectOrder.getStatus());
    Assertions.assertThat("OPERATOR").as("Source is not the same : ")
        .isEqualTo(dbCheckingCustomerCollectOrder.getSource());
  }

  public static class PrintWaybillsDialog extends MdDialog {

    @FindBy(css = "md-checkbox")
    public MdCheckbox checkbox;

    @FindBy(name = "container.order.list.download-selected")
    public NvIconTextButton downloadSelected;

    @FindBy(id = "select-printing-size")
    public PageElement PrintingSizeBox;

    @FindBy(xpath = "//div[contains(@class,'md-select-menu-container') and @aria-hidden='false']")
    public PageElement PrintSizeList;

    String PRINTING_SIZE = "//div[contains(@class,'md-select-menu-container') and @aria-hidden='false']//div[@class='md-text' and contains(text(),'%s')]";

    public PrintWaybillsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public void SelectPrintSize(String size) {
      PrintSizeList.waitUntilVisible();
      findElementByXpath(f(PRINTING_SIZE, size)).click();
      PrintSizeList.waitUntilInvisible();
    }
  }

  public static class OrdersTable extends MdVirtualRepeatTable<OrderInfo> {

    public OrdersTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("trackingId", "tracking-id")
          .put("fromName", "from-name")
          .put("fromContact", "from-contact")
          .put("fromAddress", "_from-address")
          .put("fromPostcode", "from-postcode")
          .put("toName", "to-name")
          .put("toContact", "to-contact")
          .put("toAddress", "_to-address")
          .put("toPostcode", "to-postcode")
          .put("granularStatus", "_granular-status")
          .put("createdAt", "_created-at")
          .build()
      );
      setMdVirtualRepeat("order in getTableData()");
      setEntityClass(OrderInfo.class);
//      setActionButtonsLocators(ImmutableMap.of(ACTION_DETAILS, "commons.details", ACTION_PRINT,
//          "container.bulk-order.print-label"));
    }

    public static class OrderInfo extends DataEntity<OrderInfo> {

      private String trackingId;
      private String fromName;
      private String fromContact;
      private String fromAddress;
      private String fromPostcode;
      private String toName;
      private String toContact;
      private String toAddress;
      private String toPostcode;
      private String granularStatus;
      private String createdAt;

      public OrderInfo(Map<String, ?> data) {
        super(data);
      }

      public OrderInfo() {
      }

      public String getTrackingId() {
        return trackingId;
      }

      public void setTrackingId(String trackingId) {
        this.trackingId = trackingId;
      }

      public String getFromName() {
        return fromName;
      }

      public void setFromName(String fromName) {
        this.fromName = fromName;
      }

      public String getFromContact() {
        return fromContact;
      }

      public void setFromContact(String fromContact) {
        this.fromContact = fromContact;
      }

      public String getFromAddress() {
        return fromAddress;
      }

      public void setFromAddress(String fromAddress) {
        this.fromAddress = fromAddress;
      }

      public String getFromPostcode() {
        return fromPostcode;
      }

      public void setFromPostcode(String fromPostcode) {
        this.fromPostcode = fromPostcode;
      }

      public String getToName() {
        return toName;
      }

      public void setToName(String toName) {
        this.toName = toName;
      }

      public String getToContact() {
        return toContact;
      }

      public void setToContact(String toContact) {
        this.toContact = toContact;
      }

      public String getToAddress() {
        return toAddress;
      }

      public void setToAddress(String toAddress) {
        this.toAddress = toAddress;
      }

      public String getToPostcode() {
        return toPostcode;
      }

      public void setToPostcode(String toPostcode) {
        this.toPostcode = toPostcode;
      }

      public String getGranularStatus() {
        return granularStatus;
      }

      public void setGranularStatus(String granularStatus) {
        this.granularStatus = granularStatus;
      }

      public String getCreatedAt() {
        return createdAt;
      }

      public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
      }
    }
  }
}