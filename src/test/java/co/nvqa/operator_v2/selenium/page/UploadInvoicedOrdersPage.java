package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.io.File;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class UploadInvoicedOrdersPage extends SimpleReactPage<UploadInvoicedOrdersPage> {

  public static final String CSV_FILENAME_PATTERN = "upload-invoiced-orders-template";

  @FindBy(xpath = "//input[@data-testid='useFileSelect-element']")
  public PageElement browseFilesInput;

  @FindBy(css = "[data-testid='invoiced-orders-download-sample-csv-button']")
  public PageElement downloadSampleCsvButton;

  @FindBy(xpath = "//div[@class='ant-notification-notice-message']")
  public PageElement antNotificationMessage;

  @FindBy(xpath = "//div[@class='ant-notification-notice-description']")
  public PageElement antNotificationMessageDescription;

  @FindBy(xpath = "//iframe[contains(@src,'upload-invoiced-orders')]")
  private PageElement pageFrame;

  @FindBy(xpath = "//span[contains(@class,'ant-spin-dot-spin')]")
  public PageElement antDotSpinner;


  public UploadInvoicedOrdersPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchToIframe() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void uploadFile(File file) {
    browseFilesInput.sendKeys(file.getAbsolutePath());
  }

  public String getPopUpMsg() {
    return getAntTopRightText();
  }

  public String getPopUpMsgDescription() {
    return getAntDescription();
  }

  public void clickDownloadCsvButton() {
    downloadSampleCsvButton.click();
  }

  public void verifyCsvFileDownloadedSuccessfully(String expectedBody) {
    verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(CSV_FILENAME_PATTERN),
        expectedBody);
  }

}
