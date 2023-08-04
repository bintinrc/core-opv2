package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class GroupAddressesPage extends SimpleReactPage<GroupAddressesPage>{

  @FindBy(tagName = "iframe")
  private PageElement pageFrame;
  @FindBy(xpath = "//*[@data-testid='address-search-input']")
  private PageElement inputAddressSearch;
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
    waitUntilVisibilityOfElementLocated(inputAddressSearch.getWebElement());
    inputAddressSearch.sendKeys(address);
    inputAddressSearch.sendKeys(Keys.RETURN);
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
