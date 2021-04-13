package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.selenium.page.InvoicedOrdersSearchPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import java.io.File;
import java.util.List;

import static co.nvqa.commons.util.StandardTestUtils.createFile;

public class SearchInvoicedOrdersSteps extends AbstractSteps {

  final String filename = "search-invoiced-orders-upload.csv";
  private InvoicedOrdersSearchPage invoicedOrdersSearchPage;

  public SearchInvoicedOrdersSteps() {
  }

  @Override
  public void init() {
    invoicedOrdersSearchPage = new InvoicedOrdersSearchPage(getWebDriver());
  }


  @And("Operator upload a CSV file with below order ids on Invoiced Orders Search Page")
  public void operatorUploadACSVFileWithBelowOrderIdsOnInvoicedOrdersSearchPage(
      List<String> trackingIds) {
    trackingIds = resolveValues(trackingIds);
    File csvFile = createFile(filename, String.join("\n", trackingIds));
    String absolutePath = csvFile.getAbsolutePath();
    NvLogger.info("Path of the created file : " + absolutePath);
    invoicedOrdersSearchPage.uploadFile(absolutePath);
  }

  @And("Operator clicks Search Invoiced Order button")
  public void operatorClicksSearchInvoicedOrderButton() {
    invoicedOrdersSearchPage.searchInvoicedOrdersButton.click();
    invoicedOrdersSearchPage.goBackToFilterBtn.waitUntilVisible();
  }

  @And("Operator verifies below tracking ID\\(s) and creation time is displayed")
  public void operatorVerifiesBelowTrackingIDSAndCreationTimeIsDisplayed(List<String> trackingIds) {
    trackingIds = resolveValues(trackingIds);
    String actualTrackingIdValue = invoicedOrdersSearchPage.trackingIdOutput.getText();
    String actualCreationTimeValue = invoicedOrdersSearchPage.createdAtOutput.getText();
    softAssert
        .assertEquals("TrackingId is not expected ", trackingIds.get(0), actualTrackingIdValue);
    softAssert.assertContains("Creation time is not expected ", DateUtil.getTodayDate_YYYY_MM_DD(),
        actualCreationTimeValue);
  }

  @And("Operator verifies No Results Found is displayed")
  public void operatorVerifiesNoResultsFoundIsDisplayed() {
    invoicedOrdersSearchPage.noResultsFound.waitUntilVisible(3);
    assertTrue("No Results Found Message is not displayed",
        invoicedOrdersSearchPage.noResultsFound.isDisplayed());
  }

  @Then("Operator uploads a PDF on Invoiced Orders Search Page and verifies that any other file except csv is not allowed")
  public void operatorUploadsAPDFOnInvoicedOrdersSearchPageAndVerifiesThatAnyOtherFileExceptCsvIsNotAllowed() {
    String pdfFileName = "invalid-upload.pdf";
    File pdfFile = createFile(pdfFileName, "TEST");
    invoicedOrdersSearchPage.uploadFile(pdfFile.getAbsolutePath());
    String actualErrorMsg = invoicedOrdersSearchPage.getToastTopText();
    String expectedToastText = "\"" + pdfFileName + "\" is not allowed.";
    assertEquals(expectedToastText, actualErrorMsg);
  }


  @Then("Operator uploads an invalid on Invoiced Orders Search Page CSV and verifies error message")
  public void operatorUploadsAnInvalidOnInvoicedOrdersSearchPageCSVAndVerifiesErrorMessage() {
    String csvFileName = "upload.csv";
    File csvFile = createFile(csvFileName, "TEST1 , TEST2");
    invoicedOrdersSearchPage.uploadFile(csvFile.getAbsolutePath());
    invoicedOrdersSearchPage.searchInvoicedOrdersButton.click();
    String actualNotifText = invoicedOrdersSearchPage.getNotificationMessageText();
    String actualNotifDescription = invoicedOrdersSearchPage.getNotificationMessageDescText();
    String expectedNotifText = "Error parsing csv";
    String expectedNotifDescription = "More than 1 column detected";
    softAssert.assertEquals("Actual Notification Text is not expected", expectedNotifText,
        actualNotifText);
    softAssert
        .assertEquals("Actual Notification Description is not expected", expectedNotifDescription,
            actualNotifDescription);
  }

  @When("Operator clicks in Enter Tracking ID\\(s) tab")
  public void operatorClicksInEnterTrackingIDSTab() {
    invoicedOrdersSearchPage.switchTo();
    invoicedOrdersSearchPage.trackingIDsButton.waitUntilVisible();
    invoicedOrdersSearchPage.trackingIDsButton.click();
  }

  @And("Operator enters {string} tracking id on Invoiced Orders Search Page")
  public void operatorEntersTrackingIdOnInvoicedOrdersSearchPage(String trackingId) {
    trackingId = resolveValue(trackingId);
    invoicedOrdersSearchPage.trackingIdInput.sendKeys(trackingId);
  }

  @And("Operator verifies the order count is correctly displayed as {int}")
  public void operatorVerifiesTheOrderCountIsCorrectlyDisplayed(int count) {
    invoicedOrdersSearchPage.orderCount.waitUntilVisible();
    String trackingIdCount = invoicedOrdersSearchPage.orderCount.getText();
    softAssert.assertEquals("Tracking IDs from CSV Count is not expected", String.valueOf(count),
        trackingIdCount);

  }

  @Then("Operator verifies error message {string} is displayed")
  public void operatorVerifiesErrorMessageIsDisplayed(String errorMessage) {
    String actualErrorMsgText = invoicedOrdersSearchPage.errorMessageText.getText();
    softAssert.assertEquals("Actual and expected error message text mismatch", errorMessage,
        actualErrorMsgText);
  }

  @And("Operator clicks Search Invoiced Order button without any input")
  public void operatorClicksSearchInvoicedOrderButtonWithoutAnyInput() {
    invoicedOrdersSearchPage.switchTo();
    invoicedOrdersSearchPage.searchInvoicedOrdersButton.click();
  }

  @And("Operator verifies the file name is displayed")
  public void operatorVerifiesTheFileNameIsDisplayed() {
    softAssert.assertContains("Expected and actual CSV file name mismatch", filename,
        invoicedOrdersSearchPage.chooseFileButton.getValue());
  }

  @And("Operator verifies the file name is not displayed")
  public void operatorVerifiesTheFileNameIsNotDisplayed() {
    softAssert.assertContains("CSV file name is displayed", "",
        invoicedOrdersSearchPage.chooseFileButton.getValue());
  }

  @And("Operator clicks on Upload CSV tab")
  public void operatorClicksOnUploadCSVTab() {
    invoicedOrdersSearchPage.uploadCsvButton.click();
  }

  @Then("Operator search {string} tracking id in Tracking Number Search field")
  public void operatorSearchTrackingIdInTrackingNumberSearchField(String trackingId) {
    trackingId = resolveValue(trackingId);
    invoicedOrdersSearchPage.trackingIdSearchInput.sendKeys(trackingId);
  }

  @Then("Operator verifies {string} tracking id is highlighted")
  public void operatorVerifiesTrackingIdIsHighlighted(String trackingId) {
    trackingId = resolveValue(trackingId);
    softAssert.assertEquals("Actual and expected highlighted tracking id mismatch", trackingId,
        invoicedOrdersSearchPage.searchOutput.getText());
  }

  @Then("Operator search {string} in Creation Time Search field")
  public void operatorSearchInCreationTimeSearchField(String date) {
    invoicedOrdersSearchPage.createdAtSearchInput.sendKeys(date);
  }

  @Then("Operator verifies {string} is highlighted")
  public void operatorVerifiesIsHighlighted(String date) {
    softAssert.assertContains("Actual and expected highlighted date mismatch", date,
        invoicedOrdersSearchPage.searchOutput.getText());
  }

  @And("Operator clicks Refresh button")
  public void operatorClicksRefreshButton() {
    invoicedOrdersSearchPage.refreshBtn.click();
    invoicedOrdersSearchPage.goBackToFilterBtn.waitUntilVisible();
  }

  @And("Operator clicks Go Back To Filter button")
  public void operatorClicksGoBackToFilterButton() {
    invoicedOrdersSearchPage.goBackToFilterBtn.click();
    invoicedOrdersSearchPage.searchInvoicedOrdersButton.waitUntilClickable();
  }
}
