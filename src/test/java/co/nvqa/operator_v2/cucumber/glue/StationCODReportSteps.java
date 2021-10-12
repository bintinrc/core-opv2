package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.StationCODReportPage;
import io.cucumber.datatable.DataTable;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import java.util.List;
import java.util.Map;

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
    public void verifies_that_the_following_UI_elements_are_displayed_in_station_cod_report_page(DataTable fields) {
        List<String> expectedFields = fields.asList();
        stationCODReportPage.verifyStationCODReportFields(expectedFields);
    }

    @Then("verifies that the following buttons are displayed in disabled state")
    public void verifies_that_the_following_buttons_are_displayed_in_disabled_state(DataTable buttonNames) {
        List<String> buttons = buttonNames.asList();
        for(String button : buttons){
            stationCODReportPage.verifyButtonDisplayedInDisabledState(button);
        }
    }

}
