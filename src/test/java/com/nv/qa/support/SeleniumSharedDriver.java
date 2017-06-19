package com.nv.qa.support;

import org.openqa.selenium.WebDriver;

/**
 *
 * @author Ferdinand Kurniadi
 */
public class SeleniumSharedDriver
{
    private static SeleniumSharedDriver INSTANCE = new SeleniumSharedDriver();
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
        return INSTANCE;
    }

    public WebDriver getDriver()
    {
        if(driver==null)
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
