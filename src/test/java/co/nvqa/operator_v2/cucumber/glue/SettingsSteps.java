package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.AllOrdersPage;
import co.nvqa.operator_v2.selenium.page.MainPage;
import co.nvqa.operator_v2.selenium.page.SettingsPage;
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
public class SettingsSteps extends AbstractSteps {

    private SettingsPage settingsPage;
    private AllOrdersPage allOrdersPage;

    public SettingsSteps() {
    }

    @Override
    public void init() {
        settingsPage = new SettingsPage(getWebDriver());
        allOrdersPage = new AllOrdersPage(getWebDriver());
    }

    @Given("Operator opens profile and navigates to settings screen")
    public void operator_opens_profile_and_navigates_to_settings_screen() {
        allOrdersPage.navigateToSettingsPage();
    }

    @When("Operator selects language as {string}")
    public void operator_selects_language_as(String language) {
        settingsPage.selectLanguageAs(language);
    }

}
