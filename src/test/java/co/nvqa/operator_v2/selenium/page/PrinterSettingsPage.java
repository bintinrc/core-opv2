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
    private static final String SUBMIT_BUTTON = "//nv-button-save[@name='Submit']";
    private static final String NG_REPEAT_TABLE = "printer in $data";

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

    public void printerSettingWithNameOnDisplay(String name) {
        int size = findElementsByXpath(String.format("//tr[@ng-repeat='%s']", NG_REPEAT_TABLE)).size();
        boolean exist = false;

        for (int i = 1; i <= size; i++){
            String actualName = getTextOnTableWithNgRepeat(i, "name", NG_REPEAT_TABLE);
            if (actualName.equals(name)) {
                exist = true;
                break;
            }
        }

        Assert.assertTrue(String.format("New printer setting with name %s doesn't exist", name), exist);
    }

    public void deletePrinterSettingWithName(String name) {
        int size = findElementsByXpath(String.format("//tr[@ng-repeat='%s']", NG_REPEAT_TABLE)).size();

        for (int i = 1; i <= size; i++){
            String actualName = getTextOnTableWithNgRepeat(i, "name", NG_REPEAT_TABLE);
            if (actualName.equals(name)) {
                clickButtonOnTableWithNgRepeat(i, "action", "Delete", NG_REPEAT_TABLE);
                break;
            }
        }
    }
}
