package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class AntFilterSwitch extends PageElement {

  public AntFilterSwitch(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntFilterSwitch(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  @FindBy(css = "button[role='switch']")
  public AntSwitch switchButton;

  @FindBy(xpath = ".//button[./i[contains(@class,'anticon-close')]]")
  public Button delete;

  public void selectFilter(String value) {
    switchButton.setValue(value);
  }

  public void deleteFilter() {
    delete.click();
  }

  public boolean getSelectedValue() {
    return switchButton.isChecked();
  }
}