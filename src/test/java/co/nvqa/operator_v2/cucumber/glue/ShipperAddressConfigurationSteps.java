package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.page.ShipperAddressConfigurationPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.util.List;
import java.util.Map;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.ElementNotInteractableException;
import org.openqa.selenium.InvalidArgumentException;
import org.openqa.selenium.InvalidElementStateException;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.NoSuchWindowException;
import org.openqa.selenium.StaleElementReferenceException;
import org.openqa.selenium.TimeoutException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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
    Runnable selectStatus = () -> {
      shipperAddressConfigurationPage.selectAddressStatus(option);
    };
    doWithRetry(selectStatus, "Operator select Address Status");
    takesScreenshot();
  }

  @SuppressWarnings("unchecked")
  @And("Operator chooses start and end date on Address Creation date using the following data:")
  public void operatorChoosesStartAndEndDateOnAddressCreationDateUsingTheFollowingData(
      Map<String, String> addressCreationDate) {
    addressCreationDate = resolveKeyValues(addressCreationDate);
    String startDate = addressCreationDate.get("From");
    String endDate = addressCreationDate.get("To");
    Runnable selectDates = () -> {
          shipperAddressConfigurationPage.selectDateRange(startDate,
              endDate);
    };
    doWithRetry(selectDates, "Operator chooses start and end date");
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
    String finalFilterValue = filterValue;
    Runnable filterColumn = () -> {
      shipperAddressConfigurationPage.filterBy(filterBy, finalFilterValue);
    };
    doWithRetry(filterColumn, "Operator filter column");
    takesScreenshot();
  }

  @Then("Operator verifies table is filtered {string} based on input in {string} in shipper address page")
  public void operatorVerifiesTableIsFilteredBasedOnInputInShipperAddressPage(String filterBy, String filterValue) {
    filterValue = resolveValue(filterValue);
    String finalFilterValue = filterValue;
    Runnable filterColumn = () -> {
      shipperAddressConfigurationPage.validateFilter(filterBy,finalFilterValue);
    };
    doWithRetry(filterColumn, "Operator verifies table");
    takesScreenshot();
  }

  @Then("Operator verifies table is filtered based on input in {string} in shipper address page")
  public void operatorVerifiesTableIsFilteredBasedOnPickUpTypeValue(String filterValue) {
    filterValue = resolveValue(filterValue);
    String finalFilterValue = filterValue;
    Runnable verifyTable = () -> {
      shipperAddressConfigurationPage.validatePickUpType(finalFilterValue);
    };
    doWithRetry(verifyTable, "Operator verifies table is filtered based on input");
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
    Runnable clickButton = () -> {
      shipperAddressConfigurationPage.clickDownloadAddress();
    };
    doWithRetry(clickButton, "Click on Download Addresses Button");
    takesScreenshot();
  }

  @And("Operator clicks on the edit pickup button")
  public void operatorClicksOnTheEditPickupButton() {
    shipperAddressConfigurationPage.clickEditPickupTypeButton();
    takesScreenshot();
  }

  @And("Operator selects the picktype {string} in the dropdown")
  public void operatorSelectsThePicktypesInTheDropdown(String pickType) {
    shipperAddressConfigurationPage.pickupTypeInEditWindow.selectValueWithoutSearch(pickType);
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

  @Then("Operator verifies success message after updating the pickupType for Address {string}")
  public void operatorVerifiessuccessMessageAfterUpdatingThePickupType(String addressId) {
    addressId = resolveValue(addressId);
    shipperAddressConfigurationPage.validateUploadSuccessMessageAfterPickUpUpdate(addressId);
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

  @And("Operator clicks on the {string} button")
  @SuppressWarnings("unchecked")
  public void Operator_clicks_on_the_button(String buttonText) {
    Runnable clickButton = () -> {
      shipperAddressConfigurationPage.clickButton(buttonText);
    };
    doWithRetry(clickButton, "Click on Button");
    takesScreenshot();
  }

  @And("Operator clicks on the {string} button to upload CVS")
  public void operator_clicks_on_button_to_upload_cvs(String button){
    Runnable clickButton = () -> {
      shipperAddressConfigurationPage.clickUploadCVSButton();
    };
    doWithRetry(clickButton, "Click on Button");
    takesScreenshot();
  }

  @Then("Operator verifies that the following texts are available on the downloaded file {string}")
  public void operator_verifies_that_the_following_texts_are_available_on_the_downloaded_file(
      String filePattern,
      List<String> expected) {
    expected = resolveValues(expected);
    String downloadedCsvFile = shipperAddressConfigurationPage.getLatestDownloadedFilename(
        filePattern);
    expected.forEach(
        (expectedText) -> shipperAddressConfigurationPage.verifyFileDownloadedSuccessfully(
            downloadedCsvFile,
            expectedText, true));
  }

  @Then("Operator verifies header names are available in the downloaded CSV file {string}")
  public void verifyHeaderNamesInDownloadedCsv(String fileName, List<String> headerNames) {
    headerNames = resolveValues(headerNames);
    fileName = resolveValue(fileName);
    pause9s();
    String downloadedCsvFile = shipperAddressConfigurationPage.getLatestDownloadedFilename(
        fileName);
    List<String> actual = shipperAddressConfigurationPage.readDownloadedFile(
        downloadedCsvFile);
    String headers = actual.get(0).toString().replaceAll("^\"|\"$", "").replaceAll("^\"|\"$", "");
    headerNames.forEach((e) -> Assertions.assertThat(headers)
        .as("Validation for Header Names in Downloaded CSV file")
        .contains(e));
  }

  @And("Operator uploads csv file: {string} by browsing files in {string} upload window")
  public void operatorUploadsCsvFile(String fileName, String windowName) {
    fileName = resolveValue(fileName);
    String Filepath =
        System.getProperty("user.dir") + "/src/test/resources/csv/firstMile/" + fileName;
    shipperAddressConfigurationPage.fileUpload.sendKeys(Filepath);
    shipperAddressConfigurationPage.clickSubmitFileButton(windowName, fileName);
    takesScreenshot();
  }

  @And("Operator drag and drop csv file: {string} in {string} upload window")
  public void operatorDragAndDropCsvFile(String fileName, String windowName) {
    fileName = resolveValue(fileName);
    shipperAddressConfigurationPage.dragAndDrop(fileName);
    shipperAddressConfigurationPage.clickSubmitFileButton(windowName, fileName);
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

  @Then("Operator verifies the success message is displayed on uploading the pickup type file {string}")
  public void Operator_verifies_the_success_message_is_displayed_on_uploading_the_pickup_type_file(
      String count) {
    shipperAddressConfigurationPage.validateConfigurePickupTypeUploadSuccessMessage(count);
    takesScreenshot();
  }

  @Then("Verify that csv file is downloaded with filename: {string}")
  public void verifyThatCsvFileIsDownloadedWithFilename(String filename) {
    Runnable verifyDownloadedFilename = () -> {
      shipperAddressConfigurationPage.verifyThatCsvFileIsDownloadedWithFilename(filename);
    };
    doWithRetry(verifyDownloadedFilename, "Verify Downloaded Filename");
    takesScreenshot();
  }

  @And("Operator clicks on the {string} button to upload CSV file")
  public void operatorClicksOnTheButtonToUploadCSVFile(String buttonText) {
    Runnable clickButton = () -> {
      shipperAddressConfigurationPage.clickButtonToUploadCSV(buttonText);
    };
    doWithRetry(clickButton, "Click on Button");
    takesScreenshot();
  }

  @When("Operator select address from the list with Id {string}")
  public void operatorSelectMultipleAddressesThatHasNoGroupUsingBelowData(String addressId) {
    addressId = resolveValue(addressId);
    String finalAddressId = addressId;
    Runnable selectAddress = () -> {
      shipperAddressConfigurationPage.clickOnAddressToGroup(finalAddressId);
    };
    doWithRetry(selectAddress, "Select Address from List");
  }

  @When("Operator select radio checkbox for address from the list with Id {string}")
  public void operatorSelectRadioThatHasNoGroupUsingBelowData(String addressId) {
    addressId = resolveValue(addressId);
    String finalAddressId = addressId;
    Runnable clickRadioBox = () -> {
      shipperAddressConfigurationPage.clickOnRadioCheckBoxForAddressToGroup(finalAddressId);
    };
    doWithRetry(clickRadioBox, "Click Radio Box");
  }

  @Then("Operator verify modal with below data:")
  public void operatorVerifyModalWithBelowData(Map<String, String> data) {
    data = resolveKeyValues(data);
    String firstTitle = data.get("title");
    String secondTitle = data.get("title2");
    String pickupAddress = data.get("pickup_Address");
    String firstAddress = data.get("address1");
    Runnable verifyModal = () -> {
      shipperAddressConfigurationPage.verifyGroupAddressModal(firstTitle, secondTitle, pickupAddress, firstAddress);
    };
    doWithRetry(verifyModal, "verify Modal");
    takesScreenshot();
  }

  @Then("Operator verify current group text with below data:")
  public void operatorVerifyCurrentGroupModalWithBelowData(Map<String, String> data) {
    data = resolveKeyValues(data);
    String firstAddress = data.get("address1");
    Runnable verifyCurrentText = () -> {
      shipperAddressConfigurationPage.verifyCurrentGroupAddressModal(firstAddress);
    };
    doWithRetry(verifyCurrentText, "verify Current Text");
    takesScreenshot();
  }

  @Then("Operator verify success message is displayed")
  public void operatorVerifySuccessMessageIsDisplayed() {
   shipperAddressConfigurationPage.verifySuccessMessage();
  }

  @Then("Operator verify {string} message is displayed")
  public void operatorVerifySuccessMessageIsDisplayed(String message) {
    message = resolveValue(message);
    shipperAddressConfigurationPage.verifyMessage(message);
  }

  @Then("Verify that the Group Address for Id {string} is showing with text {string}")
  public void verifyThatTheGroupAddressForIdIsShowingWithText(String addressId, String addressText) {
    addressId = resolveValue(addressId);
    shipperAddressConfigurationPage.verifyGroupAddressIsShown(addressId,addressText);
    takesScreenshot();
  }
}