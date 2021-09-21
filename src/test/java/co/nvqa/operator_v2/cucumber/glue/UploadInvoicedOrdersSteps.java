package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.selenium.page.UploadInvoicedOrdersPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import java.io.File;
import java.util.List;

import static co.nvqa.commons.util.StandardTestUtils.createFile;

public class UploadInvoicedOrdersSteps extends AbstractSteps {

  private UploadInvoicedOrdersPage uploadInvoicedOrdersPage;

  public UploadInvoicedOrdersSteps() {
  }

  @Override
  public void init() {
    uploadInvoicedOrdersPage = new UploadInvoicedOrdersPage(getWebDriver());
  }

  @And("Operator clicks Upload Invoiced Orders with CSV button on the Upload Invoiced Orders Page")
  public void operatorClicksUploadInvoicedOrdersWithCSVButtonOnTheUploadInvoicedOrdersPage() {
    uploadInvoicedOrdersPage.clickUploadCsvButton();
    uploadInvoicedOrdersPage.verifyUploadInvoicedOrdersDialogIsDisplayed();
  }

  @And("Operator upload a CSV file with below order ids and verify success message")
  public void operatorUploadACSVFileWithBelowOrderIdsVerify(List<String> trackingIds) {
    trackingIds = resolveValues(trackingIds);
    File csvFile = createFile("upload.csv", String.join("\n", trackingIds));
    NvLogger.info("Path of the created file : " + csvFile.getAbsolutePath());
    uploadInvoicedOrdersPage.uploadInvoicedOrdersDialog.uploadFile(csvFile);
    uploadInvoicedOrdersPage.verifySuccessMsgIsDisplayed();
    uploadInvoicedOrdersPage.verifySuccessUploadNewFileIsDisplayed();
    pause3s();
  }

  @And("Operator upload a CSV file with below order ids")
  public void operatorUploadACSVFileWithBelowOrderIds(List<String> trackingIds) {
    trackingIds = resolveValues(trackingIds);
    File csvFile = createFile("upload.csv", String.join("\n", trackingIds));
    NvLogger.info("Path of the created file : " + csvFile.getAbsolutePath());
    uploadInvoicedOrdersPage.uploadInvoicedOrdersDialog.uploadFile(csvFile);
  }

  @And("Operator clicks on Upload New File Button")
  public void operatorClicksOnUploadNewFileButton() {
    uploadInvoicedOrdersPage.uploadNewFileButton.click();
    uploadInvoicedOrdersPage.uploadNewCsvDialog.uploadNewFile.click();
    uploadInvoicedOrdersPage.waitUntilPageLoaded();
  }

  @Then("Operator uploads a PDF and verifies that any other file except csv is not allowed")
  public void operatorUploadsAPDFAndVerifiesThatAnyOtherFileExceptCsvIsNotAllowed() {
    String pdfFileName = "invalid-upload.pdf";
    File pdfFile = createFile(pdfFileName, "TEST");
    uploadInvoicedOrdersPage.uploadInvoicedOrdersDialog.chooseButton.setValue(pdfFile);
    String actualErrorMsg = uploadInvoicedOrdersPage.getToastTopText();
    String expectedToastText = "\"" + pdfFileName + "\" is not allowed.";
    assertEquals(expectedToastText, actualErrorMsg);
  }

  @Then("Operator uploads an invalid CSV and verifies error message")
  public void operatorUploadsAnInvalidCSVAndVerifiesErrorMessage() {
    String csvFileName = "upload.csv";
    File csvFile = createFile(csvFileName, "TEST1 , TEST2");
    uploadInvoicedOrdersPage.uploadInvoicedOrdersDialog.uploadFile(csvFile);
    String actualErrorMsg = uploadInvoicedOrdersPage.getToastTopText();
    String expectedToastText = "Error parsing csv";
    assertEquals(expectedToastText, actualErrorMsg);
  }

  @And("Operator clicks Download sample CSV template button on the Upload Invoiced Orders Page")
  public void operatorClicksDownloadSampleCSVTemplateButtonOnTheUploadInvoicedOrdersPage() {
    uploadInvoicedOrdersPage.clickDownloadCsvButton();
  }

  @Then("Operator verify Sample CSV file on Upload Invoiced Orders page downloaded successfully with below data")
  public void operatorVerifySampleCSVFileOnUploadInvoicedOrdersPageDownloadedSuccessfullyWithBelowData(
      List<String> trackingIds) {
    String expectedString = String.join("\n", trackingIds);
    uploadInvoicedOrdersPage.verifyCsvFileDownloadedSuccessfully(expectedString);
  }
}
