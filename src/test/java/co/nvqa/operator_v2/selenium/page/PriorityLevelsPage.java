package co.nvqa.operator_v2.selenium.page;

import org.openqa.selenium.WebDriver;

import java.io.File;
import java.util.Map;
import java.util.stream.Collectors;

public class PriorityLevelsPage extends OperatorV2SimplePage {

    private static final String SAMPLE_CSV_ORDERS_FILENAME = "priority_sample_orders.csv";
    private static final String SAMPLE_CSV_ORDERS_FILENAME_PATTERN = "priority_sample_orders-%s.csv";
    private static final String SAMPLE_CSV_RESERVATIONS_FILENAME = "priority_sample_reservations.csv";
    private static final String BUTTON_DOWNLOAD_SAMPLE_CSV_ORDERS_ARIA_LABEL = "Download Sample CSV (Orders)";
    private static final String BUTTON_DOWNLOAD_SAMPLE_CSV_RESERVATIONS_ARIA_LABEL = "Download Sample CSV (Reservations)";

    private static final String UPLOAD_ORDER_BUTTON_XPATH = "//nv-create-button[contains(@on-click, 'csvType.ORDER')]//button[@aria-label='Upload CSV']";
    private static final String UPLOAD_ORDER_MD_DIALOG_XPATH = "//md-dialog//*[text()='Upload Order CSV']";
    private static final String UPLOAD_ORDER_CSV_UPLOADED_ITEM_XPATH_PATTERN = "//md-list-item//*[text()='%s']";

    private static final String SAMPLE_CSV_ORDERS_EXPECTED_TEXT = "Transaction ID,Priority Level";
    private static final String SAMPLE_CSV_RESERVATIONS_EXPECTED_TEXT = "Reservation ID,Priority Level";



    public PriorityLevelsPage(WebDriver webDriver) {
        super(webDriver);
    }

    public void clickDownloadSampleCsvOrdersButton(){
        clickButtonByAriaLabelAndWaitUntilDone(BUTTON_DOWNLOAD_SAMPLE_CSV_ORDERS_ARIA_LABEL);
    }

    public void clickDownloadSampleCsvReservationsButton(){
        clickButtonByAriaLabelAndWaitUntilDone(BUTTON_DOWNLOAD_SAMPLE_CSV_RESERVATIONS_ARIA_LABEL);
    }

    public void verifyDownloadedSampleCsvOrders(){
        verifyFileDownloadedSuccessfully(SAMPLE_CSV_ORDERS_FILENAME, SAMPLE_CSV_ORDERS_EXPECTED_TEXT);
    }

    public void verifyDownloadedSampleCsvReservations(){
        verifyFileDownloadedSuccessfully(SAMPLE_CSV_RESERVATIONS_FILENAME, SAMPLE_CSV_RESERVATIONS_EXPECTED_TEXT);
    }

    public void uploadUpdateViaCsvOrders(Map<String, String> transactionToPriorityLevel)
    {
        clickAndWaitUntilDone(UPLOAD_ORDER_BUTTON_XPATH);
        waitUntilVisibilityOfElementLocated(UPLOAD_ORDER_MD_DIALOG_XPATH);

        String csvContent = SAMPLE_CSV_ORDERS_EXPECTED_TEXT + "\n" +
                transactionToPriorityLevel.entrySet().stream().map(entry -> entry.getKey() + "," + entry.getValue())
                .collect(Collectors.joining("\n"));

        File csvFile = createFile(f(SAMPLE_CSV_ORDERS_FILENAME_PATTERN, generateDateUniqueString()), csvContent);

        sendKeysByAriaLabel("Choose", csvFile.getAbsolutePath());
        waitUntilVisibilityOfElementLocated(f(UPLOAD_ORDER_CSV_UPLOADED_ITEM_XPATH_PATTERN, csvFile.getName()));
        clickNvButtonSaveByNameAndWaitUntilDone("Submit");
    }

    public void clickBulkUpdateButton(){
        clickButtonByAriaLabelAndWaitUntilDone("Bulk Update");
        waitUntilInvisibilityOfToast("Update by CSV success");
    }
}
