package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.PrinterSettingsPage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.HashMap;
import java.util.Map;

@ScenarioScoped
public class PrinterSettingsSteps extends AbstractSteps {

    private static final String NAME = "name";
    private static final String IP_ADDRESS = "ip";
    private static final String VERSION = "version";
    private static final String DEFAULT = "default";
    private PrinterSettingsPage printerSettingsPage;
    private Map<String, String> details = new HashMap<>();

    @Inject
    public PrinterSettingsSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage) {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init() {
        this.printerSettingsPage = new PrinterSettingsPage(getWebDriver());
    }

    @When("^op click add Printer button$")
    public void opClickAddPrinterButton() {
        printerSettingsPage.clickAddPrinterButtons();
    }

    @Then("^Add Printer Form on display$")
    public void addPrinterFormOnDisplay() {
        printerSettingsPage.addPrinterModalOnDisplay();
    }

    @When("^op create printer setting with details:$")
    public void opCreatePrinterSettingWithDetails(Map<String, String> details) {
        this.details.putAll(details);
        printerSettingsPage.fillPrinterName(details.get(NAME));
        pause300ms();
        printerSettingsPage.fillPrinterIp(details.get(IP_ADDRESS));
        pause300ms();
        printerSettingsPage.fillPrinterVersion(details.get(VERSION));
        pause300ms();
        printerSettingsPage.switchToDefaultPrinter(details.get(DEFAULT));
        printerSettingsPage.clickSubmitButton();
    }

    @Then("^printer setting added$")
    public void printerSettingAdded() {
        printerSettingsPage.printerSettingWithNameOnDisplay(details.get(NAME));
        printerSettingsPage.checkPrinterSettingInfo(1, details);
    }

    @When("^op delete printer settings$")
    public void opDeletePrinterSettings() {
        printerSettingsPage.searchPrinterSettings(details.get(NAME));
        printerSettingsPage.deletePrinterSettingWithName(details.get(NAME));
    }

    @Then("^printer setting deleted$")
    public void printerSettingDeleted() {
        printerSettingsPage.printerSettingWithNameNotDisplayed(details.get(NAME));
    }

     @Then("^printer setting edited$")
    public void printerSettingEdited() {
        printerSettingsPage.printerSettingWithNameOnDisplay(details.get(NAME));
        printerSettingsPage.checkPrinterSettingInfo(1, details);
    }

    @When("^op edit \"([^\"]*)\" with \"([^\"]*)\" in Printer Settings \"([^\"]*)\"$")
    public void opEditWithInPrinterSettings(String detail, String value, String name) {
        printerSettingsPage.clickEditPrinterSettingWithName(name);
        printerSettingsPage.editDetails(detail, value);
        printerSettingsPage.clickSubmitButton();
        this.details.put(detail, value);
    }
}
