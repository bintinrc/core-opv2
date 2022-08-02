package co.nvqa.operator_v2.selenium.elements.md;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconButton;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class MdDialog extends PageElement {

  public MdDialog(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public MdDialog(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  @FindBy(name = "Cancel")
  public NvIconButton close;

  @FindBy(xpath = ".//*[self::h1 or self::h2 or self::h4 or self::h5 or @class='ant-modal-confirm-title']")
  public PageElement title;

  public void close() {
    close.waitUntilClickable();
    close.moveAndClick();
  }

  public void forceClose() {
    try {
      executeScript("angular.element(arguments[0]).controller().function.cancel()",
          getWebElement());
    } catch (Exception ex1) {
      try {
        executeScript("angular.element(arguments[0]).controller().onCancel()", getWebElement());
      } catch (Exception ex2) {
        executeScript("angular.element(arguments[0]).controller().function.onCancel()",
            getWebElement());
      }
    }
  }

  public boolean isDisplayed() {
    return title.isDisplayedFast();
  }

  public void waitUntilVisible() {
    title.waitUntilClickable();
  }

  public boolean waitUntilVisible(int timeout) {
    try {
      title.waitUntilClickable(timeout);
      return true;
    } catch (Exception ex) {
      return false;
    }
  }
}