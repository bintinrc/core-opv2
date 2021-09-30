package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.StationManagementHomePage;
import io.cucumber.datatable.DataTable;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.Map;

/**
 * @author Veera N
 */

@SuppressWarnings("unused")
@ScenarioScoped
public class StationManagementHomeSteps extends AbstractSteps {

    private StationManagementHomePage stationManagementHomePage;

    public StationManagementHomeSteps() {
    }

    @Override
    public void init() {
        stationManagementHomePage = new StationManagementHomePage(getWebDriver());
    }

    @When("Operator selects the hub as {string} and proceed")
    public void operator_selects_the_hub_as_and_proceed(String hubName) {
        hubName = resolveValue(hubName);
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        stationManagementHomePage.selectHubAndProceed(hubName);
    }

    @Then("Operator changes hub as {string} through the dropdown in header")
    public void operator_changes_hub_as_through_the_dropdown_in_header(String hubName) {
        stationManagementHomePage.changeHubInHeaderDropdown(hubName);
    }

    @Then("verifies that the url path parameter changes to hub-id:{string}")
    public void verifies_that_the_url_path_parameter_changes_to_hub_id(String urlHub) {
        stationManagementHomePage.validateURLPath(urlHub);
    }

    @Then("verifies that the count in tile: {string} has increased by {int}")
    public void verifies_that_the_count_in_tile_has_increased_by(String tileName, Integer totOrder) {
        int beforeOrder = Integer.parseInt(getString(KEY_NUMBER_OF_PARCELS_IN_HUB));
        int afterOrder = stationManagementHomePage.getNumberFromTile(tileName);
        stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, totOrder);
    }

    @Given("get the count from the tile: {string}")
    public void get_the_count_from_the_tile(String tileName) {
        int beforeOrder = stationManagementHomePage.getNumberFromTile(tileName);
        put(KEY_NUMBER_OF_PARCELS_IN_HUB, beforeOrder);
    }

    @When("opens modal pop-up: {string} through hamburger button for the tile: {string}")
    public void opens_modal_pop_up_through_hamburger_button_for_the_tile(String modalTitle, String tile) {
        stationManagementHomePage.openModalPopup(modalTitle, tile);
    }

    @Then("verifies that the table:{string} is displayed with following columns:")
    public void verifies_that_the_table_is_displayed_with_following_columns(String tableName, DataTable columnNames) {
        List<String> expectedColumns = columnNames.asList();
        stationManagementHomePage.verifyTableIsDisplayedInModal(tableName);
        stationManagementHomePage.verifyColumnsInTableDisplayed(tableName, expectedColumns);
    }

    @Then("verifies that a table is displayed with following columns:")
    public void verifies_that_a_table_is_displayed_with_following_columns(DataTable columnNames) {
        List<String> expectedColumns = columnNames.asList();
        stationManagementHomePage.verifyColumnsInTableDisplayed(expectedColumns);
    }

    @When("searches for the orders in modal pop-up by applying the following filters:")
    public void searches_for_the_orders_in_modal_pop_up_by_applying_the_following_filters(DataTable searchParameters) {
        List<Map<String, String>> filters = searchParameters.asMaps(String.class, String.class);
        Map<String, String> filter = resolveKeyValues(filters.get(0));
        stationManagementHomePage.applyFilters(filter);
    }

    @When("searches for the order details in the table:{string} by applying the following filters:")
    public void searches_for_the_order_details_in_the_table_by_applying_the_following_filters(String tableName, DataTable searchParameters) {
        List<Map<String, String>> filters = searchParameters.asMaps(String.class, String.class);
        Map<String, String> filter = resolveKeyValues(filters.get(0));
        stationManagementHomePage.applyFilters(tableName,filter);
    }

    @Then("verifies that Edit Order page is opened on clicking tracking id")
    public void verifies_that_Edit_Order_page_is_opened_on_clicking_tracking_id() {
       String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
       stationManagementHomePage.verifyNavigationToEditOrderScreen(trackingId);
    }

    @Then("verifies that Route Manifest page is opened on clicking route id")
    public void verifies_that_Route_Manifest_page_is_opened_on_clicking_route_id() {
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        stationManagementHomePage.verifyNavigationToRouteManifestScreen(String.valueOf(routeId));
    }

    @Then("reloads operator portal to reset the test state")
    public void reloads_operator_portal_to_reset_the_test_state() {
        stationManagementHomePage.reloadOperatorPortal();
    }

}