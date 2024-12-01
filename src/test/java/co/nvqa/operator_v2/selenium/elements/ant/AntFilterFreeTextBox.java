package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.TextBox;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class AntFilterFreeTextBox extends AntAbstractFilterBox {

  public AntFilterFreeTextBox(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public AntFilterFreeTextBox(WebDriver webDriver, SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  @FindBy(css = "input")
  public TextBox search;

  public void setValue(String value) {
    search.setValue(value);
    search.sendKeys(Keys.ENTER);
  }

  @Override
  public void setValue(String... values) {
    setValue(values[1]);
  }
}