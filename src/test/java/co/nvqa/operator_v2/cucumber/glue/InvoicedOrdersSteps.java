package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.pricing.InvoicedOrder;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.GmailClient;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.page.UploadInvoicedOrdersPage;
import co.nvqa.operator_v2.util.TestConstants;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.Enumeration;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import org.apache.commons.io.FileUtils;

import static co.nvqa.commons.util.StandardTestUtils.createFile;

public class InvoicedOrdersSteps extends AbstractSteps {

  private UploadInvoicedOrdersPage uploadInvoicedOrdersPage;

  public InvoicedOrdersSteps() {
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

  @And("Operator upload a CSV file with below order ids")
  public void operatorUploadACSVFileWithBelowOrderIds(List<String> trackingIds) {
    trackingIds = resolveValues(trackingIds);
    File csvFile = createFile("upload.csv", String.join("\n", trackingIds));
    NvLogger.info("Path of the created file : " + csvFile.getAbsolutePath());
    uploadInvoicedOrdersPage.uploadInvoicedOrdersDialog.uploadFile(csvFile);
    uploadInvoicedOrdersPage.verifySuccessMsgIsDisplayed();
    uploadInvoicedOrdersPage.verifySuccessUploadNewFileIsDisplayed();
  }


  @Then("Operator verifies below details in dwh_qa_gl.invoiced_orders table")
  public void operatorVerifiesBelowDetailsInDwh_qa_glInvoiced_ordersTable(
      Map<String, String> dataTableAsMap) {
    InvoicedOrder invoicedOrderDB = get(KEY_INVOICED_ORDER_DETAILS_DB);
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    System.out.println("NADEERA" + invoicedOrderDB);
    if (dataTableAsMap.containsKey("shipper_id")) {
      softAssert.assertEquals(
          f("Expected and actual mismatch of shipper_id column for order with tracking id  %s",
              trackingId), dataTableAsMap.get("shipper_id"),
          String.valueOf(invoicedOrderDB.getShipperId()));
    }
    if (dataTableAsMap.containsKey("system_id")) {
      softAssert.assertEquals(
          f("Expected and actual mismatch of system_id column for order with tracking id  %s",
              trackingId), dataTableAsMap.get("system_id"),
          String.valueOf(invoicedOrderDB.getSystemId()));
    }
    if (dataTableAsMap.containsKey("invoiced_at")) {
      softAssert.assertContains(
          f("Expected and actual mismatch of invoiced_at column for order with tracking id  %s",
              trackingId), dataTableAsMap.get("invoiced_at"),
          invoicedOrderDB.getInvoicedAt());
    }
    if (dataTableAsMap.containsKey("invoiced_local_date")) {
      softAssert.assertContains(
          f("Expected and actual mismatch of invoiced_local_date column for order with tracking id  %s",
              trackingId), dataTableAsMap.get("invoiced_local_date"),
          invoicedOrderDB.getInvoicedLocalDate());
    }
    if (dataTableAsMap.containsKey("created_at")) {
      softAssert.assertContains(
          f("Expected and actual mismatch of created_at column for order with tracking id  %s",
              trackingId), dataTableAsMap.get("created_at"),
          invoicedOrderDB.getCreatedAt());
    }
    if (dataTableAsMap.containsKey("updated_at")) {
      softAssert.assertNull(
          f("Updated_at column for order with tracking id  %s is not null",
              trackingId), invoicedOrderDB.getUpdatedAt());
    }
    if (dataTableAsMap.containsKey("deleted_at")) {
      softAssert.assertNull(
          f("Deleted_at column for order with tracking id  %s is not null",
              trackingId), invoicedOrderDB.getDeletedAt());
    }

  }

  @Then("Operator opens Gmail and verifies email with below details")
  public void operatorOpensGmailAndVerifiesEmailWithBelowDetails(
      Map<String, String> dataTableAsMap) {
    pause3s();
    String expectedSubject = dataTableAsMap.get("subject");
    String expectedBody = dataTableAsMap.get("body");
    Boolean isZipFileAvailable = Boolean.parseBoolean(dataTableAsMap.get("isZipFileAvailable"));

    GmailClient gmailClient = new GmailClient();
    gmailClient.readUnseenMessage(message ->
    {
      if (message.getSubject().equals(expectedSubject)) {
        String emailBody = gmailClient.getSimpleContentBody(message);
        assertThat("Actual and expected body message mismatch", emailBody,
            containsString(expectedBody));
        if (isZipFileAvailable) {
          String REPORT_ATTACHMENT_NAME_PATTERN = "https://.*ninjavan.*invoicing/invoicing-results.*zip";

          Pattern pattern = Pattern.compile(REPORT_ATTACHMENT_NAME_PATTERN);
          Matcher matcher = pattern.matcher(emailBody);

          String attachmentUrl;

          if (matcher.find()) {
            attachmentUrl = matcher.group();
            NvLogger.infof("Zip file received in mail - %s", attachmentUrl);
            if (Objects.nonNull(attachmentUrl)) {
              put(KEY_INVOICED_ORDER_URL, attachmentUrl);
            } else {
              fail("Zip file link unavailable in the email ");
            }
          }
        }
      } else {
        fail(f("No email with '%s' subject in the mailbox", expectedSubject));
      }
    });
  }


  @When("Operator clicks on link to download on email and verifies CSV file")
  public void operatorClicksOnLinkToDownloadOnEmailAndVerifiesCSVFile() {
    List<String> body = new LinkedList<>();
    String attachmentUrl = get(KEY_INVOICED_ORDER_URL);
    assertTrue("Attachment Url is null ", Objects.nonNull(attachmentUrl));

    String zipName = "upload_invoiced-orders.zip";
    String pathToZip = TestConstants.TEMP_DIR + "invoiced_orders_" + DateUtil.getTimestamp() + "/";
    try {
      FileUtils.copyURLToFile(new URL(attachmentUrl), new File(pathToZip + zipName));
    } catch (IOException ex) {
      throw new NvTestRuntimeException("Could not get file from " + attachmentUrl, ex);
    }

    try (ZipFile zipFile = new ZipFile(pathToZip + zipName)) {
      Enumeration<? extends ZipEntry> entries = zipFile.entries();

      while (entries.hasMoreElements()) {
        ZipEntry entry = entries.nextElement();
        InputStream is = zipFile.getInputStream(entry);
        BufferedReader reader = new BufferedReader(new InputStreamReader(is));

        while (reader.ready()) {
          body.add(reader.readLine());
        }
      }
      put(KEY_INVOICED_ORDER_CSV_BODY, body);
    } catch (IOException ex) {
      throw new NvTestRuntimeException("Could not read from file " + attachmentUrl, ex);
    }
    assertFalse(f("Body is not found in CSV received in email (%s)", attachmentUrl),
        body.isEmpty());

  }

  @Then("Operator verifies below tracking id\\(s) is\\are available in the CSV file")
  public void operatorVerifiesBelowTrackingIdSIsAreAvailableInTheCSVFile(List<String> trackingIds) {
    trackingIds = resolveValues(trackingIds);
    List<String> body = get(KEY_INVOICED_ORDER_CSV_BODY);

    for (String trackingID : trackingIds) {
      assertTrue(f("Tracking_ID %s is not found in CSV", trackingID), body.contains(trackingID));
    }
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
