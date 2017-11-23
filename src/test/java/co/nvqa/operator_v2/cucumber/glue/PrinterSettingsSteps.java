package co.nvqa.operator_v2.cucumber.glue;

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
    public void printerSettingAdded() throws Throwable {
        printerSettingsPage.searchPrinterSettings(details.get(NAME));
        printerSettingsPage.printerSettingWithNameOnDisplay(details.get(NAME));
    }

    @When("^op delete printer settings$")
    public void opDeletePrinterSettings() throws Throwable {
        printerSettingsPage.searchPrinterSettings(details.get(NAME));
        printerSettingsPage.deletePrinterSettingWithName(details.get(NAME));
    }

    @Then("^printer setting deleted$")
    public void printerSettingDeleted() throws Throwable {
        printerSettingsPage.searchPrinterSettings(details.get(NAME));
        printerSettingsPage.printerSettingWithNameNotDisplayed(details.get(NAME));
    }

     @Then("^printer setting \"([^\"]*)\" edited$")
    public void printerSettingEdited(String detail) throws Throwable {
        printerSettingsPage.searchPrinterSettings(details.get(NAME));
        if (detail.equalsIgnoreCase(NAME)) {
            printerSettingsPage.printerSettingWithNameOnDisplay(details.get(NAME));
        } else if (detail.equalsIgnoreCase(IP_ADDRESS)) {
            printerSettingsPage.printerSettingWithIPOnDisplay(details.get(IP_ADDRESS));
        } else if (detail.equalsIgnoreCase(VERSION)) {
            printerSettingsPage.printerSettingWithVersionOnDisplay(details.get(VERSION));
        }
    }

    @When("^op edit \"([^\"]*)\" with \"([^\"]*)\" in Printer Settings \"([^\"]*)\"$")
    public void opEditWithInPrinterSettings(String detail, String value, String name) throws Throwable {
        printerSettingsPage.clickEditPrinterSettingWithName(name);
        printerSettingsPage.editDetails(detail, value);
        printerSettingsPage.clickSubmitButton();
        this.details.put(detail, value);
    }
}
