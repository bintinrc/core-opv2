package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class InvoicedOrdersSearchPage extends SimpleReactPage {


  @FindBy(xpath = "//span[@data-testid='invoiced-orders.segmented.upload-csv']")
  public PageElement uploadCsvButton;
  @FindBy(xpath = "//input[@data-testid='useFileSelect-element']")
  public PageElement chooseFileButton;
  @FindBy(xpath = "//span[@data-testid='invoiced-orders.segmented.enter-tracking-id']")
  public PageElement trackingIDsButton;
  @FindBy(xpath = "//div[@data-testid='invoiced-orders.tracking-id-input']//input[@type='search']")
  public PageElement trackingIdInput;

  @FindBy(xpath = "//td[@class='ant-table-cell'][1]")
  public PageElement trackingIdOutput;
  @FindBy(xpath = "//span[text()='Tracking Number']//following::input")
  public PageElement trackingIdSearchInput;
  @FindBy(xpath = "//mark[@class='highlight ']")
  public PageElement searchOutput;
  @FindBy(xpath = "//td[@class='ant-table-cell'][2]")
  public PageElement createdAtOutput;
  @FindBy(xpath = "//span[text()='Creation Time']//following::input")
  public PageElement createdAtSearchInput;

  @FindBy(xpath = "//span[@data-testid='invoiced-orders.tracking-ids-count']")
  public PageElement orderCount;
  @FindBy(xpath = "//*[text()='No Data']")
  public PageElement noDataFound;
  @FindBy(xpath = "//div[@class='ant-notification-notice-message']")
  public PageElement antNotificationMessage;
  @FindBy(xpath = "//div[@class='ant-notification-notice-description']")
  public PageElement antNotificationMessageDescription;
  @FindBy(xpath = "//button[@data-testid='invoiced-orders.search-button']")
  public PageElement searchInvoiceOrdersButton;
  @FindBy(xpath = "//button[@data-testid='invoiced-orders.results.refresh-button']")
  public Button refreshBtn;
  @FindBy(xpath = "//button[@data-testid='invoiced-orders.results.back-button']")
  public Button goBackToFilterBtn;
  @FindBy(xpath = "//span[contains(@class,'ant-spin-dot-spin')]")
  public PageElement antDotSpinner;
  @FindBy(xpath = "//span[@data-testid='invoiced-orders.tracking-id-input.error']")
  public PageElement warningText;
  @FindBy(xpath = "//iframe[contains(@src,'invoiced-orders')]")
  private PageElement pageFrame;

  @FindBy(xpath = "//span[text()='Search Invoiced Orders']/parent::button/preceding::p[1]")
  public PageElement errorMessageText;


  public InvoicedOrdersSearchPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchToIframe() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void uploadFile(String path) {
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
