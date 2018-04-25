package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.PrinterSettings;
import co.nvqa.operator_v2.selenium.page.PrinterSettingsPage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Map;

/**
 *
 * @author Lanang Jati
 */
@ScenarioScoped
public class PrinterSettingsSteps extends AbstractSteps {

    private static final String NAME = "name";
    private static final String IP_ADDRESS = "ipAddress";
    private static final String VERSION = "version";
    private static final String IS_DEFAULT_PRINTER = "isDefaultPrinter";
    private PrinterSettingsPage printerSettingsPage;

    @Inject
    public PrinterSettingsSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage) {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init() {
        this.printerSettingsPage = new PrinterSettingsPage(getWebDriver());
    }

    @When("^Operator click Add Printer button$")
    public void opClickAddPrinterButton() {
        printerSettingsPage.clickAddPrinterButtons();
    }

    @Then("^Operator verify Add Printer form is displayed$")
    public void operatorVerifyAddPrinterFormIsDisplayed() {
        printerSettingsPage.verifyAddPrinterFormIsDisplayed();
    }

    @When("^Operator create Printer Settings with details:$")
    public void operatorCreatePrinterSettingsWithDetails(Map<String, String> mapOfData) {
        String name = mapOfData.get(NAME);
        String ipAddress = mapOfData.get(IP_ADDRESS);
        String version = mapOfData.get(VERSION);
        Boolean isDefaultPrinter = Boolean.parseBoolean(mapOfData.get(IS_DEFAULT_PRINTER));
        String dateUniqueString = generateDateUniqueString();

        if("GENERATED".equalsIgnoreCase(name))
        {
            name = "Printer "+dateUniqueString;
        }

        PrinterSettings printerSettings = new PrinterSettings();
        printerSettings.setName(name);
        printerSettings.setIpAddress(ipAddress);
        printerSettings.setVersion(version);
        printerSettings.setDefaultPrinter(isDefaultPrinter);
        printerSettingsPage.addPrinter(printerSettings);

        put("printerSettings", printerSettings);
    }

    @Then("^Operator verify Printer Settings is added successfully$")
    public void operatorVerifyPrinterSettingsIsAddedSuccessfully() {
        PrinterSettings printerSettings = get("printerSettings");
        printerSettingsPage.printerSettingWithNameOnDisplay(printerSettings.getName());
        printerSettingsPage.checkPrinterSettingInfo(1, printerSettings);
    }

    @When("^Operator delete Printer Settings$")
    public void operatorDeletePrinterSettings() {
        PrinterSettings printerSettings = get("printerSettings");
        printerSettingsPage.searchPrinterSettings(printerSettings.getName());
        printerSettingsPage.deletePrinterSettingWithName(printerSettings.getName());
    }

    @Then("^Operator verify Printer Settings is deleted successfully$")
    public void operatorVerifyPrinterSettingsIsDeletedSuccessfuly() {
        PrinterSettings printerSettings = get("printerSettings");
        printerSettingsPage.printerSettingWithNameNotDisplayed(printerSettings.getName());
    }

    @When("^Operator set \"([^\"]*)\" = \"([^\"]*)\" for Printer Settings with name = \"([^\"]*)\"$")
    public void operatorEditPrinterSettings(String configName, String configValue, String printerSettingsName) {
        PrinterSettings printerSettings = get("printerSettings");

        printerSettingsPage.clickEditPrinterSettingWithName(printerSettingsName);
        printerSettingsPage.editDetails(configName, configValue);
        printerSettingsPage.clickSubmitButton();

        switch(configName)
        {
            case NAME: printerSettings.setName(configValue); break;
            case IP_ADDRESS: printerSettings.setIpAddress(configValue); break;
            case VERSION: printerSettings.setVersion(configValue); break;
        }
    }

    @Then("^Operator verify Printer Settings is edited successfully$")
    public void operatorVerifyPrinterSettingsIsEditedSuccessfully() {
        PrinterSettings printerSettings = get("printerSettings");
        printerSettingsPage.printerSettingWithNameOnDisplay(printerSettings.getName());
        printerSettingsPage.checkPrinterSettingInfo(1, printerSettings);
    }
}
