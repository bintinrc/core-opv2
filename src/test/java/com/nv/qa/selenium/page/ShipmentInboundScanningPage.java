package com.nv.qa.selenium.page;

import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.SeleniumHelper;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by lanangjati
 * on 10/5/16.
 */
public class ShipmentInboundScanningPage {

    private final WebDriver driver;

    public static final String XPATH_HUB_DROPDOWN = "//md-select[md-select-value[span[text()='Inbound Hub']]]";
    public static final String XPATH_HUB_ACTIVE_DROPDOWN = "//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option";
    public static final String XPATH_SCAN_INPUT = "//md-card-content[div[h5[text()='Scan Shipment to Inbound']]]/md-input-container/input";
    public static final String XPATH_CHANGE_END_DATE_BUTTON = "//button[@aria-label='Change End Date']";
    public static final String XPATH_SCANNING_SESSION = "//table/tbody/tr";
    public static final String XPATH_SCANNING_SESSION_NO_CHANGE = XPATH_SCANNING_SESSION + "[@class='ng-scope']";
    public static final String XPATH_SCANNING_SESSION_CHANGE = XPATH_SCANNING_SESSION + "[@class='ng-scope changed']";
    public static final String XPATH_DATE_INPUT = "//input[@class='md-datepicker-input']";
    public static final String XPATH_CHANGE_DATE_BUTTON = "//button[@aria-label='Change Date']";

    public ShipmentInboundScanningPage(WebDriver driver) {
        this.driver = driver;
        PageFactory.initElements(driver, this);
    }

    public void selectHub(String hubName) {
        CommonUtil.clickBtn(driver, XPATH_HUB_DROPDOWN);

        CommonUtil.pause10ms();

        selectDropdownValue(hubName);
    }

    private void selectDropdownValue(String value) {
        CommonUtil.clickBtn(driver, XPATH_HUB_ACTIVE_DROPDOWN + "[div[text()=' " + value + " ']]");
    }

    public String grabXpathButton(String label) {
        return "//button[span[text()='" + label + "']]";
    }

    public List<String> grabSessionIdNotChangedScan() {
        List<String> result = new ArrayList<>();
        List<WebElement> scans = driver.findElements(By.xpath(XPATH_SCANNING_SESSION_NO_CHANGE + "/td[@class='sn ng-binding']"));
        for (WebElement scan : scans) {
            result.add(scan.getText());
        }

        return result;
    }

    public void clickEditEndDate() {
        CommonUtil.clickBtn(driver, XPATH_CHANGE_END_DATE_BUTTON);
    }

    public void clickChangeDateButton() {
        CommonUtil.clickBtn(driver, XPATH_CHANGE_DATE_BUTTON);
    }

    public void inputShipmentToInbound(String shipmentId) {
        CommonUtil.inputText(driver, XPATH_SCAN_INPUT, shipmentId + "\n");

    }

    public void checkSessionScan(String shipmentId) {
        SeleniumHelper.waitUntilElementVisible(driver, driver.findElement(By.xpath(XPATH_SCANNING_SESSION_NO_CHANGE + "[td[@class='sn ng-binding'][text()='1']][td[@class='shipmentId ng-binding'][text()='" + shipmentId + "']]")));
    }

    public void checkEndDateSessionScanChange(List<String> mustCheckId, String endDate) {
        for (String id : mustCheckId) {
            SeleniumHelper.waitUntilElementVisible(driver, driver.findElement(By.xpath(XPATH_SCANNING_SESSION_CHANGE + "[td[@class='sn ng-binding'][text()='" + id + "']][td[@class='end-date ng-binding'][text()='" + endDate + "']]")));
        }
    }

    public void inputEndDate(String newDate) {
        CommonUtil.inputText(driver, XPATH_DATE_INPUT, newDate);
    }
}
