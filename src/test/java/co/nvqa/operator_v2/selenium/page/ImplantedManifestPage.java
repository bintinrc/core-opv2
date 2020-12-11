package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.ImplantedManifestOrder;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Map;

/**
 * @author Kateryna Skakunova
 */
public class ImplantedManifestPage extends OperatorV2SimplePage
{
    private static final String CSV_FILENAME_FORMAT = "implanted-manifest-%s.csv";

    @FindBy(id = "scan_barcode_input")
    public TextBox scanBarcodeInput;

    @FindBy(id = "hub")
    public MdSelect hubSelect;

    @FindBy(name = "container.implanted-manifest.create-manifest")
    public NvApiTextButton createManifest;

    @FindBy(css = "md-dialog")
    public CreateManifestDialog createManifestDialog;

    private ImplantedManifestOrderTable implantedManifestOrderTable;

    public ImplantedManifestPage(WebDriver webDriver)
    {
        super(webDriver);
        implantedManifestOrderTable = new ImplantedManifestOrderTable(webDriver);
    }

    /**
     * Accessor for Manifest table
     */
    public static class ImplantedManifestOrderTable extends MdVirtualRepeatTable<ImplantedManifestOrder>
    {
        public static final String MD_VIRTUAL_REPEAT = "scan in getTableData()";
        private static final String COLUMN_TRACKING_ID = "trackingId";
        private static final String COLUMN_SCANNED_AT = "scannedAt";
        private static final String COLUMN_DESTINATION = "destination";
        private static final String COLUMN_ADDRESSEE = "addressee";
        private static final String COLUMN_RACK_SECTOR = "rackSector";
        private static final String COLUMN_DELIVERY_BY = "deliveryBy";

        private ImplantedManifestOrderTable(WebDriver webDriver)
        {
            super(webDriver);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put(COLUMN_TRACKING_ID, "tracking-id")
                    .put(COLUMN_SCANNED_AT, "created-at")
                    .put(COLUMN_DESTINATION, "destination")
                    .put(COLUMN_ADDRESSEE, "addressee")
                    .put(COLUMN_RACK_SECTOR, "rack-sector")
                    .put(COLUMN_DELIVERY_BY, "deliver-by")
                    .build()
            );
            setActionButtonsLocators(ImmutableMap.of("close", "//button[@aria-label='close']"));
            setEntityClass(ImplantedManifestOrder.class);
            setMdVirtualRepeat(MD_VIRTUAL_REPEAT);
        }
    }

    public void clickActionXForRow(int rowNumber)
    {
        implantedManifestOrderTable.clickActionButton(rowNumber, "close");
    }

    public void clickCreateManifestButtonToInitiateCreation()
    {
        waitUntilInvisibilityOfElementLocated("//button[@aria-label='container.implanted-manifest.create-manifest' and @disabled='disabled']");
        clickNvApiTextButtonByNameAndWaitUntilDone("container.implanted-manifest.create-manifest");
    }

    public void clickDownloadCsvFile()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("Download CSV File");
    }

    public void clickRemoveAllButtonAndConfirm()
    {
        clickButtonByAriaLabelAndWaitUntilDone("Remove All");
        clickButtonByAriaLabelAndWaitUntilDone("Delete");
    }

    public void csvDownloadSuccessfullyAndContainsOrderInfo(Order order, String hubName)
    {
        String csvFileName = f(CSV_FILENAME_FORMAT, hubName);

        String trackingId = order.getTrackingId();
        verifyFileDownloadedSuccessfully(csvFileName, trackingId);

        String destination = order.getToAddress1() + " " + order.getToAddress2();
        String rackSector = order.getRackSector();
        String addressee = order.getToName();
        String expectedText = f("\"%s\",\"%s\",\"%s\"", destination, addressee, rackSector);
        verifyFileDownloadedSuccessfully(csvFileName, expectedText);
    }

    public void removeOrderByScan(String barcode)
    {
        sendKeysAndEnterByAriaLabel("remove_scan_barcode", barcode);
        String xpathToBarCode = "//input[@aria-label='remove_scan_barcode' and contains(@class,'ng-empty')]";
        waitUntilVisibilityOfElementLocated(xpathToBarCode);
    }

    public void scanBarCodeAndSaveTime(Map<String, ZonedDateTime> barcodeToScannedAtTime, String barcode)
    {
        scanBarcodeInput.setValue(barcode + Keys.ENTER);
        barcodeToScannedAtTime.put(barcode, DateUtil.getDate(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE)));
        String xpathToBarCode = "//input[@aria-label='scan_barcode' and contains(@class,'ng-empty')]";
        waitUntilVisibilityOfElementLocated(xpathToBarCode);
    }

    public void selectHub(String destinationHub)
    {
        pause2s();
        selectValueFromMdSelectWithSearch("model", destinationHub);
    }

    public void verifyRowsCountEqualsOrdersCountInManifestTable(int ordersCount)
    {
        assertEquals("Rows count in Implanted Manifest table is not equal to order count", ordersCount, implantedManifestOrderTable.getRowsCount());
    }

    public void verifyManifestTableIsEmpty()
    {
        waitUntilVisibilityOfElementLocated("//h5[text()='0 order(s) in manifest']");
        scrollToBottom();
        assertTrue("Manifest table is not empty. Orders were not removed by \"Remove All\" button click", isTableEmpty());
    }

    public void verifyInfoInManifestTableForOrder(Order order, Map<String, ZonedDateTime> barcodeToScannedAtTime)
    {
        String trackingId = order.getTrackingId();
        ZonedDateTime scannedAt = barcodeToScannedAtTime != null ?
                barcodeToScannedAtTime.get(trackingId).truncatedTo(ChronoUnit.SECONDS) :
                null;
        String destination = order.getToAddress1() + (order.getToAddress2().trim().isEmpty() ? "" : " " + order.getToAddress2());
        String rackSector = order.getRackSector();
        String addressee = order.getToName();

        boolean recordFound = false;

        for (int i = 1; i <= implantedManifestOrderTable.getRowsCount(); i++)
        {
            ImplantedManifestOrder implantedManifestOrder = implantedManifestOrderTable.readEntity(i);

            if (trackingId.equals(implantedManifestOrder.getTrackingId()))
            {
                recordFound = true;
                if (scannedAt != null)
                {
                    LocalDateTime scannedAtLocalExpected = scannedAt.toLocalDateTime();
                    LocalDateTime scannedAtLocalActual = implantedManifestOrder.getScannedAt().toLocalDateTime();
                    assertThat("'Scanned At' value in Implant Manifest table is not in expected range", scannedAtLocalExpected, isOneOf(scannedAtLocalActual, scannedAtLocalActual.plusSeconds(1L), scannedAtLocalActual.plusSeconds(2L), scannedAtLocalActual.minusSeconds(1L), scannedAtLocalActual.minusSeconds(2L)));
                }
                assertEquals("'Destination' value in Implant Manifest table", destination, implantedManifestOrder.getDestination());
                assertEquals("'Rack Sector' value in Implant Manifest table", rackSector, implantedManifestOrder.getRackSector());
                assertEquals("'Addressee' value in Implant Manifest table", addressee, implantedManifestOrder.getAddressee());
            }
        }

        assertTrue(f("No record with tracking Id %s in Manifest table", order.getTrackingId()), recordFound);
    }

    public void scrollToBottom()
    {
        scrollIntoView("//button[@aria-label='Create Manifest']");
    }

    public static class CreateManifestDialog extends MdDialog
    {
        @FindBy(id = "container.implanted-manifest.reservation-id")
        public TextBox reservationId;

        @FindBy(id = "createManifestButton")
        public NvIconTextButton createManifestButton;

        public CreateManifestDialog(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }
    }
}
