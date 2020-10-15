package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.util.TestConstants;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author Lanang Jati
 * <p>
 * Modified by Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class ShipmentInboundScanningPage extends OperatorV2SimplePage {
    public static final String XPATH_SCAN_INPUT = "//md-card-content[div[h5[text()='Scan Shipment to Inbound']]]/md-input-container/input";
    public static final String XPATH_CHANGE_END_DATE_BUTTON = "//button[@aria-label='Change End Date']";
    public static final String XPATH_SCANNING_SESSION = "//table/tbody/tr[contains(@ng-repeat,'log in ctrl.scans')]";
    public static final String XPATH_SCANNING_SESSION_NO_CHANGE = XPATH_SCANNING_SESSION;
    public static final String XPATH_SCANNING_SESSION_CHANGE = XPATH_SCANNING_SESSION + "[contains(@class,'changed')]";
    public static final String XPATH_CHANGE_DATE_BUTTON = "//button[@aria-label='Change Date']";
    public static final String XPATH_ACTIVE_INPUT_SELECTION = "//div[contains(@class,'md-select-menu-container nv-input-select-container md-active md-clickable')]//md-option[1]";
    public static final String XPATH_INBOUND_HUB_TEXT = "//div[span[.='Inbound Hub']]//p";
    public static final String XPATH_SHIPMENT_ID = "//td[@class='shipment_id']";

    @FindBy(xpath = "//md-select[contains(@id,'inbound-hub')]")
    public MdSelect inboundHub;

    @FindBy(xpath = "//md-select[contains(@id,'driver')]")
    public MdSelect driver;

    @FindBy(xpath = "//md-select[contains(@id,'movement-trip')]")
    public MdSelect movementTrip;

    @FindBy(xpath = XPATH_INBOUND_HUB_TEXT)
    public TextBox inboundHubText;

    @FindBy(xpath = "//div[span[.='Inbound Type']]//p")
    public TextBox inboundTypeText;

    @FindBy(xpath = "//button[contains(@class,'start-inbound-btn')]")
    public Button startInboundButton;

    @FindBy(xpath = "//div[contains(@class,'trip-unselected-warning')]")
    public TextBox tripUnselectedWarning;

    @FindBy(css = "md-dialog")
    public TripCompletion tripCompletionDialog;

    public ShipmentInboundScanningPage(WebDriver webDriver) {
        super(webDriver);
    }

    public void selectHub(String hubName) {
        inboundHub.searchAndSelectValue(hubName);
    }

    public void inboundScanning(Long shipmentId, String label, String hub) {
        pause2s();
        selectHub(hub);
        click(grabXpathButton(label));
        clickStartInbound();

        inputShipmentToInbound(shipmentId);
        checkSessionScan(shipmentId);
    }

    public void inboundScanningUsingMawb(Long shipmentId, String mawb, String label, String hub) {
        pause2s();
        selectHub(hub);
        click(grabXpathButton(label));
        clickStartInbound();

        inputShipmentToInboundUsingMawb(mawb);
        checkSessionScan(shipmentId);
    }

    public void inboundScanningNegativeScenario(Long shipmentId, String label, String hub, String condition) {
        pause2s();
        selectHub(hub);
        click(grabXpathButton(label));
        clickStartInbound();

        inputShipmentToInbound(shipmentId);
        pause2s();
        checkAlert(shipmentId, condition);
    }

    public void inboundScanningUsingMawbWithAlerts(Long shipmentId, String mawb, String label, String hub, String condition) {
        pause2s();
        selectHub(hub);
        click(grabXpathButton(label));
        clickStartInbound();

        inputShipmentToInboundUsingMawb(mawb);
        checkAlert(shipmentId, condition);
    }

    public void clickStartInbound() {
        startInboundButton.click();
    }

    public String grabXpathButton(String label) {
        return "//button[span[text()='" + label + "']]";
    }

    public List<String> grabSessionIdNotChangedScan() {
        List<WebElement> scans = findElementsByXpath(XPATH_SCANNING_SESSION_NO_CHANGE + "/td[contains(@class,'sn')]");
        return scans.stream().map(WebElement::getText).collect(Collectors.toList());
    }

    public void clickEditEndDate() {
        click(XPATH_CHANGE_END_DATE_BUTTON);
    }

    public void clickChangeDateButton() {
        click(XPATH_CHANGE_DATE_BUTTON);
    }

    public void inputShipmentToInbound(Long shipmentId) {
        sendKeysAndEnter(XPATH_SCAN_INPUT, String.valueOf(shipmentId));
    }

    public void inputShipmentToInboundUsingMawb(String mawb) {
        sendKeysAndEnter(XPATH_SCAN_INPUT, mawb);
    }

    public void checkSessionScan(Long shipmentId) {
        waitUntilVisibilityOfElementLocated(XPATH_SCANNING_SESSION_NO_CHANGE + String.format("[td[contains(@class,'sn')][text()='1']][td[@class='shipmentId'][text()='%s']]", String.valueOf(shipmentId)));
    }

    public void checkEndDateSessionScanChange(List<String> mustCheckId, Date endDate) {
        String formattedEndDate = MD_DATEPICKER_SDF.format(endDate);

        for (String shipmentId : mustCheckId) {
            waitUntilVisibilityOfElementLocated(XPATH_SCANNING_SESSION_CHANGE + f("[td[contains(@class,'sn')][text()='%s']][td[contains(@class,'end-date')][text()='%s']]", shipmentId, formattedEndDate));
        }
    }

    public void completeTrip() {
        tripCompletionDialog.waitUntilVisible();
        tripCompletionDialog.proceed.waitUntilClickable();
        tripCompletionDialog.proceed.click();
        tripCompletionDialog.waitUntilInvisible();
    }

    public void inputEndDate(Date date) {
        setMdDatepicker("ctrl.date", date);
    }

    private void checkAlert(Long shipmentId, String condition) {
        waitUntilVisibilityOfElementLocated("//input[contains(@ng-model,'ctrl.shipmentId')]/following-sibling::span");
        String errorMessage = getText("//input[contains(@ng-model,'ctrl.shipmentId')]/following-sibling::span");
        switch (condition) {
            case "Completed":
                assertEquals("Error Message is not the same : ", errorMessage, f("shipment %d is in terminal state: [%s]", shipmentId, condition));
                break;

            case "Cancelled":
                assertEquals("Error Message is not the same : ", errorMessage, f("shipment %d is in terminal state: [%s]", shipmentId, condition));
                break;

            case "different country van":
                assertEquals("Error Message is not the same : ", errorMessage, f("Mismatched hub system ID: shipment origin hub system ID %s and scan hub system ID id are not the same.", TestConstants.COUNTRY_CODE.toLowerCase()));
                break;

            case "different country hub":
                assertEquals("Error Message is not the same : ", errorMessage, f("Mismatched hub system ID: shipment destination hub system ID %s and scan hub system ID id are not the same.", TestConstants.COUNTRY_CODE.toLowerCase()));
                break;

            case "pending shipment":
                assertTrue("Error Message is different : ", errorMessage.contains(f("shipment %d is [Pending]", shipmentId)));
                break;

            case "closed shipment":
                assertTrue("Error Message is not the same : ", errorMessage.contains(f("shipment %d is [Closed]", shipmentId)));
                break;
        }
    }

    public void selectDriver(String driverName) {
        driver.searchAndSelectValue(driverName);
    }

    public void selectMovementTrip(String movementTripSchedule) {
        movementTrip.searchAndSelectValue(movementTripSchedule);
    }

    public void inboundScanningWithTripReturnMovementTrip(String hub, String label, String driver, String movementTripSchedule) {
        if (hub != null) {
            pause2s();
            selectHub(hub);
        }

        if (label != null) {
            pause2s();
            click(grabXpathButton(label));
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


}
