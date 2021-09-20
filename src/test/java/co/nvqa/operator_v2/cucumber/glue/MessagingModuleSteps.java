package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.SmsCampaignCsv;
import co.nvqa.operator_v2.selenium.page.MessagingModulePage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @author Rizaq Pratama
 */
@ScenarioScoped
public class MessagingModuleSteps extends AbstractSteps {

  private MessagingModulePage messagingModulePage;

  public MessagingModuleSteps() {
  }

  @Override
  public void init() {
    messagingModulePage = new MessagingModulePage(getWebDriver());
  }

  @Then("^Operator upload SMS campaign CSV file:$")
  public void uploadSmsCampaignCsv(List<Map<String, String>> data) {
    List<SmsCampaignCsv> smsCampaignList = data.stream()
        .map(val -> new SmsCampaignCsv(resolveKeyValues(val))).collect(Collectors.toList());

    File file = messagingModulePage.createSmsCampaignCsv(smsCampaignList);
    messagingModulePage.uploadFle.setValue(file);
  }

  @When("^Operator continue on invalid dialog$")
  public void onPartialErrorContinue() {
    messagingModulePage.csvValidationErrorsDialog.waitUntilVisible();
    messagingModulePage.csvValidationErrorsDialog.continueBtn.click();
    messagingModulePage.csvValidationErrorsDialog.waitUntilInvisible();
  }

  @Then("^Operator verify sms module page reset$")
  public void onSmsModulePageReset() {
    assertFalse("Compose Message card displayed",
        messagingModulePage.composeMessageCard.isDisplayedFast());
  }

  @When("^Operator compose SMS with name = \"([^\"]*)\" and tracking ID = \"([^\"]*)\"$")
  public void composeSms(String name, String trackingId) {
    messagingModulePage.composeSms(resolveValue(name), resolveValue(trackingId));
  }

  @Then("^Operator compose SMS using URL shortener$")
  public void composeSmsWithUrlShortener() {
    messagingModulePage.composeSmsWithUrlShortener();
  }

  @Then("^Operator verify SMS preview using shortened URL$")
  public void verifyPreviewUsingShortenedUrl() {
    messagingModulePage.verifyThatPreviewUsingShortenedUrl();
  }

  @When("^Operator send SMS$")
  public void sendSms() {
    messagingModulePage.composeMessageCard.sendMessages.clickAndWaitUntilDone();
    messagingModulePage.waitUntilInvisibilityOfToast("Successfully sent 1 SMS", true);
  }

  @Then("^Operator wait for sms to be processed$")
  public void waitForSmsToBeProcessed() {
    pause10s();
  }

  @Then("Operator verify that tracking ID {string} is invalid")
  public void verifyOnTrackingIdInvalid(String trackingId) {
    trackingId = resolveValue(trackingId);
    messagingModulePage.searchSmsSentHistory(trackingId);
    messagingModulePage
        .waitUntilInvisibilityOfToast("Order with trackingId " + trackingId + " not found!", true);
  }

  @Then("Operator verify that sms sent to phone number {string} and tracking id {string}")
  public void verifyOnTrackingIdValid(String contactNumber, String trackingId) {
    trackingId = resolveValue(trackingId);
    contactNumber = resolveValue(contactNumber);
    messagingModulePage.searchSmsSentHistory(trackingId);
    messagingModulePage.verifySmsHistoryTrackingIdValid(trackingId, contactNumber);
  }
}