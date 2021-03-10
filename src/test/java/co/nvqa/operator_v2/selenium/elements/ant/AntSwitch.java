package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

public class AntSwitch extends PageElement {

  public AntSwitch(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntSwitch(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public boolean isChecked() {
    return Boolean.parseBoolean(getAttribute("aria-checked"));
  }

  public void check() {
    if (!isChecked()) {
      click();
    }
  }

  public void uncheck() {
    if (isChecked()) {
      click();
    }
  }

  public void setValue(boolean checked) {
    if (checked) {
      check();
    } else {
      uncheck();
    }
  }

  public void setValue(String checked) {
    setValue(Boolean.parseBoolean(checked));
  }
}