package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.Button;
import java.util.List;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;

public class AntFilterSelect3 extends AntAbstractFilterBox {

  public AntFilterSelect3(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public AntFilterSelect3(WebDriver webDriver, SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  @FindBy(css = ".ant-select")
  public AntSelect3 selector;

  @FindBy(xpath = ".//label[contains(.,'Show')]")
  public Button show;

  public void clearAll() {
    selector.clearValue();
  }

  public void selectFilter(String value) {
    selector.selectValue(value);
  }

  public void selectFilter(Iterable<String> values) {
    selector.selectValues(values);
  }

  public void closeMenu() {
    Actions actions = new Actions(getWebDriver());
    actions.click(selector.searchInput.getWebElement()).sendKeys(Keys.ESCAPE).perform();
  }

  public List<String> getSelectedValues() {
    if (show.isDisplayedFast()) {
      show.click();
    }
    return selector.getValues();
  }

  @Override
  public void setValue(String... values) {

  }
}