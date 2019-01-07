package co.nvqa.operator_v2.selenium.page;

import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

/**
 *
 * @author Lanang Jati
 *
 * Modified by Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class ShipmentScanningPage extends OperatorV2SimplePage
{
    public static final String XPATH_HUB_DROPDOWN = "//md-select[@name='hub']";
    public static final String XPATH_SHIPMENT_DROPDOWN = "//md-select[@name='shipment']";
    //public static final String XPATH_HUB_ACTIVE_DROPDOWN = "//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option";
    public static final String XPATH_SELECT_SHIPMENT_BUTTON = "//button[@aria-label='Select Shipment']";
    public static final String XPATH_BARCODE_SCAN = "//input[@id='scan_barcode_input']";
    //public static final String XPATH_ORDER_IN_SHIPMENT = "//td[contains(@class, 'tracking-id')]";
    public static final String XPATH_RACK_SECTOR = "//div[contains(@class,'rack-sector-card')]/div/h2[@ng-show='ctrl.rackInfo']";

    public ShipmentScanningPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void selectHub(String hubName)
    {
        selectValueFromMdSelectById("commons.hub", hubName);
    }

    public void selectShipmentId(String shipmentId)
    {
        selectValueFromMdSelectById("container.shipment-management.shipment-id", shipmentId);
    }

    public void clickSelectShipment()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("container.shipment-scanning.select-shipment");
    }

    public void selectShipmentType(String shipmentType)
    {
        selectValueFromMdSelectById("container.shipment-scanning.shipment-type", shipmentType);
    }

    public void scanBarcode(String trackingId)
    {
        sendKeysAndEnter(XPATH_BARCODE_SCAN, trackingId);
    }

    public void checkOrderInShipment(String orderId)
    {
        String rack = getText(XPATH_RACK_SECTOR);
        Assert.assertTrue("order is " + rack, !rack.equalsIgnoreCase("INVALID") && !rack.equalsIgnoreCase("DUPLICATE"));

        WebElement orderWe = getWebDriver().findElement(By.xpath(String.format("//td[contains(@class, 'tracking-id')][contains(text(), '%s')]", orderId)));
        boolean orderExist = orderWe!=null;
        Assert.assertTrue("order " + orderId + " doesn't exist in shipment", orderExist);
    }
}
