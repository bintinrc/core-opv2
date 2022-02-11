package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class AntFilterSwitch extends PageElement {

  public AntFilterSwitch(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public AntFilterSwitch(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  @FindBy(css = "button[role='switch']")
  public AntSwitch switchButton;

  @FindBy(css = "label > svg")
  public Button removeFilter;

  public void selectFilter(String value) {
    switchButton.setValue(value);
  }

  public void removeFilter() {
    removeFilter.click();
  }

  public boolean getSelectedValue() {
    return switchButton.isChecked();
  }
}