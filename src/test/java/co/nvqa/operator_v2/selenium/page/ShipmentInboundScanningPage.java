package co.nvqa.operator_v2.selenium.page;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

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
    public static final String XPATH_SCANNING_SESSION = "//table/tbody/tr[contains(@ng-repeat,'log in ctrl.scans')]";
    public static final String XPATH_SCANNING_SESSION_NO_CHANGE = XPATH_SCANNING_SESSION;
    public static final String XPATH_SCANNING_SESSION_CHANGE = XPATH_SCANNING_SESSION + "[contains(@class,'changed')]";
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

    public void inboundScanning(String shipmentId, String label, String hub)
    {
        selectHub(hub);
        click(grabXpathButton(label));
        click(grabXpathButton("Start Inbound"));

        inputShipmentToInbound(shipmentId);
        checkSessionScan(shipmentId);
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
        List<WebElement> scans = findElementsByXpath(XPATH_SCANNING_SESSION_NO_CHANGE + "/td[contains(@class,'sn')]");
        List<String> result = scans.stream().map(WebElement::getText).collect(Collectors.toList());
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
        sendKeysAndEnter(XPATH_SCAN_INPUT, shipmentId);
    }

    public void checkSessionScan(String shipmentId)
    {
        waitUntilVisibilityOfElementLocated(XPATH_SCANNING_SESSION_NO_CHANGE + String.format("[td[contains(@class,'sn')][text()='1']][td[@class='shipmentId'][text()='%s']]", shipmentId));
    }

    public void checkEndDateSessionScanChange(List<String> mustCheckId, Date endDate)
    {
        String formattedEndDate = MD_DATEPICKER_SDF.format(endDate);

        for(String shipmentId : mustCheckId)
        {
            waitUntilVisibilityOfElementLocated(XPATH_SCANNING_SESSION_CHANGE + String.format("[td[contains(@class,'sn')][text()='%s']][td[contains(@class,'end-date')][text()='%s']]", shipmentId, formattedEndDate));
        }
    }

    public void inputEndDate(Date date)
    {
        setMdDatepicker("ctrl.date", date);
    }
}
