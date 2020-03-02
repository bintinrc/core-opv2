package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.util.TestConstants;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

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
    public static final String XPATH_SCAN_INPUT = "//md-card-content[div[h5[text()='Scan Shipment to Inbound']]]/md-input-container/input";
    public static final String XPATH_CHANGE_END_DATE_BUTTON = "//button[@aria-label='Change End Date']";
    public static final String XPATH_SCANNING_SESSION = "//table/tbody/tr[contains(@ng-repeat,'log in ctrl.scans')]";
    public static final String XPATH_SCANNING_SESSION_NO_CHANGE = XPATH_SCANNING_SESSION;
    public static final String XPATH_SCANNING_SESSION_CHANGE = XPATH_SCANNING_SESSION + "[contains(@class,'changed')]";
    public static final String XPATH_CHANGE_DATE_BUTTON = "//button[@aria-label='Change Date']";

    @FindBy(xpath = "//md-select[contains(@id,'inbound-hub')]")
    public MdSelect inboundHub;

    public ShipmentInboundScanningPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void selectHub(String hubName)
    {
        inboundHub.searchAndSelectValue(hubName);
    }

    public void inboundScanning(Long shipmentId, String label, String hub)
    {
        selectHub(hub);
        click(grabXpathButton(label));
        clickStartInbound();

        inputShipmentToInbound(shipmentId);
        checkSessionScan(shipmentId);
    }

    public void inboundScanningUsingMawb(Long shipmentId, String mawb, String label, String hub)
    {
        selectHub(hub);
        click(grabXpathButton(label));
        clickStartInbound();

        inputShipmentToInboundUsingMawb(mawb);
        checkSessionScan(shipmentId);
    }

    public void inboundScanningNegativeScenario(Long shipmentId, String label, String hub, String condition)
    {
        selectHub(hub);
        click(grabXpathButton(label));
        clickStartInbound();

        inputShipmentToInbound(shipmentId);
        checkAlert(shipmentId, condition);
    }

    public void clickStartInbound(){
        clickNvIconTextButtonByNameAndWaitUntilDone("container.inbound-scanning.start-inbound");
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

    public void inputShipmentToInbound(Long shipmentId)
    {
        sendKeysAndEnter(XPATH_SCAN_INPUT, String.valueOf(shipmentId));
    }

    public void inputShipmentToInboundUsingMawb(String mawb)
    {
        sendKeysAndEnter(XPATH_SCAN_INPUT, mawb);
    }

    public void checkSessionScan(Long shipmentId)
    {
        waitUntilVisibilityOfElementLocated(XPATH_SCANNING_SESSION_NO_CHANGE + String.format("[td[contains(@class,'sn')][text()='1']][td[@class='shipmentId'][text()='%s']]", String.valueOf(shipmentId)));
    }

    public void checkEndDateSessionScanChange(List<String> mustCheckId, Date endDate)
    {
        String formattedEndDate = MD_DATEPICKER_SDF.format(endDate);

        for(String shipmentId : mustCheckId)
        {
            waitUntilVisibilityOfElementLocated(XPATH_SCANNING_SESSION_CHANGE + f("[td[contains(@class,'sn')][text()='%s']][td[contains(@class,'end-date')][text()='%s']]", shipmentId, formattedEndDate));
        }
    }

    public void inputEndDate(Date date)
    {
        setMdDatepicker("ctrl.date", date);
    }

    private void checkAlert(Long shipmentId, String condition)
    {
        waitUntilVisibilityOfElementLocated("//input[contains(@ng-model,'ctrl.shipmentId')]/following-sibling::span");
        String errorMessage = getText("//input[contains(@ng-model,'ctrl.shipmentId')]/following-sibling::span");
        switch (condition) {
            case "Completed" :
                assertEquals("Error Message is not the same : ", errorMessage, f("shipment %d is in terminal state: [%s]", shipmentId, condition));
                break;

            case "Cancelled" :
                assertEquals("Error Message is not the same : ", errorMessage, f("shipment %d is in terminal state: [%s]", shipmentId, condition));
                break;

            case "different country van" :
                assertEquals("Error Message is not the same : ", errorMessage, f("Mismatched hub system ID: shipment origin hub system ID %s and scan hub system ID id are not the same.", TestConstants.COUNTRY_CODE.toLowerCase()));
                break;

            case "different country hub" :
                assertEquals("Error Message is not the same : ", errorMessage, f("Mismatched hub system ID: shipment destination hub system ID %s and scan hub system ID id are not the same.", TestConstants.COUNTRY_CODE.toLowerCase()));
                break;

            case "pending shipment" :
                assertEquals("Error Message is not the same : ", errorMessage, f("shipment %d is [Pending], please inbound into van first", shipmentId));
                break;

            case "closed shipment" :
                assertEquals("Error Message is not the same : ", errorMessage, f("shipment %d is [Closed], please inbound into van first", shipmentId));
                break;
        }
    }
}
