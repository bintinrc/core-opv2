package co.nvqa.operator_v2.selenium.page;


import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntDateRangePicker;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect2;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.selenium.elements.ant.v4.AntSelect;
import com.opencsv.CSVReader;
import com.opencsv.CSVWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
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

  private static final String MODAL_TABLE_SEARCH_BY_TABLE_NAME_XPATH = "//div[text()='%s']/ancestor::div[starts-with(@class,'VirtualTableHeader')]//input";
  private static final String MODAL_TABLE_SEARCH_BY_TABLE_CHECKBOX = "//div[text()='%s']/ancestor::div[starts-with(@class,'VirtualTableHeader')]//span[@role='button']";
  private static final String TABLE_FIRST_ROW_VALUE_BY_COLUMN = "//div[@class='BaseTable__row-cell' and @data-datakey='%s']//*[name()='span'or 'div']";
  public static final String CSV_DOWNLOADED_FILENAME_PATTERN = "Downloaded Pickup Addresses";
  public static final String COLUMN_NAME = "Suggested Address URL";
  public static final String DOWNLOADED_CSV_FILENAME = "CSV Template_Pickup Address Lat Long.csv";
  public static final String UPLOAD_ERROR_MESSAGE = "//span[text()='%s out of %s addresses']/following-sibling::span[text()=' that could not be updated.']";
  public static final String UPLOAD_SUCCESS_MESSAGE = "//span[text()='%s Shipper lat long has been updated!']";
  public static final String PICKUP_TYPE_UPDATE_SUCCESS_MESSAGE = "//span[text()='Address ID %s pickup type has been updated!']";
  public static final String BUTTON = "//span[text()='%s']/parent::button";
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

  public void validateFilter(String columnName, String expectedValue) {
    String valueXpath = f(TABLE_FIRST_ROW_VALUE_BY_COLUMN, columnName);
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
    pause1s();
    switchToShipperAddressConfigurationFrame();
    String errorXpath = f(BUTTON, buttonText);
    WebElement buttonXpath = getWebDriver().findElement(By.xpath(errorXpath));
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

}
