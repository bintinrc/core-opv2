package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.page.ReportsPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.text.ParseException;

/**
 * @author Niko Susanto
 */
@ScenarioScoped
public class ReportsSteps extends AbstractSteps {

  private ReportsPage reportsPage;

  public ReportsSteps() {
  }

  @Override
  public void init() {
    reportsPage = new ReportsPage(getWebDriver());
  }

  @When("^Operator filter COD Reports by Mode = \"([^\"]*)\" and Date = \"([^\"]*)\"$")
  public void operatorFilterCodReportByGivenModeAndDate(String mode, String dateAsString) {
    try {
      reportsPage.filterCodReportsBy(mode, YYYY_MM_DD_SDF.parse(dateAsString));
    } catch (ParseException ex) {
      throw new NvTestRuntimeException("Failed to parse date.", ex);
    }
  }

  @When("^Operator generate COD Reports")
  public void operatorGenerateCodReports() {
    reportsPage.generateCodReports();
  }

  @Then("^Verify the COD reports attachments are sent to the Operator email")
  public void verifyTheCodReportsAttachmentsAreSentToTheOperatorEmail() {
    reportsPage.codReportsAttachment();
  }
}
