package co.nvqa.operator_v2.selenium.page;


import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect2;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect4;
import java.util.List;
import org.assertj.core.api.Assertions;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;


/**
 * @author Sathishkumar
 */
public class ValidateAttemptPage extends OperatorV2SimplePage {


  private static final String BUTTON_XPATH = "//span[text()='%s']//parent::button";

  @FindBy(css = "iframe")
  private List<PageElement> pageFrame;

  @FindBy(xpath = "//label[text()='Select Hubs']//parent::div//following::div[@class='ant-select-selector'][1]")
  public List<PageElement> modalHubSelection;

  @FindBy(xpath = "//label[text()='Select Hubs']//parent::div//following::div[@class='ant-select-selector'][1]")
  public AntSelect2 hubs;

  @FindBy(xpath = "//label[text()='Select Failure Reason']//parent::div//following::div[@class='ant-select-selector'][1]")
  public AntSelect2 failureReason;

  @FindBy(xpath = "//div[contains(@class,'ant-select-dropdown')]//div[contains(@class,'ant-select-item ant-select-item-option')]")
  public PageElement hubDropdownValue;

  @FindBy(xpath = "//label[text()='Select Driver']//parent::div//following::div[@class='ant-select-selector'][1]")
  public AntSelect2 driver;

  @FindBy(xpath = "//div[contains(@class,'ant-select-item ant-select-item-option')]")
  public PageElement driverDropdownValue;

  @FindBy(xpath = "//label[text()='Select Master Shipper']//parent::div//following::div[@class='ant-select-selector'][1]")
  public AntSelect2 masterShipper;

  @FindBy(xpath = "//div[contains(@class,'ant-select-item-option-content')]")
  public PageElement masterShipperDropdownValue;

  @FindBy(xpath = "//textarea[@data-testid='shipper-ids-textarea']")
  public PageElement searchShipperIds;

  @FindBy(xpath = "//textarea[@data-testid='tracking-ids-textarea']")
  public PageElement searchTrackingIds;

  @FindBy(xpath = "//h2[text()='Filter PODs to start validating']")
  public PageElement validateAttemptHeadingText;

  @FindBy(xpath = "//p[text()='You have some PODs assigned to you that have not been validated. Do you want to resume validation?']")
  public PageElement pendingAssignedPodText;

  @FindBy(xpath = "//label[contains(text(),'Select Job')]/ancestor::div[contains(@class,'ant-row ant-form-item')]//div[@class='ant-select-selector']")
  public AntSelect4 selectJob;

  @FindBy(xpath = "//label[contains(text(),'Select Status')]/ancestor::div[contains(@class,'ant-row ant-form-item')]//div[@class='ant-select-selector']")
  public AntSelect4 selectStatus;

  @FindBy(xpath = "//label[contains(text(),'COD')]/ancestor::div[contains(@class,'ant-row ant-form-item')]//div[@class='ant-select-selector']")
  public AntSelect4 selectCOD;

  @FindBy(xpath = "//label[contains(text(),'RTS')]/ancestor::div[contains(@class,'ant-row ant-form-item')]//div[@class='ant-select-selector']")
  public AntSelect4 selectRTS;

  @FindBy(xpath = "//div[text()='Select Reason']//parent::div//following::div[@class='ant-select-selector'][1]")
  public AntSelect2 selectReasonInvalidAttempt;


  @FindBy(xpath = "//input[@placeholder='Start date']")
  public PageElement startDate;

  @FindBy(xpath = "//input[@placeholder='End date']")
  public PageElement endDate;

  @FindBy(xpath = "//span[text()='OK']//parent::button")
  public PageElement okButton;

  @FindBy(xpath = "//div[@data-testid='pod-validation.validate.productivity-metrics.completed-task-num']")
  public PageElement attemptsValidatedCount;

  @FindBy(xpath = "//div[text()='Status 404: Not Found']")
  public PageElement statusCode404message;

  @FindBy(xpath = "//a[@class='ant-notification-notice-close']")
  public PageElement notificationCloseIcon;

  @FindBy(xpath = "//textarea[@data-testid='tracking-ids-textarea']")
  public PageElement trackingIdTextArea;

  @FindBy(xpath = "//button[@disabled and @data-testid='filter-and-validate-button']")
  public PageElement disabledValidateButton;

  @FindBy(xpath = "//button[@disabled and @data-testid='save-failure-reason']")
  public PageElement disabledSaveReasonButton;

  @FindBy(xpath = "//div[@class='ant-image']//img//ancestor::div[@class='ant-row']//div[text()='Photos']")
  public PageElement podPhoto;

  @FindBy(xpath = "//div[@class='ant-image']//img//ancestor::div[@class='ant-row']//div[text()='Signature']")
  public PageElement podSignature;

  @FindBy(xpath = "//div[@data-testid='pod-validation_task_back-button']")
  public PageElement backToTask;

  @FindBy(xpath = "//label[text()='Select Validator']//parent::div//following::div[@class='ant-select-selector'][1]")
  public AntSelect2 selectValidator;


  public ValidateAttemptPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchToFrame() {
    waitWhilePageIsLoading();
    pause3s();
    if (pageFrame.size() > 0) {
      waitUntilVisibilityOfElementLocated(pageFrame.get(0).getWebElement(), 15);
      getWebDriver().switchTo().frame(pageFrame.get(0).getWebElement());
    }
  }

  public void selectHub(String hubName) {
    hubs.enterSearchTerm(hubName);
    pause2s();
    hubs.sendReturnButton();
    webDriver.findElement(
            By.xpath(
                "//label[text()='Select Hubs']//parent::div//following::div[@class='ant-select-selector'][1]//input"))
        .sendKeys(Keys.TAB);
  }

  public void selectFailureReason(String failReason) {
    failureReason.enterSearchTerm(failReason);
    pause2s();
    failureReason.sendReturnButton();
    webDriver.findElement(
            By.xpath(
                "//label[text()='Select Failure Reason']//parent::div//following::div[@class='ant-select-selector'][1]//input"))
        .sendKeys(Keys.TAB);
  }

  public void selectDriver(String driverName) {
    driver.enterSearchTerm(driverName);
    pause2s();
    driver.sendReturnButton();
    webDriver.findElement(
            By.xpath(
                "//label[text()='Select Driver']//parent::div//following::div[@class='ant-select-selector'][1]//input"))
        .sendKeys(Keys.TAB);
  }

  public void selectInvalidAttemptReasonValue(String invalidAttemptReason) {
    selectReasonInvalidAttempt.enterSearchTerm(invalidAttemptReason);
    pause2s();
    selectReasonInvalidAttempt.sendReturnButton();
    webDriver.findElement(
            By.xpath(
                "//div[text()='Select Reason']//parent::div//following::div[@class='ant-select-selector'][1]//input"))
        .sendKeys(Keys.TAB);
    clickButton("Save Reason");
  }

  public void selectMasterShipper(String masterShipperName) {
    masterShipper.enterSearchTerm(masterShipperName);
    pause2s();
    masterShipper.sendReturnButton();
    webDriver.findElement(
            By.xpath(
                "//label[text()='Select Master Shipper']//parent::div//following::div[@class='ant-select-selector'][1]//input"))
        .sendKeys(Keys.TAB);
  }


  public void enterMasterShipperIds(String masterShipperIds) {
    searchShipperIds.clearAndSendKeys(masterShipperIds);
  }

  public void enterTrackingIds(String masterTrackingIds) {
    searchTrackingIds.clearAndSendKeys(masterTrackingIds);
  }

  public void selectJob(String job) {
    selectJob.selectValueWithoutSearch(job);
  }

  public void selectStatus(String status) {
    selectStatus.selectValueWithoutSearch(status);
  }

  public void selectCOD(String cod) {
    selectCOD.selectValueWithoutSearch(cod);
  }

  public void selectRTS(String rts) {
    selectRTS.selectValueWithoutSearch(rts);
  }


  public void validatePODPageHeadingText() {
    switchToFrame();
    validateAttemptHeadingText.waitUntilVisible(5);
    pause5s();
    Assertions.assertThat(validateAttemptHeadingText.isDisplayed())
        .as("Validation for validate Attempt Heading Text")
        .isTrue();
  }

  public void selectDateTime(String startDateRange, String endDateRange) {
    pause1s();
    startDate.click();
    startDate.clearAndSendKeys(startDateRange);
    endDate.click();
    endDate.clearAndSendKeys(endDateRange);
    okButton.click();
  }

  public void clickButton(String buttonText) {
    pause1s();
    String filterColumnXpath = f(BUTTON_XPATH, buttonText);
    getWebDriver().findElement(By.xpath(filterColumnXpath)).click();
  }

  public void validateModalTitle(String modalText) {
    waitWhilePageIsLoading();
    pause2s();
    String modalXpath = f("//div[text()='%s']", modalText);
    Assertions.assertThat(getWebDriver().findElement(By.xpath(modalXpath)).isDisplayed())
        .as(f("Validation for Modal Title Text : %s", modalText))
        .isTrue();
  }

  public void validateTextIsDisplayed(String modalText) {
    waitWhilePageIsLoading();
    pause2s();
    String textXpath = f("//*[text()='%s']", modalText);
    Assertions.assertThat(getWebDriver().findElement(By.xpath(textXpath)).isDisplayed())
        .as(f("Validation for Text : %s", modalText))
        .isTrue();
  }

  public void validatetrackingIDtextboxIsEmpty() {
    waitUntilVisibilityOfElementLocated(trackingIdTextArea.getWebElement());
    Assertions.assertThat(trackingIdTextArea.getText().isEmpty())
        .as("Validation for TrackingID textbox is empty")
        .isTrue();
  }

  public void validateDisabledButton() {
    waitUntilVisibilityOfElementLocated(disabledValidateButton.getWebElement());
    Assertions.assertThat(disabledValidateButton.isDisplayed())
        .as("Validation for disabled button")
        .isTrue();
  }

  public void validateSaveReasonButtonIsDiabled() {
    Assertions.assertThat(disabledSaveReasonButton.isDisplayed())
        .as("Validation for disabled save reason button")
        .isTrue();
  }

  public void validateTrackingIdInInvalidAttemptModal(String trackingId) {
    String trackingIdXpath = f("//strong[text()='%s']", trackingId);
    Assertions.assertThat(getWebDriver().findElement(By.xpath(trackingIdXpath)).isDisplayed())
        .as(f("Validation for Tracking ID Text : %s in the Invalid attempy modal", trackingId))
        .isTrue();
  }

  public void verifyCurrentPageURL(String expectedURL) {
    waitWhilePageIsLoading();
    pause5s();
    String currentURL = getWebDriver().getCurrentUrl().trim();
    Assertions.assertThat(getWebDriver().getCurrentUrl().endsWith("/" + expectedURL)).
        as("Assertion for the URL ends with " + expectedURL).isTrue();
  }

  public void validatePODDetails(String trackingId) {
    validateTrackingId(trackingId);

  }

  public void validateTrackingId(String trackingId) {
    String trackingIdXpath = f("//a[text()='%s']", trackingId);
    Assertions.assertThat(getWebDriver().findElement(By.xpath(trackingIdXpath)).isDisplayed())
        .as(f("Validation for Tracking ID Text : %s", trackingId))
        .isTrue();
  }

  public void validateFailureReason(String failureReason) {
    String failureReasonXpath = f(
        "//div[text()='Failure Reason']//parent::div//following-sibling::div[text()='%s']",
        failureReason);
    Assertions.assertThat(getWebDriver().findElement(By.xpath(failureReasonXpath)).isDisplayed())
        .as(f("Validation for Failure Reason Text : %s", failureReason))
        .isTrue();
  }

  public void validateTransactionStatus(String transactionStatus) {
    String transactionStatusXpath = f(
        "//div[text()='Transaction Status']//parent::div//following-sibling::div//span[text()='%s']",
        transactionStatus);
    Assertions.assertThat(
            getWebDriver().findElement(By.xpath(transactionStatusXpath)).isDisplayed())
        .as(f("Validation for Transaction Status Text : %s", transactionStatus))
        .isTrue();
  }

  public void validateAttemptDateTime(String dateTime) {
    String dateTimeXpath = f(
        "//div[text()='Attempt Datetime']//parent::div//following-sibling::div[contains(text(),'%s')]",
        dateTime);
    Assertions.assertThat(getWebDriver().findElement(By.xpath(dateTimeXpath)).isDisplayed())
        .as(f("Validation for DateTime Text : %s", dateTime))
        .isTrue();
  }

  public void validateCOD(String COD) {
    String CODXpath = f("//div[text()='COD']//parent::div//following-sibling::div[text()='%s']",
        COD);
    Assertions.assertThat(getWebDriver().findElement(By.xpath(CODXpath)).isDisplayed())
        .as(f("Validation for COD Text : %s", COD))
        .isTrue();
  }

  public void validateShipperName(String shipperName) {
    String shipperNameXpath = f(
        "//div[text()='Shipper Name']//parent::div//following-sibling::div//p[contains(text(),'%s')]",
        shipperName);
    Assertions.assertThat(getWebDriver().findElement(By.xpath(shipperNameXpath)).isDisplayed())
        .as(f("Validation for shipperName Text : %s", shipperName))
        .isTrue();
  }

  public void validatePODPhoto() {
    Assertions.assertThat(podPhoto.isDisplayed())
        .as("Validation for POD photo")
        .isTrue();
  }

  public void validatePODSignature() {
    Assertions.assertThat(podSignature.isDisplayed())
        .as("Validation for POD signature")
        .isTrue();
  }


  public void validateLatitudeLongitude(String latitude, String logitude) {
    String latitudeXpath = f(
        "//div[text()='Attempt Lat Long']//parent::div//following::div[text()='%s']",
        latitude);
    Assertions.assertThat(getWebDriver().findElement(By.xpath(latitudeXpath)).isDisplayed())
        .as(f("Validation for latitude Text : %s", latitude))
        .isTrue();

    String logitudeXpath = f(
        "//div[text()='Attempt Lat Long']//parent::div//following::div[text()='%s']",
        logitude);
    Assertions.assertThat(getWebDriver().findElement(By.xpath(logitudeXpath)).isDisplayed())
        .as(f("Validation for longitude Text : %s", logitude))
        .isTrue();
  }

  public void validateDistanceFromWaypiontIsDisplayed() {
    String distanceXpath = "//div[text()='Distance from Waypoint']//parent::div//following-sibling::div";
    Assertions.assertThat(getWebDriver().findElement(By.xpath(distanceXpath)).isDisplayed())
        .as("Validation for distance Text")
        .isTrue();
  }

  public void validatePhone(String phone) {
    String phoneXpath = f(
        "//div[text()='Phone No.']//parent::div//following-sibling::div[text()='%s']", phone);
    Assertions.assertThat(getWebDriver().findElement(By.xpath(phoneXpath)).isDisplayed())
        .as(f("Validation for phone Text : %s", phone))
        .isTrue();
  }

  public void validateAddress(String address1, String address2, String postcode) {
    String address1Xpath = f(
        "//div[text()='Full Address']//parent::div//following::div[text()='%s']", address1);
    Assertions.assertThat(getWebDriver().findElement(By.xpath(address1Xpath)).isDisplayed())
        .as(f("Validation for address1 Text : %s", address1))
        .isTrue();
    String address2Xpath = f(
        "//div[text()='Full Address']//parent::div//following::div[text()='%s']", address2);
    Assertions.assertThat(getWebDriver().findElement(By.xpath(address2Xpath)).isDisplayed())
        .as(f("Validation for address1 Text : %s", address2))
        .isTrue();
    String postCodeXpath = f(
        "//div[text()='Full Address']//parent::div//following::div[text()='%s']", postcode);
    Assertions.assertThat(getWebDriver().findElement(By.xpath(postCodeXpath)).isDisplayed())
        .as(f("Validation for postcode Text : %s", postcode))
        .isTrue();
  }

  public void validateRelationship(String relationship) {
    String relationshipXpath = f(
        "//div[text()='Relationship']//parent::div//following-sibling::div[text()='%s']",
        relationship);
    Assertions.assertThat(getWebDriver().findElement(By.xpath(relationshipXpath)).isDisplayed())
        .as(f("Validation for relationship Text : %s", relationship))
        .isTrue();
  }

  public void validateCode(String code) {
    String codeXpath = f("//div[text()='Code']//parent::div//following-sibling::div[text()='%s']",
        code);
    Assertions.assertThat(getWebDriver().findElement(By.xpath(codeXpath)).isDisplayed())
        .as(f("Validation for Code Text : %s", code))
        .isTrue();
  }

  public int getAttemptsValidatedCount() {
    String count = attemptsValidatedCount.getText();
    return Integer.parseInt(count);
  }

  public void validateCountValueMatches(int beforeOrder, int afterOrder, int delta) {
    Assert.assertTrue(
        f("Assert that current count value: %s is increased by %s from %s to ", afterOrder,
            delta, beforeOrder),
        afterOrder == (beforeOrder + delta));
  }

  public void validateErrorMessage(String message) {
    String errorMessageXpath = f("//span[text()='%s']",
        message);
    Assertions.assertThat(getWebDriver().findElement(By.xpath(errorMessageXpath)).isDisplayed())
        .as(f("Validation for error message : %s", message))
        .isTrue();
  }

  public void validateDataInErrorMessage(String dataText) {
    String errorMessageDataXpath = f("//span[text()='%s']", dataText);
    Assertions.assertThat(getWebDriver().findElement(By.xpath(errorMessageDataXpath)).isDisplayed())
        .as(f("Validation for error message Data: %s", dataText))
        .isTrue();
  }

  public void validate404StatusCode(String statusCode) {
    String requestStatusCodeXpath = f("//div[text()='%s']", statusCode);
    Assertions.assertThat(
            getWebDriver().findElement(By.xpath(requestStatusCodeXpath)).isDisplayed())
        .as(f("Validation for Status code Text : %s", statusCode))
        .isTrue();
  }

  public void validateURL(String url) {
    String requestURLXpath = f("//span[text()='%s']", url);
    Assertions.assertThat(getWebDriver().findElement(By.xpath(requestURLXpath)).isDisplayed())
        .as(f("Validation for URL Text : %s", url))
        .isTrue();
  }

  public void closeNotification() {
    notificationCloseIcon.click();
  }

  public void selectDropdownValue(String fieldName, String value) {
    String dropDownxpath = "//label[contains(text(),'" + fieldName
        + "')]/ancestor::div[contains(@class,'ant-row ant-form-item')]//div[@class='ant-select-selector']//span[@class='ant-select-selection-item']";
    getWebDriver().findElement(By.xpath(dropDownxpath)).click();
    pause1s();
    getWebDriver().findElement(By.xpath(
        "//div[contains(@class, 'ant-select-dropdown')]//*[contains(normalize-space(text()), '"
            + value + "')]")).click();
  }

  public void loadValidateDeliveryOrPickAttemptPage() {
    getWebDriver().get("https://operatorv2-qa.ninjavan.co/#/sg/validate-attempt");
  }

  public void navigateBackInBrowser() {
    getWebDriver().navigate().back();
  }

  public void validatePendingAssignedPODModal() {
    switchToFrame();
    Assertions.assertThat(pendingAssignedPodText.isDisplayed())
        .as("Validation for Pending Assigned POD popup")
        .isTrue();
  }

  public void clickbackTotask() {
    backToTask.click();
  }

  public void selectValidator(String validatorName) {
    selectValidator.enterSearchTerm(validatorName);
    pause2s();
    selectValidator.sendReturnButton();
    webDriver.findElement(
            By.xpath(
                "//label[text()='Select Validator']//parent::div//following::div[@class='ant-select-selector'][1]//input"))
        .sendKeys(Keys.TAB);
  }

}



