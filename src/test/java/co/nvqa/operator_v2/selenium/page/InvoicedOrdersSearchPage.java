package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class InvoicedOrdersSearchPage extends OperatorV2SimplePage {


  @FindBy(xpath = "//label[@class='ant-radio-button-wrapper ant-radio-button-wrapper-checked']//span[text()='Upload CSV']")
  public PageElement uploadCsvButton;
  @FindBy(xpath = "//span[text()='Enter Tracking ID(s)']")
  public PageElement trackingIDsButton;
  @FindBy(xpath = "//input[@type='file']")
  public PageElement chooseFileButton;
  @FindBy(xpath = "//span[text()='Search Invoiced Orders']/parent::button")
  public PageElement searchInvoicedOrdersButton;
  @FindBy(xpath = "//input[@placeholder='Enter search term']")
  public PageElement trackingIdInput;
  @FindBy(xpath = "//td[@class='trackingId']/span/span")
  public PageElement trackingIdOutput;
  @FindBy(xpath = "//td[@class='createdAtStr']/span/span")
  public PageElement createdAtOutput;
  @FindBy(xpath = "//strong[text()='# Tracking IDs from CSV']/parent::span/following-sibling::span")
  public PageElement orderCount;
  @FindBy(xpath = "//span[text()='No Results Found']")
  public PageElement noResultsFound;
  @FindBy(xpath = "//div[@class='ant-notification-notice-message']")
  public PageElement antNotificationMessage;
  @FindBy(xpath = "//div[@class='ant-notification-notice-description']")
  public PageElement antNotificationMessageDescription;
  @FindBy(tagName = "iframe")
  private PageElement pageFrame;


  public InvoicedOrdersSearchPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchTo() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void uploadFile(String path) {
    switchTo();
    pause1s();
    chooseFileButton.sendKeys(path);
  }

  public String getNotificationMessageText() {
    antNotificationMessage.waitUntilVisible();
    return antNotificationMessage.getText();
//    assertThat("Notification message is the same", actualNotificationMessage,
//        equalTo(expectedNotificationMessage));
//    closeAntNotificationMessage.click();
//    antNotificationMessage.waitUntilInvisible();
  }

  public String getNotificationMessageDescText() {
    antNotificationMessage.waitUntilVisible();
    return antNotificationMessageDescription.getText();
  }
}
