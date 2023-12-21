package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.common.model.DataEntity;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.apache.commons.lang3.StringUtils;
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
public class AntCalendarRange extends PageElement {

  private static final SimpleDateFormat DATE_CELL_FORMAT = new SimpleDateFormat("MMMMM d, yyyy");
  private static final String DATE_CELL_LOCATOR = "//td[@role='gridcell'][@title='%s']";

  public AntCalendarRange(WebDriver webDriver, SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntCalendarRange(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  @FindBy(xpath = ".//input[@placeholder='Start date']")
  public TextBox valueFrom;

  @FindBy(xpath = ".//input[@placeholder='End date']")
  public TextBox valueTo;

  @FindBy(xpath = ".//i[contains(@class,'ant-calendar-picker-clear')]")
  public PageElement clear;

  @FindBy(xpath = "//*[contains(@class,'ant-calendar ant-calendar-range')]//input[@placeholder='Start date']")
  public TextBox inputFrom;

  @FindBy(xpath = "//*[contains(@class,'ant-calendar ant-calendar-range')]//input[@placeholder='End date']")
  public TextBox inputTo;

  public void setFrom(String from) {
    if (!StringUtils.equals(from, getValueFrom())) {
      if (!inputFrom.isDisplayedFast()) {
        valueFrom.click();
        inputFrom.waitUntilVisible();
      }
      inputFrom.sendKeys(StringUtils.repeat(Keys.BACK_SPACE.toString(), 10) + from + Keys.ENTER);
      inputFrom.waitUntilInvisible();
    }
  }


  public void setTo(String to) {
    if (!StringUtils.equals(to, getValueTo())) {
      if (!inputTo.isDisplayedFast()) {
        valueFrom.click();
        inputTo.waitUntilVisible();
      }
      inputTo.sendKeys(StringUtils.repeat(Keys.BACK_SPACE.toString(), 10) + to);
      valueFrom.jsClick();
      inputTo.waitUntilInvisible();
    }
  }

  public void setInterval(String from, String to) {
    String currentFrom = getValueFrom();
    String currentTo = getValueTo();
    if (!StringUtils.equals(from, currentFrom) || !StringUtils.equals(to, currentTo)) {
      if (!inputFrom.isDisplayedFast()) {
        valueFrom.click();
        inputFrom.waitUntilVisible();
      }
      if (!StringUtils.equals(from, currentFrom)) {
        inputFrom.sendKeys(
            StringUtils.repeat(Keys.BACK_SPACE.toString(), 10) + from + Keys.ENTER + Keys.ENTER);
      }
      if (!StringUtils.equals(to, currentTo)) {
        inputTo.sendKeys(StringUtils.repeat(Keys.BACK_SPACE.toString(), 10) + to);
      }
//      valueFrom.jsClick();
//      inputTo.waitUntilInvisible();
    }
  }

  public void fairSetInterval(Date from, Date to) {
    if (!inputFrom.isDisplayedFast()) {
      valueFrom.click();
      inputFrom.waitUntilVisible();
    }
    String xpath = f(DATE_CELL_LOCATOR, DATE_CELL_FORMAT.format(from));
    new PageElement(getWebDriver(), xpath).click();
    xpath = f(DATE_CELL_LOCATOR, DATE_CELL_FORMAT.format(to));
    new PageElement(getWebDriver(), xpath).click();
  }

  public void fairSetInterval(String from, String to) {
    fairSetInterval(DataEntity.toDateTime(from), DataEntity.toDateTime(to));
  }

  public String getValueFrom() {
    return valueFrom.getValue();
  }

  public String getValueTo() {
    return valueTo.getValue();
  }
}
