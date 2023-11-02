package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class AntModal extends PageElement {

  public AntModal(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntModal(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  @FindBy(css = ".ant-spin-dot")
  public PageElement spinner;

  @FindBy(className = "ant-modal-close")
  public PageElement close;

  @FindBy(css = ".ant-modal-title,.ant-modal-confirm-title")
  public PageElement title;

  public void close() {
    close.click();
  }

  public boolean isDisplayed() {
    return title.isDisplayedFast();
  }

  public void waitUntilVisible() {
    title.waitUntilClickable();
  }

  public void waitUntilLoaded() {
    waitUntilVisible();
    if (spinner.waitUntilVisible(2)) {
      spinner.waitUntilInvisible();
    }
  }

  public void closeDialogIfVisible(){
    if (isDisplayed()){
      close.click();
    }
  }

}