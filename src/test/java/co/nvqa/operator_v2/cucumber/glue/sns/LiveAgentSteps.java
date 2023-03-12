package co.nvqa.operator_v2.cucumber.glue.sns;

import co.nvqa.common.utils.RandomUtil;
import co.nvqa.operator_v2.cucumber.glue.AbstractSteps;
import co.nvqa.operator_v2.selenium.page.sns.LiveChatAdminDashboardPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import java.util.Map;
import java.util.Objects;

import org.assertj.core.api.Assertions;


@ScenarioScoped
public class LiveAgentSteps extends AbstractSteps {

    LiveChatAdminDashboardPage page;

    @Override
    public void init() {
        page = new LiveChatAdminDashboardPage(getWebDriver());
    }

    @Then("Create live agent with email and username")
    public void createLiveAgentWithEmailAndUsername() {
        String randomString = RandomUtil.randomString(5);
        String fullName = "testing user " + randomString;
        String email = "testuser" + randomString + "@gmail.com";
        page.inFrame(() -> {
            page.createLiveChatAgent(fullName, email);
        });
    }

    @Then("Verify agent added successfully")
    public void verifyAgentAddedSuccessfully() {
        page.inFrame(() -> {
            page.verifyLiveAgentAddedSuccessfully();
        });
    }

    @Then("Update live agent with email and username")
    public void updateLiveAgent() {
        String randomString = RandomUtil.randomString(5);
        String fullName = "testing user " + randomString;
        page.inFrame(() -> {
            page.updateLiveChatAgent(fullName, null);
        });
    }

    @Then("Delete live agent")
    public void deleteLiveAgent() {
        page.inFrame(() -> {
            page.deleteCreatedLiveChatAgent();
        });
    }

    @Then("Verify agent deleted successfully")
    public void verifyAgentDeletedSuccessfully() {
        page.inFrame(() -> {
            page.verifyLiveAgentDeletedSuccessfully();
        });
    }

    @Then("Verify agent list is visible")
    public void verifyAgentListIsVisible() {
        page.inFrame(() -> {
            page.waitUntilLoaded();
            page.agents.get(0).verifyAgentListIsVisible();
        });
    }

    @When("Open holidays popup")
    public void openHolidaysPopup() {
        page.inFrame(() -> {
            page.update.waitUntilVisible();
            page.update.click();
        });
    }

    @Then("Verify operating hour modal")
    public void verifyOperatingHourModal() {
        page.inFrame(() -> {
            page.operatingHourModal.verifyOperatingHourModal();
        });
    }

    @When("Save operating hour modal and verify modal closes")
    public void saveOperatingHourModal(Map<String, String> data) {
        page.inFrame(() -> {
            pause5s();
            page.operatingHourModal.save.click();
            // page.operatingHourModal.notification.message.waitUntilVisible();
            String header = page.notification.message.getAttribute("innerText");
            Assertions.assertThat(header)
                    .as("show correct header message :" + data.get("top"))
                    .isEqualTo(data.get("top"));
        });
    }

    @And("Goto {string} section")
    public void gotoSection(String sectionName) {
        page.inFrame(() -> {
            page.waitUntilLoaded();
            page.searchShipperSupport.forceClear();
            page.searchInputFields.forceClear();
            page.elementIndexForLiveAgentPage = sectionName.contains("Customer") ? 0 : 1;
            page.click(f(page.sectionTab,
                    sectionName));
        });
    }

    @Then("Delete live agent with name {string}")
    public void deleteLiveAgentWithName(String fullName) {
        page.inFrame(() -> {
            page.deleteLiveChatAgentWithName(fullName);
        });
    }

    @Then("Verify agent deleted successfully with name {string}")
    public void verifyAgentDeletedSuccessfully(String fullName) {
        page.inFrame(() -> {
            page.verifyLiveAgentDeletedSuccessfullyWithName(fullName);
        });
    }

    @Then("Create live agent with email and username with below data:")
    public void createLiveAgent(Map<String, String> mapOfData) {
        String randomString = RandomUtil.randomString(5);
        String fullName = Objects.isNull(mapOfData.get("fullName")) ? ("testing user " + randomString)
                : mapOfData.get("fullName");
        String email =
                Objects.isNull(mapOfData.get("email")) ? ("testinguser" + randomString + "@gmail.com")
                        : mapOfData.get("email");
        page.inFrame(() -> {
            page.createLiveChatAgent(fullName, email);
        });
    }
}

