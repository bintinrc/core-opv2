package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import java.util.Date;
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

  public static final String INBOUND_CONFIRM_MESSAGE_XPATH = "//div[@class='ant-modal-confirm-content']";

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

  public String TRIP_COMPLETION_DIALOG="//div[@class='ant-modal-content']";

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

  @FindBy(xpath = "//input[@value='SHIPMENT_VAN_INBOUND']")
  public PageElement intoVan;

  @FindBy(xpath = "//input[@value='SHIPMENT_HUB_INBOUND']")
  public PageElement intoHub;

  @FindBy(xpath = "//iframe")
  public PageElement frame;

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
    selectInboundHub(hub);
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
    selectInboundHub(hub);
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
        assertTrue("Error Message is not the same : ", resultWebElement
            .contains(f("shipment %d is in terminal state: [%s]", shipmentId, condition)));
        break;
      case "Pending":
      case "Closed":
        assertTrue("Error Message is different : ",
            resultWebElement.contains(f("shipment %d is [%s]", shipmentId, condition)));
        break;
    }

  }

  public void checkEndDateSessionScanChange(List<String> mustCheckId, Date endDate) {
    String formattedEndDate = MD_DATEPICKER_SDF.format(endDate);

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

  public void inputEndDate(Date date) {
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
        assertTrue("Error Message is different : ",
            errorMessage.contains(f("shipment %d is [%s]", shipmentId, condition)));
        break;
      case "different country van":
        Assertions.assertThat(
            f("Mismatched hub system ID: shipment origin hub system ID %s and scan hub system ID id are not the same.",
                TestConstants.COUNTRY_CODE.toLowerCase()).contains(errorMessage)).isTrue();
        break;

      case "different country hub":
        Assertions.assertThat(
            f("Mismatched hub system ID: shipment destination hub system ID %s and scan hub system ID id are not the same.",
                TestConstants.COUNTRY_CODE.toLowerCase()).contains(errorMessage)).isTrue();
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
        assertThat("Error Message is true",
            errorMessage, containsString(f("shipment for %d not found", shipmentId)));
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

  public void selectInboundHub(String hub) {
    if (getWebDriver().findElements(
            By.xpath("//div[@data-testid='hub-select']//span[@class='ant-select-selection-item']"))
        .size() != 0) {
      moveToElementWithXpath("//div[@data-testid='hub-select']//span[@class='ant-select-clear']");
      TestUtils.findElementAndClick(
          "//div[@data-testid='hub-select']//span[@class='ant-select-clear']", "xpath",
          getWebDriver());
    }
    TestUtils.findElementAndClick(XPATH_INBOUND_HUB, "xpath", getWebDriver());
    sendKeysAndEnter(XPATH_INBOUND_HUB, hub);
  }

  public void inboundScanningWithTripReturnMovementTrip(String hub, String label, String driver,
      String movementTripSchedule) {
    if (hub != null) {
      pause2s();
      selectInboundHub(hub);
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
      assertThat("Inbound button enabled", startInboundButton.isEnabled(),
          equalTo(true));
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
      assertThat("Inbound button disabled", result, equalTo(false));
    }
  }

  public void validateDriverAndMovementTripIsCleared() {
    assertThat("Driver place holder is equal", getWebDriver().findElements(
            By.xpath("//div[@data-testid='driver-select']//span[@class='ant-select-selection-item']"))
        .size(), equalTo(0));
    assertThat("Movement trip place holder is equal", getWebDriver().findElements(
            By.xpath("//div[@data-testid='trip-select']//span[@class='ant-select-selection-item']"))
        .size(), equalTo(0));
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

  public void verifyConfirmMessage(String message){
    waitUntilVisibilityOfElementLocated(TRIP_COMPLETION_DIALOG);
    String actualMessage = findElementByXpath(INBOUND_CONFIRM_MESSAGE_XPATH).getText();
    Assertions.assertThat(actualMessage).as("Message show on dialog is correct").isEqualToIgnoringCase(message);
  }
}