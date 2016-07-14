package com.nv.qa.support;

import org.openqa.selenium.Dimension;
import org.openqa.selenium.Point;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Ferdinand Kurniadi
 */
public class SeleniumSharedDriver {

    private static SeleniumSharedDriver singleton = new SeleniumSharedDriver();

    private SeleniumSharedDriver() {
    }

    public static SeleniumSharedDriver getInstance() {
        return singleton;
    }

    private WebDriver driver = null;

    public WebDriver getDriver() {
        if (driver == null) {
            driver = SeleniumHelper.getWebDriver();
            driver.manage().window().setSize(new Dimension(APIEndpoint.SELENIUM_WINDOW_WIDTH, APIEndpoint.SELENIUM_WINDOW_HEIGHT));
            driver.manage().window().setPosition(new Point(0, 0));
        }
        return driver;
    }

    public void closeDriver() {
        if (driver != null) {
            driver.quit();
            driver = null;
        }
    }
}
