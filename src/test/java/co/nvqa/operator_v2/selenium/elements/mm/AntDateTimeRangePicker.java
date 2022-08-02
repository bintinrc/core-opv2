package co.nvqa.operator_v2.selenium.elements.mm;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class AntDateTimeRangePicker extends PageElement {

  private static final String BY_TITLE_LOCATOR = "table.ant-picker-content td[title='%s']";
  private static final String HOUR_LOCATOR = "//ul[@class='ant-picker-time-panel-column'][1]//div[.='%s']";
  private static final String MINUTE_LOCATOR = "//ul[@class='ant-picker-time-panel-column'][2]//div[.='%s']";
  private static final String DATE_FORMAT = "yyyy-MM-dd";
  private static final String HOUR_FORMAT = "HH";
  private static final String MINUTE_FORMAT = "mm";
  private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern(DATE_FORMAT);
  private static final DateTimeFormatter HOUR_FORMATTER = DateTimeFormatter.ofPattern(HOUR_FORMAT);
  private static final DateTimeFormatter MINUTE_FORMATTER = DateTimeFormatter.ofPattern(
      MINUTE_FORMAT);
  @FindBy(xpath = "(.//div[contains(@class,'ant-picker-input')])[1]//input")
  public TextBox fromInput;
  @FindBy(xpath = "(.//div[contains(@class,'ant-picker-input')])[2]//input")
  public TextBox toInput;
  @FindBy(xpath = "//li[@class='ant-picker-ok']/button")
  public Button okButton;
  @FindBy(xpath = "(.//div[contains(@class,'ant-picker-input')])[1]//input/following-sibling::span")
  public PageElement fromDateClearIcon;
  @FindBy(xpath = "(.//div[contains(@class,'ant-picker-input')])[2]//input/following-sibling::span")
  public PageElement toDateClearIcon;
  @FindBy(css = ".ant-picker-clear")
  public PageElement clearIcon;

  public AntDateTimeRangePicker(WebDriver webDriver, SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntDateTimeRangePicker(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public void setDateRange(String from, String to) {
    fromInput.click();
    new Button(webDriver, webDriver.findElement(By.cssSelector(f(BY_TITLE_LOCATOR, from)))).click();
    pause500ms();
    new Button(webDriver, webDriver.findElement(By.cssSelector(f(BY_TITLE_LOCATOR, to)))).click();
  }

  public void setDateRange(ZonedDateTime from, ZonedDateTime to) {
    fromInput.click();
    new Button(webDriver, webDriver.findElement(
        By.cssSelector(f(BY_TITLE_LOCATOR, DATE_FORMATTER.format(from))))).click();
    new Button(webDriver,
        webElement.findElement(By.xpath(f(HOUR_LOCATOR, HOUR_FORMATTER.format(from))))).click();
    new Button(webDriver,
        webElement.findElement(By.xpath(f(MINUTE_LOCATOR, MINUTE_FORMATTER.format(from))))).click();
    okButton.click();
    pause500ms();

    new Button(webDriver, webDriver.findElement(
        By.cssSelector(f(BY_TITLE_LOCATOR, DATE_FORMATTER.format(to))))).click();
    new Button(webDriver,
        webElement.findElement(By.xpath(f(HOUR_LOCATOR, HOUR_FORMATTER.format(to))))).click();
    new Button(webDriver,
        webElement.findElement(By.xpath(f(MINUTE_LOCATOR, MINUTE_FORMATTER.format(to))))).click();
    okButton.click();
  }

  public void setFromDate(String from) {
    fromInput.click();
    new Button(webDriver, webDriver.findElement(By.cssSelector(f(BY_TITLE_LOCATOR, from)))).click();
    new Actions(webDriver).sendKeys(Keys.ESCAPE);
  }

  public void clear() {
    clearIcon.click();
  }

  public void clearFromDate() {
    fromDateClearIcon.moveAndClick();
  }

  public void clearToDate() {
    toDateClearIcon.moveAndClick();
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
}
