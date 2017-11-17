package co.nvqa.operator_v2.cucumber.glue;

import com.google.inject.Inject;
import com.nv.qa.utils.NvLogger;
import cucumber.api.java.en.Given;

import java.util.Random;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class SampleSteps extends AbstractSteps
{
    private static final Random random = new Random();

    @Inject
    public SampleSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
    }

    @Given("^dummy step$")
    public void dummyStep()
    {
        String scenarioName = getScenarioManager().getCurrentScenario().getName();
        boolean randomSuccess = random.nextBoolean();

        if(randomSuccess)
        {
            NvLogger.info("Dummy success on scenario: "+scenarioName);
        }
        else
        {
            throw new RuntimeException("Dummy failed on scenario: "+scenarioName);
        }
    }
}
