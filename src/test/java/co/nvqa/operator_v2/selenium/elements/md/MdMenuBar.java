package co.nvqa.operator_v2.selenium.elements.md;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.By;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

public class MdMenuBar extends PageElement {

  public MdMenuBar(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public MdMenuBar(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  private static final String MD_MENU_ITEM_LOCATOR = "//div[contains(@class,'md-active')]//md-menu-item//*[normalize-space(.)='%s']";
  private static final String MD_MENU_LOCATOR = ".//md-menu/button[normalize-space(.)='%s']";

  private void selectOptionInPopup(String option) {
    option = escapeValue(option);
    String selector = f(MD_MENU_ITEM_LOCATOR, option);
    new Button(getWebDriver(), getWebDriver().findElement(By.xpath(selector))).click();
    pause100ms();
  }

  public void selectOption(String menu, String option) {
    openMenu(menu);
    selectOptionInPopup(option);
  }

  public boolean isOptionEnabled(String menu, String option) {
    openMenu(menu);
    option = escapeValue(option);
    String selector = f(MD_MENU_ITEM_LOCATOR, option);
    return new Button(getWebDriver(), getWebDriver().findElement(By.xpath(selector)))
        .isEnabled();
  }

  private void openMenu(String menu) {
    String selector = f(MD_MENU_LOCATOR, menu);
    new Button(getWebDriver(), getWebDriver().findElement(By.xpath(selector))).click();
    pause100ms();
  }
}