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

  @And("Operator clicks on the submit button")
  public void operatorClicksOnTheSubmitButton() {
    shipperAddressConfigurationPage.clickSubmitFileButton();
    takesScreenshot();
  }

  @Then("Operator verifies upload error message is displayed for error count {string} and total count {string}")
  public void operatorVerifiesUploadErrorMessageIsDisplayed(String errorCount, String totalCount) {
    shipperAddressConfigurationPage.validateUploadErrorMessageIsShown(errorCount, totalCount);
    takesScreenshot();
  }

  @Then("Operator verifies upload error message is displayed for invalid file")
  public void operatorVerifiesUploadErrorMessageIsDisplayedForInvalidFile() {
    shipperAddressConfigurationPage.validateInvalidFileErrorMessageIsShown();
    takesScreenshot();
  }

  @And("Operator clicks on the Download Errors button")
  public void operatorClicksOnTheDownloadErrorsButton() {
    shipperAddressConfigurationPage.clickDownloadErrorsButton();
    takesScreenshot();
  }

  @Then("Operator verifies that the following texts are available on the downloaded file")
  public void operator_verifies_that_the_following_texts_are_available_on_the_downloaded_file(
      List<String> expected) {
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

  @And("Operator uploads csv file: {string} by browsing files")
  public void operatorUploadsCsvFile(String fileName) {
    fileName = resolveValue(fileName);
    String Filepath =
        System.getProperty("user.dir") + "/src/test/resources/csv/firstMile/" + fileName;
    shipperAddressConfigurationPage.fileUpload.sendKeys(Filepath);
    shipperAddressConfigurationPage.clickSubmitFileButton();
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
}



