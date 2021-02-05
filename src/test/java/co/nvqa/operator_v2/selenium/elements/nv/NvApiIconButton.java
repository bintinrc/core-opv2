package co.nvqa.operator_v2.selenium.elements.nv;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class NvApiIconButton extends PageElement {

  public NvApiIconButton(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public NvApiIconButton(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public NvApiIconButton(WebDriver webDriver, SearchContext searchContext, String xpath) {
    super(webDriver, searchContext, xpath);
  }

  @FindBy(tagName = "button")
  private Button button;

  public void click() {
    button.scrollIntoView();
    button.click();
  }
}