package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.pricing.Script;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.RunCheckParams;
import co.nvqa.operator_v2.model.RunCheckResult;
import co.nvqa.operator_v2.model.VerifyDraftParams;
import co.nvqa.operator_v2.util.TestConstants;
import org.openqa.selenium.WebDriver;

import java.text.DecimalFormat;
import java.util.List;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class PricingScriptsV2CreateEditDraftPage extends OperatorV2SimplePage
{
    private final DecimalFormat RUN_CHECK_RESULT_DF = new DecimalFormat("###.###");

    protected static final int ACTION_SAVE = 1;
    protected static final int ACTION_SAVE_AND_EXIT = 2;
    protected static final int ACTION_DELETE = 3;

    public PricingScriptsV2CreateEditDraftPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void createDraft(Script script)
    {
        waitUntilPageLoaded("pricing-scripts-v2/create?type=normal");
        setScriptInfo(script);
        setWriteScript(script);
        saveDraft();
    }

    private void setScriptInfo(Script script)
    {
        clickTabItem("Script Info");
        sendKeysToMdInputContainerByModel("ctrl.data.script.name", script.getName());
        sendKeysToMdInputContainerByModel("ctrl.data.script.description", script.getDescription());
    }

    private void setWriteScript(Script script)
    {
        clickTabItem("Write Script");
        activateParameters(script.getActiveParameters());
        updateAceEditorValue(script.getSource());
        clickNvApiTextButtonByNameAndWaitUntilDone("container.pricing-scripts.check-syntax");
        String actualSyntaxInfo = getAttribute("//div[contains(@class, 'hint') and contains(@class, 'nv-hint') and contains(@class, 'info')]", "text");
        assertEquals("Syntax Info", "No errors found. You may proceed to verify or save the draft.", actualSyntaxInfo);
    }

    private void saveDraft()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("Save Draft");
        clickToast("Your script has been successfully created.");
    }

    private void activateParameters(List<String> activeParameters)
    {
        for (String activeParameter : activeParameters)
        {
            activateInactiveParameter(activeParameter);
        }
    }

    private void activateInactiveParameter(String parameterName)
    {
        clickf("//span[text()='Inactive Parameters']/following-sibling::div//md-input-container[following-sibling::div/span[text()='%s']]", parameterName);
    }

    public void deleteScript(Script script)
    {
        waitUntilPageLoaded(buildScriptUrl(script));
        waitUntilVisibilityOfElementLocated("//p[text()='No errors found. You may proceed to verify or save the draft.']");
        selectAction(ACTION_DELETE);
        clickButtonOnMdDialogByAriaLabel("Delete");
        clickToast(script.getName() + " has been successfully deleted.");
    }

    private String buildScriptUrl(Script script){
        return String.format("pricing-scripts-v2/%d?type=normal", script.getId());
    }

    public void runCheck(Script script, RunCheckParams runCheckParams)
    {
        waitUntilPageLoaded(buildScriptUrl(script));
        waitUntilVisibilityOfElementLocated("//p[text()='No errors found. You may proceed to verify or save the draft.']");
        clickTabItem("Check Script");

        selectValueFromMdSelectById("container.pricing-scripts.description-delivery-type", runCheckParams.getDeliveryType());
        selectValueFromMdSelectById("container.pricing-scripts.description-order-type", runCheckParams.getOrderType());
        selectValueFromMdSelectById("container.pricing-scripts.description-time-slot-type", runCheckParams.getTimeslotType());
        selectValueFromMdSelectById("commons.size", runCheckParams.getSize());
        sendKeysById("commons.weight", String.valueOf(runCheckParams.getWeight()));

        // Insured Value and COD Value have a special input method.
        // We need to round the value to 2 decimal digits and then multiply by 100.
        long insuredValue = Math.round(runCheckParams.getInsuredValue() * 100.0);
        long codValue = Math.round(runCheckParams.getCodValue() * 100.0);
        sendKeysByIdCustom1("container.pricing-scripts.description-insured-value", String.valueOf(insuredValue));
        sendKeysByIdCustom1("container.pricing-scripts.description-cod-value", String.valueOf(codValue));

        retryIfRuntimeExceptionOccurred(() -> selectValueFromNvAutocomplete("ctrl.view.textFromZone", runCheckParams.getFromZone()), "Select value from \"From Zone\" NvAutocomplete");
        retryIfRuntimeExceptionOccurred(() -> selectValueFromNvAutocomplete("ctrl.view.textToZone", runCheckParams.getToZone()), "Select value from \"To Zone\" NvAutocomplete");

        clickNvApiTextButtonByNameAndWaitUntilDone("container.pricing-scripts.run-check"); //Button Run Check
    }

    public void verifyTheRunCheckResultIsCorrect(RunCheckResult runCheckResult)
    {
        String actualGrandTotal = getTextTrimmed("//md-input-container[@model='ctrl.view.result.total_with_tax']/div[1]");
        String actualGst = getTextTrimmed("//md-input-container[@model='ctrl.view.result.total_tax']/div[1]");
        String actualDeliveryFee = getTextTrimmed("//md-input-container[@model='ctrl.view.result.deliveryFee']/div[1]");
        String actualInsuranceFee = getTextTrimmed("//md-input-container[@model='ctrl.view.result.insuranceFee']/div[1]");
        String actualCodFee = getTextTrimmed("//md-input-container[@model='ctrl.view.result.codFee']/div[1]");
        String actualHandlingFee = getTextTrimmed("//md-input-container[@model='ctrl.view.result.handlingFee']/div[1]");
        String actualComments = getTextTrimmed("//md-input-container[@model='ctrl.view.result.comments']/div[1]");

        // Remove [CURRENCY_CODE] + [SPACE]
        actualGrandTotal = actualGrandTotal.substring(4);
        actualGst = actualGst.substring(4);
        actualDeliveryFee = actualDeliveryFee.substring(4);
        actualInsuranceFee = actualInsuranceFee.substring(4);
        actualCodFee = actualCodFee.substring(4);
        actualHandlingFee = actualHandlingFee.substring(4);

        assertEquals("Grand Total", RUN_CHECK_RESULT_DF.format(runCheckResult.getGrandTotal()), actualGrandTotal);
        assertEquals("GST", RUN_CHECK_RESULT_DF.format(runCheckResult.getGst()), actualGst);
        assertEquals("Delivery Fee", RUN_CHECK_RESULT_DF.format(runCheckResult.getDeliveryFee()), actualDeliveryFee);
        assertEquals("Insurance Fee", RUN_CHECK_RESULT_DF.format(runCheckResult.getInsuranceFee()), actualInsuranceFee);
        assertEquals("COD Fee", RUN_CHECK_RESULT_DF.format(runCheckResult.getCodFee()), actualCodFee);
        assertEquals("Handling Fee", RUN_CHECK_RESULT_DF.format(runCheckResult.getHandlingFee()), actualHandlingFee);
        assertEquals("Comments", runCheckResult.getComments(), actualComments);
    }

    public void validateDraftAndReleaseScript(Script script, VerifyDraftParams verifyDraftParams)
    {
        waitUntilPageLoaded(buildScriptUrl(script));
        waitUntilVisibilityOfElementLocated("//p[text()='No errors found. You may proceed to verify or save the draft.']");
        clickNvIconTextButtonByName("Verify Draft");

        if (isElementExistFast("//input[starts-with(@id, 'start-weight')]"))
        {
            sendKeysById("start-weight", String.valueOf(verifyDraftParams.getStartWeight()));
            sendKeysById("end-weight", String.valueOf(verifyDraftParams.getEndWeight()));
        }

        clickNvIconTextButtonByName("container.pricing-scripts.validate");
        waitUntilVisibilityOfElementLocated("//p[text()='No validation errors found.']");
        clickNvIconTextButtonByNameAndWaitUntilDone("Release Script");
    }

    public void cancelEditDraft()
    {
        clickNvIconTextButtonByName("commons.cancel");
    }

    public void selectAction(int actionType)
    {
        clickNvIconButtonByName("commons.actions");

        switch (actionType)
        {
            case ACTION_SAVE:
                click("//div[@ng-repeat='action in ctrl.manageScriptActions'][normalize-space()='Save']");
                break;
            case ACTION_SAVE_AND_EXIT:
                click("//div[@ng-repeat='action in ctrl.manageScriptActions'][normalize-space()='Save and Exit']");
                break;
            case ACTION_DELETE:
                click("//div[@ng-repeat='action in ctrl.manageScriptActions'][normalize-space()='Delete']");
                break;
        }

        pause1s();
    }

    private void updateAceEditorValue(String script)
    {
        /*
          editor.setValue(str, -1) // Moves cursor to the start.
          editor.setValue(str, 1) // Moves cursor to the end.
         */
        executeScript(String.format("window.ace.edit('ace-editor').setValue('%s', 1);", script));
    }

    public void waitUntilPageLoaded(String expectedUrlEndsWith)
    {
        super.waitUntilPageLoaded();

        waitUntil(() ->
        {
            String currentUrl = getCurrentUrl();
            NvLogger.infof("PricingScriptsV2CreateEditDraftPage.waitUntilPageLoaded: Current URL = [%s] - Expected URL contains = [%s]", currentUrl, expectedUrlEndsWith);
            return currentUrl.endsWith(expectedUrlEndsWith);
        }, TestConstants.SELENIUM_WEB_DRIVER_WAIT_TIMEOUT_IN_MILLISECONDS, String.format("Current URL does not contain '%s'.", expectedUrlEndsWith));
    }
}
