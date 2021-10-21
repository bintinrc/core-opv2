package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvCountry;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.ant.AntIntervalCalendarPicker;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect2;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.FindAll;
import java.util.List;
import org.openqa.selenium.support.ui.WebDriverWait;

/**
 * @author Veera
 */
public class StationCODReportPage extends OperatorV2SimplePage {

  public StationCODReportPage(WebDriver webDriver) {
    super(webDriver);
  }

  private static final String STATION_COD_REPORT_BUTTON_XPATH = "//button[@disabled]//*[text()='%s']";
  private static final String STATION_COD_REPORT_LABELS_XPATH = "//div[@class='nv-filter-container']//div[@class='ant-col']//div[contains(text(),'%s')]";
  private static final String STATION_COD_REPORT_COMBOBOX_XPATH = "//div[text()='%s']//ancestor::div[@class='ant-row-flex']//div[@role='combobox']";
  private static final String STATION_COD_COLUMN_NAME_XPATH = "//div[contains(@class,'th')]/*[1]";
  private static final String STATION_COD_COLUMN_VALUE_XPATH = "//div[@class='cell-wrapper']";
  private static final String STATION_COD_TABLE_FILTER_BY_COLUMN_NAME_XPATH = "//div[contains(@class,'th')][.//*[.='%s']]//input";
  private static final String STATION_COD_SUMMARY_ROW_BY_ROUTE_ID_XPATH = "//div[@role='row'][.//a[.='%s']]";


  @FindAll(@FindBy(xpath = "//iframe"))
  private List<PageElement> pageFrame;

  @FindAll(@FindBy(xpath = "//div[@class='nv-filter-container']//div[@class='ant-col']//div[contains(text(),'%s')]"))
  private List<PageElement> fieldNames;

  @FindBy(xpath = "//div[contains(@class,'row-cell-text')]")
  public PageElement filterDropdownValue;

  @FindBy(xpath = "//button[@*='load-button']")
  public AntButton loadSelection;

  @FindBy(xpath = "//div[@role='table']//div[contains(@class,'base-row')]")
  private List<PageElement> results;

  @FindBy(xpath = "//div[@class='nv-filter-container'][.//span[@*='ant-calendar-picker']]")
  public AntIntervalCalendarPicker transactionEndDateFilter;

  @FindBy(xpath = "//button[@*='details-button']")
  public PageElement detailsTab;

  @FindBy(xpath = "//button[@*='summary-button']")
  public PageElement summaryTab;


  private void switchToStationCODReportFrame() {
    getWebDriver().switchTo().frame(pageFrame.get(0).getWebElement());
  }

  public void verifyFieldInCODReport(String expectedField) {
    if (pageFrame.size() > 0) {
      switchToStationCODReportFrame();
    }
    WebDriverWait wdWait = new WebDriverWait(getWebDriver(), 30);
    String fieldLabelXpath = f(STATION_COD_REPORT_LABELS_XPATH, expectedField);
    wdWait.until((driver) -> {
      List<WebElement> labels = driver.findElements(By.xpath(fieldLabelXpath));
      boolean isDisplayed = labels.size() > 0 ? true : false;
      return isDisplayed;
    });
  }

  public void verifyButtonDisplayedInDisabledState(String buttonName) {
    String buttonXpath = f(STATION_COD_REPORT_BUTTON_XPATH, buttonName);
    List<WebElement> buttons = getWebDriver().findElements(By.xpath(buttonXpath));
    int isDisplayed = buttons.size();
    Assert.assertTrue(
        f("Assert that the button : %s is displayed, and is in disabled state", buttonName),
        isDisplayed > 0);
  }

  public void applyFilters(Map<String, String> filters) {

    for (Map.Entry<String, String> filter : filters.entrySet()) {
      String filterXpath = f(STATION_COD_REPORT_COMBOBOX_XPATH, filter.getKey());
      List<WebElement> filterFields = getWebDriver().findElements(By.xpath(filterXpath));
      if (filterFields.size() > 0) {
        AntSelect2 dropdown = new AntSelect2(getWebDriver(), filterFields.get(0));
        dropdown.enterSearchTerm(filter.getValue());
        filterDropdownValue.click();
      }
    }
    loadSelection.click();
    waitWhilePageIsLoading();
    Assert.assertTrue("Assert that the search has results as expected after applying filters",
        results.size() > 0);
  }

  public void applyFiltersInResultGrid(Map<String, String> filters) {

    for (Map.Entry<String, String> filter : filters.entrySet()) {
      String filterXpath = f(STATION_COD_TABLE_FILTER_BY_COLUMN_NAME_XPATH, filter.getKey());
      scrollIntoView(filterXpath);
      List<WebElement> filterFields = getWebDriver().findElements(By.xpath(filterXpath));
      if (filterFields.size() > 0) {
        filterFields.get(0).click();
        filterFields.get(0).sendKeys(filter.getValue());
      }
    }
    waitWhilePageIsLoading();
    Assert.assertTrue("Assert that the search has results as expected after applying filters",
        results.size() > 0);

  }

  public void verifyDetailsAndSummaryTabsDisplayed() {
    waitUntilVisibilityOfElementLocated(detailsTab.getWebElement());
    assertTrue("Assert that Details tab is displayed!", detailsTab.isDisplayed());
    assertTrue("Assert that Summary tab is displayed!", summaryTab.isDisplayed());
  }

  public void verifyColumnsInTableDisplayed(String tabName, List<String> expectedColumns) {
    List<String> actualColumns = new ArrayList<String>();
    List<WebElement> tableColumns = getWebDriver().findElements(
        By.xpath(STATION_COD_COLUMN_NAME_XPATH));
    tableColumns.forEach((tableColumn) -> {
      scrollIntoView(tableColumn);
      actualColumns.add(tableColumn.getText().trim());
    });
    Assert.assertTrue(f("Assert that the tab: %s has all columns as expected", tabName),
        actualColumns.containsAll(expectedColumns));
  }

  public void navigateToSummaryTab() {
    waitUntilVisibilityOfElementLocated(summaryTab.getWebElement());
    summaryTab.click();
    pause3s();
    boolean isActive = summaryTab.getAttribute("class").contains("active");
    assertTrue("Assert that Summary tab is highlighted!", isActive);
  }

  public void setTransactionEndDateFilter(String fromDate, String toDate) {
    if (pageFrame.size() > 0) {
      switchToStationCODReportFrame();
    }
    if (StringUtils.isNotBlank(fromDate) && StringUtils
        .isNotBlank(toDate)) {
      transactionEndDateFilter
          .setInterval(fromDate, toDate);
    } else if (StringUtils.isNotBlank(fromDate)) {
      transactionEndDateFilter.setFrom(fromDate);
    } else if (StringUtils.isNotBlank(toDate)) {
      transactionEndDateFilter.setTo(toDate);
    }
  }

  @FindAll(@FindBy(xpath = "//div[contains(@class,'th')]/*[1]"))
  private List<PageElement> columnNames;

  @FindAll(@FindBy(css = "div[class='cell-wrapper']"))
  private List<PageElement> columnValues;

  public Map<String, String> getResultGridContent() {
    Map<String,String> gridContent = new HashMap<String, String>();
    String columnName, columnValue;
    waitUntilVisibilityOfElementLocated(STATION_COD_COLUMN_NAME_XPATH);
    for(int row = 0; row < columnNames.size(); row++){
      scrollIntoView(columnNames.get(row).getWebElement());
      columnName = columnNames.get(row).getText();
      columnValue = columnValues.get(row).getText();
      gridContent.put(columnName, columnValue);
    }
    return gridContent;
  }


  @FindBy(css = "div[class*='footer-row']")
  private PageElement footerRow;

  public Map<String, String> getSummaryRowByRouteId(String routeId) {
    Map<String,String> gridContent = new HashMap<String, String>();
    String columnName, columnValue;
    String summaryRowXpath = f(STATION_COD_SUMMARY_ROW_BY_ROUTE_ID_XPATH, routeId).concat(STATION_COD_COLUMN_VALUE_XPATH);
    scrollIntoView(footerRow.getWebElement());
    List<WebElement> columnValues = getWebDriver().findElements(By.xpath(summaryRowXpath));
    for(int column = 1; column < columnNames.size(); column++){
      columnName = columnNames.get(column).getText();
      columnValue = columnValues.get(column).getText();
      gridContent.put(columnName, columnValue);
    }
    return gridContent;
  }

  public void verifyResultGridContent(Map<String,String> expectedResults, Map<String, String> actualResults){
    expectedResults.forEach((key, value)->{
      if(actualResults.containsKey(key)){
        boolean isValMatched = actualResults.get(key).contentEquals(value);
        Assert.assertTrue(f("Assert that column value matched for the column : %s", key), isValMatched);
      }else{
        Assert.assertTrue(f("Assert that the expected column: %s is not in the actual results", key), false);
      }
    });
  }

  @FindBy(xpath = "//div[text()='Sum of Total']//following-sibling::div")
  private PageElement totalCashCollected;

  public void verifySeparatorsInCashCollected(NvCountry countryCd){
    waitUntilVisibilityOfElementLocated(totalCashCollected.getWebElement());
    String actualTotal = totalCashCollected.getText().trim();
    String expectedTotal = actualTotal;
    Assert.assertTrue(f("Assert that the sum of total: %s is displayed", actualTotal), actualTotal.length() > 0);
    if(countryCd.equals(NvCountry.SG)){
      expectedTotal = expectedTotal.replaceAll(",","");
    }
    if(countryCd.equals(NvCountry.ID)){
      expectedTotal = expectedTotal.replaceAll("\\.", "").replaceAll(",",".");
    }
     expectedTotal = formatCODAmountByCountry(countryCd, expectedTotal);
    Assert.assertTrue("Assert that the cash collected has separators, comma and dot", expectedTotal.contentEquals(actualTotal));
  }

  @FindBy(css = "div.cod-summary div.ant-col:nth-child(1)")
  private List<PageElement> summaryColumns;

  public void verifyColumnsInCashCollectedSummary(List<String> expectedColumns) {
    List<String> actualColumns = new ArrayList<String>();
    summaryColumns.forEach((tableColumn) -> actualColumns.add(tableColumn.getText().trim()));
    Assert.assertTrue(f("Assert that Cash collected summary table has all columns as expected"),
        actualColumns.containsAll(expectedColumns));
  }

  public String formatCODAmountByCountry(NvCountry countryCd, String codAmount){
    codAmount = String.valueOf(f("%,f", Float.parseFloat(codAmount)));
    codAmount = codAmount.contains(".") ? codAmount.replaceAll("0*$", "")
        .replaceAll("\\.$", "") : codAmount;
    if(countryCd.equals(NvCountry.ID)){
      codAmount = codAmount.replaceAll(",", "~").replaceAll("\\.",",").replaceAll("~",".");
    }
    return codAmount;
  }

}