package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.util.SingletonStorage;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class BlockedDatesPage extends OperatorV2SimplePage {

  private static final Logger LOGGER = LoggerFactory.getLogger(BlockedDatesPage.class);
  private static final SimpleDateFormat MONTH_SDF = new SimpleDateFormat("MMMM", Locale.ENGLISH);

  public BlockedDatesPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void addBlockedDate() {
        /*
          Set default year of "Blocked Dates" on right panel to current year.
         */
    WebElement blockedDatesYearWe = findElementByXpath(
        "//div[contains(@class, 'list')]/md-content[contains(@class, 'list-content')]/div/md-input-container");
    blockedDatesYearWe.click();

    int currentYear = Calendar.getInstance().get(Calendar.YEAR);
    WebElement currentYearOptionWe = findElementByXpath(
        f("//md-option[@ng-repeat='m in yearList' and @value='%d']", currentYear));
    currentYearOptionWe.click();

    List<WebElement> elm = findElementsByXpath(
        "//div[@ng-repeat='day in week track by $index' and not(contains(@class, 'active')) and not(contains(@class, 'not-same-month'))]");

    if (!elm.isEmpty()) {
      WebElement day = elm.get(0);
      day.click();

      WebElement yearElm = findElementByXpath(
          "//md-select[@ng-model='calendar.year']/md-select-value/span/div");
      SingletonStorage.getInstance()
          .setTmpId(yearElm.getText() + "-" + getMonth() + "-" + getDay(day));
      click("//button[@type='submit'][@aria-label='Save Button']");
    }
  }

  public void verifyBlockedDateAddedSuccessfully() {
    if (SingletonStorage.getInstance().getTmpId() != null) {
      retryIfStaleElementReferenceExceptionOccurred(() ->
      {
        boolean isAdded = false;
        List<WebElement> els = findElementsByXpath(
            "//md-list-item[@ng-repeat=\"date in calendarListData.dates | nvFilterByYear:year | orderBy\"]/p/span[1]");

        for (WebElement el : els) {
          if (el.getText().contains(SingletonStorage.getInstance().getTmpId())) {
            isAdded = true;
            break;
          }
        }

        Assertions.assertThat(isAdded).as("Blocked Date should be added.").isTrue();
      }, getCurrentMethodName());
    }
  }

  public void removeBlockedDate() {
    if (SingletonStorage.getInstance().getTmpId() != null) {
      boolean isRemoved = false;
      List<WebElement> els = findElementsByXpath(
          "//md-list-item[@ng-repeat=\"date in calendarListData.dates | nvFilterByYear:year | orderBy\"]");

      for (WebElement el : els) {
        WebElement inner = el.findElement(By.xpath("p/span[1]"));

        if (inner.getText().contains(SingletonStorage.getInstance().getTmpId())) {
          el.findElement(By.xpath("button[@ng-click=\"removeDate(date, $event)\"]")).click();
          click("//button[@type='submit'][@aria-label='Save Button']");
          isRemoved = true;
          break;
        }
      }

      Assertions.assertThat(isRemoved).as("Blocked Date should be removed.").isTrue();
    }
  }

  public void verifyBlockedDateRemovedSuccessfully() {
    if (SingletonStorage.getInstance().getTmpId() != null) {
      retryIfStaleElementReferenceExceptionOccurred(() ->
      {
        boolean isFound = false;
        List<WebElement> els = findElementsByXpath(
            "//md-list-item[@ng-repeat=\"date in calendarListData.dates | nvFilterByYear:year | orderBy\"]/p/span[1]");

        for (WebElement el : els) {
          if (el.getText().contains(SingletonStorage.getInstance().getTmpId())) {
            isFound = true;
            break;
          }
        }

        assertFalse(isFound);
      }, getCurrentMethodName());
    }
  }

  private String getDay(WebElement day) {
    WebElement dayTxt = day.findElement(By.xpath("div[1]"));
    int dayNumber = Integer.parseInt(dayTxt.getText());
    return dayNumber < 10 ? "0" + dayNumber : "" + dayNumber;
  }

  private String getMonth() {
    String monthText = null;

    try {
      WebElement monthElm = getWebDriver().findElement(
          By.xpath("//md-select[@ng-model='calendar.month']/md-select-value/span/div"));
      Date date = MONTH_SDF.parse(monthElm.getText());
      Calendar cal = Calendar.getInstance();
      cal.setTime(date);
      int month = cal.get(Calendar.MONTH) + 1;
      monthText = month < 10 ? "0" + month : "" + month;
    } catch (Exception ex) {
      LOGGER.warn("Failed to get month. Cause: {}", ex.getMessage());
    }

    return monthText;
  }
}
