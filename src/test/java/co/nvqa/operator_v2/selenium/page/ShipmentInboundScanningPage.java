package co.nvqa.operator_v2.selenium.page;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Lanang Jati
 *
 * Modified by Daniel Joi Partogi Hutapea
 */
public class ShipmentInboundScanningPage extends SimplePage
{
    public static final String XPATH_HUB_DROPDOWN = "//md-select[md-select-value[span[text()='Inbound Hub']]]";
    public static final String XPATH_HUB_ACTIVE_DROPDOWN = "//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option";
    public static final String XPATH_SCAN_INPUT = "//md-card-content[div[h5[text()='Scan Shipment to Inbound']]]/md-input-container/input";
    public static final String XPATH_CHANGE_END_DATE_BUTTON = "//button[@aria-label='Change End Date']";
    public static final String XPATH_SCANNING_SESSION = "//table/tbody/tr";
    public static final String XPATH_SCANNING_SESSION_NO_CHANGE = XPATH_SCANNING_SESSION;
    public static final String XPATH_SCANNING_SESSION_CHANGE = XPATH_SCANNING_SESSION + "[@class='ng-scope changed']";
    public static final String XPATH_DATE_INPUT = "//input[@class='md-datepicker-input']";
    public static final String XPATH_CHANGE_DATE_BUTTON = "//button[@aria-label='Change Date']";

    public ShipmentInboundScanningPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void selectHub(String hubName)
    {
        click(XPATH_HUB_DROPDOWN);
        pause100ms();
        selectDropdownValue(hubName);
    }

    private void selectDropdownValue(String value)
    {
        click(XPATH_HUB_ACTIVE_DROPDOWN + "[div[text()=' " + value + " ']]");
    }

    public String grabXpathButton(String label)
    {
        return "//button[span[text()='" + label + "']]";
    }

    public List<String> grabSessionIdNotChangedScan()
    {
        List<String> result = new ArrayList<>();
        List<WebElement> scans = getwebDriver().findElements(By.xpath(XPATH_SCANNING_SESSION_NO_CHANGE + "/td[@class='sn ng-binding']"));

        for(WebElement scan : scans)
        {
            result.add(scan.getText());
        }

        return result;
    }

    public void clickEditEndDate()
    {
        click(XPATH_CHANGE_END_DATE_BUTTON);
    }

    public void clickChangeDateButton()
    {
        click(XPATH_CHANGE_DATE_BUTTON);
    }

    public void inputShipmentToInbound(String shipmentId)
    {
        sendKeys(XPATH_SCAN_INPUT, shipmentId + "\n");
    }

    public void checkSessionScan(String shipmentId)
    {
        waitUntilVisibilityOfElementLocated(XPATH_SCANNING_SESSION_NO_CHANGE + "[td[@class='sn'][text()='1']][td[@class='shipmentId'][text()='" + shipmentId + "']]");
    }

    public void checkEndDateSessionScanChange(List<String> mustCheckId, String endDate)
    {
        for(String id : mustCheckId)
        {
            waitUntilVisibilityOfElementLocated(XPATH_SCANNING_SESSION_CHANGE + "[td[@class='sn ng-binding'][text()='" + id + "']][td[@class='end-date ng-binding'][text()='" + endDate + "']]");
        }
    }

    public void inputEndDate(String newDate)
    {
        sendKeys(XPATH_DATE_INPUT, newDate);
    }
}
