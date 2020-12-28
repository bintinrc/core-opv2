package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common_selenium.cucumber.glue.CommonSeleniumScenarioManager;
import co.nvqa.commons.cucumber.StandardScenarioStorageKeys;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.cucumber.ScenarioStorageKeys;
import co.nvqa.operator_v2.selenium.page.OperatorV2SimplePage;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import javax.inject.Singleton;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@Singleton
public class ScenarioManager extends CommonSeleniumScenarioManager {

  public ScenarioManager() {
  }

  /**
   * Inject credential info each time the scenario is running.
   */
  @Before
  public void before() {
    put(StandardScenarioStorageKeys.KEY_SHIPPER_V2_CLIENT_ID, TestConstants.SHIPPER_V2_CLIENT_ID);
    put(StandardScenarioStorageKeys.KEY_SHIPPER_V2_CLIENT_SECRET,
        TestConstants.SHIPPER_V2_CLIENT_SECRET);

    put(StandardScenarioStorageKeys.KEY_SHIPPER_V4_CLIENT_ID, TestConstants.SHIPPER_V4_CLIENT_ID);
    put(StandardScenarioStorageKeys.KEY_SHIPPER_V4_CLIENT_SECRET,
        TestConstants.SHIPPER_V4_CLIENT_SECRET);

    put(StandardScenarioStorageKeys.KEY_NINJA_DRIVER_USERNAME, TestConstants.NINJA_DRIVER_USERNAME);
    put(StandardScenarioStorageKeys.KEY_NINJA_DRIVER_PASSWORD, TestConstants.NINJA_DRIVER_PASSWORD);
  }

  @After("@ResetWindow")
  public void resetWindow() {
    NvLogger.info("Reset window.");

    try {
      TestUtils.acceptAlertDialogIfAppear(getWebDriver());
      getWebDriver().get(TestConstants.OPERATOR_PORTAL_LOGIN_URL);
      TestUtils.acceptAlertDialogIfAppear(getWebDriver());
      OperatorV2SimplePage operatorV2SimplePage = new OperatorV2SimplePage(getWebDriver());
      String leaveBtnXpath = "//md-dialog[@aria-label='Leaving PageYou have ...']//button[@aria-label='Leave']";
      WebElement webElement = operatorV2SimplePage.findElementByFast(By.xpath(leaveBtnXpath));
      webElement.click();
      operatorV2SimplePage.waitUntilInvisibilityOfToast("sidenav-main-menu");
    } catch (Throwable th) {
      NvLogger.warnf("Failed to 'Reset Window'. Cause: %s", th.getMessage());
    }
  }

  @After("@CloseNewWindows")
  public void closeNewWindows() {
    NvLogger.info("Close new windows.");

    try {
      String mainWindowHandle = getCurrentScenarioStorage()
          .get(ScenarioStorageKeys.KEY_MAIN_WINDOW_HANDLE);

      if (StringUtils.isNotBlank(mainWindowHandle)) {
        getWebDriver().getWindowHandles().forEach(windowHandle ->
        {
          if (!windowHandle.equals(mainWindowHandle)) {
            getWebDriver().switchTo().window(windowHandle).close();
          }
        });
        getWebDriver().switchTo().window(mainWindowHandle).switchTo();
      }
    } catch (Throwable th) {
      NvLogger.warn("Failed to 'Close new windows'.", th);
    }
  }
}
