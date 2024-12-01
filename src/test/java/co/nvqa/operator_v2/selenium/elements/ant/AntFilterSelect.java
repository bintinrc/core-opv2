package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.util.List;
import java.util.stream.Collectors;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class AntFilterSelect extends PageElement {

  public AntFilterSelect(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  @FindBy(css = ".ant-select")
  public AntSelect2 searchOrSelect;

  @FindBy(css = "[data-icon='layer-minus']")
  public Button clearAll;

  @FindBy(css = "div.close > button")
  public Button removeFilter;

  @FindBy(css = "div[class*='FilterTag'] > span")
  public List<PageElement> selectedItems;

  public void clearAll() {
    if (clearAll.isDisplayedFast()) {
      clearAll.click();
    }
  }

  public void selectFilter(String value) {
    searchOrSelect.selectValue(value);
  }

  public void selectFilter(Iterable<String> values) {
    values.forEach(this::selectFilter);
  }

  public void removeFilter() {
    removeFilter.click();
  }

  public List<String> getSelectedValues() {
    return selectedItems.stream()
        .map(PageElement::getNormalizedText)
        .collect(Collectors.toList());
  }

}