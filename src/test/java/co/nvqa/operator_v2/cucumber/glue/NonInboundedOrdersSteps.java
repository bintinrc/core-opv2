package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.NonInboundedOrder;
import co.nvqa.operator_v2.selenium.page.NonInboundedOrdersPage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.time.ZonedDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;

import static co.nvqa.common.utils.StandardTestUtils.convertToZonedDateTime;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class NonInboundedOrdersSteps extends AbstractSteps {

  private NonInboundedOrdersPage nonInboundedOrdersPage;

  public NonInboundedOrdersSteps() {
  }

  @Override
  public void init() {
    nonInboundedOrdersPage = new NonInboundedOrdersPage(getWebDriver());
  }

  @When("^Operator select filter and click Load Selection on Non Inbounded Orders page using data below:$")
  public void operatorSelectFilterAndClickLoadSelectionOnNonInboundedOrdersUsingDataBelow(
      Map<String, String> mapOfData) {
    try {
      Map<String, String> mapOfTokens = StandardTestUtils.createDefaultTokens();
      Map<String, String> dataTableAsMapReplaced = StandardTestUtils.replaceDataTableTokens(mapOfData, mapOfTokens);

      String routeDate = dataTableAsMapReplaced.get("routeDate");
      ZonedDateTime fromDate = null;

      if (StringUtils.isNotBlank(routeDate)) {
        fromDate = convertToZonedDateTime(routeDate, DTF_NORMAL_DATE);
      }

      String shipperName = dataTableAsMapReplaced.get("shipperName");
      nonInboundedOrdersPage.filterAndLoadSelection(fromDate, shipperName);
    } catch (DateTimeParseException ex) {
      throw new NvTestRuntimeException("Failed to parse date.", ex);
    }
  }

  @Then("^Operator verify following parameters of the created order on Non Inbounded Orders page:$")
  public void operatorVerifyFollowingParametersOfTheCreatedOrderOnNonInboundedOrdersPage(
      Map<String, String> mapOfData) {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    NonInboundedOrder expectedOrderDetails = new NonInboundedOrder();
    expectedOrderDetails.fromMap(mapOfData);
    nonInboundedOrdersPage.verifyOrderDetails(trackingId, expectedOrderDetails);
  }

  @Then("^Operator verify the created order is NOT found on Non Inbounded Orders page$")
  public void operatorVerifyTheCreatedOrderIsNOTFoundOnNonInboundedOrdersPage() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    checkOrderIsNotFound(trackingId);
  }

  @When("^Operator cancel created orders Non Inbounded Orders page$")
  public void operatorCancelCreatedOrdersNonInboundedOrdersPage() {
    List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
    nonInboundedOrdersPage.cancelOrders(trackingIds);
  }

  @Then("^Operator verify created orders are NOT found on Non Inbounded Orders page$")
  public void operatorVerifyCreatedOrdersAreNOTFoundOnNonInboundedOrdersPage() {
    List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
    trackingIds.forEach(this::checkOrderIsNotFound);
  }

  private void checkOrderIsNotFound(String trackingId) {
    nonInboundedOrdersPage
        .filterBy(NonInboundedOrdersPage.OrdersTable.COLUMN_TRACKING_ID, trackingId);
    Assertions.assertThat(nonInboundedOrdersPage.ordersTable().isTableEmpty())
        .as("Filtered Orders page is empty").isTrue();
  }

  @When("^Operator download CSV file for created orders on Non Inbounded Orders page$")
  public void operatorDownloadCSVFileForCreatedOrdersOnNonInboundedOrdersPage() {
    List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
    nonInboundedOrdersPage.dowloadCsvFile(trackingIds);
  }

  @Then("^Operator verify the CSV of selected Non Inbounded Orders is downloaded successfully and contains correct info$")
  public void operatorVerifyTheCSVOfSelectedNonInboundedOrdersIsDownloadedSuccessfullyAndContainsCorrectInfo() {
    List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
    nonInboundedOrdersPage.verifyDownloadedCsvFileContent(trackingIds);
  }
}
