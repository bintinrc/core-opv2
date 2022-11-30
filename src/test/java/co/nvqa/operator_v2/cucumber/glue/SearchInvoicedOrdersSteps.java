package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.selenium.page.InvoicedOrdersSearchPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.util.List;
import org.assertj.core.api.Assertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SearchInvoicedOrdersSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(SearchInvoicedOrdersSteps.class);

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
    File csvFile = StandardTestUtils.createFile(filename, String.join("\n", trackingIds));
    String absolutePath = csvFile.getAbsolutePath();
    LOGGER.info("Path of the created file : " + absolutePath);
    invoicedOrdersSearchPage.uploadFile(absolutePath);
    takesScreenshot();
  }

  @And("Operator clicks Search Invoiced Order button and wait till CSV is uploaded")
  public void operatorClicksSearchInvoicedOrderButtonAndWait() {
    invoicedOrdersSearchPage.searchInvoicedOrdersButton.click();
    invoicedOrdersSearchPage.goBackToFilterBtn.waitUntilVisible();
  }

  @And("Operator clicks Search Invoiced Order button")
  public void operatorClicksSearchInvoicedOrderButton() {
    invoicedOrdersSearchPage.searchInvoicedOrdersButton.click();
    takesScreenshot();
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
    Assertions.assertThat(invoicedOrdersSearchPage.noResultsFound.isDisplayed())
        .as("No Results Found Message is not displayed").isTrue();
  }

  @Then("Operator uploads a PDF on Invoiced Orders Search Page and verifies error message {string}")
  public void operatorUploadsAPDFOnInvoicedOrdersSearchPageAndVerifiesThatAnyOtherFileExceptCsvIsNotAllowed(
      String expectedErrorMsg) {
    String pdfFileName = "invalid-upload.pdf";
    File pdfFile = StandardTestUtils.createFile(pdfFileName, "TEST");
    invoicedOrdersSearchPage.uploadFile(pdfFile.getAbsolutePath());
    String actualNotifDescription = invoicedOrdersSearchPage.getNotificationMessageText();
    verifyErrorMessage(expectedErrorMsg);
  }

  @Then("Operator uploads an invalid CSV on Invoiced Orders Search Page CSV and verifies error message {string}")
  public void operatorUploadsAnInvalidOnInvoicedOrdersSearchPageCSVAndVerifiesErrorMessage(
      String expectedErrorMsg) {
    String csvFileName = "upload.csv";
    File csvFile = StandardTestUtils.createFile(csvFileName, "TEST1 , TEST2");
    invoicedOrdersSearchPage.uploadFile(csvFile.getAbsolutePath());
    invoicedOrdersSearchPage.searchInvoicedOrdersButton.click();
    verifyErrorMessage(expectedErrorMsg);
  }

  @Then("Operator uploads an empty CSV on Invoiced Orders Search Page CSV and verifies error message {string}")
  public void operatorUploadsAnEmptyCSVOnInvoicedOrdersSearchPageCSVAndVerifiesErrorMessage(
      String expectedErrorMsg) {
    String csvFileName = "upload.csv";
    File csvFile = StandardTestUtils.createFile(csvFileName, "");
    invoicedOrdersSearchPage.uploadFile(csvFile.getAbsolutePath());
    invoicedOrdersSearchPage.searchInvoicedOrdersButton.click();
    verifyErrorMessage(expectedErrorMsg);
  }

  private void verifyErrorMessage(String expectedErrorMsg) {
    String actualNotifDescription = invoicedOrdersSearchPage.getNotificationMessageText();
    softAssert
        .assertEquals("Actual Notification Description is not expected", expectedErrorMsg,
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
    takesScreenshot();
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

  @Then("Operator verifies that error toast is displayed on Invoiced Orders Search page:")
  public void operatorVerifiesThatErrorToastIsDisplayedOnInvoicedOrdersSearchPage(String value) {
    verifyErrorMessage(value);
  }
}
