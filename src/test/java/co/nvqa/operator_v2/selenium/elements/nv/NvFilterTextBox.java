package co.nvqa.operator_v2.selenium.elements.nv;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class NvFilterTextBox extends PageElement
{
    public NvFilterTextBox(WebDriver webDriver, WebElement webElement)
    {
        super(webDriver, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(css = "input[type='text']")
    public TextBox search;

    @FindBy(name = "commons.remove-filter")
    public NvIconButton removeFilter;

    public void setValue(String value)
    {
        search.setValue(value);
    }

    public void removeFilter()
    {
        removeFilter.click();
    }
}