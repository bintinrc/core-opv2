package co.nvqa.operator_v2.selenium.elements;

import co.nvqa.commons.util.NvTestRuntimeException;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

public class NvAutocomplete extends PageElement
{
    public NvAutocomplete(WebDriver webDriver, WebElement webElement)
    {
        super(webDriver, webElement);
    }

    private WebElement getInputElement()
    {
        return webElement.findElement(By.xpath(".//input"));
    }

    public void selectValue(String value)
    {
        WebElement inputElement = getInputElement();

        if (!inputElement.getAttribute("value").isEmpty())
        {
            inputElement.clear();
            pause200ms();
        }

        inputElement.sendKeys(value);
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
    }

    public String getValue()
    {
        return getValue(getInputElement());
    }
}