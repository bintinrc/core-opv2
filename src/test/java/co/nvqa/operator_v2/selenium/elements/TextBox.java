package co.nvqa.operator_v2.selenium.elements;

import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

public class TextBox extends PageElement
{
    public TextBox(WebDriver webDriver, WebElement webElement)
    {
        super(webDriver, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public TextBox(WebDriver webDriver, SearchContext searchContext, WebElement webElement)
    {
        super(webDriver, searchContext, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public void setValue(String value)
    {
        clearAndSendKeys(value);
    }

    public void jsSetValue(String value)
    {
        executeScript(f("arguments[0].value='%s'", value), webElement);
    }

    public String getValue()
    {
        return getValue(webElement);
    }
}