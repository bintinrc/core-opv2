package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.InvoiceDisputeDetails;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class InvoiceDisputesDetailPage extends SimpleReactPage<InvoiceDisputesDetailPage> {

  @FindBy(xpath = "//article[text()='Case status']//parent::div//following-sibling::div//span")
  public PageElement caseStatus;

  @FindBy(xpath = "//article[text()='Invoice ID']//parent::div//following-sibling::div//article")
  public PageElement invoiceId;

  @FindBy(xpath = "//article[text()='Case ID']//parent::div//following-sibling::div//article")
  private PageElement caseId;

  @FindBy(xpath = "//article[text()='Date dispute filed']//parent::div//following-sibling::div//article")
  public PageElement disputeFiledDate;

  @FindBy(xpath = "//article[text()='Shipper name']//parent::div//following-sibling::div//article")
  public PageElement shipperName;

  @FindBy(xpath = "//article[text()='Shipper ID']//parent::div//following-sibling::div//a")
  public PageElement shipperID;

  @FindBy(xpath = "//article[text()=\"Dispute person's name\"]//parent::div//following-sibling::div//article")
  public PageElement disputePersonName;

  @FindBy(xpath = "//article[text()='Number of disputed TID(s)']//parent::div//following-sibling::div//article")
  public PageElement numberOfDisputeTIDs;

  @FindBy(xpath = "//article[text()='Number of invalid TID(s)']//parent::div//following-sibling::div//article")
  public PageElement numberOfInvalidTIDs;

  @FindBy(xpath = "//article[text()='Number of valid TID(s)']//parent::div//following-sibling::div//article")
  public PageElement numberOfValidTIDs;

  @FindBy(xpath = "//article[text()='Pending TID(s)']//parent::div//following-sibling::div//article")
  public PageElement pendingTIDs;

  @FindBy(xpath = "//article[text()='Accepted TID(s)']//parent::div//following-sibling::div//article")
  public PageElement acceptedTIDs;

  @FindBy(xpath = "//article[text()='Rejected TID(s)']//parent::div//following-sibling::div//article")
  public PageElement rejectedTIDs;

  @FindBy(xpath = "//article[text()='Error TID(s)']//parent::div//following-sibling::div//article")
  public PageElement errorTIDs;

  @FindBy(id = "rc-tabs-0-tab-MANUAL")
  public PageElement manualResolutionTab;

  @FindBy(css = "div.ant-modal-content")
  public ManualResolutionDisputedOrderModal manualResolutionDisputedOrderModal;

  String MANUAL_RESOLUTION_TID_XPATH = "//td[text()='%s']";
  String MANUAL_RESOLUTION_DISPUTE_TYPE = "//td[text()='%s']//following-sibling::td[1]";
  String MANUAL_RESOLUTION_STATUS = "//td[text()='%s']//following-sibling::td[2]";
  String MANUAL_RESOLUTION_FINANCE_REVISED_DELIVERY_FEE = "//td[text()='%s']//following-sibling::td[3]";
  String MANUAL_RESOLUTION_FINANCE_REVISED_COD_FEE = "//td[text()='%s']//following-sibling::td[4]";
  String MANUAL_RESOLUTION_FINANCE_DELTA_AMOUNT = "//td[text()='%s']//following-sibling::td[5]";
  String MANUAL_RESOLUTION_FINANCE_ACTION_BUTTON = "//td[text()='%s']//following-sibling::td[6]//descendant::button";

  public InvoiceDisputesDetailPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchToIframe() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }


  public InvoiceDisputeDetails getInvoiceDisputeExtendedDetails() {
    InvoiceDisputeDetails invoiceDisputeDetails = new InvoiceDisputeDetails();
    invoiceDisputeDetails.setCaseNumber(caseId.getText());
    invoiceDisputeDetails.setCaseStatus(caseStatus.getText());
    invoiceDisputeDetails.setDisputeFiledDate(disputeFiledDate.getText());
    invoiceDisputeDetails.setInvoiceId(invoiceId.getText());
    invoiceDisputeDetails.setShipperName(shipperName.getText());
    invoiceDisputeDetails.setShipperId(shipperID.getText());
    invoiceDisputeDetails.setDisputePersonName(disputePersonName.getText());
    invoiceDisputeDetails.setNumberOfTIDs(numberOfDisputeTIDs.getText());
    invoiceDisputeDetails.setNumberOfInvalidTIDs(numberOfInvalidTIDs.getText());
    invoiceDisputeDetails.setNumberOfValidTIDs(numberOfValidTIDs.getText());
    invoiceDisputeDetails.setNumberOfPendingTIDs(pendingTIDs.getText());
    invoiceDisputeDetails.setNumberOfAcceptedTIDs(acceptedTIDs.getText());
    invoiceDisputeDetails.setNumberOfRejectedTIDs(rejectedTIDs.getText());
    invoiceDisputeDetails.setNumberOfErrorTIDs(errorTIDs.getText());
    return invoiceDisputeDetails;
  }

  public boolean isTIDDisplayed(String tid) {
    try {
      return findElementBy(By.xpath(f(MANUAL_RESOLUTION_TID_XPATH, tid))).isDisplayed();
    } catch (Exception ex) {
      return false;
    }
  }

  public String getDisputeType(String tid) {
    return getText(f(MANUAL_RESOLUTION_DISPUTE_TYPE, tid));
  }

  public String getDisputeStatus(String tid) {
    return getText(f(MANUAL_RESOLUTION_STATUS, tid));
  }

  public String getDisputeRevisedDeliveryFee(String tid) {
    return getText(f(MANUAL_RESOLUTION_FINANCE_REVISED_DELIVERY_FEE, tid));
  }

  public String getDisputeRevisedCODFee(String tid) {
    return getText(f(MANUAL_RESOLUTION_FINANCE_REVISED_COD_FEE, tid));
  }

  public String getDisputeDeltaAmount(String tid) {
    return getText(f(MANUAL_RESOLUTION_FINANCE_DELTA_AMOUNT, tid));
  }

  public void clickActionButtonInManualResolutionTab(String tid) {
    click(f(MANUAL_RESOLUTION_FINANCE_ACTION_BUTTON, tid));
  }

  public void verifyManualResolutionDisputedOrderIsDisplayed() {
    manualResolutionDisputedOrderModal.waitUntilLoaded();
    manualResolutionDisputedOrderModal.isDisplayed();
    Assertions.assertThat(manualResolutionDisputedOrderModal.isDisplayed())
        .as("Manual Resolution Disputed Order Modal is displayed").isTrue();
  }

  public static class ManualResolutionDisputedOrderModal extends AntModal {

    @FindBy(xpath = "//span[text()='Save and exit']//parent::button")
    public Button saveAndExitButton;

    @FindBy(xpath = "//span[text()='Save and close']//parent::button")
    public Button saveAndConfirmButton;

    @FindBy(xpath = "//span[text()='Save and next']//parent::button")
    public Button saveAndNextButton;

    @FindBy(xpath = "//span[@aria-label='close']")
    public PageElement closeButton;

    @FindBy(xpath = "//span[text()='Confirm']//parent::button")
    public Button closeConfirmButton;

    @FindBy(xpath = "//article[text()='Tracking ID']//parent::div//following::a")
    public PageElement orderInfoTrackingId;

    @FindBy(xpath = "//article[text()='Dispute type']//parent::div//following-sibling::div//article")
    public PageElement orderInfoDisputeType;

    @FindBy(xpath = "//article[text()='Completion date']//parent::div//following-sibling::div//article")
    public PageElement orderInfoCompletionDate;

    @FindBy(xpath = "//article[text()='RTS']//parent::div//following-sibling::div//article")
    public PageElement orderInfoRts;

    @FindBy(xpath = "//article[contains(text(),'NV original billed amt (tax-exclusive)')]//parent::div//following-sibling::div//article")
    public PageElement disputeInfoOriginalBilledAmount;

    @FindBy(xpath = "//article[contains(text(),'COD Amount')]//parent::div//following-sibling::div//article")
    public PageElement disputeInfoCODAmount;

    @FindBy(xpath = "//input[@value='ACCEPTED']")
    public CheckBox acceptRadiobutton;

    @FindBy(xpath = "//input[@value='REJECTED']")
    public CheckBox rejectRadiobutton;

    @FindBy(xpath = "//span[text()='Manual adjustment']//parent::button")
    public Button manualAdjustmentButton;

    @FindBy(xpath = "//span[text()='Calculate']//parent::button")
    public Button calculateButton;

    @FindBy(xpath = "//span[text()='Remarks (shown to shipper)']//parent::div//following-sibling::div//div[@class='ant-select-selector']")
    public AntSelect3 remark;

    @FindBy(xpath = "//span[text() = 'Original delivery fee']//parent::div//following-sibling::div//descendant::input")
    public TextBox originalDeliveryFee;

    @FindBy(xpath = "//span[text() = 'Original RTS fee']//parent::div//following-sibling::div//descendant::input")
    public TextBox originalRTSFee;

    @FindBy(xpath = "//span[text() = 'Original COD fee']//parent::div//following-sibling::div//descendant::input")
    public TextBox originalCODFee;

    @FindBy(xpath = "//span[text() = 'Original insurance fee']//parent::div//following-sibling::div//descendant::input")
    public TextBox originalInsuranceFee;

    @FindBy(xpath = "//span[text() = 'Original tax']//parent::div//following-sibling::div//descendant::input")
    public TextBox originalTax;

    @FindBy(xpath = "//label[text() = 'NV original bill amount']//parent::div//following-sibling::div//descendant::input")
    public TextBox originalBillingAmount;

    @FindBy(xpath = "//span[text() = 'Revised delivery fee']//parent::div//following-sibling::div//descendant::input")
    public TextBox revisedDeliveryFee;

    @FindBy(xpath = "//span[text() = 'Revised RTS fee']//parent::div//following-sibling::div//descendant::input")
    public TextBox revisedRTSFee;

    @FindBy(xpath = "//span[text() = 'Revised COD fee']//parent::div//following-sibling::div//descendant::input")
    public TextBox revisedCODFee;

    @FindBy(xpath = "//span[text() = 'Revised insurance fee']//parent::div//following-sibling::div//descendant::input")
    public TextBox revisedInsuranceFee;

    @FindBy(xpath = "//span[text() = 'Revised tax']//parent::div//following-sibling::div//descendant::input")
    public TextBox revisedTax;

    @FindBy(xpath = "//label[text() = 'Revised total bill amount']//parent::div//following-sibling::div//descendant::input")
    public TextBox revisedTotalBillAmount;

    @FindBy(xpath = "//span[text() = 'Delta between original bill amount and revised amount']//parent::div//following-sibling::div//descendant::input")
    public TextBox deltaAmount;

    @FindBy(xpath = "//article[text() = 'Internal commentary (optional)']//parent::div//following-sibling::div//descendant::input")
    public TextBox internalCommentary;

    @FindBy(xpath = "//span[text() = 'Remarks (shown to shipper)']//parent::div//following-sibling::div//descendant::span[2]")
    public PageElement remarks;

    @FindBy(xpath = "//input[@placeholder = 'Input here']")
    public TextBox customRemarksInput;

    @FindBy(xpath = "//span[text() = 'Revised weight input']//parent::div//following-sibling::div//descendant::span//input")
    public TextBox revisedWeightInput;

    @FindBy(xpath = "//label[text() = 'NV original bill amount']//parent::div//following-sibling::div//descendant::input")
    public TextBox nvOriginalBilledAmount;

    public ManualResolutionDisputedOrderModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

  }

}