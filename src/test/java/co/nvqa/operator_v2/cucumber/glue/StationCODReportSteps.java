package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.util.NvCountry;
import co.nvqa.operator_v2.selenium.page.StationCODReportPage;
import io.cucumber.datatable.DataTable;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.Map;
import static co.nvqa.commons.util.StandardTestConstants.COUNTRY_CODE;

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

  @Then("verifies that the following UI elements are displayed in station cod report page")
  public void verifies_that_the_following_UI_elements_are_displayed_in_station_cod_report_page(
      DataTable fields) {
    List<String> labels = fields.asList();
    for (String label : labels) {
      stationCODReportPage.verifyFieldInCODReport(label);
    }
  }

  @Then("verifies that the following buttons are displayed in disabled state")
  public void verifies_that_the_following_buttons_are_displayed_in_disabled_state(
      DataTable buttonNames) {
    List<String> buttons = buttonNames.asList();
    for (String button : buttons) {
      stationCODReportPage.verifyButtonDisplayedInDisabledState(button);
    }
  }

  @When("chooses start and end date on transaction end date using the following data:")
  public void chooses_start_and_end_date_on_transaction_end_date_using_the_following_data(
      Map<String, String> transEndDate) {
    transEndDate = resolveKeyValues(transEndDate);
    String shipperCreationDateFrom = transEndDate.get("transactionEndDateFrom");
    String shipperCreationDateTo = transEndDate.get("transactionEndDateTo");
    stationCODReportPage.setTransactionEndDateFilter(shipperCreationDateFrom,
        shipperCreationDateTo);
  }

  @When("searches for station cod report by applying following filters:")
  public void searches_for_station_cod_report_by_applying_following_filters(DataTable searchParam) {
    List<Map<String, String>> filters = searchParam.asMaps(String.class, String.class);
    for (Map<String, String> filter : filters) {
      Map<String, String> resolvedFilter = resolveKeyValues(filters.get(0));
      stationCODReportPage.applyFilters(resolvedFilter);
    }
  }

  @Then("verifies that tabs - Details and Summary are displayed after the search")
  public void verifies_that_tabs_Details_and_Summary_are_displayed_after_the_search() {
    stationCODReportPage.verifyDetailsAndSummaryTabsDisplayed();
  }

  @Then("verifies that the following columns are displayed under {string} tab")
  public void verifies_that_the_following_columns_are_displayed_under_tab(String tabName,
      DataTable columns) {
    List<String> columnNames = columns.asList();
    stationCODReportPage.verifyColumnsInTableDisplayed(tabName, columnNames);
  }

  @When("navigates to summary tab in the result grid")
  public void navigates_to_summary_tab_in_the_result_grid() {
    stationCODReportPage.navigateToSummaryTab();
  }

  @When("searches for the details in result grid using the following search criteria:")
  public void searches_for_the_details_in_result_grid_using_the_following_search_criteria(
      Map<String, String> filters) {
    Map<String, String> resolvedFilters = resolveKeyValues(filters);
    stationCODReportPage.applyFiltersInResultGrid(resolvedFilters);
  }

  @When("gets the order details from details tab of station cod report")
  public void gets_the_order_details_from_details_tab_of_station_cod_report() {
    Map<String, String> results = stationCODReportPage.getResultGridContent();
    put(KEY_STATION_COD_REPORT_DETAILS_GRID, results);
  }

  @When("gets the order details from summary tab of station cod report")
  public void gets_the_order_details_from_summary_tab_of_station_cod_report() {
    String routeId = get(KEY_CREATED_ROUTE_ID).toString();
    Map<String, String> results = stationCODReportPage.getSummaryRowByRouteId(routeId);
    put(KEY_STATION_COD_REPORT_DETAILS_GRID, results);
  }

  @Then("^verifies that the following details are displayed in \\w+ tab:$")
  public void verifies_that_the_following_details_are_displayed_in_details_tab(
      Map<String, String> details) {
    NvCountry countryCd = NvCountry.fromString(COUNTRY_CODE);
    Map<String, String> actualDetails = get(KEY_STATION_COD_REPORT_DETAILS_GRID);
    Map<String, String> expectedDetails = resolveKeyValues(details);
    String codAmt;
    if (expectedDetails.containsKey("COD Amount")) {
      codAmt = stationCODReportPage.formatCODAmountByCountry(countryCd, details.get("COD Amount"));
      expectedDetails.put("COD Amount", codAmt);
    }
    stationCODReportPage.verifyResultGridContent(expectedDetails, actualDetails);
  }

  @Then("verifies that the COD amount: {string} is separated by comma for thousands and by dot for decimals")
  public void verifies_that_the_COD_amount_is_separated_by_comma_for_thousands_and_by_dot_for_decimals(
      String expectedCODAmount) {
    Map<String, String> actualDetails = get(KEY_STATION_COD_REPORT_DETAILS_GRID);
    if (actualDetails.containsKey("COD Amount")) {
      expectedCODAmount = String.valueOf(f("%,f", Float.parseFloat(expectedCODAmount)));
      expectedCODAmount = expectedCODAmount.contains(".") ? expectedCODAmount.replaceAll("0*$", "")
          .replaceAll("\\.$", "") : expectedCODAmount;
      assertTrue("Assert that COD amount has comma and dot as separators",
          expectedCODAmount.contentEquals(actualDetails.get("COD Amount")));
      return;
    }
    assertTrue("Assert that COD amount displays in the result grid",
        actualDetails.containsKey("COD Amount"));
  }


  @Then("verifies that the COD amount: {string} is separated by dot for thousands and by comma for decimals")
  public void verifies_that_the_COD_amount_is_separated_by_dot_for_thousands_and_by_comma_for_decimals(
      String expectedCODAmount) {
    NvCountry countryCd = NvCountry.fromString(COUNTRY_CODE);
    Map<String, String> actualDetails = get(KEY_STATION_COD_REPORT_DETAILS_GRID);
    if (actualDetails.containsKey("COD Amount")) {
      expectedCODAmount = stationCODReportPage.formatCODAmountByCountry(countryCd,
          expectedCODAmount);
      assertTrue(
          "Assert that COD amount has comma and dot as separators for thousands and decimals respectively",
          expectedCODAmount.contentEquals(actualDetails.get("COD Amount")));
      return;
    }
    assertTrue("Assert that COD amount displays in the result grid",
        actualDetails.containsKey("COD Amount"));
  }

  @Then("verifies that the COD collected amount is separated by comma for thousands and by dot for decimals")
  public void verifies_that_the_COD_collected_amount_is_separated_by_comma_for_thousands_and_by_dot_for_decimals() {
    NvCountry countryCd = NvCountry.fromString(COUNTRY_CODE);
    stationCODReportPage.verifySeparatorsInCashCollected(countryCd);
  }

  @Then("verifies that the COD collected amount is separated by dot for thousands and by comma for decimals")
  public void verifies_that_the_COD_collected_amount_is_separated_by_dot_for_thousands_and_by_comma_for_decimals() {
    NvCountry countryCd = NvCountry.fromString(COUNTRY_CODE);
    stationCODReportPage.verifySeparatorsInCashCollected(countryCd);
  }

  @Then("verifies that the following columns are displayed under cash collected table")
  public void verifies_that_the_following_columns_are_displayed_under_cash_collected_table(
      DataTable columns) {
    List<String> expectedColumns = columns.asList();
    stationCODReportPage.verifyColumnsInCashCollectedSummary(expectedColumns);
  }

}
