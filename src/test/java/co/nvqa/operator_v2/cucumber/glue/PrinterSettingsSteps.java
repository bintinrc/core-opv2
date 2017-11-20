package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.PrinterSettingsPage;
import co.nvqa.operator_v2.selenium.page.RouteGroupsPage;
import co.nvqa.operator_v2.util.ScenarioStorage;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.inject.Inject;
import cucumber.api.PendingException;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Map;

@ScenarioScoped
public class PrinterSettingsSteps extends AbstractSteps {

    private PrinterSettingsPage printerSettingsPage;
    private Map<String, String> details;

    @Inject
    public PrinterSettingsSteps(ScenarioManager scenarioManager) {
        super(scenarioManager);
    }

    @Override
    public void init() {
        this.printerSettingsPage = new PrinterSettingsPage(getWebDriver());
    }

    @When("^op click add Printer button$")
    public void clickNavigation()
    {
        printerSettingsPage.clickAddPrinterButtons();
    }

    @Then("^Add Printer Form on display$")
    public void addPrinterFormOnDisplay() throws Throwable {
        printerSettingsPage.addPrinterModalOnDisplay();
    }

    @When("^op create printer setting with details:$")
    public void opCreatePrinterSettingWithDetails(Map<String, String> details) throws Throwable {
        this.details = details;
        printerSettingsPage.fillPrinterName(details.get("name"));
        printerSettingsPage.fillPrinterIp(details.get("ip"));
        printerSettingsPage.fillPrinterVersion(details.get("version"));
        printerSettingsPage.switchToDefaultPrinter(details.get("default"));
        printerSettingsPage.clickSubmitButton();
    }

    @Then("^printer setting added$")
    public void printerSettingAdded() throws Throwable {
        printerSettingsPage.printerSettingWithNameOnDisplay(details.get("name"));
    }

    @When("^op delete printer settings$")
    public void opDeletePrinterSettings() throws Throwable {
        printerSettingsPage.deletePrinterSettingWithName(details.get("name"));
    }
}
