package co.nvqa.operator_v2.selenium.elements.nv;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.util.List;
import java.util.stream.Collectors;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class NvFilterAutocomplete extends AbstractFilterBox {

  public NvFilterAutocomplete(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public NvFilterAutocomplete(WebDriver webDriver, SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  @FindBy(tagName = "nv-autocomplete")
  public NvAutocomplete searchOrSelect;

  @FindBy(name = "commons.clear-all")
  public PageElement clearAll;

  @FindBy(css = "nv-icon-text-button[ng-repeat]")
  public List<NvIconTextButton> selectedItems;

  public void clearAll() {
    if (clearAll.isDisplayedFast()) {
      clearAll.moveAndClick();
    }
  }

  @Override
  public void setValue(String... values) {
    selectFilter(values[0]);
  }

  public void selectFilter(String value) {
    searchOrSelect.selectValue(value);
  }

  public void selectFilter(Iterable<String> values) {
    values.forEach(this::selectFilter);
  }

  public List<String> getSelectedValues() {
    return selectedItems.stream()
        .map(element -> element.getAttribute("aria-label"))
        .collect(Collectors.toList());
  }
}