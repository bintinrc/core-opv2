package co.nvqa.operator_v2.selenium.elements.mm;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class AntNotice extends PageElement {

  @FindBy(xpath = ".//span[2]")
  private PageElement textSpan;

  public AntNotice(WebDriver webDriver, WebElement webElement) {
    super(webDriver);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntNotice(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public String getNoticeMessage() {
    return textSpan.getText();
  }
}
