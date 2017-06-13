package com.nv.qa.support;

import org.openqa.selenium.WebDriver;

/**
 *
 * @author Ferdinand Kurniadi
 */
public class SeleniumSharedDriver {

    private static SeleniumSharedDriver singleton = new SeleniumSharedDriver();

    static
    {
        Runtime.getRuntime().addShutdownHook(new Thread(() -> SeleniumSharedDriver.getInstance().closeDriver()));
    }

    private SeleniumSharedDriver() {
    }

    public static SeleniumSharedDriver getInstance() {
        return singleton;
    }

    private WebDriver driver = null;

    public WebDriver getDriver() {
        if (driver == null) {
            driver = SeleniumHelper.getWebDriver();
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
