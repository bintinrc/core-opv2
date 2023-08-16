package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.util.Locale;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

public class AntMenuBar extends PageElement {

  public AntMenuBar(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public AntMenuBar(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  private static final String MD_MENU_ITEM_LOCATOR = "//div[contains(@class,'ant-dropdown')][not(contains(@class,'ant-dropdown-hidden'))]//li[normalize-space(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'))='%s']";
  private static final String MD_MENU_LOCATOR = ".//div[contains(@class,'ant-dropdown-trigger')][normalize-space(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'))='%s']";

  private void selectOptionInPopup(String option) {
    option = escapeValue(option);
    String selector = f(MD_MENU_ITEM_LOCATOR,
        StringUtils.normalizeSpace(option.toLowerCase(Locale.ROOT)));
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
    String selector = f(MD_MENU_ITEM_LOCATOR,
        StringUtils.normalizeSpace(option.toLowerCase(Locale.ROOT)));
    return !StringUtils.equalsIgnoreCase("true",
        new Button(getWebDriver(), getWebDriver().findElement(By.xpath(selector))).getAttribute(
            "aria-disabled"));
  }

  private void openMenu(String menu) {
    String selector = f(MD_MENU_LOCATOR, StringUtils.normalizeSpace(menu.toLowerCase(Locale.ROOT)));
    new Button(getWebDriver(), getWebDriver().findElement(By.xpath(selector))).click();
    pause200ms();
  }
}