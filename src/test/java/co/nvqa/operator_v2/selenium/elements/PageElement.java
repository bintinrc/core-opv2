package co.nvqa.operator_v2.selenium.elements;

import co.nvqa.common_selenium.page.SimplePage;
import org.openqa.selenium.By;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

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
        webElement.click();
    }

    public void jsClick()
    {
        executeScript("arguments[0].click()", webElement);
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

    public SearchContext getSearchContext(){
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

    public void scrollIntoView(){
        scrollIntoView(webElement, false);
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

    public boolean isEnabled(){
        return webElement.isEnabled();
    }

    public WebElement findElement(By by){
        return webElement.findElement(by);
    }
}
