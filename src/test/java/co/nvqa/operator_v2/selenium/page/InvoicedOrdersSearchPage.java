package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class InvoicedOrdersSearchPage extends OperatorV2SimplePage {


  @FindBy(xpath = "//span[@class='ant-radio-button']/following-sibling::span/span[text()='Upload CSV']")
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
  @FindBy(xpath = "//span[text()='Tracking Number']//following::input")
  public PageElement trackingIdSearchInput;
  @FindBy(xpath = "//mark[@class='highlight ']")
  public PageElement searchOutput;
  @FindBy(xpath = "//td[@class='createdAtStr']/span/span")
  public PageElement createdAtOutput;
  @FindBy(xpath = "//span[text()='Creation Time']//following::input")
  public PageElement createdAtSearchInput;
  @FindBy(xpath = "//strong[text()='# Tracking IDs from CSV']/parent::span/following-sibling::span")
  public PageElement orderCount;
  @FindBy(xpath = "//span[text()='No Results Found']")
  public PageElement noResultsFound;
  @FindBy(xpath = "//div[@class='ant-notification-notice-message']")
  public PageElement antNotificationMessage;
  @FindBy(xpath = "//div[@class='ant-notification-notice-description']")
  public PageElement antNotificationMessageDescription;
  @FindBy(xpath = "//span[text()='Search Invoiced Orders']/parent::button/preceding::p[1]")
  public PageElement errorMessageText;
  @FindBy(tagName = "iframe")
  private PageElement pageFrame;
  @FindBy(id = "refresh-btn")
  public Button refreshBtn;
  @FindBy(id = "go-back-btn")
  public Button goBackToFilterBtn;

  public InvoicedOrdersSearchPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchTo() {
    try {
      getWebDriver().switchTo().frame(pageFrame.getWebElement());
    } catch (NoSuchElementException e) {
      NvLogger.info("Already inside the iframe");
    }
  }

  public void uploadFile(String path) {
    switchTo();
    pause1s();
    chooseFileButton.sendKeys(path);
  }

  public String getNotificationMessageText() {
    antNotificationMessage.waitUntilVisible();
    return antNotificationMessage.getText();
  }

  public String getNotificationMessageDescText() {
    antNotificationMessage.waitUntilVisible();
    return antNotificationMessageDescription.getText();
  }
}
