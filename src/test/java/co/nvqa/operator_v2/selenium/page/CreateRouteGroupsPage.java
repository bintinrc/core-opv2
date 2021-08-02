package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.TxnRsvn;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdMenu;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.AbstractFilterBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiIconButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterBooleanBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterDateBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterFreeTextBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterTimeBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.function.Consumer;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static co.nvqa.operator_v2.selenium.page.CreateRouteGroupsPage.TxnRsvnTable.COLUMN_TRACKING_ID;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class CreateRouteGroupsPage extends OperatorV2SimplePage {

  private static final SimpleDateFormat DATE_FILTER_SDF_2 = new SimpleDateFormat("yyyy-MM-dd");
  private static final SimpleDateFormat DATE_FILTER_HOUR = new SimpleDateFormat("HH");
  private static final String XPATH_GENERAL_FILTERS = "//div[@possible-filters='ctrl.possibleGeneralFilters']";
  private static final String XPATH_TRANSACTION_FILTERS = "//div[@possible-filters='ctrl.possibleTxnFilters']";
  private static final String XPATH_FILTER_BY_TITLE = "//div[@class='filter-container'][.//div[contains(@class,'main-title')]/p[.='%s']]";

  private final Map<String, Consumer<String>> filterSetters;
  public TxnRsvnTable txnRsvnTable;

  //region General Filters
  @FindBy(xpath = "//nv-filter-date-box[.//p[.='Start Datetime']]")
  public NvFilterDateBox startDateTimeFilter;

  @FindBy(xpath = "//nv-filter-date-box[.//p[.='End Datetime']]")
  public NvFilterDateBox endDateTimeFilter;

  @FindBy(css = "nv-filter-time-box[main-title='Creation Time']")
  public NvFilterTimeBox creationTimeFilter;

  @FindBy(css = "nv-filter-autocomplete[item-types='Shipper']")
  public NvFilterAutocomplete shipperFilter;

  @FindBy(css = "nv-filter-box[item-types='DP Order']")
  public NvFilterBox dpOrderFilter;

  @FindBy(css = "nv-filter-box[item-types='Route Grouping']")
  public NvFilterBox routeGroupingFilter;

  @FindBy(css = "nv-filter-boolean-box[main-title='Routed']")
  public NvFilterBooleanBox routedFilter;

  @FindBy(css = "nv-filter-box[item-types='Master Shipper']")
  public NvFilterBox masterShipperFilter;
  //endregion

  @FindBy(css = "[id^='route-group']")
  public MdSelect routeGroup;

  @FindBy(name = "Add Transactions/Reservations")
  public NvButtonSave addTransactionReservation;

  @FindBy(name = "container.transactions.add-to-route-group")
  public NvIconTextButton addToRouteGroup;

  @FindBy(css = "md-dialog")
  public AddToRouteGroupDialog addToRouteGroupDialog;

  @FindBy(name = "commons.load-selection")
  public NvApiTextButton loadSelection;

  @FindBy(css = "nv-autocomplete[placeholder='filter.select-filter']")
  public NvAutocomplete addFilter;

  @FindBy(xpath = "//button[.='Include Transactions']")
  public Button includeTransactions;

  @FindBy(xpath = "//button[.='Hide Transactions']")
  public Button hideTransactions;

  @FindBy(css = "div[possible-filters='ctrl.possibleTxnFilters']")
  public TransactionsFiltersForm transactionsFiltersForm;

  @FindBy(xpath = "//button[.='Include Reservations']")
  public Button includeReservations;

  @FindBy(xpath = "//button[.='Hide Reservations']")
  public Button hideReservations;

  @FindBy(css = "div[possible-filters='ctrl.possibleRxnFilters']")
  public ReservationFiltersForm reservationFiltersForm;

  @FindBy(xpath = "//button[.='Include Shipments']")
  public Button includeShipments;

  @FindBy(xpath = "//button[.='Hide Shipments']")
  public Button hideShipments;

  @FindBy(css = "div.filter-box-container[possible-filters='ctrl.possibleShipmentFilters']")
  public ShipmentFiltersForm shipmentFiltersForm;

  @FindBy(css = "div[possible-filters='ctrl.possibleGeneralFilters']")
  public GeneralFiltersForm generalFiltersForm;

  @FindBy(name = "Download CSV File")
  public NvApiIconButton downloadCsvFile;

  @FindBy(xpath = "(//md-menu[contains(.,'Preset Actions')])[1]")
  public MdMenu presetActions;

  @FindBy(xpath = "(//md-menu[contains(.,'Preset Actions')])[2]")
  public MdMenu shippersPresetActions;

  @FindBy(css = "md-dialog")
  public AllOrdersPage.SavePresetDialog savePresetDialog;

  @FindBy(css = "md-dialog")
  public AllOrdersPage.DeletePresetDialog deletePresetDialog;

  @FindBy(css = "[id^='commons.preset.load-filter-preset']")
  public MdSelect filterPreset;

  @FindBy(xpath = "(//*[contains(@id,'commons.preset.load-filter-preset')])[2]")
  public MdSelect shippersFilterPreset;

  public Map<String, AbstractFilterBox> filters;

  public CreateRouteGroupsPage(WebDriver webDriver) {
    super(webDriver);
    filterSetters = ImmutableMap.<String, Consumer<String>>builder()
        .put("RTS", value -> setSwitchFilter(XPATH_TRANSACTION_FILTERS, "RTS", value))
        .put("Routed", value -> setSwitchFilter(XPATH_GENERAL_FILTERS, "Routed", value))
        .put("Creation Time", this::setCreationTimeFilter)
        .put("Route Grouping", routeGroupingFilter::selectFilter)
        .put("Shipper", shipperFilter::selectFilter)
        .put("DP Order", value -> dpOrderFilter.selectFilter(value))
        .build();
    txnRsvnTable = new TxnRsvnTable(webDriver);
    filters = ImmutableMap.<String, AbstractFilterBox>builder()
        .put("Start Datetime", startDateTimeFilter)
        .put("End Datetime", endDateTimeFilter)
        .put("Creation Time", creationTimeFilter)
        .put("Shipper", shipperFilter)
        .put("DP Order", dpOrderFilter)
        .put("Route Grouping", routeGroupingFilter)
        .put("Routed", routedFilter)
        .build();
  }

  public void waitUntilRouteGroupPageIsLoaded() {
    waitUntilInvisibilityOfElementLocated(
        "//div[contains(@class,'message') and text()='Loading...']");
  }

  public void waitUntilPageLoaded() {
    super.waitUntilPageLoaded();
    if (halfCircleSpinner.waitUntilVisible(1)) {
      halfCircleSpinner.waitUntilInvisible(60);
    }
  }

  public void setCreationTimeFilter() {
    creationTimeFilter.selectToDate(TestUtils.getNextDate(1));
    creationTimeFilter.selectToHours("23");
    creationTimeFilter.selectToMinutes("30");
    creationTimeFilter.selectFromHours("00");
    creationTimeFilter.selectToMinutes("00");
  }

  public void setCreationTimeFilter(String dates) {
    String fromDateStr;
    String toDateStr;
    String fromHours = "00";
    String fromMinutes = "00";

    if (StringUtils.equalsIgnoreCase("today", dates)) {
      fromDateStr = DATE_FILTER_SDF_2.format(new Date());
      toDateStr = fromDateStr;
    } else if (StringUtils.equalsIgnoreCase("current hour", dates)) {
      Date date = new Date();
      fromDateStr = DATE_FILTER_SDF_2.format(date);
      toDateStr = fromDateStr;
      fromHours = DATE_FILTER_HOUR.format(date);
    } else {
      String[] datesStr = dates.split(";");
      fromDateStr = StringUtils.normalizeSpace(datesStr[0]);
      toDateStr = StringUtils.normalizeSpace(datesStr[1]);
    }

        /*
          Set fromHour & fromMinute of Creation Time.
         */
    creationTimeFilter.selectFromDate(fromDateStr);
    creationTimeFilter.selectFromHours(fromHours);
    creationTimeFilter.selectFromMinutes(fromMinutes);

        /*
          Set toHour & toMinute of Creation Time.
         */
    creationTimeFilter.selectToDate(toDateStr);
    creationTimeFilter.selectToHours("23");
    creationTimeFilter.selectToMinutes("30");
  }

  public void removeFilter(String filterName) {
    AbstractFilterBox filter = filters.get(filterName);
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
    clickf("//div[@model='ctrl.includeTxnModel']//button[@aria-label='%s']", value);
  }

  public void selectReservationFiltersMode(String value) {
    clickf("//div[@model='ctrl.includeRxnModel']//button[@aria-label='%s']", value);
  }

  public void addGeneralFilters(Map<String, String> data) {
    data.forEach((filter, value) ->
    {
      AbstractFilterBox filterBox = filters.get(filter);
      if (!filterBox.isDisplayedFast()) {
        addFilter.selectValue(filter);
      }
      filterSetters.get(filter).accept(value);
    });
  }

  public void setSwitchFilter(String blockXpath, String filter, String value) {
    clickf(blockXpath + XPATH_FILTER_BY_TITLE + "//button[@aria-label='%s']", filter, value);
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
  public static class TxnRsvnTable extends MdVirtualRepeatTable<TxnRsvn> {

    public static final String MD_VIRTUAL_REPEAT = "trvn in getTableData()";
    public static final String COLUMN_ID = "id";
    public static final String COLUMN_TRACKING_ID = "trackingId";
    public static final String COLUMN_TYPE = "type";

    public TxnRsvnTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("sequence", "sequence")
          .put(COLUMN_ID, "id")
          .put("orderId", "order-id")
          .put("waypointId", "waypoint-id")
          .put(COLUMN_TRACKING_ID, "tracking-id")
          .put(COLUMN_TYPE, "type")
          .put("shipper", "shipper")
          .put("address", "address")
          .put("routeId", "route-id")
          .put("status", "status")
          .put("startDateTime", "start-date-time")
          .put("endDateTime", "end-date-time")
          .put("dp", "dp")
          .put("pickupSize", "pickup-size")
          .put("comments", "comments")
          .build()
      );
      setEntityClass(TxnRsvn.class);
      setMdVirtualRepeat(MD_VIRTUAL_REPEAT);
    }
  }

  public static class AddToRouteGroupDialog extends MdDialog {

    @FindBy(css = "button[aria-label='Existing Route Group']")
    public Button existingRouteGroup;

    @FindBy(css = "button[aria-label='Create New Route Group']")
    public Button createNewRouteGroup;

    @FindBy(css = "[id^='route-group']")
    public MdSelect routeGroup;

    @FindBy(css = "input[type='text']")
    public TextBox newRouteGroup;

    @FindBy(name = "Add Transactions/Reservations")
    public NvButtonSave addTransactionsReservations;

    public AddToRouteGroupDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class ReservationFiltersForm extends PageElement {

    @FindBy(css = "nv-autocomplete[placeholder='filter.select-filter']")
    public NvAutocomplete addFilter;

    @FindBy(css = "nv-filter-box[item-types='Pick Up Size']")
    public NvFilterBox pickUpSizeFilter;

    @FindBy(css = "nv-filter-box[item-types='Reservation Type']")
    public NvFilterBox reservationTypeFilter;

    @FindBy(css = "nv-filter-box[item-types='Reservation Status']")
    public NvFilterBox reservationStatusFilter;

    public ReservationFiltersForm(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class TransactionsFiltersForm extends PageElement {

    @FindBy(css = "nv-autocomplete[placeholder='filter.select-filter']")
    public NvAutocomplete addFilter;

    @FindBy(css = "nv-filter-box[item-types='Granular Order Status']")
    public NvFilterBox granularOrderStatusFilter;

    @FindBy(css = "nv-filter-box[item-types='Order Service Type']")
    public NvFilterBox orderServiceTypeFilter;

    @FindBy(css = "nv-filter-box[item-types='Zone']")
    public NvFilterBox zoneFilter;

    @FindBy(css = "nv-filter-box[item-types='Order Type']")
    public NvFilterBox orderTypeFilter;

    @FindBy(css = "nv-filter-box[item-types='PP/DD Leg']")
    public NvFilterBox ppDdLegFilter;

    @FindBy(css = "nv-filter-box[item-types='Transaction Status']")
    public NvFilterBox transactionStatusFilter;

    @FindBy(css = "nv-filter-boolean-box[main-title='RTS']")
    public NvFilterBooleanBox rtsFilter;

    @FindBy(css = "nv-filter-box[item-types='Parcel Size']")
    public NvFilterBox parcelSizeFilter;

    @FindBy(css = "nv-filter-box[item-types='Timeslots']")
    public NvFilterBox timeslotsFilter;

    @FindBy(css = "nv-filter-box[item-types='Delivery Type']")
    public NvFilterBox deliveryTypeFilter;

    @FindBy(css = "nv-filter-box[item-types='DNR Group']")
    public NvFilterBox dnrGroupFilter;

    @FindBy(css = "nv-filter-box[item-types='Bulky Types']")
    public NvFilterBox bulkyTypesFilter;

    public TransactionsFiltersForm(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class ShipmentFiltersForm extends PageElement {

    @FindBy(css = "nv-autocomplete[placeholder='filter.select-filter']")
    public NvAutocomplete addFilter;

    @FindBy(css = "nv-filter-time-box[main-title='Shipment Date']")
    public NvFilterTimeBox shipmentDateFilter;

    @FindBy(css = "nv-filter-time-box[main-title='ETA (Date Time)']")
    public NvFilterTimeBox etaDateTimeFilter;

    @FindBy(css = "nv-filter-box[item-types='End Hub']")
    public NvFilterBox endHubFilter;

    @FindBy(css = "nv-filter-box[item-types='Last Inbound Hub']")
    public NvFilterBox lastInboundHubFilter;

    @FindBy(css = "nv-filter-free-text-box[main-title='MAWB']")
    public NvFilterFreeTextBox mawbFilter;

    @FindBy(css = "nv-filter-time-box[main-title='Shipment Completion Date Time']")
    public NvFilterTimeBox shipmentCompletionDateTimeFilter;

    @FindBy(css = "nv-filter-box[item-types='Shipment Status']")
    public NvFilterBox shipmentStatusFilter;

    @FindBy(css = "nv-filter-box[item-types='Shipment Type']")
    public NvFilterBox shipmentTypeFilter;

    @FindBy(css = "nv-filter-box[item-types='Start Hub']")
    public NvFilterBox startHubFilter;

    @FindBy(css = "nv-filter-time-box[main-title='Transit Date Time']")
    public NvFilterTimeBox transitDateTimeFilter;

    public ShipmentFiltersForm(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class GeneralFiltersForm extends PageElement {

    @FindBy(css = "nv-autocomplete[placeholder='filter.select-filter']")
    public NvAutocomplete addFilter;

    @FindBy(xpath = "//nv-filter-date-box[.//p[.='Start Datetime']]")
    public NvFilterDateBox startDateTimeFilter;

    @FindBy(xpath = "//nv-filter-date-box[.//p[.='End Datetime']]")
    public NvFilterDateBox endDateTimeFilter;

    @FindBy(css = "nv-filter-time-box[main-title='Creation Time']")
    public NvFilterTimeBox creationTimeFilter;

    @FindBy(css = "nv-filter-autocomplete[item-types='Shipper']")
    public NvFilterAutocomplete shipperFilter;

    @FindBy(css = "nv-filter-box[item-types='DP Order']")
    public NvFilterBox dpOrderFilter;

    @FindBy(css = "nv-filter-box[item-types='Route Grouping']")
    public NvFilterBox routeGroupingFilter;

    @FindBy(css = "nv-filter-boolean-box[main-title='Routed']")
    public NvFilterBooleanBox routedFilter;

    @FindBy(css = "nv-filter-box[item-types='Master Shipper']")
    public NvFilterBox masterShipperFilter;

    public GeneralFiltersForm(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
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
}
