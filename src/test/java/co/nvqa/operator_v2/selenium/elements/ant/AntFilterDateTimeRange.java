package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.Date;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static co.nvqa.commons.support.DateUtil.DATE_FORMATTER;

/**
 * Created on 30/10/20.
 *
 * @author Sergey Mishanin
 */
public class AntFilterDateTimeRange extends PageElement {

  private static final SimpleDateFormat DATE_CELL_FORMAT = new SimpleDateFormat("MMMMM d, yyyy");
  private static final String DATE_CELL_LOCATOR = "//td[@role='gridcell'][@title='%s']";

  public AntFilterDateTimeRange(WebDriver webDriver, SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  public AntFilterDateTimeRange(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  @FindBy(xpath = "(.//div[contains(@class, 'ant-picker-input')]/input)[1]")
  public ForceClearTextBox dateFrom;

  @FindBy(xpath = "(.//div[contains(@class, 'ant-select')])[1]")
  public AntSelect2 hoursFrom;

  @FindBy(xpath = "(.//div[contains(@class, 'ant-select')])[3]")
  public AntSelect2 minutesFrom;

  @FindBy(xpath = "(.//div[contains(@class, 'ant-picker-input')]/input)[2]")
  public ForceClearTextBox dateTo;

  @FindBy(xpath = "(.//div[contains(@class, 'ant-select')])[5]")
  public AntSelect2 hoursTo;

  @FindBy(xpath = "(.//div[contains(@class, 'ant-select')])[7]")
  public AntSelect2 minutesTo;

  public void setFromDate(String from) {
    if (!StringUtils.equals(from, getFromDate())) {
      dateFrom.click();
      dateFrom.setValue(from + Keys.ENTER);
    }
  }

  public void setFromDate(Date from) {
    setFromDate(DATE_FORMATTER.format(LocalDateTime.from(from.toInstant())));
  }

  public void setToDate(String from) {
    if (!StringUtils.equals(from, getToDate())) {
      dateTo.click();
      dateTo.setValue(from + Keys.ENTER);
    }
  }

  public void setToDate(Date to) {
    setToDate(DATE_FORMATTER.format(LocalDateTime.from(to.toInstant())));
  }

  public String getFromDate() {
    return dateFrom.getValue();
  }

  public String getToDate() {
    return dateTo.getValue();
  }

  public void setFromHours(String hours) {
    if (!StringUtils.equals(hours, getFromHours())) {
      hoursFrom.selectValue(hours);
    }
  }

  public void setToHours(String hours) {
    if (!StringUtils.equals(hours, getToHours())) {
      hoursTo.selectValue(hours);
    }
  }

  public String getFromHours() {
    return hoursFrom.getValue();
  }

  public String getToHours() {
    return hoursTo.getValue();
  }

  public void setFromMinutes(String hours) {
    if (!StringUtils.equals(hours, getFromMinutes())) {
      minutesFrom.selectValue(hours);
    }
  }

  public void setToMinutes(String hours) {
    if (!StringUtils.equals(hours, getToMinutes())) {
      minutesTo.selectValue(hours);
    }
  }

  public String getFromMinutes() {
    return minutesFrom.getValue();
  }

  public String getToMinutes() {
    return minutesTo.getValue();
  }
}
