package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.PrinterTemplatesPage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class PrinterTemplatesSteps extends AbstractSteps {

  private PrinterTemplatesPage printerTemplatesPage;

  public PrinterTemplatesSteps() {
  }

  @Override
  public void init() {
    printerTemplatesPage = new PrinterTemplatesPage(getWebDriver());
  }

  @When("Operator select template with name = {string} on Printer Templates page")
  public void operatorSelectTemplateFromCombobox(String templateName) {
    printerTemplatesPage.selectTemplate(templateName);
  }

  @Then("Operator verifies the selected template is loaded and all needed fields from the template should be shown on the right panel on Printer Templates page")
  public void operatorVerifiesTheSelectedTemplateIsLoadedAndAllNeededFieldsFromTheTemplateShouldBeShownOnTheRightPanelOnPrinterTemplatePage() {
    printerTemplatesPage.verifyTemplateIsLoadedAndAllNeededFieldsIsShownOnRightPanel();
  }
}
