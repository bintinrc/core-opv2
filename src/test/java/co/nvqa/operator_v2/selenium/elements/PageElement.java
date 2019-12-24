package co.nvqa.operator_v2.selenium.elements;

import co.nvqa.common_selenium.page.SimplePage;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

public class PageElement extends SimplePage
{
    protected WebElement webElement;

    public PageElement(WebDriver webDriver)
    {
        super(webDriver);
    }

    public PageElement(WebDriver webDriver, WebElement webElement)
    {
        this(webDriver);
        this.webElement = webElement;
    }

}
