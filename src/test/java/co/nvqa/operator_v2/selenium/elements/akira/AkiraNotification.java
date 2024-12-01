package co.nvqa.operator_v2.selenium.elements.akira;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * Controller for akira notification component
 *
 * @author Ekki Syam
 */
public class AkiraNotification extends PageElement {

  public AkiraNotification(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AkiraNotification(WebDriver webDriver, SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  @FindBy(xpath = "//div[contains(@class,'inline-block') and contains(@class,'break-words')]//div[@class='font-bold']")
  public PageElement message;

  @FindBy(xpath = "//div[contains(@class,'inline-block') and contains(@class,'break-words')]//div[2]")
  public PageElement description;

  @FindBy(xpath = "//div[contains(@class,'my-px')]//*[contains(@class,'cursor-pointer')]")
  public PageElement close;
}
