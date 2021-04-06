package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
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

  @FindBy(css = "div > button > i.anticon-border")
  public Button clearAll;

  @FindBy(css = "div.close > button")
  public Button removeFilter;

  public void clearAll() {
    if (clearAll.isDisplayedFast()) {
      clearAll.click();
    }
  }

  public void selectFilter(String value) {
    searchOrSelect.selectValue(value);
  }

  public void removeFilter() {
    removeFilter.click();
  }

}