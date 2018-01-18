package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.SmsCampaignCsv;
import co.nvqa.operator_v2.selenium.page.MessagingModulePage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author Rizaq Pratama
 */
@ScenarioScoped
public class MessagingModuleSteps extends AbstractSteps
{
    private MessagingModulePage messagingModulePage;

    @Inject
    public MessagingModuleSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        messagingModulePage = new MessagingModulePage(getWebDriver());
    }

    @Then("^op upload sms campaign csv file$")
    public void uploadSmsCampaignCsv(List<SmsCampaignCsv> data)
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);

        if(trackingId!=null)
        {
            data = data.stream().map(smsCampaignCsv ->
            {
                if("_created_".equalsIgnoreCase(smsCampaignCsv.getTracking_id()))
                {
                    smsCampaignCsv.setTracking_id(trackingId);
                }
                return smsCampaignCsv;
            }).collect(Collectors.toList());
        }

        messagingModulePage.uploadCsvCampaignFile(data);
    }

    @When("^op continue on invalid dialog$")
    public void onPartialErrorContinue()
    {
        messagingModulePage.continueOnCsvUploadFailure();
    }

    @Then("^op verify sms module page resetted$")
    public void onSmsModulePageResetted()
    {
        messagingModulePage.verifyThatPageReset();
    }

    @When("^op compose sms with data : ([^\"]*), ([^\"]*)$")
    public void composeSms(String name, String trackingId)
    {
        String createdTrackingId = get(KEY_CREATED_ORDER_TRACKING_ID);

        if(createdTrackingId!=null)
        {
            if("_created_".equalsIgnoreCase(trackingId))
            {
                trackingId = createdTrackingId;
            }
        }

        messagingModulePage.composeSms(name, trackingId);
    }

    @Then("^op compose sms using url shortener$")
    public void composeSmsWithUrlShortener()
    {
        messagingModulePage.composeSmsWithUrlShortener();
    }

    @Then("^op verify sms preview using shortened url$")
    public void verifyPreviewUsingShortenedUrl()
    {
        messagingModulePage.verifyThatPreviewUsingShortenedUrl();
    }

    @When("^op send sms$")
    public void sendSms()
    {
        messagingModulePage.sendSms();
    }

    @Then("^op wait for sms to be processed$")
    public void waitForSmsToBeProcessed()
    {
        messagingModulePage.waitForSmsToBeProcessed();
    }

    @When("^op search sms sent history for tracking id ([^\"]*)$")
    public void searchHistory(String trackingId)
    {
        messagingModulePage.searchSmsSentHistory(trackingId);
    }

    @Then("^op verify that tracking id ([^\"]*) is invalid$")
    public void verifyOnTrackingIdInvalid(String trackingId)
    {
        messagingModulePage.searchSmsSentHistory(trackingId);
        messagingModulePage.verifySmsHistoryTrackingIdInvalid(trackingId);
    }

    @Then("^op verify that sms sent to phone number ([^\"]*) and tracking id ([^\"]*)$")
    public void verifyOnTrackingIdValid(String trackingId, String contactNumber)
    {
        String createdTrackingId = get(KEY_CREATED_ORDER_TRACKING_ID);

        if(createdTrackingId!=null && "_created_".equalsIgnoreCase(trackingId))
        {
            trackingId = createdTrackingId;
        }

        messagingModulePage.searchSmsSentHistory(trackingId);
        messagingModulePage.verifySmsHistoryTrackingIdValid(trackingId, contactNumber);
    }
}
