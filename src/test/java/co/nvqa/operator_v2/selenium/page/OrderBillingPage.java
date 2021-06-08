package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import java.io.File;
import java.util.Date;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Kateryna Skakunova
 */
public class OrderBillingPage extends OperatorV2SimplePage {

  private static final String FILTER_START_DATE_MDDATEPICKERNGMODEL = "ctrl.data.startDate";
  private static final String FILTER_END_DATE_MDDATEPICKERNGMODEL = "ctrl.data.endDate";
  private static final String FILTER_SHIPPER_SELECTED_SHIPPERS_NVAUTOCOMPLETE_ITEMTYPES = "Shipper";
  private static final String FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_NVAUTOCOMPLETE_ITEMTYPES = "Parent Shipper";
  private static final String FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_ERROR_MSG = "//md-virtual-repeat-container//li[1]";
  private static final String FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_SEARCH_BOX = ".//nv-autocomplete[@item-types='Parent Shipper']//input";
  private static final String FILTER_SHIPPER_SELECTED_SHIPPERS_BUTTON_ARIA_LABEL = "Selected Shippers";
  private static final String FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_BUTTON_ARIA_LABEL = "Select by Parent Shipper";
  private static final String FILTER_GENERATE_FILE_CHECKBOX_PATTERN = "//md-input-container[@label = '%s']/md-checkbox";
  private static final String FILTER_UPLOAD_CSV_ARIA_LABEL = "Upload CSV";
  private static final String FILTER_UPLOAD_CSV_NAME = "commons.upload-csv";
  private static final String FILTER_UPLOAD_CSV_DIALOG_SHIPPER_ID_XPATH = "//md-dialog//h4[text()='Upload Shipper ID CSV']";
  private static final String FILTER_UPLOAD_CSV_DIALOG_DROP_FILES_XPATH = "//md-dialog-content//h4[text()=\"Drop files or click 'Choose' to select files\"]";
  private static final String FILTER_UPLOAD_CSV_DIALOG_CHOSSE_BUTTON_ARIA_LABEL = "Choose";
  private static final String FILTER_UPLOAD_CSV_DIALOG_SAVE_BUTTON_ARIA_LABEL = "Save Button";
  private static final String FILTER_UPLOAD_CSV_DIALOG_FILE_NAME = "//md-dialog//h4//span[contains(text(), '%s')]";
  private static final String FILTER_AGGREGATED_INFO_MSG_XPATH = "//div[contains(text(),'%s')]";
  private static final String FILTER_CSV_FILE_TEMPLATE_NAME_XPATH = "//md-select[@placeholder='No Template Selected']//div[@class='md-text']";

  @FindBy(xpath = "  //md-select[@md-container-class=\"nv-input-select-container\"]")
  public MdSelect csvFileTemplate;

  public static final String SHIPPER_BILLING_REPORT = "Shipper Billing Report";
  public static final String SCRIPT_BILLING_REPORT = "Script Billing Report";
  public static final String AGGREGATED_BILLING_REPORT = "Aggregated Billing Report";


  public OrderBillingPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void selectStartDate(Date startDate) {
    setMdDatepicker(FILTER_START_DATE_MDDATEPICKERNGMODEL, startDate);
  }

  public void selectEndDate(Date endDate) {
    setMdDatepicker(FILTER_END_DATE_MDDATEPICKERNGMODEL, endDate);
  }

  public void setSpecificShipper(String shipper) {
    clickButtonByAriaLabelAndWaitUntilDone(FILTER_SHIPPER_SELECTED_SHIPPERS_BUTTON_ARIA_LABEL);
    selectValueFromNvAutocompleteByItemTypes(
        FILTER_SHIPPER_SELECTED_SHIPPERS_NVAUTOCOMPLETE_ITEMTYPES, shipper);
  }

  public void setParentShipper(String parentShipper) {
    clickButtonByAriaLabelAndWaitUntilDone(
        FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_BUTTON_ARIA_LABEL);
    selectValueFromNvAutocompleteByItemTypesAndDismiss(
        FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_NVAUTOCOMPLETE_ITEMTYPES, parentShipper);
  }

  public void setInvalidParentShipper(String shipper) {
    clickButtonByAriaLabelAndWaitUntilDone(
        FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_BUTTON_ARIA_LABEL);
    sendKeys(FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_SEARCH_BOX, shipper);
  }

  public String getNoParentErrorMsg() {
    return getText(FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_ERROR_MSG);
  }

  public void uploadCsvShippers(String shipperIds) {

    int countOfShipperIds = shipperIds.split(",").length;
    File csvFile = createFile("shipper-id-upload.csv", shipperIds);
    NvLogger.info("Path of the created file : " + csvFile.getAbsolutePath());

    clickButtonByAriaLabel(FILTER_UPLOAD_CSV_ARIA_LABEL);
    clickNvIconTextButtonByName(FILTER_UPLOAD_CSV_NAME);

    waitUntilVisibilityOfElementLocated(FILTER_UPLOAD_CSV_DIALOG_SHIPPER_ID_XPATH);
    waitUntilVisibilityOfElementLocated(FILTER_UPLOAD_CSV_DIALOG_DROP_FILES_XPATH);
    sendKeysByAriaLabel(FILTER_UPLOAD_CSV_DIALOG_CHOSSE_BUTTON_ARIA_LABEL,
        csvFile.getAbsolutePath());
    waitUntilVisibilityOfElementLocated(f(FILTER_UPLOAD_CSV_DIALOG_FILE_NAME, csvFile.getName()));
    clickButtonByAriaLabel(FILTER_UPLOAD_CSV_DIALOG_SAVE_BUTTON_ARIA_LABEL);

    assertEquals(f("Upload success. Extracted %s Shipper IDs.", countOfShipperIds),
        getToastTopText());
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
    sendKeysAndEnterByAriaLabel("Email", emailAddress);
  }

  public void clickGenerateSuccessBillingsButton() {
    clickButtonByAriaLabelAndWaitUntilDone("Generate Success Billings");
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
