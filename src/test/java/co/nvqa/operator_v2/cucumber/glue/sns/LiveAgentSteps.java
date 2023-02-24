package co.nvqa.operator_v2.cucumber.glue.sns;

import co.nvqa.common.utils.RandomUtil;
import co.nvqa.operator_v2.cucumber.glue.AbstractSteps;
import co.nvqa.operator_v2.selenium.page.sns.LiveChatAdminDashboardPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;

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
    String email = "testinguser" + randomString + "@gmail.com";
    page.inFrame(() -> {
      page.createLiveChatAgent(fullName, email);
    });
  }

  @Then("Verify agent added successfully")
  public void verifyAgentAddedSuccessfully() {
    // Write code here that turns the phrase above into concrete actions
    throw new io.cucumber.java.PendingException();
  }
}
