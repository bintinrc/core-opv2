package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.StationLanguage;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect2;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.common.collect.Comparators;
import java.util.Comparator;
import org.assertj.core.api.Assertions;
import org.junit.Assert;
import org.openqa.selenium.*;
import org.openqa.selenium.support.FindAll;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.FluentWait;
import org.openqa.selenium.support.ui.Wait;
import java.time.Duration;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Veera N
 */


@SuppressWarnings("WeakerAccess")
public class StationManagementHomePage extends OperatorV2SimplePage {

  private static final Logger LOGGER = LoggerFactory.getLogger(StationManagementHomePage.class);

  private static final String STATION_HOME_URL_PATH = "/station-homepage";
  private static final String STATION_HUB_URL_PATH = "/station-homepage/hubs/%s";
  private static final String STATION_RECOVERY_TICKETS_URL_PATH = "/recovery-tickets/result?tracking_ids=%s";
  private static final String STATION_EDIT_ORDER_URL_PATH = "/order-v2?id=%s";
  private static final String TILE_VALUE_XPATH = "(//div[contains(@class,'title')][.='%s'] | //div[contains(@class,'title')][.//*[.='%s']])/following-sibling::div//div[@class='value']";
  private static final String PENDING_PICKUP_TILE_VALUE_XPATH = "//*[.='%s']/following-sibling::*";
  private static final String TILE_TITLE_XPATH = "//div[@class='ant-card-body']//*[text()='%s'] | //div[contains(@class,'th')]//*[text()='%s']";
  private static final String TILE_HAMBURGER_XPATH = "(//div[contains(@class,'title')][.='%s'] | //div[contains(@class,'title')][.//*[.='%s']])/following-sibling::div//*[@role='img']";
  private static final String PENDING_PICKUP_TILE_HAMBURGER_XPATH = "//span[text()='%s']//parent::div//following-sibling::div//*[local-name()='svg']";
  private static final String MODAL_CONTENT_XPATH = "//*[@class='ant-modal-content'][.//*[contains(text(),'%s')]]";
  private static final String MODAL_TABLE_SEARCH_XPATH = "//div[starts-with(@class,'VirtualTableHeader')][.//*[.='%s']]//input";
  private static final String MODAL_TABLE_FILTER_XPATH = "//div[starts-with(@class,'VirtualTableHeader')][.//*[.='%s']]//div[contains(@class,'FilterSelect')]";
  private static final String MODAL_TABLE_MULTIPLE_FILTER_XPATH = "//*[contains(@class,'Filter') and text()='%s']";
  private static final String MODAL_TABLE_COMBO_FILTER_XPATH = "//div[contains(@class,'VirtualTableHeader')][.//div[.='%s']]//div[@class='ant-select-selector']";
  private static final String MODAL_TABLE_HEADER_XPATH = "//div[@class='BaseTable__header']//div[contains(@class,'th')]";
  private static final String MODAL_TABLE_FILTER_SORT_XPATH = "//div[contains(@class,'th')]//div[contains(text(),'%s')]";
  private static final String MODAL_TABLE_BY_TABLE_NAME_XPATH = "//*[contains(text(),'%s')]/parent::div/parent::div/following-sibling::div//div[@role='table']";
  private static final String MODAL_TABLE_FILTER_BY_TABLE_NAME_XPATH = "//*[contains(text(),'%s')]/ancestor::div[contains(@class,'ant-modal-content')]//div[text()='%s']/parent::div[starts-with(@class,'VirtualTableHeader')]//input";
  private static final String LEFT_NAVIGATION_LINKS_BY_HEADER = "//*[text()='%s']/parent::div/following::div//div[@class='link-index']/parent::div//a|//*[text()='%s']/parent::div//a";
  private static final String HUB_SELECTION_COMBO_VALUE_XPATH = "(//*[text()='%s'])[2]/ancestor::div[@class='ant-select-selector']";
  private static final String TABLE_CONTENT_BY_COLUMN_NAME = "//div[contains(@data-datakey,'%s')]//span[@class]";
  private static final String RECOVERY_TICKETS = "Recovery Tickets";
  private static final String TABLE_TRACKING_ID_XPATH = "//a[.//*[.='%s']]|//a[text()='%s']";
  private static final String URGENT_TASKS_ARROW_BY_TEXT_XPATH = "//*[text()=\"%s\"]/parent::div//div[@class='icon']//span";
  private static final String TABLE_COLUMN_VALUES_BY_INDEX_CSS = "[class$='_body'] [role='gridcell']:nth-child(%d)";
  private static final String QUICK_FILTER_BY_TEXT_XPATH = "//div[text()='Quick Filters']//span[text()='%s']";
  private static final String RECORD_CHECK_BOX_BY_TRACKING_ID_XPATH = "//div[@role='row'][.//*[.='%s']]//input[@type='checkbox']";
  private static final String NO_RESULTS_FOUND_TEXT_XPATH = "//div[contains(@class,'ant-card')][.//*[.='%s']]//div[normalize-space(text())='No Results Found']";

  private static final String EDIT_ORDER_TRACKING_ID_XPATH = "//div[text()='%s']";

  public StationManagementHomePage(WebDriver webDriver) {
    super(webDriver);
  }

  @FindBy(css = "div.nv-h4, header div[style*='bold']")
  private PageElement pageHeader;

  @FindBy(id = "hint-link")
  public PageElement referParentsProfileLink;

  @FindBy(css = "iframe")
  private List<PageElement> pageFrame;

  @FindBy(xpath = "(//span[text()='Search or Select'])[2]/ancestor::div[@class='ant-select-selector']")
  public AntSelect2 hubs;

  @FindBy(xpath = "//button[contains(@*,'proceed')]")
  public PageElement proceedBtn;

  @FindBy(xpath = "//div[contains(@class,'row-cell-text')]")
  public PageElement hubDropdownValues;

  @FindBy(css = "div.ant-select")
  public AntSelect2 headerHub;

  @FindBy(xpath = "//button[@data-testid='station-management-homepage_manual-button']")
  public AntSelect2 manualButton;

  @FindBy(xpath = "//div[contains(@class,'modal-content')]//div[contains(@class,'base-row')]")
  private List<PageElement> results;

  @FindBy(xpath = "//label[text()='Tracking ID']/following-sibling::h3")
  private PageElement editOrderTrackingId;

  @FindBy(xpath = "//div[text()='Route ID']/following-sibling::div")
  private PageElement routeManifestRouteId;

  @FindBy(xpath = "//div[contains(@class,'modal-content')]//div[starts-with(@class,'VirtualTableHeader')]/*[1]")
  private List<PageElement> modalTableColumns;

  @FindBy(css = "div.value svg")
  private PageElement tileValueLoadIcon;

  @FindBy(css = "button[class$='ant-modal-close']")
  private List<PageElement> modalCloseIcon;

  @FindBy(css = "div[class$='badge-count']")
  private List<PageElement> sfldTicketCount;

  @FindBy(css = "span[aria-label$='bell']")
  private PageElement alarmBell;

  @FindBy(xpath = "//*[@title='SFLD Unconfirmed Tickets']")
  private PageElement fsrUnconfirmedETAArrow;

  @FindBy(xpath = "//button[@disabled]//*[text()='Save & Proceed']")
  private List<PageElement> disabledSaveAndProceed;

  @FindBy(xpath = "//button[.//*[text()='Save & Proceed']]")
  private PageElement saveAndProceed;

  @FindBy(xpath = "//div[@*='suggestedEtas']//*[contains(@class,'ant-select-selection-item')]")
  private List<PageElement> confirmedEtas;

  @FindBy(css = "div[class$='base-row'] input[type='checkbox']")
  private List<PageElement> checkboxInRow;

  @FindBy(css = "div.polling-time-info")
  public PageElement pollingTimeInfo;

  @FindBy(css = "[id*='rc_unique_0']")
  public PageElement dialogLanguage;

  @FindBy(css = "li:last-child .text")
  public PageElement fsrText;

  @FindBy(xpath = "//*[contains(text(),'ETA that need to be confirmed')]/preceding-sibling::b")
  public List<PageElement> fsrCount;

  @FindBy(css = "div[class*='footer-row']")
  private PageElement footerRow;

  @FindAll(@FindBy(xpath = "//div[starts-with(@class,'VirtualTableHeader')]/*[1]"))
  private List<PageElement> columnNames;

  @FindAll(@FindBy(xpath = "//div[@class='BaseTable__row-cell']//div[starts-with(@class,'VirtualTable__')]"))
  private List<PageElement> columnValues;

  @FindBy(css = "span[class*='ant-select-selection-item']")
  private PageElement headerHubValue;

  @FindBy(css = "div.ant-notification-notice-message")
  private PageElement toastMessage;

  @FindBy(xpath = "//div[@*='suggestedEtas']//*[@class='ant-select-selector']")
  public AntSelect2 suggestedEtas;

  @FindBy(css = "div[class*='common-date'] [class='ant-select-selector']")
  public AntSelect2 commonSuggestedEtas;

  @FindAll(@FindBy(css = "div[class*='base-row'] input[type='checkbox']"))
  private List<PageElement> modalCheckboxes;

  @FindAll(@FindBy(css = "div[class*='base-row'] span[class*='checked']"))
  private List<PageElement> checkboxChecked;

  @FindAll(@FindBy(css = "span[class*='-checked']"))
  private List<PageElement> filterApplied;

  @FindBy(css = "div.sfld-alert")
  public PageElement sfldAlert;

  @FindBy(xpath = "//button[.//*[.='Download Failed ETAs']]")
  public PageElement downloadFailedEtas;

  @FindBy(xpath = "//div[@class='ant-modal-body']//span[text()='Search or Select']")
  public List<PageElement> modalHubSelection;

  @FindBy(xpath = "//canvas")
  public List<PageElement> chart;

  @FindBy(css = "div.ant-tooltip:not([class*='ant-tooltip-hidden'])")
  public List<PageElement> mouseOverText;

  @FindBy(css = "div.ant-tooltip:not([class*='ant-tooltip-hidden']) li")
  public List<PageElement> mouseOverTextList;

  public void switchToStationHomeFrame() {
    getWebDriver().switchTo().frame(pageFrame.get(0).getWebElement());
  }

  public void waitWhileStationPageLoads() {
    waitUntilInvisibilityOfElementLocated("//span[@class='ant-spin-dot ant-spin-dot-spin']", 60);
    waitUntilPageLoaded();
  }

  public void selectHubAndProceed(String hubName) {
    if (pageFrame.size() > 0) {
      waitUntilVisibilityOfElementLocated(pageFrame.get(0).getWebElement(), 15);
      switchToStationHomeFrame();
    }
    waitWhilePageIsLoading();
    if (modalHubSelection.size() == 0) {
      refreshPage_v1();
    }
    hubs.enterSearchTerm(hubName);
    pause5s();
    hubDropdownValues.click();
    proceedBtn.click();
    waitWhilePageIsLoading();
  }

  public void selectHubAndProceed(String hubName, StationLanguage.HubSelectionText language) {
    String langDropdownText = "";
    if (pageFrame.size() > 0) {
      waitUntilVisibilityOfElementLocated(pageFrame.get(0).getWebElement(), 15);
      switchToStationHomeFrame();
    }
    langDropdownText = language.getText();
    waitUntilVisibilityOfElementLocated(f("(//*[text()='%s'])[2]", langDropdownText), 30);
    WebElement hubs = getWebDriver().findElement(
        By.xpath(f(HUB_SELECTION_COMBO_VALUE_XPATH, langDropdownText)));
    AntSelect2 pageHubs = new AntSelect2(getWebDriver(), hubs);
    pageHubs.click();
    pageHubs.enterSearchTerm(hubName);
    hubDropdownValues.click();
    proceedBtn.click();
    waitWhilePageIsLoading();
  }

  public void changeHubInHeaderDropdown(String hubName) {
    headerHub.click();
    headerHub.enterSearchTerm(hubName);
    hubDropdownValues.click();
    waitWhilePageIsLoading();
  }

  public int getNumberFromTile(String tileName) {
    try {
      String tileValueXpath = f(TILE_VALUE_XPATH, tileName, tileName);
      waitWhilePageIsLoading();
      if (pageFrame.size() > 0) {
        switchToStationHomeFrame();
      }
      waitUntilTileValueLoads(tileName);
      waitUntilVisibilityOfElementLocated(tileValueXpath, 15);
      pause5s();
      WebElement tile = getWebDriver().findElement(By.xpath(tileValueXpath));
      String tileValue = tile.getText().replace(",", "").trim();
      if (tileValue.contains(" ")) {
        tileValue = tileValue.substring(0, tileValue.indexOf(' '));
      }
      LOGGER.info("Tile Value from " + tileName + " is " + tileValue);
      return Integer.parseInt(tileValue);
    } catch (Exception e) {
      LOGGER.error(e.getMessage(), e);
      return 0;
    }
  }

  public int getNumberFromPendingPickupTile(String tileName) {
    try {
      pause8s();
      String tileValueXpath = f(PENDING_PICKUP_TILE_VALUE_XPATH, tileName);
      waitWhilePageIsLoading();
      if (pageFrame.size() > 0) {
        switchToStationHomeFrame();
      }
      waitUntilVisibilityOfElementLocated(tileValueXpath, 15);
      WebElement tile = getWebDriver().findElement(By.xpath(tileValueXpath));
      String tileValue = tile.getText().replace(",", "").trim();
      tileValue = tileValue.replace("%", "").trim();
      if (tileValue.contains(" ")) {
        tileValue = tileValue.substring(0, tileValue.indexOf(' '));
      }
      LOGGER.info("Tile Value from " + tileName + " is " + tileValue);
      return Integer.parseInt(tileValue);
    } catch (Exception e) {
      LOGGER.error(e.getMessage(), e);
      return 0;
    }
  }

  public String getTileValueAsStringFromPendingPickupTile(String tileName) {
    String tileValue = null;
    try {
      String tileValueXpath = f(PENDING_PICKUP_TILE_VALUE_XPATH, tileName);
      waitWhilePageIsLoading();
      if (pageFrame.size() > 0) {
        switchToStationHomeFrame();
      }
      waitUntilVisibilityOfElementLocated(tileValueXpath, 15);
      pause5s();
      WebElement tile = getWebDriver().findElement(By.xpath(tileValueXpath));
      tileValue = tile.getText().replace(",", "").trim();
      tileValue = tileValue.replace("%", "").trim();
      if (tileValue.contains(" ")) {
        tileValue = tileValue.substring(0, tileValue.indexOf(' '));
      }
      LOGGER.info("Tile Value from " + tileName + " is " + tileValue);
      return tileValue;
    } catch (Exception e) {
      LOGGER.error(e.getMessage(), e);
      return tileValue;
    }
  }

  public int getSfldParcelCount() {
    int actualCount = -1;
    waitWhilePageIsLoading();
    pause5s();
    try {
      if (fsrCount.size() > 0) {
        return Integer.parseInt(fsrCount.get(0).getText().trim());
      } else {
        actualCount = 0;
      }
      return actualCount;
    } catch (Exception e) {
      return -1;
    }

  }

  public double getDollarValueFromTile(String tileName) {
    try {
      String tileValueXpath = f(TILE_VALUE_XPATH, tileName, tileName);
      waitWhilePageIsLoading();
      if (pageFrame.size() > 0) {
        switchToStationHomeFrame();
      }
      waitUntilTileValueLoads(tileName);
      pause5s();
      WebElement tile = getWebDriver().findElement(By.xpath(tileValueXpath));
      String dollarAmount = tile.getText().trim().replaceAll("\\$|\\,", "");
      return Double.parseDouble(dollarAmount);
    } catch (Exception e) {
      LOGGER.error(e.getMessage(), e);
      return 0;
    }
  }

  public void clickHamburgerIcon(String tileName) {
    String hamburgerXpath = f(TILE_HAMBURGER_XPATH, tileName, tileName);
    WebElement hamburger = getWebDriver().findElement(By.xpath(hamburgerXpath));
    scrollIntoView(hamburger);
    hamburger.click();
  }

  public void clickPendingPickupHamburgerIcon(String tileName) {
    String hamburgerXpath = f(PENDING_PICKUP_TILE_HAMBURGER_XPATH, tileName);
    WebElement hamburger = getWebDriver().findElement(By.xpath(hamburgerXpath));
    scrollIntoView(hamburger);
    hamburger.click();
  }

  public void openModalPopup(String modalTitle, String tileName) {
    waitWhilePageIsLoading();
    pause3s();
    String titleXpath = f(MODAL_CONTENT_XPATH, modalTitle);
    closeIfModalDisplay();
    clickHamburgerIcon(tileName);
    waitUntilVisibilityOfElementLocated(titleXpath);
    WebElement modalContent = getWebDriver().findElement(By.xpath(titleXpath));
    Assert.assertTrue("Assert that modal pop-up is opened",
        modalContent.isDisplayed());
  }

  public void verifyRouteMonitoringPageIsOpenedInNewTab(String tileName) {
    waitWhilePageIsLoading();
    String windowHandle = getWebDriver().getWindowHandle();
    pause3s();
    closeIfModalDisplay();
    clickHamburgerIcon(tileName);
    switchToNewWindow();
    waitWhilePageIsLoading();
    pause3s();
    Assertions.assertThat(getWebDriver().getCurrentUrl()).contains("/route-monitoring-paged");
    closeAllWindows(windowHandle);
  }

  public void verifyModalPopupByName(String modalTitle) {
    waitWhilePageIsLoading();
    pause3s();
    String titleXpath = f(MODAL_CONTENT_XPATH, modalTitle);
    List<WebElement> modalContent = getWebDriver().findElements(By.xpath(titleXpath));
    waitUntilVisibilityOfElementLocated(modalContent.get(0), 15);
    Assert.assertTrue(f("Assert that the modal pop-up %s is displayed", modalTitle),
        modalContent.size() > 0);
  }

  public void closeIfModalDisplay(String modalTitle) {
    waitWhilePageIsLoading();
    if (pageFrame.size() > 0) {
      switchToStationHomeFrame();
    }
    pause3s();
    String titleXpath = f(MODAL_CONTENT_XPATH, modalTitle);
    List<WebElement> modalContent = getWebDriver().findElements(By.xpath(titleXpath));
    if (modalContent.size() > 0) {
      modalCloseIcon.get(0).click();
    }
  }

  public void closeIfModalDisplay() {
    waitWhilePageIsLoading();
    if (pageFrame.size() > 0) {
      switchToStationHomeFrame();
    }
    pause3s();
    if (modalCloseIcon.size() > 0) {
      modalCloseIcon.get(0).click();
    }
  }

  public void validateHubURLPath(String hubId) {
    String expectedURLPath = f(STATION_HUB_URL_PATH, hubId);
    Assert.assertTrue("Assert that URL path is updated on selecting the hub",
        getCurrentUrl().endsWith(expectedURLPath));
  }

  public void validateStationURLPath() {
    getWebDriver().navigate().refresh();
    waitUntilStationHomeUrlLoads(STATION_HOME_URL_PATH);
    Assert.assertTrue("Assert that URL path is updated with station management url",
        getCurrentUrl().endsWith(STATION_HOME_URL_PATH));
  }

  public void validateStationRecoveryURLPath(String trackingId) {
    waitUntilStationHomeUrlLoads(f(STATION_RECOVERY_TICKETS_URL_PATH, trackingId));
    Assert.assertTrue("Assert that Recovery Tickets URL is loaded with Tracking Id",
        getCurrentUrl().endsWith(f(STATION_RECOVERY_TICKETS_URL_PATH, trackingId)));
  }

  public void reloadURLWithNewHudId(String hubId) {
    String currentHubId = "";
    String currentUrl = getCurrentUrl();
    Pattern pattern = Pattern.compile("hubs.(\\d+)");
    Matcher matcher = pattern.matcher(currentUrl);
    if (matcher.find()) {
      currentHubId = matcher.group(1);
      Assert.assertTrue("Assert that the current hub id is extracted from the url ",
          currentHubId.length() > 0);
    }
    String newUrl = currentUrl.replace(currentHubId, hubId);
    getWebDriver().get(newUrl);
    pause3s();
  }

  public void waitUntilStationHomeUrlLoads(String partUrl) {
    Wait<WebDriver> fWait = new FluentWait<WebDriver>(getWebDriver())
        .withTimeout(Duration.ofSeconds(15))
        .pollingEvery(Duration.ofMillis(100))
        .ignoring(NoSuchElementException.class);
    fWait.until(driver -> driver.getCurrentUrl().endsWith(partUrl));
  }

  public void waitUntilTileValueMatches(String tileName, int expected) {
    WebDriverWait wdWait = new WebDriverWait(getWebDriver(), Duration.ofSeconds(90));
    wdWait.until(driver -> {
      LOGGER.info("Refreshing the page to reload the tile value...");
      driver.navigate().refresh();
      waitUntilPageLoaded();
      closeIfModalDisplay();
      int actual = getNumberFromTile(tileName);
      return actual == expected;
    });
  }

  public void waitUntilPendingPickupTileValueMatches(String tileName, int expected) {
    WebDriverWait wdWait = new WebDriverWait(getWebDriver(), Duration.ofSeconds(90));
    wdWait.until(driver -> {
      LOGGER.info("Refreshing the page to reload the tile value...");
      driver.navigate().refresh();
      waitUntilPageLoaded();
      closeIfModalDisplay();
      int actual = getNumberFromPendingPickupTile(tileName);
      return actual == expected;
    });
  }

  public void waitUntilTileValueLoads(String tileName) {
    WebDriverWait wdWait = new WebDriverWait(getWebDriver(), Duration.ofSeconds(90));
    String tileValueXpath = f(TILE_VALUE_XPATH, tileName, tileName);
    wdWait.until(driver -> {
      double actualCount = -1;
      LOGGER.info("Waiting for the tile value to load...");
      try {
        WebElement tile = getWebDriver().findElement(By.xpath(tileValueXpath));
        String titlevalue = tile.getText().replaceAll("\\$|\\,", "").trim();
        titlevalue = titlevalue.replaceAll("\\%|\\,", "").trim();
        actualCount = Double.parseDouble(titlevalue);
      } catch (NumberFormatException nfe) {
        nfe.printStackTrace();
        actualCount = -1;
      }
      return actualCount >= 0;
    });
  }

  public void waitUntilTileDollarValueMatches(String tileName, double expected) {
    WebDriverWait wdWait = new WebDriverWait(getWebDriver(), Duration.ofSeconds(90));
    wdWait.until(driver -> {
      LOGGER.info("Refreshing the page to reload the tile value...");
      driver.navigate().refresh();
      waitUntilPageLoaded();
      double actual = getDollarValueFromTile(tileName);
      return actual == expected;
    });
  }

  public void verifyHubNotFoundToast(String message) {
    if (pageFrame.size() > 0) {
      switchToStationHomeFrame();
    }
    waitUntilVisibilityOfElementLocated(hubs.getWebElement());
    waitUntilVisibilityOfToastReact(message);
  }

  public void validateHeaderHubValue(String expectedHub) {
    pause10s();
    if (pageFrame.size() > 0) {
      switchToStationHomeFrame();
    }
    waitUntilElementIsClickable(headerHubValue.getWebElement());
    String actualHub = headerHubValue.getText().trim();
    Assert.assertTrue("Assert that the actual hub selected is as expected",
        actualHub.contains(expectedHub));
  }

  public void validateTileValueMatches(int beforeOrder, int afterOrder, int delta) {
    Assert.assertTrue(
        f("Assert that current tile value: %s is increased/decreased by %s from %s", afterOrder,
            delta, beforeOrder),
        afterOrder == (beforeOrder + delta));
  }

  public void validateTileValueMatches(double beforeOrder, double afterOrder, double delta) {
    Assert.assertTrue(
        f("Assert that current tile value: %s is increased/decreased by %s from %s", afterOrder,
            delta, beforeOrder),
        afterOrder == (beforeOrder + delta));
  }

  public void verifyTableIsDisplayedInModal(String tableName) {
    String tableXpath = f(MODAL_TABLE_BY_TABLE_NAME_XPATH, tableName);
    List<WebElement> modalTables = getWebDriver().findElements(By.xpath(tableXpath));
    int isDisplayed = modalTables.size();
    Assert.assertTrue(f("Assert that the table by name : %s is displayed", tableName),
        isDisplayed > 0);
  }

  public void verifyColumnsInTableDisplayed(String tableName, List<String> expectedColumns) {
    List<String> actualColumns = new ArrayList<String>();
    String tableXpath = f(MODAL_TABLE_BY_TABLE_NAME_XPATH, tableName);
    String tableColumnsXpath = tableXpath.concat("//div[contains(@class,'th')]/*[1]");
    List<WebElement> tableColumns = getWebDriver().findElements(By.xpath(tableColumnsXpath));
    tableColumns.forEach((tableColumn) -> actualColumns.add(tableColumn.getText().trim()));
    Assert.assertTrue(f("Assert that the table: %s has all columns as expected", tableName),
        actualColumns.containsAll(expectedColumns));
  }

  public void verifyColumnsInTableDisplayed(List<String> expectedColumns) {
    List<String> actualColumns = new ArrayList<String>();
    modalTableColumns.forEach((tableColumn) -> {
      scrollIntoView(tableColumn.getWebElement());
      actualColumns.add(tableColumn.getText().trim());
    });

    Assert.assertTrue("Assert that the table: has all columns as expected",
        actualColumns.containsAll(expectedColumns));
  }

  public void applyFilters(Map<String, String> filters, int resultsCount) {
    waitWhilePageIsLoading();
    for (Map.Entry<String, String> filter : filters.entrySet()) {
      String filterXpath = f(MODAL_TABLE_SEARCH_XPATH, filter.getKey());
      scrollIntoView(filterXpath);
      List<WebElement> filterFields = getWebDriver().findElements(By.xpath(filterXpath));
      if (filterFields.size() > 0) {
        waitWhilePageIsLoading();
        filterFields.get(0).click();
        filterFields.get(0).sendKeys(filter.getValue());
        pause1s();
      }
    }
    waitWhilePageIsLoading();
    pause3s();
    Assert.assertTrue(
        f("Assert that the search should have %s records as expected after applying filters",
            resultsCount),
        results.size() == resultsCount);
  }

  public void applyFilters(String columnName, String filterName) {
    waitWhilePageIsLoading();
    String filterColumnXpath = f(MODAL_TABLE_FILTER_XPATH, columnName);
    String filterXpath = f(MODAL_TABLE_MULTIPLE_FILTER_XPATH, filterName);
    scrollIntoView(filterColumnXpath);
    List<WebElement> filterFields = getWebDriver().findElements(By.xpath(filterColumnXpath));
    if (filterFields.size() > 0) {
      waitWhilePageIsLoading();
      filterFields.get(0).click();
      pause2s();
      getWebDriver().findElement(By.xpath(filterXpath)).click();
      filterFields.get(0).click();
    }
    waitWhilePageIsLoading();
    Assert.assertTrue(
        f("Assert that the search should have %s column as expected to apply filter",
            columnName),
        filterFields.size() > 0);
  }

  public void selectFilterValue(Map<String, String> filters) {
    waitWhilePageIsLoading();
    for (Map.Entry<String, String> filter : filters.entrySet()) {
      String comboFilterXpath = f(MODAL_TABLE_COMBO_FILTER_XPATH, filter.getKey());
      scrollIntoView(comboFilterXpath);
      List<WebElement> filterFields = getWebDriver().findElements(By.xpath(comboFilterXpath));
      if (filterFields.size() > 0) {
        pause2s();
        filterFields.get(0).click();
        pause2s();
        new AntSelect2(getWebDriver(), filterFields.get(0)).selectValue(filter.getValue());
      }
    }
    waitWhilePageIsLoading();
    Assert.assertTrue(
        f("Assert that the search should have at-least one record as expected after applying filters"),
        results.size() > 0);
  }

  public void applyFilters(String tableName, Map<String, String> filters, int resultSize) {

    for (Map.Entry<String, String> filter : filters.entrySet()) {
      String filterXpath = f(MODAL_TABLE_FILTER_BY_TABLE_NAME_XPATH, tableName, filter.getKey());
      scrollIntoView(filterXpath);
      List<WebElement> filterFields = getWebDriver().findElements(By.xpath(filterXpath));
      if (filterFields.size() > 0) {
        filterFields.get(0).click();
        filterFields.get(0).sendKeys(filter.getValue());
      }
    }
    waitWhilePageIsLoading();
    pause3s();
    String tableXpath = f(MODAL_TABLE_BY_TABLE_NAME_XPATH, tableName);
    String tableRowsXpath = tableXpath.concat("//div[contains(@class,'base-row')]");
    List<WebElement> tableRows = getWebDriver().findElements(By.xpath(tableRowsXpath));
    Assert.assertTrue("Assert that the search has results as expected after applying filters",
        tableRows.size() == resultSize);
  }

  public void verifyNavigationToEditOrderScreen(String expectedTrackingId, String expectedURL) {
    String windowHandle = getWebDriver().getWindowHandle();
    String trackingIdXpath = f(TABLE_TRACKING_ID_XPATH, expectedTrackingId, expectedTrackingId);
    WebElement trackingIdLink = getWebDriver().findElement(By.xpath(trackingIdXpath));
    trackingIdLink.click();
    switchToNewWindow();
    waitWhilePageIsLoading();
    pause3s();
    switchToStationHomeFrame();
    Assertions.assertThat(
            getWebDriver().findElements(By.xpath(f(EDIT_ORDER_TRACKING_ID_XPATH, expectedTrackingId))))
        .as("Assertion for Navigation on clicking Tracking ID").isNotEmpty();
    verifyCurrentPageURL(expectedURL);
    closeAllWindows(windowHandle);
  }

  public void verifyCurrentPageURL(String expectedURL) {
    waitWhilePageIsLoading();
    pause5s();
    String currentURL = getWebDriver().getCurrentUrl().trim();
    Assertions.assertThat(getWebDriver().getCurrentUrl().endsWith("/" + expectedURL)).
        as("Assertion for the URL ends with " + expectedURL).isTrue();

  }

  public void verifyEditOrderScreenURL(String expectedTrackingId, String orderId) {
    String expectedEditOrderUrl = f(STATION_EDIT_ORDER_URL_PATH, orderId);
    getWebDriver().switchTo().defaultContent();
    String windowHandle = getWebDriver().getWindowHandle();
    if (pageFrame.size() > 0) {
      switchToStationHomeFrame();
    }
    WebElement trackingIdLink = getWebDriver().findElement(By.linkText(expectedTrackingId));
    trackingIdLink.click();
    switchToNewWindow();
    waitWhilePageIsLoading();
    String actualEditOrderUrl = getCurrentUrl().trim();
    closeAllWindows(windowHandle);
    pause3s();
    Assert.assertTrue("Assert that the edit order screen contains order id in the url",
        actualEditOrderUrl.endsWith(expectedEditOrderUrl));
  }

  public void verifyNavigationToRouteManifestScreen(String expectedRouteId) {
    waitWhilePageIsLoading();
    String windowHandle = getWebDriver().getWindowHandle();
    if (pageFrame.size() > 0) {
      switchToStationHomeFrame();
    }
    WebElement routeIdLink = getWebDriver().findElement(By.linkText(expectedRouteId));
    routeIdLink.click();
    switchToNewWindow();
    waitWhilePageIsLoading();
    pause5s();
    String actualRouteId = routeManifestRouteId.getText().trim();
    Assert.assertTrue("Assert that the search has results as expected after applying filters",
        actualRouteId.equalsIgnoreCase(expectedRouteId));
    closeAllWindows(windowHandle);
  }

  public void loadOperatorPortal() {
    getWebDriver().get(TestConstants.OPERATOR_PORTAL_BASE_URL);
  }

  public void verifyLinksDisplayedInLeftPanel(String headerName, List<String> expectedNavLinks) {
    List<String> actualNavLinks = new ArrayList<String>();
    String linksXpath = f(LEFT_NAVIGATION_LINKS_BY_HEADER, headerName, headerName);
    List<WebElement> navLinks = getWebDriver().findElements(By.xpath(linksXpath));
    navLinks.forEach((navLink) -> actualNavLinks.add(navLink.getText().trim()));
    Assert.assertTrue(
        f("Assert that the header: %s has all navigation links as expected", headerName),
        actualNavLinks.containsAll(expectedNavLinks));
  }

  public void verifyPageOpenedOnClickingHyperlink(String linkName, String expectedPageName) {
    WebElement navLink = getWebDriver().findElement(By.linkText(linkName));
    scrollIntoView(navLink);
    navLink.click();
    switchToNewWindow();
    waitWhilePageIsLoading();
    String actualPageName = pageHeader.getText().trim();
    Assert.assertTrue("Assert that the expected page has opened in new tab from navigation links",
        actualPageName.contains(expectedPageName));
    closeAllWindowsExceptCurrentWindow();
    pause3s();
  }

  public void verifyURLOpenedOnClickingHyperlink(String linkName, String expectedURL) {
    WebElement navLink = getWebDriver().findElement(By.linkText(linkName));
    scrollIntoView(navLink);
    navLink.click();
    switchToNewWindow();
    waitWhilePageIsLoading();
    pause10s();
    Assertions.assertThat(getWebDriver().getCurrentUrl()).
        as("Assert that the expected page has opened in new tab from navigation links").
        isEqualTo(expectedURL);
    closeAllWindowsExceptCurrentWindow();
  }

  @FindBy(css = "button[class*='btn-icon']")
  private PageElement arrowIcon;

  public void verifyRecoveryTicketsOnClickingArrowIcon() {
    waitUntilVisibilityOfElementLocated(arrowIcon.getWebElement());
    arrowIcon.click();
    switchToNewWindow();
    waitWhilePageIsLoading();
    String actualPageName = pageHeader.getText().trim();
    Assert.assertTrue("Assert that recovery tickets page has opened in new tab",
        actualPageName.contains(RECOVERY_TICKETS));
    closeAllWindowsExceptCurrentWindow();
    pause3s();
  }


  public void verifyPageUsingPageHeader(StationLanguage.HeaderText language) {
    waitWhilePageIsLoading();
    pause3s();
    getWebDriver().switchTo().defaultContent();
    waitUntilVisibilityOfElementLocated(pageHeader.getWebElement());
    String actualPageName = pageHeader.getText().trim();
    Assert.assertTrue(f("Assert that the expected page : %s has opened", language.getText()),
        actualPageName.contains(language.getText()));
  }


  public void verifyPagePollingTimeInfo(StationLanguage.PollingTimeText language) {
    if (pageFrame.size() > 0) {
      switchToStationHomeFrame();
    }
    waitUntilVisibilityOfElementLocated(pollingTimeInfo.getWebElement());
    String actualText = pollingTimeInfo.getText().trim();
    Assert.assertTrue(f("Assert that the expected text : %s is displayed", language.getText()),
        actualText.contains(language.getText()));
  }

  public void verifyLanguageModalTextLanguage(StationLanguage.ModalText lang) {
    waitWhilePageIsLoading();
    if (pageFrame.size() > 0) {
      switchToStationHomeFrame();
    }
    waitUntilVisibilityOfElementLocated(dialogLanguage.getWebElement());
    String modalText = dialogLanguage.getText().trim();
    Assert.assertTrue(f("Assert that the text displayed is %s", lang),
        modalText.equals(lang.getText()));
  }

  public Map<String, String> getColumnContentByTableName(String tableName, String columnName,
      String columnValue) {
    Map<String, String> tabContent = new HashMap<String, String>();
    String tableXpath = f(MODAL_TABLE_BY_TABLE_NAME_XPATH, tableName);
    String tableColumnNameXpath = f(tableXpath.concat(TABLE_CONTENT_BY_COLUMN_NAME), columnName);
    String tableColumnValueXpath = f(tableXpath.concat(TABLE_CONTENT_BY_COLUMN_NAME), columnValue);
    List<WebElement> tableColumnNames = getWebDriver().findElements(By.xpath(tableColumnNameXpath));
    List<WebElement> tableColumnValues = getWebDriver().findElements(
        By.xpath(tableColumnValueXpath));
    String rowName, rowValue;
    for (int row = 0; row < tableColumnNames.size(); row++) {
      rowName = tableColumnNames.get(row).getText();
      rowValue = tableColumnValues.get(row).getText();
      tabContent.put(rowName, rowValue);
    }
    return tabContent;
  }

  public Map<String, String> getResultGridContent() {
    Map<String, String> gridContent = new HashMap<String, String>();
    String columnName, columnValue;
    pause3s();
    for (int row = 0; row < columnNames.size(); row++) {
      scrollIntoView(columnNames.get(row).getWebElement());
      columnName = columnNames.get(row).getText();
      columnValue = columnValues.get(row).getText();
      gridContent.put(columnName, columnValue);
    }
    return gridContent;
  }

  public Map<String, String> getResultGridContentByTableName(String tableName) {
    Map<String, String> gridContent = new HashMap<String, String>();
    String columnName, columnValue;
    String tableXpath = f(MODAL_TABLE_BY_TABLE_NAME_XPATH, tableName);
    String tableColumnsXpath = tableXpath.concat(
        "//div[contains(@class,'VirtualTableHeader')]/*[1]");
    List<WebElement> tableColumns = getWebDriver().findElements(By.xpath(tableColumnsXpath));
    String tableColumnValuesXpath = tableXpath.concat(
        "//div[@class='BaseTable__row-cell']//div[starts-with(@class,'VirtualTable__')]");
    List<WebElement> tableValues = getWebDriver().findElements(By.xpath(tableColumnValuesXpath));
    pause3s();
    for (int row = 0; row < tableColumns.size(); row++) {
      scrollIntoView(tableColumns.get(row));
      columnName = tableColumns.get(row).getText();
      columnValue = tableValues.get(row).getText();
      gridContent.put(columnName, columnValue);
    }
    return gridContent;
  }

  public void openOrdersWithUnconfirmedTickets() {
    waitWhilePageIsLoading();
    fsrUnconfirmedETAArrow.click();
  }

  public void stationConfirmedEtaEmpty() {
    waitWhilePageIsLoading();
    Assert.assertTrue("Assert that ETA Calculated field is empty", confirmedEtas.size() == 0);
  }

  public void confirmSaveAndConfirmDisabled() {
    waitWhilePageIsLoading();
    Assert.assertTrue("Assert that Save and Continue button is disabled",
        disabledSaveAndProceed.size() > 0);
  }

  public void confirmCheckboxDisplayed() {
    waitWhilePageIsLoading();
    Assert.assertTrue("Assert that there is no checkbox for sfld parcels when eta has passed"
        , checkboxInRow.size() == 0);
  }

  public void verifyFsrInUrgentTasks(String expectedText) {
    waitWhilePageIsLoading();
    String actualText = fsrText.getText().trim();
    String actualCount = fsrCount.get(0).getText().trim();
    Assert.assertTrue(f("Assert that the text : %s is displayed", expectedText)
        , expectedText.contentEquals(actualText));
    int alarmCount = getSfldParcelCount();
    int actualBannerCount = Integer.parseInt(actualCount);
    Assert.assertTrue(
        f("Assert that no of fsr parcels's eta that needs to be confirmed matches ", expectedText)
        , alarmCount == actualBannerCount);
  }

  public void openModalByClickingArrow(String modalName, String arrowText) {
    waitWhilePageIsLoading();
    String titleXpath = f(MODAL_CONTENT_XPATH, modalName);
    WebElement arrow = getWebDriver().findElement(
        By.xpath(f(URGENT_TASKS_ARROW_BY_TEXT_XPATH, arrowText)));
    arrow.click();
    WebElement modalContent = getWebDriver().findElement(By.xpath(titleXpath));
    waitUntilVisibilityOfElementLocated(modalContent, 15);
    Assert.assertTrue(f("Assert that modal pop-up : %s is opened", modalName),
        modalContent.isDisplayed());
  }

  public void sortColumn(String columnName, String sortingOrder) {
    waitWhilePageIsLoading();
    String sortColumnXpath = f(MODAL_TABLE_FILTER_SORT_XPATH, columnName);
    scrollIntoView(sortColumnXpath);
    List<WebElement> sortFields = getWebDriver().findElements(By.xpath(sortColumnXpath));
    if (sortFields.size() == 0) {
      Assert.assertTrue(
          f("Assert that the column %s to be sorted is displayed on the screen", columnName),
          results.size() > 0);
    }
    sortFields.get(0).click();
    waitWhilePageIsLoading();
    if (sortingOrder.equalsIgnoreCase("DESCENDING_ORDER")) {
      sortFields.get(0).click();
      waitWhilePageIsLoading();
    }
  }

  public List<String> getColumnValuesByColumnName(String columnName) {
    int columnIndex = 0;
    List<String> colData = new ArrayList<String>();
    waitWhilePageIsLoading();
    String headerXpath = f(MODAL_TABLE_HEADER_XPATH);
    List<WebElement> headerFields = getWebDriver().findElements(By.xpath(headerXpath));
    if (headerFields.size() == 0) {
      Assert.assertTrue(
          f("Assert that the column %s to be sorted is displayed on the screen", columnName),
          results.size() > 0);
    }
    for (WebElement header : headerFields) {
      String headerName = header.getText().trim().toLowerCase();
      columnIndex++;
      if (headerName.contains(columnName.toLowerCase())) {
        break;
      }
    }

    List<WebElement> colElements = getWebDriver().findElements(
        By.cssSelector(f(TABLE_COLUMN_VALUES_BY_INDEX_CSS, columnIndex)));
    colElements.forEach(element -> {
      colData.add(element.getText().trim());
    });
    /*
    scrollIntoView(footerRow.getWebElement());
    pause5s();
    colElements = getWebDriver().findElements(
        By.cssSelector(f(TABLE_COLUMN_VALUES_BY_INDEX_CSS, columnIndex)));
    colElements.forEach(element -> {
      colData.add(element.getText().trim());
    });
    */
    return colData;
  }

  public void getRecordsAndValidateSorting(String columnName) {
    List<String> colData = getColumnValuesByColumnName(columnName);
    if ("Time in Hub".contentEquals(columnName)) {
      List<Double> columnValue = new ArrayList<Double>();
      colData.forEach(value -> {
        value = value.replaceAll(" day ", ".")
            .replaceAll(" days ", ".")
            .replaceAll(" hours ", "")
            .replaceAll(" hour ", "")
            .replaceAll(" minutes", "")
            .replaceAll(" minute", "");
        if (!value.contains(".")) {
          value = "0." + value;
        }
        columnValue.add(Double.parseDouble(value));
      });
      Assert.assertTrue(
          f("Assert that the column values %s are sorted as expected", columnName),
          Comparators.isInOrder(columnValue, Comparator.reverseOrder()));
      return;
    }
    if ("Last Scanned Time".contentEquals(columnName)) {
      List<Double> columnValue = new ArrayList<Double>();
      colData.forEach(value -> {
        value = value.replaceAll("-", "").replaceAll(" ", ".").replaceAll(":", "");
        columnValue.add(Double.parseDouble(value));
      });
      Assert.assertTrue(
          f("Assert that the column values %s are sorted as expected", columnName),
          Comparators.isInOrder(columnValue, Comparator.naturalOrder()));
      return;
    }
    if ("ETA Calculated".contentEquals(columnName)) {
      List<Double> columnValue = new ArrayList<Double>();
      colData.forEach(value -> {
        value = value.replaceAll("-", "");
        columnValue.add(Double.parseDouble(value));
      });
      Assert.assertTrue(
          f("Assert that the column values %s are sorted as expected", columnName),
          Comparators.isInOrder(columnValue, Comparator.naturalOrder()));
    }

  }


  public void selectSuggestedEtaAndProceed(String suggestedEta) {
    waitWhilePageIsLoading();
    suggestedEtas.selectValue(suggestedEta);
    saveAndProceed.click();
  }

  public void verifyToastMessage(String message) {
    waitUntilVisibilityOfElementLocated(toastMessage.getWebElement());
    String toastMsg = toastMessage.getText().trim();
    Assert.assertTrue(f("Assert that the toast message %s is displayed as expected! ", message),
        toastMsg.contentEquals(message));
  }

  public void selectMultipleRecordsToConfirmEta(int countToSelect) {
    scrollIntoView(footerRow.getWebElement());
    pause3s();
    int iterator = countToSelect;
    int index = modalCheckboxes.size()-countToSelect;
    while(iterator > 0){
      pause2s();
      modalCheckboxes.get(index).click();
      index++;
      iterator--;
    }
    Assertions.assertThat(countToSelect)
        .as("Assert that the number of records selected is equal to the expected!")
        .isEqualTo(checkboxChecked.size());
  }

  public void verifySfldAlertMessage(String expectedMsg){
    sfldAlert.waitUntilVisible();
    String actualMsg = sfldAlert.getText();
    Assertions.assertThat(expectedMsg)
        .as("Assert that the number of records selected is equal to the expected!")
        .isEqualTo(actualMsg);
  }

  public void selectCommonSuggestedEtaAndProceed(String suggestedEta) {
    waitWhilePageIsLoading();
    commonSuggestedEtas.selectValue(suggestedEta);
    saveAndProceed.click();
  }


  public void downloadFailedEtas() {
    waitWhilePageIsLoading();
    pause2s();
    downloadFailedEtas.click();
  }

  public void applyQuickFilter(String filter) {
    waitWhileStationPageLoads();
    String filterXpath = f(QUICK_FILTER_BY_TEXT_XPATH, filter);
    WebElement quickFilter = getWebDriver().findElement(
        By.xpath(filterXpath));
    if(filterApplied.size() > 0){
      filterApplied.get(0).click();
      pause2s();
    }
    quickFilter.click();
    pause2s();
    Assert.assertTrue(f("Assert that the filter %s is applied", filter),
        filterApplied.size() > 0);
    waitWhileStationPageLoads();
  }

  public void selectCheckboxByTrackingId(List<String> trackingIds) {
    waitWhilePageIsLoading();
    scrollIntoView(footerRow.getWebElement());
    for(String trackingId : trackingIds){
      String checkboxByTrackingId = f(RECORD_CHECK_BOX_BY_TRACKING_ID_XPATH, trackingId);
      scrollIntoView(checkboxByTrackingId);
      pause2s();
      WebElement checkbox = getWebDriver().findElement(
          By.xpath(checkboxByTrackingId));
      checkbox.click();
    }
    Assert.assertTrue(f("Assert that the checkbox is selected for all given tracking id"),
        trackingIds.size() > 0 );
  }

  public void verifyStationConfirmedEtaDisabled() {
    waitWhilePageIsLoading();
    Assert.assertTrue(f("Assert that the station confirmed eta is disabled"),
        commonSuggestedEtas.isEnabled());
  }


  public void mouseOverToTileTitle(String title) {
    waitWhilePageIsLoading();
    if (pageFrame.size() > 0) {
      switchToStationHomeFrame();
    }
    String titleXpath = f(TILE_TITLE_XPATH, title, title);
    WebElement tileTitle = getWebDriver().findElement(
        By.xpath(titleXpath));
    pause1s();
    moveToElement(tileTitle);
    pause5s();
    Assert.assertTrue(f("Assert that the title %s is displayed", title),
        mouseOverText.size() > 0);
  }

  public void verifyMouseOverText(List<String> expectedTexts){
    List<String> actualTexts = new ArrayList<String>();
    if(mouseOverTextList.size() == 0){
      Assertions.assertThat(mouseOverText.get(0).getText().trim()).isEqualTo(expectedTexts.get(0));
      return;
    }
    mouseOverTextList.forEach((element) -> {
      actualTexts.add(element.getText().trim());
    });
    Assertions.assertThat(expectedTexts).isEqualTo(actualTexts);
  }

  public void mouseOverToManualButton() {
    waitWhilePageIsLoading();
    moveToElement(manualButton.getWebElement());
    pause2s();
    Assert.assertTrue("Assert that the title is not displayed",
        mouseOverText.size() == 0);
  }

  public void verifyChartIsShown() {
    waitWhilePageIsLoading();
    Assertions.assertThat(chart.size()).
        as("Assert that the chart is displayed on Parcels in incoming shipment").isGreaterThan(0);
  }

  public void verifyChartIsNotShown() {
    waitWhilePageIsLoading();
    Assertions.assertThat(chart.size()).
        as("Assert that the chart is displayed on Parcels in incoming shipment").isEqualTo(0);
  }

  public void verifyNoResultsFoundByTableName(String table) {
    waitWhilePageIsLoading();
    String noResultsXpath = f(NO_RESULTS_FOUND_TEXT_XPATH, table);
    List<WebElement> noResults = getWebDriver().findElements(
        By.xpath(noResultsXpath));
    Assertions.assertThat(noResults.size()).
        as(f("Assert that the no results found text is displayed in %s", table)).isGreaterThan(0);
  }

}
