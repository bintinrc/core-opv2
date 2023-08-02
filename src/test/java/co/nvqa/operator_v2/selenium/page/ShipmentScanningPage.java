package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.NvTable;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestUtils;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.Color;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Lanang Jati
 * <p>
 * Modified by Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class ShipmentScanningPage extends OperatorV2SimplePage {

  private static final Logger LOGGER = LoggerFactory.getLogger(ShipmentScanningPage.class);
  public static final String XPATH_HUB_DROPDOWN = "//md-select[@name='hub']";
  public static final String XPATH_SHIPMENT_DROPDOWN = "//md-select[@name='shipment']";
  //public static final String XPATH_HUB_ACTIVE_DROPDOWN = "//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option";
  public static final String XPATH_SELECT_SHIPMENT_BUTTON = "//button[.='Select Shipment'] | //button[.='Add Parcels to Shipment']";
  public static final String XPATH_BARCODE_SCAN = "//div[.='Scan Shipment to Inbound']//input | //input[@id='toAddTrackingId']";
  public static final String XPATH_REMOVE_SHIPMENT_SCAN = "//div[.='Remove Shipment']//input | //input[@id='toRemoveTrackingId']";
  //public static final String XPATH_ORDER_IN_SHIPMENT = "//td[contains(@class, 'tracking-id')]";
  public static final String XPATH_RACK_SECTOR = "//div[contains(@class,'rack-sector-card')]/div/h2[@ng-show='ctrl.rackInfo']";
  public static final String XPATH_TRIP_DEPART_PROCEED_BUTTON = "//nv[]";
  public static final String XPATH_SCAN_SHIPMENT_CONTAINER = "//form[.='Scan Shipment to Inbound']//parent::div";
  public static final String XPATH_SCANNED_SHIPMENT = "//td[contains(@class,'shipment-id')]";
  public static final String XPATH_SCANNED_SHIPMENT_BY_ID = "//td[contains(@class,'shipment-id')][.='%s']";
  public static final String XPATH_ACTIVE_INPUT_SELECTION = "//div[contains(@class,'md-select-menu-container nv-input-select-container md-active md-clickable')]//md-option[1]";
  public static final String XPATH_INBOUND_HUB_TEXT = "//div[span[.='Inbound Hub']]/following-sibling::span";
  public static final String XPATH_SHIPMENT_ID = "//td[@class='shipment_id']";
  public static final String XPATH_SMALL_SUCCESS_MESSAGE = "//form[.='Scan Shipment to Inbound']/following-sibling::div[@class='message']";

  public static final String XPATH_SCANTEXT_MESSAGE = "//h2[@class='scan-state-text']";
  public static final String XPATH_STATUS_CARD_BOX = "//div[@class='ant-row']//div[3]//div";
  public static final String XPATH_ZONE_CARD_BOX = "//div[@class='ant-row']//div[4]//div";
  private static String antNotificationMessage = "";

  @FindBy(xpath = "//div[span[.='Driver']]/following-sibling::span")
  public TextBox driverText;

  @FindBy(xpath = "//div[span[.='Movement Trip']]/following-sibling::span")
  public TextBox movementTripText;

  @FindBy(xpath = XPATH_INBOUND_HUB_TEXT)
  public TextBox inboundHubText;

  @FindBy(xpath = "//div[span[.='Inbound Type']]/following-sibling::span")
  public TextBox inboundTypeText;

  @FindBy(xpath = "//div[.='End Inbound']")
  public Button endInboundButton;

  @FindBy(xpath = "//h5[contains(.,'Shipments Scanned to Hub')]")
  public TextBox numberOfScannedParcel;

  @FindBy(xpath = "//div[contains(@class, 'ant-modal-confirm')]")
  public WebElement tripDepartureDialog;

  @FindBy(xpath = "//span[@class='ant-modal-confirm-title']")
  public WebElement dialogTitle;

  @FindBy(xpath = "//div[@class='ant-modal-confirm-content']")
  public WebElement dialogMessage;

  @FindBy(xpath = "//span[@class='ant-modal-confirm-title']")
  public List<WebElement> antModalConfirmTitleElements;

  public String ANT_MODAL_CONTENT_XPATH = "//div[contains(@class,'ant-modal-wrap') and not(contains(@style, 'none'))]//div[contains(@class,'ant-modal-content')]";
  public String ANT_MODAL_CONFIRM_TITLE_XPATH = "//div[contains(@class,'ant-modal-wrap') and not(contains(@style, 'none'))]//span[@class='ant-modal-confirm-title']";
  public String ANT_MODAL_CONFIRM_CONTENT_XPATH = "//div[contains(@class,'ant-modal-wrap') and not(contains(@style, 'none'))]//div[@class='ant-modal-confirm-content']";

  @FindBy(xpath = ".//button[.='Cancel']")
  public Button cancel;

  @FindBy(xpath = ".//button[.='OK' or .='Proceed']")
  public Button okorProceed;

  @FindBy(xpath = ".//button[.='OK']")
  public Button ok;

  @FindBy(xpath = ".//button[.='Yes, continue']")
  public Button yesContinue;

  @FindBy(xpath = ".//button[.='No, go back']")
  public Button noGoBack;

  @FindBy(css = "md-dialog")
  public LeavePageDialog leavePageDialog;

  @FindBy(css = "md-dialog")
  public RemoveAllParcelsDialog removeAllParcelsDialog;

  public String shipmentWithTripDialog = "//div[contains(@class,'ant-modal-content')]";

  @FindBy(xpath = "//div[@class='ant-modal-title']")
  public TextBox shipmentWithTripDialogTitle;

  @FindBy(xpath = "//td[contains(@class,'shipment-id')]")
  public List<PageElement> shipmentIdList;

  @FindBy(xpath = "//td[contains(@class,'origin-hub-name')]")
  public List<PageElement> originHubNameList;

  @FindBy(xpath = "//td[contains(@class,'dropoff-hub-name')]")
  public List<PageElement> dropOffHubNameList;

  @FindBy(xpath = "//td[contains(@class,'destination-hub-name')]")
  public List<PageElement> destinationHubNameList;

  @FindBy(xpath = "//td[contains(@class,'message')]")
  public List<PageElement> commentsList;

  @FindBy(css = "md-dialog")
  public ConfirmRemoveDialog confirmRemoveDialog;

  public String errorShipment = "//div[@class='ant-modal-content']";

  @FindBy(xpath = "//div[@class='ant-modal-title']")
  public TextBox errorDialogTitle;

  @FindBy(xpath = "//span[.='Cancel']")
  public Button errorShipmentCancel;

  @FindBy(xpath = "//span[.='Proceed']")
  public Button errorShipmentProceed;

  @FindBy(xpath = "//div[contains(@class,'ant-modal-body')]//td[contains(@class,'shipment-id')]")
  public TextBox shipmentIdTextBox;

  @FindBy(xpath = "//h5[contains(., 'Unregistered Shipments')]//ancestor::div[contains(@class,'ant-table-title')]/following-sibling::div/div[contains(@class,'ant-table-body')]//td[contains(@class,'shipment-id')]")
  public TextBox unregisterShipmentIdTextBox;

  @FindBy(xpath = "//h5[contains(., 'Missing Shipments')]//ancestor::div[contains(@class,'ant-table-title')]/following-sibling::div/div[contains(@class,'ant-table-body')]//td[contains(@class,'shipment-id')]")
  public TextBox missingShipmentIdTextBox;

  @FindBy(xpath = "//div[contains(@class,'ant-modal-body')]//td[contains(@class,'message')]")
  public TextBox resultTextBox;

  @FindBy(xpath = "//h5[contains(., 'Unregistered Shipments')]//ancestor::div[contains(@class,'ant-table-title')]/following-sibling::div/div[contains(@class,'ant-table-body')]//td[contains(@class,'message')]")
  public TextBox unregisterresultTextBox;

  @FindBy(xpath = "//h5[contains(., 'Missing Shipments')]//ancestor::div[contains(@class,'ant-table-title')]/following-sibling::div/div[contains(@class,'ant-table-body')]//td[contains(@class,'message')]")
  public TextBox missingresultTextBox;

  @FindBy(xpath = "//button[contains(@class,'sc-qvapu6-1 bTUICx')]")
  public Button removeButton;

  @FindBy(xpath = "//button[contains(@class,'ant-modal-close')]")
  public Button cancelButton;

  @FindBy(xpath = "//button//span[contains(text(), ' shipments')]")
  public TextBox shipmentToGo;

  @FindBy(xpath = "//button//span[contains(text(), ' shipments')]")
  public TextBox shipmentToUnload;

  @FindBy(xpath = "//div[contains(@class,'nv-h4')]")
  public TextBox pageTitle;

  @FindBy(xpath = "//div//h1")
  public TextBox shipmentDetailPageShipmentId;

  @FindBy(xpath = "//div[label[.='Origin Hub']]//nv-autocomplete")
  public NvAutocomplete selectOriginHub;

  @FindBy(xpath = "//div[label[.='Destination Hub']]//nv-autocomplete")
  public NvAutocomplete selectDestinationHub;

  @FindBy(xpath = "//md-input-container//md-select")
  public MdSelect selectShipmentType;

  @FindBy(xpath = "//div[@class='shipment-selection']//nv-autocomplete")
  public NvAutocomplete selectShipmentFilter;

  @FindBy(name = "container.shipment-scanning.select-shipment")
  public NvApiTextButton selectShipmentButton;

  @FindBy(css = "md-dialog")
  public CloseShipmentDialog closeShipmentDialog;

  @FindBy(xpath = "//form[.='Remove Shipment']/following-sibling::div[@class='message']")
  public TextBox smallRemoveMessage;

  @FindBy(xpath = "//nv-table[@param='ctrl.missingTableParam']//table[@class='table-body']")
  public NvTable<ErrorShipmentRow> missingShipmentRow;

  @FindBy(xpath = "//nv-table[@param='ctrl.unregisteredTableParam']//table[@class='table-body']")
  public NvTable<ErrorShipmentRow> unregisteredShipmentRow;

  @FindBy(xpath = "//button[.='Force Completion']")
  public Button forceCompleteButton;

  @FindBy(xpath = "//input[starts-with(@id, 'shipment_id')]")
  public TextBox shipmentIdField;

  @FindBy(xpath = "//div[@data-testid='shipment-id-select']/div/span[2]")
  public PageElement selectedShipmentId;

  @FindBy(css = "[data-testid='close-shipment-buton']")
  public Button closeShipmentButton;

  @FindBy(xpath = "//button[@data-testid='close-shipment-buton']")
  public Button closeShipment;

  @FindBy(xpath = "//button[@data-testid='confirm-close-shipment-button']")
  public Button confirmCloseShipment;

  @FindBy(xpath = "//div[@class='ant-modal-content']//button[.='Close Shipment']")
  public PageElement closeShipmentButtonOnDialog;

  @FindBy(id = "toRemoveTrackingId")
  public TextBox removeTrackingIdField;

  @FindBy(xpath = "//div[contains(@class, 'ant-space-item')][contains(text(), 'INVALID')]")
  public PageElement invalidOrderScanned;

  @FindBy(tagName = "iframe")
  private PageElement pageFrame;

  @FindBy(xpath = "//div[@data-testid='origin-hub-select']//span[contains(@class, 'selection-placeholder') and contains(text(), 'Search or Select')]")
  private PageElement origHubPlaceholder;

  @FindBy(xpath = "//div[@data-testid='destination-hub-select']//span[contains(@class, 'selection-placeholder') and contains(text(), 'Search or Select')]")
  private PageElement destHubPlaceholder;

  @FindBy(xpath = "//div[@data-testid='shipment-type-select']//span[contains(@class, 'selection-placeholder') and contains(text(), 'Select a shipment type')]")
  private PageElement shipmentTypePlaceholder;

  public ShipmentScanningPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void selectHub(String hubName) {
    origHubPlaceholder.waitUntilVisible();
    sendKeysAndEnterById("orig_hub", hubName);
    pause50ms();
  }

  public void selectDestinationHub(String destHub) {
    destHubPlaceholder.waitUntilVisible();
    sendKeysAndEnterById("dest_hub", destHub);
    pause50ms();
  }

  public void fillInComments(String comments) {
    sendKeys("//textarea[@data-testid='create-shipment-comment-input']", comments);
    pause50ms();
  }

  public void selectHubCreate(String hubName) {
    origHubPlaceholder.waitUntilVisible();
    sendKeysAndEnterById("orig_hub_id", hubName);
    pause50ms();
  }

  public void selectDestinationHubCreate(String destHub) {
    destHubPlaceholder.waitUntilVisible();
    sendKeysAndEnterById("dest_hub_id", destHub);
    pause50ms();
  }

  private String capitalize(String str) {
    return Arrays.stream(str.trim().split("_"))
        .map(t -> t.substring(0, 1).toUpperCase() + t.substring(1).toLowerCase())
        .collect(Collectors.joining(" "));
  }

  public void selectShipmentTypeCreate(String shipmentType) {
    shipmentTypePlaceholder.waitUntilVisible();
    // TestUtils.findElementAndClick("shipment_type", "id", getWebDriver());
    click("//div[@data-testid='create-shipment-type-select']");
    TestUtils.findElementAndClick("//div[.='" + shipmentType + "']", "xpath", getWebDriver());
  }

  public void selectShipmentId(Long shipmentId) {
    shipmentIdField.sendKeys(shipmentId.toString());
    pause4s();
    shipmentIdField.sendKeys(Keys.RETURN);
  }

  public void waitUntilShipmentIdFilled(Long shipmentId) {
    String shipmentIdValue = selectedShipmentId.getAttribute("title");
    Assertions.assertThat(shipmentIdValue).as("Shipment id field is filled").isEqualTo(shipmentId.toString());
  }

  public void selectShipmentIdFast(String shipmentId) {
    sendKeys("//nv-autocomplete[@item-types='shipment']//input", shipmentId);
    pause2s();
    clickf("//li//span[starts-with(text(),'%s')]", shipmentId);
    pause50ms();
  }

  public void clickSelectShipment() {
    TestUtils.findElementAndClick(XPATH_SELECT_SHIPMENT_BUTTON, "xpath", getWebDriver());
  }

  public void selectShipmentType(String shipmentType) {
    TestUtils.findElementAndClick("shipment_type", "id", getWebDriver());
    TestUtils.findElementAndClick("//div[.='" + capitalize(shipmentType) + "']", "xpath",
        getWebDriver());
  }

  public void scanBarcode(String trackingId) {
    click(XPATH_BARCODE_SCAN);
    sendKeysAndEnter(XPATH_BARCODE_SCAN, trackingId);
  }

  public void checkOrderInShipment(String trackingId) {
    WebElement orderWe = getWebDriver().findElement(By.xpath(String
        .format("//td[contains(@class, 'tracking-id')][contains(text(), '%s')]", trackingId)));
    boolean orderExist = orderWe != null;
    Assertions.assertThat(orderExist).as("order " + trackingId + " doesn't exist in shipment")
        .isTrue();
  }

  // to avoid popup alert so retry can run
  public void checkAndRemoveScannedOrdersIfInvalid() {
    if(invalidOrderScanned.isDisplayedFast())
    {
      List<WebElement> listOfScannedTrackingIdsAsListWes = findElementsBy(By.xpath("//td[contains(@class, 'tracking-id')]"));
      if(listOfScannedTrackingIdsAsListWes.size()!=0)
      {
        for(WebElement we : listOfScannedTrackingIdsAsListWes){
          removeTrackingIdField.sendKeys(we.getText());
          removeTrackingIdField.clear();
        }
      }
      throw new NvTestRuntimeException("One of the tracking ids invalid");
    }
  }

  public void checkOrderNotInShipment(String trackingId) {
    retryIfAssertionErrorOccurred(() -> {
      try {
        List<String> shipmentsList = getTextOfElements("//td[contains(@class, 'tracking-id')]");
        Assertions.assertThat(!shipmentsList.contains(trackingId))
            .as("Order " + trackingId + " exists in shipment").isTrue();
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        throw ex;
      }
    }, getCurrentMethodName(), 1000, 3);

  }

  public void closeShipment() {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pause2s();
      closeShipmentButton.click();
      waitUntilVisibilityOfElementLocated(
          "//div[contains(@class,'ant-modal-wrap') and not(contains(@style, 'none'))]//div[contains(@class,'ant-modal-content')]");
      TestUtils.callJavaScriptExecutor("arguments[0].click();",
          closeShipmentButtonOnDialog.getWebElement(),
          getWebDriver());
      String toastMessage = getAntTopText();
      LOGGER.info(toastMessage);
      Assertions.assertThat(toastMessage)
          .as("Toast message not contains Shipment <SHIPMENT_ID> created")
          .contains("Shipment", "closed");
      waitUntilInvisibilityOfElementLocated("//div[@class='ant-message-notice']");
    }, getCurrentMethodName(), 500, 2);
  }

  public void closeShipmentWithData(String originHubName, String destinationHubName,
      String shipmentType, String shipmentId) {
    pause10s();
    switchTo();
    selectHub(originHubName);
    selectDestinationHub(destinationHubName);
    selectShipmentType(shipmentType);
    waitUntilElementIsClickable("//input[@id='shipment_id']");
    selectShipmentId(Long.parseLong(shipmentId));
    clickSelectShipment();
    waitUntilVisibilityOfElementLocated("//button//span[.='Close Shipment']");
    closeShipment();
  }

  public void scanAndCloseShipmentWithData(String originHubName, String destinationHubName,
      String shipmentType, String shipmentId, String trackingId) {
    pause10s();
    switchTo();
    waitUntilVisibilityOfElementLocated(
        "//div[span[input[@id='orig_hub']]]//span[.='Search or Select']");
    selectHub(originHubName);
    selectDestinationHub(destinationHubName);
    selectShipmentType(shipmentType);
    waitUntilElementIsClickable("//input[@id='shipment_id']");
    selectShipmentId(Long.parseLong(shipmentId));
    clickSelectShipment();
    scanBarcode(trackingId);
    checkOrderInShipment(trackingId);
    waitUntilVisibilityOfElementLocated("//button//span[.='Close Shipment']");
    closeShipment();
  }

  public void scanAndCloseShipmentsWithData(String originHubName, String destinationHubName,
      String shipmentType, String shipmentId, String trackingId) {
    waitUntilVisibilityOfElementLocated(
        "//div[span[input[@id='shipment_id']]]//span[.='Search or Select']");
    waitUntilElementIsClickable("//input[@id='shipment_id']");
    selectShipmentId(Long.parseLong(shipmentId));
    clickSelectShipment();
    scanBarcode(trackingId);
    checkOrderInShipment(trackingId);
    waitUntilVisibilityOfElementLocated("//button//span[.='Close Shipment']");
    closeShipment();
  }

  public void removeOrderFromShipment(String firstTrackingId) {
    pause1s();
    sendKeysAndEnter("//input[@aria-label='input-tracking_id']", firstTrackingId);

    pause1s();
    waitUntilVisibilityOfElementLocated("//tr[@data-row-key='" + firstTrackingId + "']//button");
    waitUntilElementIsClickable("//tr[@data-row-key='" + firstTrackingId + "']//button");
    click("//tr[@data-row-key='" + firstTrackingId + "']//button");

    pause1s();
    waitUntilVisibilityOfElementLocated("//div[contains(@class,'ant-modal-content')]");
    TestUtils.callJavaScriptExecutor("arguments[0].click();",
        getWebDriver().findElement(By.xpath("//button[.='Confirm Remove']")), getWebDriver());
    String toastMessage = getAntTopText();
    LOGGER.info(toastMessage);
    Assertions.assertThat(toastMessage)
        .as("Success Delete Order tracking ID " + firstTrackingId)
        .isEqualTo("Success Delete Order tracking ID " + firstTrackingId);
    waitUntilInvisibilityOfElementLocated("//div[@class='ant-message-notice']");
  }

  public void removeOrderFromShipmentWithErrorAlert(String firstTrackingId) {
    removeTrackingIdField.pause3s();
    removeTrackingIdField.sendKeysAndEnterNoXpath(firstTrackingId);
    removeTrackingIdField.pause10s();
    String statusCardText = findElementByXpath(XPATH_STATUS_CARD_BOX).getText();
    Assertions.assertThat(statusCardText.toLowerCase()).as("Invalid contained").contains("invalid");
    Assertions.assertThat(statusCardText.toLowerCase()).as("Not in Shipment  contained")
        .contains("not in shipment");
  }

  public void verifyTheSumOfOrderIsDecreased(int expectedSumOfOrder) {
    String actualSumOfOrder = getText(
        "//nv-icon-text-button[@label='container.shipment-scanning.remove-all']/preceding-sibling::h5")
        .substring(0, 1);
    int actualSumOfOrderAsInt = Integer.parseInt(actualSumOfOrder);
    Assertions.assertThat(actualSumOfOrderAsInt).as("Sum Of Order is not the same : ")
        .isEqualTo(expectedSumOfOrder);
  }

  public void removeAllOrdersFromShipment() {
    pause1s();
    click("//button//span[.='Remove All']");
    waitUntilVisibilityOfElementLocated("//div[contains(@class,'ant-modal-content')]");
    TestUtils.callJavaScriptExecutor("arguments[0].click();",
        getWebDriver().findElement(By.xpath("//button[.='Remove']")), getWebDriver());
    waitUntilInvisibilityOfElementLocated(
        "//div[contains(@class,'ant-modal-title')][.='Removing all']");
  }

  public void verifyTheSumOfOrderIsZero() {
    String actualSumOfOrder = getText(
        "//div[@class='ant-space-item']//h4").substring(0, 1);
    int actualSumOfOrderAsInt = Integer.parseInt(actualSumOfOrder);
    Assertions.assertThat(actualSumOfOrderAsInt).as("Sum Of Order is not the same : ").isEqualTo(0);
  }

  public void verifyOrderIsRedHighlighted() {
    isElementExist("//tr[contains(@class,'highlight')]");
    isElementExist("//div[contains(@class,'error-border')]");
  }

  public void verifyOrderIsBlueHighlighted() {
    Color statusCardColor = getBackgroundColor(XPATH_STATUS_CARD_BOX);
    Color zoneCardColor = getBackgroundColor(XPATH_ZONE_CARD_BOX);
    String expectedColor = "#55a1e8";
    Assertions.assertThat(statusCardColor.asHex()).as("Status Card color is blue")
        .isEqualTo(expectedColor);
    Assertions.assertThat(zoneCardColor.asHex()).as("Zone Card color is blue")
        .isEqualTo(expectedColor);
  }

  public void verifyToastWithMessageIsShown(String expectedToastMessage) {
    retryIfAssertionErrorOccurred(() -> {
      try {
        String actualToastMessage = "";
        if (null == antNotificationMessage || antNotificationMessage.equals("")) {
          if (isElementExistFast("//div[@class='ant-message-notice']//span[2]")) {
            actualToastMessage = getAntTopText();
          } else {
            actualToastMessage = getAntTopTextV2();
          }
        } else {
          actualToastMessage = antNotificationMessage;
        }
        antNotificationMessage = "";
        Assertions.assertThat(actualToastMessage).as("Shipment inbound toast message is the same")
            .isEqualTo(expectedToastMessage);
      } catch (Throwable ex) {
        NvLogger.error(ex.getMessage());
        throw ex;
      }
    }, getCurrentMethodName(), 500, 2);
    pause5s();
  }

  public void verifyBottomToastWithMessageIsShown(String expectedToastMessage) {
    String actualToastMessage = getToastBottomText();
    assertEquals(expectedToastMessage, actualToastMessage);
    pause5s();
  }

  public void verifyBottomToastContainingMessageIsShown(String expectedToastMessageContain) {
    String actualToastMessage = getAntNotificationMessage();
    Assertions.assertThat(actualToastMessage)
        .as("Toast message contains %s", expectedToastMessageContain)
        .contains(expectedToastMessageContain);
  }

  public void verifyToastContainingMessageIsShown(String expectedToastMessageContain) {
    String actualToastMessage = "";
    if (null == antNotificationMessage || antNotificationMessage.equals("")) {
      actualToastMessage = getAntTopText();
    } else {
      actualToastMessage = antNotificationMessage;
    }
    Assertions.assertThat(actualToastMessage)
        .as("Toast message contains %s", expectedToastMessageContain)
        .contains(expectedToastMessageContain);
  }

  public void verifyBottomToastDriverInTripContainingEitherMessage(
      List<String> expectedToastMessages) {
    String actualToastMessage = getAntNotificationMessage().split(" with expected ")[0];
    Assertions.assertThat(actualToastMessage)
        .as("Toast message contains either %s or %s", expectedToastMessages.get(0),
            expectedToastMessages.get(1))
        .containsAnyOf(expectedToastMessages.get(0), expectedToastMessages.get(1));
  }


  public void verifyScanShipmentColor(String expectedContainerColorAsHex) {
    String actualContainerColorAsHex = getBackgroundColor(XPATH_SCAN_SHIPMENT_CONTAINER).asHex();
    Assertions.assertThat(actualContainerColorAsHex).as("Scan container color is the same")
        .isEqualTo(expectedContainerColorAsHex);
  }

  public void verifyScannedShipmentColor(String expectedShipmentColorAsHex) {
    String actualColorAsHex = getBackgroundColor(XPATH_SCANNED_SHIPMENT).asHex();
    Assertions.assertThat(actualColorAsHex).as("Scanned shipment color:")
        .isEqualTo(expectedShipmentColorAsHex);
  }

  public void verifyScannedShipmentColorById(String expectedShipmentColorAsHex,
      String expectedShipmentId) {
    waitUntilVisibilityOfElementLocated(f(XPATH_SCANNED_SHIPMENT_BY_ID, expectedShipmentId));
    String actualShipmentId = findElementByXpath(
        f(XPATH_SCANNED_SHIPMENT_BY_ID, expectedShipmentId)).getText();
    String actualColorAsHex = getBackgroundColor(
        f(XPATH_SCANNED_SHIPMENT_BY_ID, expectedShipmentId)).asHex();

    assertEquals(expectedShipmentId, actualShipmentId);
    assertEquals(expectedShipmentColorAsHex, actualColorAsHex);
  }

  public void clickEndShipmentInbound() {
    pause3s();
    endInboundButton.click();
    waitUntilVisibilityOfElementLocated(
        "//div[ contains(@role,'dialog') and not(contains(@style, 'none'))]//div[contains(@class, 'ant-modal-content')]");
  }

  public void clickProceedInEndInboundDialog() {
    waitUntilVisibilityOfElementLocated(ANT_MODAL_CONTENT_XPATH);
    String dialogTitleText = getWebDriver().findElement(By.xpath(ANT_MODAL_CONFIRM_TITLE_XPATH))
        .getText();
    Assertions.assertThat(dialogTitleText).as("Dialog title is the same")
        .isEqualTo("Confirm End Inbound");

    String dialogMessageText = getWebDriver().findElement(By.xpath(ANT_MODAL_CONFIRM_CONTENT_XPATH))
        .getText();
    Assertions.assertThat(dialogMessageText).as("Dialog message text is the same")
        .isEqualTo("Are you sure you want to end inbound?");

    ok.waitUntilClickable();
    ok.click();
    pause2s();
  }

  public void clickProceedInTripDepartureDialog() {
    if (null != antModalConfirmTitleElements) {
      String dialogTitleText = dialogTitle.getText();
      Assertions.assertThat(dialogTitleText).as("Dialog title is the same")
          .isEqualTo("Trip Departure");

      String dialogMessageText = dialogMessage.getText();
      Assertions.assertThat(dialogMessageText).as("Dialog message text is the same")
          .isEqualTo("Are you sure you want to start departure?");
    }
    okorProceed.waitUntilClickable();
    okorProceed.click();
    pause2s();
    antNotificationMessage = getAntNotificationMessage();
  }

  public void clickGoBackInCancelledTripDepartureDialog(String shipmentId) {
    waitUntilVisibilityOfElementLocated(errorShipment);
    /*String dialogTitleText = findElementByXpath("//span[@class='ant-modal-confirm-title']").getText();
   Assertions.assertThat(dialogTitleText).as("Dialog title is the same").isEqualTo("Proceed to inbound Cancelled Shipment?");

    String dialogMessageText = findElementByXpath("//div[@class='ant-modal-confirm-content']").getText();
    assertThat("Dialog message text is the same", dialogMessageText,
            equalTo("Shipment "+shipmentId+" is in 'Cancelled' status. Are you sure want to proceed to inbound?"));*/

    noGoBack.waitUntilClickable();
    noGoBack.click();
    //antNotificationMessage = getAntNotificationMessage();
  }

  public void clickYesContinueInInboundScanningDialog() {
    yesContinue.waitUntilClickable();
    yesContinue.click();
  }

  public String getAntNotificationMessage() {
    String notificationXpath = "//div[contains(@class,'ant-notification')]//div[@class='ant-notification-notice-message']";
    waitUntilVisibilityOfElementLocated(notificationXpath);
    WebElement notificationElement = findElementByXpath(notificationXpath);
    antNotificationMessage = notificationElement.getText();
    waitUntilInvisibilityOfNotification(notificationXpath, false);
    return antNotificationMessage;
  }

  public void clickLeavePageDialog() {
    WebElement leavePageButton = getWebDriver().findElement(By.cssSelector("[aria-label='Leave']"));
    leavePageButton.click();
  }

  public void clickRemoveButton() {
    removeButton.click();
    ok.waitUntilClickable();
    ok.click();
  }

  public void verifyErrorShipmentWithMessage(String shipmentId, String resultMessage) {
    waitUntilVisibilityOfElementLocated(errorShipment);
    String dialogTitleText = errorDialogTitle.getText();
    assertEquals("Error Shipment", dialogTitleText);

    String actualShipmentId = shipmentIdTextBox.getText();
    String actualResultMessage = resultTextBox.getText();

    assertEquals(shipmentId, actualShipmentId);
    assertEquals(resultMessage, actualResultMessage);
  }

  public void verifyErrorShipmentWithMessage(String shipmentId, String resultMessage,
      String errorShipmentType) {
    waitUntilVisibilityOfElementLocated(errorShipment);
    String dialogTitleText = errorDialogTitle.getText();
    assertEquals("Error Shipment", dialogTitleText);
    String actualShipmentId = "";
    String actualResultMessage = "";

    if ("unregistered shipments".equals(errorShipmentType)) {
      actualShipmentId = unregisterShipmentIdTextBox.getText();
      actualResultMessage = unregisterresultTextBox.getText();
    }

    if ("missing shipments".equals(errorShipmentType)) {
      actualShipmentId = missingShipmentIdTextBox.getText();
      actualResultMessage = missingresultTextBox.getText();
    }

    Assertions.assertThat(actualShipmentId).as("Shipment id is equal").isEqualTo(shipmentId);
    Assertions.assertThat(actualResultMessage).as("Result message is equal")
        .isEqualTo(resultMessage);
  }

  public void clickCancelInMdDialog() {
    cancelButton.waitUntilClickable();
    cancelButton.click();
  }

  public void clickProceedButtonInErrorShipmentDialog() {
    errorShipmentProceed.waitUntilClickable();
    errorShipmentProceed.click();
    antNotificationMessage = getAntNotificationMessage();
  }

  public void verifyShipmentWithTripData(Map<String, String> finalData,
      String expectedDialogTitle) {
    String shipmentCount = finalData.get("shipmentCount");
    String dialogTitle = f("%s (%s)", expectedDialogTitle, shipmentCount);
    if (finalData.get("inboundType") != null && "Into Hub".equals(finalData.get("inboundType"))) {
      dialogTitle = f("shipments to unload (%s)", shipmentCount);
    }
    String shipmentId = finalData.get("shipmentId");
    String originHub = finalData.get("originHub");
    String dropOffHub = finalData.get("dropOffHub");
    String destinationHub = finalData.get("destinationHub");
    String comments = finalData.get("comments");

    waitUntilVisibilityOfElementLocated(shipmentWithTripDialog);
    String actualDialogTitle = shipmentWithTripDialogTitle.getText().toLowerCase();
    int index = 0;
    for (PageElement shipmentIdElement : shipmentIdList) {
      String currentShipmentId = shipmentIdElement.getText().trim();
      if (shipmentId.equals(currentShipmentId)) {
        break;
      }
      index++;
    }
    String actualShipmentId = shipmentIdList.get(index).getText();
    String actualOriginHub = originHubNameList.get(index).getText();
    String actualDropOffHub = dropOffHubNameList.get(index).getText();
    String actualDestinationHub = destinationHubNameList.get(index).getText();
    String actualComments = commentsList.get(index).getText();

    Assertions.assertThat(actualDialogTitle).as("Dialog title is equal").isEqualTo(dialogTitle);
    Assertions.assertThat(actualShipmentId).as("Shipment id is equal").isEqualTo(shipmentId);
    Assertions.assertThat(actualOriginHub).as("Origin hub is equal").isEqualTo(originHub);
    Assertions.assertThat(actualDropOffHub).as("Drop off hub is equal").isEqualTo(dropOffHub);
    Assertions.assertThat(actualDestinationHub).as("Destination hub is equal").isEqualTo(destinationHub);
    Assertions.assertThat(actualComments).as("Comments is equal").isEqualTo(comments);
    cancelButton.click();
  }

  public void verifyCreatedShipmentsShipmentToGoWithTripDataLastIndexTransitHub(
      Map<String, String> finalData) {
    String[] shipmentIds = finalData.get("shipmentIds").split(", ");
    for (int count = 0; count < shipmentIds.length; count++) {
      finalData.put("shipmentId", shipmentIds[count]);
      if (count == (shipmentIds.length - 1)) {
        finalData.put("dropOffHub", "-");
        finalData.put("comments", "-");
      }
      verifyShipmentWithTripData(finalData, "shipments to go with trip");
    }
  }


  public void switchToOtherWindow() {
    waitUntilNewWindowOrTabOpened();
    Set<String> windowHandles = getWebDriver().getWindowHandles();

    for (String windowHandle : windowHandles) {
      getWebDriver().switchTo().window(windowHandle);
    }
  }

  public void clickShipmentToGoWithId(String shipmentIdAsString) {
    waitUntilVisibilityOfElementLocated(shipmentWithTripDialog);
    for (PageElement shipmentIdElement : shipmentIdList) {
      String currentShipmentId = shipmentIdElement.getText();
      if (shipmentIdAsString.equals(currentShipmentId)) {
        assertEquals(shipmentIdAsString, currentShipmentId);
        TestUtils.callJavaScriptExecutor("arguments[0].click();",
            getWebDriver().findElement(By.xpath(
                "//td[contains(@class,'shipment-id')]//a[.='" + shipmentIdAsString + "']")),
            getWebDriver());
        switchToOtherWindow();
        return;
      }
    }
  }

  public void verifyShipmentDetailPageIsOpenedForShipmentWithId(String shipmentIdAsString) {
    pageTitle.waitUntilVisible();
    String expectedPageTitle = "Shipment Details";
    Assertions.assertThat(expectedPageTitle).isEqualTo(pageTitle.getText());
    switchTo();
    shipmentDetailPageShipmentId.waitUntilVisible();
    String expectedShipmentIdString = f("Shipment ID : %s", shipmentIdAsString);
    Assertions.assertThat(expectedShipmentIdString)
        .isEqualTo(shipmentDetailPageShipmentId.getText());
  }

  public void verifyTripData(String expectedInboundHub, String expectedInboundType,
      String expectedDriver, String expectedDestinationHub) {
    waitUntilVisibilityOfElementLocated(XPATH_INBOUND_HUB_TEXT);
    String actualInboundHub = inboundHubText.getText();
    String actualInboundType = inboundTypeText.getText();
    String actualDriver = driverText.getText();
    String actualMovementTrip = movementTripText.getText();
    String actualDestinationHub = actualMovementTrip.split(",")[0];
    String departureDate = DateUtil.displayDate(DateUtil.getDate());
    String month = TestUtils.integerToMonth(Integer.parseInt(departureDate.split("-")[1]) - 1);
    String date = departureDate.split("-")[2];
    String expectedDepartureTime = date + " " + month;
    String actualDepartureTime = f("%s %s",
        actualMovementTrip.split(",")[1].trim().split(" ")[1],
        actualMovementTrip.split(",")[1].trim().split(" ")[2]);
    Assertions.assertThat(actualInboundHub).as("Inbound Hub is the same")
        .isEqualTo(expectedInboundHub);
    Assertions.assertThat(actualInboundType).as("Inbound Type is the same")
        .isEqualTo(expectedInboundType);
    Assertions.assertThat(actualDriver).as("Driver is the same").isEqualTo(expectedDriver);
    Assertions.assertThat(actualDestinationHub).as("Destination or Origin hub is the same")
        .contains(expectedDestinationHub);
    Assertions.assertThat(actualDepartureTime).as("Departure time is the same")
        .isEqualTo(expectedDepartureTime);
  }

  public void verifyShipmentInTrip(String expectedShipmentId) {
    waitUntilVisibilityOfElementLocated(XPATH_SHIPMENT_ID);
    String actualShipmentId = findElementByXpath(XPATH_SHIPMENT_ID).getText();
    assertEquals(expectedShipmentId, actualShipmentId);
  }

  public void verifyShipmentCount(String numberOfShipment) {
    retryIfAssertionErrorOccurred(() -> {
      try {
        String textNumberOfScannedParcel = numberOfScannedParcel.getText();
        Assertions.assertThat(textNumberOfScannedParcel)
            .as("Number of shipment scanned to Hub message is the same").
            isEqualTo(f("%s Shipments Scanned to Hub", numberOfShipment));
      } catch (Throwable ex) {
        LOGGER.info(ex.getMessage());
        pause2s();
        throw ex;
      }
    }, getCurrentMethodName(), 500, 5);
  }

  public void removeShipmentWithId(String shipmentId) {
    waitUntilVisibilityOfElementLocated(XPATH_REMOVE_SHIPMENT_SCAN);
    WebElement we = findElementByXpath(XPATH_REMOVE_SHIPMENT_SCAN);
    sendKeys(we, shipmentId);
    we.sendKeys(Keys.RETURN);
  }

  public void verifySmallMessageAppearsInScanShipmentBox(String expectedSuccessMessage) {
    retryIfAssertionErrorOccurred(() -> {
      try {
        waitUntilVisibilityOfElementLocated(XPATH_SMALL_SUCCESS_MESSAGE);
        String actualSuccessMessage = findElementByXpath(XPATH_SMALL_SUCCESS_MESSAGE).getText();
        Assertions.assertThat(actualSuccessMessage).as("Small message is equal")
            .isEqualTo(expectedSuccessMessage);
      } catch (Throwable ex) {
        NvLogger.error(ex.getMessage());
        throw ex;
      }
    }, getCurrentMethodName(), 500, 2);
  }

  public void verifyScanTextAppearsInScanShipmentBox(String expectedSuccessMessage) {
    retryIfAssertionErrorOccurred(() -> {
      try {
        String[] expected = expectedSuccessMessage.split("\n");
        waitUntilVisibilityOfElementLocated(XPATH_SCANTEXT_MESSAGE);
        String actualSuccessMessage = findElementByXpath(XPATH_SCANTEXT_MESSAGE).getText();
        Assertions.assertThat(actualSuccessMessage).as("ScanText message is equal")
            .isEqualTo(expectedSuccessMessage);
      } catch (Throwable ex) {
        NvLogger.error(ex.getMessage());
        throw ex;
      }
    }, getCurrentMethodName(), 500, 2);
  }

  public void verifySmallMessageAppearsInRemoveShipmentBox(String expectedRemoveMessage) {
    retryIfAssertionErrorOccurred(() -> {
      try {
        String actualSuccessMessage = smallRemoveMessage.getText();
        Assertions.assertThat(actualSuccessMessage).as("Small message is equal")
            .isEqualTo(expectedRemoveMessage);
      } catch (Throwable ex) {
        NvLogger.error(ex.getMessage());
        throw ex;
      }
    }, getCurrentMethodName(), 500, 2);

  }

  public void verifyShipmentToGoWithTrip(Long expectedTotalShipment) {
    shipmentToGo.waitUntilVisible();
    String shipmentToGoText = shipmentToGo.getText().trim();
    Long actualShipmentToGoCount = Long.valueOf(shipmentToGoText.split(" ")[0]);
    Assertions.assertThat(expectedTotalShipment).isEqualTo(actualShipmentToGoCount);
  }

  public void verifyShipmentToUnload(Long expectedTotalShipment) {
    shipmentToUnload.waitUntilVisible();
    String shipmentToUnloadText = shipmentToUnload.getText().trim();
    Long actualShipmentToGoCount = Long.valueOf(shipmentToUnloadText.split(" ")[0]);
    Assertions.assertThat(expectedTotalShipment).isEqualTo(actualShipmentToGoCount);
  }

  public void verifyShipmentToGoTableToScrollInto(String shipmentId) {
    waitUntilVisibilityOfElementLocated(shipmentWithTripDialog);
    for (PageElement shipmentIdElement : shipmentIdList) {
      String currentShipmentId = shipmentIdElement.getText();
      if (shipmentId.equals(currentShipmentId)) {
        Assertions.assertThat(shipmentId).isEqualTo(currentShipmentId);
        shipmentIdElement.scrollIntoView();
        return;
      }
    }
  }

  public static class CloseShipmentDialog extends MdDialog {

    @FindBy(xpath = "//button[.='Cancel']")
    public Button cancelButton;

    @FindBy(xpath = "//button[.='Close Shipment']")
    public Button closeShipmentButton;

    public CloseShipmentDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class TripDepartureDialog extends MdDialog {

    @FindBy(xpath = "//div[@class='md-toolbar-tools']//h4")
    public TextBox dialogTitle;

    @FindBy(xpath = "//md-dialog-content//p")
    public TextBox dialogMessage;

    @FindBy(name = "commons.proceed")
    public NvIconTextButton proceed;

    @FindBy(name = "commons.cancel")
    public NvIconTextButton cancel;

    public TripDepartureDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class LeavePageDialog extends MdDialog {

    @FindBy(css = "[aria-label='Leave']")
    public Button leave;

    @FindBy(css = "[aria-label='Stay']")
    public Button stay;

    public LeavePageDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class ConfirmRemoveDialog extends MdDialog {

    @FindBy(xpath = "//button//span[.='Cancel']")
    public Button cancel;

    @FindBy(xpath = "//button//span[.='Remove']")
    public Button remove;

    public ConfirmRemoveDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class ShipmentWithTrip extends MdDialog {

    @FindBy(xpath = "//div[@class='md-toolbar-tools']//h4")
    public TextBox dialogTitle;

    @FindBy(xpath = "//td[@class='id']//a")
    public List<PageElement> shipmentId;

    @FindBy(css = "[nv-table-highlight='filter.orig_hub_name']")
    public List<PageElement> originHubName;

    @FindBy(css = "[nv-table-highlight='filter.dropoff_hub_name']")
    public List<PageElement> dropOffHubName;

    @FindBy(css = "[nv-table-highlight='filter.dest_hub_name']")
    public List<PageElement> destinationHubName;

    @FindBy(css = "[nv-table-highlight='filter.comments']")
    public List<PageElement> comments;

    public ShipmentWithTrip(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

  }

  public static class ErrorShipmentDialog extends MdDialog {

    @FindBy(xpath = "//div[@class='md-toolbar-tools']//h4")
    public TextBox dialogTitle;

    @FindBy(name = "commons.cancel")
    public Button cancel;

    @FindBy(name = "commons.proceed")
    public Button proceed;

    @FindBy(xpath = "//md-dialog-content//td[@class='shipment_id']")
    public TextBox shipmentIdTextBox;

    @FindBy(xpath = "//md-dialog-content//td[@class='result']")
    public TextBox resultTextBox;

    public ErrorShipmentDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class RemoveAllParcelsDialog extends MdDialog {

    @FindBy(xpath = "//button[.='Cancel']")
    public Button cancel;

    @FindBy(xpath = "//button[.='Remove']")
    public Button remove;

    public RemoveAllParcelsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class ErrorShipmentRow extends NvTable.NvRow {

    public ErrorShipmentRow(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public ErrorShipmentRow(WebDriver webDriver, SearchContext searchContext,
        WebElement webElement) {
      super(webDriver, searchContext, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(className = "shipment_id")
    public PageElement shipmentId;

    @FindBy(className = "origin_hub_name")
    public PageElement originHubName;

    @FindBy(className = "dropoff_hub_name")
    public PageElement dropoffHubName;

    @FindBy(className = "destination_hub_name")
    public PageElement destinationHubName;

    @FindBy(className = "result")
    public PageElement result;
  }

  public void switchTo() {
    if (isElementExist("//iframe")) {
      getWebDriver().switchTo().frame(pageFrame.getWebElement());
    }
  }
}
