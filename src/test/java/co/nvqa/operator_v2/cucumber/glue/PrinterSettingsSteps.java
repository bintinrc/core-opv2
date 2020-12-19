package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.PrinterSettings;
import co.nvqa.operator_v2.selenium.page.PrinterSettingsPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.Map;

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
    mapOfData = resolveKeyValues(mapOfData);
    PrinterSettings printerSettings = new PrinterSettings(mapOfData);
    printerSettingsPage.addPrinter(printerSettings);
    put(KEY_PRINTER_SETTINGS, printerSettings);
  }

  @Then("^Operator verify Printer Settings is added successfully$")
  public void operatorVerifyPrinterSettingsIsAddedSuccessfully() {
    PrinterSettings printerSettings = get(KEY_PRINTER_SETTINGS);
    printerSettingsPage.printerSettingWithNameOnDisplay(printerSettings.getName());
    printerSettingsPage.checkPrinterSettingInfo(1, printerSettings);
  }

  @When("^Operator delete Printer Settings$")
  public void operatorDeletePrinterSettings() {
    PrinterSettings printerSettings = get(KEY_PRINTER_SETTINGS);
    printerSettingsPage.searchPrinterSettings(printerSettings.getName());
    printerSettingsPage.deletePrinterSettingWithName(printerSettings.getName());
  }

  @Then("^Operator verify Printer Settings is deleted successfully$")
  public void operatorVerifyPrinterSettingsIsDeletedSuccessfully() {
    PrinterSettings printerSettings = get(KEY_PRINTER_SETTINGS);
    retryIfAssertionErrorOccurred(
        () -> printerSettingsPage.printerSettingWithNameNotDisplayed(printerSettings.getName()),
        "Check if printer record is not displayed",
        2000,
        5
    );
    remove(KEY_PRINTER_SETTINGS);
  }

  @When("^Operator set \"([^\"]*)\" = \"([^\"]*)\" for Printer Settings with name = \"([^\"]*)\"$")
  public void operatorEditPrinterSettings(String configName, String configValue,
      String printerSettingsName) {
    PrinterSettings printerSettings = get(KEY_PRINTER_SETTINGS);

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

  @Then("^Operator verify Printer Settings is edited successfully$")
  public void operatorVerifyPrinterSettingsIsEditedSuccessfully() {
    PrinterSettings printerSettings = get(KEY_PRINTER_SETTINGS);
    printerSettingsPage.printerSettingWithNameOnDisplay(printerSettings.getName());
    printerSettingsPage.checkPrinterSettingInfo(1, printerSettings);
  }
}
