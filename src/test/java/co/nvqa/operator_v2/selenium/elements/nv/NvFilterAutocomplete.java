package co.nvqa.operator_v2.selenium.elements.nv;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class NvFilterAutocomplete extends PageElement
{
    public NvFilterAutocomplete(WebDriver webDriver, WebElement webElement)
    {
        super(webDriver, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(tagName = "nv-autocomplete")
    public NvAutocomplete searchOrSelect;

    @FindBy(name = "commons.clear-all")
    public PageElement clearAll;

    @FindBy(name = "commons.remove-filter")
    public NvIconButton removeFilter;

    public void clearAll(){
        clearAll.moveAndClick();
    }

    public void selectFilter(String value){
        searchOrSelect.selectValue(value);
    }

    public void removeFilter(){
        removeFilter.click();
    }

}