package co.nvqa.operator_v2.selenium.elements.nv;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.By;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class NvFilterBooleanBox extends AbstractFilterBox {

  public NvFilterBooleanBox(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public NvFilterBooleanBox(WebDriver webDriver, SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  @FindBy(xpath = ".//button[@ng-click='::onClick(0)']")
  public PageElement yes;

  @FindBy(xpath = ".//button[@ng-click='::onClick(1)']")
  public PageElement no;

  @FindBy(css = "button.raised")
  public PageElement selectedValue;

  @Override
  public void setValue(String... values) {
    selectFilter(Boolean.parseBoolean(values[0]));
  }

  public void setFilter(String value) {
    findElement(By.xpath(f(".//button[.='%s']", value))).click();
  }

  public void selectFilter(boolean value) {
    if (value) {
      yes.moveAndClick();
    } else {
      no.moveAndClick();
    }
  }

  public String getValue() {
    return selectedValue.getText();
  }

}