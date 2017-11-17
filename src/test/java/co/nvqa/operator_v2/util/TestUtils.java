package co.nvqa.operator_v2.util;

import com.nv.qa.support.JsonHelper;
import com.nv.qa.utils.NvLogger;
import com.nv.qa.utils.StandardTestUtils;
import org.junit.Assert;
import org.openqa.selenium.*;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.function.Consumer;

/**
 *
 * @author Soewandi Wirjawan
 */
public class TestUtils extends StandardTestUtils
{
    private static final int DEFAULT_MAX_RETRY_ON_EXCEPTION = 10;
    private static final int DEFAULT_DELAY_ON_RETRY_IN_MILLISECONDS = 100;
    private static final int SLEEP_POLL_MILLIS = 1000;

    private TestUtils()
    {
    }

    public static void clickBtn(WebDriver webDriver, String xpath)
    {
        WebElement el = webDriver.findElement(By.xpath(xpath));
        pause50ms();
        moveAndClick(webDriver, el);
    }

    public static void moveAndClick(WebDriver webDriver, WebElement el)
    {
        Actions action = new Actions(webDriver);
        action.moveToElement(el);
        pause300ms();
        action.click();
        action.perform();
        pause300ms();
    }

    public static void inputText(WebDriver webDriver, String xpath, String value)
    {
        WebElement el = webDriver.findElement(By.xpath(xpath));
        el.clear();
        pause300ms();
        el.sendKeys(value);
        pause300ms();
    }

    public static void hoverMouseTo(WebDriver webDriver, String xpath)
    {
        WebElement el = webDriver.findElement(By.xpath(xpath));
        pause100ms();
        moveTo(webDriver, el);
    }

    public static void moveTo(WebDriver webDriver, WebElement el)
    {
        Actions action = new Actions(webDriver);
        action.moveToElement(el);
        action.perform();
        pause1s();
    }

    public static void chooseValueFromMdContain(WebDriver webDriver, String xpathContainer, String value)
    {
        webDriver.findElement(By.xpath(xpathContainer)).click();
        pause1s();
        clickBtn(webDriver,"//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option[div[contains(text(),'" + value + "')]]");
    }

    public static void chooseValuesFromMdContain(WebDriver webDriver, String xpathContainer, List<String> values)
    {
        webDriver.findElement(By.xpath(xpathContainer)).click();
        pause10ms();

        if(webDriver.findElements(By.xpath("//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option[@aria-selected='false']")).size() < 7)
        {
            //clear selected item
            List<WebElement> activeItem = webDriver.findElements(By.xpath("//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option[@aria-selected='true']"));
            for(WebElement item : activeItem)
            {
                moveAndClick(webDriver, item);
            }
        }

        for(String value : values)
        {
            clickBtn(webDriver, "//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option[div[contains(text(),'" + value + "')]]");
        }
    }

    public static WebElement getResultInTable(WebDriver webDriver, String tableXpath, String value)
    {
        List<WebElement> trs = webDriver.findElements(By.xpath(tableXpath)); //tr
        for (WebElement tr : trs)
        {
            List<WebElement> tds = tr.findElements(By.tagName("td"));
            for(WebElement td : tds)
            {
                if(td.getText().trim().equalsIgnoreCase(value))
                {
                    return tr;
                }
            }
        }
        return null;
    }

    public static WebElement verifySearchingResults(WebDriver webDriver, String placeHolder, String ngTable)
    {
        String txt = webDriver.findElement(By.xpath("//input[@placeholder='" + placeHolder + "'][@ng-model='searchText']")).getAttribute("value");
        WebElement result = getResultInTable(webDriver, "//table[@ng-table='" + ngTable + "']/tbody/tr", txt);
        Assert.assertTrue(result != null);
        return result;
    }

    /**
     * Get toast element. Only call this when you sure toast will we invoked.
     *
     * @param webDriver
     * @return
     */
    public static WebElement getToast(WebDriver webDriver)
    {
        String xpath = "//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div";
        waitUntilElementVisible(webDriver, By.xpath(xpath));
        return getElementByXpath(webDriver, xpath);
    }

    public static List<WebElement> getToasts(WebDriver webDriver)
    {
        String xpath = "//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div";
        waitUntilElementVisible(webDriver, By.xpath(xpath));
        return getElementsByXpath(webDriver, xpath);
    }

    public static void closeModal(WebDriver webDriver)
    {
        Actions builder = new Actions(webDriver);
        builder.moveToElement(webDriver.findElement(By.xpath("//div[(contains(@class, 'nv-text-ellipsis nv-h4'))]")), 5, 5).click().build().perform();
        pause100ms();
    }

    public static WebElement getElementByXpath(WebDriver webDriver, String xpathExpression)
    {
        WebElement element = null;

        try
        {
            element = webDriver.findElement(By.xpath(xpathExpression));
        }
        catch(NoSuchElementException ex)
        {
        }

        return element;
    }

    public static List<WebElement> getElementsByXpath(WebDriver webDriver, String xpathExpression)
    {
        List<WebElement> elements = null;

        try
        {
            elements = webDriver.findElements(By.xpath(xpathExpression));
        }
        catch(NoSuchElementException ex)
        {
        }

        return elements;
    }

    public static boolean isElementExist(WebDriver webDriver, String xpathExpression)
    {
        return getElementByXpath(webDriver, xpathExpression)!=null;
    }

    public static void selectValueFromMdSelectMenu(WebDriver webDriver, String xpathMdSelectMenu, String xpathMdSelectOption)
    {
        WebElement mdSelectMenu = getElementByXpath(webDriver, xpathMdSelectMenu);
        mdSelectMenu.click();
        pause(500);
        WebElement mdSelectOption = getElementByXpath(webDriver, xpathMdSelectOption);
        mdSelectOption.click();
        pause(500);
    }

    public static void inputListBox(WebDriver webDriver, String placeHolder, String searchValue) throws InterruptedException
    {
        WebElement el = webDriver.findElement(By.xpath("//input[@placeholder='" + placeHolder + "']"));
        el.clear();
        el.sendKeys(searchValue);
        pause1s();
        el.sendKeys(Keys.RETURN);
        pause100ms();
        closeModal(webDriver);
    }

    public static String getOperatorTimezone(WebDriver webDriver)
    {
        String cookie = webDriver.manage().getCookieNamed("user").getValue();

        try
        {
            String userJson = URLDecoder.decode(cookie,"UTF-8");
            return (String) JsonHelper.fromJsonToHashMap(userJson).get("timezone");
        }
        catch(IOException ex)
        {
            NvLogger.error("Error on method 'getOperatorTimezone'. Cause: "+ex.getMessage());
        }

        return null;
    }

    public static int dayToInteger(String day)
    {
        switch(day.toUpperCase())
        {
            case "SUNDAY": return 1;
            case "MONDAY": return 2;
            case "TUESDAY": return 3;
            case "WEDNESDAY": return 4;
            case "THURSDAY": return 5;
            case "FRIDAY": return 6;
            case "SATURDAY": return 7;
            default: return 0;
        }
    }

    public static String integerToMonth(int month)
    {
        switch(month)
        {
            case 0: return "January";
            case 1: return "February";
            case 2: return "March";
            case 3: return "April";
            case 4: return "May";
            case 5: return "June";
            case 6: return "July";
            case 7: return "August";
            case 8: return "September";
            case 9: return "October";
            case 10: return "November";
            case 11: return "December";
            default: return null;
        }
    }

    public static void columnSearchTable(WebDriver webDriver, String columnName, String value)
    {
        String xpath = "//th[span[text()='" + columnName + "']]/nv-search-input-filter/md-input-container/div/input";
        inputText(webDriver, xpath, value);
    }

    public static void waitPageLoad(WebDriver webDriver)
    {
        new WebDriverWait(webDriver, TestConstants.SELENIUM_PAGE_LOAD_TIMEOUT_SECONDS, TestConstants.SELENIUM_DEFAULT_WEB_DRIVER_WAIT_TIMEOUT_IN_SECONDS).until((WebDriver driver) -> ((JavascriptExecutor) driver).executeScript("return document.readyState").equals("complete"));
    }

    /**
     * Deprecated, should use waitUntilElementVisible(WebDriver webDriver, final By by) instead.
     * the calling of webDriver.findElement before this function negates the purpose of implicit wait.
     *
     * @param webDriver
     * @param element
     */
    @Deprecated
    public static void waitUntilElementVisible(WebDriver webDriver, final WebElement element)
    {
        try
        {
            setImplicitTimeout(webDriver, 0);
            new WebDriverWait(webDriver, TestConstants.SELENIUM_DEFAULT_WEB_DRIVER_WAIT_TIMEOUT_IN_SECONDS, SLEEP_POLL_MILLIS).until(ExpectedConditions.visibilityOf(element));
        }
        finally
        {
            resetImplicitTimeout(webDriver);
        }
    }

    public static void waitUntilElementVisible(WebDriver webDriver, final By by)
    {
        try
        {
            setImplicitTimeout(webDriver, 0);
            new WebDriverWait(webDriver, TestConstants.SELENIUM_DEFAULT_WEB_DRIVER_WAIT_TIMEOUT_IN_SECONDS, SLEEP_POLL_MILLIS).until(ExpectedConditions.visibilityOfElementLocated(by));
        }
        finally
        {
            resetImplicitTimeout(webDriver);
        }
    }

    public static void waitUntilElementInvisible(WebDriver webDriver, final By by)
    {
        try
        {
            setImplicitTimeout(webDriver, 0);
            new WebDriverWait(webDriver, TestConstants.SELENIUM_DEFAULT_WEB_DRIVER_WAIT_TIMEOUT_IN_SECONDS, SLEEP_POLL_MILLIS).until(ExpectedConditions.invisibilityOfElementLocated(by));
        }
        finally
        {
            resetImplicitTimeout(webDriver);
        }
    }

    public static void setImplicitTimeout(WebDriver webDriver, long seconds)
    {
        webDriver.manage().timeouts().implicitlyWait(seconds, TimeUnit.SECONDS);
    }

    public static void resetImplicitTimeout(WebDriver webDriver)
    {
        setImplicitTimeout(webDriver, TestConstants.SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS);
    }

    public static void retryIfStaleElementReferenceExceptionOccurred(Runnable runnable)
    {
        retryIfStaleElementReferenceExceptionOccurred(runnable, null);
    }

    @SuppressWarnings("unchecked")
    public static void retryIfStaleElementReferenceExceptionOccurred(Runnable runnable, String methodName)
    {
        retryIfExpectedExceptionOccurred(runnable, methodName, System.out::println, DEFAULT_DELAY_ON_RETRY_IN_MILLISECONDS, DEFAULT_MAX_RETRY_ON_EXCEPTION, StaleElementReferenceException.class);
    }

    @SuppressWarnings("unchecked")
    public static void retryIfStaleElementReferenceExceptionOccurred(Runnable runnable, String methodName, Consumer<String> logConsumer)
    {
        retryIfExpectedExceptionOccurred(runnable, methodName, logConsumer, DEFAULT_DELAY_ON_RETRY_IN_MILLISECONDS, DEFAULT_MAX_RETRY_ON_EXCEPTION, StaleElementReferenceException.class);
    }
}
