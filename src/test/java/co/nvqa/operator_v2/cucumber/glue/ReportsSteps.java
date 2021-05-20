package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.DataEntity;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.OrderStatusReportEntry;
import co.nvqa.operator_v2.selenium.page.ReportsPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.io.File;
import java.text.ParseException;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

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
    reportsPage.codReportGenerateReport.clickAndWaitUntilDone();
    pause5s();
  }

  @Then("^Verify the COD reports attachments are sent to the Operator email")
  public void verifyTheCodReportsAttachmentsAreSentToTheOperatorEmail() {
    reportsPage.codReportsAttachment();
  }

  @When("Operator generates order statuses report for created orders on Reports page")
  public void operatorGeneratesOrderStatusesReportForCreatedOrdersOnReportsPage() {
    List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
    File csvFile = reportsPage.createFile(
        f("order_statuses_find_%s.csv", generateDateUniqueString()), trackingIds);
    reportsPage.orderStatusesUploadCsv.setValue(csvFile);
    reportsPage.orderStatusesGenerateReport.clickAndWaitUntilDone();
  }

  @When("Operator verifies order statuses report file contains following data:")
  public void operatorVerifyOrderStatusesReportFile(List<Map<String, String>> data) {
    String fileName = reportsPage.getLatestDownloadedFilename("results.csv");
    reportsPage.verifyFileDownloadedSuccessfully(fileName);
    String pathName = StandardTestConstants.TEMP_DIR + fileName;
    List<OrderStatusReportEntry> actualData = DataEntity
        .fromCsvFile(OrderStatusReportEntry.class, pathName, true);
    List<OrderStatusReportEntry> expectedData = data.stream()
        .map(entry -> new OrderStatusReportEntry(resolveKeyValues(entry)))
        .peek(o -> {
          final List<Order> createdOrders = get(KEY_LIST_OF_CREATED_ORDER);
          final Optional<Order> orderOpt = createdOrders.stream()
              .filter(co -> co.getTrackingId().equalsIgnoreCase(o.getTrackingId()))
              .findFirst();
          if (orderOpt.isPresent()) {
            final String rawDeliveryDate = orderOpt.get().getTransactions().get(1).getEndTime();
            final String formattedDeliveryDate = LocalDate.parse(rawDeliveryDate,DateUtil.ISO8601_LITE_FORMATTER).toString();
            o.setEstimatedDeliveryDate(formattedDeliveryDate);
          }
        })
        .collect(Collectors.toList());
    assertEquals("Number of records in order statses report", data.size(), actualData.size());
    for (int i = 0; i < expectedData.size(); i++) {
      expectedData.get(i).compareWithActual(actualData.get(i));
    }

  }
}
