package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * Created on 30/10/20.
 *
 * @author refoilmiya
 */
public class AntCalendarPicker extends PageElement {
    public AntCalendarPicker(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
        super(webDriver, searchContext, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public AntCalendarPicker(WebDriver webDriver, WebElement webElement) {
        super(webDriver, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = ".//input[@class='ant-calendar-picker-input ant-input']")
    public TextBox pickerInput;

    @FindBy(xpath = ".//i[contains(@class,'ant-calendar-picker-clear')]")
    public PageElement clear;

    @FindBy(xpath = "//input[@class='ant-calendar-input ']")
    public TextBox input;

    public void sendDate(String value) {
        input.waitUntilVisible();
        input.sendKeys(value);
        input.sendKeys(Keys.ENTER);
        input.waitUntilInvisible();
    }
}
