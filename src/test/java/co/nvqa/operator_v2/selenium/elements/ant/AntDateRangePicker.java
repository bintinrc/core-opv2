package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.TextBox;
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
public class AntDateRangePicker extends AntAbstractFilterBox {

  private static final String BY_TITLE_LOCATOR = "div.ant-picker-dropdown:not(.ant-picker-dropdown-hidden) table.ant-picker-content td[title='%s']";
  private static final String HOURS_LOCATOR = "//div[contains(@class,'ant-picker-dropdown')][not(contains(@class,'ant-picker-dropdown-hidden'))]//ul[1]/li[.='%s']";
  private static final String MINUTES_LOCATOR = "//div[contains(@class,'ant-picker-dropdown')][not(contains(@class,'ant-picker-dropdown-hidden'))]//ul[2]/li[.='%s']";

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

  @FindBy(xpath = "//div[contains(@class,'ant-picker-dropdown')][not(contains(@class,'ant-picker-dropdown-hidden'))]//button[.='Ok']")
  public Button ok;

  public void setDateRange(String from, String to) {
    fromInput.click();
    new Button(webDriver, webDriver.findElement(By.cssSelector(f(BY_TITLE_LOCATOR, from)))).click();
    pause500ms();
    new Button(webDriver, webDriver.findElement(By.cssSelector(f(BY_TITLE_LOCATOR, to)))).click();
  }

  public void setFromDate(Date from) {
    setFromDate(DateUtil.fromDate(from).format(DateUtil.DATE_FORMATTER));
  }

  public void setFromDate(String from) {
    fromInput.click();
    int count = 0;
    while (webDriver.findElements(By.cssSelector(f(BY_TITLE_LOCATOR, from))).size() == 0
        && count < 12) {
      findElementByXpath("//button[@class='ant-picker-header-next-btn']").click();
      count++;
    }
    new Button(webDriver, webDriver.findElement(By.cssSelector(f(BY_TITLE_LOCATOR, from)))).click();
    new Actions(webDriver).sendKeys(Keys.ESCAPE);
  }

  public void setToDate(Date to) {
    setToDate(DateUtil.fromDate(to).format(DateUtil.DATE_FORMATTER));
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

  public void selectFromHours(String value) {
    fromInput.click();
    Button button = new Button(webDriver, webDriver.findElement(By.xpath(f(HOURS_LOCATOR, value))));
    button.scrollIntoView();
    button.jsClick();
    ok.click();
  }

  public void selectFromHours(long value) {
    selectFromHours(String.format("%02d", value));
  }

  public void selectFromMinutes(String value) {
    fromInput.click();
    Button button = new Button(webDriver,
        webDriver.findElement(By.xpath(f(MINUTES_LOCATOR, value))));
    button.scrollIntoView();
    button.jsClick();
    ok.click();
  }

  public void selectToHours(String value) {
    toInput.click();
    Button button = new Button(webDriver, webDriver.findElement(By.xpath(f(HOURS_LOCATOR, value))));
    button.scrollIntoView();
    button.jsClick();
    ok.click();
  }

  public void selectToHours(long value) {
    selectToHours(String.format("%02d", value));
  }

  public void selectToMinutes(String value) {
    toInput.click();
    Button button = new Button(webDriver,
        webDriver.findElement(By.xpath(f(MINUTES_LOCATOR, value))));
    button.scrollIntoView();
    button.jsClick();
    ok.click();
  }

  @Override
  public void setValue(String... values) {

  }
}
