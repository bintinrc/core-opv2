package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.pricing.Script;
import co.nvqa.commons.utils.NvLogger;
import co.nvqa.operator_v2.model.VerifyDraftParams;
import co.nvqa.operator_v2.util.TestConstants;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.util.List;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class TimeBoundedScriptsCreateEditPage extends OperatorV2SimplePage
{
    protected static final int ACTION_DELETE = 3;

    public TimeBoundedScriptsCreateEditPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void createAndReleaseTimeBoundedScript(Script parentScript, Script script, VerifyDraftParams verifyDraftParams)
    {
        waitUntilPageLoaded(String.format("pricing-scripts-v2/%s/create", parentScript.getId()));
        setTimeBoundedScriptInfo(script);
        setWriteScript(script);
        validateAndReleaseScript(verifyDraftParams);
    }

    public void setTimeBoundedScriptInfo(Script script)
    {
        clickTabItem(" Time-Bounded Script Info ");
        sendKeysToMdInputContainerByModel("ctrl.data.script.name", script.getName());
        setMdDatepicker("ctrl.data.script.start_date", script.getVersionEffectiveStartDate());
        setMdDatepicker("ctrl.data.script.end_date", script.getVersionEffectiveEndDate());
    }

    private void setWriteScript(Script script)
    {
        clickTabItem("Write Script");
        activateParameters(script.getActiveParameters());
        updateAceEditorValue(script.getSource());
        clickNvApiTextButtonByNameAndWaitUntilDone("container.pricing-scripts.check-syntax");
        String actualSyntaxInfo = getAttribute("//div[contains(@class, 'hint') and contains(@class, 'nv-hint') and contains(@class, 'info')]", "text");
        Assert.assertEquals("Syntax Info", "No errors found. You may proceed to verify or save the draft.", actualSyntaxInfo);
    }

    private void activateParameters(List<String> activeParameters)
    {
        for(String activeParameter : activeParameters)
        {
            activateInactiveParameter(activeParameter);
        }
    }

    private void activateInactiveParameter(String parameterName)
    {
        clickf("//span[text()='Inactive Parameters']/following-sibling::div//md-input-container[following-sibling::div/span[text()='%s']]", parameterName);
    }

    public void validateAndReleaseScript(VerifyDraftParams verifyDraftParams)
    {
        clickNvIconTextButtonByName("Verify Draft");
        clickToast("Your script has been successfully created.");

        if(isElementExistFast("//input[starts-with(@id, 'start-weight')]"))
        {
            sendKeysById("start-weight", String.valueOf(verifyDraftParams.getStartWeight()));
            sendKeysById("end-weight", String.valueOf(verifyDraftParams.getEndWeight()));
        }

        clickNvIconTextButtonByName("container.pricing-scripts.validate");
        waitUntilVisibilityOfElementLocated("//p[text()='No validation errors found.']");
        clickNvIconTextButtonByNameAndWaitUntilDone("Release Script");
    }

    public void deleteScript(Script script)
    {
        waitUntilVisibilityOfElementLocated("//p[text()='No errors found. You may proceed to verify or save the draft.']");
        selectAction(ACTION_DELETE);
        clickButtonOnMdDialogByAriaLabel("Delete");
        clickToast(script.getName()+" has been successfully deleted.");
    }

    public void verifyScriptIsDeleted(Script script)
    {
        Assert.assertTrue("Table is not empty. Script is not deleted successfully.", isTableEmpty());
    }

    public void selectAction(int actionType)
    {
        clickNvIconButtonByName("commons.actions");

        switch(actionType)
        {
            case ACTION_DELETE: click("//div[@ng-repeat='action in ctrl.manageScriptActions'][normalize-space()='Delete']"); break;
        }

        pause1s();
    }

    private void updateAceEditorValue(String script)
    {
        /**
         * editor.setValue(str, -1) // Moves cursor to the start.
         * editor.setValue(str, 1) // Moves cursor to the end.
         */
        executeScript(String.format("window.ace.edit('ace-editor').setValue('%s', 1);", script));
    }

    public void waitUntilPageLoaded(String expectedUrlEndsWith)
    {
        super.waitUntilPageLoaded();

        waitUntil(()->
        {
            String currentUrl = getCurrentUrl();
            NvLogger.infof("TimeBoundedScriptsCreateEditPage.waitUntilPageLoaded: Current URL = [%s] - Expected URL contains = [%s]", currentUrl, expectedUrlEndsWith);
            return currentUrl.endsWith(expectedUrlEndsWith);
        }, TestConstants.SELENIUM_DEFAULT_WEB_DRIVER_WAIT_TIMEOUT_IN_MILLISECONDS, String.format("Current URL does not contain '%s'.", expectedUrlEndsWith));
    }
}
