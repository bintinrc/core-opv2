package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.model.PrinterSettings;
import co.nvqa.common.core.utils.CoreScenarioStorageKeys;
import co.nvqa.common.utils.NvSoftAssertions;
import co.nvqa.operator_v2.selenium.page.PrinterSettingsPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
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

  @When("Operator click Add Printer button")
  public void opClickAddPrinterButton() {
    printerSettingsPage.inFrame(() -> {
      printerSettingsPage.clickAddPrinterButtons();
    });
  }

  @Then("Operator verify Add Printer form is displayed")
  public void operatorVerifyAddPrinterFormIsDisplayed() {
    printerSettingsPage.inFrame(() -> {
      printerSettingsPage.verifyAddPrinterFormIsDisplayed();
    });
  }

  @When("Operator create Printer Settings with details:")
  public void operatorCreatePrinterSettingsWithDetails(Map<String, String> data) {
    Map<String, String> mapOfData = resolveKeyValues(data);
    printerSettingsPage.inFrame(() -> {
      PrinterSettings printerSettings = new PrinterSettings(mapOfData);
      printerSettingsPage.addPrinter(printerSettings);
      put(CoreScenarioStorageKeys.KEY_CORE_PRINTER_SETTINGS, printerSettings);
    });
  }

  @Then("Operator verifies that success toast {string} is displayed")
  public void verifySuccessToast(String message) {
    printerSettingsPage.inFrame((page) -> {
      page.waitUntilInvisibilityOfToast(resolveValue(message));
    });
  }

  @Then("Operator verify Printer Settings is added successfully")
  public void operatorVerifyPrinterSettingsIsAddedSuccessfully() {
    printerSettingsPage.inFrame((page) -> {
      PrinterSettings printerSettings = get(CoreScenarioStorageKeys.KEY_CORE_PRINTER_SETTINGS);
      printerSettingsPage.printerSettingWithNameOnDisplay(printerSettings.getName());
      NvSoftAssertions softly = new NvSoftAssertions();
      softly.assertEquals("name column", page.printersTable.nameColumn.getText(),
          printerSettings.getName());
      softly.assertEquals("ip address column", page.printersTable.ipAddress.getText(),
          printerSettings.getIpAddress());
      softly.assertEquals("version column", page.printersTable.version.getText(),
          printerSettings.getVersion());
      softly.assertEquals("default column", page.printersTable.isDefault.getText(),
          Boolean.toString(printerSettings.isDefault()));
      softly.assertAll();
    });
  }

  @When("Operator delete Printer Settings")
  public void operatorDeletePrinterSettings() {
    printerSettingsPage.inFrame(() -> {
      PrinterSettings printerSettings = get(CoreScenarioStorageKeys.KEY_CORE_PRINTER_SETTINGS);
      printerSettingsPage.searchPrinterSettings(printerSettings.getName());
      printerSettingsPage.deletePrinterSettingWithName(printerSettings.getName());
    });
  }

  @When("Operator set printer as default printer")
  public void operatorSetDefaultPrinter() {
    printerSettingsPage.inFrame(() -> {
      PrinterSettings printerSettings = get(CoreScenarioStorageKeys.KEY_CORE_PRINTER_SETTINGS);
      printerSettingsPage.searchPrinterSettings(printerSettings.getName());
      printerSettingsPage.printersTable.setDefaultAction.click();
    });
  }

  @Then("Operator verify Printer Settings is deleted successfully")
  public void operatorVerifyPrinterSettingsIsDeletedSuccessfully() {
    printerSettingsPage.inFrame(() -> {
      PrinterSettings printerSettings = get(CoreScenarioStorageKeys.KEY_CORE_PRINTER_SETTINGS);
      retryIfAssertionErrorOccurred(
          () -> printerSettingsPage.printerSettingWithNameNotDisplayed(printerSettings.getName()),
          "Check if printer record is not displayed",
          2000,
          5
      );
      remove(CoreScenarioStorageKeys.KEY_CORE_PRINTER_SETTINGS);
    });
  }

  @Then("Operator verify Printer Settings is set as default")
  public void operatorVerifyPrinterIsDefault() {
    printerSettingsPage.inFrame(() -> {
      PrinterSettings printerSettings = get(CoreScenarioStorageKeys.KEY_CORE_PRINTER_SETTINGS);
      printerSettingsPage.verifyDefaultPrinter(printerSettings.getName());
    });
  }

  @When("Operator set {string} = {string} for Printer Settings with name = {string}")
  public void operatorEditPrinterSettings(String configName, String configValue,
      String printerSettingsName) {
    printerSettingsPage.inFrame(() -> {
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
    });
  }

  @Then("Operator verify Printer Settings is edited successfully")
  public void operatorVerifyPrinterSettingsIsEditedSuccessfully() {
    printerSettingsPage.inFrame(() -> {
      PrinterSettings printerSettings = get(CoreScenarioStorageKeys.KEY_CORE_PRINTER_SETTINGS);
      printerSettingsPage.printerSettingWithNameOnDisplay(printerSettings.getName());
      printerSettingsPage.checkPrinterSettingInfo(printerSettings);
    });
  }
}
