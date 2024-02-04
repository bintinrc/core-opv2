package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
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
import org.openqa.selenium.support.Color;
import org.openqa.selenium.support.FindBy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class BlockedDatesPage extends SimpleReactPage<BlockedDatesPage> {

  private static final Logger LOGGER = LoggerFactory.getLogger(BlockedDatesPage.class);
  private static final SimpleDateFormat MONTH_SDF = new SimpleDateFormat("MMMM", Locale.ENGLISH);
  @FindBy(xpath = "//div[@data-testid='blocked-date-list']//button")
  public Button blockedYearsList;
  @FindBy(xpath = "//div[contains(@data-testid,'blocked-calendar-date')]")
  public List<PageElement> blockedCalendarDates;
  @FindBy(xpath = "//button[@data-testid='blocked-date-calendar-year-select']//span")
  public PageElement selectedYear;

  @FindBy(css = "[data-testid= 'blocked-date-save-changes']")
  public Button saveChanges;

  @FindBy(xpath = "//div[contains(@data-testid,'blocked-calendar-date')][1]/span")
  public PageElement day;
  @FindBy(xpath = "//button[@data-testid='blocked-date-calendar-month-select']//span")
  public PageElement month;
  @FindBy(xpath = "//div[contains(@data-testid,'blocked-date-item')]/span")
  List<PageElement> blockedDatesList;
//  @FindBy(css = "[data-testid= 'blocked-date-item']")
//  List<PageElement> blockedDateItem;

  public BlockedDatesPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void addBlockedDate() {
        /*
          Set default year of "Blocked Dates" on right panel to current year.
         */
    blockedYearsList.click();

    int currentYear = Calendar.getInstance().get(Calendar.YEAR);
    String xpath = "//div[@data-testid='blocked-date-list']//span[.='%d']";
    PageElement currentYearOptionWe = new PageElement(getWebDriver(), f(xpath, currentYear));
    currentYearOptionWe.click();
    // red background color means date already blocked
    for (PageElement element : blockedCalendarDates) {
      Color color = Color.fromString(element.getCssValue("color"));
      if (!color.asHex().equals("#F2F2F2FF")) {
        PageElement day = element;
        day.click();
        SingletonStorage.getInstance()
            .setTmpId(selectedYear.getText() + "-" + getMonth() + "-" + getDay());
        break; // Exit the loop
      }
    }
    saveChanges.click();
  }

  public void verifyBlockedDateAddedSuccessfully() {
    if (SingletonStorage.getInstance().getTmpId() != null) {
      retryIfStaleElementReferenceExceptionOccurred(() ->
      {
        boolean isAdded = false;
        for (PageElement el : blockedDatesList) {
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
//      List<WebElement> els = findElementsByXpath(
//          "//md-list-item[@ng-repeat=\"date in calendarListData.dates | nvFilterByYear:year | orderBy\"]");

      for (PageElement item : blockedDatesList) {
//        WebElement inner = item.findElement(By.xpath("p/span[1]"));

        if (item.getText().contains(SingletonStorage.getInstance().getTmpId())) {
          item.findElement(By.xpath("//button[contains(@data-testid, '\" + item.getText() + \"') and contains(@data-testid, '-remove')]")).click();
          saveChanges.click();
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

  private String getDay() {
    int dayNumber = Integer.parseInt(day.getText());
    return dayNumber < 10 ? "0" + dayNumber : "" + dayNumber;
  }

  private String getMonth() {
    String monthText = null;

    try {
      Date date = MONTH_SDF.parse(month.getText());
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
