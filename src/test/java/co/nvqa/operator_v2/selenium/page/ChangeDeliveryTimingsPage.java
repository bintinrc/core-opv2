package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.model.ChangeDeliveryTiming;
import co.nvqa.operator_v2.util.TestUtils;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 *
 * @author Tristania Siagian
 */

public class ChangeDeliveryTimingsPage extends SimplePage {

    private static final String CSV_FILENAME = "sample_csv.csv";
    private static final String COMMA = ",";
    private static final String CSV_CAMPAIGN_HEADER = "tracking_id,start_date,end_date,timewindow";
    private static final String NG_REPEAT = "success in $data";
    private static final String NG_REPEAT_ERROR = "error in $data";
    private static final String COLUMN_DATA_TITLE_TEXT = "'commons.tracking-id' | translate";
    private static final String ERROR_COLUMN_DATA = "'container.change-delivery-timings.header-message' | translate";

    public ChangeDeliveryTimingsPage(WebDriver webDriver) {
        super(webDriver);
    }

    public void downloadSampleCSVFile() {
        clickNvApiTextButtonByName("Download sample CSV file");
    }

    public void csvSampleDownloadSuccessful() {
        verifyFileDownloadedSuccessfully(CSV_FILENAME);
    }

    public void uploadCsvCampaignFile(List<ChangeDeliveryTiming> listOfChangeDeliveryTimings) {
        File csvResultFile = createDeliveryTimingChanging(listOfChangeDeliveryTimings);
        clickNvIconTextButtonByName("Upload CSV");
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class,'file-select')]");
        sendKeysByAriaLabel("Choose", csvResultFile.getAbsolutePath());
        clickNvButtonSaveByNameAndWaitUntilDone("Upload CSV");
        waitUntilInvisibilityOfToast("Delivery Time Updated");
    }

    private File createDeliveryTimingChanging(List<ChangeDeliveryTiming> listOfChangeDeliveryTimings) {
        File csvResultFile = TestUtils.createFileOnTempFolder(String.format("change-delivery-timings_%s.csv", generateDateUniqueString()));

        try {
            StringBuilder csvData = new StringBuilder();

            listOfChangeDeliveryTimings.stream().forEach((row)-> {
                StringBuilder sb = new StringBuilder();
                sb.append(row.getTrackingId()).append(COMMA);
                sb.append(row.getStartDate()).append(COMMA);
                sb.append(row.getEndDate()).append(COMMA);

                if(row.getTimewindow()!=null) {
                    sb.append(row.getTimewindow()).append(COMMA);
                }
                else {
                    sb.append(COMMA);
                }

                csvData.append(sb.toString()).append(System.lineSeparator());
            });

            PrintWriter pw = new PrintWriter(new FileOutputStream(csvResultFile));
            pw.println(CSV_CAMPAIGN_HEADER);
            pw.print(csvData.toString());
            pw.close();
        }
        catch(IOException ex) {
            throw new NvTestRuntimeException(ex);
        }

        return csvResultFile;
    }

    public void verifyDeliveryTimeChanged(String trackingId) {
        String actualRes = getTextOnTableWithNgRepeatUsingDataTitleText(1, COLUMN_DATA_TITLE_TEXT, NG_REPEAT);
        Assert.assertEquals("Tracking ID is not existed on the success table.", trackingId, actualRes);
    }

    public void invalidTrackingIdVerification() {
        String actualMessage = getTextOnTableWithNgRepeatUsingDataTitleText(1, ERROR_COLUMN_DATA, NG_REPEAT_ERROR);
        Assert.assertEquals("Tracking ID is valid.","INVALID_TRACKING_ID", actualMessage);
    }

    public void invalidStateOrderVerification() {
        String actualMessage = getTextOnTableWithNgRepeatUsingDataTitleText(1, ERROR_COLUMN_DATA, NG_REPEAT_ERROR);
        Assert.assertThat("Tracking ID is valid.", actualMessage, Matchers.startsWith("INVALID_STATE"));
    }

    public void dateIndicatedIncorectlyVerification() {
        String actualMessage = getTextOnTableWithNgRepeatUsingDataTitleText(1, ERROR_COLUMN_DATA, NG_REPEAT_ERROR);
        Assert.assertEquals("Tracking ID is valid.", "Start and End Date not indicated correctly", actualMessage);
    }

    public void startDateLaterVerification() {
        String actualMessage = getTextOnTableWithNgRepeatUsingDataTitleText(1, ERROR_COLUMN_DATA, NG_REPEAT_ERROR);
        Assert.assertEquals("Tracking ID is valid.","Start Date is later than End Date", actualMessage);
    }
}
