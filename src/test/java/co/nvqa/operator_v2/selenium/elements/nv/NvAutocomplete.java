package co.nvqa.operator_v2.selenium.elements.nv;

import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
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

    @FindBy(css = "md-progress-linear")
    public PageElement progressBar;

    public void selectValue(String value)
    {
        retryIfRuntimeExceptionOccurred(() ->
        {
            inputElement.clearAndSendKeys(value);
            pause1s();
            progressBar.waitUntilInvisible();

            String noMatchingErrorText = f("\"%s\" were found.", value);
            String notFoundXpath = f("//span[contains(text(), '%s')]", noMatchingErrorText);
            if (isElementVisible(notFoundXpath, WAIT_1_SECOND))
            {
                String actualNoMatchingErrorText = getText(notFoundXpath);
                throw new NvTestRuntimeException(f("Value not found on NV Autocomplete. Error message: %s", actualNoMatchingErrorText));
            }
        }, "Check if the value is not found on NV Autocomplete", 500, 5);

        String suggestionsId = inputElement.getAttribute("aria-owns");
        String menuXpath = f("//ul[@id='%s']", suggestionsId);
        String itemXpath = menuXpath + f("//li//span[contains(.,'%s')]", value);
        click(itemXpath);
        pause200ms();
        if (isElementVisible(menuXpath, 0))
        {
            inputElement.sendKeys(Keys.ESCAPE);
        }
    }

    public String getValue()
    {
        return getValue(inputElement.getWebElement());
    }
}