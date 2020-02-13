package co.nvqa.operator_v2.selenium.elements.nv;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class NvFilterBooleanBox extends PageElement
{
    public NvFilterBooleanBox(WebDriver webDriver, WebElement webElement)
    {
        super(webDriver, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = ".//button[@ng-click='::onClick(0)']")
    public PageElement yes;

    @FindBy(xpath = ".//button[@ng-click='::onClick(1)']")
    public PageElement no;

    public void selectFilter(boolean value)
    {
        if (value) {
            yes.moveAndClick();
        } else {
            no.moveAndClick();
        }
    }

}