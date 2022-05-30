package co.nvqa.operator_v2.selenium.elements;

import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

public class ForceClearTextBox extends TextBox {

  public ForceClearTextBox(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public ForceClearTextBox(WebDriver webDriver, String xpath) {
    super(webDriver, xpath);
  }

  public ForceClearTextBox(WebDriver webDriver, SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  public void setValue(String value) {
    if (value != null) {
      forceClear();
      sendKeysWithoutClear(webElement, value);
    }
  }
}