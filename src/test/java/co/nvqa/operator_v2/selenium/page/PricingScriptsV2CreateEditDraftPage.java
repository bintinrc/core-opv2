package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.pricing.Script;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.RunCheckParams;
import co.nvqa.operator_v2.model.RunCheckResult;
import co.nvqa.operator_v2.model.VerifyDraftParams;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonFilePicker;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconButton;
import co.nvqa.operator_v2.util.TestConstants;
import java.io.File;
import java.text.DecimalFormat;
import java.util.List;
import java.util.Map;
import java.util.Objects;
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

  @FindBy(xpath = "//p[text()='No errors found. You may proceed to verify or save the draft.']")
  public PageElement noErrorsMessage;

  @FindBy(xpath = "//div[@ng-repeat='action in ctrl.manageScriptActions'][normalize-space()='Delete']")
  public PageElement deleteAction;

  @FindBy(css = "md-dialog")
  public ConfirmDeleteDialog confirmDeleteDialog;

  @FindBy(id = "button-pick-csv")
  public NvButtonFilePicker importCsv;

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
    boolean headerHint = isElementVisible(
        "//div[@text='Run a syntax check before saving or verifying the draft.']");
    if (headerHint) {
      checkSyntax(script);
    }
  }

  private void setScriptInfo(Script script) {
    clickTabItem("Script Info");
    sendKeys(f("//md-input-container[@model='%s']//input", "ctrl.data.script.name"),
        script.getName());
    sendKeys(f("//md-input-container[@model='%s']//input", "ctrl.data.script.description"),
        script.getDescription());
  }

  private void setWriteScript(Script script) {
    clickTabItem("Write Script");
    if (Objects.nonNull(script.getHasTemplate())) {
      sendKeysAndEnter("//input[@ng-model='$mdAutocompleteCtrl.scope.searchText']",
          script.getTemplateName());
      click("//button[@aria-label='Load']");
    }
    if (Objects.nonNull(script.getIsCsvFile())) {
      String csvFileName = "sample_upload_rates.csv";
      File csvFile = createFile(csvFileName, script.getFileContent());
      importCsv.setValue(csvFile);
    }
    if (Objects.nonNull(script.getSource()) && Objects.nonNull(script.getActiveParameters())) {
      activateParameters(script.getActiveParameters());
      updateAceEditorValue(script.getSource());
    }
  }

  private void checkSyntax(Script script) {
    clickNvApiTextButtonByNameAndWaitUntilDone("container.pricing-scripts.check-syntax");
    String headerHintXpath = "//div[contains(@class, 'hint') and contains(@class, 'nv-hint') and contains(@class, 'info') and contains(@text, 'No errors found')]";
    boolean headerHint = isElementVisible(headerHintXpath);
    if (headerHint) {
      String actualSyntaxInfo = getAttribute(headerHintXpath, "text");
      assertEquals("Syntax Info", "No errors found. You may proceed to verify or save the draft.",
          actualSyntaxInfo);
      if (isElementVisible("//nv-api-text-button[@name='Save Draft']")) {
        saveDraft();
      } else {
        validateDraftAndReleaseScript(script);
      }
    }
  }

  public void checkErrorHeader(String message) {
    String actualErrorInfo = getText("//div[contains(@class,'hint')]");
    assertTrue(actualErrorInfo.contains(message));
  }

  public void editScript(Script script) {
    waitUntilPageLoaded(buildScriptUrl(script));
    setWriteScript(script);
    checkSyntax(script);
  }

  private void saveDraft() {
    pause2s();
    clickNvApiTextButtonByNameAndWaitUntilDone("Save Draft");
    clickToast("Your script has been successfully created.");
  }

  private void validateDraft() {
    clickNvIconTextButtonByName("container.pricing-scripts.validate");
    waitUntilVisibilityOfElementLocated("//p[text()='No validation errors found.']");
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
    waitUntilPageLoaded(buildScriptUrl(script));
    noErrorsMessage.waitUntilClickable();
    selectAction(ACTION_DELETE);
    confirmDeleteDialog.confirmDelete();
    waitUntilInvisibilityOfToast(script.getName() + " has been successfully deleted.", true);
  }

  private String buildScriptUrl(Script script) {
    return String.format("pricing-scripts-v2/%d?type=normal", script.getId());
  }

  public void runCheck(Script script, RunCheckParams runCheckParams) {
    waitUntilPageLoaded(buildScriptUrl(script));
    waitUntilVisibilityOfElementLocated(
        "//p[text()='No errors found. You may proceed to verify or save the draft.']");
    clickTabItem("Check Script");
    clickf("//button[@aria-label='%s']", runCheckParams.getOrderFields());
    if (runCheckParams.getOrderFields().equals("New")) {
      selectValueFromMdSelectById("container.pricing-scripts.description-service-level",
          runCheckParams.getServiceLevel());
      selectValueFromMdSelectById("container.pricing-scripts.description-service-type",
          runCheckParams.getServiceType());
    } else {
      selectValueFromMdSelectById("container.pricing-scripts.description-delivery-type",
          runCheckParams.getDeliveryType());
      selectValueFromMdSelectById("container.pricing-scripts.description-order-type",
          runCheckParams.getOrderType());
    }
    selectValueFromMdSelectById("container.pricing-scripts.description-time-slot-type",
        runCheckParams.getTimeslotType());
    clickf("//button[@aria-label='%s']", runCheckParams.getIsRts());
    click(".//md-select[starts-with(@id, \"commons.size\")]");
    pause1s();
    clickf(
        "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[@value= \"%s\"]",
        runCheckParams.getSize());
    pause50ms();
    sendKeysById("commons.weight", String.valueOf(runCheckParams.getWeight()));

    // Insured Value and COD Value have a special input method.
    // We need to round the value to 2 decimal digits and then multiply by 100.
    long insuredValue = Math.round(runCheckParams.getInsuredValue() * 100.0);
    long codValue = Math.round(runCheckParams.getCodValue() * 100.0);
    sendKeysByIdCustom1("container.pricing-scripts.description-insured-value",
        String.valueOf(insuredValue));
    sendKeysByIdCustom1("container.pricing-scripts.description-cod-value",
        String.valueOf(codValue));
    if (Objects.nonNull(runCheckParams.getFromZone())) {
      retryIfRuntimeExceptionOccurred(
          () -> selectValueFromNvAutocomplete("ctrl.view.textFromZone",
              runCheckParams.getFromZone()),
          "Select value from \"From Zone\" NvAutocomplete");
    }
    if (Objects.nonNull(runCheckParams.getToZone())) {
      retryIfRuntimeExceptionOccurred(
          () -> selectValueFromNvAutocomplete("ctrl.view.textToZone",
              runCheckParams.getToZone()),
          "Select value from \"To Zone\" NvAutocomplete");
    }
    if (Objects.nonNull(runCheckParams.getFromL1())) {
      sendKeysByName("container.pricing-scripts.from-l1", runCheckParams.getFromL1());
    }
    if (Objects.nonNull(runCheckParams.getToL1())) {
      sendKeysByName("container.pricing-scripts.to-l1", runCheckParams.getToL1());
    }
    if (Objects.nonNull(runCheckParams.getFromL2())) {
      sendKeysByName("container.pricing-scripts.from-l2", runCheckParams.getFromL2());
    }
    if (Objects.nonNull(runCheckParams.getToL2())) {
      sendKeysByName("container.pricing-scripts.to-l2", runCheckParams.getToL2());
    }
    if (Objects.nonNull(runCheckParams.getFromL3())) {
      sendKeysByName("container.pricing-scripts.from-l3", runCheckParams.getFromL3());
    }
    if (Objects.nonNull(runCheckParams.getToL3())) {
      sendKeysByName("container.pricing-scripts.to-l3", runCheckParams.getToL3());
    }
    if (Objects.nonNull(runCheckParams.getOriginPricingZone())) {
      if (runCheckParams.getOriginPricingZone().equalsIgnoreCase("empty")) {
        sendKeysByName("container.pricing-scripts.origin-pz", "");
      } else {
        sendKeysByName("container.pricing-scripts.origin-pz",
            runCheckParams.getOriginPricingZone());
      }
    }
    if (Objects.nonNull(runCheckParams.getDestinationPricingZone())) {
      if (runCheckParams.getDestinationPricingZone().equalsIgnoreCase("empty")) {
        sendKeysByName("container.pricing-scripts.dest-pz", "");
      } else {
        sendKeysByName("container.pricing-scripts.dest-pz",
            runCheckParams.getDestinationPricingZone());
      }
    }
    clickNvApiTextButtonByNameAndWaitUntilDone(
        "container.pricing-scripts.run-check"); //Button Run Check
  }

  public void verifyErrorMessage(String errorMessage, String status) {
    Map<String, String> toastData = waitUntilVisibilityAndGetErrorToastData();

    if (StringUtils.isNotBlank(status)) {
      assertThat("Error toast status", toastData.get("status"), equalToIgnoringCase(status));
    }
    if (StringUtils.isNotBlank(errorMessage)) {
      assertThat("Error toast status", toastData.get("errorMessage"),
          equalToIgnoringCase(errorMessage));
    }
  }

  public void verifyTheRunCheckResultIsCorrect(RunCheckResult runCheckResult) {
    String actualGrandTotal = getTextTrimmed(
        "//md-input-container[@model='ctrl.view.result.total_with_tax']/div[1]");
    String actualGst = getTextTrimmed(
        "//md-input-container[@model='ctrl.view.result.total_tax']/div[1]");
    String actualDeliveryFee = getTextTrimmed(
        "//md-input-container[@model='ctrl.view.result.deliveryFee']/div[1]");
    String actualInsuranceFee = getTextTrimmed(
        "//md-input-container[@model='ctrl.view.result.insuranceFee']/div[1]");
    String actualCodFee = getTextTrimmed(
        "//md-input-container[@model='ctrl.view.result.codFee']/div[1]");
    String actualHandlingFee = getTextTrimmed(
        "//md-input-container[@model='ctrl.view.result.handlingFee']/div[1]");
    String actualComments = getTextTrimmed(
        "//md-input-container[@model='ctrl.view.result.comments']/div[1]");

    // Remove [CURRENCY_CODE] + [SPACE]
    actualGrandTotal = actualGrandTotal.substring(4);
    actualGst = actualGst.substring(4);
    actualDeliveryFee = actualDeliveryFee.substring(4);
    actualInsuranceFee = actualInsuranceFee.substring(4);
    actualCodFee = actualCodFee.substring(4);
    actualHandlingFee = actualHandlingFee.substring(4);

    assertEquals("Grand Total", RUN_CHECK_RESULT_DF.format(runCheckResult.getGrandTotal()),
        actualGrandTotal);
    assertEquals("GST", RUN_CHECK_RESULT_DF.format(runCheckResult.getGst()), actualGst);
    assertEquals("Delivery Fee", RUN_CHECK_RESULT_DF.format(runCheckResult.getDeliveryFee()),
        actualDeliveryFee);
    assertEquals("Insurance Fee", RUN_CHECK_RESULT_DF.format(runCheckResult.getInsuranceFee()),
        actualInsuranceFee);
    assertEquals("COD Fee", RUN_CHECK_RESULT_DF.format(runCheckResult.getCodFee()), actualCodFee);
    assertEquals("Handling Fee", RUN_CHECK_RESULT_DF.format(runCheckResult.getHandlingFee()),
        actualHandlingFee);
    assertEquals("Comments", runCheckResult.getComments(), actualComments);
  }

  public void validateDraftAndReleaseScript(Script script, VerifyDraftParams verifyDraftParams) {
    waitUntilPageLoaded(buildScriptUrl(script));
    waitUntilVisibilityOfElementLocated(
        "//p[text()='No errors found. You may proceed to verify or save the draft.']");
    clickNvIconTextButtonByName("Verify Draft");

    if (isElementExistFast("//input[starts-with(@id, 'start-weight')]")) {
      sendKeysById("start-weight", String.valueOf(verifyDraftParams.getStartWeight()));
      sendKeysById("end-weight", String.valueOf(verifyDraftParams.getEndWeight()));
    }
    validateDraft();
  }

  public void validateDraftAndReleaseScript(Script script) {
    waitUntilPageLoaded(buildScriptUrl(script));
    waitUntilVisibilityOfElementLocated(
        "//p[text()='No errors found. You may proceed to verify or save the draft.']");
    clickNvIconTextButtonByName("Verify Draft");
    validateDraft();
  }

  public void cancelEditDraft() {
    clickNvIconTextButtonByName("commons.cancel");
  }

  public void selectAction(int actionType) {
    actionsButton.click();

    switch (actionType) {
      case ACTION_SAVE:
        click("//div[@ng-repeat='action in ctrl.manageScriptActions'][normalize-space()='Save']");
        break;
      case ACTION_SAVE_AND_EXIT:
        click(
            "//div[@ng-repeat='action in ctrl.manageScriptActions'][normalize-space()='Save and Exit']");
        break;
      case ACTION_DELETE:
        deleteAction.click();
        break;
    }

    pause1s();
  }

  private void updateAceEditorValue(String script) {
        /*
          editor.setValue(str, -1) // Moves cursor to the start.
          editor.setValue(str, 1) // Moves cursor to the end.
         */
    executeScript(String.format("window.ace.edit('ace-editor').setValue('%s', 1);", script));
  }

  public void waitUntilPageLoaded(String expectedUrlEndsWith) {
    super.waitUntilPageLoaded();

    waitUntil(() ->
        {
          String currentUrl = getCurrentUrl();
          NvLogger.infof(
              "PricingScriptsV2CreateEditDraftPage.waitUntilPageLoaded: Current URL = [%s] - Expected URL contains = [%s]",
              currentUrl, expectedUrlEndsWith);
          return currentUrl.endsWith(expectedUrlEndsWith);
        }, TestConstants.SELENIUM_WEB_DRIVER_WAIT_TIMEOUT_IN_MILLISECONDS,
        String.format("Current URL does not contain '%s'.", expectedUrlEndsWith));
  }
}