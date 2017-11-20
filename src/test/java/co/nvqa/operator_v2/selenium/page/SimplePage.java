package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import com.nv.qa.utils.NvLogger;
import org.junit.Assert;
import org.openqa.selenium.*;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.ExpectedConditions;
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
    protected WebDriver webDriver;

    public SimplePage(WebDriver webDriver)
    {
        this.webDriver = webDriver;
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

    public void moveAndClick(WebElement webElement)
    {
        Actions action = new Actions(getwebDriver());
        action.moveToElement(webElement);
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
                NvLogger.warnf("Stale element reference exception detected for element (xpath='%s') %d times.", xpathExpression, (i+1));
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
        return findElementByXpath(xpathExpression, -1);
    }

    public WebElement findElementByXpath(String xpathExpression, long timeoutInSeconds)
    {
        By byXpath = By.xpath(xpathExpression);
        NvLogger.infof("findElement: Selector = %s; Time Out In Seconds = %d", byXpath, timeoutInSeconds);

        if(timeoutInSeconds>=0)
        {
            try
            {
                setImplicitTimeout(0);
                return new WebDriverWait(getwebDriver(), timeoutInSeconds).until(ExpectedConditions.presenceOfElementLocated(byXpath));
            }
            catch(Exception ex)
            {
                throw ex;
            }
            finally
            {
                resetImplicitTimeout();
            }
        }

        return getwebDriver().findElement(byXpath);
    }

    public List<WebElement> findElementsByXpath(String xpathExpression)
    {
        return findElementsByXpath(xpathExpression, -1);
    }

    public List<WebElement> findElementsByXpath(String xpathExpression, long timeoutInSeconds)
    {
        By byXpath = By.xpath(xpathExpression);
        NvLogger.infof("findElements: Selector = %s; Time Out In Seconds = %d", byXpath, timeoutInSeconds);

        if(timeoutInSeconds>=0)
        {
            try
            {
                setImplicitTimeout(0);
                return new WebDriverWait(getwebDriver(), timeoutInSeconds).until(ExpectedConditions.presenceOfAllElementsLocatedBy(byXpath));
            }
            catch(Exception ex)
            {
                throw ex;
            }
            finally
            {
                resetImplicitTimeout();
            }
        }

        return getwebDriver().findElements(byXpath);
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

        Actions actions = new Actions(getwebDriver());
        actions.moveToElement(we, 5, 5)
                .click()
                .build()
                .perform();
        TestUtils.pause100ms();
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
        WebElement mdSelectOption = TestUtils.getElementByXpath(getwebDriver(), xpathMdSelectOption);
        mdSelectOption.click();
        pause500ms();
    }

    public boolean isElementExist(String xpathExpression)
    {
        return isElementExist(xpathExpression, -1);
    }

    public boolean isElementExist(String xpathExpression, long timeoutInSeconds)
    {
        WebElement we = null;

        try
        {
            we = findElementByXpath(xpathExpression, timeoutInSeconds);
        }
        catch(NoSuchElementException | TimeoutException ex)
        {
        }

        return we!=null;
    }

    public void searchTableCustom1(String columnClass, String keywords)
    {
        sendKeys(String.format("//th[contains(@class, '%s')]/nv-search-input-filter/md-input-container/div/input", columnClass), keywords);
        pause200ms();
    }

    public void waitUntilInvisibilityOfElementLocated(String xpath)
    {
        waitUntilInvisibilityOfElementLocated(By.xpath(xpath), TestConstants.SELENIUM_DEFAULT_WEB_DRIVER_WAIT_TIMEOUT_IN_SECONDS);
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

            new WebDriverWait(getwebDriver(), timeoutInSeconds).until((WebDriver driver) ->
            {
                try
                {
                    boolean isElementDisplayed = findElement(locator, driver).isDisplayed();
                    NvLogger.infof("Wait Until Invisibility Of Element Located: Is element '%s' still displayed? %b", locator, isElementDisplayed);
                    return !isElementDisplayed;
                }
                catch(NoSuchElementException ex)
                {
                    /**
                     * Returns true because the element is not present in DOM.
                     * The try block checks if the element is present but is invisible.
                     */
                    NvLogger.infof("Wait Until Invisibility Of Element Located: Is element '%s' still displayed? %b (NoSuchElementException)", locator, false);
                    return true;
                }
                catch(StaleElementReferenceException ex)
                {
                    /**
                     * Returns true because stale element reference implies that element
                     * is no longer visible.
                     */
                    NvLogger.infof("Wait Until Invisibility Of Element Located: Is element '%s' still displayed? %b (StaleElementReferenceException)", locator, false);
                    return true;
                }
            });
        }
        catch(Exception ex)
        {
            NvLogger.warn("Error on method 'waitUntilInvisibilityOfElementLocated'.", ex);
            throw ex;
        }
        finally
        {
            resetImplicitTimeout();
        }
    }

    public void waitUntilVisibilityOfElementLocated(String xpath)
    {
        waitUntilVisibilityOfElementLocated(By.xpath(xpath), TestConstants.SELENIUM_DEFAULT_WEB_DRIVER_WAIT_TIMEOUT_IN_SECONDS);
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

            new WebDriverWait(getwebDriver(), timeoutInSeconds).until((WebDriver wd) ->
            {
                try
                {
                    WebElement webElement = elementIfVisible(findElement(locator, wd));
                    boolean isElementDisplayed = webElement!=null;
                    NvLogger.infof("Wait Until Visibility Of Element Located: Is element '%s' displayed? %b", locator, isElementDisplayed);
                    return webElement;
                }
                catch(NoSuchElementException ex)
                {
                    /**
                     * Returns false because the element is not present in DOM.
                     * The try block checks if the element is present but is invisible.
                     */
                    NvLogger.infof("Wait Until Visibility Of Element Located: Is element '%s' displayed? %b (NoSuchElementException)", locator, false);
                    return false;
                }
                catch(StaleElementReferenceException ex)
                {
                    /**
                     * Returns false because stale element reference implies that element
                     * is no longer visible.
                     */
                    NvLogger.infof("Wait Until Visibility Of Element Located: Is element '%s' displayed? %b (StaleElementReferenceException)", locator, false);
                    return false;
                }
            });
        }
        catch(Exception ex)
        {
            NvLogger.warn("Error on method 'waitUntilVisibilityOfElementLocated'.", ex);
            throw ex;
        }
        finally
        {
            resetImplicitTimeout();
        }
    }

    private static WebElement findElement(By by, WebDriver webDriver)
    {
        try
        {
            return webDriver.findElement(by);
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
                NvLogger.warnf("File '%s' not exists. Retry %dx...", file.getAbsolutePath(), (counter+1));
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
                NvLogger.warnf("File '%s' failed to read. Cause: %s. Retry %dx...", file.getAbsolutePath(), ex.getMessage(), (counter+1));
                pause1s();
                continue;
            }

            isFileContainsExpectedText = fileText.toString().contains(expectedText);

            if(!isFileContainsExpectedText)
            {
                NvLogger.warnf("File '%s' not contains '%s'. Retry %dx...", file.getAbsolutePath(), expectedText, (counter+1));
            }

            counter++;
        }
        while(!isFileContainsExpectedText && counter<DEFAULT_MAX_RETRY_FOR_FILE_VERIFICATION);

        Assert.assertTrue(String.format("File '%s' not contains [%s]. \nFile Text:\n%s", file.getAbsolutePath(), expectedText, fileText), isFileContainsExpectedText);
    }

    public void pause10ms()
    {
        pause(10);
    }

    public void pause20ms()
    {
        pause(20);
    }

    public void pause30ms()
    {
        pause(30);
    }

    public void pause40ms()
    {
        pause(40);
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
            NvLogger.infof("Pause %,dms on Page class.", millis);
            Thread.sleep(millis);
        }
        catch(InterruptedException ex)
        {
            NvLogger.warn("Error on method 'pause'.", ex);
        }
    }

    public void refreshPage()
    {
        String previousUrl = getwebDriver().getCurrentUrl().toLowerCase();


        getwebDriver().navigate().refresh();
        new WebDriverWait(getwebDriver(), TestConstants.SELENIUM_DEFAULT_WEB_DRIVER_WAIT_TIMEOUT_IN_SECONDS).until((d)->d.getCurrentUrl().equalsIgnoreCase(previousUrl));
        String currentUrl = getwebDriver().getCurrentUrl().toLowerCase();
        Assert.assertEquals("Page URL is different after page is refreshed.", previousUrl, currentUrl);
    }

    public void setImplicitTimeout(long seconds)
    {
        getwebDriver().manage().timeouts().implicitlyWait(seconds, TimeUnit.SECONDS);
    }

    public void resetImplicitTimeout()
    {
        setImplicitTimeout(TestConstants.SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS);
    }

    public WebDriver getwebDriver()
    {
        return webDriver;
    }
}
