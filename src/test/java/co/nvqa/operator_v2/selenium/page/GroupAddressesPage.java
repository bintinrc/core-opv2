package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntDateRangePicker;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class GroupAddressesPage extends SimpleReactPage<GroupAddressesPage>{

  @FindBy(tagName = "iframe")
  private PageElement pageFrame;
  @FindBy(css = "div.ant-picker-range")
  public AntDateRangePicker addressCreationDate;
  @FindBy(xpath = "//div[@data-testid='shipper-address.filter-addresses.latest-pickup-date']//input[@placeholder='Start date']")
  private PageElement inputPickupStartDate;
  @FindBy(xpath = "//div[@data-testid='shipper-address.filter-addresses.latest-pickup-date']//input[@placeholder='End date']")
  private PageElement inputPickupEndDate;
  @FindBy(xpath = "//*[@data-testid='address-search-input']")
  private PageElement inputAddressSearch;
  @FindBy(xpath = "//div[@data-testid='shipper-address.filter-addresses.zone']//input")
  private PageElement inputZone;
  @FindBy(xpath = "//*[contains(@data-testid, 'shipper_name.cell')]/span")
  private PageElement cellShipperName;
  @FindBy(xpath = "//*[contains(@data-testid, 'shipper_id.cell')]/span")
  private PageElement cellShipperId;
  @FindBy(xpath = "//*[contains(@data-testid, 'latest_pickup_date.cell')]/span")
  private PageElement cellLatestPickupDate;
  @FindBy(xpath = "//*[contains(@data-testid, '.address.cell')]/span")
  private PageElement cellPickupAddress;
  @FindBy(xpath = "//*[contains(@data-testid, 'group_address.cell')]/span")
  private PageElement cellGroupAddress;
  @FindBy(xpath = "//button[@data-testid='shipper-address.group-addresses.load-selection']")
  private PageElement btnLoadSelection;
  @FindBy(xpath = "//div[@data-testid='shipper-address.filter-addresses.grouping']//span[@role='img']")
  private PageElement inputGrouping;
  @FindBy(xpath = "//div[@data-testid='shipper-address.filter-addresses.grouping']//*[text()='Grouped']")
  private PageElement selectGrouped;
  @FindBy(xpath = "//div[@data-testid='shipper-address.filter-addresses.grouping']//*[text()='Not Grouped']")
  private PageElement selectNotGrouped;
  @FindBy(xpath ="//div[@data-testid='shipper-address.filter-addresses.grouping']//*[text()='All']")
  private PageElement selectAll;

  public GroupAddressesPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchTo() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void loadGroupAddressesPage() {
    getWebDriver().get("https://operatorv2-qa.ninjavan.co/#/sg/shipper-address/group-addresses");
  }

  public void searchAddress(String address) {
    waitUntilVisibilityOfElementLocated(inputAddressSearch.getWebElement(), 5);
    inputAddressSearch.sendKeys(address);
    inputAddressSearch.sendKeys(Keys.RETURN);
  }

  public void searchZone(String zone) {
    waitUntilVisibilityOfElementLocated(inputZone.getWebElement(), 5);
    inputZone.click();
    inputZone.sendKeys(zone);
    inputZone.sendKeys(Keys.RETURN);
  }

  public void clickLoadSelection() {
    waitUntilVisibilityOfElementLocated(btnLoadSelection.getWebElement(), 3);
    btnLoadSelection.click();
  }

  public void selectGrouping(String group) {
    waitUntilVisibilityOfElementLocated(inputGrouping.getWebElement(), 5);
    inputGrouping.click();
    if (group.equalsIgnoreCase("grouped")){
      selectGrouped.click();
    } else if (group.equalsIgnoreCase("not grouped"))
      selectGrouped.click();
    else
      selectAll.click();
  }

  public void selectDateRange(String fromDate, String toDate) {
    waitUntilVisibilityOfElementLocated(inputPickupStartDate.getWebElement());
    inputPickupStartDate.click();
    inputPickupStartDate.sendKeys(fromDate);
    inputPickupStartDate.sendKeys(Keys.ENTER);
    pause3s();
    inputPickupEndDate.click();
    inputPickupEndDate.sendKeys(toDate);
    inputPickupEndDate.sendKeys(Keys.ENTER);
  }

  public boolean isCellShipperNameDisplayed(){
    return cellShipperName.isDisplayed();
  }

  public boolean isCellShipperIdDisplayed() {
    return cellShipperId.isDisplayed();
  }

  public boolean isCellLatestPickupDateDisplayed() {
    return cellLatestPickupDate.isDisplayed();
  }

  public boolean isCellGroupAddressDisplayed() {
    return cellGroupAddress.isDisplayed();
  }

  public boolean isCellPickupAddressDisplayed() {
    return cellPickupAddress.isDisplayed();
  }

  public String getTextCellPickupAddress() {
    return cellPickupAddress.getText();
  }
}
