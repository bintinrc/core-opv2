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

  public UploadInvoicedOrdersPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchToIframe() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void uploadFile(File file) {
    browseFilesInput.sendKeys(file.getAbsolutePath());
  }

  public String getErrorMsg() {
    return antNotificationMessage.getText();
  }

  public String getErrorMsgDescription() {
    return antNotificationMessageDescription.getText();
  }

  public void clickDownloadCsvButton() {
    downloadSampleCsvButton.click();
  }


  public void verifySuccessMsgIsDisplayed() {
    assertTrue("Success message is not displayed", isElementVisible(
        "//p[text()='Your upload is being processed. An email alert will be sent upon completion. Thank you!']"));
  }

  public void verifyCsvFileDownloadedSuccessfully(String expectedBody) {
    verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(CSV_FILENAME_PATTERN),
        expectedBody);
  }

}
