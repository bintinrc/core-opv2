package co.nvqa.operator_v2.cucumber.glue.sns;

import co.nvqa.operator_v2.cucumber.glue.AbstractSteps;
import co.nvqa.operator_v2.selenium.page.sns.NotificationsManagementPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;

@ScenarioScoped
public class NotificationsManagementSteps extends AbstractSteps {
  public NotificationsManagementPage notificationsManagementPage;

  @Override
  public void init() {
    notificationsManagementPage = new NotificationsManagementPage(getWebDriver());
  }

  @Then("Operator searches and verifies the template id {string}")
  public void operatorSearchesTheTemplateId(String templateId) {
    notificationsManagementPage.waitWhilePageIsLoading();
    notificationsManagementPage.switchTo();
    String templateName;
    if (templateId.equalsIgnoreCase("10")) {
      templateName = "Failed Delivery";
    } else if (templateId.equalsIgnoreCase("98765432")) {
      templateName = "Updated Test";
      templateId = "9876543";
    } else {
      templateName = "Test";
    }
   notificationsManagementPage.verifyTemplateIdAndName(templateId, templateName);
  }
}
