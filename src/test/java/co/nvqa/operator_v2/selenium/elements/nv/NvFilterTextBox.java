package co.nvqa.operator_v2.selenium.elements.nv;

import co.nvqa.operator_v2.selenium.elements.TextBox;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class NvFilterTextBox extends AbstractFilterBox
{
    public NvFilterTextBox(WebDriver webDriver, WebElement webElement)
    {
        super(webDriver, webElement);
    }

    @FindBy(css = "input[type='text']")
    public TextBox search;

    public void setValue(String value)
    {
        search.setValue(value);
    }

    @Override
    void setValue(String... values)
    {
        setValue(values[0]);
    }
}