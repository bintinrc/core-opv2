package co.nvqa.operator_v2.selenium.elements.md;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.By;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

public class TabWrapper extends PageElement {

  public TabWrapper(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public TabWrapper(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  private static final String TAB_LOCATOR = ".//tab-item[normalize-space(text())=normalize-space('%s')]";
  private static final String ACTIVE_TAB_LOCATOR = ".//tab-item[contains(@class,'active')]";

  public void selectTab(String value) {
    WebElement tabElement = findElementBy(By.xpath(f(TAB_LOCATOR, value)), webElement);
    tabElement.click();

  }

  public String getValue() {
    return findElementBy(By.xpath(ACTIVE_TAB_LOCATOR), webElement).getText();
  }
}