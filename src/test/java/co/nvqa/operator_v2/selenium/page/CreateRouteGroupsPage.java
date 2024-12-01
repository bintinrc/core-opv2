package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.TxnRsvn;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntAbstractFilterBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntDateRangePicker2;
import co.nvqa.operator_v2.selenium.elements.ant.AntDateTimeRangePicker;
import co.nvqa.operator_v2.selenium.elements.ant.AntDecimalFilterNumberBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntFilterFreeTextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntFilterSelect3;
import co.nvqa.operator_v2.selenium.elements.ant.AntFilterSwitch;
import co.nvqa.operator_v2.selenium.elements.ant.AntIntFilterNumberBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntMenu;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.selenium.elements.ant.AntSwitch;
import co.nvqa.operator_v2.selenium.elements.ant.AntTableV2;
import co.nvqa.operator_v2.selenium.elements.md.MdMenu;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterTimeBox;
import com.google.common.collect.ImmutableMap;
import java.time.ZonedDateTime;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;

import static co.nvqa.operator_v2.selenium.page.CreateRouteGroupsPage.TxnRsvnTable.COLUMN_TRACKING_ID;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class CreateRouteGroupsPage extends SimpleReactPage<CreateRouteGroupsPage> {

  public TxnRsvnTable txnRsvnTable;

  //region General Filters
  @FindBy(css = "nv-filter-time-box[main-title='Creation Time']")
  public NvFilterTimeBox creationTimeFilter;

  @FindBy(css = "nv-filter-autocomplete[item-types='Shipper']")
  public NvFilterAutocomplete shipperFilter;

  //endregion

  @FindBy(css = "[id^='route-group']")
  public MdSelect routeGroup;

  @FindBy(name = "Add Transactions/Reservations")
  public NvButtonSave addTransactionReservation;

  @FindBy(css = "button[data-pa-label='Add To Route Group']")
  public Button addToRouteGroup;

  @FindBy(css = ".ant-modal")
  public AddToRouteGroupDialog addToRouteGroupDialog;

  @FindBy(css = "button[data-pa-label='Load Selection']")
  public Button loadSelection;

  @FindBy(css = "button[data-pa-label='Edit Filters & Sort']")
  public Button editFilter;

  @FindBy(css = "nv-autocomplete[placeholder='filter.select-filter']")
  public NvAutocomplete addFilter;

  @FindBy(xpath = "//div[contains(@class,'ant-card')][.//span[.='General Filters']]")
  public GeneralFiltersForm generalFiltersForm;

  @FindBy(xpath = "//div[contains(@class,'ant-card')][.//span[.='Transaction Filters']]")
  public TransactionsFiltersForm transactionsFiltersForm;

  @FindBy(xpath = "//div[contains(@class,'ant-card')][.//span[.='Reservation Filters']]")
  public ReservationFiltersForm reservationFiltersForm;

  @FindBy(xpath = "//div[contains(@class,'ant-card')][.//span[.='Shipment Filters']]")
  public ShipmentFiltersForm shipmentFiltersForm;

  @FindBy(css = "button[data-pa-label='Download CSV']")
  public Button downloadCsvFile;

  @FindBy(xpath = "//button[normalize-space(.)='Preset Actions']")
  public AntMenu presetActions;

  @FindBy(xpath = "(//md-menu[contains(.,'Preset Actions')])[2]")
  public MdMenu shippersPresetActions;

  @FindBy(css = ".ant-modal")
  public SavePresetDialog savePresetDialog;

  @FindBy(css = ".ant-modal")
  public DeletePresetDialog deletePresetDialog;

  @FindBy(xpath = "//div[./label[.='Load Filter Preset']]//div[contains(@class,'ant-select')]")
  public AntSelect3 filterPreset;

  @FindBy(xpath = "(//*[contains(@id,'commons.preset.load-filter-preset')])[2]")
  public MdSelect shippersFilterPreset;

  public Map<String, AntAbstractFilterBox> filters;

  public CreateRouteGroupsPage(WebDriver webDriver) {
    super(webDriver);

    txnRsvnTable = new TxnRsvnTable(webDriver);
    filters = ImmutableMap.<String, AntAbstractFilterBox>builder()
        .put("Start Datetime", generalFiltersForm.startDateTimeFilter)
        .put("End Datetime", generalFiltersForm.endDateTimeFilter)
        .put("Creation Time", generalFiltersForm.creationTimeFilter)
        .put("Shipper", generalFiltersForm.shipperFilter)
        .put("Master Shipper", generalFiltersForm.masterShipperFilter)
        .put("DP Order", generalFiltersForm.dpOrderFilter)
        .put("Route Grouping", generalFiltersForm.routeGroupingFilter)
        .put("Routed", generalFiltersForm.routedFilter)
        .put("Service Level", generalFiltersForm.serviceLevelFilter)
        .put("Excluded Shipper", generalFiltersForm.excludedShipperFilter)
        .put("Hub Inbound Datetime", generalFiltersForm.hubInboundDatetimeFilter)
        .put("Hub Inbound User", generalFiltersForm.hubInboundUserFilter)
        .put("Orig Trxn End Time", generalFiltersForm.originalTransactionEndTimeFilter)
        .build();
  }

  public void waitUntilPageLoaded() {
    super.waitUntilPageLoaded();
    if (halfCircleSpinner.waitUntilVisible(1)) {
      halfCircleSpinner.waitUntilInvisible(60);
    }
  }

  public void setCreationTimeFilter() {
    creationTimeFilter.selectToDate(Date.from(ZonedDateTime.now().plusDays(1).toInstant()));
    creationTimeFilter.selectToHours("23");
    creationTimeFilter.selectToMinutes("30");
    creationTimeFilter.selectFromHours("00");
    creationTimeFilter.selectToMinutes("00");
  }

  public void removeFilter(String filterName) {
    AntAbstractFilterBox filter = filters.get(filterName);
    if (filter != null) {
      filter.removeFilter();
    }
  }

  public void removeAllFilterExceptGiven(List<String> filters) {
    this.filters.forEach((name, filter) ->
    {
      if (!filters.contains(name) && filter.isDisplayedFast()) {
        filter.removeFilter();
      }
    });
  }

  public void selectTransactionFiltersMode(String value) {
    transactionsFiltersForm.includeTransactions.setValue(
        value.toLowerCase(Locale.ROOT).contains("include"));
  }

  public void selectReservationFiltersMode(String value) {
    reservationFiltersForm.includeReservations.setValue(
        value.toLowerCase(Locale.ROOT).contains("include"));
  }

  public void selectShipmentsFiltersMode(String value) {
    shipmentFiltersForm.includeShipments.setValue(
        value.toLowerCase(Locale.ROOT).contains("include"));
  }

  public void searchByTrackingId(String trackingId) {
    txnRsvnTable.filterByColumn(COLUMN_TRACKING_ID, trackingId);
  }

  public void selectRouteGroupOnAddToRouteGroupDialog(String routeGroupName) {
    routeGroup.searchAndSelectValue(routeGroupName);
  }

  public void clickAddTransactionsOnAddToRouteGroupDialog() {
    addTransactionReservation.clickAndWaitUntilDone();
    waitUntilInvisibilityOfToast("Added successfully");
  }

  /**
   * Accessor for Transaction/Reservation table
   */
  public static class TxnRsvnTable extends AntTableV2<TxnRsvn> {

    public static final String MD_VIRTUAL_REPEAT = "trvn in getTableData()";
    public static final String COLUMN_ID = "id";
    public static final String COLUMN_TRACKING_ID = "trackingId";
    public static final String COLUMN_ORDER_ID = "orderId";
    public static final String COLUMN_TYPE = "type";

    public TxnRsvnTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("sequence", "__index__")
          .put(COLUMN_ID, "id")
          .put(COLUMN_ORDER_ID, "orderId")
          .put("waypointId", "waypointId")
          .put(COLUMN_TRACKING_ID, "trackingId")
          .put(COLUMN_TYPE, "type")
          .put("shipper", "shipperName")
          .put("address", "address")
          .put("routeId", "routeId")
          .put("status", "status")
          .put("startDateTime", "startTime")
          .put("endDateTime", "endTime")
          .put("dp", "dpName")
          .put("pickupSize", "pickupSize")
          .put("comments", "comment")
          .build()
      );
      setEntityClass(TxnRsvn.class);
    }
  }

  public static class AddToRouteGroupDialog extends AntModal {

    @FindBy(id = "rc-tabs-0-tab-EXISTING_ROUTE_GROUP")
    public Button existingRouteGroup;

    @FindBy(id = "rc-tabs-0-tab-NEW_ROUTE_GROUP")
    public Button createNewRouteGroup;

    @FindBy(css = "div.ant-select")
    public AntSelect3 routeGroup;

    @FindBy(css = "input[data-testid='new-route-group-input']")
    public TextBox newRouteGroup;

    @FindBy(css = "button[data-pa-label='Add Transactions/Reservations/PA Jobs']")
    public Button addTransactionsReservations;

    public AddToRouteGroupDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class GeneralFiltersForm extends PageElement {

    @FindBy(xpath = ".//div[text()='Add Filter']//div[contains(@class,'ant-select')]")
    public AntSelect3 addFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Start Datetime')]]")
    public AntDateRangePicker2 startDateTimeFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'End Datetime')]]")
    public AntDateRangePicker2 endDateTimeFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Creation Time')]]")
    public AntDateTimeRangePicker creationTimeFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Shipper')]]")
    public AntFilterSelect3 shipperFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'DP Order')]]")
    public AntFilterSelect3 dpOrderFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Route Grouping')]]")
    public AntFilterSelect3 routeGroupingFilter;

    @FindBy(xpath = "..//div[contains(@class,'FilterContainer')][.//div[contains(.,'Routed')]]")
    public AntFilterSwitch routedFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Master Shipper')]]")
    public AntFilterSelect3 masterShipperFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Service Level')]]")
    public AntFilterSelect3 serviceLevelFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Excluded Shipper')]]")
    public AntFilterSelect3 excludedShipperFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Hub Inbound User')]]")
    public AntFilterSelect3 hubInboundUserFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Hub Inbound Datetime')]]")
    public AntDateTimeRangePicker hubInboundDatetimeFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Original Transaction End Time')]]")
    public AntDateTimeRangePicker originalTransactionEndTimeFilter;

    public void addFilter(String filterName) {
      addFilter.selectValue(filterName);
      Actions actions = new Actions(getWebDriver());
      actions.click(addFilter.searchInput.getWebElement()).sendKeys(Keys.ESCAPE).perform();
    }

    public GeneralFiltersForm(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class TransactionsFiltersForm extends PageElement {

    @FindBy(xpath = ".//div[text()='Add Filter']//div[contains(@class,'ant-select')]")
    public AntSelect3 addFilter;

    @FindBy(css = "button[role='switch']")
    public AntSwitch includeTransactions;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Granular Order Status')]]")
    public AntFilterSelect3 granularOrderStatusFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Order Service Type')]]")
    public AntFilterSelect3 orderServiceTypeFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Zone')]]")
    public AntFilterSelect3 zoneFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Order Type')]]")
    public AntFilterSelect3 orderTypeFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'PP/DD Leg')]]")
    public AntFilterSelect3 ppDdLegFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Transaction Status')]]")
    public AntFilterSelect3 transactionStatusFilter;

    @FindBy(xpath = ".//div[./label[.='RTS']]")
    public AntFilterSwitch rtsFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Parcel Size')]]")
    public AntFilterSelect3 parcelSizeFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Timeslots')]]")
    public AntFilterSelect3 timeslotsFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Delivery Type')]]")
    public AntFilterSelect3 deliveryTypeFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'DNR Group')]]")
    public AntFilterSelect3 dnrGroupFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Weight')]]")
    public AntDecimalFilterNumberBox weightFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Priority Level')]]")
    public AntIntFilterNumberBox priorityLevelFilter;

    public void addFilter(String filterName) {
      addFilter.selectValue(filterName);
      Actions actions = new Actions(getWebDriver());
      actions.click(addFilter.searchInput.getWebElement()).sendKeys(Keys.ESCAPE).perform();
    }

    public TransactionsFiltersForm(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class ReservationFiltersForm extends PageElement {

    @FindBy(xpath = ".//div[text()='Add Filter']//div[contains(@class,'ant-select')]")
    public AntSelect3 addFilter;

    @FindBy(css = "button[role='switch']")
    public AntSwitch includeReservations;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Pick Up Size')]]")
    public AntFilterSelect3 pickUpSizeFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Reservation Type')]]")
    public AntFilterSelect3 reservationTypeFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Reservation Status')]]")
    public AntFilterSelect3 reservationStatusFilter;

    public ReservationFiltersForm(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class ShipmentFiltersForm extends PageElement {

    @FindBy(xpath = ".//div[text()='Add Filter']//div[contains(@class,'ant-select')]")
    public AntSelect3 addFilter;

    @FindBy(css = "button[role='switch']")
    public AntSwitch includeShipments;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Shipment Date')]]")
    public AntDateTimeRangePicker shipmentDateFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'ETA (Date Time)')]]")
    public AntDateRangePicker2 etaDateTimeFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'End Hub')]]")
    public AntFilterSelect3 endHubFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Last Inbound Hub')]]")
    public AntFilterSelect3 lastInboundHubFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'MAWB')]]")
    public AntFilterFreeTextBox mawbFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Shipment Completion Date Time')]]")
    public AntDateRangePicker2 shipmentCompletionDateTimeFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Shipment Status')]]")
    public AntFilterSelect3 shipmentStatusFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Shipment Type')]]")
    public AntFilterSelect3 shipmentTypeFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Start Hub')]]")
    public AntFilterSelect3 startHubFilter;

    @FindBy(xpath = ".//div[contains(@class,'FilterContainer')][.//div[contains(.,'Transit Date Time')]]")
    public AntDateTimeRangePicker transitDateTimeFilter;

    public ShipmentFiltersForm(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class DeletePresetDialog extends AntModal {

    @FindBy(css = "div.ant-select")
    public AntSelect3 preset;

    @FindBy(xpath = ".//div[./div/*[@height]]/div[2]")
    public PageElement message;

    @FindBy(css = "button[data-pa-label='Cancel']")
    public Button cancel;

    @FindBy(css = "button[data-pa-label='Delete']")
    public Button delete;

    public DeletePresetDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class SavePresetDialog extends AntModal {

    @FindBy(xpath = "(.//div[contains(@class,'FilterPresetSaveDialogue')])[2]/div")
    public List<PageElement> selectedFilters;

    @FindBy(css = "input[placeholder='Enter preset name']")
    public TextBox presetName;

    @FindBy(css = "span.ant-typography")
    public PageElement helpText;

    @FindBy(css = "i.input-confirmed")
    public PageElement confirmedIcon;

    @FindBy(css = "button[data-pa-label='Cancel']")
    public Button cancel;

    @FindBy(css = "button[data-pa-label='Save']")
    public Button save;

    @FindBy(css = "button[data-pa-label='Update']")
    public Button update;

    public SavePresetDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}