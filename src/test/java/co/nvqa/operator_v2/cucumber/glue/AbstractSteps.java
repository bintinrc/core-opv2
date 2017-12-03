package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.util.ScenarioStorageKeys;
import com.nv.qa.commons.cucumber.glue.StandardSteps;
import com.nv.qa.commons.utils.StandardScenarioStorage;
import com.nv.qa.commons.utils.StandardTestUtils;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;

import java.util.Map;

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

    public String replaceParam(String data, Map<String,String> mapOfDynamicVariable)
    {
        return StandardTestUtils.replaceParam(data, mapOfDynamicVariable);
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
