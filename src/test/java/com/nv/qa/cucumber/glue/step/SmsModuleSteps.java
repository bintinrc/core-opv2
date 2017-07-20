package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.model.SmsCampaignCsv;
import com.nv.qa.selenium.page.SmsModulePage;
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

    @When("^op upload sms campaign csv file")
    public void uploadSmsCampaignCsv(List<SmsCampaignCsv> data){
        smsModulePage.uploadCsvCampaignFile(data);
    }

    @When("^some csv are invalid")
    public void onPartialErrorContinue(){
        smsModulePage.continueOnCsvUploadFailure();
    }

    @When("^op compose sms")
    public void composeSms(){
        smsModulePage.composeSms();
    }

    @When("^op send sms")
    public void sendSms(){
        smsModulePage.sendSms();
    }
}
