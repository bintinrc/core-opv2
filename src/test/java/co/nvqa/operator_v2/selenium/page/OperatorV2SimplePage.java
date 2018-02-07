package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common_selenium.page.SimplePage;
import co.nvqa.commons.utils.NvLogger;
import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.util.TestConstants;
import org.openqa.selenium.*;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.util.Date;
import java.util.List;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class OperatorV2SimplePage extends SimplePage
{
    public OperatorV2SimplePage(WebDriver webDriver)
    {
        super(webDriver);
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

    public void setMdDatepicker(String mdDatepickerNgModel, Date date)
    {
        sendKeys(String.format("//md-datepicker[@ng-model='%s']/div/input", mdDatepickerNgModel), MD_DATEPICKER_SDF.format(date));
        click(String.format("//md-datepicker[@ng-model='%s']/parent::*", mdDatepickerNgModel));
    }

    public void setMdDatepickerById(String mdDatepickerId, Date date)
    {
        sendKeys(String.format("//md-datepicker[@id='%s']/div/input", mdDatepickerId), MD_DATEPICKER_SDF.format(date));
        click(String.format("//md-datepicker[@id='%s']/parent::*", mdDatepickerId));
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

    public WebElement getToastTop()
    {
        String xpath = "//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div";
        return waitUntilVisibilityOfElementLocated(xpath);
    }

    public String getToastTopText()
    {
        String text = null;

        try
        {
            WebElement webElement = getToastTop();
            text = webElement.getText();
        }
        catch(RuntimeException ex)
        {
            NvLogger.warn("Failed to get text from element Toast Top.");
        }

        return text;
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
        click(String.format("//div[@aria-hidden='false']//md-option[contains(@value,'%s')]", value));
        pause50ms();
    }

    public void selectValueFromMdSelectById(String mdSelectId, String value)
    {
        click(String.format("//md-select[starts-with(@id, '%s')]", mdSelectId));
        pause100ms();
        click(String.format("//div[@aria-hidden='false']//md-option[contains(@value,'%s') or contains(./div/text(),'%s')]", value, value));
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

        Actions actions = new Actions(getWebDriver());
        actions.moveToElement(we, 5, 5)
                .click()
                .build()
                .perform();
        pause100ms();
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

    public void clearSearchTableCustom1(String columnClass)
    {
        String xpathExpression = String.format("//th[contains(@class, '%s')]/nv-search-input-filter/md-input-container/div/button[@aria-hidden='true']", columnClass);

        if(isElementExistWait1Second(xpathExpression))
        {
            click(xpathExpression);
        }
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

    public void selectAllShown(String nvTableParam)
    {
        click(String.format("//nv-table[@param='%s']//button[@aria-label='Selection']", nvTableParam));
        pause100ms();
        clickButtonByAriaLabel("Select All Shown");
        pause100ms();
    }

    private static WebElement findElement(By by, WebDriver webDriver)
    {
        return webDriver.findElement(by);
    }

    private static WebElement elementIfVisible(WebElement element)
    {
        return element.isDisplayed()? element : null;
    }

    public void refreshPage()
    {
        String previousUrl = getWebDriver().getCurrentUrl().toLowerCase();
        getWebDriver().navigate().refresh();

        new WebDriverWait(getWebDriver(), TestConstants.SELENIUM_DEFAULT_WEB_DRIVER_WAIT_TIMEOUT_IN_SECONDS).until((WebDriver wd) ->
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
}
