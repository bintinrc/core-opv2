package co.nvqa.operator_v2.selenium.elements;

import co.nvqa.common_selenium.page.SimplePage;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

public class PageElement extends SimplePage
{
    protected WebElement webElement;

    public PageElement(WebDriver webDriver)
    {
        super(webDriver);
    }

    public PageElement(WebDriver webDriver, SearchContext searchContext)
    {
        super(webDriver, searchContext);
    }

    public PageElement(WebDriver webDriver, WebElement webElement)
    {
        this(webDriver);
        this.webElement = webElement;
    }

    public PageElement(WebDriver webDriver, SearchContext searchContext, WebElement webElement)
    {
        this(webDriver, searchContext);
        this.webElement = webElement;
    }

    public void moveAndClick()
    {
        moveAndClick(webElement);
    }

    public String getAttribute(String attributeName)
    {
        return getAttribute(webElement, attributeName);
    }

    public String getText()
    {
        return getText(webElement);
    }

    public void clear()
    {
        webElement.clear();
    }

    public void sendKeys(CharSequence keysToSend)
    {
        sendKeysWithoutClear(webElement, keysToSend);
    }

    public void clearAndSendKeys(CharSequence keysToSend)
    {
        sendKeys(webElement, keysToSend);
    }

    public WebElement getWebElement()
    {
        return webElement;
    }

    public boolean isDisplayedFast()
    {
        try
        {
            setImplicitTimeout(0);
            return webElement.isDisplayed();
        } catch (Exception ex)
        {
            return false;
        } finally
        {
            resetImplicitTimeout();
        }
    }

    public void waitUntilClickable()
    {
        waitUntilElementIsClickable(webElement);
    }

}
