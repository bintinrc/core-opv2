package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.selenium.elements.mm.AntDateTimeRangePicker;
import java.io.File;
import java.util.List;
import org.assertj.core.api.SoftAssertions;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;

/**
 * @author Kateryna Skakunova
 */
public class OrderBillingPage extends SimpleReactPage {

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
  @FindBy(css = "[data-testid='selectionMode.scriptId']")
  public AntSelect3 scriptId;
  @FindBy(css = "[data-testid='orderBilling.scriptId'] div.ant-select-selector")
  public AntSelect3 scriptIdInput;
  @FindBy(css = "[data-testid='orderBilling.emails']")
  public AntSelect3 emailAddressInput;
  @FindBy(xpath = "//*[text()='No Data']")
  public PageElement noDataFound;
  private static final String FILTER_CSV_FILE_TEMPLATE_NAME_XPATH = "//div[@data-testid = 'orderBilling.template']//div//span[2]";
  private static final String FILTER_GENERATE_FILE_CHECKBOX_PATTERN = "//span[text() = '%s']/preceding-sibling::span/input";

  private static final String XPATH_ERROR = "//span[text()='%s']";
  @FindBy(css = "[data-testid='orderBilling.template.disabledText']")
  public PageElement aggregatedDisabledTxt;

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
    Actions actions = new Actions(getWebDriver());
    actions.sendKeys(Keys.ESCAPE).build().perform();
  }

  public void setParentShipper(String parentShipper) {
    parentShippers.click();
    parentShippersInput.selectValue(parentShipper);
    parentShippersInput.click();
  }

  public void setScriptId(String scriptIdAndName) {
    scriptId.click();
    scriptIdInput.selectValue(scriptIdAndName);
    scriptIdInput.click();
  }

  public void setInvalidParentShipper(String parentShipper) {
    parentShippers.click();
    parentShippersInput.selectValue(parentShipper);
  }

  public void setEmptyParentShipper() {
    parentShippers.click();
    parentShippersInput.click();
    parentShippers.click();
  }

  public void setEmptySelectedShipper() {
    selectedShippers.click();
    selectedShippersInput.click();
    selectedShippers.click();
  }

  public void setEmptyScriptId() {
    scriptId.click();
    scriptIdInput.click();
    scriptId.click();
  }

  public void uploadCsvShippersAndVerifyToastMsg(File file, String toastTop, String toastBottom) {
    uploadCsvShippers(file);
    AntNotification notification = noticeNotifications.get(0);
    SoftAssertions softAssertions = new SoftAssertions();
    softAssertions.assertThat(notification.message.getText()).as("Toast top text is correct")
        .isEqualTo(toastTop);
    softAssertions.assertThat(notification.description.getText()).as("Toast bottom text is correct")
        .isEqualTo(toastBottom);
    softAssertions.assertAll();
  }

  public void uploadCsvShippers(File csvFile) {
    uploadCsv.click();
    uploadCsvBtn.click();
    browseFilesInput.sendKeys(csvFile.getAbsolutePath());
  }

  public void tickGenerateTheseFilesOption(String option) {
    simpleClick(f(FILTER_GENERATE_FILE_CHECKBOX_PATTERN, option));
  }

  public void setEmailAddress(String emailAddress) {
    emailAddressInput.searchInput.ClickSendKeysAndEnter(emailAddress);
    emailAddressInput.searchInput.click();
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

  public String getAggregatedInfoMsg() {
    return aggregatedDisabledTxt.getText();
  }

  public String getCsvFileTemplateName() {
    return getText(FILTER_CSV_FILE_TEMPLATE_NAME_XPATH);
  }

  public void setCsvFileTemplateName(String value) {
    csvFileTemplate.selectValue(value);
  }

  public boolean verifyErrorMsgIsVisible(String errorMsg) {
    return isElementVisible(f(XPATH_ERROR, errorMsg));
  }
}
