package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.StandardSteps;
import co.nvqa.commons.utils.StandardScenarioStorage;
import com.google.inject.Inject;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ApiShipperExtSteps extends StandardSteps<ScenarioManager>
{
    @Inject
    public ApiShipperExtSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
    }
}
