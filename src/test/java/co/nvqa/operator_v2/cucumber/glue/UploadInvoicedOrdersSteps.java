package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.pricing.model.persisted_classes.billing.OrderPaymentTags;
import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.page.UploadInvoicedOrdersPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.common.pricing.cucumber.glue.FinanceKeyStorage.KEY_BILLING_ORDER_PAYMENT_TAGS_DETAILS_DB;
import static co.nvqa.common.pricing.cucumber.glue.FinanceKeyStorage.KEY_BILLING_ORDER_PAYMENT_TAGS_INVOICED_AT_DB;
//import static co.nvqa.common.pricing.cucumber.glue.FinanceKeyStorage.KEY_BILLING_ORDER_PAYMENT_TAGS_INVOICED_AT_DB;

public class UploadInvoicedOrdersSteps extends AbstractSteps {

  private UploadInvoicedOrdersPage uploadInvoicedOrdersPage;

  private static final Logger LOGGER = LoggerFactory.getLogger(UploadInvoicedOrdersSteps.class);


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
    LOGGER.info("Path of the created file : " + csvFile.getAbsolutePath());
    uploadInvoicedOrdersPage.uploadFile(csvFile);
    verifySuccessMsg();
    pause3s();
  }

  private void verifySuccessMsg() {
    String actualMsg = uploadInvoicedOrdersPage.getPopUpMsgDescription();
    Assertions.assertThat(actualMsg).as("Success notification message displayed")
        .isEqualTo(
            "Your upload is being processed. An email alert will be sent upon completion. Thank you!");
  }

  @And("Operator upload a CSV file with below order ids")
  public void operatorUploadACSVFileWithBelowOrderIds(List<String> trackingIds) {
    trackingIds = resolveValues(trackingIds);
    File csvFile = StandardTestUtils.createFile("upload.csv", String.join("\n", trackingIds));
    LOGGER.info("Path of the created file : " + csvFile.getAbsolutePath());
    uploadInvoicedOrdersPage.uploadFile(csvFile);
    takesScreenshot();
  }

  @Then("Operator uploads a PDF and verifies that any other file except csv is not allowed")
  public void operatorUploadsAPDFAndVerifiesThatAnyOtherFileExceptCsvIsNotAllowed() {
    String pdfFileName = "invalid-upload.pdf";
    File pdfFile = StandardTestUtils.createFile(pdfFileName, "TEST");
    uploadInvoicedOrdersPage.browseFilesInput.sendKeys(pdfFile);
    String actualErrorMsg = uploadInvoicedOrdersPage.getPopUpMsg();
    String actualErrorDescription = uploadInvoicedOrdersPage.getPopUpMsgDescription();
    Assertions.assertThat(actualErrorMsg).as("Error message title is correct")
        .contains("Error uploading file");
    Assertions.assertThat(actualErrorDescription).as("Error message description is correct")
        .isEqualTo("Invalid file type");

  }

  @Then("Operator uploads an invalid CSV and verifies error message")
  public void operatorUploadsAnInvalidCSVAndVerifiesErrorMessage() {
    String csvFileName = "upload.csv";
    File csvFile = StandardTestUtils.createFile(csvFileName, "TEST1 , TEST2");
    uploadInvoicedOrdersPage.uploadFile(csvFile);
    String actualErrorMsg = uploadInvoicedOrdersPage.getPopUpMsg();
    String actualErrorDescription = uploadInvoicedOrdersPage.getPopUpMsgDescription();
    Assertions.assertThat(actualErrorMsg).as("Error message title is correct")
        .contains("Error uploading file");
    Assertions.assertThat(actualErrorDescription).as("Error message description is correct")
        .isEqualTo("Invalid CSV file");

  }


  @And("Operator upload a CSV file without extension with below order ids and verify success message")
  public void operatorUploadACSVFileWithoutExtensionWithBelowOrderIdsAndVerifySuccessMsg(
      List<String> trackingIds) {
    trackingIds = resolveValues(trackingIds);
    File csvFile = StandardTestUtils.createFile("uploadfile", String.join("\n", trackingIds));
    LOGGER.info("Path of the created file : " + csvFile.getAbsolutePath());
    uploadInvoicedOrdersPage.uploadFile(csvFile);
    verifySuccessMsg();
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

  @Then("Operator verifies that error toast is displayed on Upload Invoiced Orders page:")
  public void operatorVerifiesThatErrorToastDisplayedOnUploadInvoicedOrdersPage(
      Map<String, String> mapOfData) {
    String errorTitle = mapOfData.get("top");
    String errorMessage = mapOfData.get("bottom");

    retryIfAssertionErrorOccurred(
        () -> Assertions.assertThat(
                uploadInvoicedOrdersPage.noticeNotifications.get(0).message.getText())
            .as("Notifications are available").isNotEmpty(), "Get Notifications",
        500, 3);
    AntNotification notification = uploadInvoicedOrdersPage.noticeNotifications.get(0);
    SoftAssertions softAssertions = new SoftAssertions();
    softAssertions.assertThat(notification.message.getText()).as("Toast top text is correct")
        .isEqualTo(errorTitle);
    softAssertions.assertThat(notification.description.getText()).as("Toast bottom text is correct")
        .contains(errorMessage);
    softAssertions.assertAll();
  }

  @Then("Operator saves the invoiced_at value in the billing_qa_gl.order_payment_tags table for verifying purpose")
  public void operatorSavesTheUpdate_atValueInTheBilling_qa_glOrder_payment_tagsTableForVerifyingPurpose() {
    OrderPaymentTags orderPaymentTags = get(KEY_BILLING_ORDER_PAYMENT_TAGS_DETAILS_DB);
    if (Objects.nonNull(orderPaymentTags)) {
      put(KEY_BILLING_ORDER_PAYMENT_TAGS_INVOICED_AT_DB, orderPaymentTags.getInvoicedAt());
    } else {
      throw new NvTestRuntimeException("KEY_BILLING_ORDER_PAYMENT_TAGS_DETAILS_DB is null");
    }
  }

  @Then("Operator verifies the invoiced_at value in the billing_qa_gl.order_payment_tags table is same as the previous value")
  public void operatorVerifiesTheInvoiced_atValueInTheBilling_qa_glOrder_payment_tagsTableIsSameAsThePreviousValue() {
    OrderPaymentTags orderPaymentTags = get(KEY_BILLING_ORDER_PAYMENT_TAGS_DETAILS_DB);
    if (Objects.nonNull(orderPaymentTags)) {
      Assertions.assertThat(orderPaymentTags.getInvoicedAt().toString())
          .as("invoiced_at value is the same as below")
          .isEqualTo(get(KEY_BILLING_ORDER_PAYMENT_TAGS_INVOICED_AT_DB).toString());
    } else {
      throw new NvTestRuntimeException("KEY_BILLING_ORDER_PAYMENT_TAGS_DETAILS_DB is null");
    }
  }
}
