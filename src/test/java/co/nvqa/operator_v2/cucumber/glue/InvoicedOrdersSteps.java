package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.pricing.InvoicedOrder;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.selenium.page.UploadInvoicedOrdersPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import java.io.File;
import java.util.Map;

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

  @And("Operator uploads a CSV file with below order ids")
  public void operatorUploadsACSVFileWithBelowOrderIds(String orderIds) {
    int countOfShipperIds = orderIds.split(",").length;
    File csvFile = createFile("upload.csv", orderIds);
    NvLogger.info("Path of the created file : " + csvFile.getAbsolutePath());
    uploadInvoicedOrdersPage.uploadInvoicedOrdersDialog.uploadFile(csvFile);
    uploadInvoicedOrdersPage.uploadInvoicedOrdersDialog.submit.click();

//    clickButtonByAriaLabel(FILTER_UPLOAD_CSV_ARIA_LABEL);
//    clickNvIconTextButtonByName(FILTER_UPLOAD_CSV_NAME);
//
//    waitUntilVisibilityOfElementLocated(FILTER_UPLOAD_CSV_DIALOG_SHIPPER_ID_XPATH);
//    waitUntilVisibilityOfElementLocated(FILTER_UPLOAD_CSV_DIALOG_DROP_FILES_XPATH);
//    sendKeysByAriaLabel(FILTER_UPLOAD_CSV_DIALOG_CHOSSE_BUTTON_ARIA_LABEL,
//        csvFile.getAbsolutePath());
//    waitUntilVisibilityOfElementLocated(f(FILTER_UPLOAD_CSV_DIALOG_FILE_NAME, csvFile.getName()));
//    clickButtonByAriaLabel(FILTER_UPLOAD_CSV_DIALOG_SAVE_BUTTON_ARIA_LABEL);

//    assertEquals(f("Upload success. Extracted %s Shipper IDs.", countOfShipperIds),
//        getToastTopText());
  }

  @And("Operator upload a CSV file with below order ids")
  public void operatorUploadACSVFileWithBelowOrderIds(String trackingIds) {
    trackingIds = resolveValue(trackingIds);
    File csvFile = createFile("upload.csv", trackingIds);
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
}
