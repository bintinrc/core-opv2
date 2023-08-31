package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.pricing.Script;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.RunCheckParams;
import co.nvqa.operator_v2.model.RunCheckResult;
import co.nvqa.operator_v2.model.VerifyDraftParams;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestConstants;
import java.util.List;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class PricingScriptsV2Page extends SimpleReactPage {

  private final PricingScriptsV2CreateEditDraftPage pricingScriptsV2CreateEditDraftPage;
  private final TimeBoundedScriptsPage timeBoundedScriptsPage;

  private static final String MD_VIRTUAL_REPEAT_TABLE_DRAFTS = "script in getTableData()";
  public static final String COLUMN_CLASS_DATA_ID_ON_TABLE = "1";
  public static final String COLUMN_CLASS_DATA_NAME_ON_TABLE = "2";
  public static final String COLUMN_CLASS_DATA_DESCRIPTION_ON_TABLE = "3";
  public static final String COLUMN_CLASS_DATA_LAST_MODIFIED_ON_TABLE = "4";
  public static final String COLUMN_CLASS_DATA_LAST_MODIFIED_BY_ON_TABLE = "5";
  public static final String ACTION_BUTTON_EDIT_ON_TABLE = "scriptTable.editBtn.";

  private static final String MD_VIRTUAL_REPEAT_TABLE_ACTIVE_SCRIPTS = "script in getTableData()";
  public static final String ACTION_BUTTON_LINK_SHIPPERS_ON_TABLE_ACTIVE_SCRIPTS = "linkShippers.linkBtn";
  public static final String ACTION_BUTTON_MANAGE_TIME_BOUNDED_SCRIPTS_ON_TABLE_ACTIVE_SCRIPTS = "scriptTable.manage-time-bounded-scripts";

  private static final String TAB_DRAFTS = "Drafts";
  private static final String TAB_ACTIVE_SCRIPTS = "Active Scripts";
  private static final String ACTIVE_TAB_XPATH = "//div[@data-testid='virtualTable.noData']";
  private static final Pattern SHIPPER_SELECT_VALUE_PATTERN = Pattern.compile("(\\d+)-(.*)");

  @FindBy(xpath = "//button[@data-testid='scriptTable.createDraft']")
  public NvIconTextButton createDraftBtn;

  @FindBy(xpath = "//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div")
  public PageElement toastErrorTopText;

  @FindBy(xpath = "//div[@id='toast-container']/div/div/div/div[@class='toast-bottom']")
  public PageElement toastErrorBottomText;

  @FindBy(name = "commons.undo")
  public NvApiTextButton undoBtn;

  @FindBy(xpath = "//button[@data-testid='linkShippers.saveBtn']/..")
  public NvApiTextButton saveBtn;

  public PricingScriptsV2Page(WebDriver webDriver) {
    super(webDriver);
    pricingScriptsV2CreateEditDraftPage = new PricingScriptsV2CreateEditDraftPage(webDriver);
    timeBoundedScriptsPage = new TimeBoundedScriptsPage(webDriver);
  }

  public void createDraftAndSave(Script script) {
    pause2s();
    clickCreateDraftBtn();
    pricingScriptsV2CreateEditDraftPage.createDraftAndSave(script);
  }

  public void createDraft(Script script) {
    clickCreateDraftBtn();
    pricingScriptsV2CreateEditDraftPage.createDraft(script);
  }

  private void clickCreateDraftBtn() {
    clickButtonByText("Create Draft");
  }

  public void checkErrorHeader(String message) {
    pricingScriptsV2CreateEditDraftPage.checkSyntaxHeader(message);
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
    retryIfAssertionErrorOccurred(() -> {
      System.out.println("NADEERA:" + script.getName());
      searchTableDraftsByScriptName(script.getName());
      waitUntilInvisibilityOfElementLocated("//h5[text()='Loading more results...']");
      if (isTableEmpty(ACTIVE_TAB_XPATH)) {
        fail("Data still not loaded");
      }
    }, String.format("Draft script found "));

    String actualId = getTextOnTableDrafts(1, COLUMN_CLASS_DATA_ID_ON_TABLE);
    script.setId(Long.parseLong(actualId));
  }

  public void deleteDraftScript(Script script) {
    goToEditDraftScript(script);
    pricingScriptsV2CreateEditDraftPage.deleteScript(script);
  }

  public void searchActiveScriptName(String scriptName) {
    retryIfAssertionErrorOccurred(() -> {
      searchTableActiveScriptsByScriptName(scriptName);
      if (isTableEmpty(ACTIVE_TAB_XPATH)) {
        searchTableActiveScriptsByScriptName(scriptName);
        if (isTableEmpty(ACTIVE_TAB_XPATH)) {
          fail("Data still not loaded");
        }
      }
    }, String.format("Active script found "));
    clickActionButtonOnTable(1, ACTION_BUTTON_EDIT_ON_TABLE);
  }

  public void verifyDraftScriptIsDeleted(Script script) {
    waitUntilInvisibilityOfToast(script.getName() + " has been successfully deleted.", true);
    clickTabItem(TAB_DRAFTS);
    retryIfAssertionErrorOccurred(() -> {
      searchTableDraftsByScriptName(script.getName());
      if (!isTableEmpty(ACTIVE_TAB_XPATH)) {
        refreshPage();
        searchTableDraftsByScriptName(script.getName());
        if (!isTableEmpty(ACTIVE_TAB_XPATH)) {
          fail("Data still not loaded");
        }
      }
    }, String.format("Data still not loaded"));
    Assertions.assertThat(isTableEmpty(ACTIVE_TAB_XPATH)).as("No Results Found").isTrue();
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
    acceptAlertDialogIfAppear();
  }

  public void validateDraftAndReleaseScript(Script script) {
    goToEditDraftScript(script);
    pricingScriptsV2CreateEditDraftPage.validateDraftAndReleaseScript(script);
    waitUntilInvisibilityOfToast("Your script has been successfully released.");
    acceptAlertDialogIfAppear();
  }

  public String validateDraftAndReturnWarnings(String tabName, Script script) {
    if (!tabName.contains("active script")) {
      goToEditDraftScript(script);
    }
    return pricingScriptsV2CreateEditDraftPage.validateDraftAndReturnWarnings(script);
  }

  public void releaseScript() {
    pricingScriptsV2CreateEditDraftPage.clickButtonByTextAndWaitUntilDone(
        "Release Script");
    waitUntilInvisibilityOfToast("Your script has been successfully released.");
    acceptAlertDialogIfAppear();
  }

  public void goToEditDraftScript(Script script) {
    clickTabItem(TAB_DRAFTS);
    searchTableDraftsByScriptName(script.getName());
    wait10sUntil(() -> !isTableEmpty(ACTIVE_TAB_XPATH),
        "Drafts Table is empty. Cannot delete script.");
    clickActionButtonOnTable(1, ACTION_BUTTON_EDIT_ON_TABLE);
  }

  @Deprecated
  public void verifyDraftScriptIsReleased(Script script) {
    waitUntilPageLoaded("pricing-scripts-v2/active-scripts");
    clickTabItem(TAB_ACTIVE_SCRIPTS);

    retryIfAssertionErrorOccurred(() ->
    {
      searchTableActiveScriptsByScriptName(script.getName());
      if (isTableEmpty(ACTIVE_TAB_XPATH)) {
        fail("Data still not loaded");
      }
    }, String.format("Active script found "));
  }

  public void verifyDraftScriptIsReleased(Script script, String searchWay) {
    clickTabItem(TAB_ACTIVE_SCRIPTS);

    retryIfAssertionErrorOccurred(() -> {
      switch (searchWay) {
        case "name":
          searchTableActiveScripts(searchWay, script.getName());
          break;
        case "description":
          searchTableActiveScripts(searchWay, script.getDescription());
          searchTableActiveScripts("id", (script.getId() + ""));
          break;
        case "last-modified":
          searchTableActiveScripts("updated_at_formatted", script.getUpdatedAt());
          searchTableActiveScripts("id", (script.getId() + ""));
          break;
        case "id":
          searchTableActiveScripts(searchWay, (script.getId() + ""));
          break;
        case "last_modified_by":
          searchTableActiveScripts(searchWay, script.getLastModifiedUser());
          searchTableActiveScripts("id", (script.getId() + ""));
          break;
      }
      if (isTableEmpty(ACTIVE_TAB_XPATH)) {
        refreshPage();
        fail("Data still not loaded");
      }
    }, String.format("Active script found "));
  }

  public void searchInDraftScript(Script script, String searchWay) {
    clickTabItem(TAB_DRAFTS);
    retryIfAssertionErrorOccurred(() -> {
      switch (searchWay) {
        case "name":
          searchTableDraftScripts(searchWay, script.getName());
          break;
        case "description":
          searchTableDraftScripts(searchWay, script.getDescription());
          searchTableDraftScripts("id", (script.getId() + ""));
          break;
        case "last-modified":
          searchTableDraftScripts("updated_at_formatted", script.getUpdatedAt());
          searchTableDraftScripts("id", (script.getId() + ""));
          break;
        case "id":
          searchTableDraftScripts(searchWay, (script.getId() + ""));
          break;
        case "last-modified-by":
          searchTableDraftScripts(searchWay, script.getLastModifiedUser());
          searchTableDraftScripts("id", (script.getId() + ""));
          break;
      }
      if (isTableEmpty(ACTIVE_TAB_XPATH)) {
        refreshPage();
        fail("Data still not loaded");
      }
    }, String.format("Draft script found "), 100, 10);
  }

  public void searchAccordingScriptId(Script script) {
    clickTabItem(TAB_ACTIVE_SCRIPTS);
    retryIfAssertionErrorOccurred(() -> {
      searchTableActiveScripts("id", (script.getId() + ""));
      if (isTableEmpty(ACTIVE_TAB_XPATH)) {
        refreshPage();
        fail("Data still not loaded");
      }
    }, String.format("Active script found "), 100, 10);
    wait10sUntil(() -> !isTableEmpty(ACTIVE_TAB_XPATH),
        "Drafts Table is empty. Cannot find script.");
    clickActionButtonOnTable(1, ACTION_BUTTON_EDIT_ON_TABLE);
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
    saveBtn.clickAndWaitUntilDone();
  }

  public void linkShippersWithIdAndName(Script script, Shipper shipper) {
    searchAndSelectShipper(script, shipper);
    saveBtn.clickAndWaitUntilDone();
    waitUntilInvisibilityOfToast();
  }

  public void searchAndSelectShipper(Script script, Shipper shipper) {
    String scriptName = script.getName();
    String legacyId = shipper.getLegacyId().toString();
    String name = shipper.getName();
    clickTabItem(TAB_ACTIVE_SCRIPTS);
    searchTableActiveScriptsByScriptName(scriptName);
    if (isTableEmpty(ACTIVE_TAB_XPATH)) {
      fail("Data still not loaded");
    }
    Assertions.assertThat(getTextOnTableActiveScripts(1, COLUMN_CLASS_DATA_NAME_ON_TABLE))
        .isEqualTo(scriptName);

    clickActionButtonOnTable(1, ACTION_BUTTON_LINK_SHIPPERS_ON_TABLE_ACTIVE_SCRIPTS);
    NvLogger.info("Waiting until Link Shippers Dialog loaded.");
    waitUntilVisibilityOfElementLocated("//div[text()='Link Shippers']");
    String searchValue = Objects.isNull(name) ? legacyId : legacyId.concat(" - ").concat(name);

    click("//div[@name='shippers']//input");
    sendKeys("//div[@name='shippers']//input", legacyId);
    click("//*[text()='" + searchValue + "']");
    sendKeys("//div[@name='shippers']//input", Keys.TAB);
  }

  public void clickUndoBtn(String shipperId) {
    clickf("//span[contains(@title,'%s')]/span[contains(@class,'remove')]", shipperId);
//    undoBtn.click();
  }

  private List<String> getLinkedShipperNames() {
    return findElementsByXpath("//tr[@ng-repeat='shipper in $data']/td/div[1]").stream().map(we -> {
      String text = we.getText().trim();
      Matcher m = SHIPPER_SELECT_VALUE_PATTERN.matcher(text);
      if (m.matches()) {
        return m.group(2).trim();
      } else {
        return "";
      }
    }).collect(Collectors.toList());
  }


  private List<String> getLinkedShipperIds() {
    return findElementsByXpath("//tr[@ng-repeat='shipper in $data']/td/div[1]").stream().map(we -> {
      String text = we.getText().trim();
      Matcher m = SHIPPER_SELECT_VALUE_PATTERN.matcher(text);
      if (m.matches()) {
        return m.group(1).trim();
      } else {
        return "";
      }
    }).collect(Collectors.toList());
  }

  public void deleteActiveScript(Script script) {
    goToEditActiveScript(script);
    pricingScriptsV2CreateEditDraftPage.deleteScript(script);
  }

  public void verifyActiveScriptIsDeleted(Script script) {
    waitUntilInvisibilityOfToast(script.getName() + " has been successfully deleted.", true);
    clickTabItem(TAB_ACTIVE_SCRIPTS);
    retryIfAssertionErrorOccurred(() -> {
      searchTableActiveScriptsByScriptName(script.getName());
      if (!isTableEmpty(ACTIVE_TAB_XPATH)) {
        searchTableActiveScriptsByScriptName(script.getName());
        if (!isTableEmpty(ACTIVE_TAB_XPATH)) {
          fail("Data still not loaded");
        }
      }
    }, String.format("Data still not loaded"));
    Assertions.assertThat(isTableEmpty(ACTIVE_TAB_XPATH)).as("No Results Found").isTrue();
  }

  public void goToEditActiveScript(Script script) {
    clickTabItem(TAB_ACTIVE_SCRIPTS);
    searchTableActiveScriptsByScriptName(script.getName());
    wait10sUntil(() -> !isTableEmpty(ACTIVE_TAB_XPATH),
        "Active Scripts Table is empty. Cannot delete script.");
    clickActionButtonOnTable(1, ACTION_BUTTON_EDIT_ON_TABLE);
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
    timeBoundedScriptsPage.createAndReleaseTimeBoundedScript(parentScript, script,
        verifyDraftParams);
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
        waitUntilVisibilityOfElementLocated(
            "//div[@role='tabpanel' and @aria-hidden='false' and contains(@id,'drafts')]", 120);
        break;
      case TAB_ACTIVE_SCRIPTS:
        waitUntilPageLoaded("pricing-scripts-v2/active-scripts");
        waitUntilVisibilityOfElementLocated(
            "//div[@role='tabpanel' and @aria-hidden='false' and contains(@id,'active-scripts')]");
        break;
    }
  }

  public void searchTableDraftsByScriptName(String scriptName) {
    String xpathExpression = "//div[@role='tabpanel' and @aria-hidden='false' and contains(@id,'drafts')]//input[@data-testid='searchInput.name']";
    waitUntilVisibilityOfElementLocated(xpathExpression);
    click(xpathExpression);
    if (!getAttribute(xpathExpression, "value").equals(scriptName)) {
      sendKeys(xpathExpression, Keys.CONTROL + "a" + Keys.DELETE);
      sendKeys(xpathExpression, scriptName);
    }
  }

  public String getTextOnTableDrafts(int rowNumber, String columnDataClass) {
    return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass,
        MD_VIRTUAL_REPEAT_TABLE_DRAFTS, "drafts");
  }

  public void clickActionButtonOnTableDrafts(int rowNumber, String actionButtonName) {
    clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName,
        MD_VIRTUAL_REPEAT_TABLE_DRAFTS, XpathTextMode.CONTAINS, "ctrl.draftScriptsTableParam");
  }

  public void searchTableActiveScriptsByScriptName(String scriptName) {
    String xpathExpression = "//div[@aria-hidden='false' and contains(@id,'active-scripts')]//input[@data-testid='searchInput.name']";
    waitUntilVisibilityOfElementLocated(xpathExpression);
    click(xpathExpression);
    if (!getAttribute(xpathExpression, "value").equals(scriptName)) {
      sendKeys(xpathExpression, Keys.CONTROL + "a" + Keys.DELETE);
      sendKeys(xpathExpression, scriptName);
    }
  }

  public void searchTableActiveScripts(String searchBy, String scriptName) {
    String xpathExpression = f(
        "//div[@role='tabpanel' and @aria-hidden='false' and contains(@id,'active-scripts')]//input[@data-testid='searchInput.%s']",
        searchBy);
    waitUntilVisibilityOfElementLocated(xpathExpression);
    click(xpathExpression);
    sendKeys(xpathExpression, scriptName);
  }

  public void searchTableDraftScripts(String searchBy, String scriptName) {
    String xpathExpression = f(
        "//div[@role='tabpanel' and @aria-hidden='false' and contains(@id,'drafts')]//input[@data-testid='searchInput.%s']",
        searchBy);
    waitUntilVisibilityOfElementLocated(xpathExpression);
    click(xpathExpression);
    if (!getAttribute(xpathExpression, "value").equals(scriptName)) {
      sendKeys(xpathExpression, Keys.CONTROL + "a" + Keys.DELETE);
      sendKeys(xpathExpression, scriptName);
    }
  }

  public String getTextOnTableActiveScripts(int rowNumber, String columnDataClass) {
    String returnValue = getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass,
        MD_VIRTUAL_REPEAT_TABLE_ACTIVE_SCRIPTS, "active-scripts");
    return returnValue;

  }

  public void clickActionButtonOnTableActiveScripts(int rowNumber, String actionButtonName) {
    clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName,
        MD_VIRTUAL_REPEAT_TABLE_ACTIVE_SCRIPTS, XpathTextMode.CONTAINS, "active-scripts");
  }

  public void waitUntilPageLoaded(String expectedUrlEndsWith) {
    super.waitUntilPageLoaded();

    waitUntil(() -> {
          String currentUrl = getCurrentUrl();
          NvLogger.infof(
              "PricingScriptsV2Page.waitUntilPageLoaded: Current URL = [%s] - Expected URL contains = [%s]",
              currentUrl, expectedUrlEndsWith);
          return currentUrl.endsWith(expectedUrlEndsWith);
        }, TestConstants.SELENIUM_WEB_DRIVER_WAIT_TIMEOUT_IN_MILLISECONDS,
        String.format("Current URL does not contain '%s'.", expectedUrlEndsWith));
  }

  public void switchToIframe() {
    switchToFrame("//iframe[@ng-style='iframeStyleObj']");
  }

  public void goToWriteScriptPage() {
    pause2s();
    clickCreateDraftBtn();
    clickTabItem("Write Script");
  }

  public void verifyPresence(String field, String value) {
    if (value == null) {
      Assertions.assertThat(
              findElementByXpath(f("//span[@data-testid='scriptParameters.%s']", field)).isDisplayed())
          .as(f("Parameter %s present", field))
          .isTrue();
    } else {
      Assertions.assertThat(
              findElementByXpath(
                  f("//span[@data-testid='scriptParameter.%s.%s']", field, value)).isDisplayed())
          .as(f("Parameter %s present under %s", value, field))
          .isTrue();
    }
  }
}
