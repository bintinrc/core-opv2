package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.pricing.Script;
import co.nvqa.operator_v2.model.VerifyDraftParams;
import co.nvqa.operator_v2.util.TestConstants;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
@Deprecated
public class TimeBoundedScriptsPage extends OperatorV2SimplePage {

  private static final Logger LOGGER = LoggerFactory.getLogger(TimeBoundedScriptsPage.class);

  private static final String MD_VIRTUAL_REPEAT_TABLE = "script in getTableData()";
  public static final String COLUMN_CLASS_DATA_NAME_ON_TABLE = "name";
  public static final String COLUMN_CLASS_DATA_STATUS_ON_TABLE = "status";
  public static final String COLUMN_CLASS_DATA_DURATION_ON_TABLE = "duration";

  private final TimeBoundedScriptsCreateEditPage timeBoundedScriptsCreateEditPage;

  public TimeBoundedScriptsPage(WebDriver webDriver) {
    super(webDriver);
    timeBoundedScriptsCreateEditPage = new TimeBoundedScriptsCreateEditPage(getWebDriver());
  }

  public void createAndReleaseTimeBoundedScript(Script parentScript, Script script,
      VerifyDraftParams verifyDraftParams) {
    waitUntilPageLoaded(String.format("pricing-scripts-v2/%s/time-bounded", parentScript.getId()));
    clickNvIconTextButtonByName("Add Child");
    timeBoundedScriptsCreateEditPage
        .createAndReleaseTimeBoundedScript(parentScript, script, verifyDraftParams);
  }

  public void verifyTimeBoundedScriptIsCreatedAndReleased(Script parentScript, Script script) {
    waitUntilPageLoaded(String.format("pricing-scripts-v2/%s/time-bounded", parentScript.getId()));
    String actualParentScriptName = getText(
        "//h4[text()='Script Information']/following-sibling::div/div/label[text()='Name']/following-sibling::span");

    String actualChildScriptName1 = getTextOnTable(1, COLUMN_CLASS_DATA_NAME_ON_TABLE);
    String actualChildScriptStatus1 = getTextOnTable(1, COLUMN_CLASS_DATA_STATUS_ON_TABLE);
    String actualChildScriptDuration1 = getTextOnTable(1, COLUMN_CLASS_DATA_DURATION_ON_TABLE);

    String startDate = DTF_NORMAL_DATE.format(
        ZonedDateTime.ofInstant(script.getVersionEffectiveStartDate().toInstant(),
            ZoneId.systemDefault()));
    String endDate = DTF_NORMAL_DATE.format(
        ZonedDateTime.ofInstant(script.getVersionEffectiveStartDate().toInstant(),
            ZoneId.systemDefault()));
    String expectedDuration = startDate + " - " + endDate;

   Assertions.assertThat(actualParentScriptName).as("Parent Script Name").isEqualTo(parentScript.getName());
   Assertions.assertThat(actualChildScriptName1).as("Child Script Name 1").isEqualTo(script.getName());
   Assertions.assertThat(actualChildScriptStatus1).as("Child Script Status 1").isEqualTo("Active");
   Assertions.assertThat(actualChildScriptDuration1).as("Child Script Status 1").isEqualTo(expectedDuration);
    cancelManageTimeBoundedScripts();
  }

  public void deleteTimeBoundedScript(Script parentScript, Script script) {
    waitUntilPageLoaded(String.format("pricing-scripts-v2/%s/time-bounded", parentScript.getId()));
    goToEditTimeBoundedScript(script);
    timeBoundedScriptsCreateEditPage.deleteScript(script);
    cancelManageTimeBoundedScripts();
  }

  public void verifyTimeBoundedScriptIsDeleted(Script parentScript, Script script) {
    waitUntilPageLoaded(String.format("pricing-scripts-v2/%s/time-bounded", parentScript.getId()));
    goToEditTimeBoundedScript(script);
    timeBoundedScriptsCreateEditPage.verifyScriptIsDeleted(script);
    cancelManageTimeBoundedScripts();
  }

  public void goToEditTimeBoundedScript(Script script) {
    clickf(
        "//td[text()='%s']/following-sibling::td[contains(@class, 'act')]/div/nv-icon-button[@name='commons.edit']",
        script.getName());
  }

  public void cancelManageTimeBoundedScripts() {
    clickNvIconTextButtonByName("commons.cancel");
  }

  public String getTextOnTable(int rowNumber, String columnDataClass) {
    return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT_TABLE);
  }

  public void waitUntilPageLoaded(String expectedUrlEndsWith) {
    super.waitUntilPageLoaded();

    waitUntil(() ->
        {
          String currentUrl = getCurrentUrl();
          LOGGER.debug(
              "TimeBoundedScriptsPage.waitUntilPageLoaded: Current URL = [{}] - Expected URL contains = [{}]",
              currentUrl, expectedUrlEndsWith);
          return currentUrl.endsWith(expectedUrlEndsWith);
        }, TestConstants.SELENIUM_WEB_DRIVER_WAIT_TIMEOUT_IN_MILLISECONDS,
        String.format("Current URL does not contain '%s'.", expectedUrlEndsWith));
  }
}
