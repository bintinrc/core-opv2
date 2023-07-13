package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.page.InvoicedOrdersSearchPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.util.List;
import java.util.Map;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.openqa.selenium.Keys;
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

  @When("Search Invoiced Orders page is loaded")
  public void searchInvoicedOrdersPageIsLoaded() {
    invoicedOrdersSearchPage.switchToIframe();
    invoicedOrdersSearchPage.waitUntilLoaded();
  }

  @And("Operator upload a CSV file with below order ids on Invoiced Orders Search Page")
  public void operatorUploadACSVFileWithBelowOrderIdsOnInvoicedOrdersSearchPage(
      List<String> trackingIds) {
    trackingIds = resolveValues(trackingIds);
    File csvFile = StandardTestUtils.createFile(filename, String.join("\n", trackingIds));
    String absolutePath = csvFile.getAbsolutePath();
    LOGGER.info("Path of the created file : " + absolutePath);
    invoicedOrdersSearchPage.uploadFile(absolutePath);
    invoicedOrdersSearchPage.antDotSpinner.waitUntilInvisible();
    takesScreenshot();
  }

  @And("Operator clicks Search Invoiced Order button")
  public void operatorClicksSearchInvoicedOrderButtonAndWait() {
    invoicedOrdersSearchPage.searchInvoiceOrdersButton.click();
    invoicedOrdersSearchPage.antDotSpinner.waitUntilInvisible();
    takesScreenshot();
  }

  @And("Operator verifies below tracking ID\\(s) and creation time is displayed")
  public void operatorVerifiesBelowTrackingIDSAndCreationTimeIsDisplayed(List<String> trackingIds) {
    trackingIds = resolveValues(trackingIds);
    invoicedOrdersSearchPage.noDataFound.waitUntilInvisible();
    String actualTrackingIdValue = invoicedOrdersSearchPage.trackingIdOutput.getText();
    String actualCreationTimeValue = invoicedOrdersSearchPage.createdAtOutput.getText();
    Assertions.assertThat(actualTrackingIdValue).as("TrackingId is expected ")
        .isEqualTo(trackingIds.get(0));
    Assertions.assertThat(actualCreationTimeValue).as("Creation time is expected")
        .startsWith(DateUtil.getTodayDate_YYYY_MM_DD());
  }

  @And("Operator verifies No Data is displayed in the invoiced orders search page")
  public void operatorVerifiesNoResultsFoundIsDisplayed() {
    invoicedOrdersSearchPage.noDataFound.waitUntilVisible(3);
    Assertions.assertThat(invoicedOrdersSearchPage.noDataFound.isDisplayed())
        .as("No Results Found Message is not displayed").isTrue();
  }

  @Then("Operator uploads a PDF on Invoiced Orders Search Page and verifies error message as below:")
  public void operatorUploadsAPDFOnInvoicedOrdersSearchPageAndVerifiesThatAnyOtherFileExceptCsvIsNotAllowed(
      Map<String, String> dataTableAsMap) {
    Map<String, String> map = resolveKeyValues(dataTableAsMap);
    String pdfFileName = "invalid-upload.pdf";
    File pdfFile = StandardTestUtils.createFile(pdfFileName, "TEST");
    invoicedOrdersSearchPage.uploadFile(pdfFile.getAbsolutePath());
    String expectedNotifMsgTop = map.get("top");
    String expectedNotifDescription = map.get("bottom");
    verifyErrorMessage(expectedNotifMsgTop, expectedNotifDescription);
  }

  @Then("Operator uploads an invalid CSV on Invoiced Orders Search Page CSV and verifies error message as below:")
  public void operatorUploadsAnInvalidOnInvoicedOrdersSearchPageCSVAndVerifiesErrorMessage(
      Map<String, String> dataTableAsMap) {
    Map<String, String> map = resolveKeyValues(dataTableAsMap);
    String csvFileName = "upload.csv";
    File csvFile = StandardTestUtils.createFile(csvFileName, "TEST1 , TEST2");
    invoicedOrdersSearchPage.uploadFile(csvFile.getAbsolutePath());
    String expectedNotifMsgTop = map.get("top");
    String expectedNotifDescription = map.get("bottom");
    verifyErrorMessage(expectedNotifMsgTop, expectedNotifDescription);
  }

  @Then("Operator uploads an empty CSV on Invoiced Orders Search Page CSV and verifies error message as below:")
  public void operatorUploadsAnEmptyCSVOnInvoicedOrdersSearchPageCSVAndVerifiesErrorMessage(
      Map<String, String> dataTableAsMap) {
    Map<String, String> map = resolveKeyValues(dataTableAsMap);
    String csvFileName = "upload.csv";
    File csvFile = StandardTestUtils.createFile(csvFileName, "");
    invoicedOrdersSearchPage.uploadFile(csvFile.getAbsolutePath());
    String expectedNotifMsgTop = map.get("top");
    String expectedNotifDescription = map.get("bottom");
    verifyErrorMessage(expectedNotifMsgTop, expectedNotifDescription);
  }

  private void verifyErrorMessage(String expectedNotifMsgTop, String expectedNotifDescription) {
    String actualNotifMsgTop = invoicedOrdersSearchPage.getNotificationMessageText();
    String actualNotifDescription = invoicedOrdersSearchPage.getNotificationMessageDescText();
    Assertions.assertThat(actualNotifMsgTop)
        .as("Actual Notification is expected").isEqualTo(expectedNotifMsgTop);
    Assertions.assertThat(actualNotifDescription)
        .as("Actual Notification Description is expected").isEqualTo(expectedNotifDescription);
  }

  @When("Operator clicks in Enter Tracking ID\\(s) tab")
  public void operatorClicksInEnterTrackingIDSTab() {
    invoicedOrdersSearchPage.trackingIDsButton.waitUntilVisible();
    invoicedOrdersSearchPage.trackingIDsButton.click();
  }

  @And("Operator enters {string} tracking id on Invoiced Orders Search Page")
  public void operatorEntersTrackingIdOnInvoicedOrdersSearchPage(String trackingId) {
    trackingId = resolveValue(trackingId);
    invoicedOrdersSearchPage.trackingIdInput.sendKeys(trackingId);
    invoicedOrdersSearchPage.trackingIdInput.sendKeys(Keys.ENTER);
  }

  @And("Operator verifies the order count is correctly displayed as {int}")
  public void operatorVerifiesTheOrderCountIsCorrectlyDisplayed(int count) {
    invoicedOrdersSearchPage.orderCount.waitUntilVisible();
    String trackingIdCount = invoicedOrdersSearchPage.orderCount.getText();
    Assertions.assertThat(trackingIdCount)
        .as("Tracking IDs from CSV Count is expected").isEqualTo(String.valueOf(count));
  }


  @And("Operator clicks on Upload CSV tab")
  public void operatorClicksOnUploadCSVTab() {
    invoicedOrdersSearchPage.uploadCsvButton.click();
  }

  @And("Operator clicks Refresh button")
  public void operatorClicksRefreshButton() {
    invoicedOrdersSearchPage.refreshBtn.click();
    invoicedOrdersSearchPage.goBackToFilterBtn.waitUntilVisible();
  }

  @And("Operator clicks Go Back To Filter button")
  public void operatorClicksGoBackToFilterButton() {
    invoicedOrdersSearchPage.goBackToFilterBtn.click();
  }

  @And("Operator clicks Search Invoiced Order button without a tracking ID")
  public void operatorClicksSearchInvoicedOrderButtonWithoutATrackingID() {
    invoicedOrdersSearchPage.searchInvoiceOrdersButton.click();
  }

  @Then("Operator verifies message {string} is displayed")
  public void operatorVerifiesMessageIsDisplayed(String expectedWarningMsg) {
    String actualWarningMsg = invoicedOrdersSearchPage.warningText.getText();
    Assertions.assertThat(actualWarningMsg).as("Warning msg is displayed")
        .isEqualTo(expectedWarningMsg);
  }

  @Then("Operator verifies that error toast is displayed on Invoiced Orders Search page:")
  public void operatorVerifiesThatErrorToastDisplayedOnInvoicedOrdersSearchPage(
      Map<String, String> mapOfData) {
    String errorTitle = mapOfData.get("top");
    String errorMessage = mapOfData.get("bottom");

    retryIfAssertionErrorOccurred(
        () -> Assertions.assertThat(
                invoicedOrdersSearchPage.noticeNotifications.get(0).message.getText())
            .as("Notifications are available").isNotEmpty(), "Get Notifications",
        500, 3);
    AntNotification notification = invoicedOrdersSearchPage.noticeNotifications.get(0);
    SoftAssertions softAssertions = new SoftAssertions();
    softAssertions.assertThat(notification.message.getText()).as("Toast top text is correct")
        .isEqualTo(errorTitle);
    softAssertions.assertThat(notification.description.getText()).as("Toast bottom text is correct")
        .contains(errorMessage);
    softAssertions.assertAll();
  }


}
