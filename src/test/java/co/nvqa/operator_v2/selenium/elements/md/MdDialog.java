package co.nvqa.operator_v2.selenium.elements.md;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconButton;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class MdDialog extends PageElement
{
    public MdDialog(WebDriver webDriver, WebElement webElement)
    {
        super(webDriver, webElement);
    }

    public MdDialog(WebDriver webDriver, SearchContext searchContext, WebElement webElement)
    {
        super(webDriver, searchContext, webElement);
    }

    @FindBy(name = "Cancel")
    public NvIconButton close;

    @FindBy(xpath = ".//*[self::h2 or self::h4 or self::h5]")
    public PageElement title;

    public void close()
    {
        close.moveAndClick();
    }

    public boolean isDisplayed(){
        return title.isDisplayedFast();
    }

    public void waitUntilVisible(){
        title.waitUntilClickable();
    }
}