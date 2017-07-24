package com.nv.qa.selenium.page;

import com.nv.qa.model.SmsCampaignCsv;
import com.nv.qa.support.APIEndpoint;
import com.nv.qa.support.CommonUtil;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.util.List;

/**
 * Created by rizaqpratama on 7/18/17.
 */
public class SmsModulePage extends SimplePage{

    private static final String COMMA = ",";
    private static final String NEW_LINE = "\r\n";
    private static final String SMS_CAMPAIGN_FILE_NAME = "sms_campaign.csv";
    private static final String SMS_CAMPAIGN_HEADER = "tracking_id,name,email,job";
    private static final String FILE_PATH = APIEndpoint.SELENIUM_WRITE_PATH + SMS_CAMPAIGN_FILE_NAME;
    private static final int LOADING_TIMEOUT_IN_SECONDS = 30;
    private static final String MD_VIRTUAL_REPEAT = "sms in getTableData()";


    public SmsModulePage(WebDriver driver){
        super(driver);
    }

    public void uploadCsvCampaignFile(List<SmsCampaignCsv> data){
        try {
            createSmsCampaignCsv(data);
            uploadFile();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

    }


    private void createSmsCampaignCsv(List<SmsCampaignCsv> data) throws FileNotFoundException{
        StringBuilder smsCampaignData = new StringBuilder();
        data.stream().forEach((row)->{
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


    private void uploadFile(){
        WebElement inputElement = getDriver().findElement(By.xpath("//input[@type='file']"));
        inputElement.sendKeys(FILE_PATH);
        pause3s();
    }

    public void continueOnCsvUploadFailure(){
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class,'nv-partial-failed-upload-csv')]", LOADING_TIMEOUT_IN_SECONDS);
        findElementByXpath("//nv-icon-text-button[@text='commons.continue']").click();
        waitUntilInvisibilityOfElementLocated("//md-dialog[contains(@class,'nv-partial-failed-upload-csv')]", LOADING_TIMEOUT_IN_SECONDS);
        pause1s();
        Assert.assertFalse(isElementExist("//md-card[contains(@class,'sms-editor')]"));
        Assert.assertFalse(isElementExist("//md-dialog[contains(@class,'nv-partial-failed-upload-csv')"));
    }

    public void composeSms(String name, String trackingId){
        waitUntilVisibilityOfElementLocated("//md-card[contains(@class,'sms-editor')]", LOADING_TIMEOUT_IN_SECONDS);
        //check the uploaded file name is correct
        WebElement uploadedFileNameElement = findElementByXpath("//div[contains(@class,'uploaded-info')]//div[1]/p/b");
        Assert.assertEquals(SMS_CAMPAIGN_FILE_NAME, uploadedFileNameElement.getText());
        WebElement totalRecords = findElementByXpath("//div[contains(@class,'uploaded-info')]//div[2]/p/b");
        Assert.assertEquals("1", totalRecords.getText());
        //entry the template
        String template = "Hallo {{name}}, your parcel with tracking id {{tracking_id}} is ready to be delivered";
        sendKeys("//textarea[@name='message']", template);
        pause100ms();
        click("//nv-icon-text-button[@on-click='ctrl.updatePreview()']");
        pause1s();
        Assert.assertEquals("Hallo "+name+", your parcel with tracking id "+trackingId+" is ready to be delivered",
                findElementByXpath("//textarea[@name='preview']").getAttribute("value"));

    }

    public void sendSms(){
        click("//nv-api-text-button[@text='container.sms.send-sms']");
        waitUntilVisibilityOfElementLocated("//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div", LOADING_TIMEOUT_IN_SECONDS);
        WebElement successToast = CommonUtil.getToast(getDriver());
        Assert.assertEquals("Successfully sent 1 SMS", successToast.getText());
    }

    public void searchSmsSentHistory(String trackingId){
        sendKeys("//textarea[@name='trackingId']",trackingId);
    }

    public void verifySmsHistoryTrackingIdInvalid(String trackingId){
        waitUntilVisibilityOfElementLocated("//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div", LOADING_TIMEOUT_IN_SECONDS);
        WebElement failedToast = CommonUtil.getToast(getDriver());
        Assert.assertEquals("Order with trackingId "+trackingId+" not found!", failedToast.getText());
    }

    public void verifySmsHistoryTrackingIdValid(String trackingId, String contactNumber){
        waitUntilVisibilityOfElementLocated("//md-card[contains(@class,'sms-history')]", LOADING_TIMEOUT_IN_SECONDS);
        //assert that tracking id is equal
        WebElement trackingIdElement = findElementByXpath("//md-card[contains(@class,'sms-history')]/md-card-content/div/span");
        Assert.assertEquals(trackingId, trackingIdElement.getText());

        //check the contact number
        String number=  getTextOnTableWithMdVirtualRepeat(0,"to-number", MD_VIRTUAL_REPEAT);
        Assert.assertEquals(contactNumber, number);

    }






}
