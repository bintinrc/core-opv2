package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import java.io.File;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class UploadSelfServePromoPage extends SimpleReactPage<UploadSelfServePromoPage> {

  public static final String CSV_FILENAME_PATTERN = "sample_csv";

  @FindBy(xpath = "//span[text()='Upload Pricing Profile With CSV']//parent::button")
  public Button uploadInvoicedOrdersButton;

  @FindBy(name = "Download sample CSV template")
  public NvIconTextButton downloadSampleCsvButton;

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

  public void verifyUploadBulkPricingProfileDialogIsDisplayed() {
    uploadBulkPricingProfileDialog.isDisplayed();
    Assertions.assertThat(uploadBulkPricingProfileDialog.isDisplayed())
        .as("Upload Bulk Pricing Dialog is displayed").isTrue();
  }

  public String getNotificationMessageText() {
    antNotificationMessage.waitUntilVisible();
    return antNotificationMessage.getText();
  }

  public static class UploadBulkPricingProfileDialog extends AntModal {

    @FindBy(xpath = "//button[.='Submit']")
    public Button submitButton;

    @FindBy(xpath = "//button[.='Cancel']")
    public Button cancelButton;

    @FindBy(xpath = "//input[@data-testid='useFileSelect-element']")
    public PageElement browseInput;

    public UploadBulkPricingProfileDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public void uploadFile(File file) {
      browseInput.sendKeys(file.getAbsolutePath());
    }

  }
}
