package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.utils.ListOfDateFormat;
import co.nvqa.commons.utils.NvLogger;
import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.commons.utils.StandardTestUtils;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import org.junit.Assert;
import org.openqa.selenium.*;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.util.Arrays;
import java.util.Base64;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class SimplePage implements ListOfDateFormat
{
    public static final int FAST_WAIT_IN_SECONDS = 2;
    public static final int DEFAULT_MAX_RETRY_FOR_STALE_ELEMENT_REFERENCE = 5;
    public static final int DEFAULT_MAX_RETRY_FOR_FILE_VERIFICATION = 10;
    protected WebDriver webDriver;

    public SimplePage(WebDriver webDriver)
    {
        this.webDriver = webDriver;
    }

    public boolean isBlank(String str)
    {
        return StandardTestUtils.isBlank(str);
    }

    public void moveAndClick(WebElement webElement)
    {
        Actions action = new Actions(getwebDriver());
        action.moveToElement(webElement);
        pause100ms();
        action.click();
        action.perform();
        pause100ms();
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

    public void clickAndWaitUntilDone(String xpathExpression)
    {
        click(xpathExpression);
        waitUntilInvisibilityOfElementLocated(xpathExpression + "//md-progress-circular");
    }

    public void clickButtonByAriaLabel(String ariaLabel)
    {
        click(String.format("//button[@aria-label='%s']", ariaLabel));
    }

    public void clickButtonByAriaLabelAndWaitUntilDone(String ariaLabel)
    {
        String xpathExpression = String.format("//button[@aria-label='%s']", ariaLabel);
        click(xpathExpression);
        waitUntilInvisibilityOfElementLocated(xpathExpression + "/div[contains(@class,'show')]/md-progress-circular");
    }

    public void clickNvIconButtonByName(String name)
    {
        click(String.format("//nv-icon-button[@name='%s']", name));
    }

    public void clickNvIconButtonByNameAndWaitUntilEnabled(String name)
    {
        String xpathExpression = String.format("//nv-icon-button[@name='%s']", name);
        click(xpathExpression);
        waitUntilInvisibilityOfElementLocated(xpathExpression + "/button[@disabled='disabled']");
    }

    public void clickNvIconTextButtonByName(String name)
    {
        click(String.format("//nv-icon-text-button[@name='%s']", name));
    }

    public void clickNvIconTextButtonByNameAndWaitUntilDone(String name)
    {
        String xpathExpression = String.format("//nv-icon-text-button[@name='%s']", name);
        click(xpathExpression);
        waitUntilInvisibilityOfElementLocated(xpathExpression + "/button/div[contains(@class,'show')]/md-progress-circular");
    }

    public void clickNvApiTextButtonByName(String name)
    {
        click(String.format("//nv-api-text-button[@name='%s']", name));
    }

    public void clickNvApiTextButtonByNameAndWaitUntilDone(String name)
    {
        String xpathExpression = String.format("//nv-api-text-button[@name='%s']", name);
        click(xpathExpression);
        waitUntilInvisibilityOfElementLocated(xpathExpression + "/button/div[contains(@class,'show')]/md-progress-circular");
    }

    public void clickNvApiIconButtonByName(String name)
    {
        click(String.format("//nv-api-icon-button[@name='%s']", name));
    }

    public void clickNvApiIconButtonByNameAndWaitUntilDone(String name)
    {
        String xpathExpression = String.format("//nv-api-icon-button[@name='%s']", name);
        click(xpathExpression);
        waitUntilInvisibilityOfElementLocated(xpathExpression + "/button/div[contains(@class,'waiting')]/md-progress-circular");
    }

    public void clickNvButtonSaveByName(String name)
    {
        click(String.format("//nv-button-save[@name='%s']", name));
    }

    public void clickNvButtonSaveByNameAndWaitUntilDone(String name)
    {
        String xpathExpression = String.format("//nv-button-save[@name='%s']", name);
        click(xpathExpression);
        waitUntilInvisibilityOfElementLocated(xpathExpression + "/button/div[contains(@class,'saving')]/md-progress-circular");
    }

    public void clickButtonOnMdDialogByAriaLabel(String ariaLabel)
    {
        click(String.format("//md-dialog//button[@aria-label='%s']", ariaLabel));
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
                NvLogger.warnf("StaleElementReferenceException detected for element with XPath = { %s } %d times.", xpathExpression, (i+1));
            }
        }

        if(!success)
        {
            throw new RuntimeException(String.format("Retrying 'StaleElementReferenceException' reach maximum retry. Max retry = %d.", maxRetryStaleElementReference), exception);
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
        pause300ms();
        we.sendKeys(Keys.RETURN);
        pause300ms();
    }

    public void sendKeysById(String id, CharSequence... keysToSend)
    {
        sendKeys(String.format("//*[starts-with(@id, '%s')]", id), keysToSend);
    }

    public void sendKeysByName(String id, CharSequence... keysToSend)
    {
        sendKeys(String.format("//*[starts-with(@name, '%s')]", id), keysToSend);
    }

    public void sendKeysByAriaLabel(String ariaLabel, CharSequence... keysToSend)
    {
        sendKeys(String.format("//*[@aria-label='%s']", ariaLabel), keysToSend);
    }

    public String getText(String xpathExpression)
    {
        String text = null;

        try
        {
            WebElement webElement = findElementByXpath(xpathExpression);
            text = webElement.getText();
        }
        catch(RuntimeException ex)
        {
            NvLogger.warnf("Failed to get text from element with XPath = { %s }.", xpathExpression);
        }

        return text;
    }

    public String getTrimmedText(String xpathExpression)
    {
        String text = getText(xpathExpression);

        if(text!=null)
        {
            text = text.trim();
        }

        return text;
    }

    public File saveCanvasAsPngFile(String canvasXpathExpression)
    {
        File fileResult;

        if(getwebDriver() instanceof JavascriptExecutor)
        {
            try
            {
                JavascriptExecutor javascriptExecutor = (JavascriptExecutor) getwebDriver();
                WebElement canvasWe = findElementByXpath(canvasXpathExpression);
                String imageAsStringBase64 = (String) javascriptExecutor.executeScript("return arguments[0].toDataURL('image/png');", canvasWe);
                imageAsStringBase64 = imageAsStringBase64.split(",")[1]; //Remove Base64 prefix: data:image/png;base64,
                byte[] imageAsArrayOfByte = Base64.getDecoder().decode(imageAsStringBase64);
                BufferedImage imageAsBufferedImage = ImageIO.read(new ByteArrayInputStream(imageAsArrayOfByte));
                fileResult = TestUtils.createFileOnTempFolder("canvas-image_"+generateDateUniqueString()+".png");
                ImageIO.write(imageAsBufferedImage, "PNG", fileResult);
            }
            catch(IOException ex)
            {
                throw new NvTestRuntimeException(ex);
            }
        }
        else
        {
            throw new NvTestRuntimeException("WebDriver is not instance of JavascriptExecutor. Cannot execute method executeScript.");
        }

        return fileResult;
    }

    public void setMdDatepicker(String ngModel, Date date)
    {
        sendKeys(String.format("//md-datepicker[@ng-model='%s']/div/input", ngModel), MD_DATEPICKER_SDF.format(date));
        click(String.format("//md-datepicker[@ng-model='%s']/parent::*", ngModel));
    }

    public void setMdDatepickerById(String mdPickerId, Date date)
    {
        sendKeys(String.format("//md-datepicker[@id='%s']/div/input", mdPickerId), MD_DATEPICKER_SDF.format(date));
        click(String.format("//md-datepicker[@id='%s']/parent::*", mdPickerId));
    }

    public void waitUntilInvisibilityOfToast(String containsMessage)
    {
        waitUntilInvisibilityOfToast(containsMessage, true);
    }

    public void waitUntilInvisibilityOfToast(String containsMessage, boolean waitUntilElementVisibleFirst)
    {
        if(waitUntilElementVisibleFirst)
        {
            waitUntilVisibilityOfElementLocated(String.format("//div[@id='toast-container']//div[contains(text(), '%s')]", containsMessage));
        }

        waitUntilInvisibilityOfElementLocated(String.format("//div[@id='toast-container']//div[contains(text(), '%s')]", containsMessage));
    }

    public void waitUntilVisibilityOfToast(String containsMessage)
    {
        waitUntilVisibilityOfElementLocated(String.format("//div[@id='toast-container']//div[contains(text(), '%s')]", containsMessage));
    }

    public WebElement getToast()
    {
        String xpath = "//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div";
        return waitUntilVisibilityOfElementLocated(xpath);
    }

    public List<WebElement> getToasts()
    {
        String xpath = "//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div";
        waitUntilVisibilityOfElementLocated(xpath);
        return findElementsByXpath(xpath);
    }

    public WebElement findElementByXpath(String xpathExpression)
    {
        return findElementByXpath(xpathExpression, -1);
    }

    public WebElement findElementByXpathFast(String xpathExpression)
    {
        return findElementByXpath(xpathExpression, FAST_WAIT_IN_SECONDS);
    }

    public WebElement findElementByXpath(String xpathExpression, long timeoutInSeconds)
    {
        By byXpath = By.xpath(xpathExpression);
        NvLogger.infof("findElementByXpath: Selector = { %s } - Timeout In Seconds = [%ds]", byXpath, timeoutInSeconds);

        if(timeoutInSeconds>=0)
        {
            try
            {
                setImplicitTimeout(0);
                return new WebDriverWait(getwebDriver(), timeoutInSeconds).until(ExpectedConditions.presenceOfElementLocated(byXpath));
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

    public List<WebElement> findElementsByXpathFast(String xpathExpression)
    {
        return findElementsByXpath(xpathExpression, FAST_WAIT_IN_SECONDS);
    }

    public List<WebElement> findElementsByXpath(String xpathExpression, long timeoutInSeconds)
    {
        By byXpath = By.xpath(xpathExpression);
        NvLogger.infof("findElementsByXpath: Selector = { %s } - Timeout In Seconds = [%ds]", byXpath, timeoutInSeconds);

        if(timeoutInSeconds>=0)
        {
            try
            {
                setImplicitTimeout(0);
                return new WebDriverWait(getwebDriver(), timeoutInSeconds).until(ExpectedConditions.presenceOfAllElementsLocatedBy(byXpath));
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
                we = findElementByXpath(String.format("//tr[@md-virtual-repeat='%s'][%d]/td[starts-with(@class, '%s')]", mdVirtualRepeat, rowNumber, columnDataClass));
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
            WebElement we = findElementByXpath(String.format("//tr[@md-virtual-repeat='%s'][%d]/td[starts-with(@class, 'actions')]//nv-icon-button[@name='%s']", ngRepeat, rowNumber, actionButtonName));
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
    public void clickButtonOnTableWithMdVirtualRepeat(int rowNumber, String columnClassName, String buttonAriaLabel, String ngRepeat)
    {
        try
        {
            String xpath = String.format("//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, '%s')]//button[@aria-label='%s']", ngRepeat, rowNumber, columnClassName, buttonAriaLabel);
            WebElement we = findElementByXpath(xpath);
            moveAndClick(we);
        }
        catch(NoSuchElementException ex)
        {
            throw new NvTestRuntimeException("Cannot find action button on table.", ex);
        }
    }

    public String getTextOnTableWithNgRepeat(int rowNumber, String columnDataClass, String ngRepeat)
    {
        return getTextOnTableWithNgRepeat(rowNumber, "class", columnDataClass, ngRepeat);
    }

    public String getTextOnTableWithNgRepeatUsingDataTitleText(int rowNumber, String columnDataTitleText, String ngRepeat)
    {
        return getTextOnTableWithNgRepeat(rowNumber, "data-title", columnDataTitleText, ngRepeat);
    }

    public String getTextOnTableWithNgRepeat(int rowNumber, String columnAttributeName, String attributeValue, String ngRepeat)
    {
        String text = null;

        try
        {
            WebElement we = findElementByXpath(String.format("//tr[@ng-repeat='%s'][%d]/td[starts-with(@%s, \"%s\")]", ngRepeat, rowNumber, columnAttributeName, attributeValue));
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
            String xpath = String.format("//tr[@ng-repeat='%s'][%d]/td[starts-with(@class, 'actions')]//nv-icon-button[@name='%s']", ngRepeat, rowNumber, actionButtonName);
            WebElement we = findElementByXpath(xpath);
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
            String xpath = String.format("//tr[@ng-repeat='%s'][%d]/td[starts-with(@class, '%s')]//button[@aria-label='%s']", ngRepeat, rowNumber, className, buttonAriaLabel);
            WebElement we = findElementByXpath(xpath);
            moveAndClick(we);
        }
        catch(NoSuchElementException ex)
        {
            throw new NvTestRuntimeException("Cannot find action button on table.", ex);
        }
    }

    public void selectValueFromNvAutocomplete(String searchTextAttribute, String value)
    {
        String xpath = String.format("//nv-autocomplete[@search-text='%s']//input", searchTextAttribute);
        WebElement we = findElementByXpath(xpath);
        we.sendKeys(value);
        pause1s();
        we.sendKeys(Keys.RETURN);
        pause100ms();
    }

    public void selectValueFromMdAutocomplete(String placeholder, String value)
    {
        String xpath = String.format("//md-autocomplete[@placeholder='%s']//input", placeholder);
        WebElement we = findElementByXpath(xpath);
        we.sendKeys(value);
        pause1s();
        we.sendKeys(Keys.RETURN);
        pause100ms();
    }

    public void selectValueFromMdSelect(String mdSelectNgModel, String value)
    {
        click(String.format("//md-select[@ng-model='%s']", mdSelectNgModel));
        pause100ms();
        click(String.format("//div[@aria-hidden='false']//md-option[@value='%s']", value));
        pause50ms();
    }

    public void selectValueFromMdSelectById(String mdSelectId, String value)
    {
        click(String.format("//md-select[starts-with(@id, '%s')]", mdSelectId));
        pause100ms();
        click(String.format("//div[@aria-hidden='false']//md-option[@value='%s' or contains(./div/text(), '%s')]", value, value));
        pause50ms();
    }

    public void selectValueFromMdSelectMenu(String xpathMdSelectMenu, String xpathMdSelectOption)
    {
        WebElement mdSelectMenu = findElementByXpath(xpathMdSelectMenu);
        mdSelectMenu.click();
        pause300ms();
        WebElement mdSelectOption = findElementByXpath(xpathMdSelectOption);
        mdSelectOption.click();
        pause300ms();
    }

    public void inputListBox(String placeHolder, String searchValue)
    {
        String xpath = String.format("//input[@placeholder='%s']", placeHolder);
        WebElement we = findElementByXpath(xpath);
        we.clear();
        we.sendKeys(searchValue);
        pause1s();
        we.sendKeys(Keys.RETURN);
        pause100ms();
        closeModal();
    }

    public void closeModal()
    {
        WebElement we = findElementByXpath("//div[(contains(@class, 'nv-text-ellipsis nv-h4'))]");

        Actions actions = new Actions(getwebDriver());
        actions.moveToElement(we, 5, 5)
                .click()
                .build()
                .perform();
        pause100ms();
    }

    public boolean isElementExist(String xpathExpression)
    {
        return isElementExist(xpathExpression, -1);
    }

    public boolean isElementExistFast(String xpathExpression)
    {
        return isElementExist(xpathExpression, FAST_WAIT_IN_SECONDS);
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

    public void searchTable(String keyword)
    {
        sendKeys("//input[@type='text'][@ng-model='searchText']", keyword);
    }

    public void searchTableCustom1(String columnClass, String keywords)
    {
        sendKeys(String.format("//th[contains(@class, '%s')]/nv-search-input-filter/md-input-container/div/input", columnClass), keywords);
        pause200ms();
    }

    public void searchTableCustom2(String columnClass, String keywords)
    {
        sendKeys(String.format("//th[starts-with(@class, '%s')]/nv-search-input-filter/md-input-container/div/input", columnClass), keywords);
        pause200ms();
    }

    public boolean isTableEmpty()
    {
        boolean isEmpty = false;

        try
        {
            WebElement webElement = findElementByXpath("//h5[text()='No Results Found']", FAST_WAIT_IN_SECONDS);
            isEmpty = webElement!=null;
        }
        catch(TimeoutException ex)
        {
            NvLogger.warn("Table is not empty.");
        }

        return isEmpty;
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
                    NvLogger.infof("waitUntilInvisibilityOfElementLocated: Is element { %s } still displayed: %b", locator, isElementDisplayed);
                    return !isElementDisplayed;
                }
                catch(NoSuchElementException ex)
                {
                    /**
                     * Returns true because the element is not present in DOM.
                     * The try block checks if the element is present but is invisible.
                     */
                    NvLogger.infof("waitUntilInvisibilityOfElementLocated: Is element { %s } still displayed: %b (NoSuchElementException)", locator, false);
                    return true;
                }
                catch(StaleElementReferenceException ex)
                {
                    /**
                     * Returns true because stale element reference implies that element
                     * is no longer visible.
                     */
                    NvLogger.infof("waitUntilInvisibilityOfElementLocated: Is element { %s } still displayed: %b (StaleElementReferenceException)", locator, false);
                    return true;
                }
            });
        }
        catch(Exception ex)
        {
            NvLogger.warnf("Error on method 'waitUntilInvisibilityOfElementLocated'. Cause: %s", ex.getMessage());
            throw ex;
        }
        finally
        {
            resetImplicitTimeout();
        }
    }

    public WebElement waitUntilVisibilityOfElementLocated(String xpath)
    {
        return waitUntilVisibilityOfElementLocated(By.xpath(xpath), TestConstants.SELENIUM_DEFAULT_WEB_DRIVER_WAIT_TIMEOUT_IN_SECONDS);
    }

    public WebElement waitUntilVisibilityOfElementLocated(String xpath, long timeoutInSeconds)
    {
        return waitUntilVisibilityOfElementLocated(By.xpath(xpath), timeoutInSeconds);
    }

    public WebElement waitUntilVisibilityOfElementLocated(By locator, long timeoutInSeconds)
    {
        try
        {
            setImplicitTimeout(0);

            return new WebDriverWait(getwebDriver(), timeoutInSeconds).until((WebDriver wd) ->
            {
                try
                {
                    WebElement webElement = elementIfVisible(findElement(locator, wd));
                    boolean isElementDisplayed = webElement!=null;
                    NvLogger.infof("waitUntilVisibilityOfElementLocated: Is element { %s } displayed: %b", locator, isElementDisplayed);
                    return webElement;
                }
                catch(NoSuchElementException ex)
                {
                    /**
                     * Returns false because the element is not present in DOM.
                     * The try block checks if the element is present but is invisible.
                     */
                    NvLogger.infof("waitUntilVisibilityOfElementLocated: Is element { %s } displayed: %b (NoSuchElementException)", locator, false);
                    return null;
                }
                catch(StaleElementReferenceException ex)
                {
                    /**
                     * Returns false because stale element reference implies that element
                     * is no longer visible.
                     */
                    NvLogger.infof("waitUntilVisibilityOfElementLocated: Is element { %s } displayed: %b (StaleElementReferenceException)", locator, false);
                    return null;
                }
            });
        }
        catch(Exception ex)
        {
            NvLogger.warnf("Error on method 'waitUntilVisibilityOfElementLocated'. Cause: %s", ex.getMessage());
            throw ex;
        }
        finally
        {
            resetImplicitTimeout();
        }
    }

    private static WebElement findElement(By by, WebDriver webDriver)
    {
        return webDriver.findElement(by);
    }

    private static WebElement elementIfVisible(WebElement element)
    {
        return element.isDisplayed()? element : null;
    }

    public String getLatestDownloadedFilename(String filenamePattern)
    {
        File parentDir = new File(TestConstants.TEMP_DIR);
        File[] arrayOfFiles = parentDir.listFiles((File dir, String name)->name.startsWith(filenamePattern));

        if(arrayOfFiles==null || arrayOfFiles.length==0)
        {
            throw new NvTestRuntimeException(String.format("There is no file with name starts with '%s' on folder '%s'.", filenamePattern, parentDir));
        }
        else if(arrayOfFiles.length>1)
        {
            Arrays.sort(arrayOfFiles, (File f1, File f2) -> Long.compare(f2.lastModified(), f1.lastModified()));
        }

        return arrayOfFiles[0].getName();
    }

    public void verifyFileDownloadedSuccessfully(String filename)
    {
        String pathname = TestConstants.TEMP_DIR + filename;
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
    }

    public void verifyFileDownloadedSuccessfully(String filename, String expectedText)
    {
        verifyFileDownloadedSuccessfully(filename);

        String pathname = TestConstants.TEMP_DIR + filename;
        File file;
        boolean isFileContainsExpectedText = false;
        StringBuilder fileText;
        int counter = 0;

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

    public void waitUntilPageLoaded()
    {
        waitUntilPageLoaded(TestConstants.SELENIUM_DEFAULT_WEB_DRIVER_WAIT_TIMEOUT_IN_SECONDS);
    }

    public void waitUntilPageLoaded(long timeoutInSeconds)
    {
        try
        {
            setImplicitTimeout(0);
            new WebDriverWait(getwebDriver(), timeoutInSeconds).until((WebDriver wd) ->
            {
                String state = String.valueOf(((JavascriptExecutor) wd).executeScript("return document.readyState"));
                NvLogger.infof("Waiting until document.readyState = complete. Current state: %s", state);
                return "complete".equals(state);
            });
        }
        finally
        {
            resetImplicitTimeout();
        }
    }

    public String getCurrentMethodName()
    {
        return StandardTestUtils.getCurrentMethodName();
    }

    public String generateDateUniqueString()
    {
        return StandardTestUtils.generateDateUniqueString();
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
        TestUtils.pause(millis);
    }

    public void refreshPage()
    {
        String previousUrl = getwebDriver().getCurrentUrl().toLowerCase();
        getwebDriver().navigate().refresh();

        new WebDriverWait(getwebDriver(), TestConstants.SELENIUM_DEFAULT_WEB_DRIVER_WAIT_TIMEOUT_IN_SECONDS).until((WebDriver wd) ->
        {
            boolean result;
            String currentUrl = wd.getCurrentUrl();
            NvLogger.infof("refreshPage: Current URL = [%s] - Expected URL = [%s]", currentUrl, previousUrl);

            if(previousUrl.contains("linehaul"))
            {
                result = currentUrl.contains("linehaul");
            }
            else
            {
                result = currentUrl.equalsIgnoreCase(previousUrl);
            }

            return result;
        });

        waitUntilPageLoaded();
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
