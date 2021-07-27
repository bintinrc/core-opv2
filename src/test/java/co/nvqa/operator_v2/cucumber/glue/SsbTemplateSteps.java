package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.SsbTemplatePage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.When;

public class SsbTemplateSteps extends AbstractSteps {

  private SsbTemplatePage ssbTemplatePage;

  public SsbTemplateSteps() {
  }

  @Override
  public void init() {
    ssbTemplatePage = new SsbTemplatePage(getWebDriver());
  }

  @When("SSB Template page is loaded")
  public void movementManagementPageIsLoaded() {
    ssbTemplatePage.switchTo();
    ssbTemplatePage.waitUntilLoaded();
  }

  @And("Operator clicks Create Template button")
  public void operatorClicksCreateTemplateButton() {
    ssbTemplatePage.createNewTemplateBtn.click();
  }

  @And("SSB Report Template Editor page is loaded")
  public void ssbReportTemplateEditorPageIsLoaded() {
    ssbTemplatePage.switchTo();
  }
}
