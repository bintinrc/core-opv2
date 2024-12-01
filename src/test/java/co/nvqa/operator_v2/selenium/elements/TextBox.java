package co.nvqa.operator_v2.selenium.elements;

import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.InvalidElementStateException;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

public class TextBox extends PageElement {

  public TextBox(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public TextBox(WebDriver webDriver, String xpath) {
    super(webDriver, xpath);
  }

  public TextBox(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public void forceClear() {
    String currentValue = getValue();
    if (StringUtils.isNotEmpty(currentValue)) {
      StringBuilder sb = new StringBuilder();
      sb.append(Keys.END);
      for (int i = 0; i < currentValue.length(); i++) {
        sb.append(Keys.BACK_SPACE);
      }
      sendKeys(sb.toString());
    }
  }

  public void setValue(String value) {
    if (value != null) {
      try {
        forceClear();
        clearAndSendKeys(value);
      } catch (InvalidElementStateException ex) {
        click();
        forceClear();
        clearAndSendKeys(value);
      }
    }
  }

  public void setValue(Object value) {
    setValue(String.valueOf(value));
  }

  public void jsSetValue(String value) {
    executeScript(f("arguments[0].value='%s'", value), webElement);
  }

  public void jsSetValue(Object value) {
    jsSetValue(String.valueOf(value));
  }

  public String getValue() {
    return getValue(webElement);
  }

  public void type(String value) {
    if (value != null) {
      char[] chars = value.toCharArray();
      for (char c : chars) {
        getWebElement().sendKeys(String.valueOf(c));
        pause200ms();
      }
    }
  }
}