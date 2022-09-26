package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import java.io.File;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class UploadSelfServePromoPage extends SimpleReactPage<UploadSelfServePromoPage> {

  public static final String UPLOAD_PRICING_PROFILE_FILENAME_PATTERN = "upload_pricing_profile_template";

  @FindBy(xpath = "//span[text()='Upload Pricing Profile With CSV']//parent::button")
  public Button uploadInvoicedOrdersButton;

  @FindBy(xpath = "//span[text()='Download Sample CSV Template']//parent::button")
  public Button downloadSampleCsvButton;

  @FindBy(css = "div.ant-modal-content")
  public UploadBulkPricingProfileDialog uploadBulkPricingProfileDialog;

  @FindBy(xpath = "//div[@class='ant-notification-notice-message']")
  public PageElement antNotificationMessage;

  public UploadSelfServePromoPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void clickUploadCsvButton() {
    uploadInvoicedOrdersButton.click();
  }

  public void downloadSampleCsvButton() {
    downloadSampleCsvButton.click();
  }

  public void verifyUploadBulkPricingProfileDialogIsDisplayed() {
    uploadBulkPricingProfileDialog.waitUntilLoaded();
    uploadBulkPricingProfileDialog.isDisplayed();
    Assertions.assertThat(uploadBulkPricingProfileDialog.isDisplayed())
        .as("Upload Bulk Pricing Dialog is displayed").isTrue();
  }

  public String getNotificationMessageText() {
    antNotificationMessage.waitUntilVisible();
    return antNotificationMessage.getText();
  }

  public void verifyCsvFileDownloadedSuccessfully(String expectedBody) {
    verifyFileDownloadedSuccessfully(
        getLatestDownloadedFilename(UPLOAD_PRICING_PROFILE_FILENAME_PATTERN),
        expectedBody);
  }

  public void verifyDownloadErrorsCsvFileDownloadedSuccessfully(String expectedBody,
      String filename) {
    verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(filename),
        expectedBody);
  }

  public static class UploadBulkPricingProfileDialog extends AntModal {

    @FindBy(xpath = "//button[.='Submit']")
    public Button submitButton;

    @FindBy(xpath = "//button[.='Cancel']")
    public Button cancelButton;

    @FindBy(xpath = "//input[@data-testid='useFileSelect-element']")
    public PageElement browseInput;

    @FindBy(xpath = "//button[.='Download Errors CSV']")
    public Button downloadErrorsCsvButton;


    public UploadBulkPricingProfileDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public void uploadFile(File file) {
      browseInput.sendKeys(file.getAbsolutePath());
    }

    public void clickDownloadErrorsCsvButton() {
      downloadErrorsCsvButton.click();
    }
  }
}
