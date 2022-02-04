package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.pricing.billing.tempates.Configuration;
import co.nvqa.commons.model.pricing.billing.tempates.Template;
import co.nvqa.operator_v2.selenium.page.SsbTemplatePage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import org.assertj.core.api.Assertions;

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
    Template template = new Template();
    String templateName = mapOfData.get("templateName");
    String templateDescription = mapOfData.get("templateDescription");
    String selectHeaders = mapOfData.get("selectHeaders");

    if (Objects.nonNull(templateName)) {
      ssbTemplatePage.setTemplateName(templateName);
      template.setName(templateName);
    }
    if (Objects.nonNull(templateDescription)) {
      ssbTemplatePage.setTemplateDescription(templateDescription);
      template.setDescription(templateDescription);
    }
    if (Objects.nonNull(selectHeaders)) {
      List<String> headerColumnList = Arrays.asList(selectHeaders.split(","));
      headerColumnList.forEach(headerColumn -> ssbTemplatePage.dragAndDropColumn(headerColumn));
      Configuration configuration = new Configuration();
      configuration.setHeaders(headerColumnList);
      template.setConfiguration(configuration);
    }
    template.setReportType("SSB");

    put(KEY_TEMPLATE, template);
  }

  @And("Operator creates SSB template with below data successfully")
  public void operatorCreatesSSBTemplateWithBelowDataSuccessfully(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    setSsbTemplateData(mapOfData);
    ssbTemplatePage.clickSubmitBtn();
    takesScreenshot();
    ssbTemplatePage.waitUntilVisibilityOfNotification("Created Template Successfully.", 5000);
  }

  @And("Operator creates SSB template with below data")
  public void operatorCreatesSSBTemplateWithBelowData(Map<String, String> mapOfData) {
    setSsbTemplateData(mapOfData);
    ssbTemplatePage.clickSubmitBtn();
    takesScreenshot();
  }

  @Then("Operator verifies that error toast is displayed on SSB Template page:")
  public void operatorVerifiesThatErrorToastDisplayedOnSSBTemplatePage(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    ssbTemplatePage.getWebDriver().switchTo().defaultContent();
    if (mapOfData.containsKey("top")) {
      Assertions.assertThat(ssbTemplatePage.toastErrorTopText.getText())
          .as("Error top text is correct")
          .isEqualTo(mapOfData.get("top"));
    }
    if (mapOfData.containsKey("bottom")) {
      Assertions.assertThat(ssbTemplatePage.toastErrorBottomText.getText())
          .as("Error bottom text is correct").contains(mapOfData.get("bottom"));
    }
  }
}
