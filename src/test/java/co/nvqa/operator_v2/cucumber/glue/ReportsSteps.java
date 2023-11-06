package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.operator_v2.selenium.page.ReportsPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.time.format.DateTimeParseException;
import java.util.List;

import static co.nvqa.common.utils.StandardTestUtils.generateDateUniqueString;

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

  @When("Operator filter COD Reports by Mode = {string} and Date = {string}")
  public void operatorFilterCodReportByGivenModeAndDate(String mode, String dateAsString) {
    try {
      reportsPage.filterCodReportsBy(mode,
          StandardTestUtils.convertToZonedDateTime(dateAsString, DTF_NORMAL_DATE));
    } catch (DateTimeParseException ex) {
      throw new NvTestRuntimeException("Failed to parse date.", ex);
    }
  }

  @When("Operator generate COD Reports")
  public void operatorGenerateCodReports() {
    reportsPage.codReportGenerateReport.clickAndWaitUntilDone();
    pause5s();
  }

  @Then("Verify the COD reports attachments are sent to the Operator email")
  public void verifyTheCodReportsAttachmentsAreSentToTheOperatorEmail() {
    reportsPage.codReportsAttachment();
  }

  @When("Operator generates order statuses report for created orders on Reports page below:")
  public void operatorGeneratesOrderStatusesReportForCreatedOrdersOnReportsPage(
      List<String> trackingIds) {
    trackingIds = resolveValues(trackingIds);
    File csvFile = reportsPage.createFile(
        f("order_statuses_find_%s.csv", generateDateUniqueString()), trackingIds);
    reportsPage.orderStatusesUploadCsv.setValue(csvFile);
    reportsPage.orderStatusesGenerateReport.clickAndWaitUntilDone();
  }
}
