package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.ui.cucumber.glue.CommonUiScenarioManager;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.operator_v2.cucumber.ScenarioStorageKeys;
import co.nvqa.operator_v2.selenium.page.OperatorV2SimplePage;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.java.After;
import io.cucumber.java.Before;

import java.io.File;
import java.util.Optional;
import java.util.stream.Stream;
import javax.inject.Singleton;

import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@Singleton
public class ScenarioManager extends CommonUiScenarioManager {

    private static final Logger LOGGER = LoggerFactory.getLogger(ScenarioManager.class);

    public ScenarioManager() {
    }

    @After("@ResetWindow")
    public void resetWindow() {
        LOGGER.info("Reset window.");

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
            LOGGER.warn("Failed to 'Reset Window'. Cause: {}", th.getMessage());
        }
    }

    @After("@CloseNewWindows")
    public void closeNewWindows() {
        LOGGER.info("Close new windows.");

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
            LOGGER.warn("Failed to 'Close new windows'.", th);
        }
    }

    @After("@CleanDownloadFolder")
    public void cleanDownloadFolder() {
        File parentDir = new File(StandardTestConstants.TEMP_DIR);
        Optional<File> optionalFile = Optional.of(parentDir);
        optionalFile.flatMap(dir -> Optional.ofNullable(dir.listFiles()))
                .ifPresent(files -> Stream.of(files).forEach(File::delete));
    }
}
