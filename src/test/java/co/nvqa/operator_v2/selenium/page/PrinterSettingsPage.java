package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.PrinterSettings;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

public class PrinterSettingsPage extends OperatorV2SimplePage {

    private static final String ADD_PRINTER_BUTTON = "//button[@aria-label='Add Printer']";
    private static final String ADD_PRINTER_MODAL = "//md-dialog[md-toolbar[@title='Add Printer']]";
    private static final String PRINTER_NAME_TEXT_FIELD = "//input[@aria-label='Printer Name']";
    private static final String PRINTER_IP_ADDRESS_TEXT_FIELD = "//input[@aria-label='IP Address']";
    private static final String PRINTER_VERSION_TEXT_FIELD = "//input[@aria-label='Version']";
    private static final String PRINTER_DEFAULT_SWITCH = "//md-switch[@aria-label='Is Default Printer?']";
    private static final String SUBMIT_BUTTON = "//nv-button-save/button[@aria-label='Save Button']";
    private static final String NG_REPEAT_TABLE = "printer in $data";
    private static final String CONFIRM_DELETE_BUTTON = "//md-dialog/md-dialog-actions/button[@aria-label='Delete']";
    private static final String SEARCH_TEXT_FIELD = "//md-input-container[contains(@class,'search')]/input";

    public static final String COLUMN_CLASS_NAME = "name";
    public static final String COLUMN_CLASS_IP_ADDRESS = "ip_address";
    public static final String COLUMN_CLASS_VERSION = "version";
    public static final String COLUMN_CLASS_IS_DEFAULT = "is_default";

    private static final String NAME = "name";
    private static final String IP_ADDRESS = "ipAddress";
    private static final String VERSION = "version";
    private static final String DEFAULT = "default";

    public PrinterSettingsPage(WebDriver webDriver) {
        super(webDriver);
    }

    public void clickAddPrinterButtons() {
        click(ADD_PRINTER_BUTTON);
        pause1s();
    }

    public void verifyAddPrinterFormIsDisplayed() {
        WebElement modal = findElementByXpath(ADD_PRINTER_MODAL);
        Assert.assertTrue("Add Printer Label not Shown", modal.isDisplayed());
    }

    public void addPrinter(PrinterSettings printerSettings) {
        fillPrinterName(printerSettings.getName());
        fillPrinterIpAddress(printerSettings.getIpAddress());
        fillPrinterVersion(printerSettings.getVersion());
        switchToDefaultPrinter(printerSettings.isDefaultPrinter());
        clickSubmitButton();
    }

    public void switchToDefaultPrinter(boolean isDefault) {
        WebElement element = findElementByXpath(PRINTER_DEFAULT_SWITCH);
        boolean isChecked = Boolean.parseBoolean(element.getAttribute("aria-checked"));

        if (isDefault!=isChecked) {
            element.click();
            pause300ms();
        }
    }

    public void printerSettingWithNameOnDisplay(String name) {
        boolean isExist = isPrinterSettingsDisplayed(name);
        Assert.assertTrue(String.format("New printer setting with name %s doesn't exist", name), isExist);
    }

    public void checkPrinterSettingInfo(int index, PrinterSettings printerSettings) {
        String actualName = getTextOnTable(index, COLUMN_CLASS_NAME);
        String actualIpAddress = getTextOnTable(index, COLUMN_CLASS_IP_ADDRESS);
        String actualVersion = getTextOnTable(index, COLUMN_CLASS_VERSION);

        Assert.assertEquals("Printer Setting name is incorrect.", printerSettings.getName(), actualName);
        Assert.assertEquals("Printer Setting IP Address is incorrect.", printerSettings.getIpAddress(), actualIpAddress);
        Assert.assertEquals("Printer Setting version is incorrect.", printerSettings.getVersion(), actualVersion);
    }

    public void printerSettingWithNameNotDisplayed(String name) {
        boolean isExist = isPrinterSettingsDisplayed(name);
        Assert.assertFalse(String.format("Printer Setting with name '%s' still exist.", name), isExist);
    }

    public void deletePrinterSettingWithName(String name) {
        searchPrinterSettings(name);
        clickActionButtonInFirstRecord("Delete");
        clickAndWaitUntilDone(CONFIRM_DELETE_BUTTON);
        pause1s();
    }

    public void clickEditPrinterSettingWithName(String name) {
        searchPrinterSettings(name);
        clickActionButtonInFirstRecord("Edit");
    }

    public void editDetails(String rowDetail, String value) {
        if (rowDetail.equalsIgnoreCase(NAME)) {
            fillPrinterName(value);
        } else if (rowDetail.equalsIgnoreCase(IP_ADDRESS)) {
            fillPrinterIpAddress(value);
        } else if (rowDetail.equalsIgnoreCase(VERSION)) {
            fillPrinterVersion(value);
        } else if (rowDetail.equalsIgnoreCase(DEFAULT)) {
            switchToDefaultPrinter(Boolean.parseBoolean(value));
        }
        pause1s();
    }

    public void clickSubmitButton() {
        clickAndWaitUntilDone(SUBMIT_BUTTON);
    }

    private void clickActionButtonInFirstRecord(String buttonAriaLabel) {
        clickButtonOnTableWithNgRepeat(1, "action", buttonAriaLabel, NG_REPEAT_TABLE);
    }

    private boolean isPrinterSettingsDisplayed(String value) {
        searchPrinterSettings(value);
        return !isTableEmpty();
    }

    public boolean isTableEmpty() {
        return !isElementExistFast(String.format("//tr[@ng-repeat='%s'][1]", NG_REPEAT_TABLE));
    }

    public void searchPrinterSettings(String value) {
        sendKeys(SEARCH_TEXT_FIELD, value);
        pause200ms();
    }

    public void fillPrinterName(String name) {
        sendKeys(PRINTER_NAME_TEXT_FIELD, name);
    }

    public void fillPrinterIpAddress(String ip) {
        sendKeys(PRINTER_IP_ADDRESS_TEXT_FIELD, ip);
    }

    public void fillPrinterVersion(String ver) {
        sendKeys(PRINTER_VERSION_TEXT_FIELD, ver);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass) {
        return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT_TABLE);
    }
}
