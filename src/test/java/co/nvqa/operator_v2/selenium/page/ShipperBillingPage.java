package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.ShipperBillingRecord;
import co.nvqa.operator_v2.selenium.elements.md.ContainerSwitch;
import org.junit.platform.commons.util.StringUtils;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class ShipperBillingPage extends OperatorV2SimplePage {

  private static final String SHIPPER_LOCATOR_LOCATOR = "//*[@aria-label='Search or Select Shipper']";
  private static final String ADD_AMOUNT_LOCATOR = "+ Add";
  private static final String DEDUCT_AMOUNT_LOCATOR = "- Deduct";
  private static final String AMOUNT_LOCATOR = "//*[@ng-model='ctrl.amount']";
  private static final String REASON_LOCATOR = "commons.reason";
  private static final String BANK_TRANSFER_DETAILS_LOCATOR = "commons.shipper-billing.bank-transfer-details";
  private static final String REVIEW_BUTTON_LOCATOR = "//nv-api-text-button[@name='commons.review']/button";
  private static final String CURRENCY_LOCATOR = "//span[@class='currency']";

  private ReviewDetailsView reviewDetailsView;
  private BillingUpdatedDialog billingUpdatedDialog;

  @FindBy(css = "div[model='ctrl.transferMode']")
  public ContainerSwitch transferMode;

  public ShipperBillingPage(WebDriver webDriver) {
    super(webDriver);
    reviewDetailsView = new ReviewDetailsView(webDriver);
    billingUpdatedDialog = new BillingUpdatedDialog(webDriver);
  }

  public void selectShipper(String shipperName) {
    sendKeysWithoutClear(SHIPPER_LOCATOR_LOCATOR, shipperName);
    pause2s();
    sendKeysWithoutClear(SHIPPER_LOCATOR_LOCATOR, Keys.ENTER);
  }

  public String readCurrency() {
    String value = getText(CURRENCY_LOCATOR);
    return value.replaceAll("[+-]", "").trim();
  }

  public void chooseAddAmount() {
    clickButtonByAriaLabel(ADD_AMOUNT_LOCATOR);
  }

  public void chooseDeductAmount() {
    clickButtonByAriaLabel(DEDUCT_AMOUNT_LOCATOR);
  }

  public void enterAmount(String amount) {
    sendKeys(AMOUNT_LOCATOR, amount);
  }

  public void selectReason(String reason, String comment) {
    selectValueFromMdSelectById(REASON_LOCATOR, reason);
    sendKeysById(BANK_TRANSFER_DETAILS_LOCATOR, comment);
  }

  public void clickReviewButton() {
    click(REVIEW_BUTTON_LOCATOR);
  }

  public void updateShipperBilling(ShipperBillingRecord billingRecordInfo) {
    if (StringUtils.isBlank(billingRecordInfo.getType())) {
      throw new IllegalArgumentException("Billing operation type was not defined");
    }

    selectShipper(billingRecordInfo.getShipperName());
    switch (billingRecordInfo.getType().toLowerCase().trim()) {
      case "add":
        transferMode.selectValue("+ Add");
        break;
      case "deduct":
        transferMode.selectValue("- Deduct");
        break;
      default:
        throw new IllegalArgumentException(String
            .format("Unknown operation type [%s]. Can be 'add' or 'deduct'",
                billingRecordInfo.getType()));
    }
    billingRecordInfo.setCurrency(readCurrency());
    enterAmount(String.valueOf(billingRecordInfo.getAmount()));
    selectReason(billingRecordInfo.getReason(), billingRecordInfo.getComment());
    clickReviewButton();
    ShipperBillingRecord reviewData = reviewDetailsView.readShipperBillingRecordInfo();
    billingRecordInfo.compareWithActual(reviewData);
    reviewDetailsView.clickSumbit();
    billingRecordInfo.setReferenceNo(billingUpdatedDialog.waitUntilVisible().readReferenceNo());
    billingUpdatedDialog.close();
  }

  public static class ReviewDetailsView extends OperatorV2SimplePage {

    private static final String CARD_LOCATOR = "//md-card[@ng-if='ctrl.isReviewAvailable']";
    private static final String SHIPPER_ID_LOCATOR =
        CARD_LOCATOR + "//md-input-container[@name='commons.shipper-id']/div";
    private static final String SHIPPER_NAME_LOCATOR =
        CARD_LOCATOR + "//md-input-container[@name='commons.model.shipper-name']/div";
    private static final String TYPE_LOCATOR = CARD_LOCATOR
        + "//md-input-container[@name='container.shipper-billing.review-deduct-add']/div";
    private static final String AMOUNT_LOCATOR =
        CARD_LOCATOR + "//md-input-container[@name='commons.amount']/div";
    private static final String REASON_LOCATOR =
        CARD_LOCATOR + "//md-input-container[@name='commons.reason']/div";
    private static final String SUBMIT_BUTTON_LOCATOR =
        CARD_LOCATOR + "//nv-api-text-button[@name='commons.submit']/button";

    public ReviewDetailsView(WebDriver webDriver) {
      super(webDriver);
    }

    public String readShipperId() {
      return getText(SHIPPER_ID_LOCATOR);
    }

    public String readShipperName() {
      return getText(SHIPPER_NAME_LOCATOR);
    }

    public String readType() {
      return getText(TYPE_LOCATOR);
    }

    public String readAmount() {
      String value = getText(AMOUNT_LOCATOR);
      return value.substring(value.lastIndexOf(" ") + 1).trim();
    }

    public String readCurrency() {
      String value = getText(AMOUNT_LOCATOR);
      String[] values = value.split(" ");
      return values.length > 1 ? values[1].trim() : null;
    }

    public String readReason() {
      String value = getText(REASON_LOCATOR);
      return value.split("-")[0].trim();
    }

    public String readComment() {
      String value = getText(REASON_LOCATOR);
      String[] values = value.split("-");
      return values.length > 1 ? values[1].trim() : null;
    }

    public void clickSumbit() {
      click(SUBMIT_BUTTON_LOCATOR);
    }

    public ShipperBillingRecord readShipperBillingRecordInfo() {
      ShipperBillingRecord billingRecordInfo = new ShipperBillingRecord();
      billingRecordInfo.setShipperId(readShipperId());
      billingRecordInfo.setShipperName(readShipperName());
      billingRecordInfo.setType(readType());
      billingRecordInfo.setAmount(readAmount());
      billingRecordInfo.setCurrency(readCurrency());
      billingRecordInfo.setReason(readReason());
      billingRecordInfo.setComment(readComment());
      return billingRecordInfo;
    }
  }

  public static class BillingUpdatedDialog extends OperatorV2SimplePage {

    private static final String DIALOG_TITLE = "Billing Updated";
    private static final String DIALOG_CONTENT_LOCATOR = "//*[@class='md-dialog-content-body']";
    private static final String OK_BUTTON_LOCATOR = "OK";

    public BillingUpdatedDialog(WebDriver webDriver) {
      super(webDriver);
    }

    public BillingUpdatedDialog waitUntilVisible() {
      waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
      return this;
    }

    public String readReferenceNo() {
      String value = getText(DIALOG_CONTENT_LOCATOR);
      return value.substring(value.lastIndexOf(":") + 1).trim();
    }

    public void close() {
      clickButtonByAriaLabel(OK_BUTTON_LOCATOR);
    }
  }
}
