package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.station.hibernate.ParcelsDao;
import co.nvqa.common.station.model.persisted_class.Parcel;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.model.StationLanguage;
import co.nvqa.operator_v2.selenium.page.StationManagementHomePage;
import io.cucumber.datatable.DataTable;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;
import org.assertj.core.api.Assertions;
import org.junit.Assert;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Veera N
 */

@SuppressWarnings("unused")
@ScenarioScoped
public class StationManagementHomeSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(StationManagementHomeSteps.class);

  public static final String CSV_FILENAME_PATTERN = "Failure_Reasons";
  public static final String SFLD_ACK_FAILURE_MSG = "SFLD ticket acknowledgement failed because ticket is not of UNCONFIRMED status or other parameters are wrong.";

  private StationManagementHomePage stationManagementHomePage;

  public StationManagementHomeSteps() {
  }

  @Override
  public void init() {
    stationManagementHomePage = new StationManagementHomePage(getWebDriver());
  }

  @SuppressWarnings("unchecked")
  @When("Operator selects the hub as {string} and proceed")
  public void operator_selects_the_hub_as_and_proceed(String hubName) {
    hubName = resolveValue(hubName);
    final String hub = hubName;
    doWithRetry(() -> {
      stationManagementHomePage.selectHubAndProceed(hub);
    }, "Operator selects the hub and proceed", 10000, 3);
  }

  @When("Operator chooses the hub as {string} displayed in {string} and proceed")
  public void operator_chooses_the_hub_as_displayed_in_Language_and_proceed(String hubName,
      String language) {
    hubName = resolveValue(hubName);
    StationLanguage.HubSelectionText enumLanguage = StationLanguage.HubSelectionText.valueOf(
        language.toUpperCase());
    stationManagementHomePage.selectHubAndProceed(hubName, enumLanguage);
  }

  @Then("Operator changes hub as {string} through the dropdown in header")
  public void operator_changes_hub_as_through_the_dropdown_in_header(String hubName) {
    stationManagementHomePage.changeHubInHeaderDropdown(hubName);
  }

  @Then("Operator verifies that the url path parameter changes to hub-id:{string}")
  public void operator_verifies_that_the_url_path_parameter_changes_to_hub_id(String urlHub) {
    urlHub = resolveValue(urlHub);
    stationManagementHomePage.validateHubURLPath(urlHub);
  }

  @When("Operator updates station hub-id as {string} directly in the url")
  public void operator_updates_station_hub_id_as_directly_in_the_url(String hubId) {
    hubId = resolveValue(hubId);
    stationManagementHomePage.reloadURLWithNewHudId(hubId);
  }

  @Then("Operator verifies that the hub has changed to:{string} in header dropdown")
  public void operator_verifies_that_the_hub_has_changed_to_in_header_dropdown(String hubName) {
    hubName = resolveValue(hubName);
    stationManagementHomePage.validateHeaderHubValue(hubName);
  }

  @Then("Operator verifies that the count in tile: {string} has increased by {int}")
  public void operator_verifies_that_the_count_in_tile_has_increased_by(String tileName,
      Integer totOrder) {
    int beforeOrder = Integer.parseInt(getString(KEY_NUMBER_OF_PARCELS_IN_HUB));
    int afterOrder = stationManagementHomePage.getNumberFromTile(tileName);
    doWithRetry(() -> {
          takesScreenshot();
          getWebDriver().navigate().refresh();
          stationManagementHomePage.closeIfModalDisplay();
          stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, totOrder);
        }, f("Operator verifies that the count in tile: %s has increased by %d", tileName, totOrder),
        10000, 3);
  }

  @Then("Operator verifies that the Total Completion Rate:{string} is equal to {int}")
  public void operator_verifies_that_the_Total_Completion_Rate_is_equal_to(String tileName,
      Integer expectedCompletionRate) {
    stationManagementHomePage.closeIfModalDisplay();
    int TotalCompletionRate = stationManagementHomePage.getNumberFromTile(tileName);
    takesScreenshot();
    Assertions.assertThat(TotalCompletionRate)
        .as("expected Value is not matching for Total Completion Rate : %s", tileName)
        .isEqualTo(expectedCompletionRate);
    takesScreenshot();
  }

  @SuppressWarnings("unchecked")
  @Then("Operator verifies that the tile:{string} is equal to {string}")
  public void operator_verifies_that_the_tile_is_equal_to(String tileName,
      String expectedTilevalue) {
    doWithRetry(() -> {
      navigateRefresh();
      stationManagementHomePage.closeIfModalDisplay();
      String actualTileValue = String.valueOf(
          stationManagementHomePage.getNumberFromPendingPickupTile(tileName));
      takesScreenshot();
      Assertions.assertThat(actualTileValue)
          .as("expected Value is not matching for %s", tileName)
          .isEqualTo(expectedTilevalue);
    }, "Operator verifies that the tile value is equal to expected {string}", 10000, 3);
    takesScreenshot();
  }

  @Then("Operator verifies that the N+0 tile:{string} is equal to {string}")
  public void operator_verifies_that_the_N_Plus0_tile_is_equal_to(String tileName,
      String expectedTilevalue) {
    stationManagementHomePage.closeIfModalDisplay();
    String actualTileValue = stationManagementHomePage.getTileValueAsStringFromPendingPickupTile(
        tileName);
    takesScreenshot();
    Assertions.assertThat(actualTileValue)
        .as("expected Value is not matching for %s", tileName)
        .isEqualTo(expectedTilevalue);
    takesScreenshot();
  }

  @Then("Operator verifies that the count in the second tile: {string} has increased by {int}")
  public void operator_verifies_that_the_count_in__the_second_tile_has_increased_by(String tileName,
      Integer totOrder) {
    int beforeOrder = Integer.parseInt(getString(KEY_NUMBER_OF_PARCELS_IN_HUB_TILE_2));
    int afterOrder = stationManagementHomePage.getNumberFromTile(tileName);
    takesScreenshot();
    stationManagementHomePage.waitUntilTileValueMatches(tileName, (beforeOrder + totOrder));
    stationManagementHomePage.closeIfModalDisplay();
    stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, totOrder);
  }

  @When("Operator get the dollar amount from the tile: {string}")
  public void operator_get_the_dollar_amount_from_the_tile(String tileName) {
    double beforeOrder = stationManagementHomePage.getDollarValueFromTile(tileName);
    if ("COD NOT COLLECTED YET FROM COURIERS".equals(tileName.toUpperCase().trim())) {
      put(KEY_COD_DOLLAR_AMOUNT_NOT_COLLECTED_IN_HUB, beforeOrder);
    }
    if ("COD COLLECTED FROM COURIERS".equals(tileName.toUpperCase().trim())) {
      put(KEY_COD_DOLLAR_AMOUNT_COLLECTED_IN_HUB, beforeOrder);
    }
    takesScreenshot();
  }

  @Then("Operator verifies that the dollar amount in tile: {string} has increased by {double}")
  public void operator_verifies_that_the_dollar_amount_in_tile_has_increased_by(String tileName,
      Double deltaDollar) {
    String dollarValue = "";
    if ("COD NOT COLLECTED YET FROM COURIERS".equals(tileName.trim().toUpperCase())) {
      dollarValue = getString(KEY_COD_DOLLAR_AMOUNT_NOT_COLLECTED_IN_HUB);
    }
    if ("COD COLLECTED FROM COURIERS".equals(tileName.trim().toUpperCase())) {
      dollarValue = getString(KEY_COD_DOLLAR_AMOUNT_COLLECTED_IN_HUB);
    }
    dollarValue = dollarValue.replaceAll("\\$|\\,", "");
    double beforeOrder = Double.parseDouble(dollarValue);
    double afterOrder = stationManagementHomePage.getDollarValueFromTile(tileName);
    takesScreenshot();
    stationManagementHomePage.waitUntilTileDollarValueMatches(tileName,
        (beforeOrder + deltaDollar));
    stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, deltaDollar);
  }

  @Then("Operator verifies that the dollar amount in tile: {string} has decreased by {double}")
  public void operator_verifies_that_the_dollar_amount_in_tile_has_decreased_by(String tileName,
      Double deltaDollar) {
    deltaDollar = -deltaDollar;
    String dollarValue = "";
    if ("COD NOT COLLECTED YET FROM COURIERS".equals(tileName.trim().toUpperCase())) {
      dollarValue = getString(KEY_COD_DOLLAR_AMOUNT_NOT_COLLECTED_IN_HUB);
    }
    if ("COD COLLECTED FROM COURIERS".equals(tileName.trim().toUpperCase())) {
      dollarValue = getString(KEY_COD_DOLLAR_AMOUNT_COLLECTED_IN_HUB);
    }
    dollarValue = dollarValue.replaceAll("\\$|\\,", "");
    double beforeOrder = Double.parseDouble(dollarValue);
    double afterOrder = stationManagementHomePage.getDollarValueFromTile(tileName);
    takesScreenshot();
    stationManagementHomePage.waitUntilTileDollarValueMatches(tileName,
        (beforeOrder + deltaDollar));
    stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, deltaDollar);
  }

  @Then("Operator verifies that the dollar amount in tile: {string} has remained un-changed")
  public void operator_verifies_that_the_dollar_amount_in_tile_has_remained_un_changed(
      String tileName) {
    String dollarValue = "";
    if ("COD NOT COLLECTED YET FROM COURIERS".equals(tileName.trim().toUpperCase())) {
      dollarValue = getString(KEY_COD_DOLLAR_AMOUNT_NOT_COLLECTED_IN_HUB);
    }
    if ("COD COLLECTED FROM COURIERS".equals(tileName.trim().toUpperCase())) {
      dollarValue = getString(KEY_COD_DOLLAR_AMOUNT_COLLECTED_IN_HUB);
    }
    dollarValue = dollarValue.replaceAll("\\$|\\,", "");
    double beforeOrder = Double.parseDouble(dollarValue);
    double afterOrder = stationManagementHomePage.getDollarValueFromTile(tileName);
    takesScreenshot();
    stationManagementHomePage.waitUntilTileDollarValueMatches(tileName, beforeOrder);
    stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, 0.0);
  }

  @Then("Operator verifies that the count in tile: {string} has remained un-changed")
  public void operator_verifies_that_the_count_in_tile_has_remained_un_changed(String tileName) {
    int beforeOrder = Integer.parseInt(getString(KEY_NUMBER_OF_PARCELS_IN_HUB));
    doWithRetry(() -> {
          getWebDriver().navigate().refresh();
          int afterOrder = stationManagementHomePage.getNumberFromTile(tileName);
          takesScreenshot();
          stationManagementHomePage.closeIfModalDisplay();
          stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, 0);
        }, f("Operator verifies that the count in tile: %s has remained un-changed", tileName), 1000,
        5);
  }

  @Then("Operator verifies that the count in tile: {string} has decreased by {int}")
  public void operator_verifies_that_the_count_in_tile_has_decreased_by(String tileName,
      Integer totOrder) {
    totOrder = -totOrder;
    int beforeOrder = Integer.parseInt(getString(KEY_NUMBER_OF_PARCELS_IN_HUB));
    Integer finalTotOrder = totOrder;
    doWithRetry(() -> {
          getWebDriver().navigate().refresh();
          int afterOrder = stationManagementHomePage.getNumberFromTile(tileName);
          takesScreenshot();
          stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, finalTotOrder);
        }, f("Operator verifies that the count in tile: %s has decreased by %d", tileName, totOrder),
        10000, 3);
  }

  @When("Operator get the count from the tile: {string}")
  public void operator_get_the_count_from_the_tile(String tileName) {
    int beforeOrder = stationManagementHomePage.getNumberFromTile(tileName);
    put(KEY_NUMBER_OF_PARCELS_IN_HUB, beforeOrder);
    takesScreenshot();
  }

  @SuppressWarnings("unchecked")
  @Then("Operator verifies that the count in the pending pickup tile: {string} has increased by {int}")
  public void operator_verifies_that_the_count_in_pending_pickup_tile_has_increased_by(
      String tileName,
      Integer totOrder) {
    doWithRetry(() -> {
      int beforeOrder = get(KEY_NUMBER_OF_ADDRESS_IN_PENDING_PICKUP);
      navigateRefresh();
      int afterOrder = stationManagementHomePage.getNumberFromPendingPickupTile(tileName);
      stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, totOrder);
    }, f("Operator verifies that the count in the pending pickup tile: %s has increased by %d",
        tileName, totOrder), 10000, 3);

    takesScreenshot();
  }

  @SuppressWarnings("unchecked")
  @Then("Operator verifies that the count in the pending pickup tile: {string} has decreased by {int}")
  public void operator_verifies_that_the_count_in_pending_pickup_tile_has_decreased_by(
      String tileName,
      Integer totOrder) {
    totOrder = -totOrder;
    Integer finalTotOrder = totOrder;
    doWithRetry(() -> {
      int beforeOrder = get(KEY_NUMBER_OF_ADDRESS_IN_PENDING_PICKUP);
      navigateRefresh();
      int afterOrder = stationManagementHomePage.getNumberFromPendingPickupTile(tileName);
      stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, finalTotOrder);
    }, f("Operator verifies that the count in the pending pickup tile: %s has decreased by %d",
        tileName, totOrder), 10000, 3);

    takesScreenshot();
  }

  @SuppressWarnings("unchecked")
  @Then("Operator verifies that the count in the second in the pending pick up tile: {string} has increased by {int}")
  public void operator_verifies_that_the_count_in_the_second_tile_in_pending_pickup_has_increased_by(
      String tileName,
      Integer totOrder) {
    doWithRetry(() -> {
          int beforeOrder = get(KEY_NUMBER_OF_ADDRESS_IN_PENDING_PICKUP2);
          navigateRefresh();
          int afterOrder = stationManagementHomePage.getNumberFromPendingPickupTile(tileName);
          stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, totOrder);
        },
        f("Operator verifies that the count in the second pending pickup tile: %s has increased by %d",
            tileName, totOrder), 10000, 3);

    takesScreenshot();
  }

  @SuppressWarnings("unchecked")
  @Then("Operator verifies that the count in the second in the pending pick up tile: {string} has decreased by {int}")
  public void operator_verifies_that_the_count_in_the_second_tile_in_pending_pickup_has_decreased_by(
      String tileName,
      Integer totOrder) {
    totOrder = -totOrder;
    Integer finalTotOrder = totOrder;
    doWithRetry(() -> {
          int beforeOrder = get(KEY_NUMBER_OF_ADDRESS_IN_PENDING_PICKUP2);
          navigateRefresh();
          int afterOrder = stationManagementHomePage.getNumberFromPendingPickupTile(tileName);
          stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, finalTotOrder);
        },
        f("Operator verifies that the count in the second pending pickup tile: %s has decreased by %d",
            tileName, totOrder), 10000, 3);

    takesScreenshot();
  }

  @SuppressWarnings("unchecked")
  @Then("Operator verifies that the count in the pending pickup tile: {string} remains unchanged")
  public void operator_verifies_that_the_count_in_pending_pickup_tile_remains_unchanged(
      String tileName) {
    doWithRetry(() -> {
      int beforeOrder = get(KEY_NUMBER_OF_ADDRESS_IN_PENDING_PICKUP);
      navigateRefresh();
      int afterOrder = stationManagementHomePage.getNumberFromPendingPickupTile(tileName);
      stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, 0);
    }, f("Operator verifies that the count in the pending pickup tile: %s remains unchanged",
        tileName), 10000, 3);

    takesScreenshot();
  }

  @SuppressWarnings("unchecked")
  @Then("Operator verifies that the count in the second in the pending pick up tile: {string} remains unchanged")
  public void operator_verifies_that_the_count_in_the_second_tile_in_pending_pickup_remains_unchanged(
      String tileName) {
    doWithRetry(() -> {
      int beforeOrder = get(KEY_NUMBER_OF_ADDRESS_IN_PENDING_PICKUP2);
      navigateRefresh();
      int afterOrder = stationManagementHomePage.getNumberFromPendingPickupTile(tileName);
      stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, 0);
    }, f("Operator verifies that the count in the second pending pickup tile: %s remains unchanged",
        tileName), 10000, 3);

    takesScreenshot();
  }


  @When("Operator get the count from the pending pickup tile: {string}")
  public void operator_get_the_count_from_the_pending_pickup_tile(String tileName) {
    int beforeOrder = stationManagementHomePage.getNumberFromPendingPickupTile(tileName);
    put(KEY_NUMBER_OF_ADDRESS_IN_PENDING_PICKUP, beforeOrder);
    takesScreenshot();
  }

  @When("Operator get the count from one more tile in pending pickup: {string}")
  public void operator_get_the_count_from_one_more_tile_in_pending_pickup(String tileName) {
    int beforeOrder = stationManagementHomePage.getNumberFromPendingPickupTile(tileName);
    put(KEY_NUMBER_OF_ADDRESS_IN_PENDING_PICKUP2, beforeOrder);
    takesScreenshot();
  }

  @When("Operator get the count from one more tile: {string}")
  public void operator_get_the_count_from_one_more_tile(String tileName) {
    int beforeOrder = stationManagementHomePage.getNumberFromTile(tileName);
    put(KEY_NUMBER_OF_PARCELS_IN_HUB_TILE_2, beforeOrder);
    takesScreenshot();
  }

  @When("Operator opens modal pop-up: {string} through hamburger button for the tile: {string}")
  public void operator_opens_modal_pop_up_through_hamburger_button_for_the_tile(String modalTitle,
      String tile) {
    stationManagementHomePage.openModalPopup(modalTitle, tile);
  }

  @SuppressWarnings("unchecked")
  @When("Operator clicks on the hamburger button for the pending pickup tile: {string}")
  public void operator_clicks_hamburger_button_for_the_pending_pickup_tile(String tileName) {
    doWithRetry(() -> {
          String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
          stationManagementHomePage.clickPendingPickupHamburgerIcon(tileName);
        }, f("Operator clicks on the hamburger button for the pending pickup tile:%s", tileName), 1000,
        5);

  }

  @And("Operator verifies that Route Monitoring page is opened on clicking hamburger button for the tile: {string}")
  public void operatorVerifiesThatRouteMonitoringPageIsOpenedOnClickingHamburgerButtonForTheTile(
      String tileName) {
    stationManagementHomePage.verifyRouteMonitoringPageIsOpenedInNewTab(tileName);
    takesScreenshot();

  }

  @Then("Operator verifies that the table:{string} is displayed with following columns:")
  public void operator_verifies_that_the_table_is_displayed_with_following_columns(String tableName,
      DataTable columnNames) {
    List<String> expectedColumns = columnNames.asList();
    stationManagementHomePage.verifyTableIsDisplayedInModal(tableName);
    stationManagementHomePage.verifyColumnsInTableDisplayed(tableName, expectedColumns);
  }

  @Then("Operator verifies that a table is displayed with following columns:")
  public void operator_verifies_that_a_table_is_displayed_with_following_columns(
      DataTable columnNames) {
    List<String> expectedColumns = columnNames.asList();
    takesScreenshot();
    stationManagementHomePage.verifyColumnsInTableDisplayed(expectedColumns);
    takesScreenshot();
  }

  @When("Operator searches for the orders in modal pop-up by applying the following filters:")
  public void operator_searches_for_the_orders_in_modal_pop_up_by_applying_the_following_filters(
      DataTable searchParameters) {
    List<Map<String, String>> filters = searchParameters.asMaps(String.class, String.class);
    Map<String, String> filter = resolveKeyValues(filters.get(0));
    stationManagementHomePage.applyFilters(filter, 1);
    takesScreenshot();
  }

  @When("Operator selects following filter criteria for the table column: {string}")
  public void operator_selects_following_filter_criteria_for_the_table_column(String columnName,
      List<String> filterValues) {
    for (String filterValue : filterValues) {
      stationManagementHomePage.applyFilters(columnName, filterValue);
      takesScreenshot();
    }
  }

  @When("Operator selects the following values in the modal pop up")
  public void operator_selects_the_following_values_in_the_modal_pop_up(
      Map<String, String> selectFilters) {
    Map<String, String> filter = resolveKeyValues(selectFilters);
    stationManagementHomePage.selectFilterValue(filter);
  }

  @When("Operator expects no results when searching for the orders by applying the following filters:")
  public void operator_expects_no_results_when_searching_for_the_orders_by_applying_the_following_filters(
      DataTable searchParameters) {
    List<Map<String, String>> filters = searchParameters.asMaps(String.class, String.class);
    Map<String, String> filter = resolveKeyValues(filters.get(0));
    stationManagementHomePage.applyFilters(filter, 0);
  }

  @Then("Operator expects no results in the modal under the table:{string} when applying the following filters:")
  public void operator_expects_no_results_in_the_modal_under_the_table_when_applying_the_following_filters(
      String tableName, DataTable searchParameters) {
    List<Map<String, String>> filters = searchParameters.asMaps(String.class, String.class);
    Map<String, String> filter = resolveKeyValues(filters.get(0));
    stationManagementHomePage.applyFilters(tableName, filter, 0);
  }

  @When("Operator searches for the order details in the table:{string} by applying the following filters:")
  public void operator_searches_for_the_order_details_in_the_table_by_applying_the_following_filters(
      String tableName, DataTable searchParameters) {
    List<Map<String, String>> filters = searchParameters.asMaps(String.class, String.class);
    Map<String, String> filter = resolveKeyValues(filters.get(0));
    stationManagementHomePage.applyFilters(tableName, filter, 1);
    takesScreenshot();
  }

  @Then("Operator verifies that Edit Order page is opened on clicking tracking id")
  public void operator_verifies_that_Edit_Order_page_is_opened_on_clicking_tracking_id() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    stationManagementHomePage.verifyNavigationToEditOrderScreen(trackingId);
  }

  @Then("Operator verifies that Route Manifest page is opened on clicking route id")
  public void operator_verifies_that_Route_Manifest_page_is_opened_on_clicking_route_id() {
    Long routeId = get(KEY_CREATED_ROUTE_ID);
    stationManagementHomePage.verifyNavigationToRouteManifestScreen(String.valueOf(routeId));
  }

  @Then("reloads operator portal to reset the test state")
  public void reloads_operator_portal_to_reset_the_test_state() {
    stationManagementHomePage.loadOperatorPortal();
  }

  @When("Operator loads Operator portal home page")
  public void operator_loads_Operator_portal_home_page() {
    stationManagementHomePage.loadOperatorPortal();
  }

  @Then("Operator verifies that the toast message {string} is displayed")
  public void operator_verifies_that_the_toast_message_is_displayed(String message) {
    stationManagementHomePage.verifyHubNotFoundToast(message);
  }

  @Then("Operator verifies that station management home screen url is loaded")
  public void operator_verifies_that_station_management_home_screen_url_is_loaded() {
    stationManagementHomePage.validateStationURLPath();
  }

  @Then("Operator verifies that the following navigation links are displayed under the header:{string}")
  public void operator_verifies_that_the_following_navigation_links_are_displayed_under_the_header(
      String headerName, DataTable navLinks) {
    List<String> expectedNavLinks = navLinks.asList();
    stationManagementHomePage.verifyLinksDisplayedInLeftPanel(headerName, expectedNavLinks);
  }

  @Then("Operator verifies that the page:{string} is loaded on new tab on clicking the link:{string}")
  public void operator_verifies_that_the_page_is_loaded_on_new_tab_on_clicking_the_link(
      String pageName, String linkName) {
    stationManagementHomePage.verifyPageOpenedOnClickingHyperlink(linkName, pageName);
  }

  @Then("Operator verifies that the URL {string} is loaded on new tab on clicking the link:{string}")
  public void operator_verifies_that_the_URL_is_loaded_on_new_tab_on_clicking_the_link(
      String ExpectedURL, String linkName) {
    stationManagementHomePage.verifyURLOpenedOnClickingHyperlink(linkName, ExpectedURL);
  }

  @Then("Operator verifies that the text:{string} is displayed on the hub modal selection")
  public void operator_verifies_that_the_text_is_displayed_on_the_hub_modal_selection(
      String modalText) {
    StationLanguage.ModalText language = StationLanguage.ModalText.getLanguage(modalText);
    stationManagementHomePage.verifyLanguageModalTextLanguage(language);
  }

  @Then("Operator verifies that the station home :{string} is displayed as expected")
  public void operator_verifies_that_the_station_home_is_displayed_as_expected(String pageHeader) {
    StationLanguage.HeaderText language = StationLanguage.HeaderText.getLanguage(pageHeader);
    stationManagementHomePage.verifyPageUsingPageHeader(language);
  }

  @Then("Operator verifies that the info on page refresh text: {string} is shown on top left of the page")
  public void operator_verifies_that_the_info_on_page_refresh_text_is_shown_on_top_left_of_the_page(
      String pollingInfoText) {
    StationLanguage.PollingTimeText language = StationLanguage.PollingTimeText.getLanguage(
        pollingInfoText);
    stationManagementHomePage.verifyPagePollingTimeInfo(language);
  }

  @When("gets the count of the parcel by parcel size from the table: {string}")
  public void gets_the_count_of_the_parcel_by_parcel_size_from_the_table(String tableName) {
    String columnName = "size";
    String columnValue = "count";
    Map<String, String> tableBeforeChange = stationManagementHomePage.getColumnContentByTableName(
        tableName, columnName, columnValue);
    put(KEY_NUMBER_OF_PARCELS_IN_HUB_BY_SIZE, tableBeforeChange);
  }

  @Then("verifies that the parcel count for {string} is decreased by {int} in the table: {string}")
  public void verifies_that_the_parcel_count_for_is_decreased_by_in_the_table(String size,
      Integer delta, String tableName) {
    String columnName = "size";
    String columnValue = "count";
    final AtomicBoolean asserts = new AtomicBoolean(false);
    Map<String, String> tableBeforeChange = get(KEY_NUMBER_OF_PARCELS_IN_HUB_BY_SIZE);
    Map<String, String> tableAfterChange = stationManagementHomePage.getColumnContentByTableName(
        tableName, columnName, columnValue);
    tableAfterChange.forEach((key, value) -> {
      if (key.contentEquals(size)) {
        int sizeBeforeChange = Integer.parseInt(tableBeforeChange.get(key).replaceAll(",", ""));
        int sizeAfterChange = Integer.parseInt(value.replaceAll(",", ""));
        Assert.assertTrue(
            f("Assert that the number of parcel count is decreased for the size %s", size),
            sizeAfterChange == (sizeBeforeChange - delta));
        asserts.set(true);
      }
    });
    Assert.assertTrue(
        f("Assert that the number of parcel count is decreased for the size %s", size),
        asserts.get());
  }

  @Then("verifies that the parcel count for {string} is increased by {int} in the table: {string}")
  public void verifies_that_the_parcel_count_for_is_increased_by_in_the_table(String size,
      Integer delta, String tableName) {
    String columnName = "size";
    String columnValue = "count";
    final AtomicBoolean asserts = new AtomicBoolean(false);
    Map<String, String> tableBeforeChange = get(KEY_NUMBER_OF_PARCELS_IN_HUB_BY_SIZE);
    Map<String, String> tableAfterChange = stationManagementHomePage.getColumnContentByTableName(
        tableName, columnName, columnValue);
    tableAfterChange.forEach((key, value) -> {
      if (key.contentEquals(size)) {
        int sizeBeforeChange = Integer.parseInt(tableBeforeChange.get(key).replaceAll(",", ""));
        int sizeAfterChange = Integer.parseInt(value.replaceAll(",", ""));
        Assert.assertTrue(
            f("Assert that number of parcel count is increased for the size %s", size),
            sizeAfterChange == (sizeBeforeChange + delta));
        asserts.set(true);
        return;
      }
    });
    Assert.assertTrue(f("Assert that number of parcel count is increased for the size %s", size),
        asserts.get());
  }

  @Then("Operator verifies that the following details are displayed on the modal")
  public void operator_verifies_that_the_following_details_are_displayed_on_the_modal(
      Map<String, String> results) {
    Map<String, String> expectedResults = resolveKeyValues(results);
    Map<String, String> actualResults = stationManagementHomePage.getResultGridContent();
    Assert.assertTrue("Assert that the result grid contains results",
        actualResults.size() > 0);
    expectedResults.forEach((key, value) -> {
      if (key.startsWith("COD")) {
        actualResults.put(key, actualResults.get(key).replaceAll(",", ""));
      }
      Assert.assertTrue("Assert that the result grid contains all expected column values",
          value.contentEquals(actualResults.get(key)));
    });
    takesScreenshot();
  }

  @Then("Operator verifies that the following details are displayed on the modal under the table:{string}")
  public void operator_verifies_that_the_following_details_are_displayed_on_the_modal_under_the_table(
      String tableName, Map<String, String> results) {
    Map<String, String> expectedResults = resolveKeyValues(results);
    Map<String, String> actualResults = stationManagementHomePage.getResultGridContentByTableName(
        tableName);
    Assert.assertTrue("Assert that the result grid contains results",
        actualResults.size() > 0);
    expectedResults.forEach((key, value) -> {
      if (key.startsWith("COD")) {
        actualResults.put(key, actualResults.get(key).replaceAll(",", ""));
      }
      Assert.assertTrue("Assert that the result grid contains all expected column values",
          value.contentEquals(actualResults.get(key)));
    });
    takesScreenshot();
  }

  @Then("Operator verifies that recovery tickets page is opened on clicking arrow button")
  public void operator_verifies_that_recovery_tickets_page_is_opened_on_clicking_arrow_button() {
    stationManagementHomePage.verifyRecoveryTicketsOnClickingArrowIcon();
  }

  @Then("Operator verifies that the url for recovery tickets page is loaded with tracking id")
  public void operator_verifies_that_the_url_for_recovery_tickets_page_is_loaded_with_tracking_id() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    stationManagementHomePage.validateStationRecoveryURLPath(trackingId);
  }

  @Then("Operator verifies that the url for edit order page is loaded with order id")
  public void operator_verifies_that_the_url_for_edit_order_page_is_loaded_with_order_id() {
    String orderId = get(KEY_CREATED_ORDER_ID).toString();
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    stationManagementHomePage.verifyEditOrderScreenURL(trackingId, orderId);
  }

  @Then("Operator verifies that the modal: {string} is displayed and can be closed")
  public void operator_verifies_that_the_modal_is_displayed_and_can_be_closed(String modalName) {
    stationManagementHomePage.verifyModalPopupByName(modalName);
    stationManagementHomePage.closeIfModalDisplay(modalName);
  }

  @Then("Operator verifies that the modal: {string} is displayed")
  public void operator_verifies_that_the_modal_is_displayed(String modalName) {
    stationManagementHomePage.verifyModalPopupByName(modalName);
  }

  @When("Operator closes the modal: {string} if it is displayed on the page")
  public void operator_closes_the_modal_if_it_is_displayed_on_the_page(String modalName) {
    stationManagementHomePage.closeIfModalDisplay(modalName);
  }

  @When("Operator get sfld ticket count for the priority parcels")
  public void operator_get_the_sfld_ticket_count_for_the_priority_parcels() {
    int beforeOrder = stationManagementHomePage.getSfldParcelCount();
    put(KEY_NUMBER_OF_SFLD_TICKETS_IN_HUB, beforeOrder);
    takesScreenshot();
  }

  @Then("Operator verifies that the sfld ticket count has increased by {int}")
  public void operator_verifies_that_the_sfld_ticket_count_has_increased_by(Integer totOrder) {
    stationManagementHomePage.closeIfModalDisplay("Please Confirm ETA of FSR Parcels to Proceed");
    int beforeOrder = Integer.parseInt(getString(KEY_NUMBER_OF_SFLD_TICKETS_IN_HUB));
    int afterOrder = stationManagementHomePage.getSfldParcelCount();
    takesScreenshot();
    stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, totOrder);
  }

  @Then("Operator verifies that the sfld ticket count has decreased by {int}")
  public void operator_verifies_that_the_sfld_ticket_count_has_decreased_by(Integer totOrder) {
    totOrder = -totOrder;
    int beforeOrder = Integer.parseInt(getString(KEY_NUMBER_OF_SFLD_TICKETS_IN_HUB));
    int afterOrder = stationManagementHomePage.getSfldParcelCount();
    stationManagementHomePage.refreshPage_v1();
    stationManagementHomePage.closeIfModalDisplay();
    takesScreenshot();
    stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, totOrder);
  }

  @When("Operator clicks the arrow button to view parcels with sfld tickets")
  public void operator_clicks_the_arrow_button_to_view_parcels_with_sfld_tickets() {
    stationManagementHomePage.openOrdersWithUnconfirmedTickets();
  }

  @Then("Operator confirms that station confirmed eta field is empty")
  public void operator_confirms_that_station_confirmed_eta_field_is_empty() {
    stationManagementHomePage.stationConfirmedEtaEmpty();
  }

  @Then("Operator verifies that save and confirm button is disabled")
  public void operator_verifies_that_save_and_confirm_button_is_disabled() {
    stationManagementHomePage.confirmSaveAndConfirmDisabled();
  }

  @Then("Operator confirms that no checkbox displayed for sfld parcels when eta has passed")
  public void operator_confirms_that_no_checkbox_displayed_for_sfld_parcels_when_eta_has_passed() {
    stationManagementHomePage.confirmCheckboxDisplayed();
  }

  @Then("Operator verifies that the text: {string} and count are matching for fsr parcels in urgent tasks banner")
  public void operator_verifies_that_the_text_and_count_are_matching_for_fsr_parcels_in_urgent_tasks_banner(
      String fsrText) {
    stationManagementHomePage.verifyFsrInUrgentTasks(fsrText);
  }

  @When("Operator opens the modal: {string} by clicking arrow beside the text: {string}")
  public void operator_opens_the_modal_by_clicking_arrow_beside_the_text(String modalName,
      String fsrText) {
    stationManagementHomePage.openModalByClickingArrow(modalName, fsrText);
  }

  @When("Operator saves to address used in the parcel in the key")
  public void operator_saves_to_address_used_in_the_parcel_in_the_key() {
    Order order = get(KEY_CREATED_ORDER);
    String addressLn1 = order.getToAddress1();
    String addressLn2 = order.getToAddress2();
    String postCode = order.getToPostcode();
    String formattedToAddress = "";
    if (addressLn2.isEmpty()) {
      formattedToAddress = f("%s, %s", addressLn1, postCode);
    }
    if (!addressLn2.isEmpty()) {
      formattedToAddress = f("%s, %s, %s", addressLn1, addressLn2, postCode);
    }
    put(KEY_COMMA_DELIMITED_ORDER_TO_ADDRESS, formattedToAddress);
  }

  @Then("Operators sorts and verifies that the column:{string} is in ascending order")
  public void operators_sorts_and_verifies_that_the_column_is_in_ascending_order(
      String columnName) {
    stationManagementHomePage.sortColumn(columnName, "ASCENDING_ORDER");
    stationManagementHomePage.getRecordsAndValidateSorting(columnName);
  }

  @Then("Operators sorts and verifies that the column:{string} is in descending order")
  public void operators_sorts_and_verifies_that_the_column_is_in_descending_order(
      String columnName) {
    stationManagementHomePage.sortColumn(columnName, "DESCENDING_ORDER");
    stationManagementHomePage.getRecordsAndValidateSorting(columnName);
  }

  @When("Operators chooses the date:{string} as station confirmed eta and proceed")
  public void operators_chooses_the_date_as_station_confirmed_eta_and_proceed(String etaToChoose) {
    stationManagementHomePage.selectSuggestedEtaAndProceed(etaToChoose);
  }

  @Then("Operators verifies that the toast message: {string} has displayed")
  public void operators_verifies_that_the_toast_has_displayed(String toastMessage) {
    stationManagementHomePage.verifyToastMessage(toastMessage);
  }

  @When("Operator selects {int} records that have same eta calculated from the modal")
  public void operator_selects_records_that_have_same_eta_calculated_from_the_modal(
      Integer recordCt) {
    stationManagementHomePage.selectMultipleRecordsToConfirmEta(recordCt);
  }

  @Then("Operator verifies that the text: {string} is displayed")
  public void operator_verifies_that_the_text_is_displayed(String expectedMsg) {
    stationManagementHomePage.verifySfldAlertMessage(expectedMsg);
  }

  @Then("Operator confirms the common eta as:{string} and proceed")
  public void operator_confirms_the_common_eta_as_and_proceed(String etaDate) {
    stationManagementHomePage.selectCommonSuggestedEtaAndProceed(etaDate);
  }

  @When("Operator downloads the records with failed etas by clicking the download button")
  public void operator_downloads_the_records_with_failed_etas_by_clicking_the_download_button() {
    stationManagementHomePage.downloadFailedEtas();
  }

  @Then("Operator verifies that the valid error message is updated on the downloaded file")
  public void operator_verifies_that_the_valid_error_message_is_updated_on_the_downloaded_file() {
    String downloadedCsvFile = stationManagementHomePage.getLatestDownloadedFilename(
        CSV_FILENAME_PATTERN);
    stationManagementHomePage.verifyFileDownloadedSuccessfully(downloadedCsvFile,
        SFLD_ACK_FAILURE_MSG, true);
  }

  @When("Operator applies filter as {string} from quick filters option")
  public void operator_applies_filter_as_from_quick_filters_option(String filter) {
    stationManagementHomePage.applyQuickFilter(filter);
  }

  @When("Operator selects the checkbox on the created orders that are to be confirmed with the eta")
  public void operator_selects_the_checkbox_on_the_created_orders_that_are_to_be_confirmed_with_the_eta() {
    List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
    stationManagementHomePage.selectCheckboxByTrackingId(trackingIds);
  }

  @Then("Operator verifies that the station confirmed eta is disabled and cannot be updated")
  public void operator_verifies_that_the_station_confirmed_eta_is_disabled_and_cannot_be_updated() {
    stationManagementHomePage.verifyStationConfirmedEtaDisabled();
  }

  @When("Operator verifies that the following text is displayed on hover over the tile text: {string}")
  public void operator_verifies_that_the_following_text_is_displayed_on_hover_over_the_tile_text(
      String tileTitle, List<String> texts) {
    stationManagementHomePage.mouseOverToTileTitle(tileTitle);
    stationManagementHomePage.verifyMouseOverText(texts);
  }

  @Then("Operator verifies that the mouseover text is not displayed on moving away from the tile title")
  public void operator_verifies_that_the_mouseover_text_is_not_displayed_on_moving_away_from_the_tile_title() {
    stationManagementHomePage.mouseOverToManualButton();
  }

  @Then("Operator verifies that the chart is displayed in incoming shipment modal")
  public void operator_verifies_that_the_chart_is_displayed_in_incoming_shipment_modal() {
    stationManagementHomePage.verifyChartIsShown();
  }

  @Then("Operator verifies that the chart is not displayed in incoming shipment modal")
  public void operator_verifies_that_the_chart_is_not_displayed_in_incoming_shipment_modal() {
    stationManagementHomePage.verifyChartIsNotShown();
  }

  @Then("Operator verifies that no results found text is displayed under the table: {string}")
  public void operator_verifies_that_no_results_found_text_is_displayed_under_the_table(
      String table) {
    stationManagementHomePage.verifyNoResultsFoundByTableName(table);
  }

  @Then("Operator verifies user is redirected to the Station Management Homepage of hub {string} that has been mapped to user")
  public void operatorVerifiesUserIsRedirectedToTheStationManagementHomepageOfHubThatHasBeenMappedToUser(
      String hubName) {
    stationManagementHomePage.validateHeaderHubValue(hubName);
  }


  @And("Operator gets the order details from modal {string}")
  public void operatorGetsTheOrderDetailsFromModal(String tableName) {
    Map<String, String> actualResults = stationManagementHomePage.getResultGridContentByTableName(
        tableName);
    put(KEY_STATION_HOME_PAGE_TABLE_DETAILS, actualResults);
  }

  @Then("Station Operator verifies that Last Scan time for TrackingId {value} is +{int} hours in station parcels table")
  public void dbOperatorVerifiesThatLastScanTimeForTrackingIdIsHoursInStationParcelsTable(
      String trackingId, int timeDiff) {
    Map<String, String> details = get(KEY_STATION_HOME_PAGE_TABLE_DETAILS);
    String actualLastScanTime = details.get("Last Scan Time");
    ParcelsDao parcels = new ParcelsDao();
    List<Parcel> dbResults = parcels.getParcelDetails(trackingId);
    String expectedAdjustedTimeEndDateInUTC = DateUtil.getAdjustedLocalTimeFromUTC(
        dbResults.get(0).getLastScanTime(), timeDiff);
    Assertions.assertThat(expectedAdjustedTimeEndDateInUTC)
        .as(f("Assert that last Scan Time is added with %d from utc time in database", timeDiff))
        .isEqualTo(actualLastScanTime);
  }
}
