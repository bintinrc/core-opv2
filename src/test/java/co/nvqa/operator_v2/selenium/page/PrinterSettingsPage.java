package co.nvqa.operator_v2.selenium.page;

import org.junit.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

public class PrinterSettingsPage extends SimplePage {

    private static final String ADD_PRINTER_BUTTON = "//button[@aria-label='Add Printer']";
    private static final String ADD_PRINTER_MODAL = "//md-dialog[md-toolbar[@title='Add Printer']]";
    private static final String PRINTER_NAME_TEXT_FIELD = "//input[@aria-label='Printer Name']";
    private static final String PRINTER_IP_ADDRESS_TEXT_FIELD = "//input[@aria-label='IP Address']";
    private static final String PRINTER_VERSION_TEXT_FIELD = "//input[@aria-label='Version']";
    private static final String PRINTER_DEFAULT_SWITCH = "//md-switch[@aria-label='Is Default Printer?']";
    private static final String SUBMIT_BUTTON = "//nv-button-save/button[@aria-label='Save Button']";
    private static final String NG_REPEAT_TABLE = "printer in $data";
    private static final String CONFIRM_DELETE_BUTTON = "//md-dialog/md-dialog-actions/button[@aria-label='Delete']";

    private static final String NAME = "name";
    private static final String IP_ADDRESS = "ip";
    private static final String VERSION = "version";
    private static final String DEFAULT = "default";

    public PrinterSettingsPage(WebDriver webDriver) {
        super(webDriver);
    }

    public void clickAddPrinterButtons() {
        click(ADD_PRINTER_BUTTON);
        pause1s();
    }

    public void addPrinterModalOnDisplay() {
        WebElement modal = findElementByXpath(ADD_PRINTER_MODAL);
        Assert.assertTrue("Add Printer Label not Shown", modal.isDisplayed());
    }

    public void fillPrinterName(String name) {
        sendKeys(PRINTER_NAME_TEXT_FIELD, name);
    }

    public void fillPrinterIp(String ip) {
        sendKeys(PRINTER_IP_ADDRESS_TEXT_FIELD, ip);
    }

    public void fillPrinterVersion(String ver) {
        sendKeys(PRINTER_VERSION_TEXT_FIELD, ver);
    }

    public void switchToDefaultPrinter(String isDefault) {
        WebElement element = findElementByXpath(PRINTER_DEFAULT_SWITCH);
        String checked = element.getAttribute("aria-checked");
        if (!checked.equalsIgnoreCase(isDefault)) {
            element.click();
            pause300ms();
        }

    }

    public void clickSubmitButton() {
        clickAndWaitUntilDone(SUBMIT_BUTTON);
    }

    private boolean isPrinterSettingsDisplayed(String detailName, String value) {
        int size = findElementsByXpath(String.format("//tr[@ng-repeat='%s']", NG_REPEAT_TABLE)).size();
        boolean exist = false;

        for (int i = 1; i <= size; i++){
            String actualName = getTextOnTableWithNgRepeat(i, detailName, NG_REPEAT_TABLE);
            if (actualName.equals(value)) {
                exist = true;
                break;
            }
        }

        return exist;
    }

    public void printerSettingWithNameOnDisplay(String name) {
        boolean isExist = isPrinterSettingsDisplayed("name", name);
        Assert.assertTrue(String.format("New printer setting with name %s doesn't exist", name), isExist);
    }

    public void printerSettingWithIPOnDisplay(String ip) {
        boolean isExist = isPrinterSettingsDisplayed("ip_address", ip);
        Assert.assertTrue(String.format("New printer setting with IP %s doesn't exist", ip), isExist);
    }

    public void printerSettingWithVersionOnDisplay(String version) {
        boolean isExist = isPrinterSettingsDisplayed("version", version);
        Assert.assertTrue(String.format("New printer setting with IP %s doesn't exist", version), isExist);
    }

    public void printerSettingWithNameNotDisplayed(String name) {
        boolean isExist = isPrinterSettingsDisplayed("name", name);
        Assert.assertFalse(String.format("New printer setting with name %s exist", name), isExist);
    }

    private void clickActionButtonInRecord(String rowName, String rowValue, String buttonAriaLabel) {
        int size = findElementsByXpath(String.format("//tr[@ng-repeat='%s']", NG_REPEAT_TABLE)).size();
        int i;
        for (i = 1 ; i <= size; i++){
            String actualName = getTextOnTableWithNgRepeat(i, rowName, NG_REPEAT_TABLE);
            if (actualName.equals(rowValue)) {
                clickButtonOnTableWithNgRepeat(i, "action", buttonAriaLabel, NG_REPEAT_TABLE);
                break;
            }
        }

        Assert.assertTrue(String.format("Printer setting with %s is %s not exist", rowName, rowValue), i <= size);
    }

    public void deletePrinterSettingWithName(String name) {
        clickActionButtonInRecord(NAME, name, "Delete");
        clickAndWaitUntilDone(CONFIRM_DELETE_BUTTON);
    }

    public void clickEditPrinterSettingWithName(String name) {
        clickActionButtonInRecord(NAME, name, "Edit");
    }

    public void editDetails(String rowDetail, String value) {
        if (rowDetail.equalsIgnoreCase(NAME)) {
            fillPrinterName(value);
        } else if (rowDetail.equalsIgnoreCase(IP_ADDRESS)) {
            fillPrinterIp(value);
        } else if (rowDetail.equalsIgnoreCase(VERSION)) {
            fillPrinterVersion(value);
        } else if (rowDetail.equalsIgnoreCase(DEFAULT)) {
            switchToDefaultPrinter(value);
        }
    }
}
