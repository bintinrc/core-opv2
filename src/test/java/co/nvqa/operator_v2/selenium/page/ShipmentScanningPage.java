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
public class ShipmentScanningPage extends SimplePage
{
    public static final String XPATH_HUB_DROPDOWN = "//md-select[@name='hub']";
    public static final String XPATH_SHIPMENT_DROPDOWN = "//md-select[@name='shipment']";
    public static final String XPATH_HUB_ACTIVE_DROPDOWN = "//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option";
    public static final String XPATH_SELECT_SHIPMENT_BUTTON = "//button[@aria-label='Select Shipment']";
    public static final String XPATH_BARCODE_SCAN = "//input[@id='scan_barcode_input']";
    public static final String XPATH_ORDER_IN_SHIPMENT = "//td[contains(@class, 'tracking-id')]";
    public static final String XPATH_RACK_SECTOR = "//div[contains(@class,'rack-sector-card')]/div/h2[@ng-show='ctrl.rackInfo']";

    public ShipmentScanningPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void selectHub(String hubName)
    {
        click(XPATH_HUB_DROPDOWN);
        pause1s();
        selectDropdownValue(hubName);
        pause1s();
    }

    public void selectShipment(String shipmentId)
    {
        pause3s();
        click(XPATH_SHIPMENT_DROPDOWN);
        pause500ms();
        selectDropdownValue(shipmentId);
        pause500ms();
        click(XPATH_SELECT_SHIPMENT_BUTTON);
    }

    public void scanBarcode(String trackingId)
    {
        sendKeysAndEnter(XPATH_BARCODE_SCAN, trackingId);
    }

    private void selectDropdownValue(String value)
    {
        click(String.format("//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option/div[contains(text(), '%s')]", value));
    }

    public void checkOrderInShipment(String orderId)
    {
        String rack = getwebDriver().findElement(By.xpath(XPATH_RACK_SECTOR)).getText();
        Assert.assertTrue("order is " + rack, !rack.equalsIgnoreCase("INVALID") && !rack.equalsIgnoreCase("DUPLICATE"));

        WebElement orderWe = getwebDriver().findElement(By.xpath(String.format("//td[contains(@class, 'tracking-id')][contains(text(), '%s')]", orderId)));
        boolean orderExist = orderWe!=null;
        Assert.assertTrue("order " + orderId + " doesn't exist in shipment", orderExist);
    }
}
