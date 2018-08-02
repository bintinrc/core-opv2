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

    @Then("^Operator upload SMS campaign CSV file$")
    public void uploadSmsCampaignCsv(List<SmsCampaignCsv> data)
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);

        if(trackingId!=null)
        {
            data = data.stream().peek(smsCampaignCsv ->
            {
                if("GET_FROM_CREATED_ORDER".equalsIgnoreCase(smsCampaignCsv.getTracking_id()))
                {
                    smsCampaignCsv.setTracking_id(trackingId);
                }
            }).collect(Collectors.toList());
        }

        messagingModulePage.uploadCsvCampaignFile(data);
    }

    @When("^Operator continue on invalid dialog$")
    public void onPartialErrorContinue()
    {
        messagingModulePage.continueOnCsvUploadFailure();
    }

    @Then("^Operator verify sms module page reset$")
    public void onSmsModulePageReset()
    {
        messagingModulePage.verifyThatPageReset();
    }

    @When("^Operator compose SMS with name = \"([^\"]*)\" and tracking ID = \"([^\"]*)\"$")
    public void composeSms(String name, String trackingId)
    {
        String createdTrackingId = get(KEY_CREATED_ORDER_TRACKING_ID);

        if(createdTrackingId!=null)
        {
            if("GET_FROM_CREATED_ORDER".equalsIgnoreCase(trackingId))
            {
                trackingId = createdTrackingId;
            }
        }

        messagingModulePage.composeSms(name, trackingId);
    }

    @Then("^Operator compose SMS using URL shortener$")
    public void composeSmsWithUrlShortener()
    {
        messagingModulePage.composeSmsWithUrlShortener();
    }

    @Then("^Operator verify SMS preview using shortened URL$")
    public void verifyPreviewUsingShortenedUrl()
    {
        messagingModulePage.verifyThatPreviewUsingShortenedUrl();
    }

    @When("^Operator send SMS$")
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

    @Then("^Operator verify that tracking ID \"([^\"]*)\" is invalid$")
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
