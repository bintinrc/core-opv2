package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.model.ImplantedManifestOrder;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.WebDriver;

import java.time.LocalDateTime;
import java.time.ZonedDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Map;

/**
 * @author Kateryna Skakunova
 */
public class ImplantedManifestPage extends OperatorV2SimplePage {

    private ImplantedManifestOrderTable implantedManifestOrderTable;

    private static final String CSV_FILENAME_FORMAT = "implanted-manifest-%s.csv";

    public ImplantedManifestPage(WebDriver webDriver) {
        super(webDriver);
        implantedManifestOrderTable = new ImplantedManifestOrderTable(webDriver);
    }

    /**
     * Accessor for Manifest table
     */
    public static class ImplantedManifestOrderTable extends MdVirtualRepeatTable<ImplantedManifestOrder> {
        public static final String MD_VIRTUAL_REPEAT = "scan in getTableData()";
        public static final String COLUMN_TRACKING_ID = "trackingId";
        public static final String COLUMN_SCANNED_AT = "scannedAt";
        public static final String COLUMN_DESTINATION = "destination";
        public static final String COLUMN_ADDRESSEE = "addressee";
        public static final String COLUMN_RACK_SECTOR = "rackSector";
        public static final String COLUMN_DELIVERY_BY = "deliveryBy";

        public ImplantedManifestOrderTable(WebDriver webDriver) {
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

    public void clickActionXForRow(int rowNumber) {
        implantedManifestOrderTable.clickActionButton(rowNumber, "close");
    }

    public void clickCreateManifestButtonToInitiateCreation() {
        waitUntilInvisibilityOfElementLocated("//button[@aria-label='container.implanted-manifest.create-manifest' and @disabled='disabled']");
        clickNvApiTextButtonByNameAndWaitUntilDone("container.implanted-manifest.create-manifest");
    }

    public void clickDownloadCsvFile() {
        clickNvApiTextButtonByNameAndWaitUntilDone("Download CSV File");
    }

    public void clickRemoveAllButtonAndConfirm() {
        clickButtonByAriaLabelAndWaitUntilDone("Remove All");
        clickButtonByAriaLabelAndWaitUntilDone("Delete");
    }

    public void csvDownloadSuccessfullyAndContainsOrderInfo(Order order, String hubName) {
        String csvFileName = f(CSV_FILENAME_FORMAT, hubName);

        String trackingId = order.getTrackingId();
        verifyFileDownloadedSuccessfully(csvFileName, trackingId);

        String destination = order.getToAddress1() + " " + order.getToAddress2();
        String rackSector = order.getRackSector();
        String addressee = order.getToName();
        String expectedText = String.format("\"%s\",\"%s\",\"%s\"", destination, addressee, rackSector);
        verifyFileDownloadedSuccessfully(csvFileName, expectedText);
    }

    public void removeOrderByScan(String barcode) {
        sendKeysAndEnterByAriaLabel("remove_scan_barcode", barcode);
        String xpathToBarCode = "//input[@aria-label='remove_scan_barcode' and contains(@class,'ng-empty')]";
        waitUntilVisibilityOfElementLocated(xpathToBarCode);
    }

    public void scanBarCodeAndSaveTime(Map<String, ZonedDateTime> barcodeToScannedAtTime, String barcode) {
        sendKeysAndEnterByAriaLabel("scan_barcode", barcode);
        barcodeToScannedAtTime.put(barcode, DateUtil.getDate(DateUtil.SINGAPORE_ZONE_ID));
        String xpathToBarCode = "//input[@aria-label='scan_barcode' and contains(@class,'ng-empty')]";
        waitUntilVisibilityOfElementLocated(xpathToBarCode);
    }

    public void selectHub(String destinationHub) {
        pause2s();
        selectValueFromMdSelectWithSearch("model", destinationHub);
    }

    public void verifyRowsCountEqualsOrdersCountInManifestTable(int ordersCount) {
        assertEquals("Rows count in Implanted Manifest table is not equal to order count", ordersCount,
                implantedManifestOrderTable.getRowsCount());
    }

    public void verifyManifestTableIsEmpty() {
        waitUntilVisibilityOfElementLocated("//h5[text()='0 order(s) in manifest']");
        assertTrue("Manifest table is not empty. Orders were not removed by \"Remove All\" button click", isTableEmpty());
    }

    public void verifyInfoInManifestTableForOrder(Order order, Map<String, ZonedDateTime> barcodeToScannedAtTime) {
        String trackingId = order.getTrackingId();
        ZonedDateTime scannedAt = barcodeToScannedAtTime.get(trackingId).truncatedTo(ChronoUnit.SECONDS);
        String destination = order.getToAddress1() + (order.getToAddress2().trim().isEmpty() ? "" : " " + order.getToAddress2());
        String rackSector = order.getRackSector();
        String addressee = order.getToName();

        boolean recordFound = false;
        for (int i = 1; i <= implantedManifestOrderTable.getRowsCount(); i++) {
            ImplantedManifestOrder implantedManifestOrder = implantedManifestOrderTable.readEntity(i);
            if (trackingId.equals(implantedManifestOrder.getTrackingId())) {
                recordFound = true;
                LocalDateTime scannedAtLocalExpected = scannedAt.toLocalDateTime();
                LocalDateTime scannedAtLocalActual = implantedManifestOrder.getScannedAt().toLocalDateTime();
                assertThat("'Scanned At' value in Implant Manifest table is not in expected range", scannedAtLocalExpected,
                        isOneOf(scannedAtLocalActual, scannedAtLocalActual.plusSeconds(1L), scannedAtLocalActual.minusSeconds(1L)));
                assertEquals("'Destination' value in Implant Manifest table", destination, implantedManifestOrder.getDestination());
                assertEquals("'Rack Sector' value in Implant Manifest table", rackSector, implantedManifestOrder.getRackSector());
                assertEquals("'Addressee' value in Implant Manifest table", addressee, implantedManifestOrder.getAddressee());
            }
        }
        assertTrue(f("No record with tracking Id %s in Manifest table", order.getTrackingId()), recordFound);
    }
}
