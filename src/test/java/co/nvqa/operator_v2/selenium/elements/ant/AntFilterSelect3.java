package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.util.List;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class AntFilterSelect3 extends PageElement {

  public AntFilterSelect3(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  @FindBy(css = ".ant-select")
  public AntSelect3 selector;

  @FindBy(css = "label > svg")
  public Button removeFilter;

  public void clearAll() {
    selector.clearValue();
  }

  public void selectFilter(String value) {
    selector.selectValue(value);
  }

  public void selectFilter(Iterable<String> values) {
    selector.selectValues(values);
  }

  public void removeFilter() {
    removeFilter.click();
  }

  public List<String> getSelectedValues() {
    return selector.getValues();
  }

}