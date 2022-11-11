package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.selenium.page.ShipperAddressConfigurationPage;
import co.nvqa.operator_v2.selenium.page.StationRouteMonitoringPage;
import co.nvqa.operator_v2.selenium.page.StationRouteMonitoringPage.InvalidFailedWP;
import co.nvqa.operator_v2.selenium.page.StationRouteMonitoringPage.StationRouteMonitoring;
import io.cucumber.datatable.DataTable;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.awt.AWTException;
import java.awt.Robot;
import java.awt.Toolkit;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.StringSelection;
import java.awt.event.KeyEvent;
import java.io.File;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import org.assertj.core.api.Assertions;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.ElementNotInteractableException;
import org.openqa.selenium.InvalidArgumentException;
import org.openqa.selenium.InvalidElementStateException;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.NoSuchWindowException;
import org.openqa.selenium.StaleElementReferenceException;
import org.openqa.selenium.TimeoutException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.operator_v2.selenium.page.ShipperAddressConfigurationPage.COLUMN_NAME;
import static co.nvqa.operator_v2.selenium.page.ShipperAddressConfigurationPage.CSV_DOWNLOADED_FILENAME_PATTERN;
import static co.nvqa.operator_v2.selenium.page.ShipperAddressConfigurationPage.DOWNLOADED_CSV_FILENAME;


@SuppressWarnings("unused")
@ScenarioScoped
public class ShipperAddressConfigurationSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(
      ShipperAddressConfigurationSteps.class);
  private ShipperAddressConfigurationPage shipperAddressConfigurationPage;

  public ShipperAddressConfigurationSteps() {
  }

  @Override
  public void init() {
    shipperAddressConfigurationPage = new ShipperAddressConfigurationPage(getWebDriver());
  }

  @When("Operator loads Shipper Address Configuration page")
  public void operator_loads_shipper_address_configuration_page() {
    shipperAddressConfigurationPage.loadShipperAddressConfigurationPage();
  }

  @SuppressWarnings("unchecked")
  @And("Operator selects {string} in the Address Status dropdown")
  public void operatorSelectsInTheAddressStatusDropdown(String option) {
    retryIfExpectedExceptionOccurred(
        () -> shipperAddressConfigurationPage.selectAddressStatus(option),
        null, LOGGER::warn, DEFAULT_DELAY_ON_RETRY_IN_MILLISECONDS, 3,
        NoSuchElementException.class, NoSuchWindowException.class,
        ElementNotInteractableException.class, ElementNotInteractableException.class,
        TimeoutException.class, StaleElementReferenceException.class,
        InvalidElementStateException.class, InvalidArgumentException.class);
    takesScreenshot();
  }

  @SuppressWarnings("unchecked")
  @And("Operator chooses start and end date on Address Creation date using the following data:")
  public void operatorChoosesStartAndEndDateOnAddressCreationDateUsingTheFollowingData(
      Map<String, String> addressCreationDate) {
    addressCreationDate = resolveKeyValues(addressCreationDate);
    String startDate = addressCreationDate.get("From");
    String endDate = addressCreationDate.get("To");

    retryIfExpectedExceptionOccurred(
        () -> shipperAddressConfigurationPage.selectDateRange(startDate,
            endDate),
        null, LOGGER::warn, DEFAULT_DELAY_ON_RETRY_IN_MILLISECONDS, 3,
        NoSuchElementException.class, NoSuchWindowException.class,
        ElementNotInteractableException.class, ElementNotInteractableException.class,
        TimeoutException.class, StaleElementReferenceException.class,
        InvalidElementStateException.class, InvalidArgumentException.class);
    takesScreenshot();
  }


  @And("Operator selects  following picktypes in the dropdown:")
  public void operatorSelectsFollowingPicktypesInTheDropdown(List<String> pickType) {
    shipperAddressConfigurationPage.selectPickupType(pickType);

  }

  @And("Operator clicks on the load selection button")
  public void operatorClicksOnTheLoadSelectionButton() {
    shipperAddressConfigurationPage.clickLoadSelection();
  }

  @Then("Operator filter the column {string} with {string}")
  public void operator_Searches_By(String filterBy, String filterValue) {
    filterValue = resolveValue(filterValue);
    shipperAddressConfigurationPage.filterBy(filterBy, filterValue);
    takesScreenshot();
  }

  @Then("Operator verifies table is filtered {string} based on input in {string} in shipper address page")
  public void operatorVerifiesTableIsFilteredBasedOnInputInShipperAddresPage(String filterBy,
      String filterValue) {
    filterValue = resolveValue(filterValue);
    shipperAddressConfigurationPage.validateFilter(filterBy, filterValue);
    takesScreenshot();
  }

  @Then("Operator verifies that green check mark icon is shown under the Lat Long")
  public void operatorVerifiesGreenCheckMarkIconIsShownUndertheLatLong() {
    shipperAddressConfigurationPage.validateGreenCheckMark();
    takesScreenshot();
  }

  @Then("Operator verifies that green check mark icon is not shown under the Lat Long")
  public void operatorVerifiesGreenCheckMarkIconIsNotShownUndertheLatLong() {
    shipperAddressConfigurationPage.validateGreenCheckMarkNotDisplayed();
    takesScreenshot();
  }

  @And("Operator clicks on the Download Addresses button")
  public void operatorClicksOnTheDownloadAddressesButton() {
    shipperAddressConfigurationPage.clickDownloadAddress();
    takesScreenshot();

  }

  @And("Operator clicks on the Update Addresses Lat Long button")
  public void operatorClicksOnTheUpdateAddressesLatLongButton() {
    shipperAddressConfigurationPage.clickUpdateAddressesLatLongButton();
    takesScreenshot();
  }

  @And("Operator clicks on the Download CSV Template button")
  public void operatorClicksOnTheDownloadCSVTemplateButton() {
    shipperAddressConfigurationPage.clickDownloadCSVTemplateButton();
    takesScreenshot();
  }

  @Then("Operator verifies upload error message is displayed for error count {string} and total count {string}")
  public void operatorVerifiesUploadErrorMessageIsDisplayed(String errorCount, String totalCount) {
    shipperAddressConfigurationPage.validateUploadErrorMessageIsShown(errorCount, totalCount);
    takesScreenshot();
  }

  @Then("Operator verifies upload success message is displayed for success count {string}")
  public void operatorVerifiesUploadSuccessMessageIsDisplayed(String successCount) {
    shipperAddressConfigurationPage.validateUploadSuccessMessageIsShown(successCount);
    takesScreenshot();
  }

  @Then("Operator verifies upload error message is displayed for invalid file")
  public void operatorVerifiesUploadErrorMessageIsDisplayedForInvalidFile() {
    shipperAddressConfigurationPage.validateInvalidFileErrorMessageIsShown();
    takesScreenshot();
  }

  @Then("Operator verifies upload error message is displayed for invalid formatted file")
  public void operatorVerifiesUploadErrorMessageIsDisplayedForInvalidFormattedFile() {
    shipperAddressConfigurationPage.validateInvalidFormattedFileErrorMessageIsShown();
    takesScreenshot();
  }

  @And("Operator clicks on the Download Errors button")
  public void operatorClicksOnTheDownloadErrorsButton() {
    shipperAddressConfigurationPage.clickDownloadErrorsButton();
    takesScreenshot();
  }

  @And("Operator closes modal popup window")
  public void operatorClicksOnCloseModalButton() {
    shipperAddressConfigurationPage.closeModal();
    takesScreenshot();
  }

  @SuppressWarnings("unchecked")
  @And("Operator clicks on the {string} button")
  public void Operator_clicks_on_the_button(String buttonText) {
    retryIfExpectedExceptionOccurred(
        () -> shipperAddressConfigurationPage.clickButton(buttonText),
        null, LOGGER::warn, DEFAULT_DELAY_ON_RETRY_IN_MILLISECONDS, 3,
        NoSuchElementException.class, NoSuchWindowException.class,
        ElementNotInteractableException.class, ElementNotInteractableException.class,
        TimeoutException.class, StaleElementReferenceException.class,
        InvalidElementStateException.class, InvalidArgumentException.class);
    takesScreenshot();
  }

  @Then("Operator verifies that the following texts are available on the downloaded file")
  public void operator_verifies_that_the_following_texts_are_available_on_the_downloaded_file(
      List<String> expected) {
    expected = resolveValues(expected);
    String downloadedCsvFile = shipperAddressConfigurationPage.getLatestDownloadedFilename(
        CSV_DOWNLOADED_FILENAME_PATTERN);
    expected.forEach((expectedText) -> {
      shipperAddressConfigurationPage.verifyFileDownloadedSuccessfully(downloadedCsvFile,
          expectedText, true);
    });
  }

  @Then("Operator verifies header names are available in the downloaded CSV file {string}")
  public void verifyHeaderNamesInDownloadedCsv(String fileName, List<String> headerNames) {
    headerNames = resolveValues(headerNames);
    fileName = resolveValue(fileName);
    pause5s();
    String downloadedCsvFile = shipperAddressConfigurationPage.getLatestDownloadedFilename(
        fileName);
    List<String> actual = shipperAddressConfigurationPage.readDownloadedFile(
        downloadedCsvFile);
    String headers = actual.get(0).toString().replaceAll("^\"|\"$", "").replaceAll("^\"|\"$", "");
    headerNames.forEach((e) -> {
      Assertions.assertThat(headers)
          .as("Validation for Header Names in Downloaded CSV file")
          .contains(e);
    });

  }

  @And("Operator uploads csv file: {string} by browsing files in {string} upload window")
  public void operatorUploadsCsvFile(String fileName, String windowName) {
    fileName = resolveValue(fileName);
    String Filepath =
        System.getProperty("user.dir") + "/src/test/resources/csv/firstMile/" + fileName;
    shipperAddressConfigurationPage.fileUpload.sendKeys(Filepath);
    shipperAddressConfigurationPage.clickSubmitFileButton();
    String titlexpath = f("//*[text()='%s']", windowName);
    shipperAddressConfigurationPage.waitUntilInvisibilityOfElementLocated(
        getWebDriver().findElement(By.xpath(titlexpath)));
    takesScreenshot();
  }

  @And("Operator drag and drop csv file: {string}")
  public void operatorDragAndDropCsvFile(String fileName) {
    fileName = resolveValue(fileName);
    String Filepath =
        System.getProperty("user.dir") + "/src/test/resources/csv/firstMile/" + fileName;
    File file = new File(Filepath);
    shipperAddressConfigurationPage.dragAndDrop(file,
        shipperAddressConfigurationPage.fileUpload.getWebElement());
    takesScreenshot();

  }

  @Then("Operator updates the CSV file with below data:")
  public void operator_updates_the_csv_file_with_below_data(Map<String, String> data) {
    data = resolveKeyValues(data);
    int columnIndex = Integer.parseInt(data.get("columnIndex"));
    int rowIndex = Integer.parseInt(data.get("rowIndex"));
    String fileName = data.get("fileName");
    String value = data.get("value");
    String Filepath =
        System.getProperty("user.dir") + "/src/test/resources/csv/firstMile/" + fileName;
    File file = new File(Filepath);
    shipperAddressConfigurationPage.updateCSVFile(Filepath, columnIndex, rowIndex, value);

  }

  @Then("Operator verifies page url ends with {string}")
  public void operatorVerifiesPageUrlEndsWith(String expectedTest) {
    shipperAddressConfigurationPage.VerificationOfURL(expectedTest);
  }

  @Then("Operator verifies the success message is displayed on uploading the file : {string}")
  public void Operator_verifies_the_success_message_is_displayed_on_uploading_the_ile(
      String hubName) {
    shipperAddressConfigurationPage.validateConfigurePickupTypeUploadSuccessMessage(hubName);
    takesScreenshot();
  }

}



