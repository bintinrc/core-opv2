package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.pricing.Script;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.RunCheckParams;
import co.nvqa.operator_v2.model.RunCheckResult;
import co.nvqa.operator_v2.model.VerifyDraftParams;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestConstants;
import java.util.List;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;
import org.hamcrest.Matchers;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class PricingScriptsV2Page extends OperatorV2SimplePage {

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
  private static final String ACTIVE_TAB_XPATH = "//tab-content[@aria-hidden='false']";
  private static final Pattern SHIPPER_SELECT_VALUE_PATTERN = Pattern.compile("(\\d+)-(.*)");

  @FindBy(xpath = "//md-virtual-repeat-container//div[@class='md-virtual-repeat-scroller']")
  public PageElement progressBar;

  @FindBy(name = "container.pricing-scripts.create-draft")
  public NvIconTextButton createDraftBtn;


  public PricingScriptsV2Page(WebDriver webDriver) {
    super(webDriver);
    pricingScriptsV2CreateEditDraftPage = new PricingScriptsV2CreateEditDraftPage(webDriver);
    timeBoundedScriptsPage = new TimeBoundedScriptsPage(webDriver);
  }

  public void createDraft(Script script) {
    clickNvIconTextButtonByName("container.pricing-scripts.create-draft");
    if (!getCurrentUrl().endsWith("pricing-scripts-v2/create?type=normal") && createDraftBtn
        .isEnabled()) {
      createDraftBtn.click();
    }
    pricingScriptsV2CreateEditDraftPage.createDraft(script);

  }

  public void checkErrorHeader(String message) {
    pricingScriptsV2CreateEditDraftPage.checkErrorHeader(message);
  }

  public void editCreatedDraft(Script script) {
    goToEditDraftScript(script);
    pricingScriptsV2CreateEditDraftPage.editScript(script);
  }

  public void editCreatedActive(Script script) {
    pricingScriptsV2CreateEditDraftPage.editScript(script);
  }

  public void verifyTheNewScriptIsCreatedOnDrafts(Script script) {
    clickTabItem(TAB_DRAFTS);
    retryIfAssertionErrorOccurred(() ->
    {
      searchTableDraftsByScriptName(script.getName());
      if (isTableEmpty(ACTIVE_TAB_XPATH)) {
        refreshPage();
        fail("Data still not loaded");
      }
    }, String.format("Draft script found "));

    String actualId = getTextOnTableDrafts(1, COLUMN_CLASS_DATA_ID_ON_TABLE_DRAFTS);
    assertNotNull("Script ID is empty. Script is not created.", actualId);
    script.setId(Long.parseLong(actualId));

    String actualScriptName = getTextOnTableDrafts(1, COLUMN_CLASS_DATA_NAME_ON_TABLE_DRAFTS);
    String actualDescription = getTextOnTableDrafts(1,
        COLUMN_CLASS_DATA_DESCRIPTION_ON_TABLE_DRAFTS);

    assertEquals("Script Name", script.getName(), actualScriptName);
    assertEquals("Script Description", script.getDescription(), actualDescription);
  }

  public void deleteDraftScript(Script script) {
    goToEditDraftScript(script);
    pricingScriptsV2CreateEditDraftPage.deleteScript(script);
  }

  public void searchActiveScriptName(String scriptName) {
    retryIfAssertionErrorOccurred(() ->
    {
      searchTableActiveScriptsByScriptName(scriptName);
      if (isTableEmpty(ACTIVE_TAB_XPATH)) {
        refreshPage();
        fail("Data still not loaded");
      }
    }, String.format("Active script found "));
    clickActionButtonOnTableActiveScripts(1, ACTION_BUTTON_EDIT_ON_TABLE_DRAFTS);
  }

  public void verifyDraftScriptIsDeleted(Script script) {
    waitUntilInvisibilityOfToast(script.getName() + " has been successfully deleted.", true);
    clickTabItem(TAB_DRAFTS);
    retryIfAssertionErrorOccurred(() ->
    {
      searchTableDraftsByScriptName(script.getName());
      if (!isTableEmpty(ACTIVE_TAB_XPATH)) {
        refreshPage();
        fail("Draft script found");
      }
    }, String.format("Data still not loaded"));
    assertTrue("No Results Found", isTableEmpty(ACTIVE_TAB_XPATH));
  }

  public void runCheckDraftScript(Script script, RunCheckParams runCheckParams) {
    goToEditDraftScript(script);
    pricingScriptsV2CreateEditDraftPage.runCheck(script, runCheckParams);
  }

  public void runCheckActiveScript(Script script, RunCheckParams runCheckParams) {
    pricingScriptsV2CreateEditDraftPage.runCheck(script, runCheckParams);
  }

  public void verifyErrorMessage(String message, String response) {
    pricingScriptsV2CreateEditDraftPage.verifyErrorMessage(message, response);
  }

  public void verifyTheRunCheckResultIsCorrect(RunCheckResult runCheckResult) {
    pricingScriptsV2CreateEditDraftPage.verifyTheRunCheckResultIsCorrect(runCheckResult);
  }

  public void closeScreen() {
    pricingScriptsV2CreateEditDraftPage.cancelEditDraft();
  }

  public void validateDraftAndReleaseScript(Script script, VerifyDraftParams verifyDraftParams) {
    goToEditDraftScript(script);
    pricingScriptsV2CreateEditDraftPage.validateDraftAndReleaseScript(script, verifyDraftParams);
    waitUntilInvisibilityOfToast("Your script has been successfully released.");
  }

  public void validateDraftAndReleaseScript(Script script) {
    goToEditDraftScript(script);
    pricingScriptsV2CreateEditDraftPage.validateDraftAndReleaseScript(script);
    waitUntilInvisibilityOfToast("Your script has been successfully released.");
  }

  public void goToEditDraftScript(Script script) {
    clickTabItem(TAB_DRAFTS);
    searchTableDraftsByScriptName(script.getName());
    wait10sUntil(() -> !isTableEmpty(ACTIVE_TAB_XPATH),
        "Drafts Table is empty. Cannot delete script.");
    clickActionButtonOnTableDrafts(1, ACTION_BUTTON_EDIT_ON_TABLE_DRAFTS);
  }

  public void verifyDraftScriptIsReleased(Script script) {
    clickTabItem(TAB_ACTIVE_SCRIPTS);

    retryIfAssertionErrorOccurred(() ->
    {
      searchTableActiveScriptsByScriptName(script.getName());
      if (isTableEmpty(ACTIVE_TAB_XPATH)) {
        refreshPage();
        fail("Data still not loaded");
      }
    }, String.format("Active script found "));
  }

  public void verifyDraftScriptIsReleased(Script script, String searchWay) {
    clickTabItem(TAB_ACTIVE_SCRIPTS);

    retryIfAssertionErrorOccurred(() ->
    {
      switch (searchWay) {
        case "name":
          searchTableActiveScripts(searchWay, script.getName());
          break;
        case "description":
          searchTableActiveScripts(searchWay, script.getDescription());
          searchTableActiveScripts("id", (script.getId() + ""));
          break;
        case "last-modified":
          searchTableActiveScripts(searchWay, script.getUpdatedAt());
          searchTableActiveScripts("id", (script.getId() + ""));
          break;
        case "id":
          searchTableActiveScripts(searchWay, (script.getId() + ""));
          break;
      }
      if (isTableEmpty(ACTIVE_TAB_XPATH)) {
        refreshPage();
        fail("Data still not loaded");
      }
    }, String.format("Active script found "));
  }

  public void searchAccordingScriptId(Script script) {
    clickTabItem(TAB_ACTIVE_SCRIPTS);
    retryIfAssertionErrorOccurred(() ->
    {
      searchTableActiveScripts("id", (script.getId() + ""));
      if (isTableEmpty(ACTIVE_TAB_XPATH)) {
        refreshPage();
        fail("Data still not loaded");
      }
    }, String.format("Active script found "), 100, 10);
    wait10sUntil(() -> !isTableEmpty(ACTIVE_TAB_XPATH),
        "Drafts Table is empty. Cannot find script.");
    clickActionButtonOnTableActiveScripts(1, ACTION_BUTTON_EDIT_ON_TABLE_DRAFTS);
  }

  public void verifyDraftScriptDataIsCorrect(Script script) {
    String actualId = getTextOnTableActiveScripts(1, COLUMN_CLASS_DATA_ID_ON_TABLE_DRAFTS);
    script.setId(Long.parseLong(actualId));
    String actualScriptName = getTextOnTableActiveScripts(1,
        COLUMN_CLASS_DATA_NAME_ON_TABLE_DRAFTS);
    String actualDescription = getTextOnTableActiveScripts(1,
        COLUMN_CLASS_DATA_DESCRIPTION_ON_TABLE_DRAFTS);

    assertEquals("Script ID", String.valueOf(script.getId()), actualId);
    assertEquals("Script Name", script.getName(), actualScriptName);
    assertEquals("Script Description", script.getDescription(), actualDescription);
  }

  public void linkShippers(Script script, Shipper shipper) {
    String scriptName = script.getName();
    String legacyId = shipper.getLegacyId().toString();

    clickTabItem(TAB_ACTIVE_SCRIPTS);
    searchTableActiveScriptsByScriptName(scriptName);
    wait10sUntil(() -> !isTableEmpty(ACTIVE_TAB_XPATH),
        "Active Scripts table is empty. Script not found.");
    clickActionButtonOnTableActiveScripts(1, ACTION_BUTTON_LINK_SHIPPERS_ON_TABLE_ACTIVE_SCRIPTS);
    NvLogger.info("Waiting until Link Shippers Dialog loaded.");
    waitUntilInvisibilityOfElementLocated(
        "//md-dialog//md-dialog-content/div/md-progress-circular");
    selectValueFromNvAutocomplete("ctrl.view.textShipper", legacyId);
    clickNvApiTextButtonByNameAndWaitUntilDone("commons.save-changes");
  }

  public void linkShippersWithIdAndName(Script script, Shipper shipper) {
    String scriptName = script.getName();
    String legacyId = shipper.getLegacyId().toString();
    String name = shipper.getName();

    clickTabItem(TAB_ACTIVE_SCRIPTS);
    retryIfAssertionErrorOccurred(() ->
    {
      refreshPage();
      searchTableActiveScriptsByScriptName(scriptName);
      if (isTableEmpty(ACTIVE_TAB_XPATH)) {
        fail("Data still not loaded");
      }
      Assertions.assertThat(
          getTextOnTableActiveScripts(1, COLUMN_CLASS_DATA_NAME_ON_TABLE_ACTIVE_SCRIPTS))
          .isEqualTo(scriptName);
    }, String.format("Active script found "), 10, 5);

    clickActionButtonOnTableActiveScripts(1, ACTION_BUTTON_LINK_SHIPPERS_ON_TABLE_ACTIVE_SCRIPTS);
    NvLogger.info("Waiting until Link Shippers Dialog loaded.");
    waitUntilInvisibilityOfElementLocated(
        "//md-dialog//md-dialog-content/div/md-progress-circular");
    String searchValue = Objects.isNull(name) ? legacyId : legacyId.concat("-").concat(name);

    sendKeys(".//nv-autocomplete[@search-text='ctrl.view.textShipper']//input", searchValue);
    progressBar.waitUntilVisible();
    String menuXpath = "//md-virtual-repeat-container//ul[@class='md-autocomplete-suggestions light']";
    String itemXpath = f("//li//span[starts-with(text(),'%s')]", legacyId);

    int count = 0;
    while (!isElementVisible(itemXpath, 1) && count < 5) {
      String lastItemXpath = menuXpath + "//li[last()]";
      scrollIntoView(lastItemXpath, true);
      count++;
    }
    scrollIntoView(itemXpath, true);
    waitUntilElementIsClickable(itemXpath);
    click(itemXpath);

    clickNvApiTextButtonByNameAndWaitUntilDone("commons.save-changes");
  }

  private List<String> getLinkedShipperNames() {
    return findElementsByXpath("//tr[@ng-repeat='shipper in $data']/td/div[1]").stream()
        .map(we ->
        {
          String text = we.getText().trim();
          Matcher m = SHIPPER_SELECT_VALUE_PATTERN.matcher(text);
          if (m.matches()) {
            return m.group(2).trim();
          } else {
            return "";
          }
        })
        .collect(Collectors.toList());
  }


  private List<String> getLinkedShipperIds() {
    return findElementsByXpath("//tr[@ng-repeat='shipper in $data']/td/div[1]").stream()
        .map(we ->
        {
          String text = we.getText().trim();
          Matcher m = SHIPPER_SELECT_VALUE_PATTERN.matcher(text);
          if (m.matches()) {
            return m.group(1).trim();
          } else {
            return "";
          }
        })
        .collect(Collectors.toList());
  }

  public void verifyShipperIsLinked(Script script, Shipper shipper) {
    String scriptName = script.getName();
    String legacyId = shipper.getLegacyId().toString();

    clickTabItem(TAB_ACTIVE_SCRIPTS);
    searchTableActiveScriptsByScriptName(scriptName);
    wait10sUntil(() -> !isTableEmpty(ACTIVE_TAB_XPATH),
        "Active Scripts table is empty. Script not found.");
    clickActionButtonOnTableActiveScripts(1, ACTION_BUTTON_LINK_SHIPPERS_ON_TABLE_ACTIVE_SCRIPTS);
    NvLogger.info("Waiting until Link Shippers Dialog loaded.");
    waitUntilInvisibilityOfElementLocated(
        "//md-dialog//md-dialog-content/div/md-progress-circular");

    List<String> listOfLinkedShippers = getLinkedShipperIds();
    assertThat(String.format("Shipper '%s' is not added to table.", legacyId), listOfLinkedShippers,
        Matchers.hasItem(legacyId));
    clickButtonOnMdDialogByAriaLabel("Save changes");
  }

  public void deleteActiveScript(Script script) {
    goToEditActiveScript(script);
    pricingScriptsV2CreateEditDraftPage.deleteScript(script);
  }

  public void verifyActiveScriptIsDeleted(Script script) {
    waitUntilInvisibilityOfToast(script.getName() + " has been successfully deleted.", true);
    clickTabItem(TAB_ACTIVE_SCRIPTS);
    retryIfAssertionErrorOccurred(() ->
    {
      searchTableActiveScriptsByScriptName(script.getName());
      if (!isTableEmpty(ACTIVE_TAB_XPATH)) {
        refreshPage();
        fail("Draft script found");
      }
    }, String.format("Data still not loaded"));
    assertTrue("No Results Found", isTableEmpty(ACTIVE_TAB_XPATH));
  }

  public void goToEditActiveScript(Script script) {
    clickTabItem(TAB_ACTIVE_SCRIPTS);
    searchTableActiveScriptsByScriptName(script.getName());
    wait10sUntil(() -> !isTableEmpty(ACTIVE_TAB_XPATH),
        "Active Scripts Table is empty. Cannot delete script.");
    clickActionButtonOnTableActiveScripts(1, ACTION_BUTTON_EDIT_ON_TABLE_ACTIVE_SCRIPTS);
  }

  public void goToManageTimeBoundedScript(Script script) {
    clickTabItem(TAB_ACTIVE_SCRIPTS);
    searchTableActiveScriptsByScriptName(script.getName());
    wait10sUntil(() -> !isTableEmpty(ACTIVE_TAB_XPATH),
        "Active Scripts Table is empty. Cannot create child for selected Script.");
    clickActionButtonOnTableActiveScripts(1,
        ACTION_BUTTON_MANAGE_TIME_BOUNDED_SCRIPTS_ON_TABLE_ACTIVE_SCRIPTS);
  }

  public void createAndReleaseNewTimeBoundedScripts(Script parentScript, Script script,
      VerifyDraftParams verifyDraftParams) {
    goToManageTimeBoundedScript(parentScript);
    timeBoundedScriptsPage
        .createAndReleaseTimeBoundedScript(parentScript, script, verifyDraftParams);
    waitUntilInvisibilityOfToast("Your script has been successfully released.");
  }

  public void verifyTheNewTimeBoundedScriptIsCreatedAndReleasedSuccessfully(Script parentScript,
      Script script) {
    goToManageTimeBoundedScript(parentScript);
    timeBoundedScriptsPage.verifyTimeBoundedScriptIsCreatedAndReleased(parentScript, script);
  }

  public void deleteTimeBoundedScript(Script parentScript, Script script) {
    goToManageTimeBoundedScript(parentScript);
    timeBoundedScriptsPage.deleteTimeBoundedScript(parentScript, script);
  }

  public void verifyTimeBoundedScriptIsDeleted(Script parentScript, Script script) {
    goToManageTimeBoundedScript(parentScript);
    timeBoundedScriptsPage.verifyTimeBoundedScriptIsDeleted(parentScript, script);
  }

  public void clickTabItem(String tabItemText) {
    super.clickTabItem(tabItemText);

    switch (tabItemText) {
      case TAB_DRAFTS:
        waitUntilPageLoaded("pricing-scripts-v2/drafts");
        waitUntilVisibilityOfElementLocated("//nv-table[@param='ctrl.draftScriptsTableParam']",
            120);
        break;
      case TAB_ACTIVE_SCRIPTS:
        waitUntilPageLoaded("pricing-scripts-v2/active-scripts");
        waitUntilVisibilityOfElementLocated("//nv-table[@param='ctrl.activeScriptsTableParam']");
        break;
    }
  }

  public void searchTableDraftsByScriptName(String scriptName) {
    sendKeys(
        "//nv-table[@param='ctrl.draftScriptsTableParam']//th[contains(@class, 'name')]/nv-search-input-filter/md-input-container/div/input",
        scriptName);
  }

  public String getTextOnTableDrafts(int rowNumber, String columnDataClass) {
    return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass,
        MD_VIRTUAL_REPEAT_TABLE_DRAFTS, "ctrl.draftScriptsTableParam");
  }

  public void clickActionButtonOnTableDrafts(int rowNumber, String actionButtonName) {
    clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName,
        MD_VIRTUAL_REPEAT_TABLE_DRAFTS, XpathTextMode.CONTAINS, "ctrl.draftScriptsTableParam");
  }

  public void searchTableActiveScriptsByScriptName(String scriptName) {
    sendKeys(
        "//nv-table[@param='ctrl.activeScriptsTableParam']//th[contains(@class, 'name')]/nv-search-input-filter/md-input-container/div/input",
        scriptName);
  }

  public void searchTableActiveScripts(String searchBy, String scriptName) {
    sendKeys(f(
        "//nv-table[@param='ctrl.activeScriptsTableParam']//th[contains(@class, '%s')]/nv-search-input-filter/md-input-container/div/input",
        searchBy),
        scriptName);
  }

  public String getTextOnTableActiveScripts(int rowNumber, String columnDataClass) {
    return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass,
        MD_VIRTUAL_REPEAT_TABLE_ACTIVE_SCRIPTS, "ctrl.activeScriptsTableParam");
  }

  public void clickActionButtonOnTableActiveScripts(int rowNumber, String actionButtonName) {
    clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName,
        MD_VIRTUAL_REPEAT_TABLE_ACTIVE_SCRIPTS, XpathTextMode.CONTAINS,
        "ctrl.activeScriptsTableParam");
  }

  public void waitUntilPageLoaded(String expectedUrlEndsWith) {
    super.waitUntilPageLoaded();

    waitUntil(() ->
        {
          String currentUrl = getCurrentUrl();
          NvLogger.infof(
              "PricingScriptsV2Page.waitUntilPageLoaded: Current URL = [%s] - Expected URL contains = [%s]",
              currentUrl, expectedUrlEndsWith);
          return currentUrl.endsWith(expectedUrlEndsWith);
        }, TestConstants.SELENIUM_WEB_DRIVER_WAIT_TIMEOUT_IN_MILLISECONDS,
        String.format("Current URL does not contain '%s'.", expectedUrlEndsWith));
  }
}
