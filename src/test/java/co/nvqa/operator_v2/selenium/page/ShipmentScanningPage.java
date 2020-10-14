package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.NvTable;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.*;
import co.nvqa.operator_v2.util.TestUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import java.util.*;

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
    public static final String XPATH_SCANNED_SHIPMENT = "//td[contains(@class,'shipment_id')]";
    public static final String XPATH_SCANNED_SHIPMENT_BY_ID = "//td[contains(@class,'shipment_id')][.='%s']";
    public static final String XPATH_ACTIVE_INPUT_SELECTION = "//div[contains(@class,'md-select-menu-container nv-input-select-container md-active md-clickable')]//md-option[1]";
    public static final String XPATH_INBOUND_HUB_TEXT = "//div[span[.='Inbound Hub']]//p";
    public static final String XPATH_SHIPMENT_ID = "//td[@class='shipment_id']";
    public static final String XPATH_SMALL_SUCCESS_MESSAGE = "//div[contains(@class,'scan-barcode-container')]//small";

    @FindBy(xpath = "//div[span[.='Driver']]//p")
    public TextBox driverText;

    @FindBy(xpath = "//div[span[.='Movement Trip']]//p")
    public TextBox movementTripText;

    @FindBy(xpath = XPATH_INBOUND_HUB_TEXT)
    public TextBox inboundHubText;

    @FindBy(xpath = "//div[span[.='Inbound Type']]//p")
    public TextBox inboundTypeText;

    @FindBy(xpath = "//div[.='End Inbound']")
    public Button endInboundButton;

    @FindBy(xpath = "//h5[@class='shipment-parcel-numbers']")
    public TextBox numberOfScannedParcel;

    @FindBy(css = "md-dialog")
    public TripDepartureDialog tripDepartureDialog;

    @FindBy(css = "md-dialog")
    public LeavePageDialog leavePageDialog;

    @FindBy(css = "md-dialog")
    public ShipmentWithTrip shipmentWithTripDialog;

    @FindBy(css = "md-dialog")
    public ConfirmRemoveDialog confirmRemoveDialog;

    @FindBy(css = "md-dialog")
    public ErrorShipmentDialog errorShipment;

    @FindBy(name = "commons.remove")
    public NvIconButton removeButton;

    @FindBy(name = "commons.cancel")
    public NvIconButton cancelButton;

    @FindBy(xpath = "//div//p[@class='nv-p']//a")
    public TextBox shipmentToGo;

    @FindBy(xpath = "//div//p[@class='nv-p']//a")
    public TextBox shipmentToUnload;

    @FindBy(xpath = "//div[contains(@class,'nv-h4')]")
    public TextBox pageTitle;

    @FindBy(xpath = "//div//h3")
    public TextBox shipmentDetailPageShipmentId;

    @FindBy(xpath = "//div[@class='hub-selection']//nv-autocomplete")
    public NvAutocomplete selectHub;

    @FindBy(xpath = "//md-input-container//md-select")
    public MdSelect selectShipmentType;

    @FindBy(xpath = "//div[@class='shipment-selection']//nv-autocomplete")
    public NvAutocomplete selectShipmentFilter;

    @FindBy(name = "container.shipment-scanning.select-shipment")
    public NvApiTextButton selectShipmentButton;

    @FindBy(name = "container.shipment-scanning.close-shipment")
    public NvIconTextButton closeShipmentButton;

    @FindBy(css = "md-dialog")
    public CloseShipmentDialog closeShipmentDialog;

    @FindBy(xpath = "//div[contains(@class,'tracking-id-remove')]//small")
    public TextBox smallRemoveMessage;

    @FindBy(xpath = "//nv-table[@param='ctrl.missingTableParam']//table[@class='table-body']")
    public NvTable<ErrorShipmentRow> missingShipmentRow;

    @FindBy(xpath = "//nv-table[@param='ctrl.unregisteredTableParam']//table[@class='table-body']")
    public NvTable<ErrorShipmentRow> unregisteredShipmentRow;


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

    public void closeShipmentWithData(String hubName, String shipmentType, String shipmentId) {
        waitUntilVisibilityOfElementLocated("//div[@class='hub-selection']//nv-autocomplete");
        selectHub.waitUntilVisible();
        selectHub.selectValue(hubName);

        selectShipmentType.waitUntilVisible();
        selectShipmentType.click();
        selectShipmentType.selectValue("Air Haul");

        selectShipmentFilter.waitUntilVisible();
        selectShipmentFilter.selectValue(shipmentId);

        selectShipmentButton.waitUntilClickable();
        selectShipmentButton.click();

        closeShipmentButton.waitUntilVisible();
        closeShipmentButton.waitUntilClickable();
        closeShipmentButton.click();

        closeShipmentDialog.waitUntilVisible();
        closeShipmentDialog.closeShipmentButton.waitUntilClickable();
        closeShipmentDialog.closeShipmentButton.click();

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
        assertThat("Shipment inbound toast message is the same", actualToastMessage, equalTo(expectedToastMessage));
        pause5s();
    }

    public void verifyBottomToastWithMessageIsShown(String expectedToastMessage) {
        String actualToastMessage = getToastBottomText();
        assertEquals(expectedToastMessage, actualToastMessage);
        pause5s();
    }

    public void verifyToastContainingMessageIsShown(String expectedToastMessageContain) {
        String actualToastMessage = getToastTopText();
        assertThat(f("Toast message contains %s", expectedToastMessageContain), actualToastMessage, containsString(expectedToastMessageContain));
    }

    public void verifyScanShipmentColor(String expectedContainerColorAsHex) {
        String actualContainerColorAsHex = getBackgroundColor(XPATH_SCAN_SHIPMENT_CONTAINER).asHex();
        assertThat("Scan container color is the same", actualContainerColorAsHex, equalTo(expectedContainerColorAsHex));
    }

    public void verifyScannedShipmentColor(String expectedShipmentColorAsHex) {
        String actualColorAsHex = getBackgroundColor(XPATH_SCANNED_SHIPMENT).asHex();
        assertThat("Scanned shipment color is the same", expectedShipmentColorAsHex, equalTo(actualColorAsHex));
    }

    public void verifyScannedShipmentColorById(String expectedShipmentColorAsHex, String expectedShipmentId) {
        waitUntilVisibilityOfElementLocated(f(XPATH_SCANNED_SHIPMENT_BY_ID, expectedShipmentId));
        String actualShipmentId = findElementByXpath(f(XPATH_SCANNED_SHIPMENT_BY_ID, expectedShipmentId)).getText();
        String actualColorAsHex = getBackgroundColor(f(XPATH_SCANNED_SHIPMENT_BY_ID, expectedShipmentId)).asHex();

        assertEquals(expectedShipmentId, actualShipmentId);
        assertEquals(expectedShipmentColorAsHex, actualColorAsHex);
    }

    public void clickEndShipmentInbound() {
        endInboundButton.click();
        tripDepartureDialog.waitUntilVisible();
    }

    public void clickProceedInEndInboundDialog() {
        String dialogTitleText = tripDepartureDialog.dialogTitle.getText();
        assertThat("Dialog title is the same", dialogTitleText, equalTo("Confirm End Inbound"));

        String dialogMessageText = tripDepartureDialog.dialogMessage.getText();
        assertThat("Dialog message text is the same", dialogMessageText, equalTo("Are you sure you want to end inbound?"));

        tripDepartureDialog.proceed.waitUntilClickable();
        tripDepartureDialog.proceed.click();
        pause2s();
    }

    public void clickProceedInTripDepartureDialog() {
        String dialogTitleText = tripDepartureDialog.dialogTitle.getText();
        assertThat("Dialog title is the same", dialogTitleText, equalTo("Trip Departure"));

        String dialogMessageText = tripDepartureDialog.dialogMessage.getText();
        assertThat("Dialog message text is the same", dialogMessageText, equalTo("Are you sure you want to start departure?"));

        tripDepartureDialog.proceed.waitUntilClickable();
        tripDepartureDialog.proceed.click();
        pause2s();
    }

    public void clickLeavePageDialog() {
        WebElement leavePageButton = getWebDriver().findElement(By.cssSelector("[aria-label='Leave']"));
        leavePageButton.click();
    }

    public void clickRemoveButton() {
        removeButton.click();
        confirmRemoveDialog.waitUntilVisible();
        confirmRemoveDialog.remove.click();
    }

    public void verifyErrorShipmentWithMessage(String shipmentId, String resultMessage) {
        errorShipment.waitUntilVisible();
        String dialogTitleText = errorShipment.dialogTitle.getText();
        assertEquals("Error Shipment", dialogTitleText);

        String actualShipmentId = errorShipment.shipmentIdTextBox.getText();
        String actualResultMessage = errorShipment.resultTextBox.getText();

        assertEquals(shipmentId, actualShipmentId);
        assertEquals(resultMessage, actualResultMessage);
    }

    public void verifyErrorShipmentWithMessage(String shipmentId, String resultMessage, String errorShipmentType) {
        errorShipment.waitUntilVisible();
        String dialogTitleText = errorShipment.dialogTitle.getText();
        assertEquals("Error Shipment", dialogTitleText);
        String actualShipmentId = "";
        String actualResultMessage = "";

        if (errorShipmentType.equals("unregistered shipments")) {
            actualShipmentId = unregisteredShipmentRow.rows.get(0).shipmentId.getText();
            actualResultMessage = unregisteredShipmentRow.rows.get(0).result.getText();
        }

        if (errorShipmentType.equals("missing shipments")) {
            actualShipmentId = missingShipmentRow.rows.get(0).shipmentId.getText();
            actualResultMessage = missingShipmentRow.rows.get(0).result.getText();
        }

        assertThat("Shipment id is equal", actualShipmentId, equalTo(shipmentId));
        assertThat("Result message is equal", actualResultMessage, equalTo(resultMessage));
    }

    public void clickCancelInMdDialog() {
        cancelButton.waitUntilClickable();
        cancelButton.click();
    }

    public void clickProceedButtonInErrorShipmentDialog() {
        errorShipment.proceed.waitUntilClickable();
        errorShipment.proceed.click();
    }

    public void verifyShipmentWithTripData(Map<String, String> finalData) {
        String shipmentCount = finalData.get("shipmentCount");
        String dialogTitle = f("shipments to go with trip (%s)", shipmentCount);
        if (finalData.get("inboundType") != null && finalData.get("inboundType").equals("Into Hub")) {
            dialogTitle = f("shipments to unload (%s)", shipmentCount);
        }
        String shipmentId = finalData.get("shipmentId");
        String originHub = finalData.get("originHub");
        String dropOffHub = finalData.get("dropOffHub");
        String destinationHub = finalData.get("destinationHub");
        String comments = finalData.get("comments");

        shipmentWithTripDialog.waitUntilVisible();
        String actualDialogTitle = shipmentWithTripDialog.dialogTitle.getText().toLowerCase();
        int index = 0;
        for (PageElement shipmentIdElement : shipmentWithTripDialog.shipmentId) {
            String currentShipmentId = shipmentIdElement.getText().trim();
            if (currentShipmentId.equals(shipmentId)) {
                break;
            }
            index++;
        }
        String actualShipmentId = shipmentWithTripDialog.shipmentId.get(index).getText();
        String actualOriginHub = shipmentWithTripDialog.originHubName.get(index).getText();
        String actualDropOffHub = shipmentWithTripDialog.dropOffHubName.get(index).getText();
        String actualDestinationHub = shipmentWithTripDialog.destinationHubName.get(index).getText();
        String actualComments = shipmentWithTripDialog.comments.get(index).getText();

        assertThat("Dialog title is equal", actualDialogTitle, equalTo(dialogTitle));
        assertThat("Shipment id is equal", actualShipmentId, equalTo(shipmentId));
        assertThat("Origin hub is equal", actualOriginHub, equalTo(originHub));
        assertThat("Drop off hub is equal", actualDropOffHub, equalTo(dropOffHub));
        assertThat("Destination hub is equal", actualDestinationHub, equalTo(destinationHub));
        assertThat("Comments is equal", actualComments, equalTo(comments));
    }

    public void verifyCreatedShipmentsShipmentToGoWithTripDataLastIndexTransitHub(Map<String, String> finalData) {
        String[] shipmentIds = finalData.get("shipmentIds").split(", ");
        for (int count = 0; count < shipmentIds.length; count++) {
            finalData.put("shipmentId", shipmentIds[count]);
            if (count == (shipmentIds.length - 1)) {
                finalData.put("dropOffHub", "-");
                finalData.put("comments", "-");
            }
            verifyShipmentWithTripData(finalData);
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
        shipmentWithTripDialog.waitUntilVisible();
        for (PageElement shipmentIdElement : shipmentWithTripDialog.shipmentId) {
            String currentShipmentId = shipmentIdElement.getText();
            if (currentShipmentId.equals(shipmentIdAsString)) {
                assertEquals(shipmentIdAsString, currentShipmentId);
                shipmentIdElement.click();
                switchToOtherWindow();
                return;
            }
        }
    }

    public void verifyShipmentDetailPageIsOpenedForShipmentWithId(String shipmentIdAsString) {
        pageTitle.waitUntilVisible();
        String expectedPageTitle = "Shipment Details";
        assertEquals(expectedPageTitle, pageTitle.getText());

        shipmentDetailPageShipmentId.waitUntilVisible();
        String expectedShipmentIdString = f("Shipment ID : %s", shipmentIdAsString);
        assertEquals(expectedShipmentIdString, shipmentDetailPageShipmentId.getText());
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
        assertThat("Inbound Hub is the same", actualInboundHub, equalTo(expectedInboundHub));
        assertThat("Inbound Type is the same", actualInboundType, equalTo(expectedInboundType));
        assertThat("Driver is the same", actualDriver, equalTo(expectedDriver));
        assertThat("Destination or Origin hub is the same", actualDestinationHub, containsString(expectedDestinationHub));
        assertThat("Departure time is the same", actualDepartureTime, equalTo(expectedDepartureTime));
    }

    public void verifyShipmentInTrip(String expectedShipmentId) {
        waitUntilVisibilityOfElementLocated(XPATH_SHIPMENT_ID);
        String actualShipmentId = findElementByXpath(XPATH_SHIPMENT_ID).getText();
        assertEquals(expectedShipmentId, actualShipmentId);
    }

    public void verifyShipmentCount(String numberOfShipment) {
        String textNumberOfScannedParcel = numberOfScannedParcel.getText();
        assertThat("Number of shipment scanned to Hub message is the same",
                textNumberOfScannedParcel,
                equalTo(f("%s Shipment Scanned to Hub", numberOfShipment)));
    }

    public void removeShipmentWithId(String shipmentId) {
        sendKeysAndEnter(XPATH_REMOVE_SHIPMENT_SCAN, shipmentId);
    }

    public void verifySmallMessageAppearsInScanShipmentBox(String expectedSuccessMessage) {
        retryIfAssertionErrorOccurred(() -> {
            try {
                String actualSuccessMessage = findElementByXpath(XPATH_SMALL_SUCCESS_MESSAGE).getText();
                assertThat("Small message is equal", actualSuccessMessage, equalTo(expectedSuccessMessage));
            } catch (Throwable ex) {
                NvLogger.error(ex.getMessage());
                throw ex;
            }
        }, getCurrentMethodName());
    }

    public void verifySmallMessageAppearsInRemoveShipmentBox(String expectedRemoveMessage) {
        retryIfAssertionErrorOccurred(() -> {
            try {
                String actualSuccessMessage = smallRemoveMessage.getText();
                assertThat("Small message is equal", actualSuccessMessage, equalTo(expectedRemoveMessage));
            } catch (Throwable ex) {
                NvLogger.error(ex.getMessage());
                throw ex;
            }
        }, getCurrentMethodName());

    }

    public void verifyShipmentToGoWithTrip(Long expectedTotalShipment) {
        shipmentToGo.waitUntilVisible();
        String shipmentToGoText = shipmentToGo.getText().trim();
        Long actualShipmentToGoCount = Long.valueOf(shipmentToGoText.split(" ")[0]);
        assertEquals(expectedTotalShipment, actualShipmentToGoCount);
    }

    public void verifyShipmentToUnload(Long expectedTotalShipment) {
        shipmentToUnload.waitUntilVisible();
        String shipmentToUnloadText = shipmentToUnload.getText().trim();
        Long actualShipmentToGoCount = Long.valueOf(shipmentToUnloadText.split(" ")[0]);
        assertEquals(expectedTotalShipment, actualShipmentToGoCount);
    }

    public void verifyShipmentToGoTableToScrollInto(String shipmentId) {
        shipmentWithTripDialog.waitUntilVisible();
        for (PageElement shipmentIdElement : shipmentWithTripDialog.shipmentId) {
            String currentShipmentId = shipmentIdElement.getText();
            if (currentShipmentId.equals(shipmentId)) {
                assertEquals(shipmentId, currentShipmentId);
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

    public static class ErrorShipmentRow extends NvTable.NvRow {
        public ErrorShipmentRow(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        public ErrorShipmentRow(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
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
}
