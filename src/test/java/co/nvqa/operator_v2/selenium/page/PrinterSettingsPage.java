package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.PrinterSettings;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.md.MdSwitch;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Lanang Jati
 */
@SuppressWarnings("WeakerAccess")
public class PrinterSettingsPage extends OperatorV2SimplePage
{
    @FindBy(name = "Add Printer")
    public NvIconTextButton addPrinterButton;

    @FindBy(css = "md-dialog")
    public AddPrinterDialog addPrinterDialog;

    @FindBy(css = "md-dialog")
    public EditPrinterDialog editPrinterDialog;

    @FindBy(css = "md-dialog")
    public ConfirmDeleteDialog confirmDeleteDialog;

    public PrintersTable printersTable;

    private static final String NAME = "name";
    private static final String IP_ADDRESS = "ipaddress";
    private static final String VERSION = "version";
    private static final String DEFAULT = "default";

    public PrinterSettingsPage(WebDriver webDriver)
    {
        super(webDriver);
        printersTable = new PrintersTable(webDriver);
    }

    public void clickAddPrinterButtons()
    {
        addPrinterButton.click();
    }

    public void verifyAddPrinterFormIsDisplayed()
    {
        addPrinterDialog.waitUntilVisible();
        assertTrue("Add Printer Label not Shown", addPrinterDialog.isDisplayed());
    }

    public void addPrinter(PrinterSettings printerSettings)
    {
        addPrinterDialog.waitUntilVisible();
        addPrinterDialog.printerName.setValue(printerSettings.getName());
        addPrinterDialog.ipAddress.setValue(printerSettings.getIpAddress());
        addPrinterDialog.version.selectByValue(printerSettings.getVersion());
        addPrinterDialog.isDefaultPrinter.setValue(printerSettings.getIsDefault());
        addPrinterDialog.submit.clickAndWaitUntilDone();
        addPrinterDialog.waitUntilInvisible();
    }

    public void printerSettingWithNameOnDisplay(String name)
    {
        boolean isExist = isPrinterSettingsDisplayed(name);
        assertTrue(f("New printer setting with name %s doesn't exist", name), isExist);
    }

    public void checkPrinterSettingInfo(int index, PrinterSettings printerSettings)
    {
        PrinterSettings actual = printersTable.readEntity(index);
        printerSettings.compareWithActual(actual, "id");
    }

    public void printerSettingWithNameNotDisplayed(String name)
    {
        boolean isExist = isPrinterSettingsDisplayed(name);
        assertFalse(f("Printer Setting with name '%s' still exist.", name), isExist);
    }

    public void deletePrinterSettingWithName(String name)
    {
        searchPrinterSettings(name);
        printersTable.clickActionButton(1, PrintersTable.ACTION_DELETE);
        confirmDeleteDialog.confirmDelete();
        pause1s();
    }

    public void clickEditPrinterSettingWithName(String name)
    {
        searchPrinterSettings(name);
        printersTable.clickActionButton(1, PrintersTable.ACTION_EDIT);
    }

    public void editDetails(String paramName, String value)
    {
        editPrinterDialog.waitUntilVisible();
        switch (paramName.toLowerCase())
        {
            case NAME:
                editPrinterDialog.printerName.setValue(value);
                break;
            case IP_ADDRESS:
                editPrinterDialog.ipAddress.setValue(value);
                break;
            case VERSION:
                editPrinterDialog.version.searchAndSelectValue(value);
                break;
            case DEFAULT:
                editPrinterDialog.isDefaultPrinter.setValue(Boolean.parseBoolean(value));
        }
        pause1s();
    }

    public void clickSubmitButton()
    {
        editPrinterDialog.submitChanges.clickAndWaitUntilDone();
    }

    private boolean isPrinterSettingsDisplayed(String value)
    {
        searchPrinterSettings(value);
        return !printersTable.isEmpty();
    }

    public void searchPrinterSettings(String value)
    {
        printersTable.filterByColumn("name", value);
    }

    public static class AddPrinterDialog extends MdDialog
    {
        public AddPrinterDialog(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }

        @FindBy(css = "[id^='printer-name']")
        public TextBox printerName;

        @FindBy(css = "[id^='ip-address/-printer-identifier']")
        public TextBox ipAddress;

        @FindBy(css = "[id^='version']")
        public MdSelect version;

        @FindBy(css = "[id^='is-default-printer?']")
        public MdSwitch isDefaultPrinter;

        @FindBy(name = "Submit")
        public NvButtonSave submit;
    }

    public static class EditPrinterDialog extends MdDialog
    {
        public EditPrinterDialog(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }

        @FindBy(css = "[id^='printer-name']")
        public TextBox printerName;

        @FindBy(css = "[id^='ip-address/-printer-identifier']")
        public TextBox ipAddress;

        @FindBy(css = "[id^='version']")
        public MdSelect version;

        @FindBy(css = "[id^='is-default-printer?']")
        public MdSwitch isDefaultPrinter;

        @FindBy(name = "Submit Changes")
        public NvButtonSave submitChanges;
    }

    public static class PrintersTable extends MdVirtualRepeatTable<PrinterSettings>
    {
        public static final String ACTION_EDIT = "Edit";
        public static final String ACTION_DELETE = "Delete";

        public PrintersTable(WebDriver webDriver)
        {
            super(webDriver);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put("name", "name")
                    .put("ipAddress", "ip_address")
                    .put("version", "version")
                    .put("isDefault", "is_default")
                    .build()
            );
            setEntityClass(PrinterSettings.class);
            setActionButtonsLocators(ImmutableMap.of(
                    ACTION_EDIT, "Edit",
                    ACTION_DELETE, "Delete"));
        }
    }
}
