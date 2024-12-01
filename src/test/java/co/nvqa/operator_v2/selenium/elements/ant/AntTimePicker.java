package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * Controller for ant-time-picker component
 *
 * @author Sergey Mishanin
 */
public class AntTimePicker extends PageElement {

  public AntTimePicker(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntTimePicker(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  @FindBy(className = "ant-time-picker-input")
  public TextBox input;

  @FindBy(xpath = "//input[@class='ant-time-picker-panel-input']")
  public TextBox panelInput;

  public void setValue(String value) {
    input.click();
    panelInput.setValue(value);
    input.jsClick();
  }
}