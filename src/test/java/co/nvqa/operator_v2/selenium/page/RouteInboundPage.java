package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.CollectionSummary;
import co.nvqa.operator_v2.model.ExpectedScans;
import co.nvqa.operator_v2.model.MoneyCollection;
import co.nvqa.operator_v2.model.MoneyCollectionCollectedOrderEntry;
import co.nvqa.operator_v2.model.MoneyCollectionHistoryEntry;
import co.nvqa.operator_v2.model.WaypointOrderInfo;
import co.nvqa.operator_v2.model.WaypointPerformance;
import co.nvqa.operator_v2.model.WaypointReservationInfo;
import co.nvqa.operator_v2.model.WaypointScanInfo;
import co.nvqa.operator_v2.model.WaypointShipperInfo;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdCheckbox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import org.junit.Assert;
import org.junit.platform.commons.util.StringUtils;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static co.nvqa.operator_v2.selenium.page.RouteInboundPage.ShippersTable.VIEW_ORDERS;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteInboundPage extends OperatorV2SimplePage {

  private ShippersTable shippersTable;
  private ReservationsTable reservationsTable;
  private OrdersTable ordersTable;
  public WaypointScansTable waypointScansTable;
  private MoneyCollectionDialog moneyCollectionDialog;

  @FindBy(css = "md-progress-linear")
  public PageElement progressBar;

  @FindBy(css = "md-dialog")
  public RouteInboundCommentsDialog routeInboundCommentsDialog;

  @FindBy(css = "md-dialog")
  public PhotoAuditDialog photoAuditDialog;

  @FindBy(css = "md-dialog")
  public MoneyCollectionHistoryDialog moneyCollectionHistoryDialog;

  @FindBy(xpath = "//md-dialog[.//h2[.='Choose a route']]")
  public ChooseRouteDialog chooseRouteDialog;

  @FindBy(css = "md-dialog")
  public ReservationPickupsDialog reservationPickupsDialog;

  @FindBy(name = "Cancel")
  public NvIconButton closeDialog;

  @FindBy(xpath = "//nv-autocomplete[@search-text='ctrl.hubSelection.searchText']")
  public NvAutocomplete selectHub;

  @FindBy(id = "route-id")
  public TextBox routeIdInput;

  @FindBy(xpath = "//md-card[.//label[.='Enter the route ID']]//nv-api-text-button[@name='container.route-inbound.continue']")
  public NvApiTextButton routeIdContinue;

  @FindBy(id = "tracking-id")
  public TextBox trackingIdInput;

  @FindBy(xpath = "//md-card[.//label[.='Scan a tracking ID']]//nv-api-text-button[@name='container.route-inbound.continue']")
  public NvApiTextButton trackingIdContinue;

  @FindBy(xpath = "//nv-autocomplete[@search-text='ctrl.driverSearch.searchText']")
  public NvAutocomplete selectDriver;

  @FindBy(xpath = "//md-card[.//label[.='Search by driver']]//nv-api-text-button[@name='container.route-inbound.continue']")
  public NvApiTextButton selectDriverContinue;

  @FindBy(xpath = "//div[contains(@class, 'big-button')][contains(@ng-click,'WAYPOINT_PENDING')]")
  public BigButton pendingButton;

  @FindBy(xpath = "//div[contains(@class, 'big-button')][contains(@ng-click,'WAYPOINT_PARTIAL')]")
  public BigButton partialButton;

  @FindBy(xpath = "//div[contains(@class, 'big-button')][contains(@ng-click,'WAYPOINT_FAILED')]")
  public BigButton failedButton;

  @FindBy(xpath = "//div[contains(@class, 'big-button')][contains(@ng-click,'COLLECT_FAILED')]")
  public BigButton failedParcels;

  @FindBy(xpath = "//div[contains(@class, 'big-button')][contains(@ng-click,'COLLECT_C2C_AND_RETURN')]")
  public BigButton c2cReturn;

  @FindBy(xpath = "//div[contains(@class, 'big-button')][contains(@ng-click,'DETAILS_TYPE.RESERVATIONS)')]")
  public BigButton reservationsBigButton;

  @FindBy(xpath = "//div[contains(@class, 'big-button')][contains(@ng-click,'WAYPOINT_SUCCESS')]")
  public BigButton successButton;

  @FindBy(xpath = "//div[contains(@class, 'big-button')][contains(@ng-click,'WAYPOINT_TOTAL')]")
  public BigButton totalButton;

  @FindBy(xpath = "//div[contains(@class, 'big-button')][@ng-click='ctrl.viewMoneyCollection($event)']")
  public BigButton cashButton;

  @FindBy(xpath = "//div[./div[.=' Pending Deliveries ']]//div[@class='count-over-total']")
  public PageElement pendingDeliveries;

  @FindBy(xpath = "//div[./div[.=' Parcels Processed ']]//div[@class='count-over-total']")
  public PageElement parcelProcessed;

  @FindBy(xpath = "//div[./div[.=' Failed Deliveries (Valid) ']]//div[@class='count-over-total']")
  public PageElement failedDeliveriesValid;

  @FindBy(xpath = "//div[./div[.=' Failed Deliveries (Invalid) ']]//div[@class='count-over-total']")
  public PageElement failedDeliveriesInvalid;

  @FindBy(xpath = "//div[./div[.=' C2C / Return Pickups ']]//div[@class='count-over-total']")
  public PageElement c2cReturnPickups;

  @FindBy(xpath = "//div[./div[.=' Reservation Pickups ']]//div[@class='count-over-total']")
  public PageElement reservationPickups;

  @FindBy(xpath = "//app-route-inbound-summary//div[./label[.='Route Id']]//span")
  public PageElement routeId;

  @FindBy(xpath = "//app-route-inbound-summary//div[./label[.='Driver']]//span")
  public PageElement driver;

  @FindBy(xpath = "//app-route-inbound-summary//div[./label[.='Hub']]//span")
  public PageElement hub;

  @FindBy(xpath = "//app-route-inbound-summary//div[./label[.='Date']]//span")
  public PageElement date;

  @FindBy(css = "md-dialog")
  public DriverAttendanceDialog driverAttendanceDialog;

  @FindBy(css = "a[ng-click='ctrl.routeInboundComments($event)']")
  public PageElement routeInboundComments;

  @FindBy(css = "div[ng-if='ctrl.hasComments()']")
  public PageElement routeLastComment;

  @FindBy(name = "commons.go-back")
  public NvIconTextButton goBack;

  @FindBy(name = "container.route-inbound.continue-to-inbound")
  public NvIconTextButton continueToInbound;

  @FindBy(id = "end-session")
  public NvApiTextButton endSession;

  @FindBy(css = "[aria-label='Remove route from driver app']")
  public MdCheckbox removeRouteFromDriverApp;

  public RouteInboundPage(WebDriver webDriver) {
    super(webDriver);
    shippersTable = new ShippersTable(webDriver);
    reservationsTable = new ReservationsTable(webDriver);
    ordersTable = new OrdersTable(webDriver);
    moneyCollectionDialog = new MoneyCollectionDialog(webDriver);
    waypointScansTable = new WaypointScansTable(webDriver);
  }

  public void fetchRouteByRouteId(String hubName, Long routeId) {
    waitUntilInvisibilityOfToast(false);
    selectHub.selectValue(hubName);
    routeIdInput.setValue(routeId);
    routeIdContinue.click();
    if (isElementVisible("//div[@class='toast-message']", 2)) {
      return;
    }
    dismissDriverAttendanceDialog();
    routeIdContinue.waitUntilDone();
  }

  private void dismissDriverAttendanceDialog() {
    if (driverAttendanceDialog.waitUntilVisible(3)) {
      pause500ms();
      driverAttendanceDialog.yes.click();
      driverAttendanceDialog.waitUntilInvisible();
    }
  }

  public void fetchRouteByTrackingId(String hubName, String trackingId, Long routeId) {
    waitUntilInvisibilityOfToast(false);
    selectHub.selectValue(hubName);
    trackingIdInput.setValue(trackingId);
    trackingIdContinue.click();
    if (routeId != null) {
      selectRoute(routeId);
    }
    if (isElementVisible("//div[@class='toast-message']", 1)) {
      return;
    }
    dismissDriverAttendanceDialog();
    trackingIdContinue.waitUntilDone();
  }

  public void fetchRouteByDriver(String hubName, String driverName, Long routeId) {
    waitUntilInvisibilityOfToast(false);
    selectHub.selectValue(hubName);
    selectDriver.selectValue(driverName);
    if (routeId != null) {
      selectRoute(routeId);
    }
    if (isElementVisible("//div[@class='toast-message']", 1)) {
      return;
    }
    dismissDriverAttendanceDialog();
    selectDriverContinue.waitUntilDone();
  }

  public void selectRoute(Long routeId) {
    if (chooseRouteDialog.waitUntilVisible(5)) {
      chooseRouteDialog.chooseRoute(routeId);
      chooseRouteDialog.waitUntilInvisible();
    }
  }

  public void verifyRouteSummaryInfoIsCorrect(long expectedRouteId, String expectedDriverName,
      String expectedHubName, Date expectedRouteDate,
      WaypointPerformance expectedWaypointPerformance,
      CollectionSummary expectedCollectionSummary) {
    assertEquals("Route ID", String.valueOf(expectedRouteId), routeId.getText());
    assertEquals("Driver Name", expectedDriverName.replaceAll(" ", ""),
        driver.getText().replaceAll(" ", ""));
    assertEquals("Hub Name", expectedHubName, hub.getText());
    assertEquals("Route Date", YYYY_MM_DD_SDF.format(expectedRouteDate), date.getText());

    assertEquals("Waypoint Performance - Pending",
        String.valueOf(expectedWaypointPerformance.getPending()), pendingButton.text.getText());
    assertEquals("Waypoint Performance - Partial",
        String.valueOf(expectedWaypointPerformance.getPartial()), partialButton.text.getText());
    assertEquals("Waypoint Performance - Failed",
        String.valueOf(expectedWaypointPerformance.getFailed()), failedButton.text.getText());
    assertEquals("Waypoint Performance - Completed",
        String.valueOf(expectedWaypointPerformance.getCompleted()), successButton.text.getText());
    assertEquals("Waypoint Performance - Total",
        String.valueOf(expectedWaypointPerformance.getTotal()), totalButton.text.getText());
  }

  public void verifyRouteInboundInfoIsCorrect(Long expectedRouteId, String expectedDriverName,
      String expectedHubName, Date expectedRouteDate, ExpectedScans expectedScans) {
    if (expectedRouteId != null) {
      assertEquals("Route ID", String.valueOf(expectedRouteId), routeId.getText());
    }
    if (StringUtils.isNotBlank(expectedDriverName)) {
      assertEquals("Driver Name", expectedDriverName.replaceAll(" ", ""),
          driver.getText().replaceAll(" ", ""));
    }
    if (StringUtils.isNotBlank(expectedHubName)) {
      assertEquals("Hub Name", expectedHubName, hub.getText());
    }
    if (expectedRouteDate != null) {
      assertEquals("Route Date", YYYY_MM_DD_SDF.format(expectedRouteDate), date.getText());
    }
    if (expectedScans.getPendingDeliveriesScans() != null) {
      String expectedValue = expectedScans.getPendingDeliveriesScans() + " / " + expectedScans
          .getPendingDeliveriesTotal();
      assertEquals("Waypoint Performance - Pending Deliveries", expectedValue,
          pendingDeliveries.getText());
    }
    if (expectedScans.getParcelProcessedScans() != null) {
      String expectedValue =
          expectedScans.getParcelProcessedScans() + " / " + expectedScans.getParcelProcessedTotal();
      assertEquals("Waypoint Performance - Parcel Processed", expectedValue,
          parcelProcessed.getText());
    }
    if (expectedScans.getFailedDeliveriesValidScans() != null) {
      String expectedValue = expectedScans.getFailedDeliveriesValidScans() + " / " + expectedScans
          .getFailedDeliveriesValidTotal();
      assertEquals("Waypoint Performance - Failed Deliveries (Valid)", expectedValue,
          failedDeliveriesValid.getText());
    }
    if (expectedScans.getFailedDeliveriesInvalidScans() != null) {
      String expectedValue = expectedScans.getFailedDeliveriesInvalidScans() + " / " + expectedScans
          .getFailedDeliveriesInvalidTotal();
      assertEquals("Waypoint Performance - Failed Deliveries (Valid)", expectedValue,
          failedDeliveriesInvalid.getText());
    }
    if (expectedScans.getC2cReturnPickupsScans() != null) {
      String expectedValue = expectedScans.getC2cReturnPickupsScans() + " / " + expectedScans
          .getC2cReturnPickupsTotal();
      assertEquals("Waypoint Performance - C2C / Return Pickups", expectedValue,
          c2cReturnPickups.getText());
    }
    if (expectedScans.getReservationPickupsScans() != null) {
      String expectedValue = expectedScans.getReservationPickupsScans() + " / " + expectedScans
          .getReservationPickupsTotal();
      if (expectedScans.getReservationPickupsExtraOrders() != null) {
        expectedValue += "  |  +" + expectedScans.getReservationPickupsExtraOrders();
      }
      assertEquals("Waypoint Performance - Reservation Pickups", expectedValue,
          reservationPickups.getText());
    }
  }

  private void waitUntilLoaded() {
    if (progressBar.waitUntilVisible(1)) {
      progressBar.waitUntilInvisible();
    }
  }

  public void openPendingWaypointsDialog() {
    pendingButton.moveAndClick();
    waitUntilVisibilityOfMdDialogByTitle("Pending");
    waitUntilLoaded();
  }

  public void openCompletedWaypointsDialog() {
    successButton.moveAndClick();
    waitUntilVisibilityOfMdDialogByTitle("Completed");
    waitUntilLoaded();
  }

  public void openFailedWaypointsDialog() {
    failedButton.moveAndClick();
    waitUntilVisibilityOfMdDialogByTitle("Failed");
    waitUntilLoaded();
  }

  public void openFailedParcelsDialog() {
    failedParcels.moveAndClick();
    waitUntilVisibilityOfMdDialogByTitle("Failed Parcels");
    waitUntilLoaded();
  }

  public void openC2CReturnDialog() {
    c2cReturn.moveAndClick();
    waitUntilVisibilityOfMdDialogByTitle("C2C + Return");
    waitUntilLoaded();
  }

  public void openReservationsDialog() {
    reservationsBigButton.moveAndClick();
    waitUntilVisibilityOfMdDialogByTitle("Reservations");
    waitUntilLoaded();
  }

  public void openTotalWaypointsDialog() {
    totalButton.moveAndClick();
    waitUntilVisibilityOfMdDialogByTitle("Total");
    waitUntilLoaded();
  }

  public void openPartialWaypointsDialog() {
    partialButton.moveAndClick();
    waitUntilVisibilityOfMdDialogByTitle("Partial");
    waitUntilLoaded();
  }

  public void openPendingDeliveriesDialog() {
    pendingDeliveries.moveAndClick();
    waitUntilVisibilityOfMdDialogByTitle("Pending Deliveries");
    waitUntilLoaded();
  }

  public void openFailedDeliveriesValidDialog() {
    failedDeliveriesValid.moveAndClick();
    waitUntilVisibilityOfMdDialogByTitle("Failed Deliveries (Valid)");
    waitUntilLoaded();
  }

  public void openFailedDeliveriesInvalidDialog() {
    failedDeliveriesInvalid.moveAndClick();
    waitUntilVisibilityOfMdDialogByTitle("Failed Deliveries (Invalid)");
    waitUntilLoaded();
  }

  public void openC2CReturnPickupsDialog() {
    c2cReturnPickups.moveAndClick();
    waitUntilVisibilityOfMdDialogByTitle("C2C / Return Pickups");
    waitUntilLoaded();
  }

  public void openReservationPickupsDialog() {
    reservationPickups.moveAndClick();
    waitUntilVisibilityOfMdDialogByTitle("Reservation Pickups");
    waitUntilLoaded();
  }

  public void closeDialog() {
    routeInboundCommentsDialog.forceClose();
  }

  public void scanTrackingId(String trackingId) {
    trackingIdInput.setValue(trackingId + Keys.ENTER);
    String xpath = "//tr[@ng-repeat=\"row in ctrl.inboundingHistory | orderBy:'createdAt':true\"]/td[normalize-space(text())='%s']";
    waitUntilVisibilityOfElementLocated(xpath, trackingId);
  }

  public MoneyCollectionDialog openMoneyCollectionDialog() {
    click("//div[contains(@class,'big-button')][./*[normalize-space(.)='Money to collect']]");
    return moneyCollectionDialog;
  }

  public MoneyCollectionDialog moneyCollectionDialog() {
    return moneyCollectionDialog;
  }

  public String getMoneyToCollectValue() {
    if (isElementVisible("//*[@ng-if='ctrl.remainingCashToCollect <= 0'][.='done']")) {
      return "Fully Collected";
    } else {
      return getText("//*[@ng-if='ctrl.remainingCashToCollect > 0']").replace("$", "").trim();
    }
  }

  public void openViewOrdersOrReservationsDialog(int index) {
    shippersTable.clickActionButton(index, VIEW_ORDERS);
  }

  public void validateShippersTable(List<WaypointShipperInfo> expectedShippersInfo) {
    List<WaypointShipperInfo> actualShippersInfo = shippersTable.readAllEntities();
    assertEquals("Shippers count", expectedShippersInfo.size(), actualShippersInfo.size());

    for (int i = 0; i < actualShippersInfo.size(); i++) {
      expectedShippersInfo.get(i).compareWithActual(actualShippersInfo.get(i));
    }
  }

  public void validateReservationsTable(List<WaypointReservationInfo> expectedReservationsInfo) {
    List<WaypointReservationInfo> actualReservationsInfo = reservationsTable.readAllEntities();
    assertEquals("Reservations count", expectedReservationsInfo.size(),
        actualReservationsInfo.size());

    expectedReservationsInfo
        .forEach(expectedReservationInfo ->
        {
          String message = f("Reservation [%d]", expectedReservationInfo.getReservationId());
          WaypointReservationInfo actualReservationInfo = actualReservationsInfo.stream()
              .filter(res -> Objects
                  .equals(res.getReservationId(), expectedReservationInfo.getReservationId()))
              .findFirst()
              .orElseThrow(
                  () -> new AssertionError(message + " was not found in Reservations table"));
          expectedReservationInfo.compareWithActual(message, actualReservationInfo);
        });
  }

  public void validateOrdersTable(List<WaypointOrderInfo> expectedOrdersInfo) {
    List<WaypointOrderInfo> actualOrdersInfo = ordersTable.readAllEntities();
    Map<String, List<WaypointOrderInfo>> actualOrdersInfoMap = actualOrdersInfo.stream()
        .collect(Collectors.toMap(
            WaypointOrderInfo::getTrackingId,
            orderInfo ->
            {
              List<WaypointOrderInfo> list = new ArrayList<>();
              list.add(orderInfo);
              return list;
            },
            (oldVal, newVal) ->
            {
              oldVal.addAll(newVal);
              return oldVal;
            }
        ));
    assertEquals("Orders count", expectedOrdersInfo.size(), actualOrdersInfo.size());

    expectedOrdersInfo.forEach(expectedOrderInfo ->
    {
      List<WaypointOrderInfo> actualOrderInfoList = actualOrdersInfoMap
          .get(expectedOrderInfo.getTrackingId());
      String msg = f("Order [%s]", expectedOrderInfo.getTrackingId());
      assertThat(msg + " was not found", actualOrderInfoList, notNullValue());
      AssertionError error = null;
      for (WaypointOrderInfo actualOrderInfo : actualOrderInfoList) {
        try {
          expectedOrderInfo.compareWithActual(msg, actualOrderInfo);
          return;
        } catch (AssertionError err) {
          error = err;
        }
      }
      if (error != null) {
        throw error;
      }
    });
  }

  public void verifyErrorMessage(String status, String url, String errorCode, String errorMessage) {
    Map<String, String> toastData = waitUntilVisibilityAndGetErrorToastData();

    if (StringUtils.isNotBlank(status)) {
      assertThat("Error toast status", toastData.get("status"), equalToIgnoringCase(status));
    }

    if (StringUtils.isNotBlank(url)) {
      assertThat("Error toast url", toastData.get("url"), equalToIgnoringCase(url));
    }

    if (StringUtils.isNotBlank(errorCode)) {
      assertThat("Error toast code", toastData.get("errorCode"), equalToIgnoringCase(errorCode));
    }

    if (StringUtils.isNotBlank(errorMessage)) {
      assertThat("Error toast status", toastData.get("errorMessage"),
          equalToIgnoringCase(errorMessage));
    }
  }

  public void addRoutInboundComment(String comment) {
    routeInboundComments.click();
    routeInboundCommentsDialog.waitUntilVisible();
    routeInboundCommentsDialog.routeComment.setValue(comment);
    routeInboundCommentsDialog.add.click();
    routeInboundCommentsDialog.waitUntilInvisible();
    pause3s();
  }

  public void verifyRouteInboundComment(String expectedComment) {
    String actualComment = routeLastComment.getText();
    Pattern commentPattern = Pattern.compile("Comment by (.+):(.+)");
    Matcher matcher = commentPattern.matcher(actualComment.trim());
    if (matcher.find()) {
      String commentText = matcher.group(2).trim();
      Assert.assertEquals("Route Inbound Comment text", expectedComment, commentText);
    } else {
      Assert.fail(
          String.format("Route Inbound Comment text [%s] has unexpected format", actualComment));
    }
  }

  public static class RouteInboundCommentsDialog extends MdDialog {

    @FindBy(css = "[id^='container.route-inbound.enter-route-comment-here']")
    public TextBox routeComment;
    @FindBy(name = "Add")
    public NvIconTextButton add;

    public RouteInboundCommentsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class MoneyCollectionDialog extends OperatorV2SimplePage {

    static final String DIALOG_TITLE = "Money Collection";

    public MoneyCollectionDialog(WebDriver webDriver) {
      super(webDriver);
    }

    public String getExpectedTotal() {
      return getText("//*[@label='container.route-inbound.expected-total']/div").replace("S$", "")
          .trim();
    }

    public String getOutstandingAmount() {
      if (isElementVisible(
          "//*[@ng-if='ctrl.inputForm.outstandingAmount <= 0']/p[.='Fully Collected']")) {
        return "Fully Collected";
      } else {
        return getText("//*[@label='container.route-inbound.outstanding-amount']/div")
            .replace("S$", "").trim();
      }
    }

    public MoneyCollectionDialog setCashCollected(Double cashCollected) {
      sendKeysById("cash-collected", String.valueOf(cashCollected));
      return this;
    }

    public MoneyCollectionDialog setCreditCollected(Double creditCollected) {
      sendKeysById("credit-collected", String.valueOf(creditCollected));
      return this;
    }

    public MoneyCollectionDialog setReceiptNo(String receiptNo) {
      sendKeysById("receipt-number", receiptNo);
      return this;
    }

    public MoneyCollectionDialog setReceiptId(String receiptId) {
      sendKeysById("receipt-or-transaction-id", receiptId);
      return this;
    }

    public MoneyCollectionDialog fillForm(MoneyCollection data) {
      if (data.getCashCollected() != null) {
        setCashCollected(data.getCashCollected());
      }

      if (data.getCreditCollected() != null) {
        setCreditCollected(data.getCreditCollected());
      }

      if (StringUtils.isNotBlank(data.getReceiptNo())) {
        setReceiptNo(data.getReceiptNo());
      }

      if (StringUtils.isNotBlank(data.getReceiptId())) {
        setReceiptId(data.getReceiptId());
      }

      return this;
    }

    public void save() {
      clickNvApiTextButtonByName("commons.save");
      waitUntilInvisibilityOfMdDialogByTitle(DIALOG_TITLE);
    }
  }

  /**
   * Accessor for Shippers table
   */
  @SuppressWarnings("WeakerAccess")
  public static class ShippersTable extends NgRepeatTable<WaypointShipperInfo> {

    public static final String NG_REPEAT = "shipper in getTableData()";
    public static final String SHIPPER_NAME = "shipperName";
    public static final String ROUTE_INBOUNDED = "scanned";
    public static final String TOTAL = "total";
    public static final String VIEW_ORDERS = "View orders or reservations";

    public ShippersTable(WebDriver webDriver) {
      super(webDriver);
      setNgRepeat(NG_REPEAT);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(SHIPPER_NAME, "name")
          .put(ROUTE_INBOUNDED, "scanned")
          .put(TOTAL, "total")
          .build());
      setEntityClass(WaypointShipperInfo.class);
      setActionButtonsLocators(
          ImmutableMap.of(VIEW_ORDERS, "container.route-inbound.view-orders-or-reservations"));
    }
  }

  /**
   * Accessor for Reservations table
   */
  @SuppressWarnings("WeakerAccess")
  public static class ReservationsTable extends NgRepeatTable<WaypointReservationInfo> {

    public static final String NG_REPEAT = "reservation in getTableData()";
    public static final String RESERVATION_ID = "reservationId";
    public static final String LOCATION = "location";
    public static final String READY_TO_LATEST_TIME = "readyToLatestTime";
    public static final String APPROX_VALUE = "approxVolume";
    public static final String STATUS = "status";
    public static final String RECEIVED_PARCELS = "receivedParcels";

    public ReservationsTable(WebDriver webDriver) {
      super(webDriver);
      setNgRepeat(NG_REPEAT);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(RESERVATION_ID, "id")
          .put(LOCATION, "location")
          .put(READY_TO_LATEST_TIME, "ready-to-latest-time")
          .put(APPROX_VALUE, "approx_volume")
          .put(STATUS, "translated-status")
          .put(RECEIVED_PARCELS, "total-pickup-count")
          .build());
      setEntityClass(WaypointReservationInfo.class);
    }
  }

  /**
   * Accessor for Orders table
   */
  @SuppressWarnings("WeakerAccess")
  public static class OrdersTable extends NgRepeatTable<WaypointOrderInfo> {

    public static final String NG_REPEAT = "order in getTableData()";
    public static final String TRACKING_ID = "trackingId";
    public static final String STAMP_ID = "stampId";
    public static final String LOCATION = "location";
    public static final String TYPE = "type";
    public static final String STATUS = "status";
    public static final String CMI_COUNT = "cmiCount";
    public static final String ROUTE_INBOUND_STATUS = "routeInboundStatus";

    public OrdersTable(WebDriver webDriver) {
      super(webDriver);
      setNgRepeat(NG_REPEAT);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(TRACKING_ID, "tracking_id")
          .put(STAMP_ID, "stamp_id")
          .put(LOCATION, "location")
          .put(TYPE, "custom-type")
          .put(STATUS, "translated-status")
          .put(CMI_COUNT, "cmi_count")
          .put(ROUTE_INBOUND_STATUS, "scan-status")
          .build());
      setEntityClass(WaypointOrderInfo.class);
    }
  }

  public static class DriverAttendanceDialog extends MdDialog {

    @FindBy(css = ".md-dialog-content-body")
    public PageElement message;

    @FindBy(css = "[aria-label='Yes']")
    public Button yes;

    public DriverAttendanceDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class BigButton extends PageElement {

    @FindBy(css = "div.statistic p")
    public PageElement text;

    public BigButton(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class MoneyCollectionHistoryDialog extends MdDialog {

    @FindBy(xpath = "//md-tab-item[.='History']")
    public PageElement historyTab;
    @FindBy(xpath = "//md-tab-item[.='Details']")
    public PageElement detailsTab;
    public HistoryTable historyTable;
    public CollectedOrdersTable collectedOrdersTable;

    public MoneyCollectionHistoryDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      historyTable = new HistoryTable(webDriver);
      collectedOrdersTable = new CollectedOrdersTable(webDriver);
    }

    public static class HistoryTable extends NgRepeatTable<MoneyCollectionHistoryEntry> {

      public static final String NG_REPEAT = "row in getTableData()";
      public static final String PROCESSED_AMOUNT = "processedAmount";
      public static final String PROCESSED_TYPE = "processedType";
      public static final String INBOUNDED_BY = "inboundedBy";
      public static final String RECEIPT_NO = "receiptNo";

      public HistoryTable(WebDriver webDriver) {
        super(webDriver);
        setNgRepeat(NG_REPEAT);
        setColumnLocators(ImmutableMap.<String, String>builder()
            .put(PROCESSED_AMOUNT, "processed-amount")
            .put(PROCESSED_TYPE, "processed-type")
            .put(INBOUNDED_BY, "inbounded_by")
            .put(RECEIPT_NO, "receipt_no")
            .build());
        setEntityClass(MoneyCollectionHistoryEntry.class);
      }
    }

    public static class CollectedOrdersTable extends
        NgRepeatTable<MoneyCollectionCollectedOrderEntry> {

      public static final String NG_REPEAT = "order in getTableData()";
      public static final String PROCESSED_COD_AMOUNT = "processedCodAmount";
      public static final String PROCESSED_COD_COLLECTED = "processedCodCollected";
      public static final String TRACKING_ID = "trackingId";
      public static final String STAMP_ID = "stampId";
      public static final String CUSTOM_TYPE = "customType";
      public static final String LOCATION = "location";
      public static final String CONTACT = "contact";
      public static final String ADDRESSEE = "addressee";

      public CollectedOrdersTable(WebDriver webDriver) {
        super(webDriver);
        setNgRepeat(NG_REPEAT);
        setColumnLocators(ImmutableMap.<String, String>builder()
            .put(PROCESSED_COD_AMOUNT, "processed-cod-amount")
            .put(PROCESSED_COD_COLLECTED, "processed-cod-collected")
            .put(TRACKING_ID, "tracking_id")
            .put(STAMP_ID, "stamp_id")
            .put(CUSTOM_TYPE, "custom-type")
            .put(LOCATION, "location")
            .put(CONTACT, "contact")
            .put(ADDRESSEE, "name")
            .build());
        setEntityClass(MoneyCollectionCollectedOrderEntry.class);
      }
    }

  }

  public static class ReservationPickupsDialog extends MdDialog {

    @FindBy(xpath = ".//md-tab-item[.='Inbounded Orders']")
    public PageElement inpoundedOrdersTab;
    @FindBy(xpath = ".//md-tab-item[.='Non-inbounded Orders']")
    public PageElement nonInboundedOrdersTab;
    @FindBy(xpath = ".//md-tab-item[.='Extra Orders']")
    public PageElement extraOrdersTab;
    public NonInboundedOrdersTable nonInboundedOrdersTable;
    public InboundedOrdersTable inboundedOrdersTable;
    public ExtraOrdersTable extraOrdersTable;

    public ReservationPickupsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      nonInboundedOrdersTable = new NonInboundedOrdersTable(webDriver);
      inboundedOrdersTable = new InboundedOrdersTable(webDriver);
      extraOrdersTable = new ExtraOrdersTable(webDriver);
    }

    public static class OrdersTable extends NgRepeatTable<WaypointOrderInfo> {

      public static final String NG_REPEAT = "order in getTableData()";
      public static final String TRACKING_ID = "trackingId";
      public static final String SHIPPER_NAME = "shipperName";
      public static final String RESERVATION_ID = "reservationId";
      public static final String LOCATION = "location";

      public OrdersTable(WebDriver webDriver) {
        super(webDriver);
        setNgRepeat(NG_REPEAT);
        setColumnLocators(ImmutableMap.<String, String>builder()
            .put(TRACKING_ID, "tracking_id")
            .put(SHIPPER_NAME, "shipper_name")
            .put(RESERVATION_ID, "reservation-id")
            .put(LOCATION, "location")
            .build());
        setEntityClass(WaypointOrderInfo.class);
      }
    }

    public static class NonInboundedOrdersTable extends OrdersTable {

      public NonInboundedOrdersTable(WebDriver webDriver) {
        super(webDriver);
        setTableLocator("//nv-table[@class='non-inbounded-orders-table']");
      }
    }

    public static class InboundedOrdersTable extends OrdersTable {

      public InboundedOrdersTable(WebDriver webDriver) {
        super(webDriver);
        setTableLocator("//nv-table[@class='inbounded-orders-table']");
      }
    }

    public static class ExtraOrdersTable extends NgRepeatTable<WaypointOrderInfo> {

      public static final String NG_REPEAT = "order in getTableData()";
      public static final String TRACKING_ID = "trackingId";
      public static final String SHIPPER_NAME = "shipperName";

      public ExtraOrdersTable(WebDriver webDriver) {
        super(webDriver);
        setTableLocator("//nv-table[@class='extra-orders-table scroll-x-end']");
        setNgRepeat(NG_REPEAT);
        setColumnLocators(ImmutableMap.<String, String>builder()
            .put(TRACKING_ID, "tracking_id")
            .put(SHIPPER_NAME, "shipper_name")
            .build());
        setEntityClass(WaypointOrderInfo.class);
      }
    }
  }

  public static class WaypointScansTable extends NgRepeatTable<WaypointScanInfo> {

    public static final String NG_REPEAT = "row in ctrl.inboundingHistory | orderBy:'createdAt':true";
    public static final String TRACKING_ID = "trackingId";
    public static final String STATUS = "status";
    public static final String REASON = "reason";
    public static final String TAGS = "tags";

    public WaypointScansTable(WebDriver webDriver) {
      super(webDriver);
      setNgRepeat(NG_REPEAT);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(TRACKING_ID, "//td[2]")
          .put(STATUS, "//td[3]")
          .put(REASON, "//td[4]")
          .put(TAGS, "//td[5]")
          .build());
      setEntityClass(WaypointScanInfo.class);
    }
  }

  public static class ChooseRouteDialog extends MdDialog {

    public ChooseRouteDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public void chooseRoute(long routeId) {
      new NvIconButton(getWebDriver(), getWebElement(),
          f("//tr[./td[.='%d']]//*[@name='commons.proceed']", routeId)).click();
    }
  }

  public static class PhotoAuditDialog extends MdDialog {

    @FindBy(css = "[aria-label='I have completed photo audit']")
    public Button completePhotoAudit;

    public PhotoAuditDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}
