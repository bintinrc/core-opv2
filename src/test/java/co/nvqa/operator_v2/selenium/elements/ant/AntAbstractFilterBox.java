package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public abstract class AntAbstractFilterBox extends PageElement {

  public AntAbstractFilterBox(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntAbstractFilterBox(WebDriver webDriver, SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  @FindBy(css = "svg[data-pa-label='Remove Filter From Selection']")
  public Button removeFilter;

  public void removeFilter() {
    removeFilter.click();
  }

  public abstract void setValue(String... values);

}