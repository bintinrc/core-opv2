package co.nvqa.operator_v2.util;

import com.nv.qa.commons.utils.NvLogger;
import net.lightbody.bmp.BrowserMobProxy;
import net.lightbody.bmp.BrowserMobProxyServer;
import net.lightbody.bmp.client.ClientUtil;
import org.openqa.selenium.Dimension;
import org.openqa.selenium.Point;
import org.openqa.selenium.Proxy;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.logging.LogType;
import org.openqa.selenium.logging.LoggingPreferences;
import org.openqa.selenium.remote.CapabilityType;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class SeleniumUtils
{
    public static BrowserMobProxy BROWSER_MOB_PROXY = null;
    private static final List<WebDriver> LIST_OF_WEB_DRIVER = new ArrayList<>();

    static
    {
        Runtime.getRuntime().addShutdownHook(new Thread(()->
        {
            for(WebDriver webDriver : LIST_OF_WEB_DRIVER)
            {
                closeWebDriver(webDriver);
            }
        }));
    }

    private SeleniumUtils()
    {
    }

    public static WebDriver createWebDriver()
    {
        return createWebDriver(TestConstants.ENABLE_PROXY);
    }

    public static WebDriver createWebDriver(boolean enableProxy)
    {
        switch (TestConstants.SELENIUM_DRIVER.toUpperCase())
        {
            case "CHROME": return getWebDriverChrome(enableProxy);
            default: return getWebDriverChrome(enableProxy);
        }
    }

    public static void closeWebDriver(WebDriver webDriver)
    {
        if(webDriver!=null)
        {
            NvLogger.info("Closing WebDriver...");
            webDriver.close();
            NvLogger.info("WebDriver is closed.");

            NvLogger.info("Quiting WebDriver...");
            webDriver.quit();
            NvLogger.info("WebDriver is quite.");

            LIST_OF_WEB_DRIVER.remove(webDriver);
        }
    }

    private static WebDriver getWebDriverChrome(boolean enableProxy)
    {
        System.setProperty("webdriver.chrome.driver", TestConstants.SELENIUM_CHROME_DRIVER);

        LoggingPreferences logPrefs = new LoggingPreferences();
        logPrefs.enable(LogType.BROWSER, Level.ALL);

        String downloadFilepath = TestConstants.SELENIUM_WRITE_PATH;
        HashMap<String, Object> chromePrefs = new HashMap<>();
        chromePrefs.put("profile.default_content_settings.popups", 0);
        chromePrefs.put("download.default_directory", downloadFilepath);

        ChromeOptions chromeOptions = new ChromeOptions();
        chromeOptions.setCapability(CapabilityType.LOGGING_PREFS, logPrefs);
        chromeOptions.setExperimentalOption("prefs", chromePrefs);
        chromeOptions.addArguments("--disable-extensions");
        chromeOptions.addArguments("--allow-running-insecure-content");
        //chromeOptions.addArguments("--start-maximized"); Maximize on Mac does not cover entire screen.

        if(TestConstants.SELENIUM_CHROME_BINARY_PATH!=null && !TestConstants.SELENIUM_CHROME_BINARY_PATH.isEmpty())
        {
            chromeOptions.setBinary(TestConstants.SELENIUM_CHROME_BINARY_PATH);
        }

        if(enableProxy)
        {
            NvLogger.warn("Browser Mob Proxy is enabled. Please note enable this feature will make automation run slower. Use this proxy only for investigate an issue.");

            if(BROWSER_MOB_PROXY==null)
            {
                NvLogger.info("Starting Browser Mob Proxy Server ...");
                BROWSER_MOB_PROXY = new BrowserMobProxyServer();
                BROWSER_MOB_PROXY.start(0);
                NvLogger.infof("Browser Mob Proxy Server is started at port \"%d\".", BROWSER_MOB_PROXY.getPort());
                BROWSER_MOB_PROXY.setReadBandwidthLimit(TestConstants.PROXY_READ_BANDWIDTH_LIMIT_IN_BPS);
                NvLogger.infof("Set Mob Proxy Server read bandwidth limit to \"%,d\" bytes per seconds.", TestConstants.PROXY_READ_BANDWIDTH_LIMIT_IN_BPS);
                BROWSER_MOB_PROXY.setWriteBandwidthLimit(TestConstants.PROXY_WRITE_BANDWIDTH_LIMIT_IN_BPS);
                NvLogger.infof("Set Mob Proxy Server write bandwidth limit to \"%,d\" bytes per seconds.", TestConstants.PROXY_WRITE_BANDWIDTH_LIMIT_IN_BPS);
            }

            Proxy seleniumProxy = ClientUtil.createSeleniumProxy(BROWSER_MOB_PROXY);
            chromeOptions.setCapability(CapabilityType.PROXY, seleniumProxy);
        }

        WebDriver webDriver = new ChromeDriver(chromeOptions);
        webDriver.manage().timeouts().implicitlyWait(TestConstants.SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS, TimeUnit.SECONDS);
        webDriver.manage().timeouts().pageLoadTimeout(TestConstants.SELENIUM_PAGE_LOAD_TIMEOUT_SECONDS, TimeUnit.SECONDS);
        webDriver.manage().timeouts().setScriptTimeout(TestConstants.SELENIUM_SCRIPT_TIMEOUT_SECONDS, TimeUnit.SECONDS);
        //webDriver.manage().window().maximize(); //This works for IE and Firefox. Chrome does not work. There is a bug submitted for this on ChromeDriver project. Use "ChromeOptions.addArguments("--start-maximized");" instead.
        webDriver.manage().window().setSize(new Dimension(TestConstants.SELENIUM_WINDOW_WIDTH, TestConstants.SELENIUM_WINDOW_HEIGHT));
        webDriver.manage().window().setPosition(new Point(TestConstants.SELENIUM_WINDOW_POSITION_X, TestConstants.SELENIUM_WINDOW_POSITION_Y));
        LIST_OF_WEB_DRIVER.add(webDriver);
        return webDriver;
    }
}
