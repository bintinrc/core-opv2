package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.model.driver.FailureReason;
import co.nvqa.operator_v2.model.PoaInfo;
import co.nvqa.operator_v2.model.PohInfo;
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
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.Stack;
import java.util.function.Consumer;
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
  public static final String ROUTE_DETAIL_ITEMS_XPATH = "//div[text()='%s']/following-sibling::div";
  private final WaypointDetailsDialog waypointDetailsDialog;
  public final WaypointsTable waypointsTable;
  @FindBy(xpath = "//md-dialog[contains(@class, 'proof-of-arrival-and-handover')]")
  public ProofOfArrivalAndHandoverDialog proofOfArrivalAndHandoverDialog;

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

  @FindBy(xpath = "//button[contains(text(),'View POA/POH')]")
  private PageElement viewPoaPohButton;

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
    Assertions.assertThat(isTableEmpty())
        .as(f("Order with Tracking ID = '%s' not found on table.", order.getTrackingId()))
        .isFalse();

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
    Assertions.assertThat(actualComments).as("Comments")
        .isEqualTo(expectedFailureReason.getDescription());
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

  public void waitUntilProofOfArrivalAndHandoverDialogVisible() {
    proofOfArrivalAndHandoverDialog.waitUntilVisible(3);
  }

  public void clickViewPoaPoH() {
    viewPoaPohButton.click();
    waitUntilProofOfArrivalAndHandoverDialogVisible();
  }

  public boolean isViewPoaPohDisabled() {
    return viewPoaPohButton.isEnabled();
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
          .put("contact", "contact")
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

  public static class ProofOfArrivalAndHandoverDialog extends MdDialog {

    @FindBy(xpath = "//div[@class='ant-col' and *[text()='Arrival']]//table")
    public ProofOfArrivalTable proofOfArrivalTable;
    @FindBy(xpath = "//div[@class='ant-col' and *[text()='Handover']]//table")
    public ProofOfHandoverTable proofOfHandoverTable;
    public static final String IFRAME_XPATH = "//iframe[@ng-style='iframeStyleObj']";
    @FindBy(xpath = IFRAME_XPATH)
    public PageElement iframe;

    public ProofOfArrivalAndHandoverDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      proofOfArrivalTable = new ProofOfArrivalTable(webDriver);
      proofOfHandoverTable = new ProofOfHandoverTable(webDriver);
    }

    public void inFrame(Consumer<ProofOfArrivalAndHandoverDialog> consumer) {
      getWebDriver().switchTo().defaultContent();
      iframe.waitUntilVisible();
      getWebDriver().switchTo().frame(iframe.getWebElement());
      try {
        consumer.accept(this);
      } finally {
        getWebDriver().switchTo().defaultContent();
      }
    }

    public static class ProofOfArrivalTable extends AntTableV3<PoaInfo> {

      @FindBy(xpath = "//button/a[contains(@href, 'google.com/maps')]")
      public PageElement viewOnMap;
      @FindBy(xpath = "//tr/td[@class='ant-table-cell'][1]")
      public List<PageElement> arrivalDatetime;
      @FindBy(xpath = "//tr/td[@class='ant-table-cell'][2]")
      public List<PageElement> verifiedByGps;
      @FindBy(xpath = "//tr/td[@class='ant-table-cell'][3]")
      public List<PageElement> distanceFromSortHub;


      public ProofOfArrivalTable(WebDriver webDriver) {
        super(webDriver);
        setEntityClass(PoaInfo.class);
      }

      public void clickViewOnMap() {
        waitUntilVisibilityOfElementLocated(viewOnMap.getWebElement(), 20);
        viewOnMap.click();
      }

      public void verifyPoAInfo(PoaInfo expected, int index) {
        PoaInfo actual = new PoaInfo();
        actual.setArrivalDateTime(getTextArrivalDatetime(index));
        actual.setVerifiedByGps(getTextVerifiedByGps(index));
        actual.setDistanceFromSortHub(getTextDistanceFromSortHub(index));
        expected.compareWithActual(actual);
        Assertions.assertThat(getTextArrivalDatetime(index)).as("Arrival datetime")
            .contains(getTodayDate());
      }

      private String getTodayDate() {
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDateTime now = LocalDateTime.now();
        String dateToday = dtf.format(now);
        return dateToday;
      }

      private String getTextArrivalDatetime(int index) {
        waitUntilVisibilityOfElementLocated(arrivalDatetime.get(index).getWebElement(), 10);
        return getText(arrivalDatetime.get(index).getWebElement());
      }

      private String getTextVerifiedByGps(int index) {
        waitUntilVisibilityOfElementLocated(verifiedByGps.get(index).getWebElement());
        return getText(verifiedByGps.get(index).getWebElement());
      }

      private String getTextDistanceFromSortHub(int index) {
        waitUntilVisibilityOfElementLocated(distanceFromSortHub.get(index).getWebElement());
        return getText(distanceFromSortHub.get(index).getWebElement()).replace("View on map", "");
      }
    }

    public static class ProofOfHandoverTable extends AntTableV3<PohInfo> {

      @FindBy(xpath = "//button/*[contains(text(),'View Photo')]")
      private PageElement viewPhoto;
      @FindBy(xpath = "//div[@class='ant-col' and *[text()='Handover']]//tr/td[@class='ant-table-cell'][1]")
      private List<PageElement> handoverDatetime;
      @FindBy(xpath = "//div[@class='ant-col' and *[text()='Handover']]//tr/td[@class='ant-table-cell'][2]")
      private List<PageElement> estQty;
      @FindBy(xpath = "//div[@class='ant-col' and *[text()='Handover']]//tr/td[@class='ant-table-cell'][3]")
      private List<PageElement> cntQty;
      @FindBy(xpath = "//div[@class='ant-col' and *[text()='Handover']]//tr/td[@class='ant-table-cell'][4]")
      private List<PageElement> handover;
      @FindBy(xpath = "//div[@class='ant-col' and *[text()='Handover']]//tr/td[@class='ant-table-cell'][5]")
      private List<PageElement> sortHubName;
      @FindBy(xpath = "//div[@class='ant-col' and *[text()='Handover']]//tr/td[@class='ant-table-cell'][6]")
      private List<PageElement> staffUsername;


      public ProofOfHandoverTable(WebDriver webDriver) {
        super(webDriver);
        setEntityClass(PohInfo.class);
      }

      public void clickViewPhoto() {
        waitUntilVisibilityOfElementLocated(viewPhoto.getWebElement(), 10);
        viewPhoto.click();
      }

      public void verifyPoHInfo(PohInfo expected, int index) {
        PohInfo actual = new PohInfo();
        actual.setHandoverDatetime(getTextHandoverDatetime(index));
        actual.setEstQty(Integer.parseInt(getTextEstQty(index)));
        actual.setCntQty(Integer.parseInt(getTextCntQt(index)));
        actual.setHandover(getTextHandover(index));
        actual.setSortHubName(getTextSortHubName(index));
        actual.setStaffUsername(getTextStaffUsername(index));
        expected.compareWithActual(actual);
        Assertions.assertThat(getTextHandoverDatetime(index)).as("Handover datetime")
            .contains(getTodayDate());
      }

      private String getTodayDate() {
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDateTime now = LocalDateTime.now();
        String dateToday = dtf.format(now);
        return dateToday;
      }

      private String getTextHandoverDatetime(int index) {
        waitUntilVisibilityOfElementLocated(handoverDatetime.get(index).getWebElement(), 10);
        return getText(handoverDatetime.get(index).getWebElement());
      }

      private String getTextEstQty(int index) {
        waitUntilVisibilityOfElementLocated(estQty.get(index).getWebElement());
        return getText(estQty.get(index).getWebElement());
      }

      private String getTextCntQt(int index) {
        waitUntilVisibilityOfElementLocated(cntQty.get(index).getWebElement());
        return getText(cntQty.get(index).getWebElement());
      }

      private String getTextHandover(int index) {
        waitUntilVisibilityOfElementLocated(handover.get(index).getWebElement());
        return getText(handover.get(index).getWebElement());
      }

      private String getTextSortHubName(int index) {
        waitUntilVisibilityOfElementLocated(sortHubName.get(index).getWebElement());
        return getText(sortHubName.get(index).getWebElement());
      }

      private String getTextStaffUsername(int index) {
        waitUntilVisibilityOfElementLocated(staffUsername.get(index).getWebElement());
        return getText(staffUsername.get(index).getWebElement());
      }
    }
  }

  public String getRouteDetailItem(String itemName) {
    waitUntilVisibilityOfElementLocated(f(ROUTE_DETAIL_ITEMS_XPATH, itemName));
    return findElementByXpath(f(ROUTE_DETAIL_ITEMS_XPATH, itemName)).getText();
  }
}