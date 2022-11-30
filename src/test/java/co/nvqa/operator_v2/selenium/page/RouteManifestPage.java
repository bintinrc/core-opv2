package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.model.driver.FailureReason;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.operator_v2.model.RouteManifestWaypointDetails;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.md.MdCheckbox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.common.collect.ImmutableMap;
import java.util.List;
import java.util.Map;
import java.util.Stack;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class RouteManifestPage extends OperatorV2SimplePage {

  public static final String COLUMN_STATUS = "status";
  public static final String COLUMN_COUNT_DELIVERY = "count-d";
  public static final String COLUMN_COMMENTS = "comments";
  public static final String ACTION_BUTTON_EDIT = "container.route-manifest.choose-outcome-for-waypoint";
  private static final String MD_VIRTUAL_REPEAT = "waypoint in getTableData()";
  private final WaypointDetailsDialog waypointDetailsDialog;
  public final WaypointsTable waypointsTable;

  @FindBy(css = "md-dialog")
  public ChooseAnOutcomeForTheWaypointDialog chooseAnOutcomeForTheWaypointDialog;

  @FindBy(css = "md-dialog")
  public CodCollectionDialog codCollectionDialog;

  @FindBy(css = "div.route-detail:nth-of-type(1)>div:nth-of-type(2)")
  public PageElement routeId;

  @FindBy(xpath = "//*[text()='Tracking ID(s)']/parent::th//input")
  public PageElement trackingIDFilter;

  @FindBy(css = "md-dialog[aria-label='Are you sure?All ...']")
  public ConfirmationDialog confirmationDialog;

  public RouteManifestPage(WebDriver webDriver) {
    super(webDriver);
    waypointDetailsDialog = new WaypointDetailsDialog(webDriver);
    waypointsTable = new WaypointsTable(webDriver);
  }

  public void openPage(long routeId) {
    getWebDriver().get(f("%s/%s/route-manifest/%d", TestConstants.OPERATOR_PORTAL_BASE_URL,
        StandardTestConstants.NV_SYSTEM_ID.toLowerCase(), routeId));
    waitUntilPageLoaded();
  }

  public void waitUntilPageLoaded() {
    super.waitUntilPageLoaded();
    waitUntilInvisibilityOfElementLocated(
        "//md-progress-circular/following-sibling::div[text()='Loading...']");
  }

  public void verify1DeliverySuccessAtRouteManifest(Route route, Order order) {
    verify1DeliverySuccessOrFailAtRouteManifest(route, order, null, true);
  }

  public void verify1DeliveryFailAtRouteManifest(Route route, Order order,
      FailureReason expectedFailureReason) {
    verify1DeliverySuccessOrFailAtRouteManifest(route, order, expectedFailureReason, false);
  }

  private void verify1DeliverySuccessOrFailAtRouteManifest(Route route, Order order,
      FailureReason expectedFailureReason, boolean verifyDeliverySuccess) {
    if (verifyDeliverySuccess) {
      verify1DeliveryIsSuccess(route, order);
    } else {
      verify1DeliveryIsFailed(route, order, expectedFailureReason);
    }
  }

  public void verify1DeliveryIsSuccess(Route route, Order order) {
    waitUntilPageLoaded();

    String actualRouteId = getText(
        "//div[contains(@class,'route-detail')]/div[text()='Route ID']/following-sibling::div");
    String actualWaypointSuccessCount = getText(
        "//div[text()='Waypoint Type']/following-sibling::table//td[contains(@ng-class, 'column.Success.value')]");
   Assertions.assertThat(actualRouteId).as("Route ID").isEqualTo(String.valueOf(route.getId()));
   Assertions.assertThat(actualWaypointSuccessCount).as("Waypoint Success Count").isEqualTo("1");

    searchTableByTrackingId(order.getTrackingId());
   Assertions.assertThat(        isTableEmpty()).as(f("Order with Tracking ID = '%s' not found on table.", order.getTrackingId())).isFalse();

    String actualStatus = getTextOnTable(1, COLUMN_STATUS);
    String actualCountDelivery = getTextOnTable(1, COLUMN_COUNT_DELIVERY);
   Assertions.assertThat(actualStatus).as("Status").isEqualTo("Success");
   Assertions.assertThat(actualCountDelivery).as("Count Delivery").isEqualTo("1");
  }

  public void verify1DeliveryIsFailed(Route route, Order order,
      FailureReason expectedFailureReason) {
    waitUntilPageLoaded();

    String actualRouteId = getText(
        "//div[contains(@class,'route-detail')]/div[text()='Route ID']/following-sibling::div");
    String actualWaypointSuccessCount = getText(
        "//div[text()='Waypoint Type']/following-sibling::table//td[contains(@ng-class, 'column.Fail.value')]");
   Assertions.assertThat(actualRouteId).as("Route ID").isEqualTo(String.valueOf(route.getId()));
   Assertions.assertThat(actualWaypointSuccessCount).as("Waypoint Failed Count").isEqualTo("1");

    searchTableByTrackingId(order.getTrackingId());
    assertFalse(
        String.format("Order with Tracking ID = '%s' not found on table.", order.getTrackingId()),
        isTableEmpty());

    String actualStatus = getTextOnTable(1, COLUMN_STATUS);
    String actualCountDelivery = getTextOnTable(1, COLUMN_COUNT_DELIVERY);
    String actualComments = getTextOnTable(1, COLUMN_COMMENTS);
   Assertions.assertThat(actualStatus).as("Status").isEqualTo("Fail");
   Assertions.assertThat(actualCountDelivery).as("Count Delivery").isEqualTo("1");
   Assertions.assertThat(actualComments).as("Comments").isEqualTo(expectedFailureReason.getDescription());
  }

  public void verifyWaypointDetails(RouteManifestWaypointDetails expectedWaypointDetails) {
    RouteManifestWaypointDetails.Reservation expectedReservation = expectedWaypointDetails
        .getReservation();
    RouteManifestWaypointDetails.Pickup expectedPickup = expectedWaypointDetails.getPickup();
    RouteManifestWaypointDetails.Delivery expectedDelivery = expectedWaypointDetails.getDelivery();
    expectedWaypointDetails.setReservation(null);
    expectedWaypointDetails.setPickup(null);
    expectedWaypointDetails.setDelivery(null);

    waitUntilPageLoaded();

    if (StringUtils.isNotBlank(expectedWaypointDetails.getTrackingIds())) {
      waypointsTable
          .filterByColumn("trackingIds", String.valueOf(expectedWaypointDetails.getTrackingIds()));
    } else if (expectedWaypointDetails.getId() != null) {
      waypointsTable.filterByColumn("id", String.valueOf(expectedWaypointDetails.getId()));
    } else if (StringUtils.isNotBlank(expectedWaypointDetails.getAddress())) {
      waypointsTable
          .filterByColumn("address", String.valueOf(expectedWaypointDetails.getAddress()));
    }

    RouteManifestWaypointDetails actualWaypointDetails = waypointsTable.readEntity(1);
    expectedWaypointDetails.compareWithActual(actualWaypointDetails);

    if (expectedReservation != null || expectedPickup != null || expectedDelivery != null) {
      waypointsTable.clickActionButton(1, "details");
      waypointDetailsDialog.waitUntilVisible();

      if (expectedReservation != null) {
        RouteManifestWaypointDetails.Reservation actualReservation = waypointDetailsDialog.reservationsTable
            .readEntity(1);
        expectedReservation.compareWithActual(actualReservation);
      }
      if (expectedPickup != null) {
        RouteManifestWaypointDetails.Pickup actualPickup = waypointDetailsDialog.pickupsTable
            .readEntity(1);
        expectedPickup.compareWithActual(actualPickup);
      }
      if (expectedDelivery != null) {
        RouteManifestWaypointDetails.Delivery actualDelivery = waypointDetailsDialog.deliveryTable
            .readEntity(1);
        expectedDelivery.compareWithActual(actualDelivery);
      }
      waypointDetailsDialog.closeDialogIfVisible();
    }
  }

  public void failDeliveryWaypoint(FailureReason failureReason) {
    clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
    chooseAnOutcomeForTheWaypointDialog.waitUntilVisible();
    pause1s();
    chooseAnOutcomeForTheWaypointDialog.failure.click();

    Stack<FailureReason> stackOfFailureReason = new Stack<>();
    FailureReason pointer = failureReason;

    do {
      stackOfFailureReason.push(pointer);
      pointer = pointer.getParent();
    }
    while (pointer != null);

    FailureReason failureReasonGrandParent = stackOfFailureReason.pop();
    chooseAnOutcomeForTheWaypointDialog.chooseFailureReason
        .selectValue(failureReasonGrandParent.getDescription());
    int stackSize = stackOfFailureReason.size();

    for (int i = 1; i <= stackSize; i++) {
      FailureReason childFailureReason = stackOfFailureReason.pop();
      chooseAnOutcomeForTheWaypointDialog
          .selectFailureReasonDetails(i, childFailureReason.getDescription());
    }

    chooseAnOutcomeForTheWaypointDialog.update.click();
    confirmationDialog.waitUntilVisible();
    confirmationDialog.proceed.click();
    confirmationDialog.waitUntilInvisible();
    chooseAnOutcomeForTheWaypointDialog.waitUntilInvisible();
  }

  public void failWaypointWithFailureDetails(Map<String, String> mapOfData, String trackingID) {
    String failureReason = mapOfData.get("Failure Reason");
    String failureReasonDetail1 = mapOfData.get("Failure Reason Detail 1");
    String failureReasonDetail2 = mapOfData.get("Failure Reason Detail 2");
    trackingIDFilter.clearAndSendKeys(trackingID);
    clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
    chooseAnOutcomeForTheWaypointDialog.waitUntilVisible();
    pause1s();
    chooseAnOutcomeForTheWaypointDialog.failure.click();
    chooseAnOutcomeForTheWaypointDialog.chooseFailureReason.selectValue(failureReason);
    if (StringUtils.isNotBlank(failureReasonDetail1)) {
      chooseAnOutcomeForTheWaypointDialog.selectFailureReasonDetails(1, failureReasonDetail1);
    }
    if (StringUtils.isNotBlank(failureReasonDetail2)) {
      chooseAnOutcomeForTheWaypointDialog.selectFailureReasonDetails(2, failureReasonDetail2);
    }
    chooseAnOutcomeForTheWaypointDialog.update.click();
    confirmationDialog.waitUntilVisible();
    confirmationDialog.proceed.click();
    confirmationDialog.waitUntilInvisible();
    chooseAnOutcomeForTheWaypointDialog.waitUntilInvisible();
  }

  public void successDeliveryWaypoint() {
    clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
    chooseAnOutcomeForTheWaypointDialog.success.click();
    confirmationDialog.waitUntilVisible();
    confirmationDialog.proceed.click();
    confirmationDialog.waitUntilInvisible();
    chooseAnOutcomeForTheWaypointDialog.waitUntilInvisible();
  }

  public void successReservationWaypoint() {
    clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
    chooseAnOutcomeForTheWaypointDialog.success.click();
    confirmationDialog.waitUntilVisible();
    confirmationDialog.proceed.click();
    confirmationDialog.waitUntilInvisible();
    chooseAnOutcomeForTheWaypointDialog.waitUntilInvisible();
  }

  public void searchTableByTrackingId(String trackingId) {
    searchTableCustom1("tracking-ids", trackingId);
  }

  public String getTextOnTable(int rowNumber, String columnDataClass) {
    return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
  }

  public void clickActionButtonOnTable(int rowNumber, String actionButtonName) {
    clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
  }

  /**
   * Accessor for Waypoint Details dialog
   */
  public static class WaypointDetailsDialog extends OperatorV2SimplePage {

    public static final String DIALOG_TITLE = "Waypoint Details";
    public ReservationsTable reservationsTable;
    public PickupsTable pickupsTable;
    public DeliveryTable deliveryTable;

    public WaypointDetailsDialog(WebDriver webDriver) {
      super(webDriver);
      reservationsTable = new ReservationsTable(webDriver);
      pickupsTable = new PickupsTable(webDriver);
      deliveryTable = new DeliveryTable(webDriver);
    }

    public WaypointDetailsDialog waitUntilVisible() {
      waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
      return this;
    }

    public static class ReservationsTable extends
        NgRepeatTable<RouteManifestWaypointDetails.Reservation> {

      public ReservationsTable(WebDriver webDriver) {
        super(webDriver);
        setColumnLocators(ImmutableMap.of(
            "id", "/td[2]",
            "status", "/td[3]",
            "failureReason", "/td[6]"
        ));
        setNgRepeat("reservation in fields.reservations track by $index");
        setEntityClass(RouteManifestWaypointDetails.Reservation.class);
      }
    }

    public static class PickupsTable extends NgRepeatTable<RouteManifestWaypointDetails.Pickup> {

      public PickupsTable(WebDriver webDriver) {
        super(webDriver);
        setColumnLocators(ImmutableMap.of(
            "trackingId", "/td[2]",
            "status", "/td[3]",
            "failureReason", "/td[4]"
        ));
        setNgRepeat("pickup in fields.pickups track by $index");
        setEntityClass(RouteManifestWaypointDetails.Pickup.class);
      }
    }

    public static class DeliveryTable extends NgRepeatTable<RouteManifestWaypointDetails.Delivery> {

      public DeliveryTable(WebDriver webDriver) {
        super(webDriver);
        setColumnLocators(ImmutableMap.of(
            "trackingId", "/td[2]",
            "status", "/td[3]",
            "failureReason", "/td[5]"
        ));
        setNgRepeat("delivery in fields.deliveries track by $index");
        setEntityClass(RouteManifestWaypointDetails.Delivery.class);
      }
    }
  }

  public static class WaypointsTable extends MdVirtualRepeatTable<RouteManifestWaypointDetails> {

    public static final String COLUMN_ORDER_TAGS = "orderTags";
    public static final String COLUMN_TRACKING_IDS = "trackingIds";

    public WaypointsTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("address", "address")
          .put("status", "status")
          .put(COLUMN_ORDER_TAGS, "order-tags")
          .put("id", "id")
          .put("deliveriesCount", "count-d")
          .put("pickupsCount", "count-p")
          .put("comments", "comments")
          .put(COLUMN_TRACKING_IDS, "tracking-ids")
          .build()
      );
      setActionButtonsLocators(ImmutableMap.of("details", "Waypoint Details", "edit",
          "container.route-manifest.choose-outcome-for-waypoint"));
      setMdVirtualRepeat("waypoint in getTableData()");
      setEntityClass(RouteManifestWaypointDetails.class);
    }
  }

  public static class ChooseAnOutcomeForTheWaypointDialog extends MdDialog {

    public ChooseAnOutcomeForTheWaypointDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(name = "commons.success")
    public NvIconTextButton success;

    @FindBy(name = "commons.failure")
    public NvIconTextButton failure;

    @FindBy(name = "commons.go-back")
    public NvIconTextButton goBack;

    @FindBy(name = "commons.update")
    public NvIconTextButton update;

    @FindBy(css = "[id^='container.route-manifest.choose-failure-reason']")
    public MdSelect chooseFailureReason;

    public void selectFailureReasonDetails(int index, String reason) {
      String xpath = f(
          "(.//md-select[contains(@id, 'container.route-manifest.failure-reason-detail')])[%d]",
          index);
      new MdSelect(this, xpath).selectValue(reason);
    }
  }

  public static class CodCollectionDialog extends MdDialog {

    public CodCollectionDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = ".//tr[@ng-repeat='orderCod in ctrl.orderCods']/td[1]")
    public List<PageElement> trackingId;

    @FindBy(xpath = ".//tr[@ng-repeat='orderCod in ctrl.orderCods']/td[2]")
    public List<PageElement> amount;

    @FindBy(xpath = ".//tr[@ng-repeat='orderCod in ctrl.orderCods']/td[3]/md-checkbox")
    public List<MdCheckbox> collected;

    @FindBy(name = "commons.ok")
    public NvApiTextButton ok;
  }

  public static class ConfirmationDialog extends MdDialog {

    public ConfirmationDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[aria-label='Proceed']")
    public Button proceed;
  }
}