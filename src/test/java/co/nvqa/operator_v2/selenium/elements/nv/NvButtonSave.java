package co.nvqa.operator_v2.selenium.elements.nv;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class NvButtonSave extends PageElement {

  public NvButtonSave(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public NvButtonSave(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  @FindBy(tagName = "button")
  private Button button;

  @FindBy(xpath = ".//div[contains(@class,'saving')]/md-progress-circular")
  private PageElement spinner;

  public void click() {
    button.click();
  }

  public void clickAndWaitUntilDone() {
    click();
    pause100ms();
    spinner.waitUntilInvisible();
  }

  public void clickAndWaitUntilDone(int timeoutInSeconds) {
    click();
    pause100ms();
    spinner.waitUntilInvisible(timeoutInSeconds);
  }

  @Override
  public boolean isEnabled() {
    return button.isEnabled();
  }
}