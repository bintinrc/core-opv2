package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.pricing.Script;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.RunCheckParams;
import co.nvqa.operator_v2.model.RunCheckResult;
import co.nvqa.operator_v2.model.VerifyDraftParams;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonFilePicker;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconButton;
import co.nvqa.operator_v2.util.TestConstants;
import java.io.File;
import java.text.DecimalFormat;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.junit.platform.commons.util.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class PricingScriptsV2CreateEditDraftPage extends OperatorV2SimplePage {

  @FindBy(name = "commons.actions")
  public NvIconButton actionsButton;

  @FindBy(xpath = "//button[contains(@class,'dropdown-trigger')]")
  private PageElement buttonActionDropdown;

  @FindBy(xpath = "//div[text()='No errors found. You may proceed to verify or save the draft.']")
  public PageElement noErrorsMessage;

  @FindBy(xpath = "//button[@data-testid='deleteScript.confirmBtn']")
  public PageElement buttonConfirmDelete;

  @FindBy(xpath = "//span[text()='Delete Draft']")
  private PageElement buttonDeleteDraft;

  @FindBy(css = "md-dialog")
  public ConfirmDeleteDialog confirmDeleteDialog;

  @FindBy(id = "button-pick-csv")
  public NvButtonFilePicker importCsv;

  @FindBy(xpath = "//button[@data-testid='createEditScript.saveDraftBtn']/..")
  public NvApiTextButton saveDraftBtn;

  @FindBy(xpath = "//button[@data-testid='writeScript.checkSyntaxBtn']/..")
  public NvApiTextButton checkSyntaxBtn;

  @FindBy(xpath = "//button[@data-testid='checkScript.runCheckBtn']/..")
  public NvApiTextButton runCheckBtn;

  private final DecimalFormat RUN_CHECK_RESULT_DF = new DecimalFormat("###.###");

  protected static final int ACTION_SAVE = 1;
  protected static final int ACTION_SAVE_AND_EXIT = 2;
  protected static final int ACTION_DELETE = 3;

  public PricingScriptsV2CreateEditDraftPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void createDraft(Script script) {
    waitUntilPageLoaded("pricing-scripts-v2/create?type=normal");
    setScriptInfo(script);
    setWriteScript(script);
  }

  public void createDraftAndSave(Script script) {
    waitUntilPageLoaded("pricing-scripts-v2/create?type=normal");
    setScriptInfo(script);
    setWriteScript(script);
    assertTrue("Run Syntax is visible", isElementVisible(
        "//div[@text='Run a syntax check before saving or verifying the draft.']"));
    checkSuccessfulSyntax();
    saveDraft();
    waitUntilVisibilityOfToast("Your script has been successfully created.");
  }

  private void setScriptInfo(Script script) {
    clickTabItem("Script Info");
    String name = script.getName();
    String description = script.getDescription();
    if (!name.equalsIgnoreCase("empty")) {
      sendKeys(f("//input[@data-testid='%s']", "scriptInfo.scriptName"), script.getName());
    }
    if (!description.equalsIgnoreCase("empty")) {
      sendKeys(f("//textarea[@data-testid='%s']", "scriptInfo.scriptDescription"),
          script.getDescription());
    }
  }

  private void setWriteScript(Script script) {
    clickTabItem("Write Script");
    if (Objects.nonNull(script.getHasTemplate())) {
      sendKeysAndEnter("//input[@type='search']", script.getTemplateName());
      click("//button[@data-testid='checkScript.loadTemplateBtn']");
    }
    if (Objects.nonNull(script.getIsCsvFile())) {
      String csvFileName = "sample_upload_rates.csv";
      File csvFile = createFile(csvFileName, script.getFileContent());
      importCsv.setValue(csvFile);
    }
    if (Objects.nonNull(script.getSource())) {
      waitUntilVisibilityOfElementLocated("//div[@id='pricing-script-editor']");
      updateAceEditorValue(script.getSource());
    }
    if (Objects.nonNull(script.getActiveParameters())) {
      activateParameters(script.getActiveParameters());
    }
  }

  public void checkSuccessfulSyntax() {
    checkSyntaxBtn.clickAndWaitUntilDone();
    checkSyntaxHeader("No errors found. You may proceed to verify or save the draft.");
  }


  public void checkSyntaxHeader(String message) {
    waitUntilVisibilityOfElementLocated("//div[contains(text(),'" + message + "')]");
    String actualErrorInfo = getText("//div[contains(@class,'ant-alert-message')]");
    Assertions.assertThat(actualErrorInfo).contains(message);
  }

  public void editScript(Script script) {
    waitUntilPageLoaded(buildEditScriptUrl(script));
    setWriteScript(script);
  }

  public void saveDraft() {
    pause2s();
    saveDraftBtn.clickAndWaitUntilDone();
  }

  public void validateDraft() {
    waitUntilVisibilityOfElementLocated("//div[text()='Verify Draft']");
    clickNvIconTextButtonByName("Validate");
    waitUntilVisibilityOfElementLocated("//div[text()='No validation errors found.']");
    clickNvIconTextButtonByNameAndWaitUntilDone("Release Script");
  }

  private void activateParameters(List<String> activeParameters) {
    String xpath = "//span[text()='Inactive Parameters']/following-sibling::div//md-input-container";
    if (isElementExistFast(xpath)) {
      for (String activeParameter : activeParameters) {
        activateInactiveParameter(activeParameter);
      }
    }
  }

  private void activateInactiveParameter(String parameterName) {
    clickf(
        "//span[text()='Inactive Parameters']/following-sibling::div//md-input-container[following-sibling::div/span[text()='%s']]",
        parameterName);
  }

  public void deleteScript(Script script) {
    waitUntilPageLoaded(buildEditScriptUrl(script));
    noErrorsMessage.waitUntilClickable();
    selectAction(ACTION_DELETE);
  }

  private String buildScriptUrl(Script script) {
    return String.format("pricing-scripts-v2/%d?type=normal", script.getId());
  }

  private String buildEditScriptUrl(Script script) {
    return String.format("pricing-scripts-v2/edit?scriptId=%d&type=normal", script.getId());
  }

  public void runCheck(Script script, RunCheckParams runCheckParams) {
    waitUntilPageLoaded(buildEditScriptUrl(script));
    checkSyntaxBtn.clickAndWaitUntilDone();
    waitUntilVisibilityOfElementLocated(
        "//div[text()='No errors found. You may proceed to verify or save the draft.']");
    clickTabItem("Check Script");
    clickf("//span[text()='%s']", runCheckParams.getOrderFields());
    if (runCheckParams.getOrderFields().equals("New")) {
      selectValueFromMdSelectByName("serviceLevel",
          runCheckParams.getServiceLevel());
      selectValueFromMdSelectByName("serviceType",
          runCheckParams.getServiceType());
    } else {
      selectValueFromMdSelectByName("deliveryType",
          runCheckParams.getDeliveryType());
      selectValueFromMdSelectByName("orderType",
          runCheckParams.getOrderType());
    }
    selectValueFromMdSelectByName("timeslot",
        runCheckParams.getTimeslotType());
    clickf("//div[@name='isRTS']//div[@title='%s']", runCheckParams.getIsRts());
    selectValueFromMdSelectByName("size",
        runCheckParams.getSize());
    pause50ms();
    deleteText("//input[@name= 'weight']");
    sendKeysByName("weight", String.valueOf(runCheckParams.getWeight()));

    // Insured Value and COD Value have a special input method.
    // We need to round the value to 2 decimal digits and then multiply by 100.
    String insuredValue = runCheckParams.getInsuredValue();
    String codValue = runCheckParams.getCodValue();
    deleteText("//*[self::input or self::textarea][starts-with(@name, 'insuredValue')]");
    sendKeysByName("insuredValue", String.valueOf(insuredValue));
    deleteText("//*[self::input or self::textarea][starts-with(@name, 'codValue')]");
    sendKeysByName("codValue", String.valueOf(codValue));
    if (Objects.nonNull(runCheckParams.getFromZone())) {
      scrollIntoView(f("//div[@name='%s']//input", "fromZone"));
      clickf("//div[@name='%s']//input", "fromZone");
      pause1s();
      clickf(
          "//div[@class='ant-select-dropdown ant-select-dropdown-placement-bottomLeft ']//div[text()='%s' and contains(@class,'option')]",
          runCheckParams.getFromZone());
      pause50ms();
    }
    if (Objects.nonNull(runCheckParams.getToZone())) {
      scrollIntoView(f("//div[@name='%s']//input", "toZone"));
      clickf("//div[@name='%s']//input", "toZone");
      pause1s();
      clickf(
          "//div[@class='ant-select-dropdown ant-select-dropdown-placement-bottomLeft ']//div[text()='%s' and contains(@class,'option')]",
          runCheckParams.getToZone());
      pause50ms();
    }
    if (Objects.nonNull(runCheckParams.getFromL1())) {
//      sendKeysByName("container.pricing-scripts.from-l1", runCheckParams.getFromL1());
      sendKeysByName("fromL1",
          runCheckParams.getFromL1());
    }
    if (Objects.nonNull(runCheckParams.getToL1())) {
//      sendKeysByName("container.pricing-scripts.to-l1", runCheckParams.getToL1());
      sendKeysByName("toL1",
          runCheckParams.getToL1());
    }
    if (Objects.nonNull(runCheckParams.getFromL2())) {
//      sendKeysByName("container.pricing-scripts.from-l2", runCheckParams.getFromL2());
      sendKeysByName("fromL2",
          runCheckParams.getFromL2());
    }
    if (Objects.nonNull(runCheckParams.getToL2())) {
//      sendKeysByName("container.pricing-scripts.to-l2", runCheckParams.getToL2());
      sendKeysByName("toL2",
          runCheckParams.getToL2());
    }
    if (Objects.nonNull(runCheckParams.getFromL3())) {
//      sendKeysByName("container.pricing-scripts.from-l3", runCheckParams.getFromL3());
      sendKeysByName("fromL3",
          runCheckParams.getFromL3());
    }
    if (Objects.nonNull(runCheckParams.getToL3())) {
//      sendKeysByName("container.pricing-scripts.to-l3", runCheckParams.getToL3());
      sendKeysByName("toL3",
          runCheckParams.getToL3());
    }
    if (Objects.nonNull(runCheckParams.getOriginPricingZone())) {
      deleteText("//input[@name= 'originalPricingZone']");
      if (runCheckParams.getOriginPricingZone().equalsIgnoreCase("empty")) {
        sendKeysByName("originalPricingZone", "");
      } else {
        sendKeysByName("originalPricingZone",
            runCheckParams.getOriginPricingZone());
      }
    }
    if (Objects.nonNull(runCheckParams.getDestinationPricingZone())) {
      deleteText("//input[@name= 'destinationPricingZone']");
      if (runCheckParams.getDestinationPricingZone().equalsIgnoreCase("empty")) {
        sendKeysByName("destinationPricingZone", "");
      } else {
        sendKeysByName("destinationPricingZone",
            runCheckParams.getDestinationPricingZone());
      }
    }
    runCheckBtn.clickAndWaitUntilDone();
  }

  public void verifyErrorMessage(String errorMessage, String status) {
    Map<String, String> toastData = waitUntilVisibilityAndGetErrorToastData();

    if (StringUtils.isNotBlank(status)) {
      Assertions.assertThat(toastData.get("status")).as("Error toast status")
          .isEqualToIgnoringCase(status);
    }
    if (StringUtils.isNotBlank(errorMessage)) {
      Assertions.assertThat(toastData.get("errorMessage")).as("Error toast status")
          .isEqualToIgnoringCase(errorMessage);
    }
  }

  public void verifyTheRunCheckResultIsCorrect(RunCheckResult runCheckResult) {
    pause2s();
    String actualGrandTotal = getTextTrimmed(
        "//span[text()='Grand Total']/parent::div/following-sibling::div/span");
    String actualGst = getTextTrimmed(
        "//span[text()='GST']/parent::div/following-sibling::div/span");
    String actualDeliveryFee = getTextTrimmed(
        "//span[text()='Delivery Fee']/parent::div/following-sibling::div/span");
    String actualInsuranceFee = getTextTrimmed(
        "//span[text()='Insurance Fee']/parent::div/following-sibling::div/span");
    String actualCodFee = getTextTrimmed(
        "//span[text()='COD Fee']/parent::div/following-sibling::div/span");
    String actualHandlingFee = getTextTrimmed(
        "//span[text()='Handling Fee']/parent::div/following-sibling::div/span");
    String actualComments = getTextTrimmed(
        "//span[text()='Comments']/parent::div/following-sibling::div/span");

    // Remove [CURRENCY_CODE] + [SPACE]
    actualGrandTotal = actualGrandTotal.substring(4);
//    actualGst = actualGst.substring(4);
    actualDeliveryFee = actualDeliveryFee.substring(4);
    actualInsuranceFee = actualInsuranceFee.substring(4);
    actualCodFee = actualCodFee.substring(4);
    actualHandlingFee = actualHandlingFee.substring(4);

    SoftAssertions softAssertions = new SoftAssertions();
    softAssertions.assertThat(actualGrandTotal).as("Grand Total is correct")
        .isEqualTo(RUN_CHECK_RESULT_DF.format(runCheckResult.getGrandTotal()));
    softAssertions.assertThat(actualGst).as("GST is correct")
        .isEqualTo(RUN_CHECK_RESULT_DF.format(runCheckResult.getGst()), actualGst);
    softAssertions.assertThat(actualDeliveryFee).as("Delivery Fee is correct")
        .isEqualTo(RUN_CHECK_RESULT_DF.format(runCheckResult.getDeliveryFee()));
    softAssertions.assertThat(actualInsuranceFee).as("Insurance Fee is correct")
        .isEqualTo(RUN_CHECK_RESULT_DF.format(runCheckResult.getInsuranceFee()));
    softAssertions.assertThat(actualCodFee).as("COD Fee is correct")
        .isEqualTo(RUN_CHECK_RESULT_DF.format(runCheckResult.getCodFee()), actualCodFee);
    softAssertions.assertThat(actualHandlingFee).as("Handling Fee is correct")
        .isEqualTo(RUN_CHECK_RESULT_DF.format(runCheckResult.getHandlingFee()));
    softAssertions.assertThat(actualComments).as("Comments is correct")
        .isEqualTo(runCheckResult.getComments(), actualComments);
    softAssertions.assertAll();
  }

  public void validateDraftAndReleaseScript(Script script, VerifyDraftParams verifyDraftParams) {
    waitUntilPageLoaded(buildScriptUrl(script));
    waitUntilVisibilityOfElementLocated(
        "//div[text()='No errors found. You may proceed to verify or save the draft.']");
    clickNvIconTextButtonByName("Verify Draft");

    if (isElementExistFast("//input[starts-with(@id, 'start-weight')]")) {
      sendKeysById("start-weight", String.valueOf(verifyDraftParams.getStartWeight()));
      sendKeysById("end-weight", String.valueOf(verifyDraftParams.getEndWeight()));
    }
    validateDraft();
  }

  public void validateDraftAndReleaseScript(Script script) {
    waitUntilPageLoaded(buildEditScriptUrl(script));
    waitUntilVisibilityOfElementLocated(
        "//div[text()='No errors found. You may proceed to verify or save the draft.']");
    clickNvIconTextButtonByName("Verify Draft");
    validateDraft();
  }

  public String validateDraftAndReturnWarnings(Script script) {
    waitUntilPageLoaded(buildScriptUrl(script));
    waitUntilVisibilityOfElementLocated(
        "//div[text()='No errors found. You may proceed to verify or save the draft.']");
    clickNvIconTextButtonByName("Verify Draft");
    clickNvIconTextButtonByName("container.pricing-scripts.validate");
    return getText("//div[@type='error']").replace("\n", "");
  }

  public void cancelEditDraft() {
    clickNvIconTextButtonByName("Cancel");
  }

  public void selectAction(int actionType) {
    buttonActionDropdown.moveToElement();

    switch (actionType) {
      case ACTION_SAVE:
        click("//div[@ng-repeat='action in ctrl.manageScriptActions'][normalize-space()='Save']");
        break;
      case ACTION_SAVE_AND_EXIT:
        click(
            "//div[@ng-repeat='action in ctrl.manageScriptActions'][normalize-space()='Save and Exit']");
        break;
      case ACTION_DELETE:
        buttonDeleteDraft.click();
        buttonConfirmDelete.click();
        break;
    }

    pause1s();
  }

  private void updateAceEditorValue(String script) {
        /*
          editor.setValue(str, -1) // Moves cursor to the start.
          editor.setValue(str, 1) // Moves cursor to the end.
         */
    executeScript(
        String.format("window.ace.edit('pricing-script-editor').setValue('%s', 1);", script));
  }

  public void waitUntilPageLoaded(String expectedUrlEndsWith) {
    super.waitUntilPageLoaded();

    waitUntil(() -> {
          String currentUrl = getCurrentUrl();
          NvLogger.infof(
              "PricingScriptsV2CreateEditDraftPage.waitUntilPageLoaded: Current URL = [%s] - Expected URL contains = [%s]",
              currentUrl, expectedUrlEndsWith);
          return currentUrl.endsWith(expectedUrlEndsWith);
        }, TestConstants.SELENIUM_WEB_DRIVER_WAIT_TIMEOUT_IN_MILLISECONDS,
        String.format("Current URL does not contain '%s'.", expectedUrlEndsWith));
  }
}