package com.nv.qa.selenium.page;

import com.nv.qa.support.TestConstants;
import com.nv.qa.support.CommonUtil;
import org.junit.Assert;
import org.openqa.selenium.*;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.io.*;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class SimplePage
{
    public static final int DEFAULT_MAX_RETRY_FOR_STALE_ELEMENT_REFERENCE = 5;
    public static final int DEFAULT_MAX_RETRY_FOR_FILE_VERIFICATION = 10;
    protected WebDriver driver;

    public SimplePage(WebDriver driver)
    {
        this.driver = driver;
    }

    public void altClick(String xpath)
    {
        findElementByXpath(xpath).sendKeys(Keys.ENTER);
        pause50ms();
    }

    public void click(String xpathExpression)
    {
        WebElement we = findElementByXpath(xpathExpression);
        moveAndClick(we);
    }

    public void moveAndClick(WebElement we)
    {
        Actions action = new Actions(getDriver());
        action.moveToElement(we);
        pause300ms();
        action.click();
        action.perform();
        pause300ms();
    }

    public void sendKeys(int maxRetryStaleElementReference, String xpathExpression, CharSequence... keysToSend)
    {
        boolean success = false;
        StaleElementReferenceException exception = null;

        for(int i=0; i<maxRetryStaleElementReference; i++)
        {
            try
            {
                sendKeys(xpathExpression, keysToSend);
                success = true;
                break;
            }
            catch(StaleElementReferenceException ex)
            {
                exception = ex;
                System.out.println(String.format("[WARNING] Stale element reference exception detected for element (xpath='%s') %d times.", xpathExpression, (i+1)));
            }
        }

        if(!success)
        {
            throw new RuntimeException(String.format("Retrying 'stale element reference exception' reach maximum retry. Max retry = %d.", maxRetryStaleElementReference), exception);
        }
    }

    public void sendKeys(String xpathExpression, CharSequence... keysToSend)
    {
        WebElement we = findElementByXpath(xpathExpression);
        we.clear();
        pause300ms();
        we.sendKeys(keysToSend);
        pause300ms();
    }

    public void sendKeysAndEnter(String xpathExpression, CharSequence... keysToSend)
    {
        WebElement we = findElementByXpath(xpathExpression);
        we.clear();
        pause300ms();
        we.sendKeys(keysToSend);
        pause100ms();
        we.sendKeys(Keys.RETURN);
        pause300ms();
    }

    public WebElement findElementByXpath(String xpathExpression)
    {
        return getDriver().findElement(By.xpath(xpathExpression));
    }

    public List<WebElement> findElementsByXpath(String xpathExpression)
    {
        return getDriver().findElements(By.xpath(xpathExpression));
    }

    public WebElement findElementByXpath(String xpath, WebElement parent)
    {
        return findElementBy(By.xpath(xpath), parent);
    }

    public List<WebElement> findElementsByXpath(String xpath, WebElement parent)
    {
        return findElementsBy(By.xpath(xpath), parent);
    }

    public WebElement findElementBy(By by, WebElement parent)
    {
        return parent.findElement(by);
    }

    public List<WebElement> findElementsBy(By by, WebElement parent)
    {
        return parent.findElements(by);
    }

    public void closeModal()
    {
        WebElement we = findElementByXpath("//div[(contains(@class, 'nv-text-ellipsis nv-h4'))]");

        Actions actions = new Actions(getDriver());
        actions.moveToElement(we, 5, 5)
                .click()
                .build()
                .perform();
        CommonUtil.pause100ms();
    }

    public String getTextOnTable(int rowNumber, String columnDataClass, String mdVirtualRepeat)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, mdVirtualRepeat);
    }

    public String getTextOnTableWithMdVirtualRepeat(int rowNumber, String columnDataClass, String mdVirtualRepeat)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, mdVirtualRepeat, false);
    }

    public String getTextOnTableWithMdVirtualRepeat(int rowNumber, String columnDataClass, String mdVirtualRepeat, boolean classMustExact)
    {
        String text = null;

        try
        {
            WebElement we;

            if(classMustExact)
            {
                we = findElementByXpath(String.format("//tr[@md-virtual-repeat='%s'][%d]/td[normalize-space(@class)='%s']", mdVirtualRepeat, rowNumber, columnDataClass));
            }
            else
            {
                we = findElementByXpath(String.format("//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, '%s')]", mdVirtualRepeat, rowNumber, columnDataClass));
            }

            text = we.getText().trim();
        }
        catch(NoSuchElementException ex)
        {
        }

        return text;
    }

    public void clickActionButtonOnTableWithMdVirtualRepeat(int rowNumber, String actionButtonName, String ngRepeat)
    {
        try
        {
            WebElement we = findElementByXpath(String.format("//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, 'actions')]//nv-icon-button[@name='%s']", ngRepeat, rowNumber, actionButtonName));
            moveAndClick(we);
        }
        catch(NoSuchElementException ex)
        {
            throw new RuntimeException(String.format("Cannot find action button '%s' on table.", actionButtonName), ex);
        }
    }

    /**
     *
     * @param rowNumber
     * @param columnClassName
     * @param buttonAriaLabel
     * @param ngRepeat
     */
    public void clickButtonOnTableWithMdVirtualRepeat(int rowNumber, String columnClassName, String buttonAriaLabel,  String ngRepeat)
    {
        try
        {
            WebElement we = findElementByXpath(String.format("//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, '%s')" +
                    "]//button[@aria-label='%s']", ngRepeat, rowNumber, columnClassName, buttonAriaLabel));
            moveAndClick(we);
        }
        catch(NoSuchElementException ex)
        {
            throw new RuntimeException("Cannot find action button on table.", ex);
        }
    }

    public String getTextOnTableWithNgRepeat(int rowNumber, String columnDataClass, String ngRepeat)
    {
        String text = null;

        try
        {
            WebElement we = findElementByXpath(String.format("//tr[@ng-repeat='%s'][%d]/td[contains(@class, '%s')]", ngRepeat, rowNumber, columnDataClass));
            text = we.getText().trim();
        }
        catch(NoSuchElementException ex)
        {
        }

        return text;
    }

    public void clickActionButtonOnTableWithNgRepeat(int rowNumber, String actionButtonName, String ngRepeat)
    {
        try
        {
            WebElement we = findElementByXpath(String.format("//tr[@ng-repeat='%s'][%d]/td[contains(@class, 'actions')]//nv-icon-button[@name='%s']", ngRepeat, rowNumber, actionButtonName));
            moveAndClick(we);
        }
        catch(NoSuchElementException ex)
        {
            throw new RuntimeException("Cannot find action button on table.", ex);
        }
    }

    public void clickButtonOnTableWithNgRepeat(int rowNumber, String className, String buttonAriaLabel, String ngRepeat)
    {
        try
        {
            WebElement we = findElementByXpath(String.format("//tr[@ng-repeat='%s'][%d]/td[contains(@class, '%s')]//button[@aria-label='%s']",
                    ngRepeat, rowNumber, className, buttonAriaLabel));
            moveAndClick(we);
        }
        catch(NoSuchElementException ex)
        {
            throw new RuntimeException("Cannot find action button on table.", ex);
        }
    }

    public void inputListBox(String placeHolder, String searchValue) throws InterruptedException
    {
        WebElement we = findElementByXpath("//input[@placeholder='" + placeHolder + "']");
        we.clear();
        we.sendKeys(searchValue);
        pause1s();
        we.sendKeys(Keys.RETURN);
        pause100ms();
        closeModal();
    }

    public void selectValueFromMdSelectMenu(String xpathMdSelectMenu, String xpathMdSelectOption)
    {
        WebElement mdSelectMenu = findElementByXpath(xpathMdSelectMenu);
        mdSelectMenu.click();
        pause500ms();
        WebElement mdSelectOption = CommonUtil.getElementByXpath(getDriver(), xpathMdSelectOption);
        mdSelectOption.click();
        pause500ms();
    }

    public boolean isElementExist(String xpathExpression)
    {
        WebElement we = null;

        try
        {
            we = findElementByXpath(xpathExpression);
        }
        catch(NoSuchElementException ex)
        {
        }

        return we!=null;
    }

    public void searchTableCustom1(String columnClass, String keywords)
    {
        sendKeys(String.format("//th[contains(@class, '%s')]/nv-search-input-filter/md-input-container/div/input", columnClass), keywords);
        pause200ms();
    }

    public void waitUntilInvisibilityOfElementLocated(String xpath, long timeoutInSeconds)
    {
        waitUntilInvisibilityOfElementLocated(By.xpath(xpath), timeoutInSeconds);
    }

    public void waitUntilInvisibilityOfElementLocated(By locator, long timeoutInSeconds)
    {
        pause100ms();

        try
        {
            setImplicitTimeout(0);

            new WebDriverWait(driver, timeoutInSeconds).until((WebDriver driver) ->
            {
                try
                {
                    boolean isElementDisplayed = findElement(locator, getDriver()).isDisplayed();
                    System.out.println(String.format("[INFO] Wait Until Invisibility Of Element Located: Is element '%s' still displayed? %b", locator, isElementDisplayed));
                    return !isElementDisplayed;
                }
                catch(NoSuchElementException ex)
                {
                    /**
                     * Returns true because the element is not present in DOM.
                     * The try block checks if the element is present but is invisible.
                     */
                    System.out.println(String.format("[INFO] Wait Until Invisibility Of Element Located: Is element '%s' still displayed? %b (NoSuchElementException)", locator, false));
                    return true;
                }
                catch(StaleElementReferenceException ex)
                {
                    /**
                     * Returns true because stale element reference implies that element
                     * is no longer visible.
                     */
                    System.out.println(String.format("[INFO] Wait Until Invisibility Of Element Located: Is element '%s' still displayed? %b (StaleElementReferenceException)", locator, false));
                    return true;
                }
            });
        }
        catch(Exception ex)
        {
            ex.printStackTrace(System.err);
            throw ex;
        }
        finally
        {
            resetImplicitTimeout();
        }
    }

    public void waitUntilVisibilityOfElementLocated(String xpath, long timeoutInSeconds)
    {
        waitUntilVisibilityOfElementLocated(By.xpath(xpath), timeoutInSeconds);
    }

    public void waitUntilVisibilityOfElementLocated(By locator, long timeoutInSeconds)
    {
        try
        {
            setImplicitTimeout(0);

            new WebDriverWait(driver, timeoutInSeconds).until((WebDriver driver) ->
            {
                try
                {
                    WebElement webElement = elementIfVisible(findElement(locator, driver));
                    boolean isElementDisplayed = webElement!=null;
                    System.out.println(String.format("[INFO] Wait Until Visibility Of Element Located: Is element '%s' displayed? %b", locator, isElementDisplayed));
                    return webElement;
                }
                catch(StaleElementReferenceException ex)
                {
                    return null;
                }
            });
        }
        catch(Exception ex)
        {
            ex.printStackTrace(System.err);
            throw ex;
        }
        finally
        {
            resetImplicitTimeout();
        }
    }

    private static WebElement findElement(By by, WebDriver driver)
    {
        try
        {
            return driver.findElement(by);
        }
        catch(NoSuchElementException ex)
        {
            throw ex;
        }
        catch(WebDriverException ex)
        {
            throw ex;
        }
    }

    private static WebElement elementIfVisible(WebElement element)
    {
        return element.isDisplayed()? element : null;
    }

    public String getLatestDownloadedFilename(String filenamePattern)
    {
        File parentDir = new File(TestConstants.SELENIUM_WRITE_PATH);
        File[] arrayOfFiles = parentDir.listFiles((File dir, String name)->name.startsWith(filenamePattern));
        Arrays.sort(arrayOfFiles, (File f1, File f2) -> Long.valueOf(f2.lastModified()).compareTo(f1.lastModified()));
        return arrayOfFiles[0].getName();
    }

    public void verifyFileDownloadedSuccessfully(String filename, String expectedText)
    {
        String pathname = TestConstants.SELENIUM_WRITE_PATH + filename;
        File file;
        int counter = 0;
        boolean isFileExists;

        do
        {
            file = new File(pathname);
            isFileExists = file.exists();

            if(!isFileExists)
            {
                System.out.println(String.format("[WARN] File '%s' not exists. Retry %dx...", file.getAbsolutePath(), (counter+1)));
                pause1s();
            }
            counter++;
        }
        while(!isFileExists && counter<DEFAULT_MAX_RETRY_FOR_FILE_VERIFICATION);

        Assert.assertTrue(String.format("File '%s' not exists.", file.getAbsolutePath()), isFileExists);

        boolean isFileContainsExpectedText = false;
        StringBuilder fileText;
        counter = 0;

        do
        {
            file = new File(pathname);
            fileText = new StringBuilder();

            try(BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(file))))
            {
                String input;

                while((input=br.readLine())!=null)
                {
                    fileText.append(input).append(System.lineSeparator());
                }
            }
            catch(IOException ex)
            {
                System.out.println(String.format("[WARN] File '%s' failed to read. Cause: %s. Retry %dx...", file.getAbsolutePath(), ex.getMessage(), (counter+1)));
                pause1s();
                continue;
            }

            isFileContainsExpectedText = fileText.toString().contains(expectedText);

            if(!isFileContainsExpectedText)
            {
                System.out.println(String.format("[WARN] File '%s' not contains '%s'. Retry %dx...", file.getAbsolutePath(), expectedText, (counter+1)));
            }

            counter++;
        }
        while(!isFileContainsExpectedText && counter<DEFAULT_MAX_RETRY_FOR_FILE_VERIFICATION);

        Assert.assertTrue(String.format("File '%s' not contains [%s]. \nFile Text:\n%s", file.getAbsolutePath(), expectedText, fileText), isFileContainsExpectedText);
    }

    public void pause50ms()
    {
        pause(50);
    }

    public void pause100ms()
    {
        pause(100);
    }

    public void pause200ms()
    {
        pause(200);
    }

    public void pause300ms()
    {
        pause(300);
    }

    public void pause400ms()
    {
        pause(400);
    }

    public void pause500ms()
    {
        pause(500);
    }

    public void pause1s()
    {
        pause(1_000);
    }

    public void pause2s()
    {
        pause(2_000);
    }

    public void pause3s()
    {
        pause(3_000);
    }

    public void pause4s()
    {
        pause(4_000);
    }

    public void pause5s()
    {
        pause(5_000);
    }

    public void pause10s()
    {
        pause(10_000);
    }

    public void pause(long millis)
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

    public void setImplicitTimeout(long seconds)
    {
        getDriver().manage().timeouts().implicitlyWait(seconds, TimeUnit.SECONDS);
    }

    public void resetImplicitTimeout()
    {
        setImplicitTimeout(TestConstants.SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS);
    }

    public WebDriver getDriver()
    {
        return driver;
    }
}
