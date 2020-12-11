package co.nvqa.operator_v2.selenium.elements.nv;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class NvFilterBox extends AbstractFilterBox
{
    public NvFilterBox(WebDriver webDriver, WebElement webElement)
    {
        super(webDriver, webElement);
    }

    @FindBy(tagName = "nv-autocomplete")
    public NvAutocomplete searchOrSelect;

    @FindBy(name = "commons.clear-all")
    public PageElement clearAll;

    public void clearAll()
    {
        if (clearAll.isDisplayedFast())
        {
            clearAll.moveAndClick();
        }
    }

    @Override
    void setValue(String... values)
    {
        selectFilter(values[0]);
    }

    public void selectFilter(String value)
    {
        searchOrSelect.selectValue(value);
    }

}