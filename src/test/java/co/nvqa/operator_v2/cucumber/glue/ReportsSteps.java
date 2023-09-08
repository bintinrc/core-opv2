package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.model.order.Order;
import co.nvqa.common.core.utils.CoreScenarioStorageKeys;
import co.nvqa.common.model.DataEntity;
import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.model.OrderStatusReportEntry;
import co.nvqa.operator_v2.selenium.page.ReportsPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;

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
  public void operatorGeneratesOrderStatusesReportForCreatedOrdersOnReportsPage(List<String> trackingIds) {
    trackingIds = resolveValues(trackingIds);
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
          final List<Order> createdOrders = get(CoreScenarioStorageKeys.KEY_LIST_OF_CREATED_ORDERS);
          final Optional<Order> orderOpt = createdOrders.stream()
              .filter(co -> co.getTrackingId().equalsIgnoreCase(o.getTrackingId()))
              .findFirst();
          if (orderOpt.isPresent()) {
            final String rawDeliveryDate = orderOpt.get().getTransactions().get(1).getEndTime();
            final String formattedDeliveryDate = LocalDate.parse(rawDeliveryDate,
                DateUtil.ISO8601_LITE_FORMATTER).toString();
            o.setEstimatedDeliveryDate(formattedDeliveryDate);
          }
        })
        .collect(Collectors.toList());
    Assertions.assertThat(actualData).as("Number of records in order status report")
        .hasSameSizeAs(data);
    for (int i = 0; i < expectedData.size(); i++) {
      expectedData.get(i).compareWithActual(actualData.get(i));
    }

  }
}
