package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * Controller for ant-time-picker component
 *
 * @author Sergey Mishanin
 */
public class AntNotification extends PageElement {

  public AntNotification(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntNotification(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  @FindBy(css = ".ant-notification-notice-message")
  public PageElement message;

  @FindBy(css = ".ant-notification-notice-description")
  public PageElement description;

  @FindBy(css = "a.ant-notification-notice-close")
  public PageElement close;

}