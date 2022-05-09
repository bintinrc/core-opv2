package co.nvqa.operator_v2.selenium.elements.mm;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class AntConfirmModal extends PageElement {

  @FindBy(className = "ant-modal-confirm-title")
  public PageElement title;
  @FindBy(className = "ant-modal-confirm-content")
  public PageElement content;
  @FindBy(className = "ant-btn-primary")
  public Button confirmButton;
  @FindBy(css = ".ant-modal-confirm-btns .ant-btn:not(.ant-btn-primary)")
  public Button cancelButton;

  public AntConfirmModal(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntConfirmModal(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public boolean isDisplayed() {
    return title.isDisplayedFast();
  }

  public void waitUntilVisible() {
    title.waitUntilClickable();
  }

  public void confirm() {
    confirmButton.click();
  }

  public void cancel() {
    cancelButton.click();
  }
}