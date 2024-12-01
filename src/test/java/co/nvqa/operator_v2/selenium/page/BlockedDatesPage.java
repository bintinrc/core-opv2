package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.util.SingletonStorage;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class BlockedDatesPage extends SimpleReactPage<BlockedDatesPage> {

  @FindBy(css = "[data-testid= 'blocked-date-save-changes']")
  public Button saveChanges;

  @FindBy(xpath = "//div[contains(@data-testid,'blocked-calendar-date')][1]/span")
  public PageElement day;

  @FindBy(xpath = "//div[contains(@data-testid,'blocked-date-item')]/span")
  List<PageElement> blockedDatesList;

  @FindBy(css = "[data-testid='blocked-date-undo-changes']")
  public Button undoChanges;

  public BlockedDatesPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void addDate(String date) {
    String xpath = "//div[@data-testid='blocked-calendar-date-%s']";
    // Parse date string to LocalDate object
    LocalDate dateValue = LocalDate.parse(date);
    // Check if the date is found in the blockedDatesList
    boolean found = false;
    if (!blockedDatesList.isEmpty()) {
      for (PageElement blockedDate : blockedDatesList) {
        String blockedDateText = blockedDate.getText()
            .split("\\. ")[1]; // Split by ". " and take the second part
        if (date.equals(blockedDateText)) {
          // Increment the date by one day if found
          dateValue = dateValue.plusDays(1);
          found = true;
        }
      }
    }
    // If the date is not found, use the original date
    String selectedDateString = found ? dateValue.format(DateTimeFormatter.ISO_LOCAL_DATE) : date;

    // Locate the date element
    PageElement selectedDate = new PageElement(getWebDriver(), f(xpath, selectedDateString));
    SingletonStorage.getInstance()
        .setTmpId(selectedDateString);
    // Click the selected date element
    selectedDate.click();
    saveChanges.click();
  }

  public void verifyBlockedDateAddedSuccessfully() {
    if (SingletonStorage.getInstance().getTmpId() != null) {
      retryIfStaleElementReferenceExceptionOccurred(() ->
      {
        boolean isAdded = false;
        for (PageElement blockedDate : blockedDatesList) {
          if (blockedDate.getText().contains(SingletonStorage.getInstance().getTmpId())) {
            isAdded = true;
            break;
          }
        }
        Assertions.assertThat(isAdded).as("Blocked Date should be added.").isTrue();
      }, getCurrentMethodName());
    }

  }

  public void removeBlockedDate(String date) {
    String xpath = "//a[@data-testid='blocked-date-item-%d-remove']";
    int index = 1;
    for (PageElement item : blockedDatesList) {
      if (item.getText().contains(date)) {
        PageElement removeBlockedDate = new PageElement(getWebDriver(), f(xpath, index));
        removeBlockedDate.click();
        SingletonStorage.getInstance()
            .setTmpId(date);
        saveChanges.click();
        break;
      }
      index++;
    }
  }

  public void verifyBlockedDateRemovedSuccessfully() {
    if (SingletonStorage.getInstance().getTmpId() != null) {
      retryIfStaleElementReferenceExceptionOccurred(() ->
      {
        boolean isFound = false;
        for (PageElement blockedDate : blockedDatesList) {
          if (blockedDate.getText().contains(SingletonStorage.getInstance().getTmpId())) {
            isFound = true;
            break;
          }
        }
        assertFalse(isFound);
      }, getCurrentMethodName());
    }
  }
}
