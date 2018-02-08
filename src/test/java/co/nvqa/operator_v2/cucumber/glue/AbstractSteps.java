package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common_selenium.cucumber.glue.CommonSeleniumAbstractSteps;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.util.ScenarioStorageKeys;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public abstract class AbstractSteps extends CommonSeleniumAbstractSteps<ScenarioManager> implements ScenarioStorageKeys
{
    public AbstractSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }
}
