package co.nvqa.operator_v2.selenium.elements.nv;

import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class NvFilterBox extends AbstractFilterBox {

  public NvFilterBox(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public NvFilterBox(WebDriver webDriver, SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  @FindBy(tagName = "nv-autocomplete")
  public NvAutocomplete searchOrSelect;

  @FindBy(name = "commons.clear-all")
  public NvIconButton clearAll;

  public void clearAll() {
    if (clearAll.isDisplayedFast()) {
      clearAll.click();
    }
  }

  @Override
  void setValue(String... values) {
    selectFilter(values[0]);
  }

  public void selectFilter(String value) {
    searchOrSelect.selectValue(value);
  }

  public void selectFilter(Iterable<String> values) {
    values.forEach(this::selectFilter);
  }

}