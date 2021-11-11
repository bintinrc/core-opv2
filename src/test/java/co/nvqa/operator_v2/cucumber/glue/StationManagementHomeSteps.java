package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Dimension;
import co.nvqa.operator_v2.model.StationLanguage;
import co.nvqa.operator_v2.selenium.page.StationManagementHomePage;
import io.cucumber.datatable.DataTable;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.junit.Assert;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;

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

    @When("Operator chooses the hub as {string} displayed in {string} and proceed")
    public void operator_chooses_the_hub_as_displayed_in_Language_and_proceed(String hubName, String language) {
        hubName = resolveValue(hubName);
        StationLanguage.HubSelectionText enumLanguage = StationLanguage.HubSelectionText.valueOf(language.toUpperCase());
        stationManagementHomePage.selectHubAndProceed(hubName, enumLanguage);
    }

    @Then("Operator changes hub as {string} through the dropdown in header")
    public void operator_changes_hub_as_through_the_dropdown_in_header(String hubName) {
        stationManagementHomePage.changeHubInHeaderDropdown(hubName);
    }

    @Then("verifies that the url path parameter changes to hub-id:{string}")
    public void verifies_that_the_url_path_parameter_changes_to_hub_id(String urlHub) {
        urlHub = resolveValue(urlHub);
        stationManagementHomePage.validateHubURLPath(urlHub);
    }

    @When("updates station hub-id as {string} directly in the url")
    public void updates_station_hub_id_as_directly_in_the_url(String hubId) {
        hubId = resolveValue(hubId);
        stationManagementHomePage.reloadURLWithNewHudId(hubId);
    }

    @Then("verifies that the hub has changed to:{string} in header dropdown")
    public void verifies_that_the_hub_has_changed_to_in_header_dropdown(String hubName) {
        hubName = resolveValue(hubName);
        stationManagementHomePage.validateHeaderHubValue(hubName);
    }

    @Then("verifies that the count in tile: {string} has increased by {int}")
    public void verifies_that_the_count_in_tile_has_increased_by(String tileName, Integer totOrder) {
        int beforeOrder = Integer.parseInt(getString(KEY_NUMBER_OF_PARCELS_IN_HUB));
        int afterOrder = stationManagementHomePage.getNumberFromTile(tileName);
        takesScreenshot();
        stationManagementHomePage.waitUntilTileValueMatches(tileName, (beforeOrder+totOrder));
        stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, totOrder);
    }


    @When("get the dollar amount from the tile: {string}")
    public void get_the_dollar_amount_from_the_tile(String tileName) {
        double beforeOrder = stationManagementHomePage.getDollarValueFromTile(tileName);
        if("COD NOT COLLECTED YET FROM COURIERS".equals(tileName.toUpperCase().trim())){
            put(KEY_COD_DOLLAR_AMOUNT_NOT_COLLECTED_IN_HUB, beforeOrder);
        }
        if("COD COLLECTED FROM COURIERS".equals(tileName.toUpperCase().trim())){
            put(KEY_COD_DOLLAR_AMOUNT_COLLECTED_IN_HUB, beforeOrder);
        }
        takesScreenshot();
    }

    @Then("verifies that the dollar amount in tile: {string} has increased by {double}")
    public void verifies_that_the_dollar_amount_in_tile_has_increased_by(String tileName, Double deltaDollar) {
        String dollarValue = "";
        if("COD NOT COLLECTED YET FROM COURIERS".equals(tileName.trim().toUpperCase())){
            dollarValue = getString(KEY_COD_DOLLAR_AMOUNT_NOT_COLLECTED_IN_HUB);
        }
        if("COD COLLECTED FROM COURIERS".equals(tileName.trim().toUpperCase())){
            dollarValue = getString(KEY_COD_DOLLAR_AMOUNT_COLLECTED_IN_HUB);
        }
        dollarValue = dollarValue.replaceAll("\\$|\\,","");
        double beforeOrder = Double.parseDouble(dollarValue);
        double afterOrder = stationManagementHomePage.getDollarValueFromTile(tileName);
        takesScreenshot();
        stationManagementHomePage.waitUntilTileDollarValueMatches(tileName, (beforeOrder+deltaDollar));
        stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, deltaDollar);
    }

    @Then("verifies that the dollar amount in tile: {string} has decreased by {double}")
    public void verifies_that_the_dollar_amount_in_tile_has_decreased_by(String tileName, Double deltaDollar) {
        deltaDollar = -deltaDollar;
        String dollarValue = "";
        if("COD NOT COLLECTED YET FROM COURIERS".equals(tileName.trim().toUpperCase())){
            dollarValue = getString(KEY_COD_DOLLAR_AMOUNT_NOT_COLLECTED_IN_HUB);
        }
        if("COD COLLECTED FROM COURIERS".equals(tileName.trim().toUpperCase())){
            dollarValue = getString(KEY_COD_DOLLAR_AMOUNT_COLLECTED_IN_HUB);
        }
        dollarValue = dollarValue.replaceAll("\\$|\\,","");
        double beforeOrder = Double.parseDouble(dollarValue);
        double afterOrder = stationManagementHomePage.getDollarValueFromTile(tileName);
        takesScreenshot();
        stationManagementHomePage.waitUntilTileDollarValueMatches(tileName, (beforeOrder+deltaDollar));
        stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, deltaDollar);
    }

    @Then("verifies that the dollar amount in tile: {string} has remained un-changed")
    public void verifies_that_the_dollar_amount_in_tile_has_remained_un_changed(String tileName) {
        String dollarValue = "";
        if("COD NOT COLLECTED YET FROM COURIERS".equals(tileName.trim().toUpperCase())){
            dollarValue = getString(KEY_COD_DOLLAR_AMOUNT_NOT_COLLECTED_IN_HUB);
        }
        if("COD COLLECTED FROM COURIERS".equals(tileName.trim().toUpperCase())){
            dollarValue = getString(KEY_COD_DOLLAR_AMOUNT_COLLECTED_IN_HUB);
        }
        dollarValue = dollarValue.replaceAll("\\$|\\,","");
        double beforeOrder = Double.parseDouble(dollarValue);
        double afterOrder = stationManagementHomePage.getDollarValueFromTile(tileName);
        takesScreenshot();
        stationManagementHomePage.waitUntilTileDollarValueMatches(tileName, beforeOrder);
        stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, 0.0);
    }

    @Then("verifies that the count in tile: {string} has remained un-changed")
    public void verifies_that_the_count_in_tile_has_remained_un_changed(String tileName) {
        int beforeOrder = Integer.parseInt(getString(KEY_NUMBER_OF_PARCELS_IN_HUB));
        int afterOrder = stationManagementHomePage.getNumberFromTile(tileName);
        takesScreenshot();
        stationManagementHomePage.waitUntilTileValueMatches(tileName, beforeOrder);
        stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, 0);
    }

    @Then("verifies that the count in tile: {string} has decreased by {int}")
    public void verifies_that_the_count_in_tile_has_decreased_by(String tileName, Integer totOrder) {
        totOrder = -totOrder;
        int beforeOrder = Integer.parseInt(getString(KEY_NUMBER_OF_PARCELS_IN_HUB));
        int afterOrder = stationManagementHomePage.getNumberFromTile(tileName);
        takesScreenshot();
        stationManagementHomePage.waitUntilTileValueMatches(tileName, (beforeOrder+totOrder));
        stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, totOrder);
    }

    @When("get the count from the tile: {string}")
    public void get_the_count_from_the_tile(String tileName) {
        int beforeOrder = stationManagementHomePage.getNumberFromTile(tileName);
        put(KEY_NUMBER_OF_PARCELS_IN_HUB, beforeOrder);
        takesScreenshot();
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
        takesScreenshot();
        stationManagementHomePage.verifyColumnsInTableDisplayed(expectedColumns);
    }

    @When("searches for the orders in modal pop-up by applying the following filters:")
    public void searches_for_the_orders_in_modal_pop_up_by_applying_the_following_filters(DataTable searchParameters) {
        List<Map<String, String>> filters = searchParameters.asMaps(String.class, String.class);
        Map<String, String> filter = resolveKeyValues(filters.get(0));
        stationManagementHomePage.applyFilters(filter, 1);
    }

    @When("expects no results when searching for the orders by applying the following filters:")
    public void expects_no_results_when_searching_for_the_orders_by_applying_the_following_filters(DataTable searchParameters) {
        List<Map<String, String>> filters = searchParameters.asMaps(String.class, String.class);
        Map<String, String> filter = resolveKeyValues(filters.get(0));
        stationManagementHomePage.applyFilters(filter, 0);
    }

    @Then("expects no results in the modal under the table:{string} when applying the following filters:")
    public void expects_no_results_in_the_modal_under_the_table_when_applying_the_following_filters(String tableName, DataTable searchParameters) {
        List<Map<String, String>> filters = searchParameters.asMaps(String.class, String.class);
        Map<String, String> filter = resolveKeyValues(filters.get(0));
        stationManagementHomePage.applyFilters(tableName, filter, 0);
    }

    @When("searches for the order details in the table:{string} by applying the following filters:")
    public void searches_for_the_order_details_in_the_table_by_applying_the_following_filters(String tableName, DataTable searchParameters) {
        List<Map<String, String>> filters = searchParameters.asMaps(String.class, String.class);
        Map<String, String> filter = resolveKeyValues(filters.get(0));
        stationManagementHomePage.applyFilters(tableName, filter, 1);
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
        stationManagementHomePage.loadOperatorPortal();
    }

    @When("Operator loads Operator portal home page")
    public void operator_loads_Operator_portal_home_page() {
        stationManagementHomePage.loadOperatorPortal();
    }


    @Then("verifies that the toast message {string} is displayed")
    public void verifies_that_the_toast_message_is_displayed(String message) {
        stationManagementHomePage.verifyHubNotFoundToast(message);
    }

    @Then("verifies that station management home screen url is loaded")
    public void verifies_that_station_management_home_screen_url_is_loaded() {
        stationManagementHomePage.validateStationURLPath();
    }

    @Then("verifies that the following navigation links are displayed under the header:{string}")
    public void verifies_that_the_following_navigation_links_are_displayed_under_the_header(String headerName, DataTable navLinks) {
        List<String> expectedNavLinks = navLinks.asList();
        stationManagementHomePage.verifyLinksDisplayedInLeftPanel(headerName, expectedNavLinks);
    }

    @Then("verifies that the page:{string} is loaded on new tab on clicking the link:{string}")
    public void verifies_that_the_page_is_loaded_on_new_tab_on_clicking_the_link(String linkName, String pageName) {
        stationManagementHomePage.verifyPageOpenedOnClickingHyperlink(linkName, pageName);
    }

    @Then("verifies that the text:{string} is displayed on the hub modal selection")
    public void verifies_that_the_text_is_displayed_on_the_hub_modal_selection(String modalText) {
        StationLanguage.ModalText language = StationLanguage.ModalText.getLanguage(modalText);
        stationManagementHomePage.verifyLanguageModalTextLanguage(language);
    }

    @Then("verifies that the station home :{string} is displayed as expected")
    public void verifies_that_the_station_home_is_displayed_as_expected(String pageHeader) {
        StationLanguage.HeaderText language = StationLanguage.HeaderText.getLanguage(pageHeader);
        stationManagementHomePage.verifyPageUsingPageHeader(language);
    }

    @Then("verifies that the info on page refresh text: {string} is shown on top left of the page")
    public void verifies_that_the_info_on_page_refresh_text_is_shown_on_top_left_of_the_page(String pollingInfoText) {
        StationLanguage.PollingTimeText language = StationLanguage.PollingTimeText.getLanguage(pollingInfoText);
        stationManagementHomePage.verifyPagePollingTimeInfo(language);
    }

    @When("gets the count of the parcel by parcel size from the table: {string}")
    public void gets_the_count_of_the_parcel_by_parcel_size_from_the_table(String tableName) {
        String columnName = "size";
        String columnValue =  "count";
        Map<String, String> tableBeforeChange = stationManagementHomePage.getColumnContentByTableName(tableName, columnName, columnValue);
        put(KEY_NUMBER_OF_PARCELS_IN_HUB_BY_SIZE, tableBeforeChange);
    }

    @Then("verifies that the parcel count for {string} is decreased by {int} in the table: {string}")
    public void verifies_that_the_parcel_count_for_is_decreased_by_in_the_table(String size, Integer delta, String tableName) {
        String columnName = "size";
        String columnValue =  "count";
        final AtomicBoolean asserts = new AtomicBoolean(false);
        Map<String, String> tableBeforeChange = get(KEY_NUMBER_OF_PARCELS_IN_HUB_BY_SIZE);
        Map<String, String> tableAfterChange = stationManagementHomePage.getColumnContentByTableName(tableName, columnName, columnValue);
        Dimension.Size parcelSize = Dimension.Size.fromString(size);
        String regularSize = parcelSize.getRegular();
        tableAfterChange.forEach((key,value) -> {
            String formattedKey = key.replace("-","").toUpperCase();
            if(formattedKey.contentEquals(regularSize)){
                int sizeBeforeChange = Integer.parseInt(tableBeforeChange.get(key));
                int sizeAfterChange = Integer.parseInt(value);
                Assert.assertTrue(f("Assert that the number of parcel count is decreased for the size %s",size),
                        sizeAfterChange == (sizeBeforeChange - delta));
                asserts.set(true);
            }
        });
        Assert.assertTrue(f("Assert that the number of parcel count is decreased for the size %s",size),
                asserts.get());
    }

    @Then("verifies that the parcel count for {string} is increased by {int} in the table: {string}")
    public void verifies_that_the_parcel_count_for_is_increased_by_in_the_table(String size, Integer delta, String tableName) {
        String columnName = "size";
        String columnValue =  "count";
        final AtomicBoolean asserts = new AtomicBoolean(false);
        Map<String, String> tableBeforeChange = get(KEY_NUMBER_OF_PARCELS_IN_HUB_BY_SIZE);
        Map<String, String> tableAfterChange = stationManagementHomePage.getColumnContentByTableName(tableName, columnName, columnValue);
        Dimension.Size parcelSize = Dimension.Size.fromString(size);
        String regularSize = parcelSize.getRegular();
        tableAfterChange.forEach((key,value) -> {
            String formattedKey = key.replace("-","").toUpperCase();
            if(formattedKey.contentEquals(regularSize)){
                int sizeBeforeChange = Integer.parseInt(tableBeforeChange.get(key));
                int sizeAfterChange = Integer.parseInt(value);
                Assert.assertTrue(f("Assert that number of parcel count is increased for the size %s",size),
                        sizeAfterChange == (sizeBeforeChange + delta));
                asserts.set(true);
                return;
            }
        });
        Assert.assertTrue(f("Assert that number of parcel count is increased for the size %s",size),
                asserts.get());
    }

    @Then("verifies that the following details are displayed on the modal")
    public void verifies_that_the_following_details_are_displayed_on_the_modal(Map<String,String> results) {
        Map<String, String> expectedResults = resolveKeyValues(results);
        Map<String, String> actualResults = stationManagementHomePage.getResultGridContent();
        Assert.assertTrue("Assert that the result grid contains results",
            actualResults.size() > 0);
        expectedResults.forEach((key, value) -> {
            if(key.startsWith("COD")){
                actualResults.put(key,actualResults.get(key).replaceAll(",",""));
            }
            Assert.assertTrue("Assert that the result grid contains all expected column values",
            value.contentEquals(actualResults.get(key)));
        });
    }

    @Then("verifies that the following details are displayed on the modal under the table:{string}")
    public void verifies_that_the_following_details_are_displayed_on_the_modal_under_the_table(String tableName, Map<String,String> results) {
        Map<String, String> expectedResults = resolveKeyValues(results);
        Map<String, String> actualResults = stationManagementHomePage.getResultGridContentByTableName(tableName);
        Assert.assertTrue("Assert that the result grid contains results",
            actualResults.size() > 0);
        expectedResults.forEach((key, value) -> {
            if(key.startsWith("COD")){
                actualResults.put(key,actualResults.get(key).replaceAll(",",""));
            }
            Assert.assertTrue("Assert that the result grid contains all expected column values",
                value.contentEquals(actualResults.get(key)));
        });
    }

    @Then("verifies that recovery tickets page is opened on clicking arrow button")
    public void verifies_that_recovery_tickets_page_is_opened_on_clicking_arrow_button() {
        stationManagementHomePage.verifyRecoveryTicketsOnClickingArrowIcon();
    }

    @Then("verifies that the url for recovery tickets page is loaded with tracking id")
    public void verifies_that_the_url_for_recovery_tickets_page_is_loaded_with_tracking_id() {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        stationManagementHomePage.validateStationRecoveryURLPath(trackingId);
    }

    @Then("verifies that the url for edit order page is loaded with order id")
    public void verifies_that_the_url_for_edit_order_page_is_loaded_with_order_id() {
        String orderId = get(KEY_CREATED_ORDER_ID).toString();
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        stationManagementHomePage.verifyEditOrderScreenURL(trackingId,orderId);
    }

}
