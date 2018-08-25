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
@SuppressWarnings("WeakerAccess")
public class ShipmentInboundScanningPage extends OperatorV2SimplePage
{
    public static final String LOCATOR_HUB_DROPDOWN = "inbound-hub";
    public static final String XPATH_SCAN_INPUT = "//md-card-content[div[h5[text()='Scan Shipment to Inbound']]]/md-input-container/input";
    public static final String XPATH_CHANGE_END_DATE_BUTTON = "//button[@aria-label='Change End Date']";
    public static final String XPATH_SCANNING_SESSION = "//table/tbody/tr[contains(@ng-repeat,'log in ctrl.scans')]";
    public static final String XPATH_SCANNING_SESSION_NO_CHANGE = XPATH_SCANNING_SESSION;
    public static final String XPATH_SCANNING_SESSION_CHANGE = XPATH_SCANNING_SESSION + "[contains(@class,'changed')]";
    public static final String XPATH_CHANGE_DATE_BUTTON = "//button[@aria-label='Change Date']";

    public ShipmentInboundScanningPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void selectHub(String hubName)
    {
        selectValueFromMdSelectById(LOCATOR_HUB_DROPDOWN, hubName);
    }

    public void inboundScanning(String shipmentId, String label, String hub)
    {
        selectHub(hub);
        click(grabXpathButton(label));
        click(grabXpathButton("Start Inbound"));

        inputShipmentToInbound(shipmentId);
        checkSessionScan(shipmentId);
    }

    public String grabXpathButton(String label)
    {
        return "//button[span[text()='" + label + "']]";
    }

    public List<String> grabSessionIdNotChangedScan()
    {
        List<WebElement> scans = findElementsByXpath(XPATH_SCANNING_SESSION_NO_CHANGE + "/td[contains(@class,'sn')]");
        return scans.stream().map(WebElement::getText).collect(Collectors.toList());
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
