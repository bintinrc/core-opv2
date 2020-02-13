package co.nvqa.operator_v2.selenium.elements.md;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
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

    private static final String MD_OPTION_LOCATOR = "//div[contains(@class,'md-select-menu-container')][@aria-hidden='false']//md-option[div[contains(normalize-space(text()), '%s')]]";

    public void searchAndSelectValue(String value)
    {
        enterSearchTerm(value);
        click(f(MD_OPTION_LOCATOR, StringUtils.normalizeSpace(value)));
    }

    public void selectValue(String value)
    {
        openMenu();
        click(f(MD_OPTION_LOCATOR, StringUtils.normalizeSpace(value)));
    }

    private void openMenu()
    {
        selectValueElement.waitUntilClickable();
        selectValueElement.scrollIntoView();
        selectValueElement.moveAndClick();
        pause1s();
    }

    private void enterSearchTerm(String value)
    {
        openMenu();
        searchInput.sendKeys(value);
        pause1s();
    }

    public String getValue()
    {
        return getValue(selectValueElement.getWebElement());
    }
}