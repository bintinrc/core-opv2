package co.nvqa.operator_v2.selenium.elements.nv;

import co.nvqa.operator_v2.selenium.elements.TextBox;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class NvFilterFreeTextBox extends AbstractFilterBox {

  public NvFilterFreeTextBox(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  @FindBy(css = "input[ng-model='search']")
  public TextBox search;

  public void setValue(String value) {
    search.setValue(value);
    search.sendKeys(Keys.ENTER);
  }

  @Override
  void setValue(String... values) {
    setValue(values[1]);
  }
}