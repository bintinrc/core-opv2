package co.nvqa.operator_v2.selenium.elements.md;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import java.util.Date;

public class MdDatepicker extends PageElement
{
    public MdDatepicker(WebDriver webDriver, WebElement webElement)
    {
        super(webDriver, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public MdDatepicker(WebDriver webDriver, SearchContext searchContext, WebElement webElement)
    {
        super(webDriver, searchContext, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(className = "md-datepicker-input")
    public PageElement input;

    @FindBy(xpath = "./parent::*")
    public PageElement parent;

    public void setDate(Date date)
    {
        setValue(MD_DATEPICKER_SDF.format(date));
    }

    public void setValue(String value)
    {
        input.clearAndSendKeys(value);
        parent.jsClick();
    }
}