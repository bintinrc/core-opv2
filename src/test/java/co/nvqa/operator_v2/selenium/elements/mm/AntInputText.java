package co.nvqa.operator_v2.selenium.elements.mm;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class AntInputText extends TextBox {

  public AntInputText(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }
  public AntInputText(WebDriver webDriver, String xpath) {
    super(webDriver, xpath);
  }

  @FindBy(css = ".ant-input-clear-icon")
  private PageElement clearIcon;

  @FindBy(css = ".ant-input,.ant-input-number-input")
  private TextBox input;
  
  @FindBy(className = "ant-form-item-explain-error")
  private PageElement errorText;

  @Override
  public void clear() {
    if (StringUtils.isNotEmpty(getValue())) {
      click();
      if (clearIcon.isDisplayedFast()) {
        clearIcon.click();
      } else {
        input.forceClear();
      }
    }
  }

  public void forceClear() {
    click();
    input.forceClear();
  }

  public void setValue(String value) {
    clear();
    input.setValue(value);
  }

  public String getErrorText() {
    return errorText.getText();
  }

  public Boolean isError() {
    return errorText.isDisplayed();
  }

  public void setValue(Object value) {
    setValue(String.valueOf(value));
  }

  public void jsSetValue(String value) {
    input.jsSetValue(value);
  }

  public void jsSetValue(Object value) {
    jsSetValue(String.valueOf(value));
  }

  public String getValue() {
    return input.getValue();
  }
}
