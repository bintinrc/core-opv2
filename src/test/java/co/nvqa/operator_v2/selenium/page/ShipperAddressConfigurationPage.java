package co.nvqa.operator_v2.selenium.page;


import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntDateRangePicker;
import co.nvqa.operator_v2.selenium.elements.ant.v4.AntSelect;
import java.util.Date;
import java.util.List;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindAll;
import org.openqa.selenium.support.FindBy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ShipperAddressConfigurationPage extends OperatorV2SimplePage {

  private static final String MODAL_TABLE_SEARCH_BY_TABLE_NAME_XPATH = "//div[text()='%s']/ancestor::div[starts-with(@class,'VirtualTableHeader')]//input";
  private static final String TABLE_FIRST_ROW_VALUE_BY_COLUMN = "//div[@class='BaseTable__row-cell' and @data-datakey='%s']//*[name()='span'or 'div']";
  public static final String CSV_DOWNLOADED_FILENAME_PATTERN = "Downloaded Pickup Addresses";
  public static final String COLUMN_NAME = "Suggested Address URL";


  private static final Logger LOGGER = LoggerFactory.getLogger(
      ShipperAddressConfigurationPage.class);

  public ShipperAddressConfigurationPage(WebDriver webDriver) {
    super(webDriver);
  }

  @FindBy(css = "iframe")
  private List<PageElement> pageFrame;


  @FindBy(css = "div.ant-picker-range")
  public AntDateRangePicker addressCreationDate;

  @FindBy(xpath = "//span[text()='Clear Selection']")
  public PageElement clearSelection;

  @FindBy(xpath = "//span[text()='Load Selection']")
  public PageElement loadSelection;

  @FindBy(xpath = "//span[text()='Address Status']/parent::div//div[@class='ant-select-selector']")
  public AntSelect addressStatusSelect;

  @FindBy(xpath = "//div[@class='BaseTable__row-cell' and @data-datakey='lat_long']//*[local-name()='svg' and contains (@class,'GaComponent__StyledAxleIconComponent')]")
  public PageElement greencheckMark;

  @FindAll(@FindBy(xpath = "//div[@class='BaseTable__row-cell' and @data-datakey='lat_long']//*[local-name()='svg' and contains (@class,'GaComponent__StyledAxleIconComponent')]"))
  private List<PageElement> greencheckMarks;

  @FindBy(xpath = "//button[@data-pa-action='Download Addresses']")
  public PageElement downloadAddressButton;


  public void switchToShipperAddressConfigurationFrame() {
    if (pageFrame.size() > 0) {
      waitUntilVisibilityOfElementLocated(pageFrame.get(0).getWebElement(), 15);
      getWebDriver().switchTo().frame(pageFrame.get(0).getWebElement());
    }
  }

  // This method can be removed once redirection to Shipper Address is added in operator V2 menu
  public void loadShipperAddressConfigurationPage() {
    getWebDriver().get("https://operatorv2-qa.ninjavan.co/#/sg/shipper-address");
  }


  public void clickLoadSelection() {
    waitUntilVisibilityOfElementLocated(loadSelection.getWebElement());
    loadSelection.click();
  }

  public void clickClearSelection() {
    waitUntilVisibilityOfElementLocated(clearSelection.getWebElement());
    clearSelection.click();
  }

  public void selectDateRange(String fromDate, String toDate) {
    switchToShipperAddressConfigurationFrame();
    waitUntilVisibilityOfElementLocated(addressCreationDate.getWebElement());
    addressCreationDate.clearAndSetFromDate(fromDate);
    addressCreationDate.clearAndSetToDate(toDate);
  }

  public void selectAddressStatus(String addressStatus) {
    switchToShipperAddressConfigurationFrame();
    waitUntilVisibilityOfElementLocated(addressStatusSelect.getWebElement());
    addressStatusSelect.selectValue(addressStatus);

  }

  public void filterBy(String filterCriteria, String filterValue) {
    switchToShipperAddressConfigurationFrame();
    filterValue(filterCriteria, filterValue);
  }

  public void filterValue(String filterName, String filterValue) {

    String stationNameSearchXpath = f(MODAL_TABLE_SEARCH_BY_TABLE_NAME_XPATH, filterName);
    WebElement searchBox = getWebDriver().findElement(By.xpath(stationNameSearchXpath));
    waitUntilVisibilityOfElementLocated(searchBox);
    searchBox.sendKeys(Keys.chord(Keys.CONTROL, "a", Keys.DELETE));
    searchBox.sendKeys(filterValue);
  }

  public void validateFilter(String columnName, String expectedValue) {
    String valueXpath = f(TABLE_FIRST_ROW_VALUE_BY_COLUMN, columnName);
    pause5s();
    String actualValue = getWebDriver().findElement(By.xpath(valueXpath)).getText();
    Assertions.assertThat(actualValue).as("Validation of Column Value")
        .isEqualToIgnoringCase(expectedValue);
  }

  public void validateGreenCheckMark() {
    waitUntilVisibilityOfElementLocated(greencheckMark.getWebElement());
    Assertions.assertThat(greencheckMark.isDisplayed()).isTrue();
  }

  public void validateGreenCheckMarkNotDisplayed() {
    Assertions.assertThat(greencheckMarks.size()).isZero();
  }

  public void clickDownloadAddress() {
    pause2s();
    waitUntilVisibilityOfElementLocated(downloadAddressButton.getWebElement());
    downloadAddressButton.click();
  }

}
