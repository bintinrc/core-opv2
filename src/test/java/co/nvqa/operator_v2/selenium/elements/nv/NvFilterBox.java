package co.nvqa.operator_v2.selenium.elements.nv;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.util.List;
import java.util.stream.Collectors;
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

  @FindBy(name = "commons.remove-filter")
  public NvIconButton removeFilter;

  @FindBy(css = "nv-icon-text-button[ng-repeat]")
  public List<NvIconTextButton> selectedItems;

  @FindBy(css = "md-progress-circular")
  public PageElement spinner;

  public void clearAll() {
    if (clearAll.isDisplayedFast()) {
      clearAll.click();
    }
  }

  @Override
  public void setValue(String... values) {
    selectFilter(values[0]);
  }

  public void selectFilter(String value) {
    searchOrSelect.selectValue(value);
  }

  public void strictlySelectFilter(String value) {
    searchOrSelect.strictlySelectValue(value);
  }

  public void selectFilter(Iterable<String> values) {
    values.forEach(value -> {
      pause1s();
      this.selectFilter(value);
    });
  }

  public void strictlySelectFilter(Iterable<String> values) {
    values.forEach(this::strictlySelectFilter);
  }

  public List<String> getSelectedValues() {
    return selectedItems.stream()
        .map(element -> element.getAttribute("aria-label"))
        .collect(Collectors.toList());
  }

  public void waitUntilLoaded() {
    if (spinner.waitUntilVisible(1)) {
      spinner.waitUntilInvisible(30);
    }
  }
}