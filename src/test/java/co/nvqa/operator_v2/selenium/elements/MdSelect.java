package co.nvqa.operator_v2.selenium.elements;

import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class MdSelect extends PageElement
{
    public MdSelect(WebDriver webDriver, WebElement webElement)
    {
        super(webDriver, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public MdSelect(WebDriver webDriver, SearchContext searchContext, WebElement webElement)
    {
        super(webDriver, searchContext, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = ".//md-select-value")
    public PageElement selectValueElement;

    @FindBy(xpath = "//div[contains(@class,'md-active md-clickable')]//input[@ng-model='searchTerm']")
    public PageElement searchInput;

    public void selectValue(String value)
    {
        enterSearchTerm(value);
        click(f("//md-option[div[contains(normalize-space(text()), '%s')]]", StringUtils.normalizeSpace(value)));
    }

    public void selectPreciseValue(String value)
    {
        enterSearchTerm(value);
        click(f("//md-option[div[text()=' JKB ']]", value));
    }

    private void openMenu(){
        selectValueElement.waitUntilClickable();
        selectValueElement.moveAndClick();
        pause1s();
    }

    private void enterSearchTerm(String value){
        openMenu();
        searchInput.clearAndSendKeys(value);
        pause1s();
    }

    public String getValue()
    {
        return getValue(selectValueElement.getWebElement());
    }
}