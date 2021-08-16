package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.By;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

public class AntMenu extends PageElement {

  public AntMenu(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public AntMenu(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  private static final String MD_MENU_ITEM_LOCATOR = "//li[@role='menuitem'][.='%s']";

  public void selectOption(String option) {
    openMenu();
    option = escapeValue(option);
    String selector = f(MD_MENU_ITEM_LOCATOR, option);
    new Button(getWebDriver(), getWebDriver().findElement(By.xpath(selector))).click();
    pause100ms();
  }

  private void openMenu() {
    click();
    pause100ms();
  }
}