package co.nvqa.operator_v2.selenium.elements.md;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.InvalidElementStateException;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class MdDatepicker extends PageElement {

  private static final DateTimeFormatter DATE_FILTER_SDF = DateTimeFormatter.ofPattern(
      "EEEE MMMM d yyyy");

  public MdDatepicker(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public MdDatepicker(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  @FindBy(className = "md-datepicker-input")
  public PageElement input;

  @FindBy(xpath = "./parent::*")
  public PageElement parent;

  @FindBy(css = "button.md-datepicker-button")
  public Button calendarButton;

  @FindBy(xpath = "//tbody[@class='md-calendar-month']")
  public List<CalendarMonth> months;

  @Override
  public String getValue() {
    return input.getValue();
  }

  public void setDate(ZonedDateTime date) {
    try {
      String value = DTF_NORMAL_DATE.format(date);
      simpleSetValue(value);
    } catch (InvalidElementStateException ex) {
      String value = DATE_FILTER_SDF.format(date);
      setValue(value);
    }
  }

  public void simpleSetValue(String value) {
    input.clearAndSendKeys(value);
    parent.jsClick();
  }

  public void setValue(String value) {
    if (StringUtils.isBlank(value)) {
      throw new IllegalArgumentException("Incorrect input value [" + value + "]");
    }
    calendarButton.click();
    String dayXpath = f("//td[@aria-label='%s']", value);
    int count = 0;
    while (!isElementExistFast(dayXpath) && count < 10) {
      List<WebElement> webElements = findElementsBy(
          By.xpath("//tbody[@class='md-calendar-month']"));
      scrollIntoView(webElements.get(webElements.size() - 1), true);
      count++;
    }
    scrollIntoView(dayXpath, true);
    pause200ms();
    click(dayXpath);
  }

  public static class CalendarMonth extends PageElement {

    public CalendarMonth(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public CalendarMonth(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
      super(webDriver, searchContext, webElement);
    }
  }
}