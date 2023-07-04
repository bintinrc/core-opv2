package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.assertj.core.api.Assertions;
import org.junit.Assert;
import org.openqa.selenium.*;
import org.openqa.selenium.support.FindAll;
import org.openqa.selenium.support.FindBy;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Veera N
 */


@SuppressWarnings("WeakerAccess")
public class StationPendingPickupJobsPage extends OperatorV2SimplePage {

  private static final Logger LOGGER = LoggerFactory.getLogger(StationPendingPickupJobsPage.class);

  private static final String PENDING_PICKUP_TABLE_SEARCH_XPATH = "//div[starts-with(@class,'ant-table-filter')][.//*[.='%s']]//input";

  private static final String FILTER_BUTTON_XPATH = "//span[text()='%s']";

  private static final String CLICKED_BUTTON = "//span[text()='%s' and contains(@class,'ant-tag-checkable-checked styled')]";
  private static final String UNCLICKED_BUTTON = "//span[text()='%s' and contains(@class,'ant-tag ant-tag-checkable styled')]";

  public StationPendingPickupJobsPage(WebDriver webDriver) {
    super(webDriver);
  }

  public enum PendingPickupJobs {
    DRIVER_NAME_ROUTE_ID("station-pending-pickup-jobs_table_driver-name"),
    JOB_ID("station-pending-pickup-jobs_table_jobs-for-today_reservation-id"),
    NO_UPCOMING_JOB("station-pending-pickup-jobs_table_jobs-for-today_no-upcoming"),
    TIMESLOT("station-pending-pickup-jobs_table_jobs-for-today_timeslot"),
    PRIORITY_LEVEL("station-pending-pickup-jobs_table_jobs-for-today_priority-level"),
    TOTAL_PARCEL_COUNT("station-pending-pickup-jobs_table_parcels-total"),
    PARCEL_DUE_TODAY("station-pending-pickup-jobs_table_parcels-due-today"),
    PARCEL_LATE("station-pending-pickup-jobs_table_parcels-late"),
    DRIVER_EMPTY("station-pending-pickup-jobs_table_driver-name_empty"),
    ASSIGN_TO_ROUTE("station-pending-pickup-jobs_table_actions_assign-to-route"),
    CREATE_JOB("station-pending-pickup-jobs_table_actions_create-jobs");

    private String optionValue;

    PendingPickupJobs(String optionValue) {
      this.optionValue = optionValue;
    }

    public String getOptionValue() {
      return optionValue;
    }

    public String getXpath() {
      return String.format(
          "//tbody//div[@data-testid='%s']", this.optionValue);
    }
  }


  @FindAll(@FindBy(xpath = "//a[@data-testid='station-pending-pickup-jobs_table_actions_create-jobs']"))
  private List<PageElement> createJobButton;

  @FindAll(@FindBy(xpath = "//div[@data-testid='station-pending-pickup-jobs_table_jobs-for-today_no-upcoming']"))
  private List<PageElement> jobsForTodayValue;

  @FindAll(@FindBy(xpath = "//a[@data-testid='station-pending-pickup-jobs_table_actions_assign-to-route']"))
  public List<PageElement> assignToRouteButton;

  @FindAll(@FindBy(xpath = "//a[@data-testid='station-pending-pickup-jobs_table_actions_reassign-to-route']"))
  public List<PageElement> reAssignToRouteButton;


  @FindAll(@FindBy(xpath = "//tbody[@class='ant-table-tbody']//tr[@class='ant-table-row ant-table-row-level-0']"))
  public List<PageElement> noOfReultsInTable;

  @FindBy(css = "iframe")
  private List<PageElement> pageFrame;

  @FindBy(xpath = "//div[@data-testid='station-pending-pickup-jobs_table_empty-data']")
  private PageElement noPendingPickupRecords;

  @FindBy(xpath = "//span[text()='Parcels to Pickup']/parent::div")
  private PageElement sortParcelToPickup;

  public void switchToFrame() {
    if (pageFrame.size() > 0) {
      waitUntilVisibilityOfElementLocated(pageFrame.get(0).getWebElement(), 15);
      getWebDriver().switchTo().frame(pageFrame.get(0).getWebElement());
    }
  }

  public void applyFiltersInPendingPickupTableAndValidateResultCount(Map<String, String> filters,
      int resultsCount) {
    switchToFrame();
    waitWhilePageIsLoading();
    for (Map.Entry<String, String> filter : filters.entrySet()) {
      String filterXpath = f(PENDING_PICKUP_TABLE_SEARCH_XPATH, filter.getKey());
      scrollIntoView(filterXpath);
      List<WebElement> filterFields = getWebDriver().findElements(By.xpath(filterXpath));
      if (filterFields.size() > 0) {
        waitWhilePageIsLoading();
        filterFields.get(0).click();
        filterFields.get(0).sendKeys(filter.getValue());
      }
    }
    waitWhilePageIsLoading();
    Assert.assertTrue(
        f("Assert that the search should have %s records as expected after applying filters",
            resultsCount),
        noOfReultsInTable.size() == resultsCount);
  }

  public void applyFiltersInPendingPickupTable(Map<String, String> filters) {
    waitWhilePageIsLoading();
    switchToFrame();
    for (Map.Entry<String, String> filter : filters.entrySet()) {
      String filterColumnXpath = f(PENDING_PICKUP_TABLE_SEARCH_XPATH, filter.getKey());
      List<WebElement> filterFields = getWebDriver().findElements(By.xpath(filterColumnXpath));
      if (filterFields.size() > 0) {
        waitWhilePageIsLoading();
        filterFields.get(0).click();
        filterFields.get(0).sendKeys(Keys.chord(Keys.COMMAND, "a"));
        filterFields.get(0).sendKeys(Keys.BACK_SPACE);
        filterFields.get(0).sendKeys(filter.getValue());
        pause2s();
      }
    }
  }

  public void clickButton(String buttonText) {
    waitWhilePageIsLoading();
    switchToFrame();
    if (buttonText.equalsIgnoreCase("Create Job")) {
      createJobButton.get(0).getWebElement().click();
    }
    if (buttonText.equalsIgnoreCase("Assign To Route")) {
      assignToRouteButton.get(0).getWebElement().click();
    }
    if (buttonText.equalsIgnoreCase("Reassign To Route")) {
      reAssignToRouteButton.get(0).getWebElement().click();
    }
  }

  public String getValueFromJobsforToday() {
    switchToFrame();
    waitUntilVisibilityOfElementLocated(jobsForTodayValue.get(0).getWebElement());
    return jobsForTodayValue.get(0).getValue().trim();
  }

  public void verifyCurrentPageURL(String expectedURL) {
    String windowHandle = getWebDriver().getWindowHandle();
    switchToNewWindow();
    waitWhilePageIsLoading();
    pause3s();
    String currentURL = getWebDriver().getCurrentUrl().trim();
    Assertions.assertThat(getWebDriver().getCurrentUrl().endsWith("/" + expectedURL)).
        as("Assertion for the URL ends with " + expectedURL).isTrue();
    closeAllWindows(windowHandle);
    pause3s();
  }

  public String getColumnValue(PendingPickupJobs columnValue) {
    scrollIntoView(columnValue.getXpath());
    return getText(columnValue.getXpath());
  }

  public void validateThePresenceOfButton(String buttontext) {
    if (buttontext.equalsIgnoreCase("Assign to Route")) {
      Assertions.assertThat(assignToRouteButton.get(0).isDisplayed())
          .as("Validation for presence of Assign to Route button").isTrue();
    }
    if (buttontext.equalsIgnoreCase("Create Job")) {
      Assertions.assertThat(createJobButton.get(0).isDisplayed())
          .as("Validation for presence of Assign to Route button").isTrue();
    }
    if (buttontext.equalsIgnoreCase("Reassign to Route")) {
      Assertions.assertThat(reAssignToRouteButton.get(0).isDisplayed())
          .as("Validation for presence of Assign to Route button").isTrue();
    }
  }

  public void validateNoPendingPickupRecords() {
    waitWhilePageIsLoading();
    pause5s();
    switchToFrame();
    Assertions.assertThat(noPendingPickupRecords.isDisplayed())
        .as("Validation for presence of No Pending pickups").isTrue();
  }

  public void clickSortParcelsToPick() {
    waitWhilePageIsLoading();
    pause5s();
    switchToFrame();
    sortParcelToPickup.click();
  }

  public void clickFilterButton(String buttonText) {
    waitWhilePageIsLoading();
    pause5s();
    switchToFrame();
    String filterColumnXpath = f(FILTER_BUTTON_XPATH, buttonText);
    getWebDriver().findElement(By.xpath(filterColumnXpath)).click();
  }

  public void validateButtonIsClicked(String buttonText) {
    waitWhilePageIsLoading();
    pause5s();
    switchToFrame();
    String clickedButtonXpath = f(CLICKED_BUTTON, buttonText);
    WebElement clickedButton = getWebDriver().findElement(By.xpath(clickedButtonXpath));
    Assertions.assertThat(clickedButton.isDisplayed())
        .as("Validation for " + buttonText + " button is clicked").isTrue();
  }

  public void validateButtonIsUnClicked(String buttonText) {
    waitWhilePageIsLoading();
    pause5s();
    switchToFrame();
    String clickedButtonXpath = f(UNCLICKED_BUTTON, buttonText);
    WebElement clickedButton = getWebDriver().findElement(By.xpath(clickedButtonXpath));
    Assertions.assertThat(clickedButton.isDisplayed())
        .as("Validation for " + buttonText + "  button is unclicked").isTrue();
  }

}
