package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.model.SmsCampaignCsv;
import com.nv.qa.selenium.page.SmsModulePage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

import java.util.List;

/**
 * Created by rizaqpratama on 7/19/17.
 */
public class SmsModuleSteps extends AbstractSteps
{

    private SmsModulePage smsModulePage;
    @Override
    public void init() {
        smsModulePage = new SmsModulePage(getDriver());
    }

    @Inject
    public SmsModuleSteps(CommonScenario commonScenario){
        super(commonScenario);
    }

    @Then("^op upload sms campaign csv file")
    public void uploadSmsCampaignCsv(List<SmsCampaignCsv> data){
        smsModulePage.uploadCsvCampaignFile(data);
    }

    @When("^op continue on invalid dialog")
    public void onPartialErrorContinue(){
        smsModulePage.continueOnCsvUploadFailure();
    }

    @Then("^op verify sms module page resetted")
    public void onSmsModulePageResetted(){
        smsModulePage.verifyThatPageReset();
    }

    @When("^op compose sms with data : ([^\"]*), ([^\"]*)")
    public void composeSms(String name, String trackingId){
        smsModulePage.composeSms(name, trackingId);
    }

    @Then("^op compose sms with url shortener")
    public void composeSmsWithUrlShortener(){
        smsModulePage.composeSmsWithUrlShortener();
    }

    @When("^op send sms")
    public void sendSms(){
        smsModulePage.sendSms();
    }

    @Then("^op wait for sms to be processed")
    public void waitForSmsToBeProcessed(){
        smsModulePage.waitForSmsToBeProcessed();
    }

    @When("^op search sms sent history for tracking id ([^\"]*)$")
    public void searchHistory(String trackingId){
        smsModulePage.searchSmsSentHistory(trackingId);
    }

    @Then("^op verify that tracking id ([^\"]*) is invalid")
    public void verifyOnTrackingIdInvalid(String trackingId){
        smsModulePage.searchSmsSentHistory(trackingId);
        smsModulePage.verifySmsHistoryTrackingIdInvalid(trackingId);
    }

    @Then("^op verify that sms sent to phone number ([^\"]*) and tracking id ([^\"]*)")
    public void verifyOnTrackingIdValid(String trackingId, String contactNumber){
        smsModulePage.searchSmsSentHistory(trackingId);
        smsModulePage.verifySmsHistoryTrackingIdValid(trackingId, contactNumber);
    }
}
