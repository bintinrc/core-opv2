package com.nv.qa.support;

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
            System.out.println("Get Driver Here...");
            driver = SeleniumHelper.getWebDriver();
            System.out.println("Driver: "+driver);
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
