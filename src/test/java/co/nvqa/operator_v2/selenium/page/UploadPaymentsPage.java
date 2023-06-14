package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.io.File;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class UploadPaymentsPage extends SimpleReactPage {

  @FindBy(xpath = "//input[@type='file']")
  private PageElement uploadPaymentInput;

  @FindBy(css = ".ant-upload-list-item-name")
  private PageElement uploadPaymentOutput;

  public UploadPaymentsPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void uploadFile(File file) {
    uploadPaymentInput.sendKeys(file.getAbsolutePath());
  }

  public String getUploadedFileName() {
    return uploadPaymentOutput.getText();
  }

  public String getUploadStatusMessage() {
    return getAntTopText();
  }

  public String getUploadPaymentErrorToastTopText() {
    return getToastText("(//div[@class='ant-notification-notice-message'])[2]");

  }

  public String getUploadPaymentErrorToastDescription() {
    return getToastText("(//div[@class='ant-notification-notice-description'])[2]");
  }

  public void verifyDownloadErrorsCsvFileDownloadedSuccessfully(String expectedBody,
      String filename) {
    verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(filename),
        expectedBody);
  }
}
