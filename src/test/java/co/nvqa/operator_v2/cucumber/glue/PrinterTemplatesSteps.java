package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.PrinterTemplatesPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

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

  @When("^Operator select template with name = \"([^\"]*)\" on Printer Templates page$")
  public void operatorSelectTemplateFromCombobox(String templateName) {
    printerTemplatesPage.selectTemplate(templateName);
  }

  @Then("^Operator verifies the selected template is loaded and all needed fields from the template should be shown on the right panel on Printer Templates page$")
  public void operatorVerifiesTheSelectedTemplateIsLoadedAndAllNeededFieldsFromTheTemplateShouldBeShownOnTheRightPanelOnPrinterTemplatePage() {
    printerTemplatesPage.verifyTemplateIsLoadedAndAllNeededFieldsIsShownOnRightPanel();
  }
}
