package co.nvqa.operator_v2.selenium.elements.md;

import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import java.util.Arrays;
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

    @FindBy(css = "md-select-value div")
    public PageElement currentValueElement;

    @FindBy(xpath = "//div[contains(@class,'md-active md-clickable')]//input[@ng-model='searchTerm']")
    public PageElement searchInput;

    @FindBy(xpath = ".//md-option[@selected='selected']")
    public PageElement selectedOption;

    @FindBy(xpath = "//div[contains(@class,'md-select-menu-container')][@aria-hidden='false']//md-option")
    public PageElement option;

    @FindBy(xpath = "//div[contains(@class,'md-select-menu-container')][@aria-hidden='false']//md-option")
    public List<PageElement> options;

    private String menuId;

    private static final String MD_OPTION_LOCATOR = "//div[@id='%s']//md-option[.//div[contains(normalize-space(.), '%s')]]";
    private static final String MD_OPTION_BY_VALUE_LOCATOR = "//div[@id='%s']//md-option[@value='%s']";

    public void searchAndSelectValue(String value)
    {
        enterSearchTerm(value);
        value = escapeValue(value);
        try
        {
            click(f(MD_OPTION_LOCATOR, getMenuId(), StringUtils.normalizeSpace(value)));
        } catch (NoSuchElementException ex)
        {
            throw new NvTestRuntimeException(f("Could not select option [%s] in md-select", value), ex);
        }
    }

    public void searchAndSelectValues(Iterable<String> values)
    {
        openMenu();
        values.forEach(value ->
                {
                    searchInput.sendKeys(value);
                    pause500ms();
                    value = escapeValue(value);
                    click(f(MD_OPTION_LOCATOR, getMenuId(), StringUtils.normalizeSpace(value)));
                }
        );
        closeMenu();
    }

    public void searchAndSelectValues(String[] values)
    {
        searchAndSelectValues(Arrays.asList(values));
    }

    public void selectValue(String value)
    {
        openMenu();
        value = escapeValue(value);
        click(f(MD_OPTION_LOCATOR, getMenuId(), StringUtils.normalizeSpace(value)));
    }

    public void selectByValue(String value)
    {
        openMenu();
        value = escapeValue(value);
        click(f(MD_OPTION_BY_VALUE_LOCATOR, getMenuId(), StringUtils.normalizeSpace(value)));
    }

    private void openMenu()
    {
        selectValueElement.waitUntilClickable();
        selectValueElement.scrollIntoView();
        selectValueElement.jsClick();
        pause500ms();
    }

    private String getMenuId()
    {
        if (StringUtils.isBlank(menuId))
        {
            menuId = getAttribute("aria-owns");
        }
        return menuId;
    }

    private void closeMenu()
    {
        option.sendKeys(Keys.ESCAPE);
    }

    private void enterSearchTerm(String value)
    {
        openMenu();
        searchInput.sendKeys(value);
        pause500ms();
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
        return currentValueElement.getText();
    }

    public String getSelectedValueAttribute()
    {
        return selectedOption.getAttribute("value");
    }
}