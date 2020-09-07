package co.nvqa.operator_v2.selenium.elements;

import co.nvqa.common_selenium.page.SimplePage;
import org.openqa.selenium.By;
import org.openqa.selenium.ElementClickInterceptedException;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.StaleElementReferenceException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

import java.util.Arrays;

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
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public PageElement(WebDriver webDriver, SearchContext searchContext, WebElement webElement)
    {
        this(webDriver, searchContext);
        this.webElement = webElement;
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public void moveAndClick()
    {
        moveAndClick(webElement);
    }

    public void click()
    {
        try
        {
            scrollIntoView();
            webElement.click();
        } catch (ElementClickInterceptedException ex)
        {
            jsClick();
        }
    }

    public void jsClick()
    {
        executeScript("arguments[0].click()", webElement);
    }

    public String getAttribute(String attributeName)
    {
        return getAttribute(webElement, attributeName);
    }

    public String getValue()
    {
        return getAttribute("value");
    }

    public String getCssValue(String propertyName)
    {
        return webElement.getCssValue(propertyName);
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

    public void sendKeys(Object value)
    {
        sendKeys(String.valueOf(value));
    }

    public void clearAndSendKeys(CharSequence keysToSend)
    {
        waitUntilClickable();
        clear();
        sendKeys(webElement, keysToSend);
    }

    public WebElement getWebElement()
    {
        try
        {
            webElement.getTagName();
        } catch (StaleElementReferenceException ex)
        {
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }
        return webElement;
    }

    public SearchContext getSearchContext()
    {
        return searchContext;
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

    public void scrollIntoView()
    {
        scrollIntoView(false);
    }

    public void scrollIntoView(boolean alignToTop)
    {
        scrollIntoView(webElement, alignToTop);
    }

    public void waitUntilClickable()
    {
        waitUntilElementIsClickable(webElement);
    }

    public void waitUntilClickable(int timeoutInSeconds)
    {
        waitUntilElementIsClickable(webElement, timeoutInSeconds);
    }

    public void waitUntilInvisible()
    {
        waitUntilInvisibilityOfElementLocated(webElement);
    }

    public boolean isEnabled()
    {
        return webElement.isEnabled();
    }

    public WebElement findElement(By by)
    {
        return webElement.findElement(by);
    }

    protected String escapeValue(String value)
    {
        return value.replace("'", "\\'");
    }

    public boolean hasClass(String className)
    {
        return Arrays.asList(getAttribute("class").split(" ")).contains(className);
    }
}
