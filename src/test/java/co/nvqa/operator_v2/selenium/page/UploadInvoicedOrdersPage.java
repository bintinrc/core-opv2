package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonFilePicker;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import java.io.File;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class UploadInvoicedOrdersPage extends OperatorV2SimplePage {

  public static final String CSV_FILENAME_PATTERN = "sample_csv";

  @FindBy(name = "Upload Invoiced Orders with CSV")
  public NvIconTextButton uploadInvoicedOrdersButton;

  @FindBy(name = "Download sample CSV template")
  public NvIconTextButton downloadSampleCsvButton;

  @FindBy(name = "Upload New File")
  public NvIconTextButton uploadNewFileButton;

  @FindBy(css = "md-dialog")
  public UploadInvoicedOrdersDialog uploadInvoicedOrdersDialog;

  @FindBy(css = "md-dialog")
  public UploadNewCsvDialog uploadNewCsvDialog;

  public UploadInvoicedOrdersPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void clickUploadCsvButton() {
    uploadInvoicedOrdersButton.click();
  }

  public void clickDownloadCsvButton() {
    downloadSampleCsvButton.click();
  }


  public void verifyUploadInvoicedOrdersDialogIsDisplayed() {
    uploadInvoicedOrdersDialog.waitUntilVisible();
    assertTrue("Upload Invoiced Orders Dialog is not displayed",
        uploadInvoicedOrdersDialog.isDisplayed());
  }

  public void verifySuccessMsgIsDisplayed() {
    assertTrue("Success message is not displayed", isElementVisible(
        "//p[text()='Your upload is being processed. An email alert will be sent upon completion. Thank you!']"));
  }

  public void verifySuccessUploadNewFileIsDisplayed() {
    assertTrue("Upload New Button is not displayed", uploadNewFileButton.isDisplayed());
  }

  public void verifyCsvFileDownloadedSuccessfully(String expectedBody) {
    verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(CSV_FILENAME_PATTERN),
        expectedBody);
  }

  public static class UploadInvoicedOrdersDialog extends MdDialog {

    @FindBy(css = "[label='Choose']")
    public NvButtonFilePicker chooseButton;
    @FindBy(name = "Submit")
    public NvButtonSave submit;

    public UploadInvoicedOrdersDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public void uploadFile(File file) {
      waitUntilVisible();
      chooseButton.setValue(file);
      submit.clickAndWaitUntilDone(120);
    }
  }

  public static class UploadNewCsvDialog extends MdDialog {

    @FindBy(xpath = "//button//span[text()='Upload New File']")
    public Button uploadNewFile;

    public UploadNewCsvDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}
