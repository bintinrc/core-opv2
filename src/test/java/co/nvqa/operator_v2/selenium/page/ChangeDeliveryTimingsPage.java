package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.utils.NvLogger;
import co.nvqa.operator_v2.model.ChangeDeliveryTimings;
import co.nvqa.operator_v2.util.TestConstants;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * @author Tristania Siagian
 */

public class ChangeDeliveryTimingsPage extends SimplePage {

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    private static final String CSV_FILENAME = "sample_csv.csv";
    private static final String COMMA = ",";
    private static final String NEW_LINE = "\r\n";
    private static final String CSV_CHANGING_FILE_NAME = "test_csv.csv";
    private static final String FILE_PATH = TestConstants.TEMP_DIR + CSV_CHANGING_FILE_NAME;
    private static final String CSV_CAMPAIGN_HEADER = "tracking_id,start_date,end_date,timewindow";
    private static final String NG_REPEAT = "success in $data";
    private static final String COLUMN_DATA_TITLE_TEXT = "'commons.tracking-id' | translate";

    public ChangeDeliveryTimingsPage(WebDriver webDriver) {
        super(webDriver);
    }

    public void downloadSampleCSVFile() {
        clickNvApiTextButtonByName("Download sample CSV file");
    }

    public void csvSampleDownloadSuccessful() {
        verifyFileDownloadedSuccessfully(CSV_FILENAME);
    }

    public void uploadCsvCampaignFile(List<ChangeDeliveryTimings> data) {
        try
        {
            createDeliveryTimingChanging(data);
            additionalStep();
        }
        catch(FileNotFoundException ex)
        {
            NvLogger.warn("Error on method 'uploadCsvCampaignFile'.", ex);
        }
    }

    private void additionalStep() {
        clickNvIconTextButtonByName("Upload CSV");
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'file-select')]");
        uploadFile();
        clickAndWaitUntilDone("//md-dialog-actions/*/button[contains(@class, 'md-nvGreen-theme')]");
    }

    private void createDeliveryTimingChanging(List<ChangeDeliveryTimings> data) throws FileNotFoundException
    {
        StringBuilder CSVData = new StringBuilder();

        data.stream().forEach((row)->
        {
            StringBuilder sb = new StringBuilder();
            sb.append(row.getTracking_id()).append(COMMA);
            sb.append(row.getStart_date()).append(COMMA);
            sb.append(row.getEnd_date()).append(COMMA);
            sb.append(row.getTimewindow()).append(COMMA);
            CSVData.append(sb.toString()).append(NEW_LINE);
        });

        PrintWriter pw = new PrintWriter(new FileOutputStream(FILE_PATH));
        pw.println(CSV_CAMPAIGN_HEADER);
        pw.print(CSVData.toString());
        pw.close();
    }

    private void uploadFile()
    {
        WebElement inputElement = getwebDriver().findElement(By.xpath("//input[@type='file']"));
        inputElement.sendKeys(FILE_PATH);
        pause3s();
    }

    public void verifyDeliveryTimeChanged(String trackingID)
    {
        String actualRes = getTextOnTableWithNgRepeatUsingDataTitleText(1, COLUMN_DATA_TITLE_TEXT, NG_REPEAT);
        Assert.assertEquals("Tracking ID is not existed on the success table",trackingID,actualRes);
    }

    public void enterTrackingID(String trackingID) {
        WebElement input = getwebDriver().findElement(By.id("searchTerm"));
        input.sendKeys(trackingID);
        clickNvApiTextButtonByName("commons.search");
    }

    public void switchTab() {
        getwebDriver().findElement(By.cssSelector("body")).sendKeys(Keys.CONTROL+"/t");
        getwebDriver().switchTo().defaultContent();
    }

    public void verifyDateRange(String date_start, String end_date) {
        String datestart = getwebDriver().findElement(By.xpath("//div[label/text()='Start Date / Time']/p")).getText();
        String enddate = getwebDriver().findElement(By.xpath("//div[label/text()='End Date / Time']/p")).getText();
        Date dateStart = sdf.parse(datestart);
        Date dateEnd = sdf.parse(enddate);
        Assert.assertEquals("Start Date does not match", date_start, dateStart);
        Assert.assertEquals("End Date does not match", end_date, dateEnd);
    }

}
