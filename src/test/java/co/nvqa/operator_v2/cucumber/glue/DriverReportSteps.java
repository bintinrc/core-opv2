package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.DriverReportPage;
import co.nvqa.operator_v2.util.TestConstants;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.time.ZonedDateTime;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class DriverReportSteps extends AbstractSteps {

  private DriverReportPage driverReportPage;

  public DriverReportSteps() {
  }

  @Override
  public void init() {
    driverReportPage = new DriverReportPage(getWebDriver());
  }

  @When("Operator set the filter date to current date")
  public void operatorSetTheFilterDateToCurrentDate() {
    ZonedDateTime currentDate = ZonedDateTime.now();
    driverReportPage.setFromDate(currentDate);
    driverReportPage.setToDate(currentDate);
  }

  @When("Operator click \"Generate CSV\" button on Driver Report page")
  public void operatorClickGenerateCsvButtonOnDriverReportPage() {
    driverReportPage.clickButtonGenerateCsv();
  }

  @Then("Operator verify the CSV generated by Driver Report page contains the created route")
  public void operatorVerifyTheCsvGeneratedByDriverReportPageContainsTheCreatedRoute() {
    Long routeId = get(KEY_CREATED_ROUTE_ID, Long.class);
    driverReportPage.verifyTheGeneratedCsvIsCorrect(TestConstants.NINJA_DRIVER_NAME, routeId);
    takesScreenshot();
  }

  @When("Operator click \"Generate Driver Route Excel Report\" button on Driver Report page")
  public void operatorClickGenerateDriverRouteExcelReportButtonOnDriverReportPage() {
    driverReportPage.clickButtonGenerateDriverRouteExcelReport();
  }

  @Then("Operator verify the Excel generated by Driver Report page contains the created route")
  public void operatorVerifyTheExcelGeneratedByDriverReportPageContainsTheCreatedRoute() {
    Long routeId = get(KEY_CREATED_ROUTE_ID);
    driverReportPage.verifyTheGeneratedExcelIsCorrect(TestConstants.NINJA_DRIVER_NAME, routeId);
    takesScreenshot();
  }
}
