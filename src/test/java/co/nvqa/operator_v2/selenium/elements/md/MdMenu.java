package co.nvqa.operator_v2.selenium.elements.md;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.By;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class MdMenu extends PageElement {

  public MdMenu(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public MdMenu(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  @FindBy(css = "button[ng-click*='$mdOpenMenu($event)'] i")
  public Button selectionButton;

  private static final String MD_MENU_ITEM_LOCATOR = "div.md-open-menu-container md-menu-item button[aria-label='%s']";

  public void selectOption(String option) {
    openMenu();
    option = escapeValue(option);
    String selector = f(MD_MENU_ITEM_LOCATOR, option);
    new Button(getWebDriver(), getWebDriver().findElement(By.cssSelector(selector))).click();
    pause100ms();
  }

  private void openMenu() {
    selectionButton.click();
    pause100ms();
  }
}