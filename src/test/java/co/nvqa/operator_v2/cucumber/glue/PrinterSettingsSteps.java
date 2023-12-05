package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.model.PrinterSettings;
import co.nvqa.common.core.utils.CoreScenarioStorageKeys;
import co.nvqa.operator_v2.selenium.page.PrinterSettingsPage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.util.Map;

import static co.nvqa.operator_v2.selenium.page.PrinterSettingsPage.PrintersTable.ACTION_SET_DEFAULT;

/**
 * @author Lanang Jati
 */
@ScenarioScoped
public class PrinterSettingsSteps extends AbstractSteps {

  private static final String NAME = "name";
  private static final String IP_ADDRESS = "ipAddress";
  private static final String VERSION = "version";
  private PrinterSettingsPage printerSettingsPage;

  public PrinterSettingsSteps() {
  }

  @Override
  public void init() {
    this.printerSettingsPage = new PrinterSettingsPage(getWebDriver());
  }

  @When("Operator click Add Printer button")
  public void opClickAddPrinterButton() {
    printerSettingsPage.clickAddPrinterButtons();
  }

  @Then("Operator verify Add Printer form is displayed")
  public void operatorVerifyAddPrinterFormIsDisplayed() {
    printerSettingsPage.verifyAddPrinterFormIsDisplayed();
  }

  @When("Operator create Printer Settings with details:")
  public void operatorCreatePrinterSettingsWithDetails(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    PrinterSettings printerSettings = new PrinterSettings(mapOfData);
    printerSettingsPage.addPrinter(printerSettings);
    put(CoreScenarioStorageKeys.KEY_CORE_PRINTER_SETTINGS, printerSettings);
  }

  @Then("Operator verify Printer Settings is added successfully")
  public void operatorVerifyPrinterSettingsIsAddedSuccessfully() {
    PrinterSettings printerSettings = get(CoreScenarioStorageKeys.KEY_CORE_PRINTER_SETTINGS);
    printerSettingsPage.printerSettingWithNameOnDisplay(printerSettings.getName());
    printerSettingsPage.checkPrinterSettingInfo(1, printerSettings);
  }

  @When("Operator delete Printer Settings")
  public void operatorDeletePrinterSettings() {
    PrinterSettings printerSettings = get(CoreScenarioStorageKeys.KEY_CORE_PRINTER_SETTINGS);
    printerSettingsPage.searchPrinterSettings(printerSettings.getName());
    printerSettingsPage.deletePrinterSettingWithName(printerSettings.getName());
  }

  @When("Operator set printer as default printer")
  public void operatorSetDefaultPrinter() {
    PrinterSettings printerSettings = get(CoreScenarioStorageKeys.KEY_CORE_PRINTER_SETTINGS);
    printerSettingsPage.printersTable.filterByColumn("name", printerSettings.getName());
    printerSettingsPage.printersTable.clickActionButton(1, ACTION_SET_DEFAULT);
  }

  @Then("Operator verify Printer Settings is deleted successfully")
  public void operatorVerifyPrinterSettingsIsDeletedSuccessfully() {
    PrinterSettings printerSettings = get(CoreScenarioStorageKeys.KEY_CORE_PRINTER_SETTINGS);
    retryIfAssertionErrorOccurred(
        () -> printerSettingsPage.printerSettingWithNameNotDisplayed(printerSettings.getName()),
        "Check if printer record is not displayed",
        2000,
        5
    );
    remove(CoreScenarioStorageKeys.KEY_CORE_PRINTER_SETTINGS);
  }

  @Then("Operator verify Printer Settings is set as default")
  public void operatorVerifyPrinterIsDefault() {
    PrinterSettings printerSettings = get(CoreScenarioStorageKeys.KEY_CORE_PRINTER_SETTINGS);
    printerSettingsPage.verifyDefaultPrinter(printerSettings.getName());
  }

  @When("Operator set {string} = {string} for Printer Settings with name = {string}")
  public void operatorEditPrinterSettings(String configName, String configValue,
      String printerSettingsName) {
    PrinterSettings printerSettings = get(CoreScenarioStorageKeys.KEY_CORE_PRINTER_SETTINGS);

    printerSettingsPage.clickEditPrinterSettingWithName(printerSettingsName);
    printerSettingsPage.editDetails(configName, configValue);
    printerSettingsPage.clickSubmitButton();

    switch (configName) {
      case NAME:
        printerSettings.setName(configValue);
        break;
      case IP_ADDRESS:
        printerSettings.setIpAddress(configValue);
        break;
      case VERSION:
        printerSettings.setVersion(configValue);
        break;
    }
  }

  @Then("Operator verify Printer Settings is edited successfully")
  public void operatorVerifyPrinterSettingsIsEditedSuccessfully() {
    PrinterSettings printerSettings = get(CoreScenarioStorageKeys.KEY_CORE_PRINTER_SETTINGS);
    printerSettingsPage.printerSettingWithNameOnDisplay(printerSettings.getName());
    printerSettingsPage.checkPrinterSettingInfo(1, printerSettings);
  }
}
