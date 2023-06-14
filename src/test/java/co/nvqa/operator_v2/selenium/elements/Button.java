package co.nvqa.operator_v2.selenium.elements;

import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

public class Button extends PageElement {

  public Button(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public Button(WebDriver webDriver, String xpath) {
    super(webDriver, xpath);
  }

  public Button(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  public Button(WebDriver webDriver, SearchContext searchContext, String xpath) {
    super(webDriver, searchContext, xpath);
  }

  public void click() {
//    waitUntilClickable();
    super.click();
  }
}