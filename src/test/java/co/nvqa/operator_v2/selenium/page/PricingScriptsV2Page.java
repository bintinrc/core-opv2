package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.pricing.Script;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.RunCheckParams;
import co.nvqa.operator_v2.model.RunCheckResult;
import co.nvqa.operator_v2.model.VerifyDraftParams;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.util.TestConstants;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
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

  public PricingScriptsV2Page(WebDriver webDriver) {
    super(webDriver);
    pricingScriptsV2CreateEditDraftPage = new PricingScriptsV2CreateEditDraftPage(webDriver);
    timeBoundedScriptsPage = new TimeBoundedScriptsPage(webDriver);
  }

  public void createDraft(Script script) {
    clickNvIconTextButtonByName("container.pricing-scripts.create-draft");
    pricingScriptsV2CreateEditDraftPage.createDraft(script);
  }

  public void checkErrorHeader() {
    pricingScriptsV2CreateEditDraftPage.checkErrorHeader();
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

  public void verifyDraftScriptIsDeleted(Script script) {
    clickTabItem(TAB_DRAFTS);
    searchTableDraftsByScriptName(script.getName());
    assertTrue("Drafts Table is not empty. The Draft Script is not deleted successfully.",
        isTableEmpty(ACTIVE_TAB_XPATH));
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

  public void searchAccordingScriptId(Script script) {
    clickTabItem(TAB_ACTIVE_SCRIPTS);
    retryIfAssertionErrorOccurred(() ->
    {
      searchTableActiveScriptsByScriptId(script.getId() + "");
      if (isTableEmpty(ACTIVE_TAB_XPATH)) {
        refreshPage();
        fail("Data still not loaded");
      }
    }, String.format("Active script found "));
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

  public RunCheckParams runCheckScriptDraftAndActive(Map<String, String> mapOfData) {
    RunCheckParams runCheckParams = new RunCheckParams();

    String orderFields = mapOfData.get("orderFields");
    String deliveryType = mapOfData.get("deliveryType");
    String orderType = mapOfData.get("orderType");
    String serviceLevel = mapOfData.get("serviceLevel");
    String serviceType = mapOfData.get("serviceType");
    String timeslotType = mapOfData.get("timeslotType");
    String isRts = mapOfData.get("isRts");
    String size = mapOfData.get("size");
    double weight = Double.parseDouble(mapOfData.get("weight"));
    double insuredValue = Double.parseDouble(mapOfData.get("insuredValue"));
    double codValue = Double.parseDouble(mapOfData.get("codValue"));
    String fromZone = mapOfData.get("fromZone");
    String toZone = mapOfData.get("toZone");
    if (Objects.nonNull("fromZone") || Objects.nonNull("toZone")) {
      runCheckParams.setFromZone(fromZone);
      runCheckParams.setToZone(toZone);
    }

    runCheckParams.setOrderFields(orderFields);
    runCheckParams.setDeliveryType(deliveryType);
    runCheckParams.setOrderType(orderType);
    runCheckParams.setServiceLevel(serviceLevel);
    runCheckParams.setServiceType(serviceType);
    runCheckParams.setTimeslotType(timeslotType);
    runCheckParams.setIsRts(isRts);
    runCheckParams.setSize(size);
    runCheckParams.setWeight(weight);
    runCheckParams.setInsuredValue(insuredValue);
    runCheckParams.setCodValue(codValue);

    if (Objects.nonNull(mapOfData.get("fromL1")) || Objects.nonNull(mapOfData.get("toL1"))
        || Objects.nonNull(mapOfData.get("fromL2")) || Objects
        .nonNull(mapOfData.get("toL2")) || Objects.nonNull(mapOfData.get("fromL3")) || Objects
        .nonNull(mapOfData.get("toL3"))) {
      String fromL1 = mapOfData.get("fromL1");
      String toL1 = mapOfData.get("toL1");
      String fromL2 = mapOfData.get("fromL2");
      String toL2 = mapOfData.get("toL2");
      String fromL3 = mapOfData.get("fromL3");
      String toL3 = mapOfData.get("toL3");
      runCheckParams.setFromL1(fromL1);
      runCheckParams.setToL1(toL1);
      runCheckParams.setFromL2(fromL2);
      runCheckParams.setToL2(toL2);
      runCheckParams.setFromL3(fromL3);
      runCheckParams.setToL3(toL3);
    }
    if (Objects.nonNull(mapOfData.get("originPricingZone")) || Objects
        .nonNull(mapOfData.get("destinationPricingZone"))) {
      String originPricingZone = mapOfData.get("originPricingZone");
      String destinationPricingZone = mapOfData.get("destinationPricingZone");
      runCheckParams.setOriginPricingZone(originPricingZone);
      runCheckParams.setDestinationPricingZone(destinationPricingZone);
    }
    return runCheckParams;
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
    searchTableActiveScriptsByScriptName(scriptName);
    wait10sUntil(() -> !isTableEmpty(ACTIVE_TAB_XPATH),
        "Active Scripts table is empty. Script not found.");
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
    clickTabItem(TAB_ACTIVE_SCRIPTS);
    searchTableActiveScriptsByScriptName(script.getName());
    assertTrue("Active Scripts Table is not empty. The Active Script is not deleted successfully.",
        isTableEmpty(ACTIVE_TAB_XPATH));
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
        waitUntilVisibilityOfElementLocated("//nv-table[@param='ctrl.draftScriptsTableParam']");
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

  public void searchTableActiveScriptsByScriptId(String scriptId) {
    sendKeys(
        "//nv-table[@param='ctrl.activeScriptsTableParam']//th[contains(@class, 'id')]/nv-search-input-filter/md-input-container/div/input",
        scriptId);
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
