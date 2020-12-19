package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * Created on 30/10/20.
 *
 * @author Sergey Mishanin
 */
public class AntIntervalCalendarPicker extends PageElement {

  public AntIntervalCalendarPicker(WebDriver webDriver, SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntIntervalCalendarPicker(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  @FindBy(xpath = ".//input[@placeholder='Start date']")
  public TextBox valueFrom;

  @FindBy(xpath = ".//input[@placeholder='End date']")
  public TextBox valueTo;

  @FindBy(xpath = ".//i[contains(@class,'ant-calendar-picker-clear')]")
  public PageElement clear;

  @FindBy(xpath = "//*[contains(@class,'ant-calendar-range-left')]//input[contains(@class, 'ant-calendar-input')]")
  public TextBox inputFrom;

  @FindBy(xpath = "//*[contains(@class,'ant-calendar-range-right')]//input[contains(@class, 'ant-calendar-input')]")
  public TextBox inputTo;

  public void setFrom(String from) {
    valueFrom.click();
    inputFrom.waitUntilVisible();
    inputFrom.sendKeys(from + Keys.ENTER);
    inputFrom.waitUntilInvisible();
  }

  public void setTo(String to) {
    valueFrom.click();
    inputTo.waitUntilVisible();
    inputTo.sendKeys(to + Keys.ENTER);
    inputTo.waitUntilInvisible();
  }

  public void setInterval(String from, String to) {
    valueFrom.click();
    inputFrom.waitUntilVisible();
    inputFrom.jsSetValue(from);
    inputTo.jsSetValue(to);
    inputTo.sendKeys(Keys.ENTER);
    inputTo.waitUntilInvisible();
  }

  public String getValueFrom() {
    return valueFrom.getValue();
  }

  public String getValueTo() {
    return valueTo.getValue();
  }
}
