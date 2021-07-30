package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.SsbTemplatePage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.When;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Objects;

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
    ssbTemplatePage.waitUntilLoaded();
    ssbTemplatePage.createTemplateHeader.isDisplayed();
  }

  @And("Operator created template with below data")
  public void operatorCreatedTemplateWithBelowData(Map<String, String> mapOfData) {
    String templateName = mapOfData.get("templateName");
    String templateDescription = mapOfData.get("templateDescription");
    String selectHeaders = mapOfData.get("selectHeaders");

    if (Objects.nonNull(templateName)) {
      ssbTemplatePage.setTemplateName(templateName);
      ssbTemplatePage.setTemplateDescription(templateDescription);
    }
    if (Objects.nonNull(selectHeaders)) {
      List<String> headerColumnList = Arrays.asList(selectHeaders.split(","));
      headerColumnList.forEach(headerColumn -> ssbTemplatePage.dragAndDropColumn(headerColumn));
//      ssbTemplatePage.dragAndDropColumn("Legacy Shipper ID");
    }
  }
}
