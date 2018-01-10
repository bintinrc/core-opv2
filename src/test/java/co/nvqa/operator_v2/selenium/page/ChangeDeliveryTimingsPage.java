package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.utils.NvLogger;
import co.nvqa.operator_v2.model.ChangeDeliveryTimings;
import co.nvqa.operator_v2.util.TestUtils;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
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

    public void uploadCsvCampaignFile(List<ChangeDeliveryTimings> listOfChangeDeliveryTimings) {
        try {
            File csvResultFile = createDeliveryTimingChanging(listOfChangeDeliveryTimings);
            clickNvIconTextButtonByName("Upload CSV");
            waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'file-select')]");
            sendKeysByAriaLabel("Choose", csvResultFile.getAbsolutePath());
            pause3s();
            clickNvButtonSaveByNameAndWaitUntilDone("Upload CSV");
        }
        catch(FileNotFoundException ex) {
            NvLogger.warn("Error on method 'uploadCsvCampaignFile'.", ex);
        }
    }

    private File createDeliveryTimingChanging(List<ChangeDeliveryTimings> listOfChangeDeliveryTimings) throws FileNotFoundException
    {
        File csvResultFile = TestUtils.createFileOnTempFolder(String.format("change-delivery-timings_%s.csv", generateDateUniqueString()));
        StringBuilder csvData = new StringBuilder();

        listOfChangeDeliveryTimings.stream().forEach((row)-> {
            StringBuilder sb = new StringBuilder();
            sb.append(row.getTracking_id()).append(COMMA);
            sb.append(row.getStart_date()).append(COMMA);
            sb.append(row.getEnd_date()).append(COMMA);

            if (row.getTimewindow()!=null) {
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

        return csvResultFile;
    }

    public void verifyDeliveryTimeChanged(String trackingId) {
        String actualRes = getTextOnTableWithNgRepeatUsingDataTitleText(1, COLUMN_DATA_TITLE_TEXT, NG_REPEAT);
        Assert.assertEquals("Tracking ID is not existed on the success table.", trackingId, actualRes);
    }

    public void switchTab() {
        ArrayList<String> tabs = new ArrayList<>(getwebDriver().getWindowHandles());
        getwebDriver().switchTo().window(tabs.get(tabs.size()-1));
    }

    public void verifyDateRange(String startDate, String endDate, boolean isTimewindowNull) {
        pause5s();

        String actualStartDate = getText("//div[@id='delivery-details']//div[label/text()='Start Date / Time']/p");
        String actualEndDate = getText("//div[@id='delivery-details']//div[label/text()='End Date / Time']/p");

        if(isTimewindowNull) {
            actualStartDate = actualStartDate.substring(0, 10);
            actualEndDate = actualEndDate.substring(0, 10);
        }

        Assert.assertEquals("Start Date does not match.", startDate, actualStartDate);
        Assert.assertEquals("End Date does not match.", endDate, actualEndDate);
    }

    public void closeTab() {
        ArrayList<String> tabs = new ArrayList<String>(getwebDriver().getWindowHandles());
        getwebDriver().findElement(By.cssSelector("body")).sendKeys(Keys.COMMAND+"1");
        getwebDriver().findElement(By.cssSelector("body")).sendKeys(Keys.CONTROL+"1");
        getwebDriver().close();
        getwebDriver().switchTo().window(tabs.get(0));
    }

    public void invalidTrackingIdVerification() {
        String actualMessage = getTextOnTableWithNgRepeatUsingDataTitleText(1, ERROR_COLUMN_DATA, NG_REPEAT_ERROR);
        Assert.assertEquals("Tracking ID is valid.","INVALID_TRACKING_ID", actualMessage);
    }

    public void invalidStateOrderVerification() {
        String actualMessage = getTextOnTableWithNgRepeatUsingDataTitleText(1, ERROR_COLUMN_DATA, NG_REPEAT_ERROR);
        Assert.assertEquals("Tracking ID is valid.","INVALID_STATE", actualMessage.substring(0, 13));
    }

    public void dateIndicatedIncorectlyVerification() {
        String actualMessage = getTextOnTableWithNgRepeatUsingDataTitleText(1, ERROR_COLUMN_DATA, NG_REPEAT_ERROR);
        Assert.assertEquals("Tracking ID is valid.","Start and End Date not indicated correctly", actualMessage);
    }

    public void startDateLaterVerification() {
        String actualMessage = getTextOnTableWithNgRepeatUsingDataTitleText(1, ERROR_COLUMN_DATA, NG_REPEAT_ERROR);
        Assert.assertEquals("Tracking ID is valid.","Start Date is later than End Date", actualMessage);
    }

    public void dateEmpty(String startDate, String endDate, boolean isDateEmpty) {
        pause5s();

        String actualStartTime = getText("//div[@id='delivery-details']//div[label/text()='Start Date / Time']/p");
        String actualEndTime = getText("//div[@id='delivery-details']//div[label/text()='End Date / Time']/p");

        if(isDateEmpty) {
            actualStartTime = actualStartTime.substring(11, 19);
            actualEndTime = actualEndTime.substring(11, 19);
        }

        Assert.assertEquals("Start Date does not match.", startDate, actualStartTime);
        Assert.assertEquals("End Date does not match.", endDate, actualEndTime);
    }
}
