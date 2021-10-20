package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Cod;
import co.nvqa.commons.model.core.Dimension;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.model.pdf.AirwayBill;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.commons.util.PdfUtils;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.GlobalInboundParams;
import co.nvqa.operator_v2.model.OrderEvent;
import co.nvqa.operator_v2.model.PodDetail;
import co.nvqa.operator_v2.model.RecoveryTicket;
import co.nvqa.operator_v2.model.TransactionInfo;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdCheckbox;
import co.nvqa.operator_v2.selenium.elements.md.MdDatepicker;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdMenu;
import co.nvqa.operator_v2.selenium.elements.md.MdMenuBar;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvTag;
import co.nvqa.operator_v2.selenium.page.AllOrdersPage.ManuallyCompleteOrderDialog;
import co.nvqa.operator_v2.selenium.page.RecoveryTicketsPage.CreateTicketDialog;
import co.nvqa.operator_v2.selenium.page.RecoveryTicketsPage.EditTicketDialog;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import java.io.File;
import java.text.ParseException;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;

import static co.nvqa.operator_v2.selenium.page.EditOrderPage.EventsTable.EVENT_NAME;
import static co.nvqa.operator_v2.selenium.page.EditOrderPage.TransactionsTable.COLUMN_TYPE;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class EditOrderPage extends OperatorV2SimplePage {

  @FindBy(id = "header")
  public PageElement header;

  @FindBy(css = ".view-container md-menu-bar")
  public MdMenuBar menuBar;

  @FindBy(css = "div[loading-message='Loading events...'] md-menu")
  public MdMenu eventsTableFilter;

  @FindBy(xpath = "//div[label[.='Tracking ID']]/h3")
  public PageElement trackingId;

  @FindBy(xpath = "//div[label[.='Latest Event']]/h3")
  public PageElement latestEvent;

  @FindBy(xpath = "//div[label[.='Zone']]/h3")
  public PageElement zone;

  @FindBy(xpath = "//div[label[.='Status']]/h3")
  public PageElement status;

  @FindBy(xpath = "//div[label[.='Granular']]/h3")
  public PageElement granular;

  @FindBy(xpath = "//div[label[.='Latest Route ID']]/h3")
  public PageElement latestRouteId;

  @FindBy(xpath = "//div[label[.='Shipper ID']]/p")
  public PageElement shipperId;

  @FindBy(xpath = "//div[label[.='Order Type']]/p")
  public PageElement orderType;

  @FindBy(xpath = "//div[./label[.='Current DNR Group']]/p")
  public PageElement currentDnrGroup;

  @FindBy(xpath = "//div[./label[.='Current Priority']]/h3")
  public PageElement currentPriority;

  @FindBy(xpath = "//div[./label[.='Delivery Verification Required']]/div/div")
  public PageElement deliveryVerificationType;

  @FindBy(xpath = "//label[text()='Size']/following-sibling::p")
  public PageElement size;

  @FindBy(xpath = "//label[text()='Weight']/following-sibling::p")
  public PageElement weight;

  @FindBy(xpath = ".//a[contains(.,'Ticket ID')]")
  public Button recoveryTicket;

  @FindBy(css = "md-dialog")
  public CreateTicketDialog createTicketDialog;

  @FindBy(css = "md-dialog")
  public EditTicketDialog editTicketDialog;

  @FindBy(css = "[name='commons.edit']")
  public NvIconButton deliveryVerificationTypeEdit;

  @FindBy(css = "nv-tag[name^='COP']")
  public NvTag copValue;

  @FindBy(css = "nv-tag[name^='COD']")
  public NvTag codValue;

  @FindBy(css = "button[ng-click='ctrl.startChatWithDriver($event)']")
  public Button chatWithDriver;

  private static final String NG_REPEAT_TABLE_EVENT = "event in getTableData()";
  public static final String COLUMN_CLASS_DATA_NAME_ON_TABLE_EVENT = "name";

  public TransactionsTable transactionsTable;

  @FindBy(css = "md-dialog")
  public EditPriorityLevelDialog editPriorityLevelDialog;

  @FindBy(css = "md-dialog")
  public AddToRouteDialog addToRouteDialog;

  @FindBy(css = "md-dialog")
  public EditOrderDetailsDialog editOrderDetailsDialog;

  @FindBy(css = "md-dialog")
  public EditInstructionsDialog editInstructionsDialog;

  @FindBy(css = "md-dialog")
  public ManuallyCompleteOrderDialog manuallyCompleteOrderDialog;

  @FindBy(css = "md-dialog")
  public EditOrderStampDialog editOrderStampDialog;

  @FindBy(css = "md-dialog")
  public UpdateStatusDialog updateStatusDialog;

  @FindBy(css = "md-dialog")
  private CancelOrderDialog cancelOrderDialog;

  @FindBy(css = "md-dialog")
  private EditPickupDetailsDialog editPickupDetailsDialog;

  @FindBy(css = "md-dialog")
  public PullFromRouteDialog pullFromRouteDialog;

  @FindBy(css = "md-dialog")
  private EditCashCollectionDetailsDialog editCashCollectionDetailsDialog;

  @FindBy(css = "md-dialog")
  public EditDeliveryVerificationRequiredDialog editDeliveryVerificationRequiredDialog;

  @FindBy(css = "md-dialog")
  public CancelRtsDialog cancelRtsDialog;

  @FindBy(css = "md-dialog")
  public EditRtsDetailsDialog editRtsDetailsDialog;

  @FindBy(css = "md-dialog")
  public ResumeOrderDialog resumeOrderDialog;

  public ChatWithDriverDialog chatWithDriverDialog;

  @FindBy(id = "delivery-details")
  public DeliveryDetailsBox deliveryDetailsBox;

  @FindBy(id = "pickup-details")
  public PickupDetailsBox pickupDetailsBox;

  @FindBy(xpath = "//label[text()='Total']/following-sibling::p")
  public PageElement totalPrice;

  @FindBy(xpath = "//label[text()='Delivery Fee']/following-sibling::p")
  public PageElement deliveryFee;

  @FindBy(xpath = "//label[text()='COD Fee']/following-sibling::p")
  public PageElement codFee;

  @FindBy(xpath = "//label[text()='Insurance Fee']/following-sibling::p")
  public PageElement insuranceFee;

  @FindBy(xpath = "//label[text()='Handling Fee']/following-sibling::p")
  public PageElement handlingFee;

  @FindBy(xpath = "//label[text()='RTS Fee']/following-sibling::p")
  public PageElement rtsFee;

  @FindBy(xpath = "//label[text()='GST']/following-sibling::p")
  public PageElement gst;

  @FindBy(xpath = "//label[text()='Insured Value']/following-sibling::p")
  public PageElement insuredValue;

  private EventsTable eventsTable;
  private EditDeliveryDetailsDialog editDeliveryDetailsDialog;
  private DpDropOffSettingDialog dpDropOffSettingDialog;
  private DeleteOrderDialog deleteOrderDialog;
  private PickupRescheduleDialog pickupRescheduleDialog;
  private DeliveryRescheduleDialog deliveryRescheduleDialog;
  private PodDetailsDialog podDetailsDialog;

  public EditOrderPage(WebDriver webDriver) {
    super(webDriver);
    transactionsTable = new TransactionsTable(webDriver);
    eventsTable = new EventsTable(webDriver);
    deliveryRescheduleDialog = new DeliveryRescheduleDialog(webDriver);
    editDeliveryDetailsDialog = new EditDeliveryDetailsDialog(webDriver);
    dpDropOffSettingDialog = new DpDropOffSettingDialog(webDriver);
    deleteOrderDialog = new DeleteOrderDialog(webDriver);
    pickupRescheduleDialog = new PickupRescheduleDialog(webDriver);
    chatWithDriverDialog = new ChatWithDriverDialog(webDriver);
    podDetailsDialog = new PodDetailsDialog(webDriver);
  }

  public EventsTable eventsTable() {
    return eventsTable;
  }

  public PodDetailsDialog podDetailsDialog() {
    return podDetailsDialog;
  }

  public TransactionsTable transactionsTable() {
    return transactionsTable;
  }

  public void openPage(long orderId) {
    getWebDriver().get(f("%s/%s/order/%d", TestConstants.OPERATOR_PORTAL_BASE_URL,
        StandardTestConstants.COUNTRY_CODE.toLowerCase(), orderId));
    pause1s();
    closeDialogIfVisible();
    waitUntilInvisibilityOfLoadingOrder();
  }

  public void clickMenu(String parentMenuName, String childMenuName) {
    menuBar.selectOption(parentMenuName, childMenuName);
  }

  public boolean isMenuItemEnabled(String parentMenuName, String childMenuName) {
    return menuBar.isOptionEnabled(parentMenuName, childMenuName);
  }

  public void editOrderDetails(Order order) {
    String parcelSize = getParcelSizeShortStringByLongString(order.getParcelSize());
    Dimension dimension = order.getDimensions();

    editOrderDetailsDialog.waitUntilVisible();
    editOrderDetailsDialog.parcelSize.selectValue(parcelSize);
    editOrderDetailsDialog.weight.setValue(dimension.getWeight());
    editOrderDetailsDialog.saveChanges.clickAndWaitUntilDone();
    waitUntilInvisibilityOfToast("Current order updated successfully", true);
  }

  public void editOrderInstructions(String pickupInstruction, String deliveryInstruction) {
    editInstructionsDialog.waitUntilVisible();
    if (pickupInstruction != null) {
      editInstructionsDialog.pickupInstruction.setValue(pickupInstruction);
    }
    if (deliveryInstruction != null) {
      editInstructionsDialog.deliveryInstruction.setValue(deliveryInstruction);
    }
    editInstructionsDialog.saveChanges.clickAndWaitUntilDone();
    waitUntilInvisibilityOfToast("Instructions Updated", true);
  }

  public void editPriorityLevel(int priorityLevel) {
    if (!StringUtils.equalsIgnoreCase(currentPriority.getText(), String.valueOf(priorityLevel))) {
      clickMenu("Order Settings", "Edit Priority Level");
      editPriorityLevelDialog.waitUntilVisible();
      editPriorityLevelDialog.priorityLevel.setValue(priorityLevel);
      editPriorityLevelDialog.saveChanges.clickAndWaitUntilDone();
      editPriorityLevelDialog.waitUntilInvisible();
    }
  }

  public void editOrderStamp(String stampId) {
    clickMenu("Order Settings", "Edit Order Stamp");
    editOrderStampDialog.waitUntilVisible();
    editOrderStampDialog.stampId.setValue(stampId);
    editOrderStampDialog.save.clickAndWaitUntilDone();
    waitUntilInvisibilityOfToast(String.format("Stamp ID updated successfully: %s", stampId), true);
    waitUntilInvisibilityOfMdDialogByTitle("Edit Order Stamp");
  }

  public void editOrderStampToExisting(String existingStampId, String trackingId) {
    clickMenu("Order Settings", "Edit Order Stamp");
    editOrderStampDialog.waitUntilVisible();
    editOrderStampDialog.stampId.setValue(existingStampId);
    editOrderStampDialog.save.clickAndWaitUntilDone();
    waitUntilInvisibilityOfToast(
        String.format("Stamp %s exists in order %s", existingStampId, trackingId), true);
    editOrderStampDialog.sendKeys(Keys.ESCAPE);
    editOrderStampDialog.waitUntilInvisible();
  }

  public void removeOrderStamp() {
    clickMenu("Order Settings", "Edit Order Stamp");
    editOrderStampDialog.waitUntilVisible();
    editOrderStampDialog.remove.clickAndWaitUntilDone();
    waitUntilInvisibilityOfToast("Stamp ID removed successfully", true);
  }

  public void manuallyCompleteOrder() {
    clickMenu("Order Settings", "Manually Complete Order");
    waitUntilVisibilityOfElementLocated("//md-dialog-content[contains(@id,'dialogContent')]");
    click("//button[contains(@id,'button-api-text') and contains(@aria-label,'Complete Order')]");
    waitUntilVisibilityOfToast("The order has been completed");
    waitUntilInvisibilityOfToast("The order has been completed");
  }

  public void addToRoute(long routeId, String type) {
    clickMenu("Pickup", "Add To Route");
    addToRouteDialog.waitUntilVisible();
    addToRouteDialog.route.setValue(routeId);
    addToRouteDialog.type.selectValue(type);
    addToRouteDialog.addToRoute.clickAndWaitUntilDone();
    addToRouteDialog.waitUntilInvisible();
  }

  public void verifyDeliveryStartDateTime(String expectedDate) {
    assertEquals("Delivery Start Date/Time", expectedDate, deliveryDetailsBox.getStartDateTime());
  }

  public void verifyOrderHeaderColor(String color) {
    assertEquals("Order Header Color", color, header.getCssValue("background-color"));
  }

  public void verifyDeliveryEndDateTime(String expectedDate) {
    assertEquals("Delivery End Date/Time", expectedDate, deliveryDetailsBox.getEndDateTime());
  }

  public void verifyDeliveryRouteInfo(Route route) {
    assertThat("Delivery Route Id", deliveryDetailsBox.getRouteId(),
        equalTo(String.valueOf(route.getId())));
    if (CollectionUtils.isNotEmpty(route.getWaypoints())) {
      String expectedWaypointId = String.valueOf(route.getWaypoints().get(0).getId());
      assertThat("Delivery Waypoint ID", deliveryDetailsBox.getWaypointId(),
          equalTo(expectedWaypointId));
    }
    String expectedDriver =
        route.getDriver().getFirstName() + " " + route.getDriver().getLastName();
    assertThat("Delivery Driver", deliveryDetailsBox.getDriver(), equalTo(expectedDriver));
  }

  public void verifyPickupRouteInfo(Route route) {
    assertThat("Pickup Route Id", pickupDetailsBox.getRouteId(),
        equalTo(String.valueOf(route.getId())));
    if (CollectionUtils.isNotEmpty(route.getWaypoints())) {
      String expectedWaypointId = String.valueOf(route.getWaypoints().get(0).getId());
      assertThat("Pickup Waypoint ID", pickupDetailsBox.getWaypointId(),
          equalTo(expectedWaypointId));
    }
    String expectedDriver =
        route.getDriver().getFirstName() + " " + route.getDriver().getLastName();
    assertThat("Pickup Driver", pickupDetailsBox.getDriver(), equalTo(expectedDriver));
  }

  public void verifyOrderSummary(Order order) {
    assertEquals("Order Summary: Comments", order.getComments(), getOrderComments());
  }

  public String getOrderComments() {
    return getText("//div[@class='data-block'][label[.='Comments']]/p");
  }

  public void printAirwayBill() {
    clickMenu("View/Print", "Print Airway Bill");
    waitUntilInvisibilityOfToast("Attempting to download", true);
    waitUntilInvisibilityOfToast("Downloading");
  }

  public void cancelOrder(String cancellationReason) {
    clickMenu("Order Settings", "Cancel Order");
    cancelOrderDialog.waitUntilVisible();
    cancelOrderDialog.cancellationReason.setValue(cancellationReason);
    cancelOrderDialog.cancelOrder.clickAndWaitUntilDone();
    waitUntilInvisibilityOfToast("1 order(s) cancelled");
  }

  public void verifyAirwayBillContentsIsCorrect(Order order) {
    String trackingId = order.getTrackingId();
    String latestFilenameOfDownloadedPdf = getLatestDownloadedFilename("awb_" + trackingId);
    verifyFileDownloadedSuccessfully(latestFilenameOfDownloadedPdf);
    AirwayBill airwayBill = PdfUtils
        .getOrderInfoFromAirwayBill(TestConstants.TEMP_DIR + latestFilenameOfDownloadedPdf, 0);

    assertEquals("Tracking ID", trackingId, airwayBill.getTrackingId());

    assertEquals("From Name", order.getFromName(), airwayBill.getFromName());
    assertEquals("From Contact", order.getFromContact(), airwayBill.getFromContact());
    assertThat("From Address", airwayBill.getFromAddress(),
        containsString(order.getFromAddress1()));
    assertThat("From Address", airwayBill.getFromAddress(),
        containsString(order.getFromAddress2()));
    assertThat("Postcode In From Address", airwayBill.getFromAddress(),
        containsString(order.getFromPostcode()));

    assertEquals("To Name", order.getToName(), airwayBill.getToName());
    assertEquals("To Contact", order.getToContact(), airwayBill.getToContact());
    assertThat("To Address", airwayBill.getToAddress(), containsString(order.getToAddress1()));
    assertThat("To Address", airwayBill.getToAddress(), containsString(order.getToAddress2()));
    assertThat("Postcode In To Address", airwayBill.getToAddress(),
        containsString(order.getToPostcode()));

    assertEquals("COD", Optional.ofNullable(order.getCod()).orElse(new Cod()).getGoodsAmount(),
        airwayBill.getCod());
    assertEquals("Comments", order.getInstruction(), airwayBill.getComments());

    String actualQrCodeTrackingId = TestUtils
        .getTextFromQrCodeImage(airwayBill.getTrackingIdQrCodeFile());
    assertEquals("Tracking ID - QR Code", trackingId, actualQrCodeTrackingId);

    String actualBarcodeTrackingId = TestUtils
        .getTextFromQrCodeImage(airwayBill.getTrackingIdBarcodeFile());
    assertEquals("Tracking ID - Barcode 128", trackingId, actualBarcodeTrackingId);
  }

  public void verifyPriorityLevel(String txnType, int priorityLevel) {
    transactionsTable.filterByColumn(COLUMN_TYPE, txnType);
    TransactionInfo actual = transactionsTable.readEntity(1);
    assertEquals(txnType + " Priority Level", String.valueOf(priorityLevel),
        actual.getPriorityLevel());
  }

  public void verifyOrderInstructions(String expectedPickupInstructions,
      String expectedDeliveryInstructions) {
    if (expectedPickupInstructions != null) {
      String actualPickupInstructions = pickupDetailsBox.pickupInstructions.getText();
      assertThat("Pick Up Instructions", expectedPickupInstructions,
          equalToIgnoringCase(actualPickupInstructions));
    }
    if (expectedDeliveryInstructions != null) {
      String actualDeliveryInstructions = deliveryDetailsBox.deliveryInstructions.getText();
      assertThat("Delivery Instructions", expectedDeliveryInstructions,
          equalToIgnoringCase(actualDeliveryInstructions));
    }
  }

  public void confirmCompleteOrder() {
    String changeReason = f("This reason is created by automation at %s.",
        CREATED_DATE_SDF.format(new Date()));
    manuallyCompleteOrderDialog.waitUntilVisible();
    manuallyCompleteOrderDialog.changeReason.setValue(changeReason);
    manuallyCompleteOrderDialog.completeOrder.clickAndWaitUntilDone();
    waitUntilInvisibilityOfToast("The order has been completed", true);
  }

  public void verifyEditOrderDetailsIsSuccess(Order editedOrder) {
    Dimension expectedDimension = editedOrder.getDimensions();
    assertEquals("Order Details - Size", editedOrder.getParcelSize(), size.getText());
    assertEquals("Order Details - Weight", expectedDimension.getWeight(), getWeight());
  }

  public void verifyInboundIsSucceed() {
    String actualLatestEvent = getTextOnTableEvent(1, COLUMN_CLASS_DATA_NAME_ON_TABLE_EVENT);
    assertThat("Different Result Returned", actualLatestEvent,
        isOneOf("Van Inbound Scan", "DRIVER INBOUND SCAN"));
  }

  public void verifyEvent(Order order, String hubName, String hubId, String eventNameExpected,
      String stringContained) {
    ZonedDateTime eventDateExpected = DateUtil
        .getDate(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE));

    int rowWithExpectedEvent = 1;
    for (int i = 1; i <= eventsTable.getRowsCount(); i++) {
      String eventNameActual = getTextOnTableEvent(i, EVENT_NAME);
      if (eventNameExpected.equals(eventNameActual)) {
        rowWithExpectedEvent = i;
      }
    }
    OrderEvent eventRow = eventsTable.readEntity(rowWithExpectedEvent);
    assertEquals("Different Result Returned for hub name", hubName, eventRow.getHubName());
//        assertThat("Different Result Returned for event description", eventRow.getDescription(), containsString(f("Parcel inbound at Origin Hub - %s", hubName)));
    assertThat("Different Result Returned for event time",
        eventRow.getEventTime(),
        containsString(DateUtil.displayDate(eventDateExpected)));
    if (stringContained.contains("Scanned")) {
      assertThat("Different Result Returned for event description", eventRow.getDescription(),
          containsString(f("%s at Hub %s", stringContained, hubId)));
      return;
    }
    assertThat("Different Result Returned for event description", eventRow.getDescription(),
        containsString(stringContained));
  }

  public void verifyOrderInfoIsCorrect(Order order) {
    String expectedTrackingId = order.getTrackingId();

    assertEquals("Tracking ID", expectedTrackingId, trackingId.getText());
    assertThat("Status", status.getText(), equalToIgnoringCase(order.getStatus()));
    assertThat("Granular Status", granular.getText(),
        equalToIgnoringCase(order.getGranularStatus().replaceFirst("_", " ")));
    assertThat("Shipper ID", shipperId.getText(),
        containsString(String.valueOf(order.getShipper().getId())));
    assertEquals("Order Type", order.getType(), orderType.getText());
    assertEquals("Size", order.getParcelSize(), size.getText());
    assertEquals("Weight", order.getWeight(), getWeight(), 0.0);

    Transaction pickupTransaction = order.getTransactions().get(0);
    assertEquals("Pickup Status", pickupTransaction.getStatus(), pickupDetailsBox.getStatus());

    Transaction deliveryTransaction = order.getTransactions().get(1);
    assertEquals("Delivery Status", deliveryTransaction.getStatus(),
        deliveryDetailsBox.getStatus());

    verifyPickupAndDeliveryInfo(order);
  }

  public void verifyOrderStatus(String expectedStatus) {
    assertThat("Status", status.getText(), equalToIgnoringCase(expectedStatus));
  }

  public void verifyOrderGranularStatus(String expectedGranularStatus) {
    assertThat("Granular Status", granular.getText(), equalToIgnoringCase(expectedGranularStatus));
  }

  public void verifyOrderDeliveryTitle(String expectedDeliveryTitle) {
    assertThat("Delivery Title", getDeliveryTitle(), equalToIgnoringCase(expectedDeliveryTitle));
  }

  public void verifyOrderDeliveryStatus(String expectedDeliveryStatus) {
    assertThat("Delivery Status", deliveryDetailsBox.getStatus(),
        equalToIgnoringCase(expectedDeliveryStatus));
  }

  public void verifyOrderIsForceSuccessedSuccessfully(Order order) {
    String expectedTrackingId = order.getTrackingId();

    assertEquals("Tracking ID", expectedTrackingId, trackingId.getText());
    assertThat("Status", status.getText(), equalToIgnoringCase("Completed"));
    assertThat("Granular Status", granular.getText(), equalToIgnoringCase("Completed"));

    Long shipperId = order.getShipper().getId();

    if (shipperId != null) {
      assertThat("Shipper ID", this.shipperId.getText(), containsString(String.valueOf(shipperId)));
    }

    assertEquals("Order Type", order.getType(), orderType.getText());
    //Assert.assertThat("Latest Event", getLatestEvent(), Matchers.containsString("Order Force Successed")); //Disabled because somehow the latest event name is always 'PRICING_CHANGE' and the value on Latest Event is '-'.
    assertEquals("Pickup Status", "SUCCESS", pickupDetailsBox.getStatus());
    assertEquals("Delivery Status", "SUCCESS", deliveryDetailsBox.getStatus());

    verifyPickupAndDeliveryInfo(order);
  }

  public void verifyPickupAndDeliveryInfo(Order order) {
    // Pickup
    verifyPickupInfo(order);
    // Delivery
    verifyDeliveryInfo(order);
  }

  public void verifyPickupInfo(Order order) {
    // Pickup
    assertEquals("From Name", order.getFromName(), pickupDetailsBox.from.getText());
    assertEquals("From Email", order.getFromEmail(), pickupDetailsBox.fromEmail.getText());
    assertEquals("From Contact", order.getFromContact(), pickupDetailsBox.fromContact.getText());
    String fromAddress = pickupDetailsBox.fromAddress.getText();
    assertThat("From Address", fromAddress, containsString(order.getFromAddress1()));
    assertThat("From Address", fromAddress, containsString(order.getFromAddress2()));
  }

  public void verifyDeliveryInfo(Order order) {
    assertEquals("To Name", order.getToName(), deliveryDetailsBox.to.getText());
    assertEquals("To Email", order.getToEmail(), deliveryDetailsBox.toEmail.getText());
    assertEquals("To Contact", order.getToContact(), deliveryDetailsBox.toContact.getText());
    String toAddress = deliveryDetailsBox.toAddress.getText();
    assertThat("To Address", toAddress, containsString(order.getToAddress1()));
    assertThat("To Address", toAddress, containsString(order.getToAddress2()));
  }

  public void verifyOrderIsGlobalInboundedSuccessfully(Order order,
      GlobalInboundParams globalInboundParams, Double expectedOrderCost, String expectedStatus,
      List<String> expectedGranularStatus, String expectedDeliveryStatus) {
    if (isElementExistFast("//nv-icon-text-button[@name='container.order.edit.show-more']")) {
      clickNvIconTextButtonByName("container.order.edit.show-more");
    }

    String expectedTrackingId = order.getTrackingId();
    assertEquals("Tracking ID", expectedTrackingId, trackingId.getText());

    if (StringUtils.isNotBlank(expectedStatus)) {
      assertThat(String.format("Status - [Tracking ID = %s]", expectedTrackingId), status.getText(),
          equalToIgnoringCase(expectedStatus));
    }

    if (CollectionUtils.isNotEmpty(expectedGranularStatus)) {
      assertThat(String.format("Granular Status - [Tracking ID = %s]", expectedTrackingId),
          granular.getText(), isIn(expectedGranularStatus));
    }

    assertEquals("Pickup Status", "SUCCESS", pickupDetailsBox.getStatus());

    if (StringUtils.isNotBlank(expectedDeliveryStatus)) {
      assertThat("Delivery Status", deliveryDetailsBox.getStatus(),
          equalToIgnoringCase(expectedDeliveryStatus));
    }

    // There is an issue where after Global Inbound the new Size is not applied. KH need to fix this.
    // Uncomment this line below if KH has fixed it.
        /*if(globalInboundParams.getOverrideSize()!=null)
        {
            Assert.assertEquals("Size", getParcelSizeAsLongString(globalInboundParams.getOverrideSize()), getSize());
        }*/

    if (globalInboundParams.getOverrideWeight() != null) {
      assertEquals("Weight", globalInboundParams.getOverrideWeight(), getWeight());
    }

    if (globalInboundParams.getOverrideDimHeight() != null
        && globalInboundParams.getOverrideDimWidth() != null
        && globalInboundParams.getOverrideDimLength() != null) {
      Dimension actualDimension = getDimension();
      assertEquals("Dimension - Height", globalInboundParams.getOverrideDimHeight(),
          actualDimension.getHeight());
      assertEquals("Dimension - Width", globalInboundParams.getOverrideDimWidth(),
          actualDimension.getWidth());
      assertEquals("Dimension - Length", globalInboundParams.getOverrideDimLength(),
          actualDimension.getLength());
    }

    if (expectedOrderCost != null) {
      Double total = getTotal();
      String totalAsString = null;

      if (total != null) {
        totalAsString = NO_TRAILING_ZERO_DF.format(total);
      }

      assertEquals("Cost", NO_TRAILING_ZERO_DF.format(expectedOrderCost), totalAsString);
    }
  }

  public void verifyPickupDetailsInTransaction(Order order, String txnType) {
    transactionsTable.filterByColumn(COLUMN_TYPE, txnType);
    TransactionInfo actual = transactionsTable.readEntity(1);
    assertEquals("From Name", order.getFromName(), actual.getName());
    assertEquals("From Email", order.getFromEmail(), actual.getEmail());
    assertEquals("From Contact", order.getFromContact(), actual.getContact());
    assertThat("From Address", actual.getDestinationAddress(),
        containsString(order.getFromAddress1()));
    assertThat("From Address", actual.getDestinationAddress(),
        containsString(order.getFromAddress2()));
  }

  public void verifyDeliveryDetailsInTransaction(Order order, String txnType) {
    transactionsTable.filterByColumn(COLUMN_TYPE, txnType);
    TransactionInfo actual = transactionsTable.readEntity(1);
    assertEquals("To Name", order.getToName(), actual.getName());
    assertEquals("To Email", order.getToEmail(), actual.getEmail());
    assertEquals("To Contact", order.getToContact(), actual.getContact());
    assertThat("To Address", actual.getDestinationAddress(), containsString(order.getToAddress1()));
    assertThat("To Address", actual.getDestinationAddress(), containsString(order.getToAddress1()));
  }

  public String getDeliveryTitle() {
    return getText("//*[@id='delivery-details']/div/div[1]/h5");
  }

  public String getTag() {
    return getText("//nv-tag[@ng-repeat='tag in ctrl.orderTags']/*");
  }

  public List<String> getTags() {
    List<String> tags = new ArrayList<>();
    List<WebElement> listOfTags = findElementsByXpath(
        "//div[@id='order-tags-container']/nv-tag/span");
    for (WebElement we : listOfTags) {
      tags.add(we.getText());
    }
    return tags;
  }

  @SuppressWarnings("unused")
  public String getLatestEvent() {
    return getText("//label[text()='Latest Event']/following-sibling::h3");
  }

  public Double getWeight() {
    Double weight = null;
    String actualText = this.weight.getText();

    if (!actualText.contains("-")) {
      String temp = actualText.replace("kg", "").trim();
      weight = Double.parseDouble(temp);
    }

    return weight;
  }

  @SuppressWarnings("unused")
  public Double getCashOnDelivery() {
    Double cod = null;
    String actualText = getText("//label[text()='Cash on Delivery']/following-sibling::p");

    if (!actualText.contains("-")) {
      String temp = actualText.substring(3); //Remove currency text (e.g. SGD)
      cod = Double.parseDouble(temp);
    }

    return cod;
  }

  public Dimension getDimension() {
    Dimension dimension = new Dimension();
    String actualText = getText("//label[text()='Dimensions']/following-sibling::p");

    if (!actualText.contains("-") && !actualText.contains("x x cm") && !actualText
        .contains("(L) x (B) x (H) cm")) {
      String temp = actualText.replace("cm", "");
      String[] dims = temp.split("x");
      Double height = Double.parseDouble(dims[1]);
      Double width = Double.parseDouble(dims[0]);
      Double length = Double.parseDouble(dims[2]);
      dimension = new Dimension();
      dimension.setHeight(height);
      dimension.setWidth(width);
      dimension.setLength(length);
    }

    return dimension;
  }

  public Double getTotal() {
    Double total = null;
    String actualText = totalPrice.getText();

    if (!actualText.contains("-")) {
      String temp = actualText.substring(3); //Remove currency text (e.g. SGD)
      total = Double.parseDouble(temp);
    }

    return total;
  }

  public String getStampId() {
    return getText("//div[@class='data-block']/label[text()='Stamp ID']/following-sibling::p");
  }

  public void waitUntilInvisibilityOfLoadingOrder() {
    waitUntilInvisibilityOfElementLocated(
        "//md-content[@loading-message='Loading order...']/div[contains(@class, 'loading')]");
    pause100ms();
  }

  public String getTextOnTableEvent(int rowNumber, String columnDataClass) {
    return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT_TABLE_EVENT);
  }

  public void verifiesOrderIsTaggedToTheRecommendedRouteId() {
    TransactionInfo actual = transactionsTable.readEntity(2);
    assertTrue("Order is not tagged to any route: ", StringUtils.isNotBlank(actual.getRouteId()));
  }

  public void updatePickupDetails(Map<String, String> mapOfData) {
    String senderName = mapOfData.get("senderName");
    String senderContact = mapOfData.get("senderContact");
    String senderEmail = mapOfData.get("senderEmail");
    String internalNotes = mapOfData.get("internalNotes");
    String pickupDate = mapOfData.get("pickupDate");
    String pickupTimeslot = mapOfData.get("pickupTimeslot");
    String country = mapOfData.get("country");
    String city = mapOfData.get("city");
    String address1 = mapOfData.get("address1");
    String address2 = mapOfData.get("address2");
    String postalCode = mapOfData.get("postalCode");

    editPickupDetailsDialog.senderName.setValue(senderName);
    editPickupDetailsDialog.senderContact.setValue(senderContact);
    editPickupDetailsDialog.senderEmail.setValue(senderEmail);
    editPickupDetailsDialog.internalNotes.setValue(internalNotes);
    editPickupDetailsDialog.pickupDate.simpleSetValue(pickupDate);
    editPickupDetailsDialog.pickupTimeslot.selectValue(pickupTimeslot);
    editPickupDetailsDialog.changeAddress.click();
    editPickupDetailsDialog.country.setValue(country);
    editPickupDetailsDialog.city.setValue(city);
    editPickupDetailsDialog.address1.setValue(address1);
    editPickupDetailsDialog.address2.setValue(address2);
    editPickupDetailsDialog.postcode.setValue(postalCode);
    editPickupDetailsDialog.saveChanges.clickAndWaitUntilDone();
    waitUntilInvisibilityOfToast("Pickup Details Updated", false);
  }

  public void updateDeliveryDetails(Map<String, String> mapOfData) {
    String recipientName = mapOfData.get("recipientName");
    String recipientContact = mapOfData.get("recipientContact");
    String recipientEmail = mapOfData.get("recipientEmail");
    String internalNotes = mapOfData.get("internalNotes");
    String changeSchedule = mapOfData.get("changeSchedule");
    String deliveryDate = mapOfData.get("deliveryDate");
    String deliveryTimeslot = mapOfData.get("deliveryTimeslot");
    String country = mapOfData.get("country");
    String city = mapOfData.get("city");
    String address1 = mapOfData.get("address1");
    String address2 = mapOfData.get("address2");
    String postalCode = mapOfData.get("postalCode");

    editDeliveryDetailsDialog
        .updateRecipientName(recipientName)
        .updateRecipientContact(recipientContact)
        .updateRecipientEmail(recipientEmail)
        .updateInternalNotes(internalNotes)
        .clickChangeSchedule()
        .updateDeliveryDate(deliveryDate)
        .updateDeliveryTimeslot(deliveryTimeslot)
        .clickChangeAddress()
        .updateCountry(country)
        .updateCity(city)
        .updateAddress1(address1)
        .updateAddress2(address2)
        .updatePostalCode(postalCode)
        .clickSaveChanges();
    editDeliveryDetailsDialog.confirmPickupDetailsUpdated();
  }

  public void reschedulePickup(Map<String, String> mapOfData) {
    String senderName = mapOfData.get("senderName");
    String senderContact = mapOfData.get("senderContact");
    String senderEmail = mapOfData.get("senderEmail");
    String pickupDate = mapOfData.get("pickupDate");
    String pickupTimeslot = mapOfData.get("pickupTimeslot");
    String country = mapOfData.get("country");
    String city = mapOfData.get("city");
    String address1 = mapOfData.get("address1");
    String address2 = mapOfData.get("address2");
    String postalCode = mapOfData.get("postalCode");

    pickupRescheduleDialog
        .waitUntilVisibility()
        .updateSenderName(senderName)
        .updateSenderContact(senderContact)
        .updateSenderEmail(senderEmail)
        .updatePickupDate(pickupDate)
        .updatePickupTimeslot(pickupTimeslot)
        .clickChangeAddress()
        .updateCountry(country)
        .updateCity(city)
        .updateAddress1(address1)
        .updateAddress2(address2)
        .updatePostalCode(postalCode)
        .clickSaveChanges();
    pickupRescheduleDialog.confirmPickupRescheduledUpdated();
  }

  public void rescheduleDelivery(Map<String, String> mapOfData) {
    String recipientName = mapOfData.get("recipientName");
    String recipientContact = mapOfData.get("recipientContact");
    String recipientEmail = mapOfData.get("recipientEmail");
    String deliveryDate = mapOfData.get("deliveryDate");
    String deliveryTimeslot = mapOfData.get("deliveryTimeslot");
    String country = mapOfData.get("country");
    String city = mapOfData.get("city");
    String address1 = mapOfData.get("address1");
    String address2 = mapOfData.get("address2");
    String postalCode = mapOfData.get("postalCode");

    deliveryRescheduleDialog
        .waitUntilVisibility()
        .updateRecipientName(recipientName)
        .updateRecipientContact(recipientContact)
        .updateRecipientEmail(recipientEmail)
        .updateDeliveryDate(deliveryDate)
        .updateDeliveryTimeslot(deliveryTimeslot)
        .clickChangeAddress()
        .updateCountry(country)
        .updateCity(city)
        .updateAddress1(address1)
        .updateAddress2(address2)
        .updatePostalCode(postalCode)
        .clickSaveChanges();
    deliveryRescheduleDialog.confirmOrderDeliveryRescheduledUpdated();
  }

  public static class TransactionsTable extends NgRepeatTable<TransactionInfo> {

    public static final String COLUMN_TYPE = "type";

    public TransactionsTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("serviceEndTime", "_service-end-time")
          .put(COLUMN_TYPE, "type")
          .put("status", "status")
          .put("driver", "_driver")
          .put("routeId", "route-id")
          .put("routeDate", "_route-date")
          .put("dpId", "distribution-point-id")
          .put("failureReason", "failure_reason_code")
          .put("priorityLevel", "priority-level")
          .put("dnr", "dnr")
          .put("name", "name")
          .put("contact", "contact")
          .put("email", "email")
          .put("destinationAddress", "_address")
          .build());
      setNgRepeat("transaction in getTableData()");
      setEntityClass(TransactionInfo.class);
    }
  }

  /**
   * Accessor for Events table
   */
  public static class EventsTable extends NgRepeatTable<OrderEvent> {

    public static final String NG_REPEAT = "event in getTableData()";
    public static final String DATE_TIME = "eventTime";
    public static final String EVENT_TAGS = "tags";
    public static final String EVENT_NAME = "name";
    public static final String USER_TYPE = "userType";
    public static final String USER_ID = "user";
    public static final String SCAN_ID = "scanId";
    public static final String ROUTE_ID = "routeId";
    public static final String HUB_NAME = "hubName";
    public static final String DESCRIPTION = "description";

    public EventsTable(WebDriver webDriver) {
      super(webDriver);
      setNgRepeat(NG_REPEAT);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(DATE_TIME, "_event_time")
          .put(EVENT_TAGS, "_tags")
          .put(EVENT_NAME, "name")
          .put(USER_TYPE, "user_type")
          .put(USER_ID, "_user")
          .put(SCAN_ID, "_scan_id")
          .put(ROUTE_ID, "_route_id")
          .put(HUB_NAME, "_hub_name")
          .put(DESCRIPTION, "_description")
          .build());
      setEntityClass(OrderEvent.class);
    }

    public void verifyUpdatePickupAddressEventDescription(Order order, String eventDescription) {
      String fromAddress1Pattern = f("From Address 1 .* (to|new value) %s.*",
          order.getFromAddress1());
      String fromAddress2Pattern = f(".* From Address 2 .* (to|new value) %s.*",
          order.getFromAddress2());
      String fromPostcodePattern = f(".* From Postcode .* (to|new value) %s.*",
          order.getFromPostcode());
      String fromCityPattern = f(".* From City .* (to|new value) %s.*", order.getFromCity());
      String fromCountryPattern = f(".* From Country .* (to|new value) %s.*",
          order.getFromCountry());
      assertTrue(f("'%s' pattern is not present in the '%s' event description", fromAddress1Pattern,
          eventDescription),
          eventDescription.matches(fromAddress1Pattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", fromAddress2Pattern,
          eventDescription),
          eventDescription.matches(fromAddress2Pattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", fromPostcodePattern,
          eventDescription),
          eventDescription.matches(fromPostcodePattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", fromCityPattern,
          eventDescription),
          eventDescription.matches(fromCityPattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", fromCountryPattern,
          eventDescription),
          eventDescription.matches(fromCountryPattern));
    }

    public void verifyUpdateDeliveryAddressEventDescription(Order order, String eventDescription) {
      String toAddress1Pattern = f("To Address 1 .* (to|new value) %s.*", order.getToAddress1());
      String toAddress2Pattern = f(".* To Address 2 .* (to|new value) %s.*", order.getToAddress2());
      String toPostcodePattern = f(".* To Postcode .* (to|new value) %s.*", order.getToPostcode());
      String toCityPattern = f(".* To City .* (to|new value) %s.*", order.getToCity());
      String toCountryPattern = f(".* To Country .* (to|new value) %s.*", order.getToCountry());
      assertTrue(f("'%s' pattern is not present in the '%s' event description", toAddress1Pattern,
          eventDescription),
          eventDescription.matches(toAddress1Pattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", toAddress2Pattern,
          eventDescription),
          eventDescription.matches(toAddress2Pattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", toPostcodePattern,
          eventDescription),
          eventDescription.matches(toPostcodePattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", toCityPattern,
          eventDescription),
          eventDescription.matches(toCityPattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", toCountryPattern,
          eventDescription),
          eventDescription.matches(toCountryPattern));
    }

    public void verifyUpdatePickupContactInformationEventDescription(Order order,
        String eventDescription) {
      String fromNamePattern = f("From Name .* (to|new value) %s.*", order.getFromName());
      String fromEmailPattern = f(".* From Email .* (to|new value) %s.*", order.getFromEmail());
      String fromContactPattern = f(".* From Contact .* (to|new value) \\%s.*",
          order.getFromContact());
      assertTrue(f("'%s' pattern is not present in the '%s' event description", fromNamePattern,
          eventDescription),
          eventDescription.matches(fromNamePattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", fromEmailPattern,
          eventDescription),
          eventDescription.matches(fromEmailPattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", fromContactPattern,
          eventDescription),
          eventDescription.matches(fromContactPattern));
    }

    public void verifyUpdateDeliveryContactInformationEventDescription(Order order,
        String eventDescription) {
      String toNamePattern = f("To Name .* (to|new value) %s.*", order.getToName());
      String toEmailPattern = f(".* To Email .* (to|new value) %s.*", order.getToEmail());
      String toContactPattern = f(".* To Contact .* (to|new value) \\%s.*", order.getToContact());
      assertTrue(f("'%s' pattern is not present in the '%s' event description", toNamePattern,
          eventDescription),
          eventDescription.matches(toNamePattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", toEmailPattern,
          eventDescription),
          eventDescription.matches(toEmailPattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", toContactPattern,
          eventDescription),
          eventDescription.matches(toContactPattern));
    }

    public void verifyUpdatePickupSlaEventDescription(Order order, String eventDescription) {
      String fromPickUpStartTimePattern = f("Pickup Start Time .* (to|new value) %s %s.*",
          order.getPickupDate(), order.getPickupTimeslot().getStartTime());
      String fromPickUpEndTimePattern = f(".* Pickup End Time .* (to|new value) %s %s.*",
          order.getPickupEndDate(), order.getPickupTimeslot().getEndTime());
      assertTrue(
          f("'%s' pattern is not present in the '%s' event description", fromPickUpStartTimePattern,
              eventDescription),
          eventDescription.matches(fromPickUpStartTimePattern));
      assertTrue(
          f("'%s' pattern is not present in the '%s' event description", fromPickUpEndTimePattern,
              eventDescription),
          eventDescription.matches(fromPickUpEndTimePattern));
    }

    public void verifyUpdateDeliverySlaEventDescription(Order order, String eventDescription) {
      String deliveryStartTimePattern = f("Delivery Start Time .* (to|new value) %s %s.*",
          order.getDeliveryDate(), order.getDeliveryTimeslot().getStartTime());
      String deliveryEndTimePattern = f(".* Delivery End Time .* (to|new value) %s %s.*",
          order.getDeliveryDate(), order.getDeliveryTimeslot().getEndTime());
      assertTrue(
          f("'%s' pattern is not present in the '%s' event description", deliveryStartTimePattern,
              eventDescription),
          eventDescription.matches(deliveryStartTimePattern));
      assertTrue(
          f("'%s' pattern is not present in the '%s' event description", deliveryEndTimePattern,
              eventDescription),
          eventDescription.matches(deliveryEndTimePattern));
    }

    public void verifyPickupAddressEventDescription(Order order, String eventDescription) {
      String addressPattern = f("Address: %s, %s, %s, %s, %s.*", order.getFromAddress1(),
          order.getFromAddress2(),
          order.getFromCity(), order.getFromCountry(), order.getFromPostcode());
      assertTrue(f("'%s' pattern is not present in the '%s' event description", addressPattern,
          eventDescription),
          eventDescription.matches(addressPattern));
    }

    public void verifyDeliveryAddressEventDescription(Order order, String eventDescription) {
      String addressPattern = f("Address: %s, %s, %s, %s, %s.*", order.getToAddress1(),
          order.getToAddress2(),
          order.getToCity(), order.getToCountry(), order.getToPostcode());
      assertTrue(f("'%s' pattern is not present in the '%s' event description", addressPattern,
          eventDescription),
          eventDescription.matches(addressPattern));
    }

    public void verifyVerifyUpdateCashDescription(Order order, String eventDescription) {
      String cashPattern = null;
      if (String.valueOf(order.getCod().getGoodsAmount()) == null) {
        cashPattern = f("Cash On Delivery changed from 0 to .*", order.getCod().getGoodsAmount());
        assertTrue(f("'%s' pattern is not present in the '%s' event description", cashPattern,
            eventDescription),
            eventDescription.matches(cashPattern));
      } else {
        cashPattern = f("Cash On Delivery changed from %s to .*", order.getCod().getGoodsAmount());
        assertTrue(f("'%s' pattern is not present in the '%s' event description", cashPattern,
            eventDescription),
            eventDescription.matches(cashPattern));
      }
    }

    public void verifyHubInboundEventDescription(Order order, String eventDescription) {
      String widthPattern = f(".* Width changed from .* to %s.*",
          order.getDimensions().getWidth().intValue());
      String lengthPattern = f(".* Length changed from .* to %s.*",
          order.getDimensions().getLength().intValue());
      String heightPattern = f(".* Height changed from .* to %s.*",
          order.getDimensions().getHeight().intValue());
      assertTrue(
          f("'%s' pattern is not present in the '%s' event description", widthPattern,
              eventDescription),
          eventDescription.matches(widthPattern));
      assertTrue(
          f("'%s' pattern is not present in the '%s' event description", lengthPattern,
              eventDescription),
          eventDescription.matches(lengthPattern));
      assertTrue(
          f("'%s' pattern is not present in the '%s' event description", heightPattern,
              eventDescription),
          eventDescription.matches(heightPattern));
    }

    public void verifyHubInboundWithDeviceIdEventDescription(Order order, String eventDescription) {
      String deviceIdPattern = null;

      deviceIdPattern = f(".* Device Id: 12345 .*");
      assertTrue(f("'%s' pattern is not present in the '%s' event description", deviceIdPattern,
          eventDescription),
          eventDescription.matches(deviceIdPattern));
    }
  }

  public void tagOrderToDP(String dpId) {
    dpDropOffSettingDialog.selectDpValue(dpId);
    List<String> dpDropOffDates = dpDropOffSettingDialog.getListOfDropOffDates();
    dpDropOffSettingDialog
        .selectDropOffDateValue(dpDropOffDates.get((int) (Math.random() * dpDropOffDates.size())));
    dpDropOffSettingDialog.saveChanges();
    dpDropOffSettingDialog.confirmOrderIsTagged();
  }

  public void untagOrderFromDP() {
    dpDropOffSettingDialog.clearSelectedDropOffValue();
    dpDropOffSettingDialog.saveChanges();
    dpDropOffSettingDialog.confirmOrderIsTagged();
  }

  public boolean deliveryIsIndicatedWithIcon() {
    return deliveryDetailsBox.isNinjaCollectTagPresent();
  }

  public void deleteOrder() {
    deleteOrderDialog.waitUntilVisibility();
    deleteOrderDialog.enterPassword();
    deleteOrderDialog.clickDeleteOrderButton();
    deleteOrderDialog.confirmOrderIsDeleted();
  }

  /**
   * Accessor for Cancel dialog
   */
  public static class CancelOrderDialog extends MdDialog {

    public CancelOrderDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[id^='container.order.edit.cancellation-reason']")
    public TextBox cancellationReason;

    @FindBy(name = "container.order.edit.cancel-order")
    public NvApiTextButton cancelOrder;
  }

  /**
   * Accessor for Delivery Details box
   */
  public static class DeliveryDetailsBox extends PageElement {

    @FindBy(css = "h5.nv-text-right")
    public PageElement status;
    @FindBy(xpath = "./div[2]/div/div/div[1]/div/div/h5")
    public PageElement to;
    @FindBy(xpath = "./div[2]/div/div/div[2]/div[1]/span")
    public PageElement toEmail;
    @FindBy(xpath = "./div[2]/div/div/div[2]/div[2]/span")
    public PageElement toContact;
    @FindBy(xpath = "./div[2]/div/div/div[2]/div[3]/span")
    public PageElement toAddress;
    @FindBy(xpath = ".//div[label[.='Start Date / Time']]/p")
    public PageElement startDateTime;
    @FindBy(xpath = ".//div[label[.='End Date / Time']]/p")
    public PageElement endDateTime;
    @FindBy(xpath = ".//div[label[.='Last Service End']]/p")
    public PageElement lastServiceEnd;
    @FindBy(xpath = ".//div[label[.='Delivery Instructions']]/p")
    public PageElement deliveryInstructions;
    @FindBy(name = "commons.rts")
    public PageElement rtsTag;

    private static final String BOX_LOCATOR = "//div[h5[text()='Delivery Details']]";
    private static final String ROUTE_ID_LOCATOR =
        BOX_LOCATOR + "//div[label[text()='Route Id']]/p";
    private static final String ROUTE_DATE_LOCATOR =
        BOX_LOCATOR + "//div[label[text()='Route Date']]/p";
    private static final String DRIVER_LOCATOR = BOX_LOCATOR + "//div[label[text()='Driver']]/p";
    private static final String WAYPOINT_ID_LOCATOR =
        BOX_LOCATOR + "//div[label[text()='Waypoint ID']]/p";
    private static final String START_DATE_TIME_LOCATOR =
        BOX_LOCATOR + "//div[label[text()='Start Date / Time']]/p";
    private static final String END_DATE_TIME_LOCATOR =
        BOX_LOCATOR + "//div[label[text()='End Date / Time']]/p";
    private static final String NV_TAG_LOCATOR = "//nv-tag[@name='commons.ninja-collect']";

    public DeliveryDetailsBox(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public String getStatus() {
      return status.getText().split(":")[1].trim();
    }

    public String getRouteId() {
      return getText(ROUTE_ID_LOCATOR);
    }

    public String getRouteDate() {
      return getText(ROUTE_DATE_LOCATOR);
    }

    public String getDriver() {
      return getText(DRIVER_LOCATOR);
    }

    public String getWaypointId() {
      return getText(WAYPOINT_ID_LOCATOR);
    }

    public String getStartDateTime() {
      return getText(START_DATE_TIME_LOCATOR);
    }

    public String getEndDateTime() {
      return getText(END_DATE_TIME_LOCATOR);
    }

    public boolean isNinjaCollectTagPresent() {
      return isElementExist(NV_TAG_LOCATOR);
    }
  }

  /**
   * Accessor for Pickup Details box
   */
  public static class PickupDetailsBox extends PageElement {

    @FindBy(css = "h5.nv-text-right")
    public PageElement status;
    @FindBy(xpath = "./div[2]/div/div/div[1]/div/div/h5")
    public PageElement from;
    @FindBy(xpath = "./div[2]/div/div/div[2]/div[1]/span")
    public PageElement fromEmail;
    @FindBy(xpath = "./div[2]/div/div/div[2]/div[2]/span")
    public PageElement fromContact;
    @FindBy(xpath = "./div[2]/div/div/div[2]/div[3]/span")
    public PageElement fromAddress;
    @FindBy(xpath = ".//div[label[.='Start Date / Time']]/p")
    public PageElement startDateTime;
    @FindBy(xpath = ".//div[label[.='End Date / Time']]/p")
    public PageElement endDateTime;
    @FindBy(xpath = ".//div[label[.='Last Service End']]/p")
    public PageElement lastServiceEnd;
    @FindBy(xpath = ".//div[label[.='Pick Up Instructions']]/p")
    public PageElement pickupInstructions;

    private static final String ROUTE_ID_LOCATOR = "//div[h5[text()='Pickup Details']]//div[label[text()='Route Id']]/p";
    private static final String ROUTE_DATE_LOCATOR = "//div[h5[text()='Pickup Details']]//div[label[text()='Route Date']]/p";
    private static final String DRIVER_LOCATOR = "//div[h5[text()='Pickup Details']]//div[label[text()='Driver']]/p";
    private static final String WAYPOINT_ID_LOCATOR = "//div[h5[text()='Pickup Details']]//div[label[text()='Waypoint ID']]/p";

    public PickupDetailsBox(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public String getStatus() {
      return status.getText().split(":")[1].trim();
    }

    public String getRouteId() {

      return getText(ROUTE_ID_LOCATOR);
    }

    public String getRouteDate() {

      return getText(ROUTE_DATE_LOCATOR);
    }

    public String getDriver() {

      return getText(DRIVER_LOCATOR);
    }

    public String getWaypointId() {

      return getText(WAYPOINT_ID_LOCATOR);
    }
  }

  /**
   * Accessor for Edit Pickup Details dialog
   */
  public static class EditPickupDetailsDialog extends MdDialog {

    @FindBy(css = "[id^='commons.sender-name']")
    public TextBox senderName;

    @FindBy(css = "[id^='commons.sender-contact']")
    public TextBox senderContact;

    @FindBy(css = "[id^='commons.sender-email']")
    public TextBox senderEmail;

    @FindBy(id = "container.order.edit.internal-notes")
    public TextBox internalNotes;

    @FindBy(id = "commons.model.pickup-date")
    public MdDatepicker pickupDate;

    @FindBy(css = "[id^='container.order.edit.pickup-timeslot']")
    public MdSelect pickupTimeslot;

    @FindBy(name = "container.order.edit.change-address")
    public NvIconTextButton changeAddress;

    @FindBy(css = "[id^='commons.country']")
    public TextBox country;

    @FindBy(css = "[id^='commons.city']")
    public TextBox city;

    @FindBy(css = "[id^='commons.address1']")
    public TextBox address1;

    @FindBy(css = "[id^='commons.address2']")
    public TextBox address2;

    @FindBy(css = "[id^='commons.postcode']")
    public TextBox postcode;

    @FindBy(name = "commons.save-changes")
    public NvApiTextButton saveChanges;

    public EditPickupDetailsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  /**
   * Accessor for Edit Delivery Details dialog
   */
  public static class EditDeliveryDetailsDialog extends OperatorV2SimplePage {

    private static final String DIALOG_TITLE = "Edit Delivery Details";
    private static final String RECIPIENT_NAME_ARIA_LABEL = "Recipient Name";
    private static final String RECIPIENT_CONTACT_ARIA_LABEL = "Recipient Contact";
    private static final String RECIPIENT_EMAIL_ARIA_LABEL = "Recipient Email";
    private static final String INTERNAL_NOTES_ARIA_LABEL = "Internal Notes";
    private static final String CHANGE_SCHEDULE_CHECKBOX_ARIA_LABEL = "//md-checkbox[@aria-label='Change Schedule']";
    private static final String DELIVERY_DATE_ID = "commons.model.delivery-date";
    private static final String DELIVERY_TIMESLOT_ARIA_LABEL = "Delivery Timeslot";
    private static final String COUNTRY_ARIA_LABEL = "Country";
    private static final String COUNTRY_XPATH = "//input[@aria-label='Country' and @aria-hidden='false']";
    private static final String CITY_ARIA_LABEL = "City";
    private static final String ADDRESS_1_ARIA_LABEL = "Address 1";
    private static final String ADDRESS_2_ARIA_LABEL = "Address 2";
    private static final String POSTAL_CODE_ARIA_LABEL = "Postal Code";
    private static final String CHANGE_ADDRESS_BUTTON_ARIA_LABEL = "Change Address";
    private static final String SAVE_CHANGES_BUTTON_ARIA_LABEL = "Save changes";
    private static final String UPDATE_DELIVERY_DETAILS_SUCCESSFUL_TOAST_MESSAGE = "Delivery Details Updated";

    public EditDeliveryDetailsDialog(WebDriver webDriver) {
      super(webDriver);
    }

    public EditDeliveryDetailsDialog waitUntilVisibility() {
      waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
      return this;
    }

    public EditDeliveryDetailsDialog waitUntilAddressCanBeChanged() {
      waitUntilVisibilityOfElementLocated(COUNTRY_XPATH);
      return this;
    }

    public EditDeliveryDetailsDialog updateRecipientName(String text) {
      if (Objects.nonNull(text)) {
        sendKeysByAriaLabel(RECIPIENT_NAME_ARIA_LABEL, text);
      }
      return this;
    }

    public EditDeliveryDetailsDialog updateRecipientContact(String text) {
      if (Objects.nonNull(text)) {
        sendKeysByAriaLabel(RECIPIENT_CONTACT_ARIA_LABEL, text);
      }
      return this;
    }

    public EditDeliveryDetailsDialog updateRecipientEmail(String text) {
      if (Objects.nonNull(text)) {
        sendKeysByAriaLabel(RECIPIENT_EMAIL_ARIA_LABEL, text);
      }
      return this;
    }

    public EditDeliveryDetailsDialog updateInternalNotes(String text) {
      if (Objects.nonNull(text)) {
        sendKeysByAriaLabel(INTERNAL_NOTES_ARIA_LABEL, text);
      }
      return this;
    }

    public EditDeliveryDetailsDialog clickChangeSchedule() {
      click(CHANGE_SCHEDULE_CHECKBOX_ARIA_LABEL);
      return this;
    }

    public EditDeliveryDetailsDialog updateDeliveryDate(String textDate) {
      if (Objects.nonNull(textDate)) {
        try {
          setMdDatepickerById(DELIVERY_DATE_ID, YYYY_MM_DD_SDF.parse(textDate));
        } catch (ParseException e) {
          throw new NvTestRuntimeException("Failed to parse date.", e);
        }
      }
      return this;
    }

    public EditDeliveryDetailsDialog updateDeliveryTimeslot(String value) {
      if (Objects.nonNull(value)) {
        selectValueFromMdSelectByAriaLabel(DELIVERY_TIMESLOT_ARIA_LABEL, value);
      }
      return this;
    }

    public EditDeliveryDetailsDialog clickChangeAddress() {
      clickButtonByAriaLabel(CHANGE_ADDRESS_BUTTON_ARIA_LABEL);
      waitUntilAddressCanBeChanged();
      return this;
    }

    public EditDeliveryDetailsDialog updateCountry(String value) {
      if (Objects.nonNull(value)) {
        sendKeysByAriaLabel(COUNTRY_ARIA_LABEL, value);
      }
      return this;
    }

    public EditDeliveryDetailsDialog updateCity(String value) {
      if (Objects.nonNull(value)) {
        sendKeysByAriaLabel(CITY_ARIA_LABEL, value);
      }
      return this;
    }

    public EditDeliveryDetailsDialog updateAddress1(String value) {
      if (Objects.nonNull(value)) {
        sendKeysByAriaLabel(ADDRESS_1_ARIA_LABEL, value);
      }
      return this;
    }

    public EditDeliveryDetailsDialog updateAddress2(String value) {
      if (Objects.nonNull(value)) {
        sendKeysByAriaLabel(ADDRESS_2_ARIA_LABEL, value);
      }
      return this;
    }

    public EditDeliveryDetailsDialog updatePostalCode(String value) {
      if (Objects.nonNull(value)) {
        sendKeysByAriaLabel(POSTAL_CODE_ARIA_LABEL, value);
      }
      return this;
    }

    public void clickSaveChanges() {
      clickButtonByAriaLabelAndWaitUntilDone(SAVE_CHANGES_BUTTON_ARIA_LABEL);
    }

    public void confirmPickupDetailsUpdated() {
      waitUntilVisibilityOfToast(UPDATE_DELIVERY_DETAILS_SUCCESSFUL_TOAST_MESSAGE);
    }
  }

  /**
   * Accessor for DP Drop Off Setting dialog
   */
  public static class DpDropOffSettingDialog extends OperatorV2SimplePage {

    private static final String DIALOG_TITLE = "DP Drop Off Setting";
    private static final String DP_LIST = "//nv-autocomplete[@item-types='DP']";
    private static final String DROP_OFF_DATE_SELECT_LOCATOR = "container.order.edit.edit-dp-management-dropoff-date";
    private static final String SAVE_CHANGES_BUTTON_ARIA_LABEL = "Save changes";
    private static final String TAG_DP_DONE_SUCCESSFULLY_TOAST_MESSAGE = "Tagging to DP done successfully";
    private static final String DP_CLEAR_SELECTED_BUTTON_LOCATOR = "//button/md-icon[@md-svg-icon='md-close']";

    public DpDropOffSettingDialog(WebDriver webDriver) {
      super(webDriver);
    }

    public DpDropOffSettingDialog waitUntilVisibility() {
      waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
      return this;
    }

    private List<String> getListOfDropOffDates() {
      waitUntilVisibilityOfElementLocated("//md-select[@placeholder='Drop Off Date']");
      clickAndWaitUntilDone("//md-select[@placeholder='Drop Off Date']");
      waitUntilVisibilityOfElementLocated("//md-option[@aria-hidden='false']");
      List<String> listOfDropOffDates = findElementsBy(
          By.xpath("//md-option[@aria-hidden='false']")).stream()
          .map(WebElement::getText).collect(Collectors.toList());
      Actions actions = new Actions(getWebDriver());
      actions.sendKeys(Keys.ESCAPE).build().perform();
      return listOfDropOffDates;
    }

    public void selectDpValue(String value) {
      selectValueFromMdAutocomplete("", value);
    }

    public void selectDropOffDateValue(String value) {
      selectValueFromMdSelectById(DROP_OFF_DATE_SELECT_LOCATOR, value);
    }

    public void clearSelectedDropOffValue() {
      clickAndWaitUntilDone(DP_CLEAR_SELECTED_BUTTON_LOCATOR);
    }

    public void saveChanges() {
      clickButtonByAriaLabel(SAVE_CHANGES_BUTTON_ARIA_LABEL);
      waitUntilInvisibilityOfMdDialogByTitle(DIALOG_TITLE);
    }

    public void confirmOrderIsTagged() {
      waitUntilInvisibilityOfToast(TAG_DP_DONE_SUCCESSFULLY_TOAST_MESSAGE, true);
    }
  }

  /**
   * Accessor for Delete Order dialog
   */
  public static class DeleteOrderDialog extends OperatorV2SimplePage {

    private static final String DIALOG_TITLE = "Delete Order";
    private static final String PASSWORD = "1234567890";
    private static final String ENTER_PASSWORD_FIELD_ARIA_LABEL = "Password";
    private static final String DELETE_NV_API_TEXT_BUTTON_LOCATOR = "container.order.edit.delete-order";
    private static final String DELETE_ORDER_DONE_SUCCESSFULLY_TOAST_MESSAGE = "Order Deleted";

    public DeleteOrderDialog(WebDriver webDriver) {
      super(webDriver);
    }

    public DeleteOrderDialog waitUntilVisibility() {
      waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
      return this;
    }

    private void enterPassword() {
      sendKeysByAriaLabel(ENTER_PASSWORD_FIELD_ARIA_LABEL, PASSWORD);
    }

    private void clickDeleteOrderButton() {
      clickNvApiTextButtonByNameAndWaitUntilDone(DELETE_NV_API_TEXT_BUTTON_LOCATOR);
    }

    public void confirmOrderIsDeleted() {
      waitUntilInvisibilityOfToast(DELETE_ORDER_DONE_SUCCESSFULLY_TOAST_MESSAGE, true);
    }
  }

  /**
   * Accessor for Pickup Reschedule dialog
   */
  public static class PickupRescheduleDialog extends OperatorV2SimplePage {

    private static final String DIALOG_TITLE = "Pickup Reschedule";
    private static final String SENDER_NAME_ARIA_LABEL = "Sender Name";
    private static final String SENDER_CONTACT_ARIA_LABEL = "Sender Contact";
    private static final String SENDER_EMAIL_ARIA_LABEL = "Sender Email";
    private static final String PICKUP_DATE_ID = "commons.model.pickup-date";
    private static final String PICKUP_TIMESLOT_ARIA_LABEL = "Pickup Timeslot";
    private static final String COUNTRY_ARIA_LABEL = "Country";
    private static final String COUNTRY_XPATH = "//input[@aria-label='Country' and @aria-hidden='false']";
    private static final String CITY_ARIA_LABEL = "City";
    private static final String ADDRESS_1_ARIA_LABEL = "Address 1";
    private static final String ADDRESS_2_ARIA_LABEL = "Address 2";
    private static final String POSTAL_CODE_ARIA_LABEL = "Postal Code";
    private static final String CHANGE_ADDRESS_BUTTON_ARIA_LABEL = "Change Address";
    private static final String SAVE_CHANGES_BUTTON_ARIA_LABEL = "Save changes";
    private static final String ORDER_RESCHEDULED_SUCCESSFUL_TOAST_MESSAGE = "Order Rescheduled Successfully";

    public PickupRescheduleDialog(WebDriver webDriver) {
      super(webDriver);
    }

    public PickupRescheduleDialog waitUntilVisibility() {
      waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
      return this;
    }

    public PickupRescheduleDialog waitUntilAddressCanBeChanged() {
      waitUntilVisibilityOfElementLocated(COUNTRY_XPATH);
      return this;
    }

    public PickupRescheduleDialog updateSenderName(String text) {
      if (Objects.nonNull(text)) {
        sendKeysByAriaLabel(SENDER_NAME_ARIA_LABEL, text);
      }
      return this;
    }

    public PickupRescheduleDialog updateSenderContact(String text) {
      if (Objects.nonNull(text)) {
        sendKeysByAriaLabel(SENDER_CONTACT_ARIA_LABEL, text);
      }
      return this;
    }

    public PickupRescheduleDialog updateSenderEmail(String text) {
      if (Objects.nonNull(text)) {
        sendKeysByAriaLabel(SENDER_EMAIL_ARIA_LABEL, text);
      }
      return this;
    }

    public PickupRescheduleDialog updatePickupDate(String textDate) {
      if (Objects.nonNull(textDate)) {
        try {
          setMdDatepickerById(PICKUP_DATE_ID, YYYY_MM_DD_SDF.parse(textDate));
        } catch (ParseException e) {
          throw new NvTestRuntimeException("Failed to parse date.", e);
        }
      }
      return this;
    }

    public PickupRescheduleDialog updatePickupTimeslot(String value) {
      if (Objects.nonNull(value)) {
        selectValueFromMdSelectByAriaLabel(PICKUP_TIMESLOT_ARIA_LABEL, value);
      }
      return this;
    }

    public PickupRescheduleDialog clickChangeAddress() {
      clickButtonByAriaLabel(CHANGE_ADDRESS_BUTTON_ARIA_LABEL);
      waitUntilAddressCanBeChanged();
      return this;
    }

    public PickupRescheduleDialog updateCountry(String value) {
      if (Objects.nonNull(value)) {
        sendKeysByAriaLabel(COUNTRY_ARIA_LABEL, value);
      }
      return this;
    }

    public PickupRescheduleDialog updateCity(String value) {
      if (Objects.nonNull(value)) {
        sendKeysByAriaLabel(CITY_ARIA_LABEL, value);
      }
      return this;
    }

    public PickupRescheduleDialog updateAddress1(String value) {
      if (Objects.nonNull(value)) {
        sendKeysByAriaLabel(ADDRESS_1_ARIA_LABEL, value);
      }
      return this;
    }

    public PickupRescheduleDialog updateAddress2(String value) {
      if (Objects.nonNull(value)) {
        sendKeysByAriaLabel(ADDRESS_2_ARIA_LABEL, value);
      }
      return this;
    }

    public PickupRescheduleDialog updatePostalCode(String value) {
      if (Objects.nonNull(value)) {
        sendKeysByAriaLabel(POSTAL_CODE_ARIA_LABEL, value);
      }
      return this;
    }

    public void clickSaveChanges() {
      clickButtonByAriaLabelAndWaitUntilDone(SAVE_CHANGES_BUTTON_ARIA_LABEL);
    }

    public void confirmPickupRescheduledUpdated() {
      waitUntilVisibilityOfToast(ORDER_RESCHEDULED_SUCCESSFUL_TOAST_MESSAGE);
    }
  }

  /**
   * Accessor for Delivery Reschedule dialog
   */
  public static class DeliveryRescheduleDialog extends OperatorV2SimplePage {

    private static final String DIALOG_TITLE = "Delivery Reschedule";
    private static final String RECIPIENT_NAME_ARIA_LABEL = "Recipient Name";
    private static final String RECIPIENT_CONTACT_ARIA_LABEL = "Recipient Contact";
    private static final String RECIPIENT_EMAIL_ARIA_LABEL = "Recipient Email";
    private static final String DELIVERY_DATE_ID = "commons.model.delivery-date";
    private static final String DELIVERY_TIMESLOT_ARIA_LABEL = "Delivery Timeslot";
    private static final String COUNTRY_ARIA_LABEL = "Country";
    private static final String COUNTRY_XPATH = "//input[@aria-label='Country' and @aria-hidden='false']";
    private static final String CITY_ARIA_LABEL = "City";
    private static final String ADDRESS_1_ARIA_LABEL = "Address 1";
    private static final String ADDRESS_2_ARIA_LABEL = "Address 2";
    private static final String POSTAL_CODE_ARIA_LABEL = "Postal Code";
    private static final String CHANGE_ADDRESS_BUTTON_ARIA_LABEL = "Change Address";
    private static final String SAVE_CHANGES_BUTTON_ARIA_LABEL = "Save changes";
    private static final String ORDER_RESCHEDULED_SUCCESSFUL_TOAST_MESSAGE = "Order Rescheduled Successfully";

    public DeliveryRescheduleDialog(WebDriver webDriver) {
      super(webDriver);
    }

    public DeliveryRescheduleDialog waitUntilVisibility() {
      waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
      return this;
    }

    public DeliveryRescheduleDialog waitUntilAddressCanBeChanged() {
      waitUntilVisibilityOfElementLocated(COUNTRY_XPATH);
      return this;
    }

    public DeliveryRescheduleDialog updateRecipientName(String text) {
      if (Objects.nonNull(text)) {
        sendKeysByAriaLabel(RECIPIENT_NAME_ARIA_LABEL, text);
      }
      return this;
    }

    public DeliveryRescheduleDialog updateRecipientContact(String text) {
      if (Objects.nonNull(text)) {
        sendKeysByAriaLabel(RECIPIENT_CONTACT_ARIA_LABEL, text);
      }
      return this;
    }

    public DeliveryRescheduleDialog updateRecipientEmail(String text) {
      if (Objects.nonNull(text)) {
        sendKeysByAriaLabel(RECIPIENT_EMAIL_ARIA_LABEL, text);
      }
      return this;
    }

    public DeliveryRescheduleDialog updateDeliveryDate(String textDate) {
      if (Objects.nonNull(textDate)) {
        try {
          setMdDatepickerById(DELIVERY_DATE_ID, YYYY_MM_DD_SDF.parse(textDate));
        } catch (ParseException e) {
          throw new NvTestRuntimeException("Failed to parse date.", e);
        }
      }
      return this;
    }

    public DeliveryRescheduleDialog updateDeliveryTimeslot(String value) {
      if (Objects.nonNull(value)) {
        selectValueFromMdSelectByAriaLabel(DELIVERY_TIMESLOT_ARIA_LABEL, value);
      }
      return this;
    }

    public DeliveryRescheduleDialog clickChangeAddress() {
      clickButtonByAriaLabel(CHANGE_ADDRESS_BUTTON_ARIA_LABEL);
      waitUntilAddressCanBeChanged();
      return this;
    }

    public DeliveryRescheduleDialog updateCountry(String value) {
      if (Objects.nonNull(value)) {
        sendKeysByAriaLabel(COUNTRY_ARIA_LABEL, value);
      }
      return this;
    }

    public DeliveryRescheduleDialog updateCity(String value) {
      if (Objects.nonNull(value)) {
        sendKeysByAriaLabel(CITY_ARIA_LABEL, value);
      }
      return this;
    }

    public DeliveryRescheduleDialog updateAddress1(String value) {
      if (Objects.nonNull(value)) {
        sendKeysByAriaLabel(ADDRESS_1_ARIA_LABEL, value);
      }
      return this;
    }

    public DeliveryRescheduleDialog updateAddress2(String value) {
      if (Objects.nonNull(value)) {
        sendKeysByAriaLabel(ADDRESS_2_ARIA_LABEL, value);
      }
      return this;
    }

    public DeliveryRescheduleDialog updatePostalCode(String value) {
      if (Objects.nonNull(value)) {
        sendKeysByAriaLabel(POSTAL_CODE_ARIA_LABEL, value);
      }
      return this;
    }

    public void clickSaveChanges() {
      clickButtonByAriaLabelAndWaitUntilDone(SAVE_CHANGES_BUTTON_ARIA_LABEL);
    }

    public void confirmOrderDeliveryRescheduledUpdated() {
      waitUntilInvisibilityOfToast(ORDER_RESCHEDULED_SUCCESSFUL_TOAST_MESSAGE, true);
    }
  }

  /**
   * Accessor for Pull from Route Dialog
   */
  public static class PullFromRouteDialog extends MdDialog {

    public PullFromRouteDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = ".to-pull-checkbox > md-checkbox")
    public MdCheckbox toPull;

    @FindBy(name = "container.order.edit.pull-from-route")
    public NvApiTextButton pullFromRoute;
  }

  public void changeCopValue(Integer copValue) {
    editCashCollectionDetailsDialog.waitUntilVisible();
    pause1s();
    editCashCollectionDetailsDialog.amount.click();
    editCashCollectionDetailsDialog.amount.sendKeys(copValue);
    editCashCollectionDetailsDialog.saveChanges.clickAndWaitUntilDone();
    editOrderStampDialog.waitUntilInvisible();
  }

  public void changeCodValue(Integer codValue) {
    editCashCollectionDetailsDialog.waitUntilVisible();
    pause1s();
    editCashCollectionDetailsDialog.amount.click();
    editCashCollectionDetailsDialog.amount.sendKeys(codValue);
    editCashCollectionDetailsDialog.saveChanges.clickAndWaitUntilDone();
    editOrderStampDialog.waitUntilInvisible();
  }

  public void verifyCopUpdated(Integer copValue) {
    assertEquals("COP Value", "COP SGD" + (copValue / 100), this.copValue.getText());
  }

  public void verifyCodUpdated(Integer codValue) {
    assertEquals("COD Value", "COD SGD" + (codValue / 100), this.codValue.getText());
  }

  public void changeCopToggleToYes() {
    editCashCollectionDetailsDialog.waitUntilVisible();
    editCashCollectionDetailsDialog.copYes.click();
  }

  public void changeCopToggleToNo() {
    editCashCollectionDetailsDialog.waitUntilVisible();
    editCashCollectionDetailsDialog.copNo.click();
    editCashCollectionDetailsDialog.saveChanges.clickAndWaitUntilDone();
  }

  public void changeCodToggleToYes() {
    editCashCollectionDetailsDialog.waitUntilVisible();
    editCashCollectionDetailsDialog.codYes.click();
  }

  public void changeCodToggleToNo() {
    editCashCollectionDetailsDialog.waitUntilVisible();
    editCashCollectionDetailsDialog.codNo.click();
    editCashCollectionDetailsDialog.saveChanges.clickAndWaitUntilDone();
  }

  public static class EditPriorityLevelDialog extends MdDialog {

    public EditPriorityLevelDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = "//md-input-container[label]//input")
    public TextBox priorityLevel;


    @FindBy(name = "commons.save-changes")
    public NvApiTextButton saveChanges;
  }

  public static class AddToRouteDialog extends MdDialog {

    public AddToRouteDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[id^='container.order.edit.route']")
    public TextBox route;

    @FindBy(css = "[id^='commons.type']")
    public MdSelect type;

    @FindBy(css = "[id^='container.order.edit.route-tags']")
    public MdSelect routeTags;

    @FindBy(name = "container.order.edit.suggest-route")
    public NvApiTextButton suggestRoute;

    @FindBy(name = "container.order.edit.add-to-route")
    public NvApiTextButton addToRoute;
  }

  public static class EditOrderDetailsDialog extends MdDialog {

    public EditOrderDetailsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[id^='delivery-types']")
    public MdSelect deliveryTypes;

    @FindBy(css = "md-select[id^='parcel-size']")
    public MdSelect parcelSize;

    @FindBy(id = "weight")
    public TextBox weight;

    @FindBy(name = "commons.save-changes")
    public NvApiTextButton saveChanges;
  }

  public static class EditInstructionsDialog extends MdDialog {

    public EditInstructionsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(id = "container.order.edit.pickup-instruction")
    public TextBox pickupInstruction;

    @FindBy(id = "container.order.edit.delivery-instruction")
    public TextBox deliveryInstruction;

    @FindBy(id = "container.order.edit.order-instruction")
    public TextBox orderInstruction;

    @FindBy(name = "commons.save-changes")
    public NvApiTextButton saveChanges;
  }

  public static class EditOrderStampDialog extends MdDialog {

    public EditOrderStampDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(id = "commons.stamp-id")
    public TextBox stampId;

    @FindBy(name = "commons.save")
    public NvApiTextButton save;

    @FindBy(name = "commons.remove")
    public NvApiTextButton remove;
  }

  public static class UpdateStatusDialog extends MdDialog {

    public UpdateStatusDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[id^='commons.model.granular-status']")
    public MdSelect granularStatus;

    @FindBy(css = "[id^='container.order.edit.input-reason-for-change']")
    public TextBox changeReason;

    @FindBy(name = "commons.save-changes")
    public NvApiTextButton saveChanges;
  }

  public static class EditCashCollectionDetailsDialog extends MdDialog {

    public EditCashCollectionDetailsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(id = "Amount")
    public TextBox amount;

    @FindBy(xpath = "//div[label[@label = 'Cash on Pickup']]//button[@aria-label='Yes']")
    public Button copYes;

    @FindBy(xpath = "//div[label[@label = 'Cash on Pickup']]//button[@aria-label='No']")
    public Button copNo;

    @FindBy(xpath = "//div[label[@label = 'Cash on Delivery']]//button[@aria-label='Yes']")
    public Button codYes;

    @FindBy(xpath = "//div[label[@label = 'Cash on Delivery']]//button[@aria-label='No']")
    public Button codNo;

    @FindBy(name = "commons.save-changes")
    public NvApiTextButton saveChanges;
  }

  public static class EditDeliveryVerificationRequiredDialog extends MdDialog {

    public EditDeliveryVerificationRequiredDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[id^='commons.delivery-verification-required']")
    public MdSelect deliveryVerificationRequired;

    @FindBy(name = "commons.save-changes")
    public NvApiTextButton saveChanges;
  }

  /**
   * Accessor for Cancel RTS
   */
  public static class CancelRtsDialog extends MdDialog {

    public CancelRtsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(name = "container.order.edit.cancel-rts")
    public NvApiTextButton cancelRts;
  }

  public static class EditRtsDetailsDialog extends MdDialog {

    public EditRtsDetailsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "md-select[id^='commons.reason']")
    public MdSelect reason;

    @FindBy(css = "input[id^='commons.recipient-name']")
    public TextBox recipientName;

    @FindBy(css = "input[id^='commons.recipient-contact']")
    public TextBox recipientContact;

    @FindBy(css = "input[id^='commons.recipient-email']")
    public TextBox recipientEmail;

    @FindBy(css = "input[id^='container.order.edit.internal-notes']")
    public TextBox internalNotes;

    @FindBy(id = "commons.model.delivery-date")
    public MdDatepicker deliveryDate;

    @FindBy(css = "md-select[id^='commons.timeslot']")
    public MdSelect timeslot;

    @FindBy(name = "container.order.edit.change-address")
    public NvIconTextButton changeAddress;

    @FindBy(name = "commons.save-changes")
    public NvApiTextButton saveChanges;
  }

  public static class ResumeOrderDialog extends MdDialog {

    public ResumeOrderDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(name = "container.order.edit.resume-order")
    public NvApiTextButton resumeOrder;
  }

  public void createTicket(RecoveryTicket recoveryTicket) {
    waitUntilPageLoaded();
    String trackingId = recoveryTicket.getTrackingId();
    String ticketType = recoveryTicket.getTicketType();

    createTicketDialog.waitUntilVisible();
    createTicketDialog.trackingId.setValue(trackingId
        + " "); // Add 1 <SPACE> character at the end of tracking ID to make the textbox get trigged and request tracking ID validation to backend.
    createTicketDialog.entrySource.selectValue(recoveryTicket.getEntrySource());
    createTicketDialog.investigatingDept.selectValue(recoveryTicket.getInvestigatingDepartment());
    createTicketDialog.investigatingHub.searchAndSelectValue(recoveryTicket.getInvestigatingHub());
    createTicketDialog.ticketType.selectValue(ticketType);

    switch (ticketType) {
      case RecoveryTicketsPage.TICKET_TYPE_DAMAGED: {
        //Damaged Details
        createTicketDialog.orderOutcome
            .searchAndSelectValue(recoveryTicket.getOrderOutcomeDamaged());
        createTicketDialog.parcelLocation.selectValue(recoveryTicket.getParcelLocation());
        createTicketDialog.liability.selectValue(recoveryTicket.getLiability());
        createTicketDialog.damageDescription.setValue(recoveryTicket.getDamageDescription());
        break;
      }
      case RecoveryTicketsPage.TICKET_TYPE_MISSING: {
        createTicketDialog.orderOutcome
            .searchAndSelectValue(recoveryTicket.getOrderOutcomeMissing());
        createTicketDialog.parcelDescription.setValue(recoveryTicket.getParcelDescription());
        createTicketDialog.parcelDescription.setValue(recoveryTicket.getParcelDescription());
        break;
      }
      case RecoveryTicketsPage.TICKET_TYPE_PARCEL_EXCEPTION: {
        createTicketDialog.ticketSubtype.selectValue(recoveryTicket.getTicketSubType());
        createTicketDialog.orderOutcome
            .searchAndSelectValue(recoveryTicket.getOrderOutcomeInaccurateAddress());
        if (StringUtils.isNotBlank(recoveryTicket.getRtsReason())) {
          createTicketDialog.rtsReason.selectValue(recoveryTicket.getRtsReason());
        }
        createTicketDialog.exceptionReason.setValue(recoveryTicket.getExceptionReason());
        break;
      }
      case RecoveryTicketsPage.TICKET_TYPE_SHIPPER_ISSUE: {
        createTicketDialog.ticketSubtype.selectValue(recoveryTicket.getTicketSubType());
        createTicketDialog.orderOutcome
            .searchAndSelectValue(recoveryTicket.getOrderOutcomeDuplicateParcel());
        if (StringUtils.isNotBlank(recoveryTicket.getRtsReason())) {
          createTicketDialog.rtsReason.selectValue(recoveryTicket.getRtsReason());
        }
        createTicketDialog.issueDescription.setValue(recoveryTicket.getIssueDescription());
      }
    }

    createTicketDialog.customerZendeskId.setValue(recoveryTicket.getCustZendeskId());
    createTicketDialog.shipperZendeskId.setValue(recoveryTicket.getShipperZendeskId());
    createTicketDialog.ticketNotes.setValue(recoveryTicket.getTicketNotes());

    retryIfRuntimeExceptionOccurred(() ->
    {
      if (createTicketDialog.createTicket.isDisabled()) {
        createTicketDialog.trackingId.setValue(trackingId + " ");
        pause100ms();
        throw new NvTestRuntimeException(
            "Button \"Create Ticket\" still disabled. Trying to key in Tracking ID again.");
      }
    });

    createTicketDialog.createTicket.clickAndWaitUntilDone();
    waitUntilInvisibilityOfToast("Ticket created");
  }

  /**
   * Accessor for Delete Order dialog
   */
  public static class PodDetailsDialog extends OperatorV2SimplePage {

    private static final String DIALOG_TITLE = "Proof of Delivery";

    @FindBy(xpath = "//*[@id=\"information\"]//label[contains(string(), \"Status\")]/following-sibling::p")
    public PageElement status;

    @FindBy(xpath = "//*[@id=\"information\"]//label[contains(string(), \"POD Time\")]/following-sibling::p")
    public PageElement podTime;

    @FindBy(xpath = "//*[@id=\"information\"]//label[contains(string(), \"Start Date / Time\")]/following-sibling::p")
    public PageElement startDateTime;

    @FindBy(xpath = "//*[@id=\"information\"]//label[contains(string(), \"End Date / Time\")]/following-sibling::p")
    public PageElement endDateTime;

    @FindBy(xpath = "//*[@id=\"information\"]//label[contains(string(), \"Waypoint ID\")]/following-sibling::p")
    public PageElement waypointId;

    @FindBy(xpath = "//*[@id=\"information\"]//label[contains(string(), \"Route ID\")]/following-sibling::p")
    public PageElement routeId;

    @FindBy(xpath = "//*[@id=\"information\"]//label[contains(string(), \"Driver\")]/following-sibling::p")
    public PageElement driver;

    @FindBy(xpath = "//*[@id=\"information\"]//label[contains(string(), \"Verification Method\")]/following-sibling::p")
    public PageElement verificationMethod;

    @FindBy(xpath = "//*[@id=\"information\"]//label[contains(string(), \"Priority Level\")]/following-sibling::p")
    public PageElement priorityLevel;

    @FindBy(xpath = "//*[@id=\"information\"]//label[contains(string(), \"Location\")]/following-sibling::p")
    public PageElement location;

    @FindBy(xpath = "//*[@class=\"selected-pod-holder\"]/div[1]/div/h4")
    public PageElement trackingId;

    @FindBy(xpath = "//*[@class=\"selected-pod-holder\"]/div[2]/div/h4")
    public PageElement transaction;

    private PodDetailTable podDetailTable;

    public PodDetailsDialog(WebDriver webDriver) {
      super(webDriver);
      podDetailTable = new PodDetailTable(webDriver);
    }

    public PodDetailsDialog waitUntilVisibility() {
      waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
      return this;
    }

    public String getTrackingId() {
      return trackingId.getText();
    }

    public String getTransaction() {
      // format: TRANSACTION (21403)
      return transaction.getText();
    }

    public String getStatus() {
      return status.getText();
    }

    public String getPodTime() {
      // format: 2021-05-13 14:06:59
      return podTime.getText();
    }

    public String getStartDateTime() {
      // format: 2021-05-14 09:00:00
      return startDateTime.getText();
    }

    public String getEndDateTime() {
      // format: 2021-05-18 22:00:00
      return endDateTime.getText();
    }

    public String getWaypointId() {
      return waypointId.getText();
    }

    public String getRouteId() {
      return routeId.getText();
    }

    public String getDriver() {
      return driver.getText();
    }

    public String getPriorityLevel() {
      return priorityLevel.getText();
    }

    public String getLocation() {
      return location.getText();
    }

    public String getVerificationMethod() {
      return verificationMethod.getText();
    }

    public PodDetailTable getPodDetailTable() {
      return podDetailTable;
    }

    public void scrollToBottom() {
      this.scrollIntoView(
          "//*[@id=\"information\"]//label[contains(string(), \"Verification Method\")]/following-sibling::p");
    }

  }

  public static class PodDetailTable extends NgRepeatTable<PodDetail> {

    private static final String ACTION_VIEW = "View";

    public PodDetailTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("podId", "id")
          .put("waypointType", "_rsvn-or-txn")
          .put("type", "_type")
          .put("status", "_status")
          .put("distance", "_distance")
          .put("podTime", "_pod-time")
          .put("driver", "route-driver")
          .put("recipient", "_recipient")
          .put("address", "_address")
          .put("verificationMethod", "_verification-method")
          .build());
      setNgRepeat("pod in getTableData()");
      setActionButtonsLocators(ImmutableMap.of(ACTION_VIEW, "commons.view"));
      setEntityClass(PodDetail.class);
    }

    public void clickView(int rowNumber) {
      clickActionButton(rowNumber, ACTION_VIEW);
    }
  }


  public static class ChatWithDriverDialog extends OperatorV2SimplePage {

    @FindBy(xpath = "//div[@data-testid='driverChat.container']//div[./span[contains(@class,'ant-typography-ellipsis-single-line')]]/..")
    public List<ChatOrderItem> orderItems;

    @FindBy(xpath = "//div[@data-testid='driverChat.chatMessagesContainer']//div[@id]")
    public List<ChatMessage> messages;

    @FindBy(css = "[data-testid='MessageInput.input']")
    public TextBox messageInput;

    @FindBy(css = "[data-testid='GoToOrderDetails.button']")
    public Button goToOrderDetails;

    @FindBy(css = "md-dialog iframe")
    public PageElement iframe;

    @FindBy(css = "[data-testid='driverChat.chatMessagesContainer'] p")
    public PageElement chatDate;

    @FindBy(xpath = "//div[text()='Read']")
    public PageElement readLabel;

    @FindBy(name = "Cancel")
    public NvIconButton close;

    public ChatWithDriverDialog(WebDriver webDriver) {
      super(webDriver);
    }

    public void close() {
      getWebDriver().switchTo().defaultContent();
      close.click();
    }

    public void switchTo() {
      getWebDriver().switchTo().defaultContent();
      getWebDriver().switchTo().frame(iframe.getWebElement());
    }

    public ChatOrderItem findOrderItemByTrackingId(String trackingId) {
      return orderItems.stream()
          .filter(chatOrderItem -> StringUtils
              .equalsIgnoreCase(trackingId, chatOrderItem.trackingId.getText()))
          .findFirst()
          .orElseThrow(() -> new AssertionError(
              "Tracking ID " + trackingId + " not found in Chat With Driver dialog"));
    }

    public void waitUntilVisible() {
      switchTo();
      messageInput.waitUntilVisible();
    }

    public static class ChatOrderItem extends PageElement {

      @FindBy(css = "span.ant-typography-ellipsis-single-line > strong")
      public PageElement trackingId;

      @FindBy(xpath = ".//div[2]/span")
      public PageElement date;

      @FindBy(xpath = ".//div[2]/div")
      public PageElement replaysNumber;

      public ChatOrderItem(WebDriver webDriver, WebElement webElement) {
        super(webDriver, webElement);
      }
    }

    public static class ChatMessage extends PageElement {

      @FindBy(xpath = "./div/div[1]")
      public PageElement message;

      @FindBy(xpath = "./div/div[2]")
      public PageElement date;

      public ChatMessage(WebDriver webDriver, WebElement webElement) {
        super(webDriver, webElement);
      }
    }
  }

  public void verifyTheSortCodeIsCorrect(String sortCode, File orderAirwayBillPdfAsByteArray) {
    String actualSortCode = PdfUtils.getSortCode(orderAirwayBillPdfAsByteArray);
    assertTrue("Sort Code", sortCode.equalsIgnoreCase(actualSortCode));
  }

  @FindBy(css = "[aria-label*='Order outcome']")
  public List<PageElement> orderOutcomeDialog;

  @FindBy(css = "button[aria-label='No']")
  public PageElement noBtn;

  @FindBy(css = "button[aria-label='Keep']")
  public PageElement keepBtn;

  public void chooseCurrentOrderOutcome(String value) {
    if (orderOutcomeDialog.size() > 0) {
        if(value.equalsIgnoreCase("keep")){
          keepBtn.click();
        }
        if (value.equalsIgnoreCase("no")) {
          noBtn.click();
        }
    }

  }

}
