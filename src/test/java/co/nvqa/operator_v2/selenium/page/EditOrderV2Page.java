package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.model.core.Cod;
import co.nvqa.commons.model.core.Dimension;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.model.pdf.AirwayBill;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.commons.util.PdfUtils;
import co.nvqa.operator_v2.model.GlobalInboundParams;
import co.nvqa.operator_v2.model.OrderEvent;
import co.nvqa.operator_v2.model.PodDetail;
import co.nvqa.operator_v2.model.RecoveryTicket;
import co.nvqa.operator_v2.model.TransactionInfo;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntCheckbox;
import co.nvqa.operator_v2.selenium.elements.ant.AntDateTimeRangePicker;
import co.nvqa.operator_v2.selenium.elements.ant.AntMenuBar;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.selenium.elements.ant.AntSwitch;
import co.nvqa.operator_v2.selenium.elements.ant.AntTextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdAutocomplete;
import co.nvqa.operator_v2.selenium.elements.md.MdCheckbox;
import co.nvqa.operator_v2.selenium.elements.md.MdDatepicker;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdMenu;
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
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static co.nvqa.operator_v2.selenium.page.EditOrderPage.EventsTable.EVENT_NAME;
import static co.nvqa.operator_v2.selenium.page.EditOrderPage.TransactionsTable.COLUMN_TYPE;
import static org.apache.commons.lang3.StringUtils.equalsAnyIgnoreCase;
import static org.apache.commons.lang3.StringUtils.equalsIgnoreCase;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class EditOrderV2Page extends SimpleReactPage<EditOrderV2Page> {

  @FindBy(id = "header")
  public PageElement header;

  @FindBy(xpath = "//div[./div[contains(text(),'Actions')]]")
  public AntMenuBar menuBar;

  @FindBy(css = "div[loading-message='Loading events...'] md-menu")
  public MdMenu eventsTableFilter;

  @FindBy(xpath = "//div[label[.='Tracking ID']]/h3")
  public PageElement trackingId;

  @FindBy(xpath = "//div[label[.='Latest Event']]/h3")
  public PageElement latestEvent;

  @FindBy(xpath = "//div[./label[.='Zone']]//span")
  public PageElement zone;

  @FindBy(xpath = "//div[./label[.='Status']]//span")
  public PageElement status;

  @FindBy(xpath = "//div[./label[.='Granular']]//span")
  public PageElement granular;

  @FindBy(xpath = "//div[./label[.='Stamp ID']]//span")
  public PageElement stampId;

  @FindBy(xpath = "//div[./label[.='Comments']]//div")
  public PageElement comments;

  @FindBy(xpath = "//div[label[.='Latest Route ID']]/h3")
  public PageElement latestRouteId;

  @FindBy(xpath = "//div[label[.='Shipper ID']]/p")
  public PageElement shipperId;

  @FindBy(xpath = "//div[label[.='Order Type']]/p")
  public PageElement orderType;

  @FindBy(xpath = "//label[text()='Delivery type']/following-sibling::div")
  public PageElement deliveryType;

  @FindBy(xpath = "//div[./label[.='Current DNR Group']]/p")
  public PageElement currentDnrGroup;

  @FindBy(xpath = "//div[./label[.='Current priority']]//span")
  public PageElement currentPriority;

  @FindBy(xpath = "//div[./label[.='Delivery verification required']]/div/div/div")
  public PageElement deliveryVerificationType;

  @FindBy(xpath = "//label[text()='Size']/following-sibling::div")
  public PageElement size;

  @FindBy(xpath = "//label[text()='Weight']/following-sibling::div")
  public PageElement weight;

  @FindBy(xpath = "//label[text()='Dimensions']/following-sibling::div")
  public PageElement dimensions;

  @FindBy(xpath = ".//a[contains(.,'Ticket ID')]")
  public Button recoveryTicket;

  @FindBy(css = ".ant-modal")
  public CreateTicketDialog createTicketDialog;

  @FindBy(css = "md-dialog")
  public EditTicketDialog editTicketDialog;

  @FindBy(css = "[data-testid='edit-order-testid.order-summary-section.dvr-field.edit.icon']")
  public Button deliveryVerificationTypeEdit;

  @FindBy(xpath = ".//span[contains(@class,'ant-tag')][contains(.,'COP')]")
  public PageElement copValue;

  @FindBy(xpath = ".//span[contains(@class,'ant-tag')][contains(.,'COD')]")
  public PageElement codValue;

  @FindBy(css = "button[ng-click='ctrl.startChatWithDriver($event)']")
  public Button chatWithDriver;

  private static final String NG_REPEAT_TABLE_EVENT = "event in getTableData()";
  public static final String COLUMN_CLASS_DATA_NAME_ON_TABLE_EVENT = "name";

  public TransactionsTable transactionsTable;

  @FindBy(css = ".ant-modal")
  public EditPriorityLevelDialog editPriorityLevelDialog;

  @FindBy(css = "md-dialog")
  public AddToRouteDialog addToRouteDialog;

  @FindBy(css = ".ant-modal")
  public EditOrderDetailsDialog editOrderDetailsDialog;

  @FindBy(css = ".ant-modal")
  public EditInstructionsDialog editInstructionsDialog;

  @FindBy(css = "md-dialog")
  public ManuallyCompleteOrderDialog manuallyCompleteOrderDialog;

  @FindBy(css = ".ant-modal")
  public EditOrderStampDialog editOrderStampDialog;

  @FindBy(css = "md-dialog")
  public UpdateStatusDialog updateStatusDialog;

  @FindBy(css = ".ant-modal")
  public CancelOrderDialog cancelOrderDialog;

  @FindBy(css = ".ant-modal")
  public EditPickupDetailsDialog editPickupDetailsDialog;

  @FindBy(css = ".ant-modal")
  public PullFromRouteDialog pullFromRouteDialog;

  @FindBy(css = ".ant-modal")
  public EditCashCollectionDetailsDialog editCashCollectionDetailsDialog;

  @FindBy(css = ".ant-modal")
  public EditDeliveryVerificationRequiredDialog editDeliveryVerificationRequiredDialog;

  @FindBy(css = "md-dialog")
  public CancelRtsDialog cancelRtsDialog;

  @FindBy(css = ".ant-modal")
  public EditRtsDetailsDialog editRtsDetailsDialog;

  @FindBy(css = ".ant-modal")
  public ResumeOrderDialog resumeOrderDialog;

  public ChatWithDriverDialog chatWithDriverDialog;

  @FindBy(xpath = ".//div[./div[contains(@class,'delivery-banner')]]")
  public DeliveryDetailsBox deliveryDetailsBox;

  @FindBy(xpath = ".//div[./div[contains(@class,'pickup-banner')]]")
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

  @FindBy(xpath = "//label[text()='Insured value']/following-sibling::div")
  public PageElement insuredValue;

  @FindBy(xpath = "//label[text()='Billing Weight']/following-sibling::p")
  public PageElement billingWeight;

  @FindBy(xpath = "//label[text()='Billing Size']/following-sibling::p")
  public PageElement billingSize;

  @FindBy(xpath = "//label[text()='Source']/following-sibling::p")
  public PageElement source;

  @FindBy(css = "md-dialog")
  public DpDropOffSettingDialog dpDropOffSettingDialog;

  public EventsTable eventsTable;
  public EditDeliveryDetailsDialog editDeliveryDetailsDialog;
  @FindBy(css = ".ant-modal")
  public DeleteOrderDialog deleteOrderDialog;
  private PickupRescheduleDialog pickupRescheduleDialog;
  private DeliveryRescheduleDialog deliveryRescheduleDialog;
  private PodDetailsDialog podDetailsDialog;

  public EditOrderV2Page(WebDriver webDriver) {
    super(webDriver);
    transactionsTable = new TransactionsTable(webDriver);
    eventsTable = new EventsTable(webDriver);
    deliveryRescheduleDialog = new DeliveryRescheduleDialog(webDriver);
    editDeliveryDetailsDialog = new EditDeliveryDetailsDialog(webDriver);
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
    getWebDriver().get(f("%s/%s/order-v2?id=%s", TestConstants.OPERATOR_PORTAL_BASE_URL,
        StandardTestConstants.NV_SYSTEM_ID.toLowerCase(), orderId));
    pause1s();
    getWebDriver().switchTo().defaultContent();
    pageFrame.waitUntilVisible();
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
    waitUntilLoaded(20, 120);
  }

  public void clickMenu(String parentMenuName, String childMenuName) {
    menuBar.selectOption(parentMenuName, childMenuName);
  }

  public boolean isMenuItemEnabled(String parentMenuName, String childMenuName) {
    return menuBar.isOptionEnabled(parentMenuName, childMenuName);
  }

  public void editOrderStamp(String stampId) {
    clickMenu("Order Settings", "Edit Order Stamp");
    editOrderStampDialog.waitUntilVisible();
    editOrderStampDialog.stampId.setValue(stampId);
    editOrderStampDialog.save.click();
  }

  public void editOrderStampToExisting(String existingStampId, String trackingId) {
    clickMenu("Order Settings", "Edit Order Stamp");
    editOrderStampDialog.waitUntilVisible();
    editOrderStampDialog.stampId.setValue(existingStampId);
    editOrderStampDialog.save.click();
    waitUntilInvisibilityOfToast(
        String.format("Stamp %s exists in order %s", existingStampId, trackingId), true);
    editOrderStampDialog.sendKeys(Keys.ESCAPE);
    editOrderStampDialog.waitUntilInvisible();
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
    Assertions.assertThat(deliveryDetailsBox.getStartDateTime()).as("Delivery Start Date/Time")
        .isEqualTo(expectedDate);
  }

  public void verifyOrderHeaderColor(String color) {
    Assertions.assertThat(header.getCssValue("background-color")).as("Order Header Color")
        .isEqualTo(color);
  }

  public void verifyDeliveryEndDateTime(String expectedDate) {
    Assertions.assertThat(deliveryDetailsBox.getEndDateTime()).as("Delivery End Date/Time")
        .isEqualTo(expectedDate);
  }

  public void verifyDeliveryRouteInfo(Route route) {
    Assertions.assertThat(deliveryDetailsBox.getRouteId()).as("Delivery Route Id")
        .isEqualTo(String.valueOf(route.getId()));
    if (CollectionUtils.isNotEmpty(route.getWaypoints())) {
      String expectedWaypointId = String.valueOf(route.getWaypoints().get(0).getId());
      Assertions.assertThat(deliveryDetailsBox.getWaypointId()).as("Delivery Waypoint ID")
          .isEqualTo(expectedWaypointId);
    }
    String expectedDriver =
        route.getDriver().getFirstName() + " " + route.getDriver().getLastName();
    Assertions.assertThat(deliveryDetailsBox.getDriver().trim()).as("Delivery Driver")
        .isEqualTo(expectedDriver.trim());
  }

  public void verifyPickupRouteInfo(Route route) {
    Assertions.assertThat(pickupDetailsBox.getRouteId()).as("Pickup Route Id")
        .isEqualTo(String.valueOf(route.getId()));
    if (CollectionUtils.isNotEmpty(route.getWaypoints())) {
      String expectedWaypointId = String.valueOf(route.getWaypoints().get(0).getId());
      Assertions.assertThat(pickupDetailsBox.getWaypointId()).as("Pickup Waypoint ID")
          .isEqualTo(expectedWaypointId);
    }
    String expectedDriver =
        route.getDriver().getFirstName() + " " + route.getDriver().getLastName();
    Assertions.assertThat(pickupDetailsBox.getDriver().trim()).as("Pickup Driver")
        .isEqualTo(expectedDriver.trim());
  }

  public void printAirwayBill() {
    clickMenu("View/Print", "Print Airway Bill");
    waitUntilInvisibilityOfToast("Attempting to download", true);
    waitUntilInvisibilityOfToast("Downloading");
  }

  public void verifyAirwayBillContentsIsCorrect(Order order) {
    verifyAirwayBillContentsIsCorrect(order, 0, "awb_" + order.getTrackingId());
  }

  public void verifyAirwayBillContentsIsCorrect(Order order, int index, String fileName) {
    String trackingId = order.getTrackingId();
    String latestFilenameOfDownloadedPdf = getLatestDownloadedFilename(fileName);
    verifyFileDownloadedSuccessfully(latestFilenameOfDownloadedPdf);
    AirwayBill airwayBill = PdfUtils.getOrderInfoFromAirwayBill(
        TestConstants.TEMP_DIR + latestFilenameOfDownloadedPdf, index);

    Assertions.assertThat(airwayBill.getTrackingId()).as("Tracking ID").isEqualTo(trackingId);

    Assertions.assertThat(airwayBill.getFromName()).as("From Name").isEqualTo(order.getFromName());
    Assertions.assertThat(airwayBill.getFromContact()).as("From Contact")
        .isEqualTo(order.getFromContact());
    Assertions.assertThat(airwayBill.getFromAddress()).as("From Address")
        .contains(order.getFromAddress1());
    Assertions.assertThat(StringUtils.normalizeSpace(airwayBill.getFromAddress()))
        .as("From Address").contains(StringUtils.normalizeSpace(order.getFromAddress2()));
    Assertions.assertThat(airwayBill.getFromAddress()).as("Postcode In From Address")
        .contains(order.getFromPostcode());

    Assertions.assertThat(airwayBill.getToName()).as("To Name").isEqualTo(order.getToName());
    Assertions.assertThat(airwayBill.getToContact()).as("To Contact")
        .isEqualTo(order.getToContact());
    Assertions.assertThat(airwayBill.getToAddress()).as("To Address")
        .contains(order.getToAddress1());
    Assertions.assertThat(StringUtils.normalizeSpace(airwayBill.getToAddress())).as("To Address")
        .contains(StringUtils.normalizeSpace(order.getToAddress2()));
    Assertions.assertThat(airwayBill.getToAddress()).as("Postcode In To Address")
        .contains(order.getToPostcode());

    Assertions.assertThat(airwayBill.getCod()).as("COD")
        .isEqualTo(Optional.ofNullable(order.getCod()).orElse(new Cod()).getGoodsAmount());
    Assertions.assertThat(airwayBill.getComments()).as("Comments")
        .isEqualTo(order.getInstruction());

    String actualQrCodeTrackingId = TestUtils.getTextFromQrCodeImage(
        airwayBill.getTrackingIdQrCodeFile());
    Assertions.assertThat(actualQrCodeTrackingId).as("Tracking ID - QR Code").isEqualTo(trackingId);

    String actualBarcodeTrackingId = TestUtils.getTextFromQrCodeImage(
        airwayBill.getTrackingIdBarcodeFile());
    Assertions.assertThat(actualBarcodeTrackingId).as("Tracking ID - Barcode 128")
        .isEqualTo(trackingId);
  }

  public void verifyPriorityLevel(String txnType, int priorityLevel) {
    transactionsTable.filterByColumn(COLUMN_TYPE, txnType);
    TransactionInfo actual = transactionsTable.readEntity(1);
    Assertions.assertThat(actual.getPriorityLevel()).as(txnType + " Priority Level")
        .isEqualTo(String.valueOf(priorityLevel));
  }

  public String confirmCompleteOrder() {
    String changeReason = f("This reason is created by automation at %s.",
        DTF_CREATED_DATE.format(ZonedDateTime.now()));
    manuallyCompleteOrderDialog.waitUntilVisible();
    manuallyCompleteOrderDialog.changeReason.setValue("Others (fill in below)");
    manuallyCompleteOrderDialog.reasonForChange.setValue(changeReason);
    manuallyCompleteOrderDialog.completeOrder.clickAndWaitUntilDone();
    waitUntilInvisibilityOfToast("The order has been completed", true);
    return changeReason;
  }

  public void confirmCompleteOrder(String reason, String reasonDescr) {
    manuallyCompleteOrderDialog.waitUntilVisible();
    manuallyCompleteOrderDialog.changeReason.setValue(reason);
    if (StringUtils.isNotBlank(reasonDescr)) {
      manuallyCompleteOrderDialog.reasonForChange.setValue(reasonDescr);
    }
    manuallyCompleteOrderDialog.completeOrder.clickAndWaitUntilDone();
    waitUntilInvisibilityOfToast("The order has been completed", true);
  }

  public void verifyEditOrderDetailsIsSuccess(Order editedOrder) {
    Dimension expectedDimension = editedOrder.getDimensions();
    Assertions.assertThat(size.getText()).as("Order Details - Size")
        .isEqualTo(editedOrder.getParcelSize());
    Assertions.assertThat(getWeight()).as("Order Details - Weight")
        .isEqualTo(expectedDimension.getWeight());
  }

  public void verifyInboundIsSucceed() {
    String actualLatestEvent = getTextOnTableEvent(1, COLUMN_CLASS_DATA_NAME_ON_TABLE_EVENT);
    Assertions.assertThat(actualLatestEvent).as("Different Result Returned")
        .isIn("Van Inbound Scan", "DRIVER INBOUND SCAN", "PARCEL ROUTING SCAN");
  }

  public void verifyEvent(Order order, String hubName, String hubId, String eventNameExpected,
      String stringContained) {
    ZonedDateTime eventDateExpected = DateUtil.getDate(
        ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE));

    int rowWithExpectedEvent = 1;
    for (int i = 1; i <= eventsTable.getRowsCount(); i++) {
      String eventNameActual = getTextOnTableEvent(i, EVENT_NAME);
      if (eventNameExpected.equals(eventNameActual)) {
        rowWithExpectedEvent = i;
      }
    }
    OrderEvent eventRow = eventsTable.readEntity(rowWithExpectedEvent);
    Assertions.assertThat(eventRow.getHubName()).as("Different Result Returned for hub name")
        .isEqualTo(hubName);
    Assertions.assertThat(eventRow.getEventTime()).as("Different Result Returned for event time")
        .contains(DateUtil.displayDate(eventDateExpected));
    if (stringContained.contains("Scanned")) {
      Assertions.assertThat(eventRow.getDescription())
          .as("Different Result Returned for event description")
          .contains(f("%s at Hub %s", stringContained, hubId));
      return;
    }
    Assertions.assertThat(eventRow.getDescription())
        .as("Different Result Returned for event description").contains(stringContained);
  }

  public void verifyOrderDeliveryTitle(String expectedDeliveryTitle) {
    Assertions.assertThat(getDeliveryTitle()).as("Delivery Title")
        .isEqualToIgnoringCase(expectedDeliveryTitle);
  }

  public void verifyPickupAndDeliveryInfo(Order order) {
    // Pickup
    verifyPickupInfo(order);
    // Delivery
    verifyDeliveryInfo(order);
  }

  public void verifyPickupInfo(Order order) {
    // Pickup
    Assertions.assertThat(pickupDetailsBox.from.getText()).as("From Name")
        .isEqualTo(order.getFromName());
    Assertions.assertThat(pickupDetailsBox.fromEmail.getText()).as("From Email")
        .isEqualTo(order.getFromEmail());
    Assertions.assertThat(pickupDetailsBox.fromContact.getText()).as("From Contact")
        .isEqualTo(order.getFromContact());
    String fromAddress = pickupDetailsBox.fromAddress.getText();
    Assertions.assertThat(fromAddress).as("From Address").contains(order.getFromAddress1());
    Assertions.assertThat(fromAddress).as("From Address").contains(order.getFromAddress2());
  }

  public void verifyDeliveryInfo(Order order) {
    Assertions.assertThat(deliveryDetailsBox.to.getText()).as("To Name")
        .isEqualTo(order.getToName());
    Assertions.assertThat(deliveryDetailsBox.toEmail.getText()).as("To Email")
        .isEqualTo(order.getToEmail());
    Assertions.assertThat(deliveryDetailsBox.toContact.getText()).as("To Contact")
        .isEqualTo(order.getToContact());
    String toAddress = deliveryDetailsBox.toAddress.getText();
    Assertions.assertThat(toAddress).as("To Address").contains(order.getToAddress1());
    if (StringUtils.isNotBlank(order.getToAddress2())) {
      Assertions.assertThat(toAddress).as("To Address").contains(order.getToAddress2());
    }
    if (StringUtils.isNotBlank(order.getToPostcode())) {
      Assertions.assertThat(toAddress).as("To Address").contains(order.getToPostcode());
    }
  }

  public void verifyPickupDetailsInTransaction(Order order, String txnType) {
    transactionsTable.filterByColumn(COLUMN_TYPE, txnType);
    TransactionInfo actual = transactionsTable.readEntity(1);
    Assertions.assertThat(actual.getName()).as("From Name").isEqualTo(order.getFromName());
    Assertions.assertThat(actual.getEmail()).as("From Email").isEqualTo(order.getFromEmail());
    Assertions.assertThat(actual.getContact()).as("From Contact").isEqualTo(order.getFromContact());
    Assertions.assertThat(actual.getDestinationAddress()).as("From Address")
        .contains(order.getFromAddress1());
    Assertions.assertThat(actual.getDestinationAddress()).as("From Address")
        .contains(order.getFromAddress2());
  }

  public void verifyDeliveryDetailsInTransaction(Order order, String txnType) {
    transactionsTable.filterByColumn(COLUMN_TYPE, txnType);
    TransactionInfo actual = transactionsTable.readEntity(1);
    Assertions.assertThat(actual.getName()).as("To Name").isEqualTo(order.getToName());
    Assertions.assertThat(actual.getEmail()).as("To Email").isEqualTo(order.getToEmail());
    Assertions.assertThat(actual.getContact()).as("To Contact").isEqualTo(order.getToContact());
    Assertions.assertThat(actual.getDestinationAddress()).as("To Address")
        .contains(order.getToAddress1());
    Assertions.assertThat(actual.getDestinationAddress()).as("To Address")
        .contains(order.getToAddress1());
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

  public Double getLength() {
    Double length = null;
    String actualText = this.dimensions.getText();

    if (!actualText.contains("(L) x (B) x (H) cm")) {
      String temp = actualText.replaceAll("[^-?0-9]+", " ");
      length = Double.parseDouble(temp.split(" ")[2]);
    }

    return length;
  }

  public Double getWidth() {
    Double width = null;
    String actualText = this.dimensions.getText();

    if (!actualText.contains("(L) x (B) x (H) cm")) {
      String temp = actualText.replaceAll("[^-?0-9]+", " ");
      width = Double.parseDouble(temp.split(" ")[0]);
    }

    return width;
  }

  public Double getHeighth() {
    Double height = null;
    String actualText = this.dimensions.getText();

    if (!actualText.contains("(L) x (B) x (H) cm")) {
      String temp = actualText.replaceAll("[^-?0-9]+", " ");
      height = Double.parseDouble(temp.split(" ")[1]);
    }

    return height;
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

    if (!actualText.contains("-") && !actualText.contains("x x cm") && !actualText.contains(
        "(L) x (B) x (H) cm")) {
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

  public String getTextOnTableEvent(int rowNumber, String columnDataClass) {
    return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT_TABLE_EVENT);
  }

  public void verifiesOrderIsTaggedToTheRecommendedRouteId() {
    TransactionInfo actual = transactionsTable.readEntity(2);
    Assertions.assertThat(StringUtils.isNotBlank(actual.getRouteId()))
        .as("Order is not tagged to any route: ").isTrue();
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
    if (StringUtils.isNotBlank(pickupDate)) {
      editPickupDetailsDialog.pickupDate.simpleSetValue(pickupDate);
    }
    if (StringUtils.isNotBlank(pickupTimeslot)) {
      editPickupDetailsDialog.pickupTimeslot.selectValue(pickupTimeslot);
    }
    editPickupDetailsDialog.shipperRequestedToChange.setValue(
        Boolean.parseBoolean(mapOfData.getOrDefault("shipperRequestedToChange", "false")));
    editPickupDetailsDialog.assignPickupLocation.setValue(
        Boolean.parseBoolean(mapOfData.getOrDefault("assignPickupLocation", "false")));
    editPickupDetailsDialog.changeAddress.click();
    editPickupDetailsDialog.country.setValue(country);
    editPickupDetailsDialog.city.setValue(city);
    editPickupDetailsDialog.address1.setValue(address1);
    editPickupDetailsDialog.address2.setValue(address2);
    editPickupDetailsDialog.postcode.setValue(postalCode);
    editPickupDetailsDialog.saveChanges.clickAndWaitUntilDone();
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

    pickupRescheduleDialog
        .waitUntilVisibility()
        .updateSenderName(senderName)
        .updateSenderContact(senderContact)
        .updateSenderEmail(senderEmail)
        .updatePickupDate(pickupDate)
        .updatePickupTimeslot(pickupTimeslot)
        .clickSaveChanges();
    pickupRescheduleDialog.confirmPickupRescheduledUpdated();
  }

  public void reschedulePickupWithAddressChanges(Map<String, String> mapOfData) {
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

  public void rescheduleDeliveryWithAddressChange(Map<String, String> mapOfData) {
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

  public void rescheduleDelivery(Map<String, String> mapOfData) {
    String recipientName = mapOfData.get("recipientName");
    String recipientContact = mapOfData.get("recipientContact");
    String recipientEmail = mapOfData.get("recipientEmail");
    String deliveryDate = mapOfData.get("deliveryDate");
    String deliveryTimeslot = mapOfData.get("deliveryTimeslot");

    deliveryRescheduleDialog
        .waitUntilVisibility()
        .updateRecipientName(recipientName)
        .updateRecipientContact(recipientContact)
        .updateRecipientEmail(recipientEmail)
        .updateDeliveryDate(deliveryDate)
        .updateDeliveryTimeslot(deliveryTimeslot)
        .clickSaveChanges();
    deliveryRescheduleDialog.confirmOrderDeliveryRescheduledUpdated();
  }

  public static class TransactionsTable extends AntTableV4<TransactionInfo> {

    public static final String COLUMN_TYPE = "type";

    public TransactionsTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("serviceEndTime", "serviceEndTime")
          .put(COLUMN_TYPE, "type")
          .put("status", "status")
          .put("driver", "driverName")
          .put("routeId", "routeId")
          .put("routeDate", "routeDate")
          .put("dpId", "distributionPointId")
          .put("failureReason", "failure_reason_code")
          .put("priorityLevel", "priorityLevel")
          .put("dnr", "dnr")
          .put("name", "name")
          .put("contact", "contact")
          .put("email", "email")
          .put("destinationAddress", "_address")
          .build());
      setEntityClass(TransactionInfo.class);
    }
  }

  /**
   * Accessor for Events table
   */
  public static class EventsTable extends AntTableV4<OrderEvent> {

    public static final String DATE_TIME = "eventTime";
    public static final String EVENT_TAGS = "tags";
    public static final String EVENT_NAME = "name";
    public static final String USER_TYPE = "userType";
    public static final String USER_ID = "user";
    public static final String ROUTE_ID = "routeId";
    public static final String HUB_NAME = "hubName";
    public static final String DESCRIPTION = "description";

    public EventsTable(WebDriver webDriver) {
      super(webDriver);
      setTableLocator("//div[./div/span[.='Events']]/div[contains(@class,'VirtualTable')]");
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(DATE_TIME, "_time")
          .put(EVENT_TAGS, "_tags")
          .put(EVENT_NAME, "_name")
          .put(USER_TYPE, "_userType")
          .put(USER_ID, "_user")
          .put(ROUTE_ID, "_routeId")
          .put(HUB_NAME, "_hubName")
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
          eventDescription), eventDescription.matches(fromAddress1Pattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", fromAddress2Pattern,
          eventDescription), eventDescription.matches(fromAddress2Pattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", fromPostcodePattern,
          eventDescription), eventDescription.matches(fromPostcodePattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", fromCityPattern,
          eventDescription), eventDescription.matches(fromCityPattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", fromCountryPattern,
          eventDescription), eventDescription.matches(fromCountryPattern));
    }

    public void verifyUpdateDeliveryAddressEventDescription(Order order, String eventDescription) {
      String toAddress1Pattern = f("To Address 1 .* (to|new value) %s.*", order.getToAddress1());
      String toAddress2Pattern = f(".* To Address 2 .* (to|new value) %s.*", order.getToAddress2());
      String toPostcodePattern = f(".* To Postcode .* (to|new value) %s.*", order.getToPostcode());
      String toCityPattern = f(".* To City .* (to|new value) %s.*", order.getToCity());
      String toCountryPattern = f(".* To Country .* (to|new value) %s.*", order.getToCountry());
      assertTrue(f("'%s' pattern is not present in the '%s' event description", toAddress1Pattern,
          eventDescription), eventDescription.matches(toAddress1Pattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", toAddress2Pattern,
          eventDescription), eventDescription.matches(toAddress2Pattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", toPostcodePattern,
          eventDescription), eventDescription.matches(toPostcodePattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", toCityPattern,
          eventDescription), eventDescription.matches(toCityPattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", toCountryPattern,
          eventDescription), eventDescription.matches(toCountryPattern));
    }

    public void verifyUpdatePickupContactInformationEventDescription(Order order,
        String eventDescription) {
      String fromNamePattern = f("From Name .* (to|new value) %s.*", order.getFromName());
      String fromEmailPattern = f(".* From Email .* (to|new value) %s.*", order.getFromEmail());
      String fromContactPattern = f(".* From Contact .* (to|new value) \\%s.*",
          order.getFromContact());
      assertTrue(f("'%s' pattern is not present in the '%s' event description", fromNamePattern,
          eventDescription), eventDescription.matches(fromNamePattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", fromEmailPattern,
          eventDescription), eventDescription.matches(fromEmailPattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", fromContactPattern,
          eventDescription), eventDescription.matches(fromContactPattern));
    }

    public void verifyUpdateDeliveryContactInformationEventDescription(Order order,
        String eventDescription) {
      String toNamePattern = f("To Name .* (to|new value) %s.*", order.getToName());
      String toEmailPattern = f(".* To Email .* (to|new value) %s.*", order.getToEmail());
      String toContactPattern = f(".* To Contact .* (to|new value) \\%s.*", order.getToContact());
      assertTrue(f("'%s' pattern is not present in the '%s' event description", toNamePattern,
          eventDescription), eventDescription.matches(toNamePattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", toEmailPattern,
          eventDescription), eventDescription.matches(toEmailPattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", toContactPattern,
          eventDescription), eventDescription.matches(toContactPattern));
    }

    public void verifyUpdatePickupSlaEventDescription(Order order, String eventDescription) {
      String fromPickUpStartTimePattern = f("Pickup Start Time .* (to|new value) %s %s.*",
          order.getPickupDate(), order.getPickupTimeslot().getStartTime());
      String fromPickUpEndTimePattern = f(".* Pickup End Time .* (to|new value) %s %s.*",
          order.getPickupEndDate(), order.getPickupTimeslot().getEndTime());
      assertTrue(
          f("'%s' pattern is not present in the '%s' event description", fromPickUpStartTimePattern,
              eventDescription), eventDescription.matches(fromPickUpStartTimePattern));
      assertTrue(
          f("'%s' pattern is not present in the '%s' event description", fromPickUpEndTimePattern,
              eventDescription), eventDescription.matches(fromPickUpEndTimePattern));
    }

    public void verifyUpdateDeliverySlaEventDescription(Order order, String eventDescription) {
      String deliveryStartTimePattern = f("Delivery Start Time .* (to|new value) %s %s.*",
          order.getDeliveryDate(), order.getDeliveryTimeslot().getStartTime());
      String deliveryEndTimePattern = f(".* Delivery End Time .* (to|new value) %s %s.*",
          order.getDeliveryDate(), order.getDeliveryTimeslot().getEndTime());
      assertTrue(
          f("'%s' pattern is not present in the '%s' event description", deliveryStartTimePattern,
              eventDescription), eventDescription.matches(deliveryStartTimePattern));
      assertTrue(
          f("'%s' pattern is not present in the '%s' event description", deliveryEndTimePattern,
              eventDescription), eventDescription.matches(deliveryEndTimePattern));
    }

    public void verifyPickupAddressEventDescription(Order order, String eventDescription) {
      String addressPattern = f("Address: %s, %s, %s, %s, %s.*", order.getFromAddress1(),
          order.getFromAddress2(), order.getFromCity(), order.getFromCountry(),
          order.getFromPostcode());
      assertTrue(f("'%s' pattern is not present in the '%s' event description", addressPattern,
          eventDescription), eventDescription.matches(addressPattern));
    }

    public void verifyDeliveryAddressEventDescription(Order order, String eventDescription) {
      String addressPattern = f("Address: %s, %s, %s, %s, %s.*", order.getToAddress1(),
          order.getToAddress2(), order.getToCity(), order.getToCountry(), order.getToPostcode());
      assertTrue(f("'%s' pattern is not present in the '%s' event description", addressPattern,
          eventDescription), eventDescription.matches(addressPattern));
    }

    public void verifyVerifyUpdateCashDescription(Order order, String eventDescription) {
      String cashPattern = null;
      if (String.valueOf(order.getCod().getGoodsAmount()) == null) {
        cashPattern = f("Cash On Delivery changed from 0 to .*", order.getCod().getGoodsAmount());
        assertTrue(f("'%s' pattern is not present in the '%s' event description", cashPattern,
            eventDescription), eventDescription.matches(cashPattern));
      } else {
        cashPattern = f("Cash On Delivery changed from %s to .*", order.getCod().getGoodsAmount());
        assertTrue(f("'%s' pattern is not present in the '%s' event description", cashPattern,
            eventDescription), eventDescription.matches(cashPattern));
      }
    }

    public void verifyHubInboundEventDescription(Order order, String eventDescription) {
      String widthPattern = f(".* Width changed from .* to %s.*",
          order.getDimensions().getWidth().intValue());
      String lengthPattern = f(".* Length changed from .* to %s.*",
          order.getDimensions().getLength().intValue());
      String heightPattern = f(".* Height changed from .* to %s.*",
          order.getDimensions().getHeight().intValue());
      assertTrue(f("'%s' pattern is not present in the '%s' event description", widthPattern,
          eventDescription), eventDescription.matches(widthPattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", lengthPattern,
          eventDescription), eventDescription.matches(lengthPattern));
      assertTrue(f("'%s' pattern is not present in the '%s' event description", heightPattern,
          eventDescription), eventDescription.matches(heightPattern));
    }

    public void verifyHubInboundWithDeviceIdEventDescription(Order order, String eventDescription) {
      String deviceIdPattern = null;

      deviceIdPattern = f(".* Device Id: 12345 .*");
      assertTrue(f("'%s' pattern is not present in the '%s' event description", deviceIdPattern,
          eventDescription), eventDescription.matches(deviceIdPattern));
    }
  }

  public void tagOrderToDP(String dpId) {
    dpDropOffSettingDialog.dropOffDp.selectValue(dpId);
    List<String> dpDropOffDates = dpDropOffSettingDialog.dropOffDate.getOptions();
    dpDropOffSettingDialog.dropOffDate.selectValue(
        dpDropOffDates.get((int) (Math.random() * dpDropOffDates.size())));
    dpDropOffSettingDialog.saveChanges.clickAndWaitUntilDone();
    waitUntilInvisibilityOfToast("Tagging to DP done successfully", true);
  }

  public boolean deliveryIsIndicatedWithIcon() {
    return deliveryDetailsBox.isNinjaCollectTagPresent();
  }

  /**
   * Accessor for Cancel dialog
   */
  public static class CancelOrderDialog extends AntModal {

    public CancelOrderDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "input.ant-input")
    public ForceClearTextBox cancellationReason;

    @FindBy(css = "[data-testid='edit-order-testid.cancel-order.cancel-order.button']")
    public Button cancelOrder;
  }

  /**
   * Accessor for Delivery Details box
   */
  public static class DeliveryDetailsBox extends PageElement {

    @FindBy(xpath = "./div/span[2]")
    public PageElement status;
    @FindBy(xpath = ".//div[@class='layout-row']//h5")
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
    @FindBy(xpath = ".//label[.='Delivery instructions']//following-sibling::div")
    public PageElement deliveryInstructions;
    @FindBy(xpath = ".//span[contains(@class,'ant-tag')][.='RTS']")
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
    private static final String LAST_SERVICE_END_DATE_LOCATOR =
        BOX_LOCATOR + "//div[label[text()='Last Service End']]/p";
    private static final String NV_TAG_LOCATOR = "//nv-tag[@name='commons.ninja-collect']";

    public DeliveryDetailsBox(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
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

    public String getLastServiceEnd() {
      return getText(LAST_SERVICE_END_DATE_LOCATOR);
    }

    public boolean isNinjaCollectTagPresent() {
      return isElementExist(NV_TAG_LOCATOR);
    }
  }

  /**
   * Accessor for Pickup Details box
   */
  public static class PickupDetailsBox extends PageElement {

    @FindBy(xpath = "./div/span[2]")
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
    @FindBy(xpath = ".//label[.='Pickup instructions']//following-sibling::div")
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

    @FindBy(css = "[aria-label='Shipper requested to change']")
    public MdCheckbox shipperRequestedToChange;

    @FindBy(css = "[aria-label='Assign Pickup Location']")
    public MdCheckbox assignPickupLocation;

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
          setMdDatepickerById(DELIVERY_DATE_ID,
              StandardTestUtils.convertToZonedDateTime(textDate, DTF_NORMAL_DATE));
        } catch (DateTimeParseException e) {
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
  public static class DpDropOffSettingDialog extends MdDialog {

    @FindBy(css = "button md-icon[md-svg-icon='md-close']")
    public Button clearSelected;

    @FindBy(name = "commons.save-changes")
    public NvApiTextButton saveChanges;

    @FindBy(css = "[id^='container.order.edit.edit-dp-management-dropoff-date']")
    public MdSelect dropOffDate;

    @FindBy(css = "md-autocomplete")
    public MdAutocomplete dropOffDp;

    public DpDropOffSettingDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  /**
   * Accessor for Delete Order dialog
   */
  public static class DeleteOrderDialog extends AntModal {

    @FindBy(css = "[data-testid='edit-order-testid.delete-order.password.input']")
    public ForceClearTextBox password;

    @FindBy(css = "[data-testid='edit-order-testid.delete-order.delete-order.button']")
    public Button deleteOrder;

    public DeleteOrderDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
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
          setMdDatepickerById(PICKUP_DATE_ID,
              StandardTestUtils.convertToZonedDateTime(textDate, DTF_NORMAL_DATE));
        } catch (DateTimeParseException e) {
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
          setMdDatepickerById(DELIVERY_DATE_ID,
              StandardTestUtils.convertToZonedDateTime(textDate, DTF_NORMAL_DATE));
        } catch (DateTimeParseException e) {
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
  public static class PullFromRouteDialog extends AntModal {

    public PullFromRouteDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = ".ant-checkbox")
    public AntCheckbox toPull;

    @FindBy(xpath = ".//*[.='* Cannot be pulled due to Delivery Success']")
    public PageElement errorHint;

    @FindBy(css = "[data-testid='edit-order-testid.pull-from-route.pull-from-route.button']")
    public Button pullFromRoute;
  }

  public static class EditPriorityLevelDialog extends AntModal {

    public EditPriorityLevelDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[data-testid='edit-order-testid.edit-priority-level.delivery-priority-level.input']")
    public ForceClearTextBox priorityLevel;

    @FindBy(css = "span.ant-typography")
    public PageElement errorMessage;


    @FindBy(css = "[data-testid='edit-order-testid.edit-priority-level.submit-changes.button']")
    public Button saveChanges;
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

  public static class EditOrderDetailsDialog extends AntModal {

    public EditOrderDetailsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[data-testid='edit-order-testid.edit-order-details-dialogue.delvery-type']")
    public AntSelect3 deliveryTypes;

    @FindBy(css = "[data-testid='edit-order-testid.edit-order-details-dialogue.parcel-size']")
    public AntSelect3 parcelSize;

    @FindBy(css = "[data-testid='edit-order-testid.edit-order-details-dialogue.weight']")
    public ForceClearTextBox weight;

    @FindBy(css = "[data-testid='edit-order-testid.edit-order-details-dialogue.length']")
    public ForceClearTextBox length;

    @FindBy(css = "[data-testid='edit-order-testid.edit-order-details-dialogue.width']")
    public ForceClearTextBox width;

    @FindBy(css = "[data-testid='edit-order-testid.edit-order-details-dialogue.breadth']")
    public ForceClearTextBox breadth;

    @FindBy(css = "[data-testid='edit-order-testid.edit-order-details-dialogue.insured-value']")
    public ForceClearTextBox insuredValue;

    @FindBy(css = "[data-testid='edit-order-testid.edit-order-details.submit-changes.button']")
    public Button saveChanges;
  }

  public static class EditInstructionsDialog extends AntModal {

    public EditInstructionsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[data-testid='edit-order-testid.edit-instructions.pickup-instruction.textarea']")
    public ForceClearTextBox pickupInstruction;

    @FindBy(css = "[data-testid='edit-order-testid.edit-instructions.delivery-instruction.textarea']")
    public ForceClearTextBox deliveryInstruction;

    @FindBy(css = "[data-testid='edit-order-testid.edit-instructions.order-instruction.textarea']")
    public ForceClearTextBox orderInstruction;

    @FindBy(css = "[data-testid='edit-order-testid.edit-instructions.save-changes.button']")
    public Button saveChanges;
  }

  public static class EditOrderStampDialog extends AntModal {

    public EditOrderStampDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[data-testid='edit-order-testid.edit-order-stamp.new-stamp-id.input']")
    public ForceClearTextBox stampId;

    @FindBy(css = "[data-testid='edit-order-testid.edit-order-stamp.save.button']")
    public Button save;

    @FindBy(css = "[data-testid='edit-order-testid.edit-order-stamp.remove.button']")
    public Button remove;
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

  public static class EditCashCollectionDetailsDialog extends AntModal {

    public EditCashCollectionDetailsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[data-testid='edit-order-testid.edit-cash-collection-details.cop-input']")
    public ForceClearTextBox copAmount;

    @FindBy(css = "[data-testid='edit-order-testid.edit-cash-collection-details.cod-input']")
    public ForceClearTextBox codAmount;

    @FindBy(css = "[data-testid='edit-order-testid.edit-cash-collection-details.cop-switch']")
    public AntSwitch cop;

    @FindBy(css = "[data-testid='edit-order-testid.edit-cash-collection-details.cod-switch']")
    public AntSwitch cod;

    @FindBy(css = "[data-testid='edit-order-testid.edit-cash-collection-details.submit-changes.button']")
    public Button saveChanges;
  }

  public static class EditDeliveryVerificationRequiredDialog extends AntModal {

    public EditDeliveryVerificationRequiredDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[data-testid='edit-order-testid.edit-dvr.dvr.single-select']")
    public AntSelect3 deliveryVerificationRequired;

    @FindBy(css = "[data-testid='edit-order-testid.edit-dvr.save-changes.button']")
    public Button saveChanges;
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

  public static class EditRtsDetailsDialog extends AntModal {

    public EditRtsDetailsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
    @FindBy(css = "[text='container.order.edit.rts-hint'] p")
    public PageElement hint;

    @FindBy(css = "[data-testid='edit-order-testid.edit-rts-details.rts-reason.single-select']")
    public AntSelect3 reason;

    @FindBy(css = "[data-testid='edit-order-testid.edit-rts-details.name.input']")
    public ForceClearTextBox recipientName;

    @FindBy(css = "[data-testid='edit-order-testid.edit-rts-details.contact.input']")
    public AntTextBox recipientContact;

    @FindBy(css = "[data-testid='edit-order-testid.edit-rts-details.email.input']")
    public ForceClearTextBox recipientEmail;

    @FindBy(css = "[data-testid='edit-order-testid.edit-rts-details.internal-notes.input']")
    public ForceClearTextBox internalNotes;

    @FindBy(css = "[data-testid='edit-order-testid.edit-rts-details.delivery-date.date-select']")
    public ForceClearTextBox deliveryDate;

    @FindBy(css = "[data-testid='edit-order-testid.edit-rts-details.timeslot.single-select']")
    public AntSelect3 timeslot;

    @FindBy(css = "[data-testid='edit-order-testid.edit-details.change-address.button']")
    public Button changeAddress;

    @FindBy(css = "[data-testid='edit-order-testid.edit-rts-details.save-changes.button']")
    public Button saveChanges;

    @FindBy(css = "[data-testid='edit-order-testid.new-address-form.country.input']")
    public ForceClearTextBox country;

    @FindBy(css = "[data-testid='edit-order-testid.new-address-form.city.input']")
    public ForceClearTextBox city;

    @FindBy(css = "[data-testid='edit-order-testid.new-address-form.address-1.input']")
    public ForceClearTextBox address1;

    @FindBy(css = "[data-testid='edit-order-testid.new-address-form.address-2.input']")
    public ForceClearTextBox address2;

    @FindBy(css = "[data-testid='edit-order-testid.new-address-form.postal-code.input']")
    public ForceClearTextBox postcode;
  }
  public static class ResumeOrderDialog extends AntModal {

    public ResumeOrderDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[data-testid='edit-order-testid.resume-order.resume-order.button']")
    public Button resumeOrder;
  }

  public void createTicket(RecoveryTicket recoveryTicket) {
    String trackingId = recoveryTicket.getTrackingId();
    String ticketType = recoveryTicket.getTicketType();

    createTicketDialog.waitUntilVisible();
    waitWhilePageIsLoading(120);
    createTicketDialog.trackingId.setValue(trackingId
        + " "); // Add 1 <SPACE> character at the end of tracking ID to make the textbox get trigged and request tracking ID validation to backend.
    createTicketDialog.entrySource.selectValue(recoveryTicket.getEntrySource());
    createTicketDialog.investigatingDept.selectValue(recoveryTicket.getInvestigatingDepartment());
    createTicketDialog.investigatingHub.searchAndSelectValue(recoveryTicket.getInvestigatingHub());
    createTicketDialog.ticketType.selectValue(ticketType);

    switch (ticketType) {
      case RecoveryTicketsPage.TICKET_TYPE_DAMAGED: {
        //Damaged Details
        createTicketDialog.orderOutcome.searchAndSelectValue(recoveryTicket.getOrderOutcome());
        if (StringUtils.isNotBlank(recoveryTicket.getLiability())) {
          createTicketDialog.liability.selectValue(recoveryTicket.getLiability());
        }
        if (StringUtils.isNotBlank(recoveryTicket.getParcelLocation())) {
          createTicketDialog.parcelLocation.selectValue(recoveryTicket.getParcelLocation());
        }
        if (StringUtils.isNotBlank(recoveryTicket.getDamageDescription())) {
          createTicketDialog.damageDescription.setValue(recoveryTicket.getDamageDescription());
        }
        if (StringUtils.isNotBlank(recoveryTicket.getRtsReason())) {
          createTicketDialog.rtsReason.selectValue(recoveryTicket.getRtsReason());
        }
        break;
      }
      case RecoveryTicketsPage.TICKET_TYPE_MISSING: {
        createTicketDialog.orderOutcome.searchAndSelectValue(recoveryTicket.getOrderOutcome());
        createTicketDialog.parcelDescription.setValue(recoveryTicket.getParcelDescription());
        break;
      }
      case RecoveryTicketsPage.TICKET_TYPE_PARCEL_EXCEPTION: {
        createTicketDialog.ticketSubtype.selectValue(recoveryTicket.getTicketSubType());
        createTicketDialog.orderOutcome.searchAndSelectValue(recoveryTicket.getOrderOutcome());
        if (StringUtils.isNotBlank(recoveryTicket.getRtsReason())) {
          createTicketDialog.rtsReason.selectValue(recoveryTicket.getRtsReason());
        }
        createTicketDialog.exceptionReason.setValue(recoveryTicket.getExceptionReason());
        break;
      }
      case RecoveryTicketsPage.TICKET_TYPE_PARCEL_ON_HOLD: {
        createTicketDialog.ticketSubtype.selectValue(recoveryTicket.getTicketSubType());
        createTicketDialog.orderOutcome.searchAndSelectValue(recoveryTicket.getOrderOutcome());
        if (StringUtils.isNotBlank(recoveryTicket.getRtsReason())) {
          createTicketDialog.rtsReason.selectValue(recoveryTicket.getRtsReason());
        }
        createTicketDialog.issueDescription.setValue(recoveryTicket.getIssueDescription());
        break;
      }
      case RecoveryTicketsPage.TICKET_TYPE_SHIPPER_ISSUE: {
        createTicketDialog.ticketSubtype.selectValue(recoveryTicket.getTicketSubType());
        createTicketDialog.orderOutcome.searchAndSelectValue(recoveryTicket.getOrderOutcome());
        if (StringUtils.isNotBlank(recoveryTicket.getRtsReason())) {
          createTicketDialog.rtsReason.selectValue(recoveryTicket.getRtsReason());
        }
        createTicketDialog.issueDescription.setValue(recoveryTicket.getIssueDescription());
      }
      case RecoveryTicketsPage.TICKET_TYPE_SELF_COLLECTION: {
        createTicketDialog.orderOutcome.searchAndSelectValue(recoveryTicket.getOrderOutcome());
        break;
      }
    }

    createTicketDialog.customerZendeskId.setValue(recoveryTicket.getCustZendeskId());
    createTicketDialog.shipperZendeskId.setValue(recoveryTicket.getShipperZendeskId());
    createTicketDialog.ticketNotes.setValue(recoveryTicket.getTicketNotes());

    retryIfRuntimeExceptionOccurred(() -> {
      if (createTicketDialog.createTicket.isDisabled()) {
        createTicketDialog.trackingId.setValue(trackingId + " ");
        pause100ms();
        throw new NvTestRuntimeException(
            "Button \"Create Ticket\" still disabled. Trying to key in Tracking ID again.");
      }
    });

    createTicketDialog.createTicket.clickAndWaitUntilDone(60);
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
          .filter(chatOrderItem -> equalsIgnoreCase(trackingId, chatOrderItem.trackingId.getText()))
          .findFirst().orElseThrow(() -> new AssertionError(
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
    actualSortCode = actualSortCode.replaceAll("\\n|F O R  N I N J A  V A N  U S E", "");
    Assertions.assertThat(sortCode.equalsIgnoreCase(actualSortCode)).as("Sort Code").isTrue();
  }

  @FindBy(css = "[aria-label*='Order outcome']")
  public List<PageElement> orderOutcomeDialog;

  @FindBy(css = "button[aria-label='No']")
  public PageElement noBtn;

  @FindBy(css = "button[aria-label='Keep']")
  public PageElement keepBtn;

  public void chooseCurrentOrderOutcome(String value) {
    if (orderOutcomeDialog.size() > 0) {
      if (equalsAnyIgnoreCase(value, "keep", "yes")) {
        keepBtn.click();
      }
      if (equalsIgnoreCase(value, "no")) {
        noBtn.click();
      }
    }

  }

  public String getEventTimeByEventName(String eventName) {
    int rowWithExpectedEvent = 1;
    for (int i = 1; i <= eventsTable.getRowsCount(); i++) {
      String eventNameActual = getTextOnTableEvent(i, EVENT_NAME);
      if (eventName.equals(eventNameActual)) {
        rowWithExpectedEvent = i;
      }
    }
    OrderEvent eventRow = eventsTable.readEntity(rowWithExpectedEvent);
    String eventTime = eventRow.getEventTime();
    return eventTime;
  }

}