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

import static co.nvqa.common.utils.StandardTestConstants.NV_SYSTEM_ID;

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
    Assertions.assertThat(ssbTemplatePage.createTemplateHeader.isDisplayed())
        .as("Available Headers (scroll down to see more) is visible").isTrue();
    if (!ssbTemplatePage.isLegacyIdHeaderColumnAvailable()) {
      ssbTemplatePage.clickGoBackBtn();
      ssbTemplatePage.clickCreateTemplateBtn();
      ssbTemplatePage.waitUntilLoaded();
    }
    Assertions.assertThat(ssbTemplatePage.isLegacyIdHeaderColumnAvailable())
        .as("Legacy Id is visible").isTrue();
  }

  private void setSsbTemplateData(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    Template template = Objects.nonNull(get(KEY_TEMPLATE)) ? get(KEY_TEMPLATE) : new Template();

    String templateName = mapOfData.get("templateName");
    String templateDescription = mapOfData.get("templateDescription");
    String selectHeaders = mapOfData.get("selectHeaders");
    String removeHeaders = mapOfData.get("removeHeaders");

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
      headerColumnList.forEach(
          headerColumn -> ssbTemplatePage.dragAndDropColumnToSelectedHeadersColumn(headerColumn));
      Configuration configuration = new Configuration();
      configuration.setHeaders(headerColumnList);
      template.setConfiguration(configuration);
    }
    if (Objects.nonNull(removeHeaders)) {
      List<String> headerColumnList = Arrays.asList(removeHeaders.split(","));
      headerColumnList.forEach(
          headerColumn -> ssbTemplatePage.dragAndDropToAvailableHeadersColumn(headerColumn));
      Configuration configuration = new Configuration();
      configuration.setHeaders(headerColumnList);
      template.setConfiguration(configuration);
    }
    template.setReportType("SSB");
    template.setSystemId(NV_SYSTEM_ID);

    put(KEY_TEMPLATE, template);
  }

  @And("Operator creates SSB template with below data successfully")
  public void operatorCreatesSSBTemplateWithBelowDataSuccessfully(Map<String, String> mapOfData) {
    operatorFillSSBTemplateWithBelowData(mapOfData);
    ssbTemplatePage.waitUntilVisibilityOfNotification("Created Template Successfully.", 5000);
  }

  @And("Operator updates SSB template with below data successfully")
  public void operatorUpdatedSSBTemplateWithBelowDataSuccessfully(Map<String, String> mapOfData) {
    operatorFillSSBTemplateWithBelowData(mapOfData);
    ssbTemplatePage.waitUntilVisibilityOfNotification("Updated Template Successfully.", 5000);
  }

  @And("Operator updates SSB template with below data")
  @And("Operator creates SSB template with below data")
  public void operatorFillSSBTemplateWithBelowData(Map<String, String> mapOfData) {
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

  @Then("Operator edits SSB Template with Name {value}")
  public void operatorEditsSSBTemplateWithName(String name) {
    ssbTemplatePage.selectAndEditSsbTemplate(name);
  }

  @Then("Operator deletes the SSB template {value}")
  public void operatorDeletesTheSSBTemplate(String name) {
    ssbTemplatePage.selectAndDeleteSsbTemplate(name);
  }

}
