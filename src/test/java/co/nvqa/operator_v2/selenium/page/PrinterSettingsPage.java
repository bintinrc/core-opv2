package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.core.model.PrinterSettings;
import co.nvqa.common.utils.NvSoftAssertions;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.akira.AkiraModal;
import co.nvqa.operator_v2.selenium.elements.akira.AkiraSelect;
import co.nvqa.operator_v2.selenium.elements.akira.DynamicTable;
import org.assertj.core.api.Assertions;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Lanang Jati
 */
@SuppressWarnings("WeakerAccess")
public class PrinterSettingsPage extends SimpleAkiraPage<PrinterSettingsPage> {

  @FindBy(css = "[data-testid='add-printer-button']")
  public Button addPrinterButton;

  @FindBy(xpath = "//*[contains(@id,'headlessui-dialog-panel')]")
  public AddPrinterDialog addPrinterDialog;

  @FindBy(xpath = "//div[contains(@id,\"headlessui-listbox-button\")]")
  public AkiraSelect selectByField;

  @FindBy(css = "[data-testid='search-bar']")
  public ForceClearTextBox searchBar;

  @FindBy(xpath = "//*[contains(@id,'headlessui-dialog-panel')]")
  public EditPrinterDialog editPrinterDialog;

  @FindBy(xpath = "//*[contains(@id,'headlessui-dialog-panel')]")
  public ConfirmDeleteDialog confirmDeleteDialog;

  @FindBy(xpath = "//table")
  public PrintersTable printersTable;

  private static final String NAME = "name";
  private static final String IP_ADDRESS = "ipaddress";
  private static final String VERSION = "version";
  private static final String DEFAULT = "default";

  public PrinterSettingsPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void clickAddPrinterButtons() {
    addPrinterButton.click();
  }

  public void verifyAddPrinterFormIsDisplayed() {
    Assertions.assertThat(addPrinterDialog.title.getText()).as("Add Printer Label not Shown")
        .isEqualTo("Add printer");
  }

  public void addPrinter(PrinterSettings printerSettings) {
    addPrinterDialog.printerName.setValue(printerSettings.getName());
    addPrinterDialog.ipAddress.setValue(printerSettings.getIpAddress());
    addPrinterDialog.versionSelect.selectValueWithoutClose(printerSettings.getVersion());
    if (printerSettings.isDefault()) {
      addPrinterDialog.isDefaultPrinter.click();
    }
    addPrinterDialog.submit.click();
  }

  public void printerSettingWithNameOnDisplay(String name) {
    boolean isExist = isPrinterSettingsDisplayed(name);
    Assertions.assertThat(isExist).as(f("New printer setting with name %s doesn't exist", name))
        .isTrue();
  }

  public void printerSettingWithNameNotDisplayed(String name) {
    boolean isExist = isPrinterSettingsDisplayed(name);
    Assertions.assertThat(isExist).as(f("Printer Setting with name '%s' still exist.", name))
        .isFalse();
  }

  public void deletePrinterSettingWithName(String name) {
    searchPrinterSettings(name);
    printersTable.deleteAction.click();
    Assertions.assertThat(confirmDeleteDialog.title.getText()).as("confirm delete dialog displayed")
        .isEqualTo("Confirm delete");
    Assertions.assertThat(confirmDeleteDialog.description.getText())
        .as("confirm delete dialog description")
        .isEqualTo("Are you sure you want to permanently delete \"%s\"?", name);
    confirmDeleteDialog.delete.click();
    pause1s();
  }

  public void clickEditPrinterSettingWithName(String name) {
    searchPrinterSettings(name);
    printersTable.editAction.click();
  }

  public void editDetails(String paramName, String value) {
    editPrinterDialog.waitUntilVisible();
    switch (paramName.toLowerCase()) {
      case NAME:
        editPrinterDialog.printerName.setValue(value);
        break;
      case IP_ADDRESS:
        editPrinterDialog.ipAddress.setValue(value);
        break;
      case VERSION:
        editPrinterDialog.versionSelect.selectValueWithoutClose(value);
        break;
      case DEFAULT:
        if (Boolean.parseBoolean(value)) {
          editPrinterDialog.isDefaultPrinter.click();
        }
    }
    pause1s();
  }

  public void clickSubmitButton() {
    editPrinterDialog.submitChanges.click();
  }

  private boolean isPrinterSettingsDisplayed(String value) {
    searchPrinterSettings(value);
    return isElementExist("//*[@id='root']//table/tbody/tr[1]");
  }

  public void searchPrinterSettings(String value) {
    searchBar.clearAndSendKeys(value);
  }

  public void checkPrinterSettingInfo(PrinterSettings printerSettings) {
    NvSoftAssertions softly = new NvSoftAssertions();
    softly.assertEquals("name column", printersTable.nameColumn.getText(),
        printerSettings.getName());
    softly.assertEquals("ip address column", printersTable.ipAddress.getText(),
        printerSettings.getIpAddress());
    softly.assertEquals("version column", printersTable.version.getText(),
        printerSettings.getVersion());
    softly.assertEquals("default column", printersTable.isDefault.getText(),
        Boolean.toString(printerSettings.isDefault()));
    softly.assertAll();
  }

  public void verifyDefaultPrinter(String name) {
    searchPrinterSettings(name);
    Assert.assertTrue("Button is not displayed", printersTable.alreadySetToDefault.isDisplayed());
  }

  public static class AddPrinterDialog extends AkiraModal {

    @FindBy(css = "[data-testid='name-input']")
    public TextBox printerName;

    @FindBy(css = "[data-testid='ip_address-input']")
    public TextBox ipAddress;

    @FindBy(xpath = "(//button[contains(@id,'headlessui-listbox-button')])[1]")
    public AkiraSelect versionSelect;

    @FindBy(xpath = "//input[@data-testid='toggle-is-default']/following-sibling::div")
    public PageElement isDefaultPrinter;

    @FindBy(css = "[data-testid='modal-submit-button']")
    public Button submit;

    public AddPrinterDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class EditPrinterDialog extends AkiraModal {

    @FindBy(css = "[data-testid='name-input']")
    public TextBox printerName;

    @FindBy(css = "[data-testid='ip_address-input']")
    public TextBox ipAddress;

    @FindBy(xpath = "(//button[contains(@id,'headlessui-listbox-button')])[1]")
    public AkiraSelect versionSelect;

    @FindBy(xpath = "//input[@data-testid='toggle-is-default']/following-sibling::div")
    public PageElement isDefaultPrinter;

    @FindBy(css = "[data-testid='modal-submit-button']")
    public Button submitChanges;

    public EditPrinterDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class PrintersTable extends DynamicTable<PrintersTable> {

    @FindBy(css = "[data-testid^='edit-button']")
    public Button editAction;

    @FindBy(css = "[data-testid^='delete-button']")
    public Button deleteAction;

    @FindBy(css = "[data-testid^='set-as-default-button']")
    public Button setDefaultAction;

    @FindBy(css = "[data-testid^='already-set-as-default-button']")
    public Button alreadySetToDefault;

    @FindBy(xpath = "//*[@id='root']//table/tbody/tr/td[2]")
    public PageElement nameColumn;

    @FindBy(xpath = "//*[@id='root']//table/tbody/tr/td[3]")
    public PageElement ipAddress;

    @FindBy(xpath = "//*[@id='root']//table/tbody/tr/td[4]")
    public PageElement version;

    @FindBy(xpath = "//*[@id='root']//table/tbody/tr/td[5]")
    public PageElement isDefault;

    public PrintersTable(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class ConfirmDeleteDialog extends AkiraModal {

    @FindBy(xpath = "//div[@data-testid='confirm-delete-modal']//p")
    public PageElement description;

    @FindBy(css = "[data-testid='modal-delete-button']")
    public Button delete;

    public ConfirmDeleteDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}
