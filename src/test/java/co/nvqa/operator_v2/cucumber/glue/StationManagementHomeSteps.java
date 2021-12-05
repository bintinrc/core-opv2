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
        takesScreenshot();
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
    public void operator_verifies_that_the_count_in_tile_has_increased_by(String tileName, Integer totOrder) {
        int beforeOrder = Integer.parseInt(getString(KEY_NUMBER_OF_PARCELS_IN_HUB));
        int afterOrder = stationManagementHomePage.getNumberFromTile(tileName);
        takesScreenshot();
        stationManagementHomePage.waitUntilTileValueMatches(tileName, (beforeOrder+totOrder));
        stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, totOrder);
    }


    @When("Operator get the dollar amount from the tile: {string}")
    public void operator_get_the_dollar_amount_from_the_tile(String tileName) {
        double beforeOrder = stationManagementHomePage.getDollarValueFromTile(tileName);
        if("COD NOT COLLECTED YET FROM COURIERS".equals(tileName.toUpperCase().trim())){
            put(KEY_COD_DOLLAR_AMOUNT_NOT_COLLECTED_IN_HUB, beforeOrder);
        }
        if("COD COLLECTED FROM COURIERS".equals(tileName.toUpperCase().trim())){
            put(KEY_COD_DOLLAR_AMOUNT_COLLECTED_IN_HUB, beforeOrder);
        }
        takesScreenshot();
    }

    @Then("Operator verifies that the dollar amount in tile: {string} has increased by {double}")
    public void operator_verifies_that_the_dollar_amount_in_tile_has_increased_by(String tileName, Double deltaDollar) {
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

    @Then("Operator verifies that the dollar amount in tile: {string} has decreased by {double}")
    public void operator_verifies_that_the_dollar_amount_in_tile_has_decreased_by(String tileName, Double deltaDollar) {
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

    @Then("Operator verifies that the dollar amount in tile: {string} has remained un-changed")
    public void operator_verifies_that_the_dollar_amount_in_tile_has_remained_un_changed(String tileName) {
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

    @Then("Operator verifies that the count in tile: {string} has remained un-changed")
    public void operator_verifies_that_the_count_in_tile_has_remained_un_changed(String tileName) {
        int beforeOrder = Integer.parseInt(getString(KEY_NUMBER_OF_PARCELS_IN_HUB));
        int afterOrder = stationManagementHomePage.getNumberFromTile(tileName);
        takesScreenshot();
        stationManagementHomePage.waitUntilTileValueMatches(tileName, beforeOrder);
        stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, 0);
    }

    @Then("Operator verifies that the count in tile: {string} has decreased by {int}")
    public void operator_verifies_that_the_count_in_tile_has_decreased_by(String tileName, Integer totOrder) {
        totOrder = -totOrder;
        int beforeOrder = Integer.parseInt(getString(KEY_NUMBER_OF_PARCELS_IN_HUB));
        int afterOrder = stationManagementHomePage.getNumberFromTile(tileName);
        takesScreenshot();
        stationManagementHomePage.waitUntilTileValueMatches(tileName, (beforeOrder+totOrder));
        stationManagementHomePage.validateTileValueMatches(beforeOrder, afterOrder, totOrder);
    }

    @When("Operator get the count from the tile: {string}")
    public void operator_get_the_count_from_the_tile(String tileName) {
        int beforeOrder = stationManagementHomePage.getNumberFromTile(tileName);
        put(KEY_NUMBER_OF_PARCELS_IN_HUB, beforeOrder);
        takesScreenshot();
    }

    @When("Operator opens modal pop-up: {string} through hamburger button for the tile: {string}")
    public void operator_opens_modal_pop_up_through_hamburger_button_for_the_tile(String modalTitle, String tile) {
        stationManagementHomePage.openModalPopup(modalTitle, tile);
    }

    @Then("Operator verifies that the table:{string} is displayed with following columns:")
    public void operator_verifies_that_the_table_is_displayed_with_following_columns(String tableName, DataTable columnNames) {
        List<String> expectedColumns = columnNames.asList();
        stationManagementHomePage.verifyTableIsDisplayedInModal(tableName);
        stationManagementHomePage.verifyColumnsInTableDisplayed(tableName, expectedColumns);
    }

    @Then("Operator verifies that a table is displayed with following columns:")
    public void operator_verifies_that_a_table_is_displayed_with_following_columns(DataTable columnNames) {
        List<String> expectedColumns = columnNames.asList();
        takesScreenshot();
        stationManagementHomePage.verifyColumnsInTableDisplayed(expectedColumns);
    }

    @When("Operator searches for the orders in modal pop-up by applying the following filters:")
    public void operator_searches_for_the_orders_in_modal_pop_up_by_applying_the_following_filters(DataTable searchParameters) {
        List<Map<String, String>> filters = searchParameters.asMaps(String.class, String.class);
        Map<String, String> filter = resolveKeyValues(filters.get(0));
        stationManagementHomePage.applyFilters(filter, 1);
    }

    @When("Operator expects no results when searching for the orders by applying the following filters:")
    public void operator_expects_no_results_when_searching_for_the_orders_by_applying_the_following_filters(DataTable searchParameters) {
        List<Map<String, String>> filters = searchParameters.asMaps(String.class, String.class);
        Map<String, String> filter = resolveKeyValues(filters.get(0));
        stationManagementHomePage.applyFilters(filter, 0);
    }

    @Then("Operator expects no results in the modal under the table:{string} when applying the following filters:")
    public void operator_expects_no_results_in_the_modal_under_the_table_when_applying_the_following_filters(String tableName, DataTable searchParameters) {
        List<Map<String, String>> filters = searchParameters.asMaps(String.class, String.class);
        Map<String, String> filter = resolveKeyValues(filters.get(0));
        stationManagementHomePage.applyFilters(tableName, filter, 0);
    }

    @When("Operator searches for the order details in the table:{string} by applying the following filters:")
    public void operator_searches_for_the_order_details_in_the_table_by_applying_the_following_filters(String tableName, DataTable searchParameters) {
        List<Map<String, String>> filters = searchParameters.asMaps(String.class, String.class);
        Map<String, String> filter = resolveKeyValues(filters.get(0));
        stationManagementHomePage.applyFilters(tableName, filter, 1);
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
    public void operator_verifies_that_the_following_navigation_links_are_displayed_under_the_header(String headerName, DataTable navLinks) {
        List<String> expectedNavLinks = navLinks.asList();
        stationManagementHomePage.verifyLinksDisplayedInLeftPanel(headerName, expectedNavLinks);
    }

    @Then("Operator verifies that the page:{string} is loaded on new tab on clicking the link:{string}")
    public void operator_verifies_that_the_page_is_loaded_on_new_tab_on_clicking_the_link(String pageName, String linkName) {
        stationManagementHomePage.verifyPageOpenedOnClickingHyperlink(linkName, pageName);
    }

    @Then("Operator verifies that the text:{string} is displayed on the hub modal selection")
    public void operator_verifies_that_the_text_is_displayed_on_the_hub_modal_selection(String modalText) {
        StationLanguage.ModalText language = StationLanguage.ModalText.getLanguage(modalText);
        stationManagementHomePage.verifyLanguageModalTextLanguage(language);
    }

    @Then("Operator verifies that the station home :{string} is displayed as expected")
    public void operator_verifies_that_the_station_home_is_displayed_as_expected(String pageHeader) {
        StationLanguage.HeaderText language = StationLanguage.HeaderText.getLanguage(pageHeader);
        stationManagementHomePage.verifyPageUsingPageHeader(language);
    }

    @Then("Operator verifies that the info on page refresh text: {string} is shown on top left of the page")
    public void operator_verifies_that_the_info_on_page_refresh_text_is_shown_on_top_left_of_the_page(String pollingInfoText) {
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

    @Then("Operator verifies that the following details are displayed on the modal")
    public void operator_verifies_that_the_following_details_are_displayed_on_the_modal(Map<String,String> results) {
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

    @Then("Operator verifies that the following details are displayed on the modal under the table:{string}")
    public void operator_verifies_that_the_following_details_are_displayed_on_the_modal_under_the_table(String tableName, Map<String,String> results) {
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
        stationManagementHomePage.verifyEditOrderScreenURL(trackingId,orderId);
    }

    @Then("Operator verifies that the modal: {string} is displayed and can be closed")
    public void operator_verifies_that_the_modal_is_displayed_and_can_be_closed(String modalName) {
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

    @When("Operator clicks the alarm button to view parcels with sfld tickets")
    public void operator_clicks_the_alarm_button_to_view_parcels_with_sfld_tickets() {
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
    public void operator_verifies_that_the_text_and_count_are_matching_for_fsr_parcels_in_urgent_tasks_banner(String fsrText) {
        stationManagementHomePage.verifyFsrInUrgentTasks(fsrText);
    }

    @When("Operator opens the modal: {string} by clicking arrow beside the text: {string}")
    public void operator_opens_the_modal_by_clicking_arrow_beside_the_text(String modalName, String fsrText) {
        stationManagementHomePage.openModalByClickingArrow(modalName,fsrText);
    }
}
