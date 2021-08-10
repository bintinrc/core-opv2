package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import java.time.LocalDateTime;
import java.util.Date;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import static co.nvqa.commons.support.DateUtil.DATE_FORMATTER_SNS_1;

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

  @FindBy(xpath = "//*[contains(@class,'ant-calendar-date-panel')]//input[@placeholder='Start date']")
  public TextBox inputFrom;

  @FindBy(xpath = "//*[contains(@class,'ant-calendar-date-panel')]//input[@placeholder='End date']")
  public TextBox inputTo;

  public void setFrom(String from) {
    valueFrom.click();
    inputFrom.waitUntilVisible();
    inputFrom.sendKeys(StringUtils.repeat(Keys.BACK_SPACE.toString(), 10) + from + Keys.ENTER);
    inputFrom.waitUntilInvisible();
  }

  public void setFrom(Date from) {
    setFrom(DATE_FORMATTER_SNS_1.format(LocalDateTime.from(from.toInstant())));
  }

  public void setTo(String to) {
    valueFrom.click();
    inputTo.waitUntilVisible();
    inputTo.sendKeys(StringUtils.repeat(Keys.BACK_SPACE.toString(), 10) + to);
    inputFrom.sendKeys(Keys.ENTER);
    inputTo.waitUntilInvisible();
  }

  public void setTo(Date to) {
    setTo(DATE_FORMATTER_SNS_1.format(LocalDateTime.from(to.toInstant())));
  }

  public void setInterval(String from, String to) {
    valueFrom.click();
    inputFrom.waitUntilVisible();
    inputFrom.jsSetValue(from);
    inputTo.jsSetValue(to);
    valueFrom.jsClick();
    inputTo.waitUntilInvisible();
  }

  public void setInterval(Date from, Date to) {
    setInterval(DATE_FORMATTER_SNS_1.format(DateUtil.getDate(from.toInstant())),
        DATE_FORMATTER_SNS_1.format(DateUtil.getDate(to.toInstant())));
  }

  public String getValueFrom() {
    return valueFrom.getValue();
  }

  public String getValueTo() {
    return valueTo.getValue();
  }
}
