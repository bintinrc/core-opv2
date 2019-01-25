package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common_selenium.cucumber.glue.CommonSeleniumAbstractSteps;
import co.nvqa.commons.utils.ScenarioStorage;
import co.nvqa.operator_v2.util.ScenarioStorageKeys;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public abstract class AbstractSteps extends CommonSeleniumAbstractSteps<ScenarioManager> implements ScenarioStorageKeys
{
    public AbstractSteps()
    {
    }

    public AbstractSteps(ScenarioManager scenarioManager, ScenarioStorage scenarioStorage)
    {
        super();
    }
}
