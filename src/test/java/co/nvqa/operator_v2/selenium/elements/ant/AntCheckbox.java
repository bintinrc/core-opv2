package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * Controller for ant-checkbox component
 *
 * @author Sergey Mishanin
 */
public class AntCheckbox extends PageElement {

  public AntCheckbox(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntCheckbox(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  @FindBy(className = "ant-checkbox-input")
  public CheckBox input;

  public boolean isChecked() {
    return input.isChecked();
  }

  public void check() {
    input.check();
  }

  public void uncheck() {
    input.uncheck();
  }

  public void setValue(boolean value) {
    input.setValue(value);
  }

  @Override
  public boolean isEnabled() {
    return input.isEnabled();
  }
}