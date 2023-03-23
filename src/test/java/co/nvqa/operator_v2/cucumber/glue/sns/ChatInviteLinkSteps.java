package co.nvqa.operator_v2.cucumber.glue.sns;

import co.nvqa.operator_v2.cucumber.glue.AbstractSteps;
import co.nvqa.operator_v2.selenium.page.sns.ChatInviteLinkPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import org.assertj.core.api.Assertions;

@ScenarioScoped
public class ChatInviteLinkSteps extends AbstractSteps {
    public ChatInviteLinkPage chatInviteLinkPage;

    @Override
    public void init() {
        this.chatInviteLinkPage = new ChatInviteLinkPage(getWebDriver());
    }

    @And("Operator generate link for shipper using {string}")
    public void operatorGeneratorLinkForShipperUsingShipperLegacyId(String shipperLegacyId) {
        chatInviteLinkPage.inFrame(() -> {
            String LegacyId = resolveValue(shipperLegacyId);
            chatInviteLinkPage.operatorGeneratorLinkForShipperUsingShipperLegacyId(LegacyId);
        });
    }

    @Then("Verify shipper name {string} and contact {string} on chat invite link page")
    public void verifyShipperDetailsOnChatInviteLinkPage(String shipperName, String shipperContact) {
        chatInviteLinkPage.inFrame(() -> {
            String name = resolveValue(shipperName);
            String shipperPhoneNumber = resolveValue(shipperContact);
            chatInviteLinkPage.verifyShipperNameAndPhoneNumber(name, shipperPhoneNumber);
        });
    }

    @Then("Operator gets generated chat invite link")
    public void verifyGeneratedChatInviteLinkFor() {
        chatInviteLinkPage.inFrame(() -> {
            String generatedLink = chatInviteLinkPage.getGeneratedInviteLink();
            put(KEY_SNS_CHAT_INVITE_LINK, "https://" + generatedLink);
        });
    }

    @Then("Verify user is redirected to {string} page")
    public void waitUntilLoaded(String pageName) {
        chatInviteLinkPage.ninjaChatPage.waitUntilVisible();
        String currentUrl = chatInviteLinkPage.ninjaChatPage.getCurrentUrl();
        Assertions.assertThat(currentUrl).as("Verify page redirection").contains(pageName);
    }

    @And("Operator generate link for consignee using phone number {string}")
    public void operatorGeneratorLinkForConsigneeUsingPhoneNumber(String phoneNumber) {
        chatInviteLinkPage.inFrame(() -> {
            chatInviteLinkPage.operatorGeneratorLinkForConsigneeUsingPhoneNumber(phoneNumber);
        });
    }
}
