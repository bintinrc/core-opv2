package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.util.CoreDateUtil;
import java.util.Date;
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
public class AntDateRangePicker2 extends AntAbstractFilterBox {

  private static final String BY_TITLE_LOCATOR = "div.ant-picker-dropdown:not(.ant-picker-dropdown-hidden) table.ant-picker-content td[title='%s']";

  public AntDateRangePicker2(WebDriver webDriver, SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntDateRangePicker2(WebDriver webDriver, WebElement webElement) {
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

  public void setFromDate(Date from) {
    setFromDate(CoreDateUtil.fromDate(from).format(CoreDateUtil.DATE_FORMATTER));
  }

  public void setFromDate(String from) {
    fromInput.click();
    new Button(webDriver, webDriver.findElement(By.cssSelector(f(BY_TITLE_LOCATOR, from)))).click();
    new Actions(webDriver).sendKeys(Keys.ESCAPE);
  }

  public void setToDate(Date to) {
    setToDate(CoreDateUtil.fromDate(to).format(CoreDateUtil.DATE_FORMATTER));
  }

  public void setToDate(String to) {
    toInput.click();
    new Button(webDriver, webDriver.findElement(By.cssSelector(f(BY_TITLE_LOCATOR, to)))).click();
    new Actions(webDriver).sendKeys(Keys.ESCAPE);
  }

  public void clearAndSetFromDate(String from) {
    fromInput.click();
    fromInput.forceClear();
    fromInput.sendKeys(from);
    fromInput.sendKeys(Keys.ENTER);
  }

  public void clearAndSetToDate(String to) {
    toInput.click();
    toInput.forceClear();
    toInput.sendKeys(to);
    toInput.sendKeys(Keys.ENTER);
  }

  @Override
  public void setValue(String... values) {

  }
}
