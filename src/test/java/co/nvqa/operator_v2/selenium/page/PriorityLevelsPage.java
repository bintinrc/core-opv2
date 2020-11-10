package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

import java.io.File;
import java.util.Map;
import java.util.stream.Collectors;

public class PriorityLevelsPage extends OperatorV2SimplePage
{
    private static final String SAMPLE_CSV_ORDERS_FILENAME = "priority_sample_orders.csv";
    private static final String SAMPLE_CSV_ORDERS_FILENAME_PATTERN = "priority_sample_orders-%s.csv";
    private static final String SAMPLE_CSV_RESERVATIONS_FILENAME = "priority_sample_reservations.csv";

    private static final String SAMPLE_CSV_ORDERS_EXPECTED_TEXT = "Transaction ID,Priority Level";
    private static final String SAMPLE_CSV_RESERVATIONS_EXPECTED_TEXT = "Reservation ID,Priority Level";

    @FindBy(css = "nv-icon-text-button[on-click*='selectCsv'][on-click*='csvType.ORDER']")
    public NvIconTextButton uploadCsvOrders;

    @FindBy(css = "nv-icon-text-button[on-click*='download'][on-click*='csvType.ORDER']")
    public NvIconTextButton downloadSimpleCsvOrders;

    @FindBy(css = "nv-icon-text-button[on-click*='selectCsv'][on-click*='csvType.RSVN']")
    public NvIconTextButton uploadCsvReservations;

    @FindBy(css = "nv-icon-text-button[on-click*='download'][on-click*='csvType.RSVN']")
    public NvIconTextButton downloadSimpleCsvReservations;

    @FindBy(css = "md-dialog")
    public UploadFileDialog uploadCsvDialog;

    public PriorityLevelsPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void verifyDownloadedSampleCsvOrders()
    {
        verifyFileDownloadedSuccessfully(SAMPLE_CSV_ORDERS_FILENAME, SAMPLE_CSV_ORDERS_EXPECTED_TEXT);
    }

    public void verifyDownloadedSampleCsvReservations()
    {
        verifyFileDownloadedSuccessfully(SAMPLE_CSV_RESERVATIONS_FILENAME, SAMPLE_CSV_RESERVATIONS_EXPECTED_TEXT);
    }

    public void uploadUpdateViaCsvOrders(Map<String, String> transactionToPriorityLevel)
    {
        uploadCsvOrders.click();
        String csvContent = SAMPLE_CSV_ORDERS_EXPECTED_TEXT + "\n" +
                transactionToPriorityLevel.entrySet().stream().map(entry -> entry.getKey() + "," + entry.getValue())
                        .collect(Collectors.joining("\n"));
        File csvFile = createFile(f(SAMPLE_CSV_ORDERS_FILENAME_PATTERN, generateDateUniqueString()), csvContent);
        uploadCsvDialog.uploadFile(csvFile);
    }

    public void clickBulkUpdateButton()
    {
        clickButtonByAriaLabelAndWaitUntilDone("Bulk Update");
        waitUntilInvisibilityOfToast("Update by CSV success");
    }
}
