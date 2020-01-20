package co.nvqa.operator_v2.selenium.elements;

import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class MdAutocomplete extends PageElement
{
    public MdAutocomplete(WebDriver webDriver, WebElement webElement)
    {
        super(webDriver, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public MdAutocomplete(WebDriver webDriver, SearchContext searchContext, WebElement webElement)
    {
        super(webDriver, searchContext, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = ".//input")
    public PageElement inputElement;

    public void selectValue(String value)
    {
        enterSearchTerm(value);
        selectItem(value);
    }

    public void enterSearchTerm(String value)
    {
        inputElement.waitUntilClickable();
        inputElement.moveAndClick();
        inputElement.clearAndSendKeys(value);
    }

    public void selectItem(String value)
    {
        click(f("//ul[contains(@class,'md-autocomplete-suggestions')]/li[contains(normalize-space(.),'%s')]", StringUtils.normalizeSpace(value)));
    }
}