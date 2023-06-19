package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.util.NvCountry;
import co.nvqa.operator_v2.selenium.page.StationCODReportPage;
import io.cucumber.datatable.DataTable;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;
import org.assertj.core.api.Assertions;
import org.junit.Assert;

import static co.nvqa.common.utils.StandardTestConstants.NV_SYSTEM_ID;

/**
 * @author Veera N
 */

@SuppressWarnings("unused")
@ScenarioScoped
public class StationCODReportSteps extends AbstractSteps {

  private StationCODReportPage stationCODReportPage;

  public StationCODReportSteps() {
  }

  @Override
  public void init() {
    stationCODReportPage = new StationCODReportPage(getWebDriver());
  }

  @Then("Operator verifies that the following UI elements are displayed in station cod report page")
  public void operator_verifies_that_the_following_UI_elements_are_displayed_in_station_cod_report_page(
      DataTable fields) {
    List<String> labels = fields.asList();
    for (String label : labels) {
      stationCODReportPage.verifyFieldInCODReport(label);
    }
    takesScreenshot();
  }

  @Then("Operator verifies that the following buttons are displayed in disabled state")
  public void operator_verifies_that_the_following_buttons_are_displayed_in_disabled_state(
      DataTable buttonNames) {
    List<String> buttons = buttonNames.asList();
    for (String button : buttons) {
      stationCODReportPage.verifyButtonDisplayedInDisabledState(button);
    }
    takesScreenshot();
  }

  @When("Operator chooses start and end date on transaction end date using the following data:")
  public void operator_chooses_start_and_end_date_on_transaction_end_date_using_the_following_data(
      Map<String, String> transEndDate) {
    transEndDate = resolveKeyValues(transEndDate);
    String shipperCreationDateFrom = transEndDate.get("transactionEndDateFrom");
    String shipperCreationDateTo = transEndDate.get("transactionEndDateTo");
    stationCODReportPage.setTransactionEndDateFilter(shipperCreationDateFrom,
        shipperCreationDateTo);
  }

  @When("Operator searches for station cod report by applying following filters:")
  public void operator_searches_for_station_cod_report_by_applying_following_filters(
      DataTable searchParam) {
    pause2s();
    List<Map<String, String>> filters = searchParam.asMaps(String.class, String.class);
    for (Map<String, String> filter : filters) {
      Map<String, String> resolvedFilter = resolveKeyValues(filters.get(0));
      stationCODReportPage.applyFilters(resolvedFilter);
    }
  }

  @Then("Operator verifies that tabs - Details and Summary are displayed after the search")
  public void operator_verifies_that_tabs_Details_and_Summary_are_displayed_after_the_search() {
    stationCODReportPage.verifyDetailsAndSummaryTabsDisplayed();
    takesScreenshot();
  }

  @Then("Operator verifies that the following columns are displayed under {string} tab")
  public void operator_verifies_that_the_following_columns_are_displayed_under_tab(String tabName,
      DataTable columns) {
    List<String> columnNames = columns.asList();
    stationCODReportPage.verifyColumnsInTableDisplayed(tabName, columnNames);
    takesScreenshot();
  }

  @When("Operator navigates to summary tab in the result grid")
  public void operator_navigates_to_summary_tab_in_the_result_grid() {
    stationCODReportPage.navigateToSummaryTab();
  }

  @When("Operator searches for the details in result grid using the following search criteria:")
  public void operator_searches_for_the_details_in_result_grid_using_the_following_search_criteria(
      Map<String, String> filters) {
    Map<String, String> resolvedFilters = resolveKeyValues(filters);
    stationCODReportPage.applyFiltersInResultGrid(resolvedFilters);
  }

  @When("Operator gets the order details from details tab of station cod report")
  public void operator_gets_the_order_details_from_details_tab_of_station_cod_report() {
    Map<String, String> results = stationCODReportPage.getResultGridContent();
    put(KEY_STATION_COD_REPORT_DETAILS_GRID, results);
  }

  @When("Operator gets the order details from summary tab of station cod report")
  public void operator_gets_the_order_details_from_summary_tab_of_station_cod_report() {
    String routeId = get(KEY_CREATED_ROUTE_ID).toString();
    Map<String, String> results = stationCODReportPage.getSummaryRowByRouteId(routeId);
    put(KEY_STATION_COD_REPORT_DETAILS_GRID, results);
  }

  @Then("^Operator verifies that the following details are displayed in \\w+ tab:$")
  public void operator_verifies_that_the_following_details_are_displayed_in_details_tab(
      Map<String, String> details) {
    NvCountry countryCd = NvCountry.fromString(NV_SYSTEM_ID);
    Map<String, String> actualDetails = get(KEY_STATION_COD_REPORT_DETAILS_GRID);
    Map<String, String> expectedDetails = resolveKeyValues(details);
    String codAmt;
    if (expectedDetails.containsKey("COD Amount")) {
      codAmt = stationCODReportPage.formatCODAmountByCountry(countryCd, details.get("COD Amount"));
      expectedDetails.put("COD Amount", codAmt);
    }
    stationCODReportPage.verifyResultGridContent(expectedDetails, actualDetails);
    takesScreenshot();
  }

  @Then("Operator verifies that the COD amount: {string} is separated by comma for thousands and by dot for decimals")
  public void operator_verifies_that_the_COD_amount_is_separated_by_comma_for_thousands_and_by_dot_for_decimals(
      String expectedCODAmount) {
    Map<String, String> actualDetails = get(KEY_STATION_COD_REPORT_DETAILS_GRID);
    if (actualDetails.containsKey("COD Amount")) {
      expectedCODAmount = String.valueOf(f("%,f", Float.parseFloat(expectedCODAmount)));
      expectedCODAmount = expectedCODAmount.contains(".") ? expectedCODAmount.replaceAll("0*$", "")
          .replaceAll("\\.$", "") : expectedCODAmount;
      Assertions.assertThat(expectedCODAmount.contentEquals(actualDetails.get("COD Amount")))
          .as("Assert that COD amount has comma and dot as separators").isTrue();
      return;
    }
    Assertions.assertThat(actualDetails.containsKey("COD Amount"))
        .as("Assert that COD amount displays in the result grid").isTrue();
    takesScreenshot();
  }


  @Then("Operator verifies that the COD amount: {string} is separated by dot for thousands and by comma for decimals")
  public void operator_verifies_that_the_COD_amount_is_separated_by_dot_for_thousands_and_by_comma_for_decimals(
      String expectedCODAmount) {
    NvCountry countryCd = NvCountry.fromString(NV_SYSTEM_ID);
    Map<String, String> actualDetails = get(KEY_STATION_COD_REPORT_DETAILS_GRID);
    if (actualDetails.containsKey("COD Amount")) {
      expectedCODAmount = stationCODReportPage.formatCODAmountByCountry(countryCd,
          expectedCODAmount);
      Assertions.assertThat(expectedCODAmount.contentEquals(actualDetails.get("COD Amount"))).as(
          "Assert that COD amount has comma and dot as separators for thousands and decimals respectively"
      ).isTrue();
      return;
    }
    Assertions.assertThat(actualDetails.containsKey("COD Amount"))
        .as("Assert that COD amount displays in the result grid").isTrue();
    takesScreenshot();
  }

  @Then("Operator verifies that the COD collected amount is separated by comma for thousands and by dot for decimals")
  public void operator_verifies_that_the_COD_collected_amount_is_separated_by_comma_for_thousands_and_by_dot_for_decimals() {
    NvCountry countryCd = NvCountry.fromString(NV_SYSTEM_ID);
    stationCODReportPage.verifySeparatorsInCashCollected(countryCd);
    takesScreenshot();
  }

  @Then("Operator verifies that the COD collected amount is separated by dot for thousands and by comma for decimals")
  public void operator_verifies_that_the_COD_collected_amount_is_separated_by_dot_for_thousands_and_by_comma_for_decimals() {
    NvCountry countryCd = NvCountry.fromString(NV_SYSTEM_ID);
    stationCODReportPage.verifySeparatorsInCashCollected(countryCd);
    takesScreenshot();
  }

  @Then("Operator verifies that the following columns are displayed under cash collected table")
  public void operator_verifies_that_the_following_columns_are_displayed_under_cash_collected_table(
      DataTable columns) {
    List<String> expectedColumns = columns.asList();
    stationCODReportPage.verifyColumnsInCashCollectedSummary(expectedColumns);
    takesScreenshot();
  }

  @Then("Operator verifies that the (updated )driver name: {string} is displayed in the grid")
  public void operator_verifies_that_the_updated_driver_name_is_displayed_in_the_grid(
      String driverFirstName) {
    Map<String, String> actualDetails = get(KEY_STATION_COD_REPORT_DETAILS_GRID);
    Map<String, String> expectedDetails = new HashMap<>();
    expectedDetails.put("Driver Name", resolveValue(driverFirstName));
    stationCODReportPage.verifyResultGridContent(expectedDetails, actualDetails);
    takesScreenshot();
  }

  @When("downloads station cod report in CSV file format")
  public void downloads_station_cod_report_in_CSV_file_format() {
    stationCODReportPage.downloadReportInCSVFormat();
  }

  @Then("Operator verifies that the downloaded CSV file matches with the expected details in {string} tab")
  public void operator_verifies_that_the_downloaded_CSV_file_matches_with_the_expected_details_in_tab(
      String tab) {
    final AtomicBoolean asserts = new AtomicBoolean(false);
    Map<String, String> expectedDetails = get(KEY_STATION_COD_REPORT_DETAILS_GRID);
    Map<String, Object> actualDetails = stationCODReportPage.getContentFromDownloadedCSV(tab);
    expectedDetails.forEach((key, value) -> {
      if (!actualDetails.containsKey(key)) {
        Assert.assertTrue(
            f("Assert that the record: %s in CSV match with the results displayed in the grid!",
                value),
            false);
      }
      if (actualDetails.containsKey(key)) {
        asserts.set(actualDetails.get(key).toString().contentEquals(value));
        if (key.contentEquals("COD Amount")) {
          asserts.set(actualDetails.get(key).toString().contains(value.replace(",", "")));
        }
        Assert.assertTrue(
            f("Assert that the record: %s in CSV match with the results displayed in the grid!",
                value),
            asserts.get());
      }
    });
    takesScreenshot();
  }

  @Then("Operator verifies that COD amount is rounded off to two decimal in CSV downloaded from {string} tab")
  public void operator_verifies_that_COD_amount_is_rounded_off_to_two_decimal_in_CSV_downloaded_from_tab(
      String tab) {
    Map<String, String> expectedDetails = get(KEY_STATION_COD_REPORT_DETAILS_GRID);
    Map<String, Object> actualDetails = stationCODReportPage.getContentFromDownloadedCSV(tab);
    String formattedExpectedCODAmount = expectedDetails.get("COD Amount").replace(",", "");
    if (actualDetails.containsKey("COD Amount")) {
      formattedExpectedCODAmount = String.format("%.2f",
          Float.parseFloat(formattedExpectedCODAmount));
      Assert.assertTrue("Assert that the cod amount in CSV is rounded off to 2 decimals",
          formattedExpectedCODAmount.contentEquals((String) actualDetails.get("COD Amount")));
      return;
    }
    Assert.assertTrue("Assert that the downloaded CSV contains COD Amount",
        actualDetails.containsKey("COD Amount"));
    takesScreenshot();
  }

}
