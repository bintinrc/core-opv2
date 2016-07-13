package com.nv.qa.support;

import org.openqa.selenium.WebDriver;


/**
 * Created by ferdinand on 4/22/16.
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