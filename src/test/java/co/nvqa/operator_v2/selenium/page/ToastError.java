package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class ToastError extends PageElement {

  @FindBy(css = "div.toast-top > div")
  public PageElement toastTop;
  @FindBy(css = "div.toast-bottom")
  public PageElement toastBottom;

  public ToastError(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }


}
