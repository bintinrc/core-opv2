package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.operator_v2.model.ReservationInfo;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDatepicker;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdMenu;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.md.MdSwitch;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicLong;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.Color;
import org.openqa.selenium.support.FindBy;

import static co.nvqa.operator_v2.selenium.page.ShipperPickupsPage.ReservationsTable.ACTION_BUTTON_DETAILS;
import static co.nvqa.operator_v2.selenium.page.ShipperPickupsPage.ReservationsTable.ACTION_BUTTON_FINISH;
import static co.nvqa.operator_v2.selenium.page.ShipperPickupsPage.ReservationsTable.ACTION_BUTTON_ROUTE_EDIT;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class ShipperPickupsPage extends OperatorV2SimplePage {

  public static final String REFRESH_BUTTON_ARIA_LABEL = "Refresh";

  private static final String CSV_FILENAME = "shipper-pickups.csv";
  private static final String SELECTED_COUNT_LABEL_LOCATOR = "//h5[contains(text(),'Selected:')]";

  private CreateSelectedReservationsDialog createSelectedReservationsDialog;
  private BulkPriorityEditDialog bulkPriorityEditDialog;
  public ReservationsTable reservationsTable;
  public FiltersForm filtersForm;

  public static final String ITEM_DOWNLOAD_CSV_FILE = "Download CSV File";
  public static final String ITEM_CREATE_RESERVATION = "Create Reservation";
  public static final String ITEM_REMOVE_ROUTE = "Remove Route";
  public static final String ITEM_SUGGEST_ROUTE = "Suggest Route";
  public static final String ITEM_EDIT_PRIORITY_LEVEL = "Edit Priority Level";

  @FindBy(css = "md-dialog")
  public ReservationDetailsDialog reservationDetailsDialog;

  @FindBy(css = "md-dialog.shipper-pickups-pod-details-dialog")
  public PodDetailsDialog podDetailsDialog;

  @FindBy(css = "md-dialog")
  public EditRouteDialog editRouteDialog;

  @FindBy(css = "md-dialog")
  public BulkRouteAssignmentDialog bulkRouteAssignmentDialog;

  @FindBy(xpath = "//md-dialog[contains(@class,'shipper-pickups-finish-reservation-dialog')]")
  public FinishReservationDialog finishReservationDialog;

  @FindBy(css = "md-dialog")
  public OperationResultsDialog operationResultsDialog;

  @FindBy(css = "md-dialog")
  public RemoveRouteFromReservationsDialog removeRouteFromReservationsDialog;

  @FindBy(css = "nv-filter-autocomplete[item-types='Shipper']")
  public NvFilterAutocomplete shipperFilter;

  @FindBy(name = "commons.edit-fiters")
  public NvIconTextButton editFilters;

  @FindBy(css = "div.navigation md-menu")
  public MdMenu actionsMenu;

  @FindBy(css = "md-switch[aria-label='Bulk Assign Route']")
  public MdSwitch bulkAssignRoute;

  @FindBy(css = "nv-bulk-route-assignment-side-panel")
  public BulkRouteAssignmentSidePanel bulkRouteAssignmentSidePanel;

  public ShipperPickupsPage(WebDriver webDriver) {
    super(webDriver);
    createSelectedReservationsDialog = new CreateSelectedReservationsDialog(webDriver);
    bulkPriorityEditDialog = new BulkPriorityEditDialog(webDriver);
    reservationsTable = new ReservationsTable(webDriver);
    filtersForm = new FiltersForm(webDriver);
  }

  public BulkRouteAssignmentDialog bulkRouteAssignmentDialog() {
    return bulkRouteAssignmentDialog;
  }

  private static String buildPickupAddress(Address address) {
    return StringUtils.trim(address.getAddress1());
  }

  public void assignReservationToRoute(Address address, Long routeId) {
    assignReservationToRoute(address, routeId, null);
  }

  public void assignReservationToRoute(Address address, Long routeId, Integer priorityLevel) {
    reservationsTable.searchByPickupAddress(address);
    reservationsTable.clickActionButton(1, ACTION_BUTTON_ROUTE_EDIT);
    editRouteDialog.fillTheForm(routeId, priorityLevel);
    editRouteDialog.submitForm();
    pause1s();
  }

  public void verifyReservationInfo(Address address, String shipperName, String routeId,
      String driverName, String priorityLevel, String approxVolume, String comments) {
        /*
          Reload the table to make sure the table info is updated.
         */
    editFilters.click();
    filtersForm.loadSelection.clickAndWaitUntilDone();

    String pickupAddress = null;
    if (address != null) {
      pickupAddress = reservationsTable.searchByPickupAddress(address);
    }
    ReservationInfo actual = reservationsTable.readEntity(1);

    if (comments != null && comments.length() > 255) {
      comments = comments.substring(0, 255) + "...";
    }

    if (address != null) {
      // Remove multiple [SPACE] chars from String value.
      String actualPickupAddress = StringUtils.normalizeSpace(actual.getPickupAddress());
      pickupAddress = StringUtils.normalizeSpace(pickupAddress);
      assertThat("Pickup Address", actualPickupAddress, startsWith(pickupAddress));
    }

    assertThatIfExpectedValueNotBlank("Shipper Name", shipperName, actual.getShipperName(),
        startsWith(shipperName));
    assertEqualsIfExpectedValueNotBlank("Route ID", routeId, actual.getRouteId());
    assertEqualsIfExpectedValueNotBlank("Driver Name", driverName, actual.getDriverName());
    assertEqualsIfExpectedValueNotBlank("Priority Level", priorityLevel, actual.getPriorityLevel());
    assertEqualsIfExpectedValueNotBlank("Approx. Volume", approxVolume, actual.getApproxVolume());
    assertEqualsIfExpectedValueNotBlank("Comments", comments, actual.getComments());
  }

  public void verifyReservationInfo(ReservationInfo expectedReservationInfo, Address address) {
    Date readyDate = expectedReservationInfo.getReadyByDate();
    Date latestDate = expectedReservationInfo.getLatestByDate();

    if (readyDate != null && latestDate != null) {
      editFilters.click();
      filtersForm.filterReservationDate(readyDate, latestDate);
      filtersForm.loadSelection.clickAndWaitUntilDone();
    }

    ReservationInfo actualReservationInfo = readReservationInfo(address);
    expectedReservationInfo
        .compareWithActual(actualReservationInfo, "reservationCreatedTime", "serviceTime");
    assertDateIsEqualIfExpectedValueNotNullOrBlank("Reservation Created Time",
        expectedReservationInfo.getReservationCreatedTime(),
        actualReservationInfo.getReservationCreatedTime());
    assertDateIsEqualIfExpectedValueNotNullOrBlank("Service Time",
        expectedReservationInfo.getServiceTime(), actualReservationInfo.getServiceTime());
  }

  private void assertDateIsEqualIfExpectedValueNotNullOrBlank(String message, String expected,
      String actual) {
    if (StringUtils.isNotBlank(expected)) {
      if (actual == null) {
        actual = "";
      }

      actual = actual.split(" ")[0];
      expected = expected.split(" ")[0];
      assertEquals(message, expected, actual);
    }
  }

  public void verifyReservationsInfo(List<ReservationInfo> expectedReservationsInfo,
      List<Address> addresses) {
    for (int i = 0; i < addresses.size(); i++) {
      verifyReservationInfo(expectedReservationsInfo.get(i), addresses.get(i));
    }
  }

  public void verifyReservationDetails(Address address, String shipperName, String shipperId,
      String reservationId) {
    String pickupAddress = reservationsTable.searchByPickupAddress(address);
    reservationsTable.clickActionButton(1, ACTION_BUTTON_DETAILS);
    reservationDetailsDialog.waitUntilVisible();

    assertEquals("Shipper Name", shipperName,
        reservationDetailsDialog.shipperName.getNormalizedText());
    assertEquals("Shipper ID", shipperId, reservationDetailsDialog.shipperId.getNormalizedText());
    assertEquals("Reservation ID", reservationId,
        reservationDetailsDialog.reservationId.getNormalizedText());
    assertThat("Pickup Address", reservationDetailsDialog.pickupAddress.getNormalizedText(),
        startsWith(pickupAddress));
  }

  @SuppressWarnings("unused")
  public ReservationInfo duplicateReservation(Address address, Date date) {
    return duplicateReservations(Collections.singletonList(address), date).get(0);
  }

  public ReservationInfo downloadCsvFile(Address address) {
    return downloadCsvFiles(Collections.singletonList(address)).get(0);
  }

  public List<ReservationInfo> downloadCsvFiles(List<Address> addresses) {
    List<ReservationInfo> reservationsInfo = selectReservationsAndStoreInfo(addresses);
    actionsMenu.selectOption(ITEM_DOWNLOAD_CSV_FILE);
    return reservationsInfo;
  }

  public void verifyCsvFileDownloadedSuccessfully(ReservationInfo reservationInfo) {
    verifyFileDownloadedSuccessfully(CSV_FILENAME, reservationInfo.toCsvLine(), false, true);
  }

  public List<ReservationInfo> duplicateReservations(List<Address> addresses, Date date) {
    List<ReservationInfo> originalReservationsInfo = selectReservationsAndStoreInfo(addresses);
    actionsMenu.selectOption(ITEM_CREATE_RESERVATION);
    createSelectedReservationsDialog.fillTheForm(date);
    createSelectedReservationsDialog.submitForm();
    String toastMessage = addresses.size() == 1 ?
        "1 Reservation(s) Created" :
        "Reservation(s) created successfully";
    waitUntilInvisibilityOfToast(toastMessage, true);
    if (operationResultsDialog.isDisplayedFast()) {
      operationResultsDialog.forceClose();
      operationResultsDialog.waitUntilInvisible();
    }

    return originalReservationsInfo;
  }

  public void editPriorityLevel(Address address, int priorityLevel) {
    editPriorityLevel(Collections.singletonList(address), priorityLevel, false);
  }

  public void editPriorityLevel(List<Address> addresses, int priorityLevel, boolean setToAll) {
    selectReservationsByAddress(addresses);
    actionsMenu.selectOption(ITEM_EDIT_PRIORITY_LEVEL);
    bulkPriorityEditDialog.fillTheForm(priorityLevel, setToAll);
    bulkPriorityEditDialog.submitForm();
  }

  public BulkRouteAssignmentDialog suggestRoute(List<Address> addresses, List<String> routeTags) {
    selectReservationsByAddress(addresses);
    actionsMenu.selectOption(ITEM_SUGGEST_ROUTE);
    bulkRouteAssignmentDialog.waitUntilVisible();
    routeTags.forEach(routeTag -> bulkRouteAssignmentDialog.routeTags.selectValue(routeTag));
    bulkRouteAssignmentDialog.suggest.clickAndWaitUntilDone();
    return bulkRouteAssignmentDialog;
  }

  public void removeRoute(Address addresses) {
    removeRoutes(Collections.singletonList(addresses));
  }

  public void removeRoutes(List<Address> addresses) {
    selectReservationsByAddress(addresses);
    actionsMenu.selectOption(ITEM_REMOVE_ROUTE);
    removeRouteFromReservationsDialog.waitUntilVisible();
    removeRouteFromReservationsDialog.remove.click();
    waitUntilInvisibilityOfToast(f("%d Reservation(s) Pulled Out from Route", addresses.size()));
  }

  public void selectReservationsByAddress(List<Address> addresses) {
    addresses.forEach(address ->
    {
      reservationsTable.searchByPickupAddress(address);
      reservationsTable.selectRow(1);
    });
    verifySelectedCount(addresses.size());
  }

  public List<ReservationInfo> selectReservationsAndStoreInfo(List<Address> addresses) {
    List<ReservationInfo> reservationsInfo = new ArrayList<>();
    addresses.forEach(address ->
    {
      reservationsInfo.add(readReservationInfo(address));
      reservationsTable.selectRow(1);
    });
    verifySelectedCount(addresses.size());
    return reservationsInfo;
  }

  public void verifySelectedCount(int count) {
    assertEquals(getText(SELECTED_COUNT_LABEL_LOCATOR), String.format("Selected: %d", count));
  }

  public ReservationInfo readReservationInfo(Address address) {
    reservationsTable.searchByPickupAddress(address);
    assertFalse("Reservation was not found", reservationsTable.isTableEmpty());
    return reservationsTable.readEntity(1);
  }

  public void clickButtonRefresh() {
    clickNvApiIconButtonByNameAndWaitUntilDone(REFRESH_BUTTON_ARIA_LABEL);
  }

  public void finishReservationWithFailure() {
    reservationsTable.clickActionButton(1, ACTION_BUTTON_FINISH);
    finishReservationDialog.selectFailureAsReason();

    List<String> failureReasons = finishReservationDialog.failureReason.getOptions();
    int randomFailureReasonIndex = (int) (Math.random() * 7);
    finishReservationDialog.selectFailureReason(failureReasons.get(randomFailureReasonIndex));

    int detailsCount;
    do {
      detailsCount = finishReservationDialog.failureReasonDetail.size();
      finishReservationDialog.selectFailureReasonDetail(detailsCount - 1);
    } while (finishReservationDialog.failureReasonDetail.size() > detailsCount);

    finishReservationDialog.clickOnUpdateButton();
    finishReservationDialog.proceedWithFailureInConfirmationPopUp();
  }

  public void finishReservationWithSuccess() {
    reservationsTable.clickActionButton(1, ACTION_BUTTON_FINISH);
    finishReservationDialog.selectSuccessAsReason();
    finishReservationDialog.proceedWithSuccessInConfirmationPopUp();
  }

  public void verifyFinishedReservationHighlighted(String color) {
    assertEquals("Expected another background color for finished reservation with failure",
        color,
        reservationsTable.getNotDefaultBackgroundColorOfRow(1));
  }

  public void verifyFinishedReservationHasStatus(String status) {
    assertEquals("Reservation status",
        status,
        reservationsTable.getTextOnTable(1, ReservationsTable.COLUMN_RESERVATION_STATUS_CLASS));
  }

  /**
   * Accessor for Reservation Details dialog
   */
  public static class ReservationDetailsDialog extends MdDialog {

    @FindBy(css = "#field-shipper-name > div")
    public PageElement shipperName;

    @FindBy(css = "#field-shipper-id > div")
    public PageElement shipperId;

    @FindBy(css = "#field-reservation-id > div")
    public PageElement reservationId;

    @FindBy(css = "#field-pickup-address > div")
    public PageElement pickupAddress;

    @FindBy(xpath = ".//div[normalize-space(.)='POD not found']")
    public PageElement podNotFound;

    @FindBy(css = "#field-timestamp > div")
    public PageElement timestamp;

    @FindBy(css = "#field-keyin-by-driver > div")
    public PageElement inputOnPod;

    @FindBy(css = "#field-scanned-at-shipper > div")
    public PageElement scannedAtShipperCount;

    @FindBy(css = ".pod-table-content:nth-of-type(1) .content-row")
    public PageElement scannedAtShipperPOD;

    @FindBy(name = "container.shipper-pickups.dialog.view-pod")
    public NvIconTextButton viewPod;

    @FindBy(name = "commons.download-csv")
    public NvIconTextButton downloadCsvFile;

    @FindBy(css = "nv-tag")
    public PageElement podName;

    public ReservationDetailsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  /**
   * Accessor for Create Reservation dialog
   */
  public static class CreateSelectedReservationsDialog extends OperatorV2SimplePage {

    private static final String DIALOG_LOCATOR = "//md-dialog[contains(@class,'reservation-reschedule-selected')]";
    private static final String FIELD_DATE_ID = "commons.model.date";
    private static final String BUTTON_SUBMIT_ARIA_LABEL = "Recreate";

    public CreateSelectedReservationsDialog(WebDriver webDriver) {
      super(webDriver);
    }

    public void fillTheForm(Date date) {
      waitUntilVisibilityOfElementLocated(DIALOG_LOCATOR);
      setMdDatepickerById(FIELD_DATE_ID, date);
    }

    public void submitForm() {
      clickButtonByAriaLabelAndWaitUntilDone(BUTTON_SUBMIT_ARIA_LABEL);
    }
  }

  /**
   * Accessor for Create Reservation dialog
   */
  public static class EditRouteDialog extends MdDialog {

    @FindBy(css = "nv-autocomplete[selected-item='ctrl.data.selectedRoute']")
    public NvAutocomplete newRoute;

    @FindBy(id = "Priority Level")
    public TextBox priorityLevel;

    @FindBy(name = "commons.save-changes")
    public NvApiTextButton saveChanges;

    @FindBy(name = "container.shipper-pickups.dialog.change-address")
    public NvIconTextButton editAddress;

    @FindBy(id = "commons.address1")
    public TextBox address1;

    @FindBy(id = "commons.address2")
    public TextBox address2;

    @FindBy(id = "commons.postcode")
    public TextBox postcode;

    @FindBy(id = "commons.latitude")
    public TextBox latitude;

    @FindBy(id = "commons.longitude")
    public TextBox longitude;

    public EditRouteDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public void fillTheForm(Long routeId, Integer priorityLevel) {
      waitUntilVisible();
      pause2s();
      assertNotNull("Route ID should not be null.", routeId);

      newRoute.selectValue(routeId);

      if (priorityLevel != null) {
        this.priorityLevel.setValue(priorityLevel);
      }
    }

    public void submitForm() {
      saveChanges.clickAndWaitUntilDone();
      waitUntilInvisible();
    }
  }

  /**
   * Accessor for Bulk Priority Edit dialog
   */
  public static class BulkPriorityEditDialog extends OperatorV2SimplePage {

    private static final String DIALOG_TITLE = "Bulk Priority Edit";
    private static final String FIELD_PRIORITY_LEVEL_MODEL = "data.priorityLevel";
    private static final String BUTTON_SUBMIT_ARIA_LABEL = "Save changes";
    private static final String BUTTON_SET_TO_ALL_ARIA_LABEL = "Set to all";
    private static final String RESERVATIONS_TABLE_NG_REPEAT = "data in ctrl.data.reservations";

    public BulkPriorityEditDialog(WebDriver webDriver) {
      super(webDriver);
    }

    @SuppressWarnings("unused")
    public void fillTheForm(int priorityLevel) {
      fillTheForm(priorityLevel, false);
    }

    public void fillTheForm(int priorityLevel, boolean setToAll) {
      waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
      int rowsCount = 1;

      if (setToAll) {
        clickButtonByAriaLabel(BUTTON_SET_TO_ALL_ARIA_LABEL);
      } else {
        rowsCount = getRowsCountOfTableWithNgRepeat(RESERVATIONS_TABLE_NG_REPEAT);
      }

      for (int index = 1; index <= rowsCount; index++) {
        sendKeysToMdInputContainerOnTableWithNgRepeat(index, FIELD_PRIORITY_LEVEL_MODEL,
            RESERVATIONS_TABLE_NG_REPEAT, String.valueOf(priorityLevel));
      }
    }

    public void submitForm() {
      clickButtonByAriaLabelAndWaitUntilDone(BUTTON_SUBMIT_ARIA_LABEL);
      waitUntilInvisibilityOfMdDialogByTitle(DIALOG_TITLE);
    }
  }

  /**
   * Accessor for Bulk Route Assignment dialog
   */
  public static class BulkRouteAssignmentDialog extends MdDialog {

    @FindBy(css = "nv-autocomplete[search-text='ctrl.view.tagSearchText']")
    public NvAutocomplete routeTags;

    @FindBy(css = "nv-autocomplete[search-text='reservation.serviceSearchText']")
    public List<NvAutocomplete> suggestedRoutes;

    @FindBy(name = "container.shipper-pickups.dialog.suggest")
    public NvApiTextButton suggest;

    @FindBy(name = "commons.save-changes")
    public NvApiTextButton saveChanges;

    public BulkRouteAssignmentDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public String readSuggestedRoute(int index) {
      return suggestedRoutes.get(index - 1).getValue();
    }

    public Route validateSuggestedRoutes(List<Route> validRoutes) {
      Route route = null;
      int rowsCount = suggestedRoutes.size();

      for (int index = 1; index <= rowsCount; index++) {
        route = validateSuggestedRoute(index, validRoutes);
      }

      return route;
    }

    public Route validateSuggestedRoute(int index, List<Route> validRoutes) {
      String suggestedRoute = readSuggestedRoute(index);
      assertThat("Suggested Route", suggestedRoute, not(isEmptyOrNullString()));
      Pattern p = Pattern.compile("(\\d*)(\\s-\\s)(.*)");
      Matcher m = p.matcher(suggestedRoute);
      AtomicLong routeId = new AtomicLong(0);

      if (m.matches()) {
        routeId.set(Long.parseLong(m.group(1)));
      }

      String reason = String.format("[%d] Suggested Route ID", index);
      assertThat(reason, routeId.get(), greaterThan(0L));
      Optional<Route> optRoute = validRoutes.stream()
          .filter(route -> route.getId() == routeId.get()).findFirst();
      reason = String.format("[%d] Suggested route is not valid", index);
      assertTrue(reason, optRoute.isPresent());
      return optRoute.orElse(null);
    }

    public void submitForm() {
      saveChanges.clickAndWaitUntilDone();
      waitUntilInvisible();
    }
  }

  /**
   * Accessor for Reservations table
   */
  public static class ReservationsTable extends MdVirtualRepeatTable<ReservationInfo> {

    private static final String MD_VIRTUAL_REPEAT = "data in getTableData()";
    public static final String COLUMN_RESERVATION_ID = "id";
    public static final String COLUMN_PICKUP_ADDRESS = "pickupAddress";
    public static final String COLUMN_RESERVATION_STATUS = "reservationStatus";
    private static final String COLUMN_RESERVATION_STATUS_CLASS = "status";

    public static final String ACTION_BUTTON_ROUTE_EDIT = "Edit";
    public static final String ACTION_BUTTON_DETAILS = "Details";
    public static final String ACTION_BUTTON_FINISH = "Finish";


    public ReservationsTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_RESERVATION_ID, "id")
          .put("shipperId", "shipper-id")
          .put("shipperName", "name")
          .put(COLUMN_PICKUP_ADDRESS, "pickup-address")
          .put("routeId", "route-id")
          .put("driverName", "driver-name")
          .put("priorityLevel", "priority-level")
          .put("readyBy", "ready-by")
          .put("latestBy", "last-by")
          .put("reservationType", "type")
          .put(COLUMN_RESERVATION_STATUS, COLUMN_RESERVATION_STATUS_CLASS)
          .put("reservationCreatedTime", "created-date")
          .put("serviceTime", "service-time")
          .put("approxVolume", "approx-volume")
          .put("failureReason", "failure-reason")
          .put("comments", "comments")
          .build()
      );
      setActionButtonsLocators(
          ImmutableMap.of(ACTION_BUTTON_ROUTE_EDIT, "container.shipper-pickups.route-edit",
              ACTION_BUTTON_DETAILS, "container.shipper-pickups.details",
              ACTION_BUTTON_FINISH, "Finish"));
      setEntityClass(ReservationInfo.class);
    }

    public String searchByPickupAddress(Address address) {
      String addressValue = buildPickupAddress(address);
      filterByColumn(COLUMN_PICKUP_ADDRESS, addressValue);
      return addressValue;
    }

    public String getNotDefaultBackgroundColorOfRow(int rowNumber) {
      waitUntilVisibilityOfElementLocated(
          f("//tr[@md-virtual-repeat='%s' and not(contains(@class, 'row-default'))][%d]",
              MD_VIRTUAL_REPEAT, rowNumber));
      Color actualPriorityLevelColor = getBackgroundColor(
          f("//tr[@md-virtual-repeat='%s'][%d]", MD_VIRTUAL_REPEAT, rowNumber));
      return actualPriorityLevelColor.asHex();
    }

    public String getBackgroundColorOfRow(int rowNumber) {
      waitUntilVisibilityOfElementLocated(
          f("//tr[@md-virtual-repeat='%s'][%d]", MD_VIRTUAL_REPEAT, rowNumber));
      Color actualPriorityLevelColor = getBackgroundColor(
          f("//tr[@md-virtual-repeat='%s'][%d]", MD_VIRTUAL_REPEAT, rowNumber));
      return actualPriorityLevelColor.asHex();
    }
  }

  /**
   * Accessor for Filters form
   */
  public static class FiltersForm extends OperatorV2SimplePage {

    @FindBy(name = "fromDateField")
    public MdDatepicker fromDateField;

    @FindBy(name = "rsvnDate")
    public MdDatepicker toDateField;

    @FindBy(xpath = "//nv-filter-box[@main-title='Reservation Types']")
    public NvFilterBox reservationTypesFilter;

    @FindBy(xpath = "//nv-filter-autocomplete[@main-title='Shipper']")
    public NvFilterAutocomplete shipperFilter;

    @FindBy(xpath = "//nv-filter-box[@main-title='Master Shipper']")
    public NvFilterBox masterShipperFilter;

    @FindBy(xpath = "//nv-filter-box[@main-title='Waypoint Status']")
    public NvFilterAutocomplete statusFilter;

    @FindBy(xpath = "//nv-filter-box[@main-title='Hubs']")
    public NvFilterBox hubsFilter;

    @FindBy(xpath = "//nv-filter-box[@main-title='Zones']")
    public NvFilterBox zonesFilter;

    @FindBy(name = "Load Selection")
    public NvApiTextButton loadSelection;

    public FiltersForm(WebDriver webDriver) {
      super(webDriver);
    }

    public void filterReservationDate(Date fromDate, Date toDate) {
      toDateField.setDate(toDate); // To Date should be select first.
      fromDateField.setDate(fromDate);
    }

    public void filterByHub(String hub) {
      hubsFilter.clearAll();
      hubsFilter.selectFilter(hub);
    }

    public void filterByZone(String zone) {
      zonesFilter.clearAll();
      zonesFilter.selectFilter(zone);
    }

    public void filterByShipper(String shipperName) {
      shipperFilter.clearAll();
      shipperFilter.selectFilter(shipperName);
    }

    public void filterByMasterShipper(String masterShipperName) {
      masterShipperFilter.clearAll();
      masterShipperFilter.selectFilter(masterShipperName);
    }

    public void filterByType(String reservationType) {
      reservationTypesFilter.clearAll();
      reservationTypesFilter.selectFilter(reservationType);
    }

    public void filterByStatus(String waypointStatus) {
      if (waypointStatus != null) {
        statusFilter.clearAll();
        statusFilter.selectFilter(waypointStatus);
      }
    }
  }

  /**
   * Accessor for Finish reservation dialog
   */
  public static class FinishReservationDialog extends MdDialog {

    @FindBy(name = "commons.failure")
    public NvIconTextButton failure;

    @FindBy(name = "commons.success")
    public NvIconTextButton success;

    @FindBy(xpath = "//md-dialog[contains(@aria-label,'Success Reservation')]")
    public ConfirmFinishReservationDialog successReservationDialog;

    @FindBy(xpath = "//md-dialog[contains(@aria-label,'Fail Reservation')]")
    public ConfirmFinishReservationDialog failReservationDialog;

    @FindBy(css = "[id^='container.shipper-pickups.choose-failure-reason']")
    public MdSelect failureReason;

    @FindBy(css = "[id^='container.shipper-pickups.failure-reason-detail']")
    public List<MdSelect> failureReasonDetail;

    @FindBy(name = "commons.update")
    public NvApiTextButton update;

    public FinishReservationDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public void selectFailureAsReason() {
      waitUntilVisible();
      failure.waitUntilClickable();
      failure.click();
    }

    public void selectSuccessAsReason() {
      waitUntilVisible();
      success.waitUntilClickable();
      success.click();
    }

    public void clickOnUpdateButton() {
      update.clickAndWaitUntilDone();
    }

    public void proceedWithFailureInConfirmationPopUp() {
      failReservationDialog.waitUntilVisible();
      failReservationDialog.proceed.click();
    }

    public void proceedWithSuccessInConfirmationPopUp() {
      successReservationDialog.waitUntilVisible();
      successReservationDialog.proceed.click();
    }

    private void selectFailureReason(String value) {
      failureReason.selectValue(value);
    }

    private void selectFailureReasonDetail(int index, String value) {
      failureReasonDetail.get(index).selectValue(value);
    }

    public void selectFailureReasonDetail(int index) {
      List<String> failureReasonDetailsSecond = failureReasonDetail.get(index).getOptions();
      int randomFailureReasonDetailsIndexSecond = (int) (Math.random() * failureReasonDetailsSecond
          .size());
      selectFailureReasonDetail(index,
          failureReasonDetailsSecond.get(randomFailureReasonDetailsIndexSecond)
              .replace("'", "/'"));
    }

    public static class ConfirmFinishReservationDialog extends MdDialog {

      public ConfirmFinishReservationDialog(WebDriver webDriver, WebElement webElement) {
        super(webDriver, webElement);
      }

      public ConfirmFinishReservationDialog(WebDriver webDriver, SearchContext searchContext,
          WebElement webElement) {
        super(webDriver, searchContext, webElement);
      }

      @FindBy(css = "[aria-label='Proceed']")
      public Button proceed;
    }
  }

  public static class OperationResultsDialog extends MdDialog {

    public OperationResultsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

  }

  public static class RemoveRouteFromReservationsDialog extends MdDialog {

    @FindBy(name = "commons.remove")
    public NvIconTextButton remove;

    public RemoveRouteFromReservationsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class BulkRouteAssignmentSidePanel extends PageElement {

    @FindBy(css = "div.list-description")
    public PageElement description;

    @FindBy(css = "div[md-virtual-repeat='item in cards']")
    public List<ReservationCard> reservationCards;

    @FindBy(css = "nv-autocomplete[selected-item='selectedRoute']")
    public NvAutocomplete route;

    @FindBy(name = "Bulk Assign")
    public NvApiTextButton bulkAssign;

    public BulkRouteAssignmentSidePanel(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public static class ReservationCard extends PageElement {

      @FindBy(css = "p.title")
      public PageElement title;

      @FindBy(css = "p.description")
      public PageElement description;

      @FindBy(css = "p.subtitle")
      public PageElement subtitle;

      @FindBy(css = "div.close-icon")
      public PageElement closeIcon;

      public ReservationCard(WebDriver webDriver, SearchContext searchContext,
          WebElement webElement) {
        super(webDriver, searchContext, webElement);
      }
    }
  }

  public static class PodDetailsDialog extends MdDialog {

    @FindBy(css = "#field-reservation-id > div")
    public PageElement reservationId;

    @FindBy(css = "#field-receipient-name > div")
    public PageElement recipientName;

    @FindBy(css = "#field-shipper-id > div")
    public PageElement shipperId;

    @FindBy(css = "#field-shipper-name > div")
    public PageElement shipperName;

    @FindBy(css = "#field-shipper-contact > div")
    public PageElement shipperContact;

    @FindBy(xpath = ".//md-input-container[./label[.='Status']]/div")
    public PageElement status;

    public PodDetailsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}