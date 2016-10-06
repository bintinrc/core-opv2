package com.nv.qa.selenium.page.page;

import com.nv.qa.support.CommonUtil;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.PageFactory;

/**
 * Created by lanangjati
 * on 10/5/16.
 */
public class ShipmentInboundScanningPage {

    private final WebDriver driver;

    public static final String XPATH_HUB_DROPDOWN = "//md-select[md-select-value[span[text()='Inbound Hub']]]";
    public static final String XPATH_HUB_ACTIVE_DROPDOWN = "//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option";
    public static final String XPATH_SCAN_INPUT = "//md-card-content[div[h5[text()='Scan Shipment to Inbound']]]/md-input-container/input";

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
}
