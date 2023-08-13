package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntDateRangePicker;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class GroupAddressesPage extends SimpleReactPage<GroupAddressesPage>{

  @FindBy(tagName = "iframe")
  private PageElement pageFrame;
  @FindBy(css = "div.ant-picker-range")
  public AntDateRangePicker addressCreationDate;
  private static final String MODAL_TABLE_SEARCH_BY_TABLE_NAME_XPATH = "//div[text()='%s']/ancestor::div[starts-with(@class,'TableHeader')]//input";
  private static final String MODAL_TABLE_SEARCH_BY_TABLE_CHECKBOX = "//div[text()='%s']/ancestor::div[starts-with(@class,'TableHeader')]//span[@role='button']";
  public static final String CHECKBOX_FOR_ADDRESS_TO_BE_GROUPED = "//input[@data-testid='group-address-table-checkbox-%s']";
  public static final String GROUP_ADDRESS_VERIFY_MODAL = "//span[contains(text(), '%s')]";
  public static final String CURRENT_GROUP_ADDRESS_VERIFY_MODAL = "//i[contains(text(), '%s')]";
  public static final String RADIO_CHECKBOX_FOR_ADDRESS_TO_BE_GROUPED = "//input[@data-testid='radio-option-%s']";
  public static final String GROUP_ADDRESS_VERIFY_COLUMN = "//div[@data-testid='virtual-table.%s.formatted_group_address.cell']";

  public static final String WARNING_MESSAGE = "//span[text()='%s']";
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
  @FindBy(xpath = "//div[@class='ant-message-custom-content ant-message-success']")
  public PageElement successMessage;

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

  public void selectDateRangeForAddressCreation(String fromDate, String toDate) {
    waitUntilVisibilityOfElementLocated(addressCreationDate.getWebElement());
    addressCreationDate.clearAndSetFromDate(fromDate);
    addressCreationDate.clearAndSetToDate(toDate);
  }

  public void filterBy(String filterCriteria, String filterValue) {
    filterValue(filterCriteria, filterValue);
  }

  public void filterValue(String filterName, String filterValue) {
    String stationNameSearchXpath = f(MODAL_TABLE_SEARCH_BY_TABLE_NAME_XPATH, filterName);
    String checkBoxXpath = f(MODAL_TABLE_SEARCH_BY_TABLE_CHECKBOX , filterName);
    WebElement searchBox = getWebDriver().findElement(By.xpath(stationNameSearchXpath));
    WebElement checkBox = getWebDriver().findElement(By.xpath(checkBoxXpath));
    waitUntilVisibilityOfElementLocated(searchBox);
    if(checkBox.isDisplayed()) {
      checkBox.click();
    }
    searchBox.sendKeys(Keys.chord(Keys.CONTROL, "a", Keys.DELETE));
    searchBox.sendKeys(filterValue);
  }

  public void clickOnAddressToGroup(String addressId) {
    String checkBoxXpath = f(CHECKBOX_FOR_ADDRESS_TO_BE_GROUPED, addressId);
    WebElement checkBox = getWebDriver().findElement(By.xpath(checkBoxXpath));
    checkBox.click();
  }

  public void verifyCurrentGroupAddressModal(String address1) {
    String title1Xpath = f(CURRENT_GROUP_ADDRESS_VERIFY_MODAL, address1);
    WebElement title = getWebDriver().findElement(By.xpath(title1Xpath));
    Assertions.assertThat(title.getText().equals(title));
  }

  public void verifyGroupAddressModal(String title1, String title2, String pickup_Address, String address1) {
    String title1Xpath = f(GROUP_ADDRESS_VERIFY_MODAL, title1);
    String title2Xpath = f(GROUP_ADDRESS_VERIFY_MODAL, title1);
    String pick_AddressXpath = f(GROUP_ADDRESS_VERIFY_MODAL, title1);
    String address1Xpath = f(GROUP_ADDRESS_VERIFY_MODAL, title1);

    WebElement title = getWebDriver().findElement(By.xpath(title1Xpath));
    WebElement second_Title = getWebDriver().findElement(By.xpath(title2Xpath));
    WebElement pickUp_Address = getWebDriver().findElement(By.xpath(pick_AddressXpath));
    WebElement first_Address = getWebDriver().findElement(By.xpath(address1Xpath));

    Assertions.assertThat(title.getText().equals(title1));
    Assertions.assertThat(second_Title.getText().equals(title2));
    Assertions.assertThat(pickUp_Address.getText().equals(pickup_Address));
    Assertions.assertThat(first_Address.getText().equals(address1));
  }

  public void clickOnRadioCheckBoxForAddressToGroup(String addressId) {
    String checkBoxXpath = f(RADIO_CHECKBOX_FOR_ADDRESS_TO_BE_GROUPED, addressId);
    WebElement checkBox = getWebDriver().findElement(By.xpath(checkBoxXpath));
    checkBox.click();
  }

  public void verifySuccessMessage() {
    Assertions.assertThat(successMessage.isDisplayed());
  }

  public void verifyGroupAddressIsShown(String addressID, String textMessage) {
    String title1Xpath = f(GROUP_ADDRESS_VERIFY_COLUMN, addressID);
    WebElement title = getWebDriver().findElement(By.xpath(title1Xpath));
    Assertions.assertThat(title.getText().equals(textMessage));
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

  public void verifyMessage(String message) {
    String messageText = f(WARNING_MESSAGE, message);
    WebElement textElement = getWebDriver().findElement(By.xpath(messageText));
    Assertions.assertThat(textElement.getText().equals(message));
  }

}
