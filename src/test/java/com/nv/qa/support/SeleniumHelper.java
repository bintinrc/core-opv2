package com.nv.qa.support;

import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.firefox.FirefoxProfile;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.logging.LogType;
import org.openqa.selenium.logging.LoggingPreferences;
import org.openqa.selenium.remote.CapabilityType;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.support.ui.ExpectedCondition;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.util.HashMap;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;

/**
 * Created by ferdinand on 4/19/16.
 */
public class SeleniumHelper {

    static final int SLEEP_POLL_MILIS = 1000;

    public static WebDriver getWebDriver() {
        switch (APIEndpoint.SELENIUM_DRIVER.toLowerCase()) {
            case "chrome":
                return getWebDriverChrome();
            case "firefox":
            default:
                return getWebDriverFirefox();
        }
    }

    public static WebDriver getWebDriverFirefox() {
        FirefoxProfile profile = new FirefoxProfile();
        profile.setPreference("browser.helperApps.neverAsk.saveToDisk", "application/octet-stream");
        profile.setPreference("pdfjs.disabled", false);
        profile.setPreference("browser.download.manager.showWhenStarting", false);
        profile.setPreference("browser.download.folderList", 1);
//        profile.setPreference("browser.download.dir", "/tmp/Downloads"); //-- use with folderList=2
        WebDriver driver = new FirefoxDriver(profile);
        driver.manage().timeouts().implicitlyWait(APIEndpoint.SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS, TimeUnit.SECONDS);
        driver.manage().timeouts().pageLoadTimeout(APIEndpoint.SELENIUM_PAGE_LOAD_TIMEOUT_SECONDS, TimeUnit.SECONDS);
        driver.manage().timeouts().setScriptTimeout(APIEndpoint.SELENIUM_SCRIPT_TIMEOUT_SECONDS, TimeUnit.SECONDS);
        driver.manage().window().maximize();
        return driver;
    }

    public static WebDriver getWebDriverChrome() {
        System.setProperty("webdriver.chrome.driver", APIEndpoint.SELENIUM_CHROME_DRIVER);

        DesiredCapabilities capabilities = DesiredCapabilities.chrome();
        LoggingPreferences logPrefs = new LoggingPreferences();
        logPrefs.enable(LogType.BROWSER, Level.ALL);
        capabilities.setCapability(CapabilityType.LOGGING_PREFS, logPrefs);

        String downloadFilepath = APIEndpoint.SELENIUM_WRITE_PATH;
        HashMap<String, Object> chromePrefs = new HashMap<>();
        chromePrefs.put("profile.default_content_settings.popups", 0);
        chromePrefs.put("download.default_directory", downloadFilepath);

        ChromeOptions options = new ChromeOptions();
        options.setExperimentalOption("prefs", chromePrefs);
        options.addArguments("--disable-extensions");
        //options.addArguments("--start-maximized"); Maximize on Mac does not cover entire screen.

        if(APIEndpoint.SELENIUM_CHROME_BINARY_PATH!=null && !APIEndpoint.SELENIUM_CHROME_BINARY_PATH.isEmpty())
        {
            options.setBinary(APIEndpoint.SELENIUM_CHROME_BINARY_PATH);
        }

        capabilities.setCapability(ChromeOptions.CAPABILITY, options);

        WebDriver driver = new ChromeDriver(capabilities);
        driver.manage().timeouts().implicitlyWait(APIEndpoint.SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS, TimeUnit.SECONDS);
        driver.manage().timeouts().pageLoadTimeout(APIEndpoint.SELENIUM_PAGE_LOAD_TIMEOUT_SECONDS, TimeUnit.SECONDS);
        driver.manage().timeouts().setScriptTimeout(APIEndpoint.SELENIUM_SCRIPT_TIMEOUT_SECONDS, TimeUnit.SECONDS);
        //driver.manage().window().maximize(); //This works for IE and Firefox. Chrome does not work. There is a bug submitted for this on ChromeDriver project. Use "ChromeOptions.addArguments("--start-maximized");" instead.
        driver.manage().window().setSize(new Dimension(APIEndpoint.SELENIUM_WINDOW_WIDTH, APIEndpoint.SELENIUM_WINDOW_HEIGHT));
        driver.manage().window().setPosition(new Point(0, 0));
        return driver;
    }

    public static void executeJavascript(WebDriver driver, String script, Object... args) {
        ((JavascriptExecutor) driver).executeScript(script, args);
    }

    public static void printWebElement(WebElement element) {
        StringBuffer sb = new StringBuffer();
        sb.append(element.toString()).append("\n");

        Point loc = element.getLocation();
        Dimension dim = element.getSize();


        sb.append("\tid : ").append(element.getAttribute("id")).append("\n");
        sb.append("\tname : ").append(element.getAttribute("name")).append("\n");
        sb.append("\ttext : ").append(element.getText()).append("\n");
        sb.append("\tposition : ").append(loc.getX()).append(", ").append(loc.getY()).append("\n");
        sb.append("\tsize : ").append(dim.getWidth()).append(", ").append(dim.getHeight()).append("\n");
        sb.append("\tng-click : ").append(element.getAttribute("ng-click")).append("\n");
        sb.append("\tdisplayed : ").append(element.isDisplayed()).append("\n");
        sb.append("\tenabled : ").append(element.isEnabled()).append("\n");
        sb.append("\tselected : ").append(element.isSelected()).append("\n");
        sb.append("\tclass : ").append(element.getAttribute("class")).append("\n");

        System.out.println(sb.toString());
    }

    public static WebElement findElement(WebDriver driver, By by) {
        WebElement el = driver.findElement(by);
        printWebElement(el);
        return el;
    }

    public static WebElement findElement(WebElement root, By by) {
        WebElement el = root.findElement(by);
        printWebElement(el);
        return el;
    }

    public static List<WebElement> findElements(WebDriver driver, By by) {
        List<WebElement> el = driver.findElements(by);
        System.out.println("--- FIND ELEMENTS ---");
        for (WebElement x : el) {
            printWebElement(x);
        }
        System.out.println("--- END FIND ELEMENTS ---");
        return el;
    }

    public static List<WebElement> findElements(WebElement root, By by) {
        List<WebElement> el = root.findElements(by);
        System.out.println("--- FIND ELEMENTS ---");
        for (WebElement x : el) {
            printWebElement(x);
        }
        System.out.println("--- END FIND ELEMENTS ---");
        return el;
    }

    public static void waitPageLoad(WebDriver driver) {
        (new WebDriverWait(driver, APIEndpoint.SELENIUM_PAGE_LOAD_TIMEOUT_SECONDS, SLEEP_POLL_MILIS)).until(
                new ExpectedCondition<Boolean>() {
                    public Boolean apply(WebDriver d) {
                        return ((JavascriptExecutor) d).executeScript("return document.readyState").equals("complete");
                    }
                }
        );
    }

    public static void waitAngularLoad(WebDriver driver) {
        (new WebDriverWait(driver, APIEndpoint.SELENIUM_PAGE_LOAD_TIMEOUT_SECONDS, SLEEP_POLL_MILIS)).until(
                new ExpectedCondition<Boolean>() {
                    @Override
                    public Boolean apply(WebDriver driver) {
                        return Boolean.valueOf(((JavascriptExecutor) driver).executeScript("return (window.angular !== undefined) && (angular.element(document).injector() !== undefined) && (angular.element(document).injector().get('$http').pendingRequests.length === 0)").toString());
                    }
                }
        );
    }

    public static void waitUntilElementVisible(WebDriver driver, final WebElement element) {
//        (new WebDriverWait(driver, APIEndpoint.SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS)).until(
//                new ExpectedCondition<Boolean>() {
//                    public Boolean apply(WebDriver d) {
//                        return element.isDisplayed();
//                    }
//                }
//        );


        (new WebDriverWait(driver, APIEndpoint.SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS, SLEEP_POLL_MILIS)).until(
                ExpectedConditions.visibilityOf(element)
        );

    }

    public static void waitUntilElementInvisible(WebDriver driver, final By by) {
        (new WebDriverWait(driver, APIEndpoint.SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS, SLEEP_POLL_MILIS)).until(
                ExpectedConditions.invisibilityOfElementLocated(by)
        );

    }

    public static void waitUntilElementPresent(WebDriver driver, final By locator) {
        (new WebDriverWait(driver, APIEndpoint.SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS, SLEEP_POLL_MILIS)).until(
//                ExpectedConditions.presenceOfElementLocated(locator)
                ExpectedConditions.visibilityOfElementLocated(locator)
        );

    }

    //-- Dropdown support
    public static WebElement navBarElement(WebDriver driver, String navTitle) {
        WebElement navBar = driver.findElement(By.cssSelector("div.hor-menu>ul.nav.navbar-nav"));
        if (navBar != null) {
//            List<WebElement> dropDown = navBar.findElements(By.cssSelector("li.menu-dropdown.classic-menu-dropdown"));
            List<WebElement> dropDown = navBar.findElements(By.tagName("li"));
            for (WebElement e : dropDown) {
                WebElement menuItems = e.findElement(By.tagName("a"));
                if (menuItems.getText().trim().equalsIgnoreCase(navTitle)) {
                    return e;
                }
            }
        }
        System.out.println(String.format("Cannot find nav with title %s.", navTitle));
        return null;
    }

    public static WebElement nodeMenuItemElement(WebElement parent, String menuItemTitle) {
        WebElement elm = parent.findElement(By.cssSelector("ul.dropdown-menu.pull-left"));
        List<WebElement> elms = elm.findElements(By.cssSelector("li"));
        for (WebElement e : elms) {
            if (e.findElement(By.tagName("a")).getText().trim().equalsIgnoreCase(menuItemTitle)) {
                return e;
            }
        }
        System.out.println(String.format("Cannot find menuItem with title %s.", menuItemTitle));
        return null;
    }

    public static void clickLeaf(Actions action, WebElement parent, String menuItemTitle, String selector) {
        WebElement elm = parent.findElement(By.cssSelector(selector));
        List<WebElement> elms = elm.findElements(By.cssSelector("li>a"));
        for (WebElement f : elms) {
            if (f.getText().trim().equalsIgnoreCase(menuItemTitle)) {
                clickOnElm(action, f);
                break;
            }
        }
    }

    public static void hoverOnElm(Actions action, WebElement elm) {
        action.moveToElement(elm);
        CommonUtil.pause(APIEndpoint.SELENIUM_INTERACTION_WAIT_MILLISECONDS);
        //action.pause(APIEndpoint.SELENIUM_INTERACTION_WAIT_MILLISECONDS); //pause action is deprecated and will remove from selenium on new version.
        action.perform();
    }

    public static void clickOnElm(Actions action, WebElement elm) {
        action.click(elm);
        CommonUtil.pause(APIEndpoint.SELENIUM_INTERACTION_WAIT_MILLISECONDS);
        //action.pause(APIEndpoint.SELENIUM_INTERACTION_WAIT_MILLISECONDS); //pause action is deprecated and will remove from selenium on new version.
        action.perform();
    }

}
