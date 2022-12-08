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

  public StationPendingPickupJobsPage(WebDriver webDriver) {
    super(webDriver);
  }

  @FindAll(@FindBy(xpath = "//a[@data-testid='station-pending-pickup-jobs_table_actions_create-jobs']"))
  private List<PageElement> createJobButton;

  @FindAll(@FindBy(xpath = "//div[@data-testid='station-pending-pickup-jobs_table_jobs-for-today_no-upcoming']"))
  private List<PageElement> jobsForTodayValue;

  @FindAll(@FindBy(xpath = "//a[@data-testid='station-pending-pickup-jobs_table_actions_assign-to-route']"))
  public List<PageElement> assignToRouteButton;

  @FindAll(@FindBy(xpath = "//tbody[@class='ant-table-tbody']//tr"))
  public List<PageElement> noOfReultsInTable;


  public void applyFiltersInPendingPickupTableAndValidateResultCount(Map<String, String> filters,
      int resultsCount) {
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
    pause3s();
    Assert.assertTrue(
        f("Assert that the search should have %s records as expected after applying filters",
            resultsCount),
        noOfReultsInTable.size() == resultsCount);
  }

  public void applyFiltersInPendingPickupTable(Map<String, String> filters) {
    waitWhilePageIsLoading();
    for (Map.Entry<String, String> filter : filters.entrySet()) {
      String filterColumnXpath = f(PENDING_PICKUP_TABLE_SEARCH_XPATH, filter.getKey());
      scrollIntoView(filterColumnXpath);
      List<WebElement> filterFields = getWebDriver().findElements(By.xpath(filterColumnXpath));
      if (filterFields.size() > 0) {
        waitWhilePageIsLoading();
        filterFields.get(0).click();
        filterFields.get(0).sendKeys(filter.getValue());
      }
    }
  }

  public void clickCreateJobButton() {
    waitWhilePageIsLoading();
    waitUntilVisibilityOfElementLocated(createJobButton.get(0).getWebElement());
    createJobButton.get(0).click();
  }

  public String getValueFromJobsforToday() {
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
        as("Assertion for the URL ends with" + expectedURL).isTrue();
    closeAllWindows(windowHandle);
    pause3s();
  }

}
