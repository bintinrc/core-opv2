package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.model.SmsCampaignCsv;
import com.nv.qa.selenium.page.SmsModulePage;
import com.nv.qa.support.ScenarioStorage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

import java.util.List;
import java.util.stream.Collectors;

import com.nv.qa.model.order_creation.v2.Order;

/**
 * Created by rizaqpratama on 7/19/17.
 */
public class SmsModuleSteps extends AbstractSteps
{

    private SmsModulePage smsModulePage;
    private final ScenarioStorage scenarioStorage;
    @Override
    public void init() {
        smsModulePage = new SmsModulePage(getDriver());
    }

    @Inject
    public SmsModuleSteps(CommonScenario commonScenario, ScenarioStorage scenarioStorage){
        super(commonScenario);
        this.scenarioStorage = scenarioStorage;
    }

    @Then("^op upload sms campaign csv file")
    public void uploadSmsCampaignCsv(List<SmsCampaignCsv> data){
        Order order = scenarioStorage.get("order");
        if(order != null ){
            String trackingId = order.getTracking_id();
            data = data.stream().map(smsCampaignCsv -> {
                if(smsCampaignCsv.getTracking_id().equalsIgnoreCase("_created_")){
                    smsCampaignCsv.setTracking_id(trackingId);
                }
                return smsCampaignCsv;
            }).collect(Collectors.toList());
        }

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
        Order order = scenarioStorage.get("order");
        if(order != null){
            String nTrackingId = order.getTracking_id();
            if(trackingId.equalsIgnoreCase("_created_")){
                trackingId = nTrackingId;
            }
        }
        smsModulePage.composeSms(name, trackingId);
    }

    @Then("^op compose sms using url shortener")
    public void composeSmsWithUrlShortener(){
        smsModulePage.composeSmsWithUrlShortener();
    }

    @Then("^op verify sms preview using shortened url")
    public void verifyPreviewUsingShortenedUrl(){
        smsModulePage.verifyThatPreviewUsingShortenedUrl();
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
        Order order = scenarioStorage.get("order");
        if(order != null && trackingId.equalsIgnoreCase("_created_")){
            trackingId = order.getTracking_id();
        }
        smsModulePage.searchSmsSentHistory(trackingId);
        smsModulePage.verifySmsHistoryTrackingIdValid(trackingId, contactNumber);
    }
}
