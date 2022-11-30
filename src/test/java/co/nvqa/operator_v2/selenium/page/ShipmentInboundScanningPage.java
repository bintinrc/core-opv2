package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Lanang Jati
 * <p>
 * Modified by Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class ShipmentInboundScanningPage extends SimpleReactPage<ShipmentInboundScanningPage> {

  public static final String XPATH_CHANGE_END_DATE_BUTTON = "//button[@aria-label='Change End Date']";
  public static final String XPATH_SCANNING_SESSION = "//table/tbody/tr[contains(@ng-repeat,'log in ctrl.scans')]";
  public static final String XPATH_SCANNING_SESSION_NO_CHANGE = XPATH_SCANNING_SESSION;
  public static final String XPATH_SCANNING_SESSION_CHANGE =
      XPATH_SCANNING_SESSION + "[contains(@class,'changed')]";
  public static final String XPATH_CHANGE_DATE_BUTTON = "//button[@aria-label='Change Date']";
  public static final String XPATH_INBOUND_HUB_TEXT = "//div[span[.='Inbound Hub']]//p";
  public static final String XPATH_INBOUND_HUB = "//div[@class='ant-select-selector']//input[@id='rc_select_0']";
  public static final String XPATH_DRIVER = "//div[@class='ant-select-selector']//input[@id='rc_select_1']";
  public static final String XPATH_MOVEMENT_TRIP = "//div[@class='ant-select-selector']//input[@id='rc_select_2']";
  public static final String XPATH_ANT_SPINNING = "//div[contains(@class,'ant-spin-spinning')]";
  public static final String CONST_INTO_VAN = "Into Van";
  public static final String CONST_INTO_HUB = "Into Hub";

  @FindBy(xpath = "//md-select[contains(@id,'inbound-hub')]")
  public MdSelect inboundHub;

  @FindBy(xpath = "//div[@data-testid='driver-select']//span[@class='ant-select-selection-item']")
  public WebElement driver;

  @FindBy(xpath = "//div[@data-testid='trip-select']//span[@class='ant-select-selection-item']")
  public WebElement movementTrip;

  @FindBy(xpath = XPATH_INBOUND_HUB_TEXT)
  public TextBox inboundHubText;

  @FindBy(xpath = "//div[span[.='Inbound Type']]//p")
  public TextBox inboundTypeText;

  @FindBy(xpath = "//span[text()='Start Inbound']")
  public Button startInboundButton;

  @FindBy(xpath = "//div[contains(@class,'trip-unselected-warning')]")
  public TextBox tripUnselectedWarning;

  @FindBy(xpath = "//div[.='Scan Shipment to Inbound']//input | //input[@id='toAddTrackingId']")
  public TextBox shipmentIdInput;

  private static String XPATH_SHIPMENTID_INPUT = "//div[.='Scan Shipment to Inbound']//input | //input[@id='toAddTrackingId']";

  @FindBy(css = "[data-testid='scan-box-container'] div.message")
  public PageElement scanAlertMessage;

  @FindBy(xpath = "//md-card[contains(@class,'scan-status-card')]")
  public PageElement scanStatusCard;

  @FindBy(css = "md-dialog")
  public TripCompletion tripCompletionDialog;

  public String TRIP_COMPLETION_DIALOG = "//div[@class='ant-modal-content']";

  @FindBy(xpath = ".//button[.='Cancel']")
  public Button cancel;

  @FindBy(xpath = ".//button[.='Proceed']")
  public Button proceed;

  @FindBy(css = "h2.scan-state-text")
  public PageElement scannedState;

  @FindBy(xpath = "//h1[@*='scan-state-command']")
  public PageElement scannedMessage;

  @FindBy(css = "div.scanned-shipping-id")
  public PageElement scannedShipmentId;

  @FindBy(xpath = "//div[@id='rc_select_0_list']//div[@class='ant-empty-description']")
  public PageElement listEmptyData;

  @FindBy(css = "[data-testid='hub-select']")
  public AntSelect3 hubSelect;

  @FindBy(xpath = "//input[@value='SHIPMENT_VAN_INBOUND']")
  public PageElement intoVan;

  @FindBy(xpath = "//input[@value='SHIPMENT_HUB_INBOUND']")
  public PageElement intoHub;

  @FindBy(xpath = "//iframe")
  public PageElement frame;

  @FindBy(xpath = " //div[@class='ant-modal-confirm-content']")
  public PageElement confirmMessage;

  public ShipmentInboundScanningPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void inboundScanning(long shipmentId, String label, String hub) {
    inboundScanningShipment(shipmentId, label, hub);
    checkSessionScan(String.valueOf(shipmentId));
  }

  public void inboundScanningShipment(long shipmentId, String label, String hub) {
    pause2s();
    click(XPATH_INBOUND_HUB);
    listEmptyData.waitUntilInvisible();
    hubSelect.selectValue(hub);
    if (CONST_INTO_VAN.equals(label)) {
      intoVan.click();
    } else if (CONST_INTO_HUB.equals(label)) {
      intoHub.click();
    }
    startInboundButton.click();
    fillShipmentId(shipmentId);
  }

  public void inboundScanningUsingMawb(Long shipmentId, String mawb, String label, String hub) {
    pause2s();
    inboundHub.searchAndSelectValue(hub);
    click(grabXpathButton(label));
    startInboundButton.click();
    fillShipmentId(mawb);
    checkSessionScan(String.valueOf(shipmentId));
  }

  public void inboundScanningUsingMawbCheckSessionUsingMAWB(String mawb, String label, String hub) {
    pause2s();
    inboundHub.searchAndSelectValue(hub);
    click(grabXpathButton(label));
    startInboundButton.click();
    fillShipmentId(mawb);
    checkSessionScan(String.valueOf(mawb));
  }

  public void inboundScanningNegativeScenario(Long shipmentId, String label, String hub,
      String condition) {
    pause2s();
    hubSelect.selectValue(hub);
    if (CONST_INTO_VAN.equals(label)) {
      intoVan.click();
    } else if (CONST_INTO_HUB.equals(label)) {
      intoHub.click();
    }
    startInboundButton.click();
    fillShipmentId(shipmentId);
    pause2s();
    checkAlert(shipmentId, condition);
  }

  public void inboundScanningUsingMawbWithAlerts(Long shipmentId, String mawb, String label,
      String hub, String condition) {
    pause2s();
    inboundHub.searchAndSelectValue(hub);
    click(grabXpathButton(label));
    startInboundButton.click();
    fillShipmentId(mawb);
    checkAlert(shipmentId, condition);
  }

  public String grabXpathButton(String label) {
    return f("//*[@aria-label='%s']", label);
  }

  public List<String> grabSessionIdNotChangedScan() {
    List<WebElement> scans = findElementsByXpath(
        XPATH_SCANNING_SESSION_NO_CHANGE + "/td[contains(@class,'sn')]");
    return scans.stream().map(WebElement::getText).collect(Collectors.toList());
  }

  public void clickEditEndDate() {
    click(XPATH_CHANGE_END_DATE_BUTTON);
  }

  public void clickChangeDateButton() {
    click(XPATH_CHANGE_DATE_BUTTON);
  }

  public void fillShipmentId(Object value) {
    sendKeysAndEnter(XPATH_SHIPMENTID_INPUT, value.toString());
  }

  public void checkSessionScan(String shipmentId) {
    waitUntilVisibilityOfElementLocated(f("//tr//td[text()='%s']", shipmentId));
  }

  public void checkSessionScanResult(Long shipmentId, String condition) {
    String resultWebElement = findElementByXpath(
        XPATH_SCANNING_SESSION_NO_CHANGE + "//td[@class='result']").getText();
    switch (condition) {
      case "Completed":
      case "Cancelled":
        assertTrue("Error Message is not the same : ", resultWebElement.contains(
            f("shipment %d is in terminal state: [%s]", shipmentId, condition)));
        break;
      case "Pending":
      case "Closed":
        Assertions.assertThat(
                resultWebElement.contains(f("shipment %d is [%s]", shipmentId, condition)))
            .as("Error Message is different : ").isTrue();
        break;
    }

  }

  public void checkEndDateSessionScanChange(List<String> mustCheckId, LocalDateTime endDate) {
    String formattedEndDate = DTF_NORMAL_DATE.format(endDate);

    for (String shipmentId : mustCheckId) {
      waitUntilVisibilityOfElementLocated(XPATH_SCANNING_SESSION_CHANGE + f(
          "[td[contains(@class,'sn')][text()='%s']][td[contains(@class,'end-date')][text()='%s']]",
          shipmentId, formattedEndDate));
    }
  }

  public void completeTrip() {
    waitUntilVisibilityOfElementLocated(TRIP_COMPLETION_DIALOG);
    proceed.waitUntilClickable();
    proceed.click();
    waitUntilInvisibilityOfElementLocated(TRIP_COMPLETION_DIALOG);
  }

  public void inputEndDate(LocalDateTime date) {
    setMdDatepicker("ctrl.date", date);
  }

  public void checkAlert(Long shipmentId, String condition) {
    scanAlertMessage.waitUntilVisible();
    String errorMessage = scanAlertMessage.getText();
    String expected = "";
    switch (condition) {
      case "Completed":
      case "Cancelled":
        expected = f("Shipment id %d cannot change status from %s", shipmentId, condition);
        Assertions.assertThat(errorMessage).as(condition + " shipment:").contains(expected);
        break;
      case "Pending":
      case "Closed":
        Assertions.assertThat(
                errorMessage.contains(f("shipment %d is [%s]", shipmentId, condition)))
            .as("Error Message is different : ").isTrue();
        break;
      case "different country van":
        Assertions.assertThat(
            f("Mismatched hub system ID: shipment origin hub system ID %s and scan hub system ID id are not the same.",
                TestConstants.NV_SYSTEM_ID.toLowerCase()).contains(errorMessage)).isTrue();
        break;

      case "different country hub":
        Assertions.assertThat(
            f("Mismatched hub system ID: shipment destination hub system ID %s and scan hub system ID id are not the same.",
                TestConstants.NV_SYSTEM_ID.toLowerCase()).contains(errorMessage)).isTrue();
        break;

      case "pending shipment":
        expected = f("shipment %d is [Pending]", shipmentId);
        Assertions.assertThat(errorMessage).as("pending shipment:").contains(expected);
        break;

      case "closed shipment":
        expected = f("shipment %d is [Closed]", shipmentId);
        Assertions.assertThat(errorMessage).as("closed shipment:").contains(expected);
        break;

      case "shipment not found":
        Assertions.assertThat(errorMessage).as("Error Message is true")
            .contains(f("shipment for %d not found", shipmentId));
        break;

      case "Transit":
        expected = f("Shipment id %d cannot change status from %s", shipmentId, condition);
        Assertions.assertThat(errorMessage).as("Transit:").contains(expected);
        break;
    }
  }

  public void selectDriver(String driverName) {
    waitUntilInvisibilityOfElementLocated(XPATH_ANT_SPINNING);
    waitUntilElementIsClickable(XPATH_DRIVER);
    TestUtils.findElementAndClick(XPATH_DRIVER, "xpath", getWebDriver());
    sendKeysAndEnter(XPATH_DRIVER, driverName);
  }

  public void selectMovementTrip(String movementTripSchedule) {
    waitUntilElementIsClickable(XPATH_MOVEMENT_TRIP);
    TestUtils.findElementAndClick(XPATH_MOVEMENT_TRIP, "xpath", getWebDriver());
    sendKeysAndEnter(XPATH_MOVEMENT_TRIP, movementTripSchedule);
  }

  public void inboundScanningWithTripReturnMovementTrip(String hub, String label, String driver,
      String movementTripSchedule) {
    if (hub != null) {
      pause2s();
      hubSelect.selectValue(hub);
    }

    if (label != null) {
      pause2s();
      if (CONST_INTO_VAN.equals(label)) {
        intoVan.click();
      } else if (CONST_INTO_HUB.equals(label)) {
        intoHub.click();
      }
    }

    if (driver != null) {
      pause2s();
      selectDriver(driver);
    }
    if (movementTripSchedule != null) {
      pause2s();
      selectMovementTrip(movementTripSchedule);
    }

    pause2s();
  }

  public void verifyStartInboundButtonIsEnabledOrDisabled(String status) {
    if ("enabled".equals(status)) {
      Assertions.assertThat(startInboundButton.isEnabled()).as("Inbound button enabled").isTrue();
      return;
    }
    if ("disabled".equals(status)) {
      String value = getWebDriver().findElement(
              By.xpath("//button[contains(@class,'ant-btn')]//span[text()='Start Inbound']"))
          .getAttribute("disabled");
      boolean result = false;
      if (value != null) {
        result = true;
      }
      Assertions.assertThat(result).as("Inbound button disabled").isFalse();
    }
  }

  public void validateDriverAndMovementTripIsCleared() {
    Assertions.assertThat(getWebDriver().findElements(
            By.xpath("//div[@data-testid='driver-select']//span[@class='ant-select-selection-item']"))
        .size()).as("Driver place holder is equal").isEqualTo(0);
    Assertions.assertThat(getWebDriver().findElements(
            By.xpath("//div[@data-testid='trip-select']//span[@class='ant-select-selection-item']"))
        .size()).as("Movement trip place holder is equal").isEqualTo(0);
  }

  public static class TripCompletion extends MdDialog {

    @FindBy(className = "md-title")
    public TextBox dialogTitle;

    @FindBy(xpath = ".//button[.='Cancel']")
    public Button cancel;

    @FindBy(xpath = ".//button[.='Proceed']")
    public Button proceed;

    public TripCompletion(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public void verifyConfirmMessage(String message) {
    waitUntilVisibilityOfElementLocated(TRIP_COMPLETION_DIALOG);
    String actualMessage = confirmMessage.getText();
    Assertions.assertThat(actualMessage).as("Message show on dialog is correct")
        .isEqualToIgnoringCase(message);
  }
}