package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonFilePicker;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import java.io.File;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class UploadInvoicedOrdersPage extends OperatorV2SimplePage {

  @FindBy(name = "Upload Invoiced Orders with CSV")
  public NvIconTextButton uploadInvoicedOrdersButton;

  @FindBy(css = "md-dialog")
  public UploadInvoicedOrdersDialog uploadInvoicedOrdersDialog;

  public UploadInvoicedOrdersPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void clickUploadCsvButton() {
    uploadInvoicedOrdersButton.click();
  }

  public void verifyUploadInvoicedOrdersDialogIsDisplayed() {
    uploadInvoicedOrdersDialog.waitUntilVisible();
    assertTrue("Upload Invoiced Orders Dialog is not displayed",
        uploadInvoicedOrdersDialog.isDisplayed());
  }

  public void verifySuccessMsgIsDisplayed() {
    assertTrue(isElementVisible(
        "//p[text()='Your upload is being processed. An email alert will be sent upon completion. Thank you!']"));
  }

  public void verifySuccessUploadNewFileIsDisplayed() {
    assertTrue(isElementVisible(
        "//nv-icon-text-button[@name='Upload New File']"));
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
      submit.clickAndWaitUntilDone();
    }

  }
}
