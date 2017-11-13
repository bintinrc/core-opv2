package co.nvqa.operator_v2.cucumber.glue;

import com.google.inject.Inject;
import cucumber.api.java.en.Given;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class SampleSteps extends AbstractSteps
{
    @Inject
    public SampleSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
    }

    @Given("^dummy \"([^\"]*)\"$")
    public void dummyStep(String dummy)
    {
        String scenarioName = getScenarioManager().getCurrentScenario().getName();

        if("failed".equalsIgnoreCase(dummy))
        {
            throw new RuntimeException("Dummy failed on scenario: "+scenarioName);
        }
        else
        {
            System.out.println("[INFO] Dummy success on scenario: "+scenarioName);
        }
    }
}
