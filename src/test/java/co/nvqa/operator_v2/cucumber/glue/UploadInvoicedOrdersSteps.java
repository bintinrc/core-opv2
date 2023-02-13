package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.selenium.page.UploadInvoicedOrdersPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.util.List;
import org.assertj.core.api.Assertions;

public class UploadInvoicedOrdersSteps extends AbstractSteps {

  private UploadInvoicedOrdersPage uploadInvoicedOrdersPage;

  public UploadInvoicedOrdersSteps() {
  }

  @Override
  public void init() {
    uploadInvoicedOrdersPage = new UploadInvoicedOrdersPage(getWebDriver());
  }

  @And("Operator upload a CSV file with below order ids and verify success message")
  public void operatorUploadACSVFileWithBelowOrderIdsVerify(List<String> trackingIds) {
    trackingIds = resolveValues(trackingIds);
    File csvFile = StandardTestUtils.createFile("upload.csv", String.join("\n", trackingIds));
    NvLogger.info("Path of the created file : " + csvFile.getAbsolutePath());
    uploadInvoicedOrdersPage.uploadFile(csvFile);
    uploadInvoicedOrdersPage.verifySuccessMsgIsDisplayed();
    pause3s();
  }

  @And("Operator upload a CSV file with below order ids")
  public void operatorUploadACSVFileWithBelowOrderIds(List<String> trackingIds) {
    trackingIds = resolveValues(trackingIds);
    File csvFile = StandardTestUtils.createFile("upload.csv", String.join("\n", trackingIds));
    NvLogger.info("Path of the created file : " + csvFile.getAbsolutePath());
    uploadInvoicedOrdersPage.uploadFile(csvFile);
    takesScreenshot();
  }

  @Then("Operator uploads a PDF and verifies that any other file except csv is not allowed")
  public void operatorUploadsAPDFAndVerifiesThatAnyOtherFileExceptCsvIsNotAllowed() {
    String pdfFileName = "invalid-upload.pdf";
    File pdfFile = StandardTestUtils.createFile(pdfFileName, "TEST");
    uploadInvoicedOrdersPage.browseFilesInput.sendKeys(pdfFile);
    String actualErrorMsg = uploadInvoicedOrdersPage.getErrorMsg();
    String actualErrorDescription = uploadInvoicedOrdersPage.getErrorMsgDescription();
    Assertions.assertThat(actualErrorMsg).as("Error message title is correct")
        .isEqualTo("Error uploading file");
    Assertions.assertThat(actualErrorDescription).as("Error message description is correct")
        .isEqualTo("Error: Invalid file type");

  }

  @Then("Operator uploads an invalid CSV and verifies error message")
  public void operatorUploadsAnInvalidCSVAndVerifiesErrorMessage() {
    String csvFileName = "upload.csv";
    File csvFile = StandardTestUtils.createFile(csvFileName, "TEST1 , TEST2");
    uploadInvoicedOrdersPage.uploadFile(csvFile);
    String actualErrorMsg = uploadInvoicedOrdersPage.getErrorMsg();
    String actualErrorDescription = uploadInvoicedOrdersPage.getErrorMsgDescription();
    Assertions.assertThat(actualErrorMsg).as("Error message title is correct")
        .isEqualTo("Error uploading file");
    Assertions.assertThat(actualErrorDescription).as("Error message description is correct")
        .isEqualTo("Error: Invalid CSV file");

  }


  @And("Operator upload a CSV file without extension with below order ids and verify success message")
  public void operatorUploadACSVFileWithoutExtensionWithBelowOrderIdsAndVerifySuccessMsg(
      List<String> trackingIds) {
    trackingIds = resolveValues(trackingIds);
    File csvFile = StandardTestUtils.createFile("uploadfile", String.join("\n", trackingIds));
    NvLogger.info("Path of the created file : " + csvFile.getAbsolutePath());
    uploadInvoicedOrdersPage.uploadFile(csvFile);
    uploadInvoicedOrdersPage.verifySuccessMsgIsDisplayed();
    takesScreenshot();
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

  @When("Upload Invoiced Orders page is loaded")
  public void uploadInvoicedOrdersPageIsLoaded() {
    uploadInvoicedOrdersPage.switchToIframe();
    uploadInvoicedOrdersPage.waitUntilLoaded();
  }

}
