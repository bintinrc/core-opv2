package co.nvqa.operator_v2.selenium.elements.nv;

import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class NvAutocomplete extends PageElement
{
    public NvAutocomplete(WebDriver webDriver, WebElement webElement)
    {
        super(webDriver, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public NvAutocomplete(WebDriver webDriver, SearchContext searchContext, WebElement webElement)
    {
        super(webDriver, searchContext, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = ".//input")
    public PageElement inputElement;

    public void selectValue(String value)
    {
        inputElement.clearAndSendKeys(value);
        pause1s();

        /*
          Check if the value is not found on NV Autocomplete.
         */
        String noMatchingErrorText = f("\"%s\" were found.", value);

        retryIfRuntimeExceptionOccurred(() ->
        {
            try
            {
                WebElement noMatchingErrorWe = findElementByXpath(f("//span[contains(text(), '%s')]", noMatchingErrorText), WAIT_1_SECOND);
                String actualNoMatchingErrorText = getText(noMatchingErrorWe);
                throw new NvTestRuntimeException(f("Value not found on NV Autocomplete. Error message: %s", actualNoMatchingErrorText));
            } catch (NoSuchElementException | TimeoutException ignore)
            {
            }
        }, "Check if the value is not found on NV Autocomplete", 500, 5);

        inputElement.sendKeys(Keys.RETURN);
        pause200ms();
        String suggestionsId = inputElement.getAttribute("aria-owns");
        if (isElementVisible(f("//ul[@id='%s']", suggestionsId), 0))
        {
            inputElement.sendKeys(Keys.ESCAPE);
        }
    }

    public String getValue()
    {
        return getValue(inputElement.getWebElement());
    }
}