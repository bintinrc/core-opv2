package co.nvqa.operator_v2.selenium.elements.md;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import java.util.List;
import java.util.stream.Collectors;

public class MdSelect extends PageElement
{
    public MdSelect(WebDriver webDriver, WebElement webElement)
    {
        super(webDriver, webElement);
    }

    public MdSelect(WebDriver webDriver, SearchContext searchContext, WebElement webElement)
    {
        super(webDriver, searchContext, webElement);
    }

    @FindBy(css = "md-select-value")
    public PageElement selectValueElement;

    @FindBy(xpath = "//div[contains(@class,'md-active md-clickable')]//input[@ng-model='searchTerm']")
    public PageElement searchInput;

    @FindBy(xpath = "//div[contains(@class,'md-select-menu-container')][@aria-hidden='false']//md-option")
    public List<PageElement> options;

    private static final String MD_OPTION_LOCATOR = "//div[contains(@class,'md-select-menu-container')][@aria-hidden='false']//md-option[./div[contains(normalize-space(text()), '%s')]]";

    public void searchAndSelectValue(String value)
    {
        enterSearchTerm(value);
        value = escapeValue(value);
        click(f(MD_OPTION_LOCATOR, StringUtils.normalizeSpace(value)));
    }

    public void selectValue(String value)
    {
        openMenu();
        value = escapeValue(value);
        click(f(MD_OPTION_LOCATOR, StringUtils.normalizeSpace(value)));
    }

    private void openMenu()
    {
        selectValueElement.waitUntilClickable();
        selectValueElement.scrollIntoView();
        selectValueElement.jsClick();
        pause1s();
    }

    private void enterSearchTerm(String value)
    {
        openMenu();
        searchInput.sendKeys(value);
        pause1s();
    }

    public List<String> getOptions()
    {
        openMenu();
        List<String> opt = options.stream().map(PageElement::getText).collect(Collectors.toList());
        options.get(0).sendKeys(Keys.ESCAPE);
        return opt;
    }

    public String getValue()
    {
        return getValue(selectValueElement.getWebElement());
    }
}