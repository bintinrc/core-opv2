package co.nvqa.operator_v2.selenium.elements;

import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

/**
 * Controller for a simple HTML checkbox input
 *
 * @author Sergey Mishanin
 */
public class CheckBox extends PageElement {

  public CheckBox(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public CheckBox(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  public CheckBox(WebDriver webDriver, String xpath) {
    super(webDriver, xpath);
  }

  public boolean isChecked() {
    return getWebElement().isSelected();
  }

  public void check() {
    if (!isChecked()) {
      click();
    }
  }

  public void uncheck() {
    if (isChecked()) {
      click();
    }
  }

  public void setValue(boolean value) {
    if (value != isChecked()) {
      click();
    }
  }
}