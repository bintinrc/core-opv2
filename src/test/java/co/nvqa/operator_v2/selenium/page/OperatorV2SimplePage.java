package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common_selenium.page.SimplePage;
import co.nvqa.commons.utils.NvLogger;
import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.commons.utils.StandardTestUtils;
import co.nvqa.operator_v2.util.TestConstants;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;

import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class OperatorV2SimplePage extends SimplePage
{
    public OperatorV2SimplePage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void goToUrl(String url)
    {
        getWebDriver().navigate().to(url);
    }

    public void clickAndWaitUntilDone(String xpathExpression)
    {
        click(xpathExpression);
        waitUntilInvisibilityOfElementLocated(xpathExpression + "//md-progress-circular");
    }

    public void clickButtonByAriaLabel(String ariaLabel)
    {
        clickf("//button[@aria-label='%s']", ariaLabel);
    }

    public void clickButtonByAriaLabelAndWaitUntilDone(String ariaLabel)
    {
        String xpathExpression = String.format("//button[@aria-label='%s']", ariaLabel);
        click(xpathExpression);
        waitUntilInvisibilityOfElementLocated(xpathExpression + "/div[contains(@class,'show')]/md-progress-circular");
    }

    public void clickNvIconButtonByName(String name)
    {
        clickf("//nv-icon-button[@name='%s']", name);
    }

    public void clickNvIconButtonByNameAndWaitUntilEnabled(String name)
    {
        String xpathExpression = String.format("//nv-icon-button[@name='%s']", name);
        click(xpathExpression);
        waitUntilInvisibilityOfElementLocated(xpathExpression + "/button[@disabled='disabled']");
    }

    public void clickNvIconTextButtonByName(String name)
    {
        clickf("//nv-icon-text-button[@name='%s']", name);
    }

    public void clickNvIconTextButtonByNameAndWaitUntilDone(String name)
    {
        String xpathExpression = String.format("//nv-icon-text-button[@name='%s']", name);
        click(xpathExpression);
        waitUntilInvisibilityOfElementLocated(xpathExpression + "/button/div[contains(@class,'show')]/md-progress-circular");
    }

    public void clickNvApiTextButtonByName(String name)
    {
        clickf("//nv-api-text-button[@name='%s']", name);
    }

    public void clickNvApiTextButtonByNameAndWaitUntilDone(String name)
    {
        String xpathExpression = String.format("//nv-api-text-button[@name='%s']", name);
        click(xpathExpression);
        waitUntilInvisibilityOfElementLocated(xpathExpression + "/button/div[contains(@class,'show')]/md-progress-circular");
    }

    public void clickNvApiIconButtonByName(String name)
    {
        clickf("//nv-api-icon-button[@name='%s']", name);
    }

    public void clickNvApiIconButtonByNameAndWaitUntilDone(String name)
    {
        String xpathExpression = String.format("//nv-api-icon-button[@name='%s']", name);
        click(xpathExpression);
        waitUntilInvisibilityOfElementLocated(xpathExpression + "/button/div[contains(@class,'waiting')]/md-progress-circular");
    }

    public void clickNvButtonSaveByName(String name)
    {
        clickf("//nv-button-save[@name='%s']", name);
    }

    public void clickNvButtonSaveByNameAndWaitUntilDone(String name)
    {
        String xpathExpression = String.format("//nv-button-save[@name='%s']", name);
        click(xpathExpression);
        waitUntilInvisibilityOfElementLocated(xpathExpression + "/button/div[contains(@class,'saving')]/md-progress-circular");
    }

    public void clickButtonOnMdDialogByAriaLabel(String ariaLabel)
    {
        clickf("//md-dialog//button[@aria-label='%s']", ariaLabel);
    }

    public void clickButtonOnMdDialogByAriaLabelIgnoreCase(String ariaLabel)
    {
        clickf("//md-dialog//button[translate(@aria-label,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')=translate('%s','ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')]", ariaLabel);
    }

    public void clear(String xpathExpression)
    {
        WebElement we = findElementByXpath(xpathExpression);
        we.clear();
        pause100ms();
    }

    public void clearf(String xpathExpression, Object... args)
    {
        xpathExpression = String.format(xpathExpression, args);
        WebElement we = findElementByXpath(xpathExpression);
        we.clear();
        pause100ms();
    }

    public void sendKeysByIdCustom1(String id, CharSequence... keysToSend)
    {
        String xpathExpression = String.format("//*[self::input or self::textarea][starts-with(@id, '%s')]", id);
        WebElement we = findElementByXpath(xpathExpression);
        we.click();
        we.sendKeys(keysToSend);
        pause50ms();
    }

    public void sendKeysAndEnterByAriaLabel(String ariaLabel, CharSequence... keysToSend)
    {
        sendKeysAndEnter(String.format("//*[@aria-label='%s']", ariaLabel), keysToSend);
    }

    public void sendKeysToMdInputContainerByModel(String mdInputContainerModel, CharSequence... keysToSend)
    {
        sendKeys(String.format("//md-input-container[@model='%s']/input", mdInputContainerModel), keysToSend);
    }

    public void setMdDatepicker(String mdDatepickerNgModel, Date date)
    {
        sendKeys(String.format("//md-datepicker[@ng-model='%s']/div/input", mdDatepickerNgModel), MD_DATEPICKER_SDF.format(date));
        clickf("//md-datepicker[@ng-model='%s']/parent::*", mdDatepickerNgModel);
    }

    public void setMdDatepickerById(String mdDatepickerId, Date date)
    {
        sendKeys(String.format("//md-datepicker[@id='%s']/div/input", mdDatepickerId), MD_DATEPICKER_SDF.format(date));
        clickf("//md-datepicker[@id='%s']/parent::*", mdDatepickerId);
    }

    public void clickTabItem(String tabItemText)
    {
        clickf("//tab-item[contains(text(), '%s')]", tabItemText);
    }

    public void waitUntilVisibilityOfToast(String containsMessage)
    {
        waitUntilVisibilityOfElementLocated(String.format("//div[@id='toast-container']//div[contains(text(), '%s')]", containsMessage));
    }

    public void waitUntilInvisibilityOfToast(String containsMessage)
    {
        waitUntilInvisibilityOfToast(containsMessage, true);
    }

    public void waitUntilInvisibilityOfToast(String containsMessage, boolean waitUntilElementVisibleFirst)
    {
        String xpathExpression = String.format("//div[@id='toast-container']//div[contains(text(), '%s')]", containsMessage);

        if(waitUntilElementVisibleFirst)
        {
            waitUntilVisibilityOfElementLocated(xpathExpression);
        }

        waitUntilInvisibilityOfElementLocated(xpathExpression);
    }

    public void clickToast(String containsMessage)
    {
        clickToast(containsMessage, true);
    }

    public void clickToast(String containsMessage, boolean waitUntilElementVisibleFirst)
    {
        String xpathExpression = String.format("//div[@id='toast-container']//div[contains(text(), '%s')]", containsMessage);

        if(waitUntilElementVisibleFirst)
        {
            waitUntilVisibilityOfElementLocated(xpathExpression);
        }

        clickf(xpathExpression);
    }

    public WebElement getToast()
    {
        String xpathExpression = "//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div";
        return waitUntilVisibilityOfElementLocated(xpathExpression);
    }

    public List<WebElement> getToasts()
    {
        String xpathExpression = "//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div";
        waitUntilVisibilityOfElementLocated(xpathExpression);
        return findElementsByXpath(xpathExpression);
    }

    public WebElement getToastTop()
    {
        String xpathExpression = "//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div";
        return waitUntilVisibilityOfElementLocated(xpathExpression);
    }

    public String getToastTopText()
    {
        return getToastText("//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div");
    }

    public WebElement getToastBottom()
    {
        String xpathExpression = "//div[@id='toast-container']/div/div/div/div[@class='toast-bottom']";
        return waitUntilVisibilityOfElementLocated(xpathExpression);
    }

    public String getToastBottomText()
    {
        return getToastText("//div[@id='toast-container']/div/div/div/div[@class='toast-bottom']");
    }

    public String getToastText(String toastXpathExpression)
    {
        String text = null;

        try
        {
            WebElement webElement = waitUntilVisibilityOfElementLocated(toastXpathExpression);
            text = webElement.getText();
        }
        catch(RuntimeException ex)
        {
            NvLogger.warn("Failed to get text from element Toast.");
        }

        return text;
    }

    public String getTextOnTable(int rowNumber, String columnDataClass, String mdVirtualRepeat)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, mdVirtualRepeat);
    }

    public String getTextOnTableWithMdVirtualRepeat(int rowNumber, String columnDataClass, String mdVirtualRepeat)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, mdVirtualRepeat, XpathTextMode.STARTS_WITH);
    }

    public String getTextOnTableWithMdVirtualRepeat(int rowNumber, String columnDataClass, String mdVirtualRepeat, String nvTableParam)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, mdVirtualRepeat, XpathTextMode.STARTS_WITH, nvTableParam);
    }

    public String getTextOnTableWithMdVirtualRepeat(int rowNumber, String columnDataClass, String mdVirtualRepeat, XpathTextMode xpathTextMode)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, mdVirtualRepeat, xpathTextMode, null);
    }

    public String getTextOnTableWithMdVirtualRepeat(int rowNumber, String columnDataClass, String mdVirtualRepeat, XpathTextMode xpathTextMode, String nvTableParam)
    {
        String text = null;

        try
        {
            String nvTableXpathExpression = "";

            if(!isBlank(nvTableParam))
            {
                nvTableXpathExpression = String.format("//nv-table[@param='%s']", nvTableParam);
            }

            WebElement we;

            switch(xpathTextMode)
            {
                case EXACT      : we = findElementByXpath(String.format("%s//tr[@md-virtual-repeat='%s'][%d]/td[normalize-space(@class)='%s']", nvTableXpathExpression, mdVirtualRepeat, rowNumber, columnDataClass)); break;
                case CONTAINS   : we = findElementByXpath(String.format("%s//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, '%s')]", nvTableXpathExpression, mdVirtualRepeat, rowNumber, columnDataClass)); break;
                case STARTS_WITH: we = findElementByXpath(String.format("%s//tr[@md-virtual-repeat='%s'][%d]/td[starts-with(@class, '%s')]", nvTableXpathExpression, mdVirtualRepeat, rowNumber, columnDataClass)); break;
                default         : we = findElementByXpath(String.format("%s//tr[@md-virtual-repeat='%s'][%d]/td[starts-with(@class, '%s')]", nvTableXpathExpression, mdVirtualRepeat, rowNumber, columnDataClass));
            }

            text = we.getText().trim();
        }
        catch(NoSuchElementException ex)
        {
            NvLogger.warn("Failed to find element by XPath.");
        }

        return text;
    }

    public void clickActionButtonOnTableWithMdVirtualRepeat(int rowNumber, String actionButtonName, String mdVirtualRepeat)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, mdVirtualRepeat, XpathTextMode.STARTS_WITH, null);
    }

    public void clickCustomActionButtonOnTableWithMdVirtualRepeat(int rowNumber, String actionButtonXpath, String mdVirtualRepeat)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, mdVirtualRepeat, XpathTextMode.STARTS_WITH, null, actionButtonXpath);
    }

    public void clickActionButtonOnTableWithMdVirtualRepeat(int rowNumber, String actionButtonName, String mdVirtualRepeat, XpathTextMode xpathTextMode)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, mdVirtualRepeat, xpathTextMode, null);
    }

    public void clickActionButtonOnTableWithMdVirtualRepeat(int rowNumber, String actionButtonName, String mdVirtualRepeat, String nvTableParam)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, mdVirtualRepeat, XpathTextMode.STARTS_WITH, nvTableParam);
    }

    public void clickActionButtonOnTableWithMdVirtualRepeat(int rowNumber, String actionButtonName, String mdVirtualRepeat, XpathTextMode xpathTextMode, String nvTableParam)
    {
        String actionButtonXpath = String.format("//nv-icon-button[@name='%s']", actionButtonName);
        try
        {
            clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, mdVirtualRepeat, xpathTextMode, nvTableParam, actionButtonXpath);
        }
        catch(RuntimeException ex)
        {
            throw new RuntimeException(String.format("Cannot find action button '%s' on table.", actionButtonName), ex);
        }
    }

    public void clickActionButtonOnTableWithMdVirtualRepeat(int rowNumber, String mdVirtualRepeat, XpathTextMode xpathTextMode, String nvTableParam, String actionButtonXpath)
    {
        try
        {
            String nvTableXpathExpression = "";

            if(!isBlank(nvTableParam))
            {
                nvTableXpathExpression = String.format("//nv-table[@param='%s']", nvTableParam);
            }

            String xpathExpression;

            switch(xpathTextMode)
            {
                case CONTAINS   : xpathExpression = String.format("%s//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, 'actions')]%s", nvTableXpathExpression, mdVirtualRepeat, rowNumber, actionButtonXpath); break;
                case STARTS_WITH: xpathExpression = String.format("%s//tr[@md-virtual-repeat='%s'][%d]/td[starts-with(@class, 'actions')]%s", nvTableXpathExpression, mdVirtualRepeat, rowNumber, actionButtonXpath); break;
                default         : xpathExpression = String.format("%s//tr[@md-virtual-repeat='%s'][%d]/td[starts-with(@class, 'actions')]%s", nvTableXpathExpression, mdVirtualRepeat, rowNumber, actionButtonXpath);
            }

            WebElement we = findElementByXpath(xpathExpression);
            moveAndClick(we);
        }
        catch(NoSuchElementException ex)
        {
            throw new RuntimeException(String.format("Cannot find action button '%s' on table.", actionButtonXpath), ex);
        }
    }

    /**
     *
     * @param rowNumber The row number.
     * @param columnClassName The column's class name.
     * @param buttonAriaLabel The button's aria label.
     * @param ngRepeat Ng-Repeat used in the tag.
     */
    public void clickButtonOnTableWithMdVirtualRepeat(int rowNumber, String columnClassName, String buttonAriaLabel, String ngRepeat)
    {
        try
        {
            String xpathExpression = String.format("//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, '%s')]//button[@aria-label='%s']", ngRepeat, rowNumber, columnClassName, buttonAriaLabel);
            WebElement we = findElementByXpath(xpathExpression);
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

    public int getRowsCountOfTableWithNgRepeat(String ngRepeat)
    {
        try
        {
            List<WebElement> webElements = findElementsByXpath(String.format("//tr[@ng-repeat='%s']", ngRepeat));
            return webElements.size();
        }
        catch(NoSuchElementException ex)
        {
            NvLogger.warn("Table with NgRepeat [" + ngRepeat + "] was not found");
            return 0;
        }
    }

    public int getRowsCountOfTableWithMdVirtualRepeat(String mdVirtualRepeat)
    {
        try
        {
            List<WebElement> webElements = findElementsByXpath(String.format("//tr[@md-virtual-repeat='%s']", mdVirtualRepeat));
            return webElements.size();
        }
        catch(NoSuchElementException | TimeoutException ex)
        {
            NvLogger.warn("Table with md-virtual-repeat [" + mdVirtualRepeat + "] was not found");
            return 0;
        }
    }

    public int getRowsCountOfTableWithMdVirtualRepeatFast(String mdVirtualRepeat)
    {
        try
        {
            List<WebElement> webElements = findElementsByXpathFast(String.format("//tr[@md-virtual-repeat='%s']", mdVirtualRepeat));
            return webElements.size();
        }
        catch(NoSuchElementException | TimeoutException ex)
        {
            NvLogger.warn("Table with md-virtual-repeat [" + mdVirtualRepeat + "] was not found");
            return 0;
        }
    }

    public String getSelectedValueOfMdAutocompleteOnTableWithNgRepeat(int rowNumber, String columnDataClass, String ngRepeat)
    {
        return getSelectedValueOfMdAutocompleteOnTableWithNgRepeat(rowNumber, "class", columnDataClass, ngRepeat);
    }

    public String getSelectedValueOfMdAutocompleteOnTableWithNgRepeat(int rowNumber, String columnAttributeName, String attributeValue, String ngRepeat)
    {
        String value = null;

        try
        {
            WebElement we = findElementByXpath(String.format("//tr[@ng-repeat='%s'][%d]/td[starts-with(@%s, \"%s\")]/nv-autocomplete//input", ngRepeat, rowNumber, columnAttributeName, attributeValue));
            value = we.getAttribute("value").trim();
        }
        catch(NoSuchElementException ex)
        {
            NvLogger.warn("Failed to getTextOnTableWithNgRepeat.");
        }

        return value;
    }

    public String getTextOnTableWithNgRepeatUsingDataTitle(int rowNumber, String columnDataTitle, String ngRepeat)
    {
        return getTextOnTableWithNgRepeat(rowNumber, "data-title", columnDataTitle, ngRepeat);
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
            NvLogger.warn("Failed to getTextOnTableWithNgRepeat.");
        }

        return text;
    }

    public void clickActionButtonOnTableWithNgRepeat(int rowNumber, String actionButtonName, String ngRepeat)
    {
        try
        {
            String xpathExpression = String.format("//tr[@ng-repeat='%s'][%d]/td[starts-with(@class, 'actions')]//nv-icon-button[@name='%s']", ngRepeat, rowNumber, actionButtonName);
            WebElement we = findElementByXpath(xpathExpression);
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
            String xpathExpression = String.format("//tr[@ng-repeat='%s'][%d]/td[starts-with(@class, '%s')]//button[@aria-label='%s']", ngRepeat, rowNumber, className, buttonAriaLabel);
            WebElement we = findElementByXpath(xpathExpression);
            moveAndClick(we);
        }
        catch(NoSuchElementException ex)
        {
            throw new NvTestRuntimeException("Cannot find action button on table.", ex);
        }
    }

    public void sendKeysToMdInputContainerOnTableWithNgRepeat(int rowNumber, String inputModel, String ngRepeat, CharSequence... keysToSend)
    {
        try
        {
            String xpathExpression = String.format("//tr[@ng-repeat='%s'][%d]/td//md-input-container[@model='%s']/input", ngRepeat, rowNumber, inputModel);
            sendKeys(xpathExpression, keysToSend);
        }
        catch(NoSuchElementException ex)
        {
            throw new NvTestRuntimeException("Cannot find md input on table.", ex);
        }
    }

    public void checkRowWithMdVirtualRepeat(int rowNumber, String mdVirtualRepeat)
    {
        WebElement mdCheckboxWe = findElementByXpath(String.format("//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, 'column-checkbox')]/md-checkbox", mdVirtualRepeat, rowNumber));
        String ariaChecked = getAttribute(mdCheckboxWe, "aria-checked");

        if("false".equalsIgnoreCase(ariaChecked))
        {
            mdCheckboxWe.click();
        }
    }

    public void clickToggleButton(String divModel, String buttonAriaLabel)
    {
        clickf("//div[@model='%s']//button[@aria-label='%s']", divModel, buttonAriaLabel);
    }

    public String getToggleButtonValue(String divModel)
    {
        return getText(String.format("//div[@model='%s']//button[contains(@class,'raised')]/span", divModel));
    }

    public void selectValueFromNvAutocomplete(String searchText, String value)
    {
        selectValueFromNvAutocompleteBy("search-text", searchText, value);
    }

    public void selectValueFromNvAutocompleteByItemTypes(String itemTypes, String value)
    {
        selectValueFromNvAutocompleteBy("item-types", itemTypes, value);
    }

    public void selectValueFromNvAutocompleteByItemTypesAndDismiss(String itemTypes, String value)
    {
        WebElement we = selectValueFromNvAutocompleteBy("item-types", itemTypes, value);
        we.sendKeys(Keys.ESCAPE);
        pause200ms();
    }

    public void selectValueFromNvAutocompleteBySearchTextAndDismiss(String searchText, String value)
    {
        WebElement we = selectValueFromNvAutocompleteBy("search-text", searchText, value);
        we.sendKeys(Keys.ESCAPE);
        pause200ms();
    }

    public void removeNvFilterBoxByMainTitle(String mainTtitle)
    {
        String xpath = String.format("//*[self::nv-filter-text-box or self::nv-filter-box][@main-title='%s']//button[i[text()='close']]", mainTtitle);
        click(xpath);
    }

    public void selectValueFromNvAutocompleteByPossibleOptions(String possibleOptions, String value)
    {
        selectValueFromNvAutocompleteBy("possible-options", possibleOptions, value);
    }

    private WebElement selectValueFromNvAutocompleteBy(String nvAutocompleteAttribute, String nvAutocompleteAttributeValue, String value)
    {
        String xpathExpression = String.format("//nv-autocomplete[@%s='%s']//input", nvAutocompleteAttribute, nvAutocompleteAttributeValue);
        WebElement we = findElementByXpath(xpathExpression);

        if(!we.getAttribute("value").isEmpty())
        {
            we.clear();
            pause200ms();
        }

        we.sendKeys(value);
        pause1s();

        /*
          Check if the value is not found on NV Autocomplete.
         */
        String noMatchingErrorText = String.format("\"%s\" were found.", value);

        try
        {
            WebElement noMatchingErrorWe = findElementByXpath(String.format("//span[contains(text(), '%s')]", noMatchingErrorText), WAIT_1_SECOND);
            String actualNoMatchingErrorText = getText(noMatchingErrorWe);
            throw new NvTestRuntimeException(String.format("Value not found on NV Autocomplete. Error message: %s", actualNoMatchingErrorText));
        }
        catch(NoSuchElementException | TimeoutException ex)
        {
        }

        we.sendKeys(Keys.RETURN);
        pause200ms();
        return we;
    }

    public String getNvAutocompleteValue(String searchTextAttribute)
    {
        return getValue(String.format("//nv-autocomplete[@search-text='%s']//input", searchTextAttribute));
    }

    public void selectValueFromMdAutocomplete(String placeholder, String value)
    {
        String xpathExpression = String.format("//md-autocomplete[@placeholder='%s']//input", placeholder);
        WebElement we = findElementByXpath(xpathExpression);
        we.sendKeys(value);
        pause1s();
        we.sendKeys(Keys.RETURN);
        pause100ms();
    }

    public void selectValueFromMdSelect(String mdSelectNgModel, String value)
    {
        clickf("//md-select[@ng-model='%s']", mdSelectNgModel);
        pause100ms();
        clickf("//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[contains(@value,'%s') or contains(./div/text(),'%s')]", value, value);
        pause50ms();
    }

    public void selectMultipleValuesFromMdSelect(String mdSelectNgModel, List<String> listOfValues)
    {
        selectMultipleValuesFromMdSelect(mdSelectNgModel, XpathTextMode.CONTAINS, listOfValues);
    }

    public void selectMultipleValuesFromMdSelect(String mdSelectNgModel, XpathTextMode xpathTextMode, List<String> listOfValues)
    {
        if(listOfValues!=null && !listOfValues.isEmpty())
        {
            selectMultipleValuesFromMdSelect(mdSelectNgModel, xpathTextMode, listOfValues.toArray(new String[]{}));
        }
    }

    public void selectMultipleValuesFromMdSelect(String mdSelectNgModel, String... values)
    {
        selectMultipleValuesFromMdSelect(mdSelectNgModel, XpathTextMode.CONTAINS, values);
    }

    public void selectMultipleValuesFromMdSelect(String mdSelectNgModel, XpathTextMode xpathTextMode, String... values)
    {
        clickf("//md-select[@ng-model='%s']", mdSelectNgModel);
        pause100ms();

        for(String value : values)
        {
            switch(xpathTextMode)
            {
                case EXACT   : clickf("//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[@value='%s']", value); break;
                case CONTAINS: clickf("//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[contains(@value,'%s')]", value); break;
                default      : clickf("//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[contains(@value,'%s')]", value);
            }

            pause40ms();
        }

        Actions actions = new Actions(getWebDriver());
        actions.sendKeys(Keys.ESCAPE).build().perform();
        pause300ms();
    }

    public void selectMultipleValuesFromMdSelectById(String mdSelectId, List<String> listOfValues)
    {
        selectMultipleValuesFromMdSelectById(mdSelectId, XpathTextMode.CONTAINS, listOfValues);
    }

    public void selectMultipleValuesFromMdSelectById(String mdSelectId, XpathTextMode xpathTextMode, List<String> listOfValues)
    {
        if(listOfValues!=null && !listOfValues.isEmpty())
        {
            selectMultipleValuesFromMdSelectById(mdSelectId, xpathTextMode, listOfValues.toArray(new String[]{}));
        }
    }

    public void selectMultipleValuesFromMdSelectById(String mdSelectId, String... values)
    {
        selectMultipleValuesFromMdSelectById(mdSelectId, XpathTextMode.CONTAINS, values);
    }

    public void selectMultipleValuesFromMdSelectById(String mdSelectId, XpathTextMode xpathTextMode, String... values)
    {
        clickf("//md-select[starts-with(@id, '%s')]", mdSelectId);
        pause100ms();

        for(String value : values)
        {
            switch(xpathTextMode)
            {
                case EXACT   : clickf("//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[@value='%s' or ./div/text()='%s']", value); break;
                case CONTAINS: clickf("//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[contains(@value,'%s') or contains(./div/text(),'%s')]", value, value); break;
                default      : clickf("//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[contains(@value,'%s') or contains(./div/text(),'%s')]", value, value); break;
            }

            pause100ms();
        }

        Actions actions = new Actions(getWebDriver());
        actions.sendKeys(Keys.ESCAPE).build().perform();
        pause300ms();
    }

    public void toggleMdSwithcById(String mdSwitchId, boolean state)
    {
        String xpath = String.format("//md-switch[starts-with(@id, '%s')]", mdSwitchId);
        boolean currentState = Boolean.parseBoolean(getAttribute(xpath, "aria-checked"));
        if (currentState != state){
            click(xpath);
        }
    }

    public void selectValueFromMdSelectById(String mdSelectId, String value)
    {
        clickf("//md-select[starts-with(@id, '%s')]", mdSelectId);
        pause100ms();
        clickf("//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[contains(@value,'%s') or contains(./div/text(),'%s')]", value, value);
        pause50ms();
    }

    public void selectValueFromMdSelectByIdContains(String mdSelectId, String value)
    {
        clickf("//md-select[contains(@id, '%s')]", mdSelectId);
        pause100ms();
        clickf("//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[contains(@value,'%s') or contains(./div/text(),'%s')]", value, value);
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

    public String getMdSelectValue(String mdSelectNgModel)
    {
        return getText(String.format("//md-select[@ng-model='%s']/md-select-value/span/div[@class='md-text']", mdSelectNgModel));
    }

    public String getMdSelectValueById(String mdSelectId)
    {
        return getText(String.format("//md-select[contains(@id,'%s')]/md-select-value/span/div[@class='md-text']", mdSelectId));
    }

    public String getMdSelectedItemValueAttributeById(String mdSelectId)
    {
        return getAttribute(String.format("//md-select[contains(@id,'%s')]//md-option[@selected='selected']", mdSelectId), "value");
    }

    public String getMdSelectValueTrimmed(String mdSelectNgModel)
    {
        String value = getMdSelectValue(mdSelectNgModel);

        if(value!=null)
        {
            value = value.trim();
        }

        return value;
    }

    public List<String> getMdSelectMultipleValues(String mdSelectNgModel)
    {
        List<WebElement> listOfWe = findElementsByXpath(String.format("//md-select[@ng-model='%s']/md-select-value/span/div[@class='md-text']", mdSelectNgModel));

        if(listOfWe!=null)
        {
            return listOfWe.stream().map(WebElement::getText).collect(Collectors.toList());
        }

        return null;
    }

    public List<String> getMdSelectMultipleValuesTrimmed(String mdSelectNgModel)
    {
        List<WebElement> listOfWe = findElementsByXpath(String.format("//md-select[@ng-model='%s']/md-select-value/span/div[@class='md-text']", mdSelectNgModel));

        if(listOfWe!=null)
        {
            return listOfWe.stream().map(this::getTextTrimmed).collect(Collectors.toList());
        }

        return null;
    }

    public void inputListBox(String placeHolder, String searchValue)
    {
        String xpathExpression = String.format("//input[@placeholder='%s']", placeHolder);
        WebElement we = findElementByXpath(xpathExpression);
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
        String xpathExpression = String.format("//th[contains(@class, '%s')]/nv-search-input-filter/md-input-container/div/button[@aria-hidden='false']", columnClass);

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
        clickf("//nv-table[@param='%s']//button[@aria-label='Selection']", nvTableParam);
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
        acceptAlertDialogIfAppear();
        String previousUrl = getCurrentUrl().toLowerCase();
        getWebDriver().navigate().refresh();
        acceptAlertDialogIfAppear();

        waitUntil(()->
        {
            boolean result;
            String currentUrl = getCurrentUrl();
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
        }, TestConstants.SELENIUM_WEB_DRIVER_WAIT_TIMEOUT_IN_MILLISECONDS);

        waitUntilPageLoaded();
    }

    public void waitUntilNewWindowOrTabOpened()
    {
        NvLogger.info("Wait until new window or tab opened.");
        wait5sUntil(()->getWebDriver().getWindowHandles().size()>1, String.format("Window handles size is = %d.", getWebDriver().getWindowHandles().size()));
    }

    public void switchToOtherWindow(String expectedUrlEndWith)
    {
        waitUntilNewWindowOrTabOpened();
        String currentWindowHandle = getWebDriver().getWindowHandle();
        Set<String> windowHandles = getWebDriver().getWindowHandles();
        boolean windowFound = false;

        for(String windowHandle : windowHandles)
        {
            getWebDriver().switchTo().window(windowHandle);
            String currentWindowUrl = getCurrentUrl();

            if(currentWindowUrl.endsWith(expectedUrlEndWith))
            {
                windowFound = true;
                break;
            }
        }

        if(!windowFound)
        {
            getWebDriver().switchTo().window(currentWindowHandle);
            throw new NvTestRuntimeException(String.format("Window with URL end with '%s' not found.", expectedUrlEndWith));
        }
    }

    public void closeAllWindowsAcceptTheMainWindow(String mainWindowHandle)
    {
        Set<String> windowHandles = getWebDriver().getWindowHandles();

        for(String windowHandle : windowHandles)
        {
            if(!windowHandle.equals(mainWindowHandle))
            {
                getWebDriver().switchTo().window(windowHandle);
                getWebDriver().close();
            }
        }

        getWebDriver().switchTo().window(mainWindowHandle);
    }

    public String convertTimeFrom24sHourTo12HoursAmPm(String the24HourTime)
    {
        return StandardTestUtils.convertTimeFrom24sHourTo12HoursAmPm(the24HourTime);
    }

    public void clickMdMenuItem(String parentMenuName, String childMenuName){
        clickf("//md-menu-bar/md-menu/button[*[contains(text(), '%s')]]", parentMenuName);
        waitUntilVisibilityOfElementLocated("//div[@aria-hidden='false']/md-menu-content");
        clickf("//div[@aria-hidden='false']/md-menu-content/md-menu-item/button/span[contains(text(), '%s')]", childMenuName);
    }
}
