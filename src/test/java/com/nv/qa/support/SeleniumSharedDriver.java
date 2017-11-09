package com.nv.qa.support;

import org.openqa.selenium.WebDriver;

/**
 *
 * @author Ferdinand Kurniadi
 */
public class SeleniumSharedDriver
{
    private static SeleniumSharedDriver instance = new SeleniumSharedDriver();
    private WebDriver driver = null;

    static
    {
        Runtime.getRuntime().addShutdownHook(new Thread(() -> SeleniumSharedDriver.getInstance().closeDriver()));
    }

    private SeleniumSharedDriver()
    {
    }

    public static SeleniumSharedDriver getInstance()
    {
        return instance;
    }

    public WebDriver getDriver()
    {
        return getDriver(true);
    }

    public WebDriver getDriver(boolean createDriverIfNull)
    {
        if(driver==null && createDriverIfNull)
        {
            driver = SeleniumHelper.getWebDriver();
        }

        return driver;
    }

    public void closeDriver()
    {
        if(driver!=null)
        {
            driver.close();
            driver.quit();
            System.out.println("WebDriver quiting!");
            driver = null;
        }
    }
}
