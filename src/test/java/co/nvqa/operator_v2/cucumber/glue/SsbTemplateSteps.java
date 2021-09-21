package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.pricing.billing.SsbTemplate;
import co.nvqa.operator_v2.selenium.page.SsbTemplatePage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.When;
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
    ssbTemplatePage.clickCreateTemplateBtn();
  }

  @And("SSB Report Template Editor page is loaded")
  public void ssbReportTemplateEditorPageIsLoaded() {
    ssbTemplatePage.waitUntilLoaded();
    ssbTemplatePage.createTemplateHeader.isDisplayed();
  }

  private void setSsbTemplateData(Map<String, String> mapOfData) {
    SsbTemplate ssbTemplate = new SsbTemplate();
    String templateName = mapOfData.get("templateName");
    String templateDescription = mapOfData.get("templateDescription");
    String selectHeaders = mapOfData.get("selectHeaders");

    if (Objects.nonNull(templateName)) {
      ssbTemplatePage.setTemplateName(templateName);
      ssbTemplate.setTemplateName(templateName);
    }
    if (Objects.nonNull(templateDescription)) {
      ssbTemplatePage.setTemplateDescription(templateDescription);
      ssbTemplate.setTemplateDescription(templateDescription);
    }
    if (Objects.nonNull(selectHeaders)) {
      List<String> headerColumnList = Arrays.asList(selectHeaders.split(","));
      headerColumnList.forEach(headerColumn -> ssbTemplatePage.dragAndDropColumn(headerColumn));
    }

    put(KEY_SSB_TEMPLATE, ssbTemplate);
  }

  @And("Operator creates template with below data successfully")
  public void operatorCreatesTemplateWithBelowDataSuccessfully(Map<String, String> mapOfData) {
    setSsbTemplateData(mapOfData);
    ssbTemplatePage.clickSubmitBtn();
    ssbTemplatePage.waitUntilVisibilityOfNotification("Created Template Successfully.", 5000);
  }
}
