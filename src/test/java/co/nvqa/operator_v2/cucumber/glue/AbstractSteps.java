package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.StandardSteps;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.util.ScenarioStorageKeys;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public abstract class AbstractSteps extends StandardSteps<ScenarioManager> implements ScenarioStorageKeys
{
    public AbstractSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    public abstract void init();

    public void takesScreenshot()
    {
        final byte[] screenshot = ((TakesScreenshot) getWebDriver()).getScreenshotAs(OutputType.BYTES);
        getScenarioManager().getCurrentScenario().embed(screenshot, "image/png");
    }

    public void reloadPage()
    {
        getScenarioManager().getWebDriver().navigate().refresh();
    }

    public void writeToCurrentScenarioLog(String message)
    {
        getScenarioManager().writeToCurrentScenarioLog(message);
    }

    public WebDriver getWebDriver()
    {
        return getScenarioManager().getWebDriver();
    }
}
