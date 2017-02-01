package com.nv.qa.selenium.page;

import com.nv.qa.support.CommonUtil;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

/**
 * Created by lanangjati
 * on 9/26/16.
 */
public class ShipmentScanningPage {

    private final WebDriver driver;
    public static final String XPATH_HUB_DROPDOWN = "//md-select[@name='hub']";
    public static final String XPATH_SHIPMENT_DROPDOWN = "//md-select[@name='shipment']";
    public static final String XPATH_HUB_ACTIVE_DROPDOWN = "//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option";
    public static final String XPATH_SELECT_SHIPMENT_BUTTON = "//button[@aria-label='Select Shipment']";
    public static final String XPATH_BARCODE_SCAN = "//input[@id='scan_barcode_input']";
    public static final String XPATH_ORDER_IN_SHIPMENT = "//td[@class='tracking-id ng-binding']";
    public static final String XPATH_RACK_SECTOR = "//div[contains(@class,'rack-sector-card')]/div/h2[@ng-show='ctrl.rackInfo']";

    public ShipmentScanningPage(WebDriver driver) {
        this.driver = driver;
        PageFactory.initElements(driver, this);
    }

    public void selectHub(String hubName) {
        CommonUtil.clickBtn(driver, XPATH_HUB_DROPDOWN);
        CommonUtil.pause50ms();
        selectDropdownValue(hubName);
        CommonUtil.pause50ms();
    }

    public void selectShipment(String shipmentId) {
        CommonUtil.clickBtn(driver, XPATH_SHIPMENT_DROPDOWN);
        CommonUtil.pause50ms();
        selectDropdownValue(shipmentId);
        CommonUtil.pause50ms();
        CommonUtil.clickBtn(driver, XPATH_SELECT_SHIPMENT_BUTTON);
    }

    private void selectDropdownValue(String value) {
        CommonUtil.clickBtn(driver, XPATH_HUB_ACTIVE_DROPDOWN + "[div[text()=' " + value + " ']]");
    }

    public void checkOrderInShipment(String orderId) {
        String rack = driver.findElement(By.xpath(XPATH_RACK_SECTOR)).getText();
        Assert.assertTrue("order is " + rack, !rack.equalsIgnoreCase("INVALID") && !rack.equalsIgnoreCase("DUPLICATE"));

        WebElement order = driver.findElement(By.xpath(XPATH_ORDER_IN_SHIPMENT + "[text()='" + orderId + "']"));
        Assert.assertEquals("order in shipment", orderId, order.getText());
    }
}
