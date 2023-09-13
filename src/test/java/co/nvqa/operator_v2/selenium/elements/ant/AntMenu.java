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

  private static final String MD_MENU_ITEM_LOCATOR = "//div[contains(@class, 'ant-dropdown') and not(contains(@class, 'ant-dropdown-hidden'))]//li[@role='menuitem'][.='%s']";
  private static final String MD_MENU_ITEM_CONTAINS_LOCATOR = "//div[contains(@class, 'ant-dropdown') and not(contains(@class, 'ant-dropdown-hidden'))]//li[@role='menuitem'][contains(.,'%s')]";


  public void selectOption(String option) {
    openMenu();
    getItemElement(option).click();
    pause1s();
  }

  public Button getItemElement(String option) {
    option = escapeValue(option);
    String selector = f(MD_MENU_ITEM_LOCATOR, option);
    if (isElementExist(selector, 1)) {
      return new Button(getWebDriver(), getWebDriver().findElement(By.xpath(selector)));
    } else {
      selector = f(MD_MENU_ITEM_CONTAINS_LOCATOR, option);
      return new Button(getWebDriver(), getWebDriver().findElement(By.xpath(selector)));
    }
  }

  private void openMenu() {
    click();
    pause100ms();
  }
}