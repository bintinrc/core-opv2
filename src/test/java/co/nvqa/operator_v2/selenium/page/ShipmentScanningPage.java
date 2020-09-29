package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.*;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.Color;
import org.openqa.selenium.support.FindBy;

import static org.hamcrest.Matchers.allOf;

/**
 * @author Lanang Jati
 * <p>
 * Modified by Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class ShipmentScanningPage extends OperatorV2SimplePage {
    public static final String XPATH_HUB_DROPDOWN = "//md-select[@name='hub']";
    public static final String XPATH_SHIPMENT_DROPDOWN = "//md-select[@name='shipment']";
    //public static final String XPATH_HUB_ACTIVE_DROPDOWN = "//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option";
    public static final String XPATH_SELECT_SHIPMENT_BUTTON = "//button[@aria-label='Select Shipment']";
    public static final String XPATH_BARCODE_SCAN = "//input[@id='scan_barcode_input']";
    public static final String XPATH_REMOVE_SHIPMENT_SCAN = "//input[@id='scan_barcode_input_remove']";
    //public static final String XPATH_ORDER_IN_SHIPMENT = "//td[contains(@class, 'tracking-id')]";
    public static final String XPATH_RACK_SECTOR = "//div[contains(@class,'rack-sector-card')]/div/h2[@ng-show='ctrl.rackInfo']";
    public static final String XPATH_TRIP_DEPART_PROCEED_BUTTON = "//nv[]";
    public static final String XPATH_SCAN_SHIPMENT_CONTAINER = "//div[contains(@class,'scan-barcode-container')]";

    @FindBy(xpath = "//div[.='End Inbound']")
    public Button endInboundButton;

    @FindBy(xpath = "//h5[@class='shipment-parcel-numbers']")
    public TextBox numberOfScannedParcel;

    @FindBy(css = "md-dialog")
    public TripDepartureDialog tripDepartureDialog;

    @FindBy(css = "md-dialog")
    public ConfirmRemoveDialog confirmRemoveDialog;

    @FindBy(name = "commons.remove")
    public NvIconButton removeButton;

    public ShipmentScanningPage(WebDriver webDriver) {
        super(webDriver);
    }

    public void selectHub(String hubName) {
        sendKeys("//nv-autocomplete[@item-types='hub']//input", hubName);
        pause1s();
        clickf("//li//span[text()='%s']", hubName);
        pause50ms();
    }

    public void selectShipmentId(Long shipmentId) {
        sendKeys("//nv-autocomplete[@item-types='shipment']//input", shipmentId.toString());
        pause2s();
        waitUntilVisibilityOfElementLocated(f("//li//span[starts-with(text(),'%s')]", shipmentId.toString()));
        clickf("//li//span[starts-with(text(),'%s')]", shipmentId.toString());
        pause50ms();
    }

    public void clickSelectShipment() {
        clickNvApiTextButtonByNameAndWaitUntilDone("container.shipment-scanning.select-shipment");
    }

    public void selectShipmentType(String shipmentType) {
        selectValueFromMdSelectById("container.shipment-scanning.shipment-type", shipmentType);
    }

    public void scanBarcode(String trackingId) {
        sendKeysAndEnter(XPATH_BARCODE_SCAN, trackingId);
    }

    public void checkOrderInShipment(String trackingId) {
//        String rack = getText(XPATH_RACK_SECTOR);
//        assertTrue("order is " + rack, !rack.equalsIgnoreCase("INVALID") && !rack.equalsIgnoreCase("DUPLICATE"));

        WebElement orderWe = getWebDriver().findElement(By.xpath(String.format("//td[contains(@class, 'tracking-id')][contains(text(), '%s')]", trackingId)));
        boolean orderExist = orderWe != null;
        assertTrue("order " + trackingId + " doesn't exist in shipment", orderExist);
    }

    public void closeShipment() {
        pause300ms();
        click("//nv-icon-text-button[contains(@name,'close-shipment')]/button[contains(@class,'close-shipment')]");
        waitUntilVisibilityOfElementLocated("//md-dialog[md-dialog-content[contains(@id,'dialogContent')]]");
        click("//button[contains(@class,'md-primary') and @aria-label='Close Shipment']");

        String toastMessage = getToastTopText();
        assertThat("Toast message not contains Shipment <SHIPMENT_ID> created", toastMessage, allOf(containsString("Shipment"), containsString("closed")));
        waitUntilInvisibilityOfToast();
    }

    public void removeOrderFromShipment(String firstTrackingId) {
        pause1s();
        sendKeys("//nv-search-input-filter[@search-text='filter.trackingId']//input", firstTrackingId);
        pause1s();
        waitUntilVisibilityOfElementLocated("//tr[contains(@class,'last-row')]/preceding-sibling::tr//button[contains(@id,'remove')]");
        click("//tr[contains(@class,'last-row')]/preceding-sibling::tr//button[contains(@id,'remove')]");
        waitUntilVisibilityOfElementLocated("//md-dialog-content[contains(@id,'dialogContent')]");
        click("//button[@aria-label='Delete']");
        waitUntilVisibilityOfToast(f("Success delete order tracking ID %s", firstTrackingId));
        waitUntilInvisibilityOfToast();
    }

    public void verifyTheSumOfOrderIsDecreased(int expectedSumOfOrder) {
        String actualSumOfOrder = getText("//nv-icon-text-button[@label='container.shipment-scanning.remove-all']/preceding-sibling::h5").substring(0, 1);
        int actualSumOfOrderAsInt = Integer.parseInt(actualSumOfOrder);
        assertEquals("Sum Of Order is not the same : ", expectedSumOfOrder, actualSumOfOrderAsInt);
    }

    public void removeAllOrdersFromShipment() {
        pause1s();
        click("//nv-icon-text-button[@label='container.shipment-scanning.remove-all']");
        waitUntilVisibilityOfElementLocated("//md-dialog-content[contains(@id,'dialogContent')]");
        click("//button[@ng-click='dialog.hide()' and @aria-label='Remove']");
        pause1s();
    }

    public void verifyTheSumOfOrderIsZero() {
        String actualSumOfOrder = getText("//nv-icon-text-button[@label='container.shipment-scanning.remove-all']/preceding-sibling::h5").substring(0, 1);
        int actualSumOfOrderAsInt = Integer.parseInt(actualSumOfOrder);
        assertEquals("Sum Of Order is not the same : ", 0, actualSumOfOrderAsInt);
    }

    public void verifyOrderIsRedHighlighted() {
        isElementExist("//tr[contains(@class,'highlight')]");
        isElementExist("//div[contains(@class,'error-border')]");
    }

    public void verifyToastWithMessageIsShown(String expectedToastMessage) {
        String actualToastMessage = getToastTopText();
        assertEquals(expectedToastMessage, actualToastMessage);
        pause5s();
    }

    public void verifyScanShipmentColor(String expectedContainerColorAsHex) {
        String actualContainerColorAsHex = getBackgroundColor(XPATH_SCAN_SHIPMENT_CONTAINER).asHex();
        assertEquals(expectedContainerColorAsHex, actualContainerColorAsHex);
    }

    public void endShipmentInbound() {
        endInboundButton.click();
        tripDepartureDialog.waitUntilVisible();
        tripDepartureDialog.proceed.click();
    }

    public void clickRemoveButton() {
        removeButton.click();
        confirmRemoveDialog.waitUntilClickable();
        confirmRemoveDialog.remove.click();
    }

    public void verifyShipmentNotExist() {
        String textNumberOfScannedParcel = numberOfScannedParcel.getText();
        assertEquals("0 Shipment Scanned to Hub", textNumberOfScannedParcel);
    }

    public void removeShipmentWithId(String shipmentId) {
        sendKeysAndEnter(XPATH_REMOVE_SHIPMENT_SCAN, shipmentId);
    }

    public static class TripDepartureDialog extends MdDialog {
        @FindBy(name = "commons.proceed")
        public NvIconTextButton proceed;

        @FindBy(name = "commons.cancel")
        public NvIconTextButton cancel;

        public TripDepartureDialog(WebDriver webDriver, WebElement webElement) {
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
}
