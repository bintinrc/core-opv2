package co.nvqa.operator_v2.selenium.elements.nv;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.util.List;
import java.util.stream.Collectors;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class NvFilterAutocomplete extends AbstractFilterBox {

  public NvFilterAutocomplete(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  @FindBy(tagName = "nv-autocomplete")
  public NvAutocomplete searchOrSelect;

  @FindBy(name = "commons.clear-all")
  public PageElement clearAll;

  public void clearAll() {
    if (clearAll.isDisplayedFast()) {
      clearAll.moveAndClick();
    }
  }

  @Override
  void setValue(String... values) {
    selectFilter(values[0]);
  }

  public void selectFilter(String value) {
    searchOrSelect.selectValue(value);
  }

  public List<String> getSelectedValues() {
    return getWebElement()
        .findElements(By.cssSelector("div[ng-if*='state.showSelected']  nv-icon-text-button"))
        .stream()
        .map(item -> item.getAttribute("name"))
        .collect(Collectors.toList());
  }
}