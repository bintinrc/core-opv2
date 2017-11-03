package com.nv.qa.support;

import org.junit.Assert;
import org.openqa.selenium.*;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.interactions.Actions;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.URLDecoder;
import java.util.*;
import java.util.function.Consumer;

/**
 *
 * @author Soewandi Wirjawan
 */
public class CommonUtil
{
    private static final int DEFAULT_MAX_RETRY_ON_EXCEPTION = 10;
    private static final int DEFAULT_DELAY_ON_RETRY_IN_MILLISECONDS = 100;

    private CommonUtil()
    {
    }

    public static void clickBtn(WebDriver driver, String xpath)
    {
        WebElement el = driver.findElement(By.xpath(xpath));
        pause50ms();
        moveAndClick(driver, el);
    }

    public static void moveAndClick(WebDriver driver, WebElement el)
    {
        Actions action = new Actions(driver);
        action.moveToElement(el);
        pause300ms();
        action.click();
        action.perform();
        pause300ms();
    }

    public static void inputText(WebDriver driver, String xpath, String value)
    {
        WebElement el = driver.findElement(By.xpath(xpath));
        el.clear();
        pause300ms();
        el.sendKeys(value);
        pause300ms();
    }

    public static void hoverMouseTo(WebDriver driver, String xpath)
    {
        WebElement el = driver.findElement(By.xpath(xpath));
        pause100ms();
        moveTo(driver, el);
    }

    public static void moveTo(WebDriver driver, WebElement el)
    {
        Actions action = new Actions(driver);
        action.moveToElement(el);
        action.perform();
        pause1s();
    }

    public static void chooseValueFromMdContain(WebDriver driver, String xpathContainer, String value)
    {
        driver.findElement(By.xpath(xpathContainer)).click();
        CommonUtil.pause1s();

        CommonUtil.clickBtn(driver,"//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option[div[contains(text(),'" + value + "')]]");
    }

    public static void chooseValuesFromMdContain(WebDriver driver, String xpathContainer, List<String> values)
    {
        driver.findElement(By.xpath(xpathContainer)).click();
        CommonUtil.pause10ms();

        if(driver.findElements(By.xpath("//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option[@aria-selected='false']")).size() < 7)
        {
            //clear selected item
            List<WebElement> activeItem = driver.findElements(By.xpath("//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option[@aria-selected='true']"));
            for(WebElement item : activeItem)
            {
                CommonUtil.moveAndClick(driver, item);
            }
        }

        for(String value : values)
        {
            CommonUtil.clickBtn(driver, "//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option[div[contains(text(),'" + value + "')]]");
        }
    }

    public static void pause10s()
    {
        pause(10_000);
    }

    public static void pause5s()
    {
        pause(5_000);
    }

    public static void pause3s()
    {
        pause(3_000);
    }

    public static void pause1s()
    {
        pause(1_000);
    }

    public static void pause100ms()
    {
        pause(100);
    }

    public static void pause200ms()
    {
        pause(200);
    }

    public static void pause300ms()
    {
        pause(300);
    }

    public static void pause500ms()
    {
        pause(500);
    }

    public static void pause50ms()
    {
        pause(50);
    }

    public static void pause10ms()
    {
        pause(10);
    }

    public static void pause(long millis)
    {
        try
        {
            Thread.sleep(millis);
        }
        catch(InterruptedException ex)
        {
            ex.printStackTrace();
        }
    }

    public static String getStackTrace(Throwable cause)
    {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        cause.printStackTrace(pw);
        return sw.toString();
    }

    public static WebElement getResultInTable(WebDriver driver, String tableXpath, String value)
    {
        List<WebElement> trs = driver.findElements(By.xpath(tableXpath)); //tr
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

    public static WebElement verifySearchingResults(WebDriver driver, String placeHolder, String ngTable)
    {
        String txt = driver.findElement(By.xpath("//input[@placeholder='" + placeHolder + "'][@ng-model='searchText']")).getAttribute("value");
        WebElement result = CommonUtil.getResultInTable(driver, "//table[@ng-table='" + ngTable + "']/tbody/tr", txt);
        Assert.assertTrue(result != null);
        return result;
    }

    /**
     * Get toast element. Only call this when you sure toast will we invoked.
     *
     * @param driver
     * @return
     */
    public static WebElement getToast(WebDriver driver)
    {
        String xpath = "//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div";
        SeleniumHelper.waitUntilElementVisible(driver, By.xpath(xpath));
        return getElementByXpath(driver, xpath);
    }

    public static List<WebElement> getToasts(WebDriver driver)
    {
        String xpath = "//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div";
        SeleniumHelper.waitUntilElementVisible(driver, By.xpath(xpath));
        return getElementsByXpath(driver, xpath);
    }

    public static void closeModal(WebDriver driver)
    {
        Actions builder = new Actions(driver);
        builder.moveToElement(driver.findElement(By.xpath("//div[(contains(@class, 'nv-text-ellipsis nv-h4'))]")), 5, 5).click().build().perform();
        CommonUtil.pause100ms();
    }

    public static WebElement getElementByXpath(WebDriver driver, String xpathExpression)
    {
        WebElement element = null;

        try
        {
            element = driver.findElement(By.xpath(xpathExpression));
        }
        catch(NoSuchElementException ex)
        {
        }

        return element;
    }

    public static List<WebElement> getElementsByXpath(WebDriver driver, String xpathExpression)
    {
        List<WebElement> elements = null;

        try
        {
            elements = driver.findElements(By.xpath(xpathExpression));
        }
        catch(NoSuchElementException ex)
        {
        }

        return elements;
    }

    public static boolean isElementExist(WebDriver driver, String xpathExpression)
    {
        return getElementByXpath(driver, xpathExpression)!=null;
    }

    public static void selectValueFromMdSelectMenu(WebDriver driver, String xpathMdSelectMenu, String xpathMdSelectOption)
    {
        WebElement mdSelectMenu = CommonUtil.getElementByXpath(driver, xpathMdSelectMenu);
        mdSelectMenu.click();
        pause(500);
        WebElement mdSelectOption = CommonUtil.getElementByXpath(driver, xpathMdSelectOption);
        mdSelectOption.click();
        pause(500);
    }

    public static void inputListBox(WebDriver driver, String placeHolder, String searchValue) throws InterruptedException
    {
        WebElement el = driver.findElement(By.xpath("//input[@placeholder='" + placeHolder + "']"));
        el.clear();
        el.sendKeys(searchValue);
        CommonUtil.pause1s();
        el.sendKeys(Keys.RETURN);
        CommonUtil.pause100ms();
        CommonUtil.closeModal(driver);
    }

    /**
     * This method return 9 digit random number.
     *
     * @return
     */
    public static String generateTrackingRefNo()
    {
        long millis = System.currentTimeMillis();
        long secondsSince1970 = millis/1000;
        String result = String.valueOf(secondsSince1970).substring(1); //Remove the first index to remove the most significant value of timestamp.
        return result;
    }

    public static String replaceParam(String data, Map<String,String> mapOfDynamicVariable)
    {
        if(data==null)
        {
            return null;
        }

        String result = data;

        for(Map.Entry<String,String> entry : mapOfDynamicVariable.entrySet())
        {
            result = result.replaceAll("\\{\\{"+entry.getKey()+"\\}\\}", entry.getValue());
        }

        return result;
    }

    public static int dayToInteger(String day)
    {
        if (day.equalsIgnoreCase("SUNDAY")) {
            return 1;
        } else if (day.equalsIgnoreCase("MONDAY")) {
            return 2;
        } else if (day.equalsIgnoreCase("TUESDAY")) {
            return 3;
        } else if (day.equalsIgnoreCase("WEDNESDAY")) {
            return 4;
        } else if (day.equalsIgnoreCase("THURSDAY")) {
            return 5;
        } else if (day.equalsIgnoreCase("FRIDAY")) {
            return 6;
        } else if (day.equalsIgnoreCase("SATURDAY")) {
            return 7;
        } else {
            return 0;
        }
    }

    public static String integerToMonth(int month)
    {
        if (month == 0) {
            return "January";
        } else if (month == 1) {
            return "February";
        } else if (month == 2) {
            return "March";
        } else if (month == 3) {
            return "April";
        } else if (month == 4) {
            return "May";
        } else if (month == 5) {
            return "June";
        } else if (month == 6) {
            return "July";
        } else if (month == 7) {
            return "August";
        } else if (month == 8) {
            return "September";
        } else if (month == 9) {
            return "October";
        } else if (month == 10) {
            return "November";
        } else if (month == 11) {
            return "December";
        } else {
            return null;
        }
    }

    public static void columnSearchTable(WebDriver driver, String columnName, String value)
    {
        String xpath = "//th[span[text()='" + columnName + "']]/nv-search-input-filter/md-input-container/div/input";
        inputText(driver, xpath, value);
    }

    public static Date getNextDate(int day)
    {
        Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        cal.add(Calendar.DATE, day);
        return cal.getTime();
    }

    public static Date getBeforeDate(int day)
    {
        Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        cal.add(Calendar.DATE, -1*day);
        return cal.getTime();
    }

    public static boolean deleteFile(String pathname)
    {
        File file = new File(pathname);
        return deleteFile(file);
    }

    public static boolean deleteFile(File file)
    {
        boolean deleted = false;

        if(file.exists())
        {
            deleted = file.delete();

            if(deleted)
            {
                System.out.println(String.format("[INFO] File '%s' is deleted.", file.getAbsolutePath()));
            }
        }

        return deleted;
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

    public static void retryIfRuntimeExceptionOccurred(Runnable runnable)
    {
        retryIfRuntimeExceptionOccurred(runnable, null);
    }

    @SuppressWarnings("unchecked")
    public static void retryIfRuntimeExceptionOccurred(Runnable runnable, String methodName)
    {
        retryIfExpectedExceptionOccurred(runnable, methodName, System.out::println, DEFAULT_DELAY_ON_RETRY_IN_MILLISECONDS, DEFAULT_MAX_RETRY_ON_EXCEPTION, RuntimeException.class);
    }

    @SuppressWarnings("unchecked")
    public static void retryIfExpectedExceptionOccurred(Runnable runnable, Class<? extends Throwable> ... expectedExceptionClasses)
    {
        retryIfExpectedExceptionOccurred(runnable, null, System.out::println, DEFAULT_DELAY_ON_RETRY_IN_MILLISECONDS, DEFAULT_MAX_RETRY_ON_EXCEPTION, expectedExceptionClasses);
    }

    @SuppressWarnings("unchecked")
    public static void retryIfExpectedExceptionOccurred(Runnable runnable, long delayInMillis, Class<? extends Throwable> ... expectedExceptionClasses)
    {
        retryIfExpectedExceptionOccurred(runnable, null, System.out::println, delayInMillis, DEFAULT_MAX_RETRY_ON_EXCEPTION, expectedExceptionClasses);
    }

    @SuppressWarnings("unchecked")
    public static void retryIfExpectedExceptionOccurred(Runnable runnable, String methodName, Class<? extends Throwable> ... expectedExceptionClasses)
    {
        retryIfExpectedExceptionOccurred(runnable, methodName, System.out::println, DEFAULT_DELAY_ON_RETRY_IN_MILLISECONDS, DEFAULT_MAX_RETRY_ON_EXCEPTION, expectedExceptionClasses);
    }

    @SuppressWarnings("unchecked")
    public static void retryIfExpectedExceptionOccurred(Runnable runnable, String methodName, long delayInMillis, Class<? extends Throwable> ... expectedExceptionClasses)
    {
        retryIfExpectedExceptionOccurred(runnable, methodName, System.out::println, delayInMillis, DEFAULT_MAX_RETRY_ON_EXCEPTION, expectedExceptionClasses);
    }

    @SuppressWarnings("unchecked")
    public static void retryIfExpectedExceptionOccurred(Runnable runnable, String methodName, Consumer<String> logConsumer, long delayInMillis, int maxRetry, Class<? extends Throwable> ... expectedExceptionClasses)
    {
        Throwable actualException = null;
        boolean isExceptionOccurred;
        int counter = 0;

        do
        {
            try
            {
                runnable.run();
                isExceptionOccurred = false;
            }
            catch(Throwable ex)
            {
                actualException = ex;
                isExceptionOccurred = true;
                boolean isExpectedExceptionOccurred = false;

                for(Class<? extends Throwable> expectedExceptionClass : expectedExceptionClasses)
                {
                    if(expectedExceptionClass.isInstance(ex))
                    {
                        isExpectedExceptionOccurred = true;
                        break;
                    }
                }

                if(isExpectedExceptionOccurred)
                {
                    if(methodName==null)
                    {
                        logConsumer.accept(String.format("[WARN] %s is occurred. Retrying %dx...", ex.getClass(), (counter+1)));
                    }
                    else
                    {
                        logConsumer.accept(String.format("[WARN] %s is occurred on method '%s'. Retrying %dx...", ex.getClass(), methodName, (counter+1)));
                    }
                }
                else
                {
                    throw ex;
                }
            }

            counter++;
            pause(delayInMillis);
        }
        while(isExceptionOccurred && counter<maxRetry);

        if(isExceptionOccurred)
        {
            if(methodName==null)
            {
                throw new RuntimeException(String.format("%s still occurred after trying  %d times.", actualException.getClass(), maxRetry), actualException);
            }
            else
            {
                throw new RuntimeException(String.format("%s still occurred on method '%s' after trying %d times.", actualException.getClass(), methodName, maxRetry), actualException);
            }
        }
    }

    public static Set<Cookie> getCookies(WebDriver driver)
    {
        return driver.manage().getCookies();
    }

    public static String getOperatorTimezone(WebDriver driver)
    {
        String cookie = driver.manage().getCookieNamed("user").getValue();

        try
        {
            String cookier = URLDecoder.decode(cookie,"UTF-8");
            return (String) JsonHelper.fromJsonToHashMap(cookier).get("timezone");
        }
        catch (IOException e)
        {
            System.out.println(e.getMessage());
        }

        return null;
    }
}
