package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class AntTextBox extends TextBox {

  public AntTextBox(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public AntTextBox(WebDriver webDriver, String xpath) {
    super(webDriver, xpath);
  }

  public AntTextBox(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  @FindBy(css = ".ant-input-clear-icon")
  private PageElement clearIcon;

  @FindBy(css = "input")
  private TextBox input;

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