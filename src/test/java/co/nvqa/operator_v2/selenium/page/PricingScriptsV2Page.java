package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.pricing.Script;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.utils.NvLogger;
import co.nvqa.operator_v2.model.RunCheckParams;
import co.nvqa.operator_v2.model.RunCheckResult;
import co.nvqa.operator_v2.model.VerifyDraftParams;
import co.nvqa.operator_v2.util.TestConstants;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class PricingScriptsV2Page extends OperatorV2SimplePage
{
    private final PricingScriptsV2CreateEditDraftPage pricingScriptsV2CreateEditDraftPage;
    private final TimeBoundedScriptsPage timeBoundedScriptsPage;

    private static final String MD_VIRTUAL_REPEAT_TABLE_DRAFTS = "script in getTableData()";
    public static final String COLUMN_CLASS_DATA_ID_ON_TABLE_DRAFTS = "id";
    public static final String COLUMN_CLASS_DATA_NAME_ON_TABLE_DRAFTS = "name";
    public static final String COLUMN_CLASS_DATA_DESCRIPTION_ON_TABLE_DRAFTS = "description";
    public static final String ACTION_BUTTON_EDIT_ON_TABLE_DRAFTS = "container.pricing-scripts.edit-script";

    private static final String MD_VIRTUAL_REPEAT_TABLE_ACTIVE_SCRIPTS = "script in getTableData()";
    public static final String COLUMN_CLASS_DATA_ID_ON_TABLE_ACTIVE_SCRIPTS = "id";
    public static final String COLUMN_CLASS_DATA_NAME_ON_TABLE_ACTIVE_SCRIPTS = "name";
    public static final String COLUMN_CLASS_DATA_DESCRIPTION_ON_TABLE_ACTIVE_SCRIPTS = "description";
    public static final String ACTION_BUTTON_EDIT_ON_TABLE_ACTIVE_SCRIPTS = "container.pricing-scripts.edit-script";
    public static final String ACTION_BUTTON_LINK_SHIPPERS_ON_TABLE_ACTIVE_SCRIPTS = "container.pricing-scripts.link-shippers";
    public static final String ACTION_BUTTON_MANAGE_TIME_BOUNDED_SCRIPTS_ON_TABLE_ACTIVE_SCRIPTS = "container.pricing-scripts.manage-time-bounded-scripts";

    private static final String TAB_DRAFTS = "Drafts";
    private static final String TAB_ACTIVE_SCRIPTS = "Active Scripts";

    public PricingScriptsV2Page(WebDriver webDriver)
    {
        super(webDriver);
        pricingScriptsV2CreateEditDraftPage = new PricingScriptsV2CreateEditDraftPage(webDriver);
        timeBoundedScriptsPage = new TimeBoundedScriptsPage(webDriver);
    }

    public void createDraft(Script script)
    {
        clickNvIconTextButtonByName("container.pricing-scripts.create-draft");
        pricingScriptsV2CreateEditDraftPage.createDraft(script);
    }

    public void verifyTheNewScriptIsCreatedOnDrafts(Script script)
    {
        clickTabItem(TAB_DRAFTS);
        searchTableDraftsByScriptName(script.getName());
        wait10sUntil(()->!isTableEmpty(), "Drafts table is empty. New script failed to created.");

        String actualId = getTextOnTableDrafts(1, COLUMN_CLASS_DATA_ID_ON_TABLE_DRAFTS);
        Assert.assertNotNull("Script ID is empty. Script is not created.", actualId);
        script.setId(Long.parseLong(actualId));

        String actualScriptName = getTextOnTableDrafts(1, COLUMN_CLASS_DATA_NAME_ON_TABLE_DRAFTS);
        String actualDescription = getTextOnTableDrafts(1, COLUMN_CLASS_DATA_DESCRIPTION_ON_TABLE_DRAFTS);

        Assert.assertEquals("Script Name", script.getName(), actualScriptName);
        Assert.assertEquals("Script Description", script.getDescription(), actualDescription);
    }

    public void deleteDraftScript(Script script)
    {
        goToEditDraftScript(script);
        pricingScriptsV2CreateEditDraftPage.deleteScript(script);
    }

    public void verifyDraftScriptIsDeleted(Script script)
    {
        clickTabItem(TAB_DRAFTS);
        searchTableDraftsByScriptName(script.getName());
        Assert.assertTrue("Drafts Table is not empty. The Draft Script is not deleted successfully.", isTableEmpty());
    }

    public void runCheckDraftScript(Script script, RunCheckParams runCheckParams)
    {
        goToEditDraftScript(script);
        pricingScriptsV2CreateEditDraftPage.runCheck(script, runCheckParams);
    }

    public void verifyTheRunCheckResultIsCorrect(RunCheckResult runCheckResult)
    {
        pricingScriptsV2CreateEditDraftPage.verifyTheRunCheckResultIsCorrect(runCheckResult);
        pricingScriptsV2CreateEditDraftPage.cancelEditDraft();
        waitUntilPageLoaded("pricing-scripts-v2/drafts");
        waitUntilInvisibilityOfElementLocated("//h5[text()='Loading more results...']");
    }

    public void validateDraftAndReleaseScript(Script script, VerifyDraftParams verifyDraftParams)
    {
        goToEditDraftScript(script);
        pricingScriptsV2CreateEditDraftPage.validateDraftAndReleaseScript(script, verifyDraftParams);
        waitUntilInvisibilityOfToast("Your script has been successfully released.");
    }

    public void goToEditDraftScript(Script script)
    {
        clickTabItem(TAB_DRAFTS);
        searchTableDraftsByScriptName(script.getName());
        wait10sUntil(()->!isTableEmpty(), "Drafts Table is empty. Cannot delete script.");
        clickActionButtonOnTableDrafts(1, ACTION_BUTTON_EDIT_ON_TABLE_DRAFTS);
    }

    public void verifyDraftScriptIsReleased(Script script)
    {
        clickTabItem(TAB_ACTIVE_SCRIPTS);
        searchTableActiveScriptsByScriptName(script.getName());
        wait10sUntil(()->!isTableEmpty(), "Active Scripts table is empty. Draft Script failed to release.");

        String actualId = getTextOnTableActiveScripts(1, COLUMN_CLASS_DATA_ID_ON_TABLE_DRAFTS);
        String actualScriptName = getTextOnTableActiveScripts(1, COLUMN_CLASS_DATA_NAME_ON_TABLE_DRAFTS);
        String actualDescription = getTextOnTableActiveScripts(1, COLUMN_CLASS_DATA_DESCRIPTION_ON_TABLE_DRAFTS);

        Assert.assertEquals("Script ID", String.valueOf(script.getId()), actualId);
        Assert.assertEquals("Script Name", script.getName(), actualScriptName);
        Assert.assertEquals("Script Description", script.getDescription(), actualDescription);
    }

    public void linkShippers(Script script, Shipper shipper)
    {
        String scriptName = script.getName();
        String shipperName = shipper.getName();

        clickTabItem(TAB_ACTIVE_SCRIPTS);
        searchTableActiveScriptsByScriptName(scriptName);
        wait10sUntil(()->!isTableEmpty(), "Active Scripts table is empty. Script not found.");
        clickActionButtonOnTableActiveScripts(1, ACTION_BUTTON_LINK_SHIPPERS_ON_TABLE_ACTIVE_SCRIPTS);
        NvLogger.info("Waiting until Link Shippers Dialog loaded.");
        waitUntilInvisibilityOfElementLocated("//md-dialog//md-dialog-content/div/md-progress-circular");
        selectValueFromNvAutocomplete("ctrl.view.textShipper", shipperName);

        List<String> listOfLinkedShippers = findElementsByXpath("//tr[@ng-repeat='shipper in $data']/td/div[1]").stream().map(we -> we.getText().trim()).collect(Collectors.toList());
        Assert.assertThat(String.format("Shipper '%s' is not added to table.", shipperName), listOfLinkedShippers, Matchers.hasItem(shipperName));
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.save-changes");
    }

    public void verifyShipperIsLinked(Script script, Shipper shipper)
    {
        String scriptName = script.getName();
        String shipperName = shipper.getName();

        clickTabItem(TAB_ACTIVE_SCRIPTS);
        searchTableActiveScriptsByScriptName(scriptName);
        wait10sUntil(()->!isTableEmpty(), "Active Scripts table is empty. Script not found.");
        clickActionButtonOnTableActiveScripts(1, ACTION_BUTTON_LINK_SHIPPERS_ON_TABLE_ACTIVE_SCRIPTS);
        NvLogger.info("Waiting until Link Shippers Dialog loaded.");
        waitUntilInvisibilityOfElementLocated("//md-dialog//md-dialog-content/div/md-progress-circular");

        List<String> listOfLinkedShippers = findElementsByXpath("//tr[@ng-repeat='shipper in $data']/td/div[1]").stream().map(we -> we.getText().trim()).collect(Collectors.toList());
        Assert.assertThat(String.format("Shipper '%s' is not added to table.", shipperName), listOfLinkedShippers, Matchers.hasItem(shipperName));
        clickButtonOnMdDialogByAriaLabel("Cancel");
    }

    public void deleteActiveScript(Script script)
    {
        goToEditActiveScript(script);
        pricingScriptsV2CreateEditDraftPage.deleteScript(script);
    }

    public void verifyActiveScriptIsDeleted(Script script)
    {
        clickTabItem(TAB_ACTIVE_SCRIPTS);
        searchTableActiveScriptsByScriptName(script.getName());
        Assert.assertTrue("Active Scripts Table is not empty. The Active Script is not deleted successfully.", isTableEmpty());
    }

    public void goToEditActiveScript(Script script)
    {
        clickTabItem(TAB_ACTIVE_SCRIPTS);
        searchTableActiveScriptsByScriptName(script.getName());
        wait10sUntil(()->!isTableEmpty(), "Active Scripts Table is empty. Cannot delete script.");
        clickActionButtonOnTableActiveScripts(1, ACTION_BUTTON_EDIT_ON_TABLE_ACTIVE_SCRIPTS);
    }

    public void goToManageTimeBoundedScript(Script script)
    {
        clickTabItem(TAB_ACTIVE_SCRIPTS);
        searchTableActiveScriptsByScriptName(script.getName());
        wait10sUntil(()->!isTableEmpty(), "Active Scripts Table is empty. Cannot create child for selected Script.");
        clickActionButtonOnTableActiveScripts(1, ACTION_BUTTON_MANAGE_TIME_BOUNDED_SCRIPTS_ON_TABLE_ACTIVE_SCRIPTS);
    }

    public void createAndReleaseNewTimeBoundedScripts(Script parentScript, Script script, VerifyDraftParams verifyDraftParams)
    {
        goToManageTimeBoundedScript(parentScript);
        timeBoundedScriptsPage.createAndReleaseTimeBoundedScript(parentScript, script, verifyDraftParams);
        waitUntilInvisibilityOfToast("Your script has been successfully released.");
    }

    public void verifyTheNewTimeBoundedScriptIsCreatedAndReleasedSuccessfully(Script parentScript, Script script)
    {
        goToManageTimeBoundedScript(parentScript);
        timeBoundedScriptsPage.verifyTimeBoundedScriptIsCreatedAndReleased(parentScript, script);
    }

    public void deleteTimeBoundedScript(Script parentScript, Script script)
    {
        goToManageTimeBoundedScript(parentScript);
        timeBoundedScriptsPage.deleteTimeBoundedScript(parentScript, script);
    }

    public void verifyTimeBoundedScriptIsDeleted(Script parentScript, Script script)
    {
        goToManageTimeBoundedScript(parentScript);
        timeBoundedScriptsPage.verifyTimeBoundedScriptIsDeleted(parentScript, script);
    }

    public void clickTabItem(String tabItemText)
    {
        super.clickTabItem(tabItemText);

        switch(tabItemText)
        {
            case TAB_DRAFTS: waitUntilPageLoaded("pricing-scripts-v2/drafts"); break;
            case TAB_ACTIVE_SCRIPTS: waitUntilPageLoaded("pricing-scripts-v2/active-scripts"); break;
        }
    }

    public void searchTableDraftsByScriptName(String scriptName)
    {
        sendKeys("//nv-table[@param='ctrl.draftScriptsTableParam']//th[contains(@class, 'name')]/nv-search-input-filter/md-input-container/div/input", scriptName);
    }

    public String getTextOnTableDrafts(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT_TABLE_DRAFTS, "ctrl.draftScriptsTableParam");
    }

    public void clickActionButtonOnTableDrafts(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT_TABLE_DRAFTS, XpathTextMode.CONTAINS, "ctrl.draftScriptsTableParam");
    }

    public void searchTableActiveScriptsByScriptName(String scriptName)
    {
        sendKeys("//nv-table[@param='ctrl.activeScriptsTableParam']//th[contains(@class, 'name')]/nv-search-input-filter/md-input-container/div/input", scriptName);
    }

    public String getTextOnTableActiveScripts(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT_TABLE_ACTIVE_SCRIPTS, "ctrl.activeScriptsTableParam");
    }

    public void clickActionButtonOnTableActiveScripts(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT_TABLE_ACTIVE_SCRIPTS, XpathTextMode.CONTAINS, "ctrl.activeScriptsTableParam");
    }

    public void waitUntilPageLoaded(String expectedUrlEndsWith)
    {
        super.waitUntilPageLoaded();

        waitUntil(()->
        {
            String currentUrl = getCurrentUrl();
            NvLogger.infof("PricingScriptsV2Page.waitUntilPageLoaded: Current URL = [%s] - Expected URL contains = [%s]", currentUrl, expectedUrlEndsWith);
            return currentUrl.endsWith(expectedUrlEndsWith);
        }, TestConstants.SELENIUM_DEFAULT_WEB_DRIVER_WAIT_TIMEOUT_IN_MILLISECONDS, String.format("Current URL does not contain '%s'.", expectedUrlEndsWith));
    }
}
