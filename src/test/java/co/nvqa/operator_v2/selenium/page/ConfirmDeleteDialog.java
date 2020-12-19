package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class ConfirmDeleteDialog extends PageElement {

  public ConfirmDeleteDialog(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  @FindBy(css = "button[aria-label='Delete']")
  public Button delete;

  public void confirmDelete() {
    waitUntilClickable();
    pause1s();
    delete.click();
    waitUntilInvisible();
  }
}
