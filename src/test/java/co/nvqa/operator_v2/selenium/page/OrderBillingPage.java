package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.selenium.elements.mm.AntDateTimeRangePicker;
import java.io.File;
import java.util.List;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Kateryna Skakunova
 */
public class OrderBillingPage extends SimpleReactPage {

  //  private static final String FILTER_START_DATE_MDDATEPICKERNGMODEL = "ctrl.data.startDate";
//  private static final String FILTER_END_DATE_MDDATEPICKERNGMODEL = "ctrl.data.endDate";
  private static final String FILTER_SHIPPER_SELECTED_SHIPPERS_NVAUTOCOMPLETE_ITEMTYPES = "Shipper";
  private static final String FILTER_GENERATE_FILE_CHECKBOX_PATTERN = "//span[text() = '%s']/preceding-sibling::span/input";
  @FindBy(css = ".ant-picker.ant-picker-range")
  public AntDateTimeRangePicker betweenDateRange;
  @FindBy(css = "[data-testid='selectionMode.allShippers']")
  public PageElement allShippers;
  @FindBy(css = "[data-testid='selectionMode.selectedShippers']")
  public AntSelect3 selectedShippers;
  @FindBy(css = "[data-testid='orderBilling.selectedShippers'] div.ant-select-selector")
  public AntSelect selectedShippersInput;
  @FindBy(css = "[data-testid='selectionMode.uploadCSV']")
  public PageElement uploadCsv;
  @FindBy(css = "[data-testid='orderBilling.uploadCSV']")
  public Button uploadCsvBtn;
  @FindBy(css = "[data-testid='useFileSelect-element']")
  public PageElement browseFilesInput;
  @FindBy(css = "[data-testid='selectionMode.parentShippers']")
  public AntSelect3 parentShippers;
  @FindBy(css = "[data-testid='orderBilling.parentShippers'] div.ant-select-selector")
  public AntSelect parentShippersInput;

//  @FindBy(css = "input.ant-select-search__field,input.ant-select-selection-search-input")
//  public PageElement searchInput;
  @FindBy(css = "[data-testid='selectionMode.scriptId']")
  public AntSelect3 scriptId;
  private static final String FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_NVAUTOCOMPLETE_ITEMTYPES = "Parent Shipper";
  private static final String FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_ERROR_MSG = "//md-virtual-repeat-container//li[1]";
  private static final String FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_SEARCH_BOX = ".//nv-autocomplete[@item-types='Parent Shipper']//input";
  private static final String FILTER_SHIPPER_SELECTED_SHIPPERS_BUTTON_ARIA_LABEL = "Selected Shippers";
  private static final String FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_BUTTON_ARIA_LABEL = "Select by Parent Shipper";
  private static final String FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_LOADING = "//span[text()='Loading']";
  @FindBy(css = "[data-testid='orderBilling.emails']")
  public AntSelect3 emailAddressInput;
  private static final String FILTER_UPLOAD_CSV_ARIA_LABEL = "Upload CSV";
  private static final String FILTER_UPLOAD_CSV_NAME = "commons.upload-csv";
  private static final String FILTER_UPLOAD_CSV_DIALOG_SHIPPER_ID_XPATH = "//md-dialog//h4[text()='Upload Shipper ID CSV']";
  private static final String FILTER_UPLOAD_CSV_DIALOG_DROP_FILES_XPATH = "//md-dialog-content//h4[text()=\"Drop files or click 'Choose' to select files\"]";
  private static final String FILTER_UPLOAD_CSV_DIALOG_CHOSSE_BUTTON_ARIA_LABEL = "Choose";
  private static final String FILTER_UPLOAD_CSV_DIALOG_SAVE_BUTTON_ARIA_LABEL = "Save Button";
  private static final String FILTER_UPLOAD_CSV_DIALOG_FILE_NAME = "//md-dialog//h4//span[contains(text(), '%s')]";
  private static final String FILTER_AGGREGATED_INFO_MSG_XPATH = "//div[contains(text(),'%s')]";
  private static final String FILTER_CSV_FILE_TEMPLATE_NAME_XPATH = "//md-select[@placeholder='No Template Selected']//div[@class='md-text']";
  @FindBy(css = "[data-testid='orderBilling.template']")
  public AntSelect3 csvFileTemplate;

  @FindBy(css = "[data-testid='orderBilling.submit']")
  public Button generateSuccessBillingsButton;

  @FindBy(css = ".md-dialog-content-body")
  public PageElement infoMessage;
  @FindBy(css = ".ant-notification-notice")
  public List<AntNotification> noticeNotifications;
  @FindBy(xpath = "//iframe[contains(@src,'order-billing')]")
  private PageElement pageFrame;

  public static final String SHIPPER_BILLING_REPORT = "Shipper Billing Report";
  public static final String SCRIPT_BILLING_REPORT = "Script Billing Report";
  public static final String AGGREGATED_BILLING_REPORT = "Aggregated Billing Report";


  public OrderBillingPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchToIframe() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void selectStartDate(String startDate) {
    betweenDateRange.setFromDate(startDate);
  }

  public void selectEndDate(String endDate) {
    betweenDateRange.setToDate(endDate);
  }

  public void setSpecificShipper(String shipper) {
    selectedShippers.click();
    selectedShippersInput.selectValue(shipper);
//    clickButtonByAriaLabelAndWaitUntilDone(FILTER_SHIPPER_SELECTED_SHIPPERS_BUTTON_ARIA_LABEL);
//    selectValueFromNvAutocompleteByItemTypes(
//        FILTER_SHIPPER_SELECTED_SHIPPERS_NVAUTOCOMPLETE_ITEMTYPES, shipper);
  }

  public void setParentShipper(String parentShipper) {
    parentShippers.click();
    parentShippersInput.selectValue(parentShipper);
    parentShippersInput.click();
//    clickButtonByAriaLabelAndWaitUntilDone(
//        FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_BUTTON_ARIA_LABEL);
//    waitUntilInvisibilityOfElementLocated(FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_LOADING);
//    selectValueFromNvAutocompleteByItemTypesAndDismiss(
//        FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_NVAUTOCOMPLETE_ITEMTYPES, parentShipper);
  }

  public void setInvalidParentShipper(String parentShipper) {
    //same as above?
    parentShippers.click();
    parentShippersInput.selectValue(parentShipper);
//    clickButtonByAriaLabelAndWaitUntilDone(
//        FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_BUTTON_ARIA_LABEL);
//    sendKeys(FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_SEARCH_BOX, shipper);
  }

  public void setEmptyParentShipper() {
    parentShippers.click();
    parentShippers.searchInput.click();
//    clickButtonByAriaLabelAndWaitUntilDone(
//        FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_BUTTON_ARIA_LABEL);
  }

  public void setEmptySelectedShipper() {
    selectedShippers.click();
    selectedShippers.searchInput.click();
//    clickButtonByAriaLabelAndWaitUntilDone(FILTER_SHIPPER_SELECTED_SHIPPERS_BUTTON_ARIA_LABEL);
  }

  public String getNoParentErrorMsg() {
    return getText(FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_ERROR_MSG);
  }

  public void uploadCsvShippersAndVerifySuccessMsg(String shipperIds, File csvFile) {
    int countOfShipperIds = shipperIds.split(",").length;
    uploadCsvShippers(csvFile);
    AntNotification notification = noticeNotifications.get(0);
    Assertions.assertThat(notification.message.getText()).as("Toast top text is correct")
        .isEqualTo("Upload success.");
    Assertions.assertThat(notification.description.getText()).as("Toast bottom text is correct")
        .isEqualTo(f("Extracted %s Shipper IDs.", countOfShipperIds));
  }

  public void uploadCsvShippers(File csvFile) {
    uploadCsv.click();
    uploadCsvBtn.click();
    browseFilesInput.sendKeys(csvFile.getAbsolutePath());
//
//
//    clickButtonByAriaLabel(FILTER_UPLOAD_CSV_ARIA_LABEL);
//    clickNvIconTextButtonByName(FILTER_UPLOAD_CSV_NAME);
//
//    waitUntilVisibilityOfElementLocated(FILTER_UPLOAD_CSV_DIALOG_SHIPPER_ID_XPATH);
//    waitUntilVisibilityOfElementLocated(FILTER_UPLOAD_CSV_DIALOG_DROP_FILES_XPATH);
//    sendKeysByAriaLabel(FILTER_UPLOAD_CSV_DIALOG_CHOSSE_BUTTON_ARIA_LABEL,
//        csvFile.getAbsolutePath());
//    waitUntilVisibilityOfElementLocated(f(FILTER_UPLOAD_CSV_DIALOG_FILE_NAME, csvFile.getName()));
//    clickButtonByAriaLabel(FILTER_UPLOAD_CSV_DIALOG_SAVE_BUTTON_ARIA_LABEL);
  }

  public void uploadPDFShippersAndVerifyErrorMsg() {
    String pdfFileName = "shipper-id-upload.pdf";
    File pdfFile = createFile(pdfFileName, "TEST");

    clickButtonByAriaLabel(FILTER_UPLOAD_CSV_ARIA_LABEL);
    clickNvIconTextButtonByName(FILTER_UPLOAD_CSV_NAME);

    waitUntilVisibilityOfElementLocated(FILTER_UPLOAD_CSV_DIALOG_SHIPPER_ID_XPATH);
    waitUntilVisibilityOfElementLocated(FILTER_UPLOAD_CSV_DIALOG_DROP_FILES_XPATH);

    sendKeysByAriaLabel(FILTER_UPLOAD_CSV_DIALOG_CHOSSE_BUTTON_ARIA_LABEL,
        pdfFile.getAbsolutePath());
    String expectedToastText = "\"" + pdfFileName + "\" is not allowed.";
    assertEquals(expectedToastText, getToastTopText());
  }

  public void tickGenerateTheseFilesOption(String option) {
    simpleClick(f(FILTER_GENERATE_FILE_CHECKBOX_PATTERN, option));
  }

  public void setEmailAddress(String emailAddress) {
//    emailAddressInput.searchInput.setValue(emailAddress);
    emailAddressInput.searchInput.ClickSendKeysAndEnter(emailAddress);
    emailAddressInput.searchInput.click();

//    sendKeysAndEnterByAriaLabel("Email", emailAddress);
  }

  public void clickGenerateSuccessBillingsButton() {
    generateSuccessBillingsButton.click();
  }

  public boolean isGenerateSuccessBillingsButtonEnabled() {
    return generateSuccessBillingsButton.isEnabled();
  }

  public void verifyNoErrorsAvailable() {
    if (toastErrors.size() > 0) {
      fail(f("Error on attempt to generate email: %s", toastErrors.get(0).toastBottom.getText()));
    }
  }

  public Boolean isAggregatedInfoMsgExist(String infoMsg) {
    return isElementExist(f(FILTER_AGGREGATED_INFO_MSG_XPATH, infoMsg));
  }

  public String getCsvFileTemplateName() {
    return getText(FILTER_CSV_FILE_TEMPLATE_NAME_XPATH);
  }

  public void setCsvFileTemplateName(String value) {
    csvFileTemplate.selectValue(value);
  }
}
