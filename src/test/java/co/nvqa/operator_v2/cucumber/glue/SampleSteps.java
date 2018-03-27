package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.NvLogger;
import co.nvqa.commons.utils.StandardScenarioStorage;
import com.google.inject.Inject;
import cucumber.api.java.en.Given;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Random;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class SampleSteps extends AbstractSteps
{
    private static final Random random = new Random();

    @Inject
    public SampleSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
    }

    @Given("^step \"([^\"]*)\"$")
    public void stepSuccessOrFailed(String status)
    {
        String scenarioName = getScenarioManager().getCurrentScenario().getName();
        boolean randomSuccess = random.nextBoolean();

        if("success".equalsIgnoreCase(status))
        {
            System.out.println("[INFO] Step SUCCESS on scenario: "+scenarioName);
        }
        else if("failed".equalsIgnoreCase(status))
        {
            throw new RuntimeException("Step FAILED on scenario: "+scenarioName);
        }
        else
        {
            randomStep();
        }
    }

    @Given("^random step$")
    public void randomStep()
    {
        String scenarioName = getScenarioManager().getCurrentScenario().getName();
        boolean randomSuccess = random.nextBoolean();

        if(randomSuccess)
        {
            NvLogger.info("Step SUCCESS on scenario: "+scenarioName);
        }
        else
        {
            throw new RuntimeException("Step FAILED on scenario: "+scenarioName);
        }
    }
}
