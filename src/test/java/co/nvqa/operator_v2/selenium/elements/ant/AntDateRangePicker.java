package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * @author Sergey Mishanin
 */
public class AntDateRangePicker extends PageElement {

  private static final String BY_TITLE_LOCATOR = "table.ant-picker-content td[title='%s']";

  public AntDateRangePicker(WebDriver webDriver, SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntDateRangePicker(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  @FindBy(xpath = "(.//div[contains(@class,'ant-picker-input')])[1]//input")
  public TextBox fromInput;

  @FindBy(xpath = "(.//div[contains(@class,'ant-picker-input')])[2]//input")
  public TextBox toInput;

  public void setDateRange(String from, String to) {
    fromInput.click();
    new Button(webDriver, webDriver.findElement(By.cssSelector(f(BY_TITLE_LOCATOR, from)))).click();
    pause500ms();
    new Button(webDriver, webDriver.findElement(By.cssSelector(f(BY_TITLE_LOCATOR, to)))).click();
  }

  public void setFromDate(String from) {
    fromInput.click();
    new Button(webDriver, webDriver.findElement(By.cssSelector(f(BY_TITLE_LOCATOR, from)))).click();
    new Actions(webDriver).sendKeys(Keys.ESCAPE);
  }

  public void setToDate(String to) {
    toInput.click();
    new Button(webDriver, webDriver.findElement(By.cssSelector(f(BY_TITLE_LOCATOR, to)))).click();
    new Actions(webDriver).sendKeys(Keys.ESCAPE);
  }
}
