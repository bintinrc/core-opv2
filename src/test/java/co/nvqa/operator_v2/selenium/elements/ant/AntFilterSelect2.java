package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.util.List;
import java.util.stream.Collectors;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class AntFilterSelect2 extends PageElement {

  public AntFilterSelect2(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntFilterSelect2(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  @FindBy(css = ".ant-select")
  public AntSelect searchOrSelect;

  @FindBy(css = "[data-testid='filterMultipleSelect.clearAll']")
  public Button clearAll;
  @FindBy(xpath = ".//button[./i[contains(@class,'anticon-close')]]")
  public Button delete;

  @FindBy(css = "span[data-testid='filterMultipleSelect.tag']")
  public List<PageElement> selectedValues;

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

  public void deleteFilter() {
    delete.click();
  }

  public List<String> getSelectedValues() {
    return selectedValues.stream().map(PageElement::getNormalizedText).collect(Collectors.toList());
  }
}