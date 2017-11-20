package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.SmsCampaignCsv;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import com.nv.qa.commons.utils.NvLogger;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 *
 * @author Rizaq Pratama
 */
public class SmsModulePage extends SimplePage
{
    private static final String COMMA = ",";
    private static final String NEW_LINE = "\r\n";
    private static final String SMS_CAMPAIGN_FILE_NAME = "sms_campaign.csv";
    private static final String SMS_CAMPAIGN_HEADER = "tracking_id,name,email,job";
    private static final String FILE_PATH = TestConstants.SELENIUM_WRITE_PATH + SMS_CAMPAIGN_FILE_NAME;
    private static final String MD_VIRTUAL_REPEAT = "sms in getTableData()";
    private static Map<String, Object> cache;
    private SimpleDateFormat sdf = new SimpleDateFormat("YYYY-MM-DD hh:ss");

    public SmsModulePage(WebDriver webDriver)
    {
        super(webDriver);

        if(cache== null)
        {
            cache = new ConcurrentHashMap<>();
        }
    }

    public void uploadCsvCampaignFile(List<SmsCampaignCsv> data)
    {
        try
        {
            createSmsCampaignCsv(data);
            uploadFile();
        }
        catch(FileNotFoundException ex)
        {
            NvLogger.warn("Error on method 'uploadCsvCampaignFile'.", ex);
        }
    }

    private void createSmsCampaignCsv(List<SmsCampaignCsv> data) throws FileNotFoundException
    {
        StringBuilder smsCampaignData = new StringBuilder();

        data.stream().forEach((row)->
        {
            StringBuilder sb = new StringBuilder();
            sb.append(row.getTracking_id()).append(COMMA);
            sb.append(row.getName()).append(COMMA);
            sb.append(row.getEmail()).append(COMMA);
            sb.append(row.getJob()).append(COMMA);
            smsCampaignData.append(sb.toString()).append(NEW_LINE);
        });

        PrintWriter pw = new PrintWriter(new FileOutputStream(FILE_PATH));
        pw.println(SMS_CAMPAIGN_HEADER);
        pw.print(smsCampaignData.toString());
        pw.close();
    }

    private void uploadFile()
    {
        WebElement inputElement = getwebDriver().findElement(By.xpath("//input[@type='file']"));
        inputElement.sendKeys(FILE_PATH);
        pause3s();
    }

    public void continueOnCsvUploadFailure()
    {
        pause1s();
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class,'nv-partial-failed-upload-csv')]");
        findElementByXpath("//nv-icon-text-button[@text='commons.continue']").click();
        waitUntilInvisibilityOfElementLocated("//md-dialog[contains(@class,'nv-partial-failed-upload-csv')]");
    }

    public void verifyThatPageReset()
    {
        pause1s();
        Assert.assertFalse(isElementExist("//md-card[contains(@class,'sms-editor')]"));
        Assert.assertFalse(isElementExist("//md-dialog[contains(@class,'nv-partial-failed-upload-csv')"));
    }

    public void composeSms(String name, String trackingId)
    {
        waitUntilVisibilityOfElementLocated("//md-card[contains(@class,'sms-editor')]");
        String smsDate = sdf.format(new Date());
        cache.put("sms-date", smsDate);
        //check the uploaded file name is correct
        WebElement uploadedFileNameElement = findElementByXpath("//div[contains(@class,'uploaded-info')]//div[1]/p/b");
        Assert.assertEquals(SMS_CAMPAIGN_FILE_NAME, uploadedFileNameElement.getText());
        WebElement totalRecords = findElementByXpath("//div[contains(@class,'uploaded-info')]//div[2]/p/b");
        Assert.assertEquals("1", totalRecords.getText());
        //entry the template
        String template = "Hallo {{name}}, your parcel with tracking id {{tracking_id}} is ready to be delivered. sms-date: "+smsDate;
        sendKeys("//textarea[@name='message']", template);
        pause100ms();
        click("//nv-icon-text-button[@on-click='ctrl.updatePreview()']");
        pause1s();
        String expectedMessage = "Hallo "+name+", your parcel with tracking id "+trackingId+" is ready to be delivered. sms-date: "+smsDate;
        String actualMessage = findElementByXpath("//md-input-container[@model='ctrl.messagePreview']/textarea[@name='preview']").getAttribute("value");
        Assert.assertEquals(expectedMessage, actualMessage);
    }

    public void composeSmsWithUrlShortener()
    {
        waitUntilVisibilityOfElementLocated("//md-card[contains(@class,'sms-editor')]");
        //check the uploaded file name is correct
        WebElement uploadedFileNameElement = findElementByXpath("//div[contains(@class,'uploaded-info')]//div[1]/p/b");
        Assert.assertEquals(SMS_CAMPAIGN_FILE_NAME, uploadedFileNameElement.getText());
        WebElement totalRecords = findElementByXpath("//div[contains(@class,'uploaded-info')]//div[2]/p/b");
        Assert.assertEquals("1", totalRecords.getText());
        //entry the template
        String template = "email : {{email}}";
        sendKeys("//textarea[@name='message']", template);
        pause100ms();
        //check the shorten url click box
        click("//li[@ng-repeat='field in ctrl.fields'][3]/span[2]/input");
        pause100ms();
        click("//nv-icon-text-button[@on-click='ctrl.updatePreview()']");
    }

    public void verifyThatPreviewUsingShortenedUrl()
    {
        pause10s();
        String actualValue = findElementByXpath("(//textarea[@name='preview'])[2]").getAttribute("value");
        String expectedValue = "http://qa.nnj.vn";
        Assert.assertThat("The produced sms using ninja url shortener is failed", actualValue, Matchers.containsString(expectedValue));
    }

    public void waitForSmsToBeProcessed()
    {
        pause10s();
    }

    public void sendSms()
    {
        click("//nv-api-text-button[@text='container.sms.send-messages']");
        waitUntilVisibilityOfElementLocated("//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div");
        WebElement successToast = TestUtils.getToast(getwebDriver());
        Assert.assertEquals("Successfully sent 1 SMS", successToast.getText());
    }

    public void searchSmsSentHistory(String trackingId)
    {
        sendKeys("//input[@name='trackingId']",trackingId);
        click("//nv-icon-text-button[@text='commons.load']/button");
    }

    public void verifySmsHistoryTrackingIdInvalid(String trackingId)
    {
        waitUntilVisibilityOfElementLocated("//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div");
        WebElement failedToast = TestUtils.getToast(getwebDriver());
        Assert.assertEquals("Order with trackingId "+trackingId+" not found!", failedToast.getText());
    }

    public void verifySmsHistoryTrackingIdValid(String trackingId, String contactNumber)
    {
        waitUntilVisibilityOfElementLocated("//md-card[contains(@class,'sms-history')]");
        String smsDate = (String)cache.get("sms-date");
        //assert that tracking id is equal
        WebElement trackingIdElement = findElementByXpath("//md-card[contains(@class,'sms-history')]/md-card-content/div/span");
        Assert.assertEquals("Tracking id: "+trackingId, trackingIdElement.getText());

        //check the contact number
        String number=  getTextOnTableWithMdVirtualRepeat(1,"to-number", MD_VIRTUAL_REPEAT, false);
        Assert.assertEquals("Contact Number", contactNumber, number);

        //check sms-date on the message field
        String message =  getTextOnTableWithMdVirtualRepeat(1,"message", MD_VIRTUAL_REPEAT, false);
        Assert.assertThat("It contain sms-date woth same date", message, Matchers.containsString(smsDate));
    }
}
