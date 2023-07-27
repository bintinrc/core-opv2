package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntDateRangePicker;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.selenium.elements.ant.v4.AntSelect;
import com.opencsv.CSVReader;
import com.opencsv.CSVWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindAll;
import org.openqa.selenium.support.FindBy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ShipperAddressConfigurationPage extends OperatorV2SimplePage {

  private static final String MODAL_TABLE_SEARCH_BY_TABLE_NAME_XPATH = "//div[text()='%s']/ancestor::div[starts-with(@class,'TableHeader')]//input";
  private static final String MODAL_TABLE_SEARCH_BY_TABLE_CHECKBOX = "//div[text()='%s']/ancestor::div[starts-with(@class,'TableHeader')]//span[@role='button']";
  private static final String TABLE_FIRST_ROW_VALUE_BY_COLUMN = "//div[@class='BaseTable__row-cell' and @data-datakey='%s']//*[name()='span'or 'div']";
  public static final String COLUMN_NAME = "Suggested Address URL";
  private static final String MODAL_TABLE_SEARCH_BY_HEADER_NAME_XPATH = "//div[@data-datakey='%s']";
  private static final String TABLE_FIRST_ROW_VALUE_PICKUP_TYPE_COLUMN = "//div[@data-datakey='formatted_pickup_type']";
  public static final String UPLOAD_ERROR_MESSAGE = "//span[text()='%s out of %s addresses']/following-sibling::span[text()=' that could not be updated.']";
  public static final String UPLOAD_SUCCESS_MESSAGE = "//span[text()='%s Shipper lat long has been updated!']";
  public static final String PICKUP_TYPE_UPDATE_SUCCESS_MESSAGE = "//span[text()='Address ID %s pickup type has been updated!']";
  public static final String CHECKBOX_FOE_ADDRESS_TO_BE_GROUPED = "//input[@data-testid='group-address-table-checkbox-%s']";

  public static final String GROUP_ADDRESS_VERIFY_MODAL = "//span[contains(text(), '%s')]";

  public static final String BUTTON = "//span[text()='%s']/parent::button";
  public static final String CONFIGURE_PICKUP_TYPE_BUTTON = "//button[@data-testid='shipper-address.menu.pickupTypeButton']";
  public static final String SAVE_CHANGES_BUTTON = "//button[@data-testid='shipper-address.edit-pickup-type.save-changes']";
  public static final String GROUP_ADDRESSES_BUTTON = "//button[@data-testid='shipper-address.menu.groupAddressesButton']";
  public static final String GROUP_ADDRESS_BUTTON = "//button[@data-testid='shipper-address.group-addresses.group-address']";
  public static final String UPLOAD_CSV_BUTTON = "//button[@data-testid='shipper-address.results.upload-csv-button']";
  public static final String UPDATE_LAT_LONG_TYPE_BUTTON = "//button[@data-testid='shipper-address.menu.latLongButton']";
  public static final String UPLOAD_CVS_CONFIGURE_PICKUP_TYPE = "//button[@data-testid='shipper-address.results.upload-csv-button']";
  public static final String CONFIGURE_PICKUP_TYPE_FILE_UPLOAD_SUCCESS_MESSAGE = "//span[text()='%s addresses pick up has been updated!']";
  public static final String FILENAME_IN_UPLOAD_WINDOW = "//span[text()='%s']";


  private static final Logger LOGGER = LoggerFactory.getLogger(
      ShipperAddressConfigurationPage.class);

  public ShipperAddressConfigurationPage(WebDriver webDriver) {
    super(webDriver);
  }

  @FindBy(css = "iframe")
  private List<PageElement> pageFrame;


  @FindBy(css = "div.ant-picker-range")
  public AntDateRangePicker addressCreationDate;

  @FindBy(xpath = "//span[text()='Clear Selection']")
  public PageElement clearSelection;

  @FindBy(xpath = "//span[text()='Load Selection']")
  public PageElement loadSelection;

  @FindBy(xpath = "//span[text()='Address Status']/parent::div//div[@class='ant-select-selector']")
  public AntSelect addressStatusSelect;

  @FindBy(xpath = "//div[@class='BaseTable__row-cell' and @data-datakey='lat_long']//*[local-name()='svg' and contains (@class,'GaComponent__StyledAxleIconComponent')]")
  public PageElement greencheckMark;

  @FindAll(@FindBy(xpath = "//div[@class='BaseTable__row-cell' and @data-datakey='lat_long']//*[local-name()='svg' and contains (@class,'GaComponent__StyledAxleIconComponent')]"))
  private List<PageElement> greencheckMarks;

  @FindBy(xpath = "//button[@data-pa-action='Download Addresses']")
  public PageElement downloadAddressButton;

  @FindBy(xpath = "//span[text()='Update Addresses Lat Long']/parent::button")
  public PageElement updateAddressesLatLongButton;

  @FindBy(xpath = "//span[text()='Configure Pickup Type']/parent::button")
  public PageElement configurePickupTypeButton;

  @FindBy(xpath = "//span[text()='Download CSV Template']/parent::button")
  public PageElement downloadCSVTemplateButton;

  @FindBy(xpath = "//div[text()='Drag and drop CSV file here']")
  public PageElement dragAndDropPath;

  @FindBy(xpath = "//input[@type='file']")
  public PageElement fileUpload;

  @FindAll(@FindBy(xpath = "//span[text()='Submit File']//parent::button"))
  private List<PageElement> submitFileButton;

  @FindBy(xpath = "//span[text()='Please review the errors and upload a valid file.']")
  public PageElement errormessage2;

  @FindBy(xpath = "//span[text()='Download Errors']/parent::button")
  public PageElement downloadErrorsButton;

  @FindBy(xpath = "//div[text()='Please upload a file with valid input!']")
  public PageElement invalidFileErrorMessage;

  @FindBy(xpath = "//div[text()='Please upload a valid formatted file!']")
  public PageElement invalidFormatFileErrorMessage;

  @FindBy(xpath = "//button[@aria-label='Close']")
  public PageElement closePopModal;

  @FindBy(xpath = "//*[@id='address-pickup-type-drop-down']//div[@class='ant-select-selector']")
  public AntSelect pickupType;

  @FindBy(xpath = "//*[@class='ant-select-clear']")
  public PageElement clearDropdown;

  @FindBy(xpath = "//button[@data-pa-label='Edit Pickup Type']")
  public PageElement editPickUpTypeButton;

  @FindBy(xpath = "//div[contains(text(),'Pickup Type')]/ancestor::div[contains(@class,'ant')]//div[@class='ant-select-selector']")
  public AntSelect3 pickupTypeInEditWindow;


  public void switchToShipperAddressConfigurationFrame() {
    if (pageFrame.size() > 0) {
      waitUntilVisibilityOfElementLocated(pageFrame.get(0).getWebElement(), 15);
      getWebDriver().switchTo().frame(pageFrame.get(0).getWebElement());
    }
  }

  // This method can be removed once redirection to Shipper Address is added in operator V2 menu
  public void loadShipperAddressConfigurationPage() {
    getWebDriver().get("https://operatorv2-qa.ninjavan.co/#/sg/shipper-address");
  }


  public void clickLoadSelection() {
    waitUntilVisibilityOfElementLocated(loadSelection.getWebElement());
    loadSelection.click();
  }

  public void clickClearSelection() {
    waitUntilVisibilityOfElementLocated(clearSelection.getWebElement());
    clearSelection.click();
  }

  public void selectDateRange(String fromDate, String toDate) {
    switchToShipperAddressConfigurationFrame();
    waitUntilVisibilityOfElementLocated(addressCreationDate.getWebElement());
    addressCreationDate.clearAndSetFromDate(fromDate);
    addressCreationDate.clearAndSetToDate(toDate);
  }

  public void selectAddressStatus(String addressStatus) {
    switchToShipperAddressConfigurationFrame();
    waitUntilVisibilityOfElementLocated(addressStatusSelect.getWebElement());
    addressStatusSelect.selectValue(addressStatus);

  }

  public void selectPickupType(List<String> pickuptype) {
    switchToShipperAddressConfigurationFrame();
    clearDropdown.click();
    pickupType.selectValues(pickuptype);
  }

  public void filterBy(String filterCriteria, String filterValue) {
    switchToShipperAddressConfigurationFrame();
    filterValue(filterCriteria, filterValue);
  }

  public void filterValue(String filterName, String filterValue) {
    String stationNameSearchXpath = f(MODAL_TABLE_SEARCH_BY_TABLE_NAME_XPATH, filterName);
    String checkBoxXpath = f(MODAL_TABLE_SEARCH_BY_TABLE_CHECKBOX , filterName);
    WebElement searchBox = getWebDriver().findElement(By.xpath(stationNameSearchXpath));
    WebElement checkBox = getWebDriver().findElement(By.xpath(checkBoxXpath));
    waitUntilVisibilityOfElementLocated(searchBox);
    if(checkBox.isDisplayed()) {
      checkBox.click();
    }
    searchBox.sendKeys(Keys.chord(Keys.CONTROL, "a", Keys.DELETE));
    searchBox.sendKeys(filterValue);
  }

  public void validateFilter(String filterName , String expectedValue) {
    String firstMileNameSearchXpath = f(MODAL_TABLE_SEARCH_BY_HEADER_NAME_XPATH, filterName);
    pause5s();
    String actualValue = getWebDriver().findElement(By.xpath(firstMileNameSearchXpath)).getText();
    Assertions.assertThat(actualValue).as("Validation of Column Value")
        .isEqualToIgnoringCase(expectedValue);
  }

  public void validatePickUpType(String expectedValue) {
    String valueXpath = TABLE_FIRST_ROW_VALUE_PICKUP_TYPE_COLUMN;
    pause5s();
    String actualValue = getWebDriver().findElement(By.xpath(valueXpath)).getText();
    Assertions.assertThat(actualValue).as("Validation of Column Value")
        .isEqualToIgnoringCase(expectedValue);
  }

  public void validateGreenCheckMark() {
    waitUntilVisibilityOfElementLocated(greencheckMark.getWebElement());
    Assertions.assertThat(greencheckMark.isDisplayed()).isTrue();
  }

  public void validateGreenCheckMarkNotDisplayed() {
    Assertions.assertThat(greencheckMarks).isEmpty();
  }

  public void clickDownloadAddress() {
    pause2s();
    waitUntilVisibilityOfElementLocated(downloadAddressButton.getWebElement());
    downloadAddressButton.click();
  }

  public void clickUpdateAddressesLatLongButton() {
    waitUntilVisibilityOfElementLocated(updateAddressesLatLongButton.getWebElement());
    updateAddressesLatLongButton.click();
  }

  public void clickConfigurePickupTypeButton() {
    waitUntilVisibilityOfElementLocated(configurePickupTypeButton.getWebElement());
    configurePickupTypeButton.click();
  }

  public void clickDownloadCSVTemplateButton() {
    waitUntilVisibilityOfElementLocated(downloadCSVTemplateButton.getWebElement());
    downloadCSVTemplateButton.click();
  }

  public void clickSubmitFileButton(String windowName, String fileName) {
    if (submitFileButton.size() > 0) {
      String uploadedFileNamexpath = f(FILENAME_IN_UPLOAD_WINDOW, fileName);
      Assertions.assertThat(
              getWebDriver().findElement(By.xpath(uploadedFileNamexpath)).isDisplayed())
          .as("Validation for uploaded file name in the upload Window")
          .isTrue();
      waitUntilVisibilityOfElementLocated(submitFileButton.get(0).getWebElement());
      submitFileButton.get(0).click();
      //waitUntilInvisibilityOfElementLocated(submitFileButton.get(0).getWebElement());
    }
  }

  public void validateUploadErrorMessageIsShown(String errorCount, String totalCount) {
    pause5s();
    String errorXpath = f(UPLOAD_ERROR_MESSAGE, errorCount, totalCount);
    WebElement errorMessage = getWebDriver().findElement(By.xpath(errorXpath));
    waitUntilVisibilityOfElementLocated(errorMessage);
    Assertions.assertThat(errorMessage.isDisplayed()).as("Validation for Upload error message")
        .isTrue();
    Assertions.assertThat(errormessage2.isDisplayed()).as("Validation for Upload error message")
        .isTrue();
  }

  public void validateUploadSuccessMessageIsShown(String errorCount) {
    waitUntilVisibilityOfElementLocated(getWebDriver().findElement(By.xpath(f(UPLOAD_SUCCESS_MESSAGE, errorCount))));
    String errorXpath = f(UPLOAD_SUCCESS_MESSAGE, errorCount);
    WebElement successMessage = getWebDriver().findElement(By.xpath(errorXpath));
    Assertions.assertThat(successMessage.isDisplayed()).as("Validation for Upload Success message")
        .isTrue();
  }

  public void validateUploadSuccessMessageAfterPickUpUpdate(String addressId) {
    String SuccessMessageXpath = f(PICKUP_TYPE_UPDATE_SUCCESS_MESSAGE, addressId);
    waitUntilVisibilityOfElementLocated(getWebDriver().findElement(By.xpath(SuccessMessageXpath)));
    WebElement successMessage = getWebDriver().findElement(By.xpath(SuccessMessageXpath));
    Assertions.assertThat(successMessage.isDisplayed())
        .as("Validation for Pick Type update Success message")
        .isTrue();
  }

  public void validateConfigurePickupTypeUploadSuccessMessage(String count) {
    String SuccessMessageXpath = f(CONFIGURE_PICKUP_TYPE_FILE_UPLOAD_SUCCESS_MESSAGE, count);
    waitUntilVisibilityOfElementLocated(getWebDriver().findElement(By.xpath(SuccessMessageXpath)));
    WebElement successMessage = getWebDriver().findElement(By.xpath(SuccessMessageXpath));
    Assertions.assertThat(successMessage.isDisplayed())
        .as("Validation for Pickup type Upload Success message")
        .isTrue();
  }

  public void clickButton(String buttonText) {
    String elementXpath = null;
    switchToShipperAddressConfigurationFrame();
    if(buttonText.contains("Configure Pickup Type")){
      elementXpath = f(CONFIGURE_PICKUP_TYPE_BUTTON, buttonText);
    }
    if(buttonText.contains("Update Lat Long")){
      elementXpath = f(UPDATE_LAT_LONG_TYPE_BUTTON, buttonText);
    }
    if(buttonText.contains("Update Addresses Lat Long")){
      elementXpath = f(UPDATE_LAT_LONG_TYPE_BUTTON, buttonText);
    }
    if(buttonText.contains("Save Changes")){
      elementXpath = f(SAVE_CHANGES_BUTTON, buttonText);
    }
    if(buttonText.equals("Group Addresses")){
      elementXpath = GROUP_ADDRESSES_BUTTON;
    }
    if(buttonText.equals("Group Address")){
      elementXpath = GROUP_ADDRESS_BUTTON;
    }
    WebElement buttonXpath = getWebDriver().findElement(By.xpath(elementXpath));
    buttonXpath.click();
  }

  public void clickButtonToUploadCSV(String buttonText) {
    String elementXpath = null;
    switchToShipperAddressConfigurationFrame();
    elementXpath = UPLOAD_CSV_BUTTON;
    WebElement buttonXpath = getWebDriver().findElement(By.xpath(elementXpath));
    buttonXpath.click();
  }

  public void clickUploadCVSButton() {
    pause1s();
    switchToShipperAddressConfigurationFrame();
    WebElement buttonXpath = getWebDriver().findElement(By.xpath(UPLOAD_CVS_CONFIGURE_PICKUP_TYPE));
    buttonXpath.click();
  }

  public void VerificationOfURL(String buttonText) {
    waitWhilePageIsLoading();
    Assertions.assertThat(getWebDriver().getCurrentUrl()).endsWith(buttonText);
    LOGGER.info(getWebDriver().getCurrentUrl());
  }

  public void validateInvalidFileErrorMessageIsShown() {
    pause5s();
    Assertions.assertThat(invalidFileErrorMessage.isDisplayed())
        .as("Validation for error message for Invalid input file").isTrue();
  }

  public void validateInvalidFormattedFileErrorMessageIsShown() {
    pause5s();
    Assertions.assertThat(invalidFormatFileErrorMessage.isDisplayed())
        .as("Validation for error message for Invalid Formatted input file").isTrue();
  }

  public void clickDownloadErrorsButton() {
    waitUntilVisibilityOfElementLocated(downloadErrorsButton.getWebElement());
    downloadErrorsButton.click();
  }

  public void dragAndDrop(String fileName) {
    String Filepath =
        System.getProperty("user.dir") + "/src/test/resources/csv/firstMile/" + fileName;
    File file = new File(Filepath);
    WebElement upload = getWebDriver().findElement(
        By.xpath("//div[text()='Drag and drop CSV file here']"));
    dragAndDrop(file, upload);
  }

  public void closeModal() {
    waitUntilVisibilityOfElementLocated(closePopModal.getWebElement());
    closePopModal.click();
  }

  public void updateCSVFile(String filepath, int columnNumber, int rowNumber, String value) {
    try {
      CSVReader csvReader = new CSVReader(new FileReader(filepath));
      List<String[]> allData = csvReader.readAll();
      allData.get(rowNumber)[columnNumber] = value;
      CSVWriter csvWriter = new CSVWriter(new FileWriter(filepath));
      csvWriter.writeAll(allData);
      csvWriter.flush();
    } catch (Exception e) {
      throw new NvTestRuntimeException("Could not update the CSV file " + filepath, e);
    }
  }

  public void clickEditPickupTypeButton() {
    waitUntilVisibilityOfElementLocated(editPickUpTypeButton.getWebElement());
    editPickUpTypeButton.click();
  }

  public void verifyThatCsvFileIsDownloadedWithFilename(String fileName) {
    LocalDateTime currentDateTime = LocalDateTime.now(ZoneId.of("GMT+8"));
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("ddMMMyyyy");
    String formattedDate = currentDateTime.format(formatter);
    String formatTedFilename = fileName.replaceAll("<current_Date>",formattedDate);
    String downloadedCsvFile = getLatestDownloadedFilename(
        formatTedFilename);
    Assertions.assertThat(fileName.equals(downloadedCsvFile));
 }

  public void clickOnAddressToGroup(String addressId) {
    String checkBoxXpath = f(CHECKBOX_FOE_ADDRESS_TO_BE_GROUPED, addressId);
    WebElement checkBox = getWebDriver().findElement(By.xpath(checkBoxXpath));
    checkBox.click();
  }

  public void verifyGroupAddressModal(String title1, String title2, String pickup_Address, String address1) {
    String title1Xpath = f(GROUP_ADDRESS_VERIFY_MODAL, title1);
    String title2Xpath = f(GROUP_ADDRESS_VERIFY_MODAL, title1);
    String pick_AddressXpath = f(GROUP_ADDRESS_VERIFY_MODAL, title1);
    String address1Xpath = f(GROUP_ADDRESS_VERIFY_MODAL, title1);

    WebElement title = getWebDriver().findElement(By.xpath(title1Xpath));
    WebElement second_Title = getWebDriver().findElement(By.xpath(title2Xpath));
    WebElement pickUp_Address = getWebDriver().findElement(By.xpath(pick_AddressXpath));
    WebElement first_Address = getWebDriver().findElement(By.xpath(address1Xpath));

    Assertions.assertThat(title.getText().equals(title1));
    Assertions.assertThat(second_Title.getText().equals(title2));
    Assertions.assertThat(pickUp_Address.getText().equals(pickup_Address));
    Assertions.assertThat(first_Address.getText().equals(address1));
  }
}
